-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPARAMSEGOPPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPARAMSEGOPPRO`;
DELIMITER $$


CREATE PROCEDURE `PLDPARAMSEGOPPRO`(
    -- SP DE PROCESO PARA GENERAR EL LISTADO DE OPERACIONES QUE REQUIERAN UN ESCALAMIENTO
    -- SOLO ESTAN CONSIDERADAS LAS OPERACIONES EN EFECTIVO
	Par_FechaDet				DATE, 			-- Fecha de Deteccion
	Par_Salida					CHAR(1),		-- Parametro de Salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de error
	Par_EmpresaID				INT(11),

    /* Parametros de Auditoria */
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),

	Aud_NumTransaccion			BIGINT(20)
			)

TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_TipoPer			CHAR(1);
DECLARE Var_TipoIns			INT(11);
DECLARE Var_NacCli			CHAR(1);
DECLARE Var_MontoIn			DECIMAL(12,2);
DECLARE Var_MonComp			INT(11);
DECLARE Var_FeIniVig		DATETIME;
DECLARE Var_NivSeg			INT(11);
DECLARE Var_FecSiguie		DATE;
DECLARE Var_FechaIniMes		DATE;
DECLARE Var_FechaFiMes		DATE;
DECLARE Var_FecOper 	 	DATE;
DECLARE Var_FecApli	  		DATE;
DECLARE Var_FecActual 		DATETIME;
DECLARE Var_Empresa     	INT;
DECLARE Var_CuentaAhoID		BIGINT(12);

-- DECLARACION DE CONSTANTES
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Uno			INT;
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Constante_SI		CHAR(1);
DECLARE	TipPersFActividad	CHAR(1);
DECLARE	TipPersMoral		CHAR(1);
DECLARE Un_DiaHabil			INT;
DECLARE Es_DiaHabil			CHAR(1);

-- ASIGNACION DE CONSTANTES
SET Entero_Cero			:= 0;		-- ENTERO CERO
SET Decimal_Cero		:= 0.0;		-- DECIMAL CERO
SET Cadena_Vacia		:= '';		-- CADENA VACIA
SET Entero_Uno			:= 1;		-- ENTERO UNO
SET Nat_Cargo			:= 'C';		-- NATURALEZA DE MOVIMIENTO CARGO
SET Nat_Abono			:= 'A';		-- NATURALEZA DE MOVIMIENTO ABONO
SET Constante_SI		:= 'S';		-- CONSTANTE SI
SET TipPersFActividad	:= 'A';		-- TIPO DE PERSONA FISICA CON ACT EMPRESARIAL
SET TipPersMoral		:= 'M';		-- TIPO DE PERSONA MORAL
SET Un_DiaHabil			:= 1;		-- NUMERO DE DIAS HABILES: 1 DIA

SELECT FechaSistema, EmpresaDefault
  INTO Var_FecActual,Var_Empresa
	FROM PARAMETROSSIS;

SET Var_FecOper	   := Var_FecActual;

ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000'
		BEGIN
			SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDPARAMSEGOPPRO');

		END;

	CALL DIASFESTIVOSCAL(
			Var_FecOper,		Entero_Cero,		Var_FecApli,		Es_DiaHabil,	Var_Empresa,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

	CALL DIASFESTIVOSCAL(
			Var_FecOper,		Un_DiaHabil,		Var_FecSiguie,		Es_DiaHabil,	Var_Empresa,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

	SET Var_FechaIniMes	:= DATE_ADD(Par_FechaDet, INTERVAL -Entero_Uno*(DAY(Par_FechaDet))+Entero_Uno DAY);
	SET Var_FechaFiMes	:= (last_day(Par_FechaDet));

	DROP TABLE IF EXISTS `TMP_SEGTOOPER_PASO`;
	DROP TABLE IF EXISTS `TMP_SEGTOOPER_DIARIO`;
	DROP TABLE IF EXISTS `TMP_SEGTOOPER_MENSUAL`;

	-- Tabla temporal que guarda las operaciones de seguimiento diario
	CREATE TEMPORARY TABLE `TMP_SEGTOOPER_DIARIO` (
	  RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	  `FechaDetec` 			DATE,
	  `CuentaAhoID` 		BIGINT(12),
	  `NumeroMov` 			BIGINT(20),
	  `Fecha` 				DATE,
	  `NatMovimiento` 		CHAR(1),
	  `CantidadMov` 		DECIMAL(12,2),
	  `DescripcionMov` 		VARCHAR(150),
	  `ReferenciaMov` 		VARCHAR(50),
	  `TipoMovAhoID` 		CHAR(4),
	  `MonedaID` 			INT(11),
	  `ClienteID` 			INT(11),
	  `TipoPersona` 		CHAR(1),
	  `NacionCliente` 		CHAR(1),
	  `Transaccion` 		BIGINT(20),
	  `EmpresaID` 			INT(11),
	  `Usuario` 			INT(11),
	  `FechaActual` 		DATETIME,
	  `DireccionIP` 		VARCHAR(15),
	  `ProgramaID` 			VARCHAR(50),
	  `Sucursal` 			INT(11),
	  `NumTransaccion` 		BIGINT(20),
	  INDEX(`NumeroMov`)
	);

	-- Tabla temporal de paso que guarda las operaciones de seguimiento al cierre de mes
	CREATE TEMPORARY TABLE `TMP_SEGTOOPER_PASO` (
	  RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	  `FechaDetec` 			DATE,
	  `CuentaAhoID` 		BIGINT(12),
	  `NumeroMov` 			BIGINT(20),
	  `Fecha` 				DATE,
	  `NatMovimiento` 		CHAR(1),
	  `CantidadMov` 		DECIMAL(14,2),
	  `MontoInferior` 		DECIMAL(14,2) DEFAULT 0.0,
	  `DescripcionMov` 		VARCHAR(150),
	  `ReferenciaMov` 		VARCHAR(50),
	  `TipoMovAhoID` 		CHAR(4),
	  `MonedaID` 			INT(11),
	  `ClienteID` 			INT(11),
	  `TipoPersona` 		CHAR(1),
	  `NacionCliente` 		CHAR(1),
	  `Transaccion` 		BIGINT(20),
	  `EmpresaID` 			INT(11),
	  `Usuario` 			INT(11),
	  `FechaActual` 		DATETIME,
	  `DireccionIP` 		VARCHAR(15),
	  `ProgramaID` 			VARCHAR(50),
	  `Sucursal` 			INT(11),
	  `NumTransaccion` 		BIGINT(20),
	  INDEX(`NumeroMov`)
	);

	-- Tabla temporal que guarda las operaciones de seguimiento al cierre de mes
	CREATE TEMPORARY TABLE `TMP_SEGTOOPER_MENSUAL` (
	  RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	  `FechaDetec` 			DATE,
	  `CuentaAhoID` 		BIGINT(12),
	  `NumeroMov` 			BIGINT(20),
	  `Fecha` 				DATE,
	  `NatMovimiento` 		CHAR(1),
	  `CantidadMov` 		DECIMAL(14,2),
	  `MontoInferior` 		DECIMAL(14,2) DEFAULT 0.0,
	  `DescripcionMov` 		VARCHAR(150),
	  `ReferenciaMov` 		VARCHAR(50),
	  `TipoMovAhoID` 		CHAR(4),
	  `MonedaID` 			INT(11),
	  `ClienteID` 			INT(11),
	  `TipoPersona` 		CHAR(1),
	  `NacionCliente` 		CHAR(1),
	  `Transaccion` 		BIGINT(20),
	  `EmpresaID` 			INT(11),
	  `Usuario` 			INT(11),
	  `FechaActual` 		DATETIME,
	  `DireccionIP` 		VARCHAR(15),
	  `ProgramaID` 			VARCHAR(50),
	  `Sucursal` 			INT(11),
	  `NumTransaccion` 		BIGINT(20),
	  INDEX(`NumeroMov`)
	);

	/* SEGUIMIENTO DE OPERACIONES DIARIO */
	INSERT INTO `TMP_SEGTOOPER_DIARIO` (
		FechaDetec,				CuentaAhoID,		NumeroMov,			Fecha,				NatMovimiento,
		CantidadMov,			DescripcionMov,		ReferenciaMov,		TipoMovAhoID,		MonedaID,
		ClienteID,				TipoPersona,		NacionCliente,		EmpresaID,			Usuario,
		FechaActual,			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion,
		Transaccion)
	  SELECT
		Par_FechaDet, 			CM.CuentaAhoID,		CM.NumeroMov,		CM.Fecha, 			CM.NatMovimiento,
		CM.CantidadMov,			CM.DescripcionMov,	CM.ReferenciaMov,	CM.TipoMovAhoID,	CM.MonedaID,
		CA.ClienteID,			CL.TipoPersona,		CL.Nacion,			Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,
		Aud_NumTransaccion
		FROM CUENTASAHOMOV CM,
			CUENTASAHO	CA,
			CLIENTES 	CL,
			TIPOSMOVSAHO TA,
			PARAMETROSEGOPER P
			WHERE CM.CuentaAhoID = CA.CuentaAhoID
				AND CA.ClienteID = CL.ClienteID
				AND TA.TipoMovAhoID = CM.TipoMovAhoID
				AND IF(CL.TipoPersona = TipPersFActividad,TipPersMoral,CL.TipoPersona) = P.TipoPersona
				AND CL.Nacion = P.NacCliente
				AND TA.EsEfectivo = Constante_SI
				AND CM.MonedaID = P.MonedaComp
				AND CM.NatMovimiento = Nat_Abono
				AND CM.Fecha = Par_FechaDet
				AND CM.CantidadMov > IFNULL(P.MontoInferior,Decimal_Cero)
			ORDER BY CA.CuentaAhoID;

	-- SE REGISTRAN LAS OPERACIONES DETECTADAS EN LA TABLA PLDSEGTOOPER
    INSERT INTO `PLDSEGTOOPER` (
		FechaDetec,				CuentaAhoID,		NumeroMov,			Fecha,				NatMovimiento,
		CantidadMov,			DescripcionMov,		ReferenciaMov,		TipoMovAhoID,		MonedaID,
		ClienteID,				TipoPersona,		NacionCliente,		EmpresaID,			Usuario,
		FechaActual,			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion,
		Transaccion)
	  SELECT
		FechaDetec,				CuentaAhoID,		NumeroMov,			Fecha,				NatMovimiento,
		CantidadMov,			DescripcionMov,		ReferenciaMov,		TipoMovAhoID,		MonedaID,
		ClienteID,				TipoPersona,		NacionCliente,		EmpresaID,			Usuario,
		FechaActual,			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion,
		Transaccion
		FROM `TMP_SEGTOOPER_DIARIO`;

	/* SEGUIMIENTO DE OPERACIONES MENSUAL
		cuya cantidad individual no supera lo parametrizado
		pero la sumatoria de estos montos si lo superan */
	IF(MONTH(Var_FecOper) != MONTH(Var_FecSiguie))THEN
		INSERT INTO `TMP_SEGTOOPER_PASO` (
			FechaDetec,				CuentaAhoID,		NumeroMov,			Fecha,				NatMovimiento,
			CantidadMov,			DescripcionMov,		ReferenciaMov,		TipoMovAhoID,		MonedaID,
			ClienteID,				TipoPersona,		NacionCliente,		EmpresaID,			Usuario,
			FechaActual,			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion,
			Transaccion,			MontoInferior)
		  SELECT DISTINCT
			Par_FechaDet,			CM.CuentaAhoID, 	CM.NumeroMov,		CM.Fecha, 			CM.NatMovimiento,
			CM.CantidadMov,			CM.DescripcionMov,	CM.ReferenciaMov,	CM.TipoMovAhoID,	CM.MonedaID,
			CA.ClienteID, 			CL.TipoPersona,		CL.Nacion,			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,
			Entero_Cero,			Decimal_Cero
			FROM CUENTASAHOMOV CM,
				CUENTASAHO	CA,
				CLIENTES 	CL,
				TIPOSMOVSAHO TA,
				PARAMETROSEGOPER P
				WHERE CM.CuentaAhoID = CA.CuentaAhoID
					AND CA.ClienteID = CL.ClienteID
					AND TA.TipoMovAhoID = CM.TipoMovAhoID
					AND IF(CL.TipoPersona = TipPersFActividad,TipPersMoral,CL.TipoPersona) = P.TipoPersona
					AND CL.Nacion = P.NacCliente
					AND TA.EsEfectivo = Constante_SI
					AND CM.MonedaID = P.MonedaComp
					AND CM.NatMovimiento = Nat_Abono
					AND CM.Fecha BETWEEN Var_FechaIniMes AND Par_FechaDet
					AND CM.CantidadMov <= IFNULL(P.MontoInferior,Decimal_Cero)
				ORDER BY CM.CuentaAhoID;

		-- SE REGISTRAN LAS OPERACIONES DETECTADAS EN LA TABLA PLDSEGTOOPER
		INSERT INTO `TMP_SEGTOOPER_MENSUAL` (
			FechaDetec,							CuentaAhoID,			NumeroMov,				Fecha,					NatMovimiento,
			CantidadMov,						DescripcionMov,			ReferenciaMov,			TipoMovAhoID,			MonedaID,
			ClienteID,							TipoPersona,			NacionCliente,			EmpresaID,				Usuario,
			FechaActual,						DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion,
			Transaccion)
		  SELECT
			MAX(SM.FechaDetec),					SM.CuentaAhoID,			MAX(SM.NumeroMov),		MAX(SM.Fecha),			MAX(SM.NatMovimiento),
			SUM(SM.CantidadMov)AcumuladoMes,	MAX(SM.DescripcionMov),	MAX(SM.ReferenciaMov),	MAX(SM.TipoMovAhoID),	MAX(SM.MonedaID),
			MAX(SM.ClienteID),					MAX(SM.TipoPersona),	MAX(SM.NacionCliente),	MAX(SM.EmpresaID),		MAX(SM.Usuario),
			MAX(SM.FechaActual),				MAX(SM.DireccionIP),	MAX(SM.ProgramaID),		MAX(SM.Sucursal),		MAX(SM.NumTransaccion),
			MAX(SM.Transaccion)
			FROM `TMP_SEGTOOPER_PASO` SM
			GROUP BY SM.CuentaAhoID ;

		INSERT INTO `PLDSEGTOOPER` (
			FechaDetec,				CuentaAhoID,		NumeroMov,			Fecha,				NatMovimiento,
			CantidadMov,			DescripcionMov,		ReferenciaMov,		TipoMovAhoID,		MonedaID,
			ClienteID,				TipoPersona,		NacionCliente,		EmpresaID,			Usuario,
			FechaActual,			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion,
			Transaccion)
		  SELECT DISTINCT
			SM.FechaDetec,			SM.CuentaAhoID,		SM.NumeroMov,			SM.Fecha,			SM.NatMovimiento,
			SM.CantidadMov,			SM.DescripcionMov,	SM.ReferenciaMov,		SM.TipoMovAhoID,	SM.MonedaID,
			SM.ClienteID,			SM.TipoPersona,		SM.NacionCliente,		SM.EmpresaID,		SM.Usuario,
			SM.FechaActual,			SM.DireccionIP,		SM.ProgramaID,			SM.Sucursal,		SM.NumTransaccion,
			SM.Transaccion
			FROM `TMP_SEGTOOPER_MENSUAL`SM , PARAMETROSEGOPER P
				 WHERE IF(SM.TipoPersona = TipPersFActividad,TipPersMoral,SM.TipoPersona) = P.TipoPersona
					AND SM.NacionCliente = P.NacCliente
					AND SM.MonedaID = P.MonedaComp
					AND SM.CantidadMov > IFNULL(P.MontoInferior,Decimal_Cero)
            ORDER BY SM.CuentaAhoID;

	END IF;/* FIN SEGUIMIENTO DE OPERACIONES MENSUAL*/

	DROP TABLE IF EXISTS `TMP_SEGTOOPER_PASO`;
	DROP TABLE IF EXISTS `TMP_SEGTOOPER_DIARIO`;
	DROP TABLE IF EXISTS `TMP_SEGTOOPER_MENSUAL`;

	SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Seguimiento de Operaciones PLD Exitoso.');

END ManejoErrores;

IF(Par_Salida = Constante_SI)THEN
    SELECT
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Cadena_Vacia AS control,
        Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$
