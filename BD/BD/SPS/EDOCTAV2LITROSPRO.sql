-- EDOCTAV2LITROSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2LITROSPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2LITROSPRO`(
	-- SP PARA GENERAR INFORMACION DE RESUMEN DE CREDITOS PARA EL ESTADO DE CUENTA BIENESTAR
	Par_Salida							CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr					INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen					VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	Par_EmpresaID 						INT(11),			-- Parametros de auditoria
	Aud_Usuario							INT(11),			-- Parametros de auditoria
	Aud_FechaActual						DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP						VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID						VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal						INT(11), 			-- Parametros de auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Parametros de auditoria
)

TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_FechaCorte				DATE;				-- Variable para la fecha corte
	DECLARE Var_AnioMes					INT(11);			-- Variable para obtener el periodo parametrizado
	DECLARE Var_AnioMesStr				VARCHAR(10);		-- Anio y Mes en formato cadena
	DECLARE Var_FecIniMes				DATE;				-- Fecha de Fin de mes
	DECLARE Var_FecFinMes				DATE;				-- Fecha de Fin de mes
	DECLARE Var_Anio					INT(11);			-- Anio
	DECLARE Var_MesIni					INT(11);			-- Mes Inicio
	DECLARE Var_MesFin					INT(11);			-- Mes Fin
	DECLARE Var_FolioProceso			BIGINT(20);			-- Folio de procesamiento
	DECLARE Var_Control					VARCHAR(50);		-- Variable para control de excepciones

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);			-- Entero Cero
	DECLARE Entero_Uno					INT(1);				-- Entero Uno
	DECLARE Var_EstVigente				CHAR(1);			-- Estatus Vigente
	DECLARE Var_EstVencido				CHAR(1);			-- Estatus Vencido
	DECLARE Var_EstCastigado			CHAR(1);			-- Estatus Castigado
	DECLARE Var_EstPagado				CHAR(1);			-- Estatus Pagado
	DECLARE Var_EstAtrasado				CHAR(1);			-- Estatus Atrasado
	DECLARE Var_EstEliminado			CHAR(1);			-- Estatus Eliminado
	DECLARE Var_LeyendaPagado			VARCHAR(50);		-- Leyenda Pagado
	DECLARE Var_PagoInmediato			VARCHAR(50);		-- Leyenda pago inmediato
	DECLARE Var_SI						CHAR(1);			-- Etiquete Si
	DECLARE Var_DiaUnoDelMes			CHAR(2);			-- Dia Primero del mes
	DECLARE Var_TipoProdCred			INT(11);			-- TipoProducto CREDITO de la tabla EDOCTAV2PRODUCTOS
    DECLARE DireccionIPVacia			VARCHAR(50);

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Entero_Uno						:= 1;				-- Entero Uno
	SET Var_EstVigente					:= 'V';				-- Estatus Credito : VIGENTE
	SET Var_EstVencido					:= 'B';				-- Estatus Credito : VENCIDO
	SET Var_EstCastigado 				:= 'K';				-- Estatus Credito : CASTIGADO
	SET Var_EstPagado 					:= 'P';				-- Estatus Credito : PAGADO
	SET Var_EstAtrasado					:= 'A';				-- Estatus Credito : ATRASADO
	SET Var_EstEliminado				:= 'E';				-- Estatus Credito : ELIMINADO
	SET Var_LeyendaPagado				:= 'PAGADO';		-- Leyenda Pagado
	SET Var_PagoInmediato				:= 'INMEDIATO';		-- Leyenda Pago inmediato
	SET Var_SI							:= 'S';				-- Etiquete Si
	SET Var_DiaUnoDelMes				:= '01';			-- Asignacion de Dia Primero del mes
	SET Var_TipoProdCred				:= 4;				-- 4 = Productos de Credito que deben aparecer en el Estado de Cuenta
    SET DireccionIPVacia				:= "127.0.0.1";
    

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2LITROSPRO');
			SET Var_Control = 'sqlException';
		END;
	-- Se obtiene el periodo con el que se trabajará

	SELECT		MesProceso,		FechaInicio,	FechaFin,		FolioProceso
		INTO	Var_AnioMes,	Var_FecIniMes,	Var_FecFinMes,	Var_FolioProceso
		FROM	EDOCTAV2PARAMS
		LIMIT	Entero_Uno;

        -- SE CREA TABLA TEMPORAL PARA OBTENER LOS CREDITOS DEL CLIENTE YA OBTENIDOS
		DROP TABLE IF EXISTS TMPEDOCTARESUMCREDITOSSIMP;
		CREATE TEMPORARY TABLE TMPEDOCTARESUMCREDITOSSIMP (
			`ClienteID`					INT(11),
			`CreditoID`					BIGINT(12),
			`Producto`					VARCHAR(100),
			`SaldoInsoluto`				DECIMAL(14,2),
			`MontoProximoPago`			DECIMAL(14,2),
			`FechaLeyenda`				VARCHAR(50)
		);

		CREATE INDEX IDX_TMPEDOCTARESUMCREDITOSSIMP_CLIENTE USING BTREE ON TMPEDOCTARESUMCREDITOSSIMP (ClienteID);
		CREATE INDEX IDX_TMPEDOCTARESUMCREDITOSSIMP_CREDITO USING BTREE ON TMPEDOCTARESUMCREDITOSSIMP (CreditoID);

		INSERT INTO TMPEDOCTARESUMCREDITOSSIMP(
												ClienteID,		CreditoID,		Producto,		SaldoInsoluto,		MontoProximoPago,
												FechaLeyenda
		)SELECT
												ClienteID,		CreditoID,		Producto,		SaldoInsoluto,		MontoProximoPago,
												FechaLeyenda
		FROM	EDOCTAV2RESUMCREDITOS;

        DROP TABLE IF EXISTS EDOCTAV2LITROS;
		CREATE TABLE `EDOCTAV2LITROS` (
			`AnioMes`				INT(11),					-- AnioMes
			`CreditoID`				BIGINT(20),					-- simple.CreditoID
			`ClienteID`				INT(11),					-- simple.ClienteID
			`LitrosMeta` 			INT(11),  					-- Litros Consumidos del Vehiculo
			`TotalLitros` 			INT(11),  					-- Total de litros
			`LitConsumidos` 		INT(11), 					-- Consumo total de litros en un periodo
            `CliProcEspecifico` 	INT(11) 					-- Consumo total de litros en un periodo
		);

        INSERT INTO EDOCTAV2LITROS
		SELECT
				Var_AnioMes,						-- AnioMes
				TmpEdoResCred.CreditoID,			-- CreditoID
				TmpEdoResCred.ClienteID,			-- ClienteID
				Entero_Cero,						-- Litros Consumidos del Vehiculo
				Entero_Cero,						-- Total de litros
				Entero_Cero,						-- Consumo total de litros en un periodo
                48
		FROM CREDITOS cred
		INNER JOIN  TMPEDOCTARESUMCREDITOSSIMP TmpEdoResCred  ON TmpEdoResCred.CreditoID = cred.CreditoID
															  AND TmpEdoResCred.ClienteID = cred.ClienteID
		WHERE Estatus IN ('V', 'B', 'K')
		OR (Estatus = 'P'
				AND  FechTerminacion >= Var_FecIniMes
				AND  FechTerminacion <= Var_FecFinMes);


		-- Limpiamos la tabla para posteriormente guardar los litros de los creditos.
		DELETE FROM EDOCTATMPCALCULOLITROS;
		INSERT INTO EDOCTATMPCALCULOLITROS(
			CreditoID,		Meta,								Total,											EmpresaID, 	Usuario,
			FechaActual, 	DireccionIP, 						ProgramaID, 									Sucursal,	NumTransaccion
		)
		SELECT
			INF.CreditoID,	IFNULL(AVG(INF.GNV), Entero_Cero),	IFNULL(SUM(INFWS.LitConsumidos), Entero_Cero), 	Entero_Uno, Entero_Uno,
			Fecha_Vacia,	DireccionIPVacia,					Entero_Uno,										Entero_Uno,	Entero_Uno
		FROM INFOADICIONALCRED AS INF
			INNER JOIN INFOADICIONALCREDWS AS INFWS ON  INFWS.CreditoID = INF.CreditoID
			GROUP BY INF.CreditoID;

		-- Limpiamos la tabla para posteriormente guardar los litros de los creditos.
		DELETE FROM EDOCTATMPLITROSCONSUMIDOS;
		INSERT INTO EDOCTATMPLITROSCONSUMIDOS(
			CreditoID,		Consumidos,										EmpresaID, 	Usuario,	FechaActual,
			DireccionIP, 	ProgramaID, 									Sucursal,	NumTransaccion
		)
		SELECT
			INFWS.CreditoID,	IFNULL(SUM(INFWS.LitConsumidos), Entero_Cero), 	Entero_Uno, Entero_Uno,	Fecha_Vacia,
			DireccionIPVacia,	Entero_Uno,									Entero_Uno,	Entero_Uno
		FROM INFOADICIONALCREDWS AS INFWS
			WHERE INFWS.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
			GROUP BY INFWS.CreditoID;


		/*Actualizamos los LitrosMeta */
		UPDATE EDOCTAV2LITROS Edo, EDOCTATMPCALCULOLITROS CALIT
			SET Edo.LitrosMeta	= CALIT.Meta
		WHERE Edo.CreditoID = CALIT.CreditoID;

		/*Actualizamos los TotalLitros */
		UPDATE EDOCTAV2LITROS Edo, EDOCTATMPCALCULOLITROS CALIT
			SET Edo.TotalLitros	= CALIT.Total
		WHERE Edo.CreditoID = CALIT.CreditoID;

		/*Actualizamos los LitConsumidos */
		UPDATE EDOCTAV2LITROS Edo, EDOCTATMPLITROSCONSUMIDOS LITCON
			SET Edo.LitConsumidos	= LITCON.Consumidos
		WHERE Edo.CreditoID = LITCON.CreditoID;


		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso de extraccion de litros Ejecutado con Exito';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;


	IF (Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;

END TerminaStore$$
