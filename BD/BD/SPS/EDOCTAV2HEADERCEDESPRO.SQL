-- EDOCTAV2HEADERCEDESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2HEADERCEDESPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2HEADERCEDESPRO`(
	Par_Salida              CHAR(1),			-- Indica si el error lo regresa en un select o no
	INOUT Par_NumErr		INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error
	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);		-- Variable de Control
	DECLARE Var_AnioMes			INT(11);			-- el mes proceso
	DECLARE Var_FecIniMes		DATE;
	DECLARE Var_FecFinMes		DATE;
	DECLARE Var_FolioProceso	BIGINT(20);
	DECLARE EstCedeVigente		CHAR(1);
	DECLARE EstCedePagada		CHAR(1);
	DECLARE EstCedeCancelada	CHAR(1);
	DECLARE TipoProdCede		INT(11);
	DECLARE NatCargo  			CHAR(1);
	DECLARE TipoMovISRCede 		INT(11);

	-- Declaracion de Constantes.
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia		DATE;				-- Fecha Vacia
	DECLARE Entero_Cero		INT(11);			-- Entero Cero
	DECLARE Var_SalidaSI	CHAR(1);			-- Salida si
	DECLARE Var_ActFolio	TINYINT UNSIGNED;	-- Actualizacion del folio generado en el estado de cuenta

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET	Var_SalidaSI			:= 'S';				-- Salida si
	SET	Var_ActFolio			:= 1;				-- Actualizacion del folio generado en el estado de cuenta
	SET EstCedeVigente			:= 'N';				-- Estatus de la Cede: Vigente (cargada a cuenta)
	SET EstCedePagada			:= 'P';				-- Estatus de la Cede: Pagada (abonada a cuenta)
	SET EstCedeCancelada		:= 'C';				-- Estatus de la Cede: Cancelada
	SET TipoProdCede			:= 	2;				-- Tipo de Productos de CEDES de la tabla EDOCTAV2PRODUCTOS
	SET NatCargo  				:= 'C';				-- Naturaleza de Cargo
	SET TipoMovISRCede 			:= 505;				-- Tipo de Movimiento de Ahorro de ISR Retenido por PAgo de Cede

	-- Valores por default
	SET Par_EmpresaID		:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario			:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual		:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP		:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID		:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal		:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion	:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2HEADERCEDESPRO');
			SET Var_Control	= 'sqlException';
		END;

		SELECT	MesProceso, 	FechaInicio, 	FechaFin,  		FolioProceso
		INTO	Var_AnioMes,	Var_FecIniMes, Var_FecFinMes, 	Var_FolioProceso
		FROM	EDOCTAV2PARAMS
		LIMIT	1;

		DROP TEMPORARY TABLE IF EXISTS TMP_ISR_COBRADO;
		CREATE TEMPORARY TABLE `TMP_ISR_COBRADO` (
			  `CedeID` INT(11) NOT NULL COMMENT 'CedeID',
			  `MontoISR` DECIMAL(18,2) NOT NULL COMMENT 'Monto de ISR a Retener',
			  PRIMARY KEY (`CedeID`),
			  KEY `IDX_TMP_ISR_COBRADO_01` (`CedeID`)
			) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;


		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTA_SALDOSCEDE;
		CREATE TEMPORARY TABLE `TMPEDOCTA_SALDOSCEDE` (
			  `FechaCorte` date NOT NULL COMMENT 'Fecha de Corte',
			  `CedeID` int(11) NOT NULL COMMENT 'ID del CEDE',
			  `TipoCedeID` int(11) NOT NULL COMMENT 'Tipo de CEDE',
			  `SaldoCapital` decimal(16,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de Capital',
			  `SaldoIntProvision` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de Provision',
			  `Estatus` char(1) NOT NULL COMMENT 'Estatus del CEDE',
			  `TasaFija` decimal(14,4) DEFAULT NULL COMMENT 'tasa fija',
			  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'tasa ISR',
			  `InteresGenerado` decimal(12,2) DEFAULT '0.00' COMMENT 'Interes generado',
			  `InteresRecibir` decimal(12,2) DEFAULT '0.00' COMMENT 'interes a recibr',
			  `InteresRetener` decimal(12,2) DEFAULT '0.00' COMMENT 'interes a retener',
			  `TasaBase` int(11) DEFAULT NULL COMMENT 'Tasa Base',
			  `SobreTasa` decimal(12,4) DEFAULT '0.0000' COMMENT 'Sobre Tasa',
			  PRIMARY KEY (`FechaCorte`,`CedeID`),
			  KEY `IDX_TMPEDOCTA_SALDOSCEDE_01` (`CedeID`),
			  KEY `IDX_TMPEDOCTA_SALDOSCEDE_02` (`TipoCedeID`)
			) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTACEDES;
		CREATE TEMPORARY TABLE `TMPEDOCTACEDES` (
			  CedeID 			INT(11) NOT NULL COMMENT 'id de la tabla',
			  Estatus 			CHAR(1) NOT NULL COMMENT 'Estatus del Cede N =vigente  P =Pagada  C =Cancelada  A =Registrada',
			  FechaLiquida		DATE,
			  TipoCedeID 		INT(11) DEFAULT NULL COMMENT 'Tipo de CEDE',
			  CuentaAhoID 		BIGINT(12) DEFAULT NULL COMMENT 'Cuenta de ahorro',
			  ClienteID 		INT(11) DEFAULT NULL COMMENT 'Cliente ID',
			  FechaInicio 		DATE DEFAULT NULL COMMENT 'Fecha de inicio de la CEDE',
			  FechaVencimiento 	DATE DEFAULT NULL COMMENT 'Fecha de vencimiento',
			  FechaPago 		DATE DEFAULT NULL COMMENT 'Fecha de pago',
			  Monto 			DECIMAL(18,2) DEFAULT NULL COMMENT 'Monto de la CEDE',
			  Plazo 			INT(11) DEFAULT NULL COMMENT 'Plazo de la CEDE',
			  TasaFija 			DECIMAL(14,4) DEFAULT '0.00' COMMENT 'tasa fija',
			  TasaISR 			DECIMAL(12,4) DEFAULT '0.00' COMMENT 'tasa ISR',
			  TasaNeta 			DECIMAL(12,4) DEFAULT '0.00' COMMENT 'tasa Neta',
			  CalculoInteres 	INT(1) DEFAULT NULL COMMENT 'Calculo de interes',
			  TasaBase 			DECIMAL(12,4) DEFAULT '0.00' COMMENT 'tasa base',
			  SobreTasa 		DECIMAL(12,4) DEFAULT '0.00' COMMENT 'sobre tasa',
			  PisoTasa 			DECIMAL(12,4) DEFAULT '0.00' COMMENT 'piso tasa',
			  TechoTasa 		DECIMAL(12,4) DEFAULT '0.00' COMMENT 'techo tasa',
			  InteresGenerado 	DECIMAL(18,2) DEFAULT '0.00' COMMENT 'interes generado',
			  InteresRecibir 	DECIMAL(18,2) DEFAULT '0.00' COMMENT 'interes a recibir',
			  InteresRetener 	DECIMAL(18,2) DEFAULT '0.00' COMMENT 'interes a retener',
			  SaldoProvision 	DECIMAL(18,2) DEFAULT '0.00' COMMENT 'Se Inicializa al Inicio de cada mes',
			  ValorGat 			DECIMAL(12,4) DEFAULT '0.00' COMMENT 'valor del Gat',
			  ValorGatReal 		DECIMAL(12,4) DEFAULT '0.00' COMMENT 'valor del Gat real ',
			  TasaFijaPag 		DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Tasa fija con la que se calculo del devengamiento obtenida de SALDOSCEDES',
			  TasaBasePag 		DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Tasa Base con la que se calculo del devengamiento en caso de usar tasa variable obtenida de SALDOSCEDES',
			  SobreTasaPag 		DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Sobre Tasa con la que se calculo del devengamiento en caso de usar tasa variable obtenida de SALDOSCEDES',
			  SucursalID 		INT(11) DEFAULT NULL COMMENT 'Sucursal del Cede',
			  PRIMARY KEY (CedeID),
			  KEY `TMPEDOCTACEDES_01` (`CedeID`),
			  KEY `TMPEDOCTACEDES_02` (`TipoCedeID`)
			) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

		DELETE FROM EDOCTAV2HEADERCEDES
		WHERE FolioProcesoID = Var_FolioProceso;

		INSERT INTO TMP_ISR_COBRADO
		SELECT ReferenciaMov AS Cede, SUM(CantidadMov) AS MontoISR
		  FROM `HIS-CUENAHOMOV`
		  WHERE Fecha >= Var_FecIniMes
		    AND Fecha <= Var_FecFinMes
		    AND TipoMovAhoID = TipoMovISRCede
		    AND NatMovimiento = NatCargo
		  GROUP BY ReferenciaMov;


		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAFECCORTECEDE;
		CREATE TEMPORARY TABLE TMPEDOCTAFECCORTECEDE
		SELECT CedeID, MAX(FechaCorte) AS FechaCorte
		FROM SALDOSCEDES
		WHERE FechaCorte >= Var_FecIniMes AND FechaCorte <= Var_FecFinMes
		GROUP BY CedeID;

		CREATE INDEX IDX_TMPEDOCTAFECCORTECEDE_01 ON TMPEDOCTAFECCORTECEDE(CedeID);

		INSERT INTO TMPEDOCTA_SALDOSCEDE
		SELECT 	Sal.FechaCorte, 		Sal.CedeID, 	Sal.TipoCedeID, 	Sal.SaldoCapital, 		Sal.SaldoIntProvision,
				Sal.Estatus, 			Sal.TasaFija, 	Sal.TasaISR, 		Sal.InteresGenerado, 	Sal.InteresRecibir,
				Sal.InteresRetener, 	Sal.TasaBase,	Sal.SobreTasa
		FROM SALDOSCEDES Sal
		INNER JOIN TMPEDOCTAFECCORTECEDE Fec ON Sal.CedeID = Fec.CedeID AND  Sal.FechaCorte = Fec.FechaCorte;

		INSERT INTO TMPEDOCTACEDES
		SELECT 	His.CedeID,
				Sal.Estatus,
				IF(Sal.Estatus='P',Sal.FechaCorte,Fecha_Vacia) AS FechaLiquida,
				His.TipoCedeID,
				His.CuentaAhoID,
				His.ClienteID,
				His.FechaInicio,
				His.FechaVencimiento,
				His.FechaPago,
				His.Monto,
				His.Plazo,
				His.TasaFija,
				His.TasaISR,
				His.TasaNeta,
				His.CalculoInteres,
				His.TasaBase,
				His.SobreTasa,
				His.PisoTasa,
				His.TechoTasa,
				His.InteresGenerado,
				His.InteresRecibir,
				Entero_Cero AS InteresRetener,
				His.SaldoProvision,
				His.ValorGat,
				His.ValorGatReal,
				His.SucursalID,
				Sal.TasaFija AS TasaFijaPag,
				IFNULL(Sal.TasaBase, Entero_Cero) AS TasaBasePag,
				IFNULL(Sal.SobreTasa, Entero_Cero) AS SobreTasaPag
		FROM EDOCTAV2DATOSCTE Cli
			INNER JOIN CEDES His ON Cli.ClienteID = His.ClienteID
								  AND His.FechaInicio <= Var_FecFinMes
								  AND ( His.Estatus = EstCedeVigente OR (His.Estatus = EstCedePagada AND His.FechaVencimiento >= Var_FecIniMes AND His.FechaVencimiento <= Var_FecFinMes )
																	OR (His.Estatus = EstCedeCancelada AND His.FechaVenAnt >= Var_FecIniMes AND His.FechaVenAnt <= Var_FecFinMes )
												)
			INNER JOIN TMPEDOCTA_SALDOSCEDE Sal ON Sal.CedeID = His.CedeID
			INNER JOIN EDOCTAV2PRODUCTOS PROD ON His.TipoCedeID = PROD.ProductoID AND PROD.TipoProducto = TipoProdCede
		WHERE Cli.FolioProceso = Var_FolioProceso;

		UPDATE TMPEDOCTACEDES Cede
			INNER JOIN TMP_ISR_COBRADO Isr ON Cede.CedeID = Isr.CedeID
		SET Cede.InteresRetener = Isr.MontoISR;

		INSERT INTO EDOCTAV2HEADERCEDES
		SELECT 	Var_AnioMes,		Ced.SucursalID,			Ced.ClienteID,		Ced.CuentaAhoID,		Ced.CedeID,
				Ced.Estatus,		Ced.FechaLiquida,		Ced.TipoCedeID,		Tip.Descripcion,		Ced.Monto,
				Ced.FechaInicio,	Ced.FechaVencimiento,	Ced.Plazo,			Ced.TasaFija,			Ced.InteresRetener,
				Ced.ValorGat,		Ced.ValorGatReal,		Entero_Cero,		Entero_Cero,			Entero_Cero,
				Var_FolioProceso,	Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
		FROM TMPEDOCTACEDES Ced
		INNER JOIN TIPOSCEDES Tip ON Ced.TipoCedeID = Tip.TipoCedeID;

		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAFECCORTECEDE;
		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTA_SALDOSCEDE;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Encabezado de Cedes Terminado con Exito con Folio: ', Var_FolioProceso);


	END ManejoErrores; -- Fin del bloque manejo de errores

	IF Par_Salida = Var_SalidaSI THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;

END TerminaStore$$
