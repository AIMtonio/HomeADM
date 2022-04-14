-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMEXEFECLIMESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIMEXEFECLIMESPRO`;DELIMITER $$

CREATE PROCEDURE `LIMEXEFECLIMESPRO`(
# SP para Agrupamiento de Operaciones en Efectivo por Cliente, que rebasen los limites establecidos en PARAMPLDOPEEFEC, segun disposiciones oficiales
	Par_FechaActual		DATE,
    Par_Salida			VARCHAR(1),
    INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),
    /* Parametros Auditoria */
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion	BIGINT(20)
		)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_FechaSis		DATE;
	DECLARE	Var_FechaBatch		DATE;
	DECLARE	Var_FecBitaco 		DATETIME;
	DECLARE	Var_MinutosBit 		INT;
	DECLARE	Var_FecIniMes		DATE;
	DECLARE	Var_FecFinMes		DATE;
	DECLARE Var_LimFisica		DECIMAL(12,2);
	DECLARE Var_LimMoral 		DECIMAL(12,2);
	DECLARE Var_LimMes			DECIMAL(12,2);
	DECLARE	Var_MonedaID		INT(11);
	DECLARE Var_TipoCambio		DECIMAL(14,2);
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_Consecutivo		INT(11);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Entero_Uno		INT;
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE	Pro_AgruOpEfe	INT;
	DECLARE Per_Fisica		CHAR(1);
	DECLARE Nat_Abono		CHAR(1);
	DECLARE Nat_Cargo		CHAR(1);
	DECLARE	DiaUnoDelMes	CHAR(2);
	DECLARE	EstatusVigente	CHAR(1);
	DECLARE	SalidaSi		CHAR(1);

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';				-- Cadena o String Vacio
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero		:= 0;				-- Entero en Cero
	SET	Entero_Uno		:= 0;				-- Entero en Uno
	SET Decimal_Cero	:= 0.0;				-- Decimal en Cero
	SET	Pro_AgruOpEfe 	:= 504;				-- Proceso de Agrupamiento de Operaciones en Efectivo que Rebasan LImites, tabla PROCESOSBATCH
	SET	Per_Fisica		:= 'F';				-- Tipo de Persona: Fisica
	SET Nat_Abono		:= 'A';				-- Naturaleza Abono
	SET Nat_Cargo		:= 'C';				-- Naturaleza Cargo
	SET	DiaUnoDelMes	:= '01';			-- Constante 01 sirve para concatenar la fecha inicio de mes --
	SET	EstatusVigente	:= 'V';				-- Estatus Vigente
	SET	SalidaSi		:= 'S';				-- Salida Si

	-- Inicializacion
	SET	Aud_ProgramaID	:= 'AGRUOPEREFECLIMESPRO';
	SET	Var_FecBitaco	:= NOW();
	SET	Var_Consecutivo	:= Entero_Cero;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-LIMEXEFECLIMESPRO');
				SET Var_Control := 'sqlException' ;
			END;

		SELECT FechaSistema
			INTO Var_FechaSis
				FROM PARAMETROSSIS;

		-- Se evalua si el Proceso ya se ejecuto en la fecha Actual
		SELECT Fecha INTO Var_FechaBatch
			FROM BITACORABATCH
			WHERE Fecha 			= Par_FechaActual
				AND ProcesoBatchID	= Pro_AgruOpEfe;

		SET Var_FechaBatch := IFNULL(Var_FechaBatch, Fecha_Vacia);

		IF Var_FechaBatch != Fecha_Vacia THEN
			LEAVE TerminaStore;
		END IF;

		-- Fecha de Inicio de Mes
		-- Fecha de Fin de Mes
		SET	Var_FecIniMes			:= DATE(CONCAT(CAST(EXTRACT(YEAR FROM Par_FechaActual) AS CHAR),'-',CAST(EXTRACT(MONTH FROM Par_FechaActual) AS CHAR),'-',DiaUnoDelMes ));
		SET	Var_FecFinMes			:= DATE_ADD(Var_FecIniMes,INTERVAL 1 MONTH);
		SET	Var_FecFinMes			:= DATE_ADD(Var_FecFinMes,INTERVAL -1 DAY);


		-- Obtencion de los Montos Limites Mensuales
		SELECT MontoLimEfecF,	MontoLimEfecM,	MontoLimEfecMes,	MontoLimMonedaID
			INTO Var_LimFisica, Var_LimMoral, 	Var_LimMes, 		Var_MonedaID
				FROM PARAMPLDOPEEFEC
					WHERE Estatus = EstatusVigente;

		# Obtener Tipo de Cambio del Dia anterior o la ultima capturada
		SELECT ROUND(TipCamDof, 2)
			INTO Var_TipoCambio
				FROM `HIS-MONEDAS`
					WHERE MonedaID = Var_MonedaID
					ORDER BY FechaActual DESC LIMIT 1;

		# Si no hay Tipo de Cambio de dias anteriores, se obtiene el del dia actual
		IF IFNULL(Var_TipoCambio , Entero_Cero) = Entero_Cero THEN
			SELECT ROUND(TipCamDof, 2)
				INTO Var_TipoCambio
					FROM MONEDAS
						WHERE MonedaID = Var_MonedaID
						ORDER BY FechaActual DESC LIMIT 1;
		END IF;

		# Se convierten los Montos Limites de Reversa, segÃºn el tipo de Cambio de la Moneda a que pertenece
		SET Var_LimFisica := (IFNULL(Var_LimFisica,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));
		SET Var_LimMoral := (IFNULL(Var_LimMoral,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));
		SET Var_LimMes := (IFNULL(Var_LimMes,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));


		-- Tabla Temporal Para Almacenar Clientes que Superan los Limites Mensuales
		-- para AGrupamiento de Operaciones
		DROP TABLE IF EXISTS LIMOPERCLI;

		CREATE TEMPORARY TABLE LIMOPERCLI(
			ClienteID		INT(11),
			Fecha			DATE,
			NatMovimiento	CHAR(1),
			MontoMes		DECIMAL(12,2),
			TipoPersona		CHAR(1),
			LimOrigen		DECIMAL(12,2),
			INDEX(ClienteID)
		);

		#Clientes FISICAS, que rebasan su limite de Operacion
		INSERT INTO LIMOPERCLI
		SELECT 	cli.ClienteID,	max(efe.Fecha),	efe.NatMovimiento,	SUM(efe.CantidadMov) AS MontoMes,	cli.TipoPersona,
				Var_LimFisica
		 FROM EFECTIVOMOVS efe
			INNER JOIN CLIENTES cli ON efe.ClienteID = cli.ClienteID
			WHERE
				 efe.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
					AND cli.TipoPersona = Per_Fisica
					AND efe.NatMovimiento = Nat_Abono
				GROUP BY cli.ClienteID,efe.NatMovimiento, cli.TipoPersona
				HAVING MontoMes > Var_LimFisica AND MontoMes < Var_LimMes;

		#Clientes MORALES, que rebasan su limite de Operacion
		INSERT INTO LIMOPERCLI
		SELECT 	cli.ClienteID,	max(efe.Fecha),	efe.NatMovimiento,	SUM(efe.CantidadMov) AS MontoMes,	cli.TipoPersona,
				Var_LimMoral
		FROM EFECTIVOMOVS efe
			INNER JOIN CLIENTES cli ON efe.ClienteID = cli.ClienteID
			WHERE
				 efe.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
					AND cli.TipoPersona != Per_Fisica
					AND efe.NatMovimiento = Nat_Abono
				GROUP BY cli.ClienteID, efe.NatMovimiento, cli.TipoPersona
				HAVING MontoMes > Var_LimMoral AND MontoMes < Var_LimMes;


		#Clientes MORALES, que rebasan su limite de Operacion
		INSERT INTO LIMOPERCLI
		SELECT 	cli.ClienteID,	max(efe.Fecha),	efe.NatMovimiento,	SUM(efe.CantidadMov) AS MontoMes,	cli.TipoPersona,
				Var_LimMes
		FROM EFECTIVOMOVS efe
			INNER JOIN CLIENTES cli ON efe.ClienteID = cli.ClienteID
			WHERE
					efe.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
					AND efe.NatMovimiento = Nat_Abono
				GROUP BY cli.ClienteID, efe.NatMovimiento, cli.TipoPersona
				HAVING MontoMes > Var_LimMes;

		#Agrupamiento de Operaciones que Rebasan los Montos Limites Mensuales
		INSERT INTO LIMEXEFECLIMES(
			ClienteID,			CuentaAhoID,		NombreCliente,			TipoPersona,		SucursalID,
			Fecha,				SaldoMes,			Cargo,					Abono,				DescripcionOp,
			Transaccion,		LimOrigen,			EmpresaID,				Usuario,			FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,				NumTransaccion)

		SELECT
			efe.ClienteID,		cue.CuentaAhoID,	cli.NombreCompleto,		cli.TipoPersona,	cue.SucursalID,
			lim.Fecha,			lim.MontoMes,		Decimal_Cero,
			CASE WHEN efe.NatMovimiento = Nat_Abono THEN efe.CantidadMov
				ELSE Decimal_Cero
			END AS Abono,
			efe.DescripcionMov,
			efe.NumTransaccion,	lim.LimOrigen,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
			FROM LIMOPERCLI lim
				LEFT JOIN EFECTIVOMOVS efe ON lim.ClienteID = efe.ClienteID
				INNER JOIN CLIENTES cli ON lim.ClienteID = cli.ClienteID
				INNER JOIN CUENTASAHO cue ON efe.CuentasAhoID = cue.CuentaAhoID
			WHERE (efe.Fecha between Var_FecIniMes AND Var_FecFinMes)
				AND efe.NatMovimiento = Nat_Abono AND efe.CantidadMov > Decimal_Cero
			ORDER BY efe.ClienteID, efe.CuentasAhoID;

		DROP TABLE IF EXISTS LIMOPERCLI;

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
				Pro_AgruOpEfe, 		Par_FechaActual, 	Var_MinutosBit,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr = 000;
		SET Par_ErrMen = CONCAT('Proceso Agrupamiento de Operaciones en Efectivo por Cliente Exitoso.');
		SET Var_Control := 'limexEfecCliMesPro' ;

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$