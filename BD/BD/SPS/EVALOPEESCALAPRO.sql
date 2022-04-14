-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EVALOPEESCALAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EVALOPEESCALAPRO`;DELIMITER $$

CREATE PROCEDURE `EVALOPEESCALAPRO`(
-- Store para consultar si una Operacion se Escala o no de Acuerdo al Nivel de Riesgo del Cliente y/o Operacion
    Par_ClienteID			BIGINT(20), 		-- Cliente ID
	Par_InstrumentoID		BIGINT(12),			-- ID del Instrumento a Evaluar; Cuenta, Credito, Solicitud, Inversion, etc
	Par_CuentaAhoID			BIGINT(12),			-- Cuenta de Ahorro Asociada al instrumento
	Par_SucursalID			INT,				-- Sucursal donde se Origna la Operacion
    Par_NombreProc      	VARCHAR(16),		-- Proceso que Origina la Operacion: PROCESCALINTPLD

    Par_Salida          	CHAR(1),
    INOUT	Par_NumErr		INT(11),
    INOUT	Par_ErrMen		VARCHAR(400),
    INOUT	Par_ResultRev	CHAR(1),			-- Resultado de la Revision de la Operacion de Escalamiento

	Par_EmpresaID       	INT(11),			-- Auditoria
    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria
    Aud_NumTransaccion  	BIGINT(20)			-- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Var_EvalCumple		CHAR(1);
	DECLARE	Var_PEPs			CHAR(1);
	DECLARE	Var_ParentescoPEP	CHAR(1);
	DECLARE	Var_Nacionalidad	CHAR(1);
	DECLARE	Var_RieLocalidad	CHAR(1);
	DECLARE	Var_RieActividad	CHAR(1);
	DECLARE	Var_RiesgoPaisNac	CHAR(1);
	DECLARE	Var_RiesgoPaisRes	CHAR(1);
	DECLARE	Var_NumCtasAho		INT;
	DECLARE Var_FecActual 		DATE;
	DECLARE Var_NumOpeInusuales	INT;
	DECLARE Var_NumOpeRelevante	INT;
	DECLARE Var_LimOpeInu		INT;
	DECLARE Var_LimOpeRele		INT;
	DECLARE Var_PorcePuntos 	DECIMAL(12,2);
	DECLARE Var_TotPonderado	DECIMAL(12,2);
	DECLARE Var_PunObtenido		DECIMAL(12,2);
	DECLARE Var_NivelRiesgo		VARCHAR(50);
	DECLARE Var_OrigenRecursos	CHAR(1);
	DECLARE Var_RiesgoProd		CHAR(1);
	DECLARE Var_RiesgoDes		CHAR(1);
	DECLARE Var_NivelRiesgoID	CHAR(1);
	DECLARE	Var_CodigoNivel		INT;
	DECLARE	Var_CodigoMatriz	INT;
	DECLARE	Var_SeEscala		CHAR(1);
	DECLARE Var_TipoPersona		CHAR(1);
	DECLARE Var_TipoMatriz		INT(11);

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Cero			CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE TipoConResRev		INT;
	DECLARE Con_PEPNAcional		INT;
	DECLARE Con_PEPExtranjero	INT;
	DECLARE Con_Localidad		INT;
	DECLARE Con_Actividad		INT;
	DECLARE Con_OriRecursos		INT;
	DECLARE Con_ProdCredito		INT;
	DECLARE Con_DestinoCred		INT;
	DECLARE Con_Inusuales		INT;
	DECLARE Con_Relevantes		INT;
	DECLARE Con_PaisNacimiento	INT(11);
	DECLARE Con_PaisResidencia	INT(11);
	DECLARE Match_SI			CHAR(1);
	DECLARE En_Seguimiento		CHAR(1);
	DECLARE Rec_Terceros		CHAR(1);
	DECLARE Valor_SI			CHAR(1);
	DECLARE Valor_NO			CHAR(1);
	DECLARE	SI_Cumple			CHAR(1);
	DECLARE	NO_Cumple			CHAR(1);
	DECLARE	Cli_Nacional		CHAR(1);
	DECLARE	Cli_Extranjero		CHAR(1);
	DECLARE	Alto_Riesgo			CHAR(1);
	DECLARE	Cue_Activa			CHAR(1);
	DECLARE	Cue_Bloqueada		CHAR(1);
	DECLARE	Cue_Cancelada		CHAR(1);
	DECLARE	Tip_Cliente			CHAR(3);
	DECLARE SalidaNO			CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE PersonaFisica		CHAR(1);
	DECLARE PersonaFisActE		CHAR(1);
	DECLARE PersonaMoral		CHAR(1);

	DECLARE	Pld_ProCuentasAh		VARCHAR(16);
	DECLARE	Pld_ProInversion		VARCHAR(16);
	DECLARE	Pld_ProLinCred			VARCHAR(16);
	DECLARE	Pld_ProCredito			VARCHAR(16);
	DECLARE	Pld_ProSolCred			VARCHAR(16);
	DECLARE	Pld_ProSolFond			VARCHAR(16);
	DECLARE	Pld_ProCredkubo			VARCHAR(16);
	DECLARE MatrizXPuntos		INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;				-- Entero en Cero
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Cadena_Cero			:= '0';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET TipoConResRev       := 3;				-- Tipo de Consulta del Escalamiento

	SET Con_PEPNAcional		:= 1;			-- Concepto: PEP Nacional
	SET Con_PEPExtranjero	:= 2;			-- Concepto: PEP Extranjero
	SET Con_Localidad		:= 3;			-- Concepto: Localidad
	SET Con_Actividad		:= 4;			-- Concepto: Actividad Economica
	SET Con_OriRecursos		:= 5;			-- Concepto: Origen de los Recursos
	SET Con_ProdCredito		:= 6;			-- Concepto: Producto de Credito
	SET Con_DestinoCred		:= 7;			-- Concepto: Destino del Credito
	SET Con_Inusuales		:= 8;			-- Concepto: Numero de Alertas Inusuales
	SET Con_Relevantes		:= 9;			-- Concepto: Numero de Alertas Relevantes
	SET Con_PaisNacimiento	:= 10;			-- Concepto: Pais de Nacimiento
	SET Con_PaisResidencia	:= 11;			-- Concepto: Pais de Residencia
	SET	Match_SI			:= '1';			-- La Validacion si hace 'Match'
	SET	En_Seguimiento		:= 'S';			-- Estatus en Segumiento
	SET	Rec_Terceros		:= 'T';			-- El Origen de los Recursos es de un Tercero

	SET	Valor_SI			:= 'S';			-- Valor SI
	SET	Valor_NO			:= 'N';			-- Valor NO
	SET	SI_Cumple			:= 'S';			-- SI Cumple el Criterio
	SET	NO_Cumple			:= 'N';			-- NO Cumple el Criterio
	SET	Cli_Nacional		:= 'N';			-- Cliente Nacional
	SET	Cli_Extranjero		:= 'E';			-- Cliente Extranjero
	SET	Alto_Riesgo			:= 'A';			-- Nivel de Riesgo Alto

	SET	Cue_Activa			:= 'A';			-- Cuenta Activa
	SET	Cue_Bloqueada		:= 'B';			-- Cuenta Bloqueada
	SET	Cue_Cancelada		:= 'C';			-- Cuenta Cancelada
	SET	Tip_Cliente			:= 'CTE';		-- Tipo de Persona: Cliente
	SET SalidaNO            := 'N'; 		-- El Proceso SI Arroja una Salida
	SET SalidaSI            := 'S';			-- El Proceso NO Arroja una Salida

	-- Valor (ID) de acuerdo a la tabla PROCESCALINTPLD
	SET	Pld_ProCuentasAh	:= 'CTAAHO';			-- Proceso: Cuenta de Ahorro
	SET	Pld_ProInversion	:= 'INVERSION';			-- Proceso: Inversion
	SET	Pld_ProLinCred		:= 'LINEACREDITO'; 		-- Proceso: Linea de Credito
	SET	Pld_ProCredito		:= 'CREDITO'; 			-- Proceso: Credito
	SET	Pld_ProSolCred		:= 'SOLICITUDCREDITO'; 	-- Proceso: Solicitud de Credito
	SET	Pld_ProSolFond		:= 'SOLICITUDFONDEO';	-- Proceso: Solicitud de Fondeo
	SET	Pld_ProCredkubo		:= 'CREDITOXSOLICITU';	-- Proceso: Credito por Solicitud Kubo
	SET PersonaFisica 		:= 'F';     			-- Tipo de persona física
	SET PersonaFisActE	 	:= 'A';     			-- Tipo de persona física con act. empresarial
	SET PersonaMoral		:= 'M';     			-- Tipo de persona moral
	SET MatrizXPuntos		:= 2;					-- Matriz que evalua por puntos

	-- Inicializaciones
	SET Par_ClienteID		:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_CuentaAhoID		:= IFNULL(Par_CuentaAhoID, Entero_Cero);
	SET	Par_ResultRev		:= Cadena_Vacia;
	SET	Par_NumErr			:= Entero_Cero;
	SET	Par_ErrMen			:= Cadena_Vacia;
	SET	Aud_FechaActual		:= NOW();


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET	Par_NumErr := 999;
			SET	Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
			'Disculpe las molestias que esto le ocasiona. Ref: SP-EVALOPEESCALAPRO');
		END;

	-- Consultamos si ya Existe Escalamiento para esta Operacion
	CALL PLDOPEESCALAINTCON(
		Par_InstrumentoID,	Par_NombreProc,	TipoConResRev,		SalidaNO,			Par_NumErr,
		Par_ErrMen,			Par_ResultRev,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

	SET	Par_ResultRev := IFNULL(Par_ResultRev,Cadena_Vacia);

		-- Si no Existe el proceso de Escalamiento Interno lo Creamos
		IF(Par_ResultRev = Cadena_Vacia) THEN
			SET Var_TipoMatriz := (SELECT TipoMatrizPLD FROM PARAMETROSSIS LIMIT 1);
			SET Var_TipoMatriz := IFNULL(Var_TipoMatriz,1);

			IF(Var_TipoMatriz = MatrizXPuntos) THEN /*Evalua por MAtriz x Puntos*/
				SET Var_NivelRiesgo := (SELECT NivelRiesgo FROM CLIENTES WHERE ClienteID = Par_ClienteID);
				SET Var_TipoPersona := (SELECT TipoPersona FROM CLIENTES WHERE ClienteID = Par_ClienteID);
				SET Var_NivelRiesgo := IFNULL(Var_NivelRiesgo,'');

				SET Var_SeEscala := (SELECT Rie.SeEscala
										FROM CATNIVELESRIESGO Rie
										WHERE Rie.TipoPersona = Var_TipoPersona
										AND Rie.NivelRiesgoID = Var_NivelRiesgo
										AND Rie.Estatus='A' LIMIT 1);
				SET Var_SeEscala := IFNULL(Var_SeEscala, Cadena_Vacia);
			  ELSE
				-- ----------------------------------------------------------------------
				-- Revision del Criterio de PEP Nacional
				-- ----------------------------------------------------------------------

				SET Var_EvalCumple := NO_Cumple;

				SELECT Nacion, TipoPersona INTO Var_Nacionalidad, Var_TipoPersona
					FROM CLIENTES Cli
					WHERE Cli.ClienteID = Par_ClienteID;

				SET Var_Nacionalidad := IFNULL(Var_Nacionalidad, Cadena_Vacia);


				SELECT PEPs, ParentescoPEP INTO Var_PEPs, Var_ParentescoPEP
					FROM CONOCIMIENTOCTE
					WHERE ClienteID = Par_ClienteID;

				SET Var_PEPs := IFNULL(Var_PEPs, Cadena_Vacia);
				SET Var_ParentescoPEP := IFNULL(Var_ParentescoPEP, Cadena_Vacia);

				IF(Var_Nacionalidad = Cli_Nacional AND (Var_PEPs = SI_Cumple OR Var_ParentescoPEP = SI_Cumple) ) THEN

					SET Var_EvalCumple = SI_Cumple;

				END IF;

				INSERT INTO PLDEVALUAPROCESODET(
					`OperacionID`,	`ConceptoMatrizID`,	`Cumple`,		`EmpresaID`,	`Usuario`,
					`FechaActual`,	`DireccionIP`,		`ProgramaID`,	`Sucursal`,		`NumTransaccion` ) VALUES (

					Aud_NumTransaccion,	Con_PEPNAcional,	Var_EvalCumple,	Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );

				-- ----------------------------------------------------------------------
				-- Revision del Criterio de PEP Extranjero
				-- ----------------------------------------------------------------------

				SET Var_EvalCumple := NO_Cumple;

				IF(Var_Nacionalidad = Cli_Extranjero AND (Var_PEPs = SI_Cumple OR Var_ParentescoPEP = SI_Cumple) ) THEN

					SET Var_EvalCumple = SI_Cumple;

				END IF;

				INSERT INTO PLDEVALUAPROCESODET(
					`OperacionID`,	`ConceptoMatrizID`,	`Cumple`,		`EmpresaID`,	`Usuario`,
					`FechaActual`,	`DireccionIP`,		`ProgramaID`,	`Sucursal`,		`NumTransaccion` ) VALUES (

					Aud_NumTransaccion,	Con_PEPExtranjero,	Var_EvalCumple,	Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );


				-- ----------------------------------------------------------------------
				-- Revision del Criterio de Localidad
				-- ----------------------------------------------------------------------
				SELECT ClaveRiesgo INTO Var_RieLocalidad
					FROM DIRECCLIENTE Dir,
						 LOCALIDADREPUB Loc
					WHERE Dir.ClienteID = Par_ClienteID
					  AND Dir.Oficial = Valor_SI
					  AND Dir.EstadoID = Loc.EstadoID
					  AND Dir.MunicipioID = Loc.MunicipioID
					  AND Dir.LocalidadID = Loc.LocalidadID
					LIMIT 1;

				SET Var_RieLocalidad := IFNULL(Var_RieLocalidad, Cadena_Vacia);

				SET Var_EvalCumple := NO_Cumple;

				IF(Var_RieLocalidad = Alto_Riesgo) THEN

					SET Var_EvalCumple = SI_Cumple;

				END IF;


				INSERT INTO PLDEVALUAPROCESODET(
					`OperacionID`,	`ConceptoMatrizID`,	`Cumple`,		`EmpresaID`,	`Usuario`,
					`FechaActual`,	`DireccionIP`,		`ProgramaID`,	`Sucursal`,		`NumTransaccion` ) VALUES (

					Aud_NumTransaccion,	Con_Localidad,		Var_EvalCumple,	Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );


				-- ----------------------------------------------------------------------
				-- Revision del Criterio de Actividad Economica
				-- ----------------------------------------------------------------------
				SELECT Act.ClaveRiesgo INTO Var_RieActividad
					FROM CLIENTES Cli,
						 ACTIVIDADESBMX Act
					WHERE Cli.ClienteID = Par_ClienteID
					  AND Cli.ActividadBancoMX = Act.ActividadBMXID;

				SET Var_RieActividad := IFNULL(Var_RieActividad, Cadena_Vacia);

				SET Var_EvalCumple := NO_Cumple;

				IF(Var_RieActividad = Alto_Riesgo) THEN

					SET Var_EvalCumple = SI_Cumple;

				END IF;

	INSERT INTO PLDEVALUAPROCESODET(
		`OperacionID`,	`ConceptoMatrizID`,	`Cumple`,		`EmpresaID`,	`Usuario`,
		`FechaActual`,	`DireccionIP`,		`ProgramaID`,	`Sucursal`,		`NumTransaccion` ) VALUES (

		Aud_NumTransaccion,	Con_Actividad,		Var_EvalCumple,	Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );

	IF(Var_TipoPersona != PersonaMoral)THEN
		/* --------------------------------------------------------------------
		 * ------------ Revision del Criterio Pais de Nacimiento --------------
		 * --------------------------------------------------------------------*/
		SELECT P.ClaveRiesgo INTO Var_RiesgoPaisNac
			FROM CLIENTES C INNER JOIN PAISES P ON(C.LugarNacimiento = P.PaisID)
			WHERE C.ClienteID = Par_ClienteID
				AND C.TipoPersona != PersonaMoral;

		SET Var_RiesgoPaisNac	:= IFNULL(Var_RiesgoPaisNac, Cadena_Vacia);
		SET Var_EvalCumple		:= NO_Cumple;

		IF(Var_RiesgoPaisNac = Alto_Riesgo) THEN
			SET Var_EvalCumple	:= SI_Cumple;
		END IF;

		INSERT INTO PLDEVALUAPROCESODET(
			OperacionID,		ConceptoMatrizID,		Cumple,				EmpresaID,		Usuario,
			FechaActual,		DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion )
		VALUES (
			Aud_NumTransaccion,	Con_PaisNacimiento,		Var_EvalCumple,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
	END IF;

	/* --------------------------------------------------------------------
	 * ------------ Revision del Criterio Pais de Residencia --------------
	 * --------------------------------------------------------------------*/
	SELECT P.ClaveRiesgo INTO Var_RiesgoPaisRes
		FROM CLIENTES C INNER JOIN PAISES P ON(
    		IF(C.TipoPersona != PersonaMoral,C.PaisResidencia,C.PaisConstitucionID) = P.PaisID)
		WHERE C.ClienteID = Par_ClienteID;

	SET Var_RiesgoPaisRes	:= IFNULL(Var_RiesgoPaisRes, Cadena_Vacia);
	SET Var_EvalCumple		:= NO_Cumple;

	IF(Var_RiesgoPaisRes = Alto_Riesgo) THEN
		SET Var_EvalCumple	:= SI_Cumple;
	END IF;

	INSERT INTO PLDEVALUAPROCESODET(
		OperacionID,		ConceptoMatrizID,		Cumple,				EmpresaID,		Usuario,
		FechaActual,		DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion )
	VALUES (
		Aud_NumTransaccion,	Con_PaisResidencia,		Var_EvalCumple,		Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

	-- ----------------------------------------------------------------------
	-- Revision del Criterio de Transaccionalidad
	-- ----------------------------------------------------------------------

	-- Numero de Operaciones Inusuales
	SELECT FechaSistema INTO Var_FecActual
		FROM PARAMETROSSIS
		LIMIT 1;

	-- Verifica si tiene una Cuenta De ahorro Activa
	SELECT COUNT(CuentaAhoID) INTO Var_NumCtasAho
		FROM CUENTASAHO Cue
		WHERE Cue.ClienteID = Par_ClienteID
		  AND Cue.Estatus IN (Cue_Activa, Cue_Bloqueada, Cue_Cancelada);

	SET Var_NumCtasAho := IFNULL(Var_NumCtasAho, Entero_Cero);


	SELECT	LimiteValida INTO Var_LimOpeInu
		FROM CATMATRIZRIESGO
		WHERE ConceptoMatrizID = Con_Inusuales;

	SET Var_LimOpeInu := IFNULL(Var_LimOpeInu, Entero_Cero);

	IF(Var_NumCtasAho != Entero_Cero) THEN

		SELECT COUNT(FechaDeteccion) INTO Var_NumOpeInusuales
			FROM PLDOPEINUSUALES
			WHERE FechaDeteccion BETWEEN DATE_ADD(Var_FecActual, INTERVAL -1 MONTH) AND Var_FecActual
			  AND TipoPersonaSAFI = Tip_Cliente
			  AND ClavePersonaInv = Par_ClienteID;

		SET Var_NumOpeInusuales := IFNULL(Var_NumOpeInusuales, Entero_Cero);

		SET Var_EvalCumple := NO_Cumple;

		IF(Var_NumOpeInusuales >= Var_LimOpeInu) THEN

			SET Var_EvalCumple = SI_Cumple;

		END IF;

		INSERT INTO PLDEVALUAPROCESODET(
			`OperacionID`,	`ConceptoMatrizID`,	`Cumple`,		`EmpresaID`,	`Usuario`,
			`FechaActual`,	`DireccionIP`,		`ProgramaID`,	`Sucursal`,		`NumTransaccion` ) VALUES (

			Aud_NumTransaccion,	Con_Inusuales,		Var_EvalCumple,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );

		-- --------------------------------------------------------------------------------
		-- Numero de Operaciones Relevantes
		-- --------------------------------------------------------------------------------

		SELECT	LimiteValida INTO Var_LimOpeRele
			FROM CATMATRIZRIESGO
			WHERE ConceptoMatrizID = Con_Relevantes;

		SET Var_LimOpeRele := IFNULL(Var_LimOpeRele, Entero_Cero);


		SELECT COUNT(Fecha) INTO Var_NumOpeRelevante
			FROM PLDOPEREELEVANT
			WHERE ClienteID = Par_ClienteID
			  AND Fecha BETWEEN DATE_ADD(Var_FecActual, INTERVAL -1 MONTH) AND Var_FecActual;

		SET Var_NumOpeRelevante := IFNULL(Var_NumOpeRelevante, Entero_Cero);

		SET Var_EvalCumple := NO_Cumple;

		IF(Var_NumOpeRelevante >= Var_LimOpeRele) THEN

			SET Var_EvalCumple = SI_Cumple;

		END IF;

		INSERT INTO PLDEVALUAPROCESODET(
			`OperacionID`,	`ConceptoMatrizID`,	`Cumple`,		`EmpresaID`,	`Usuario`,
			`FechaActual`,	`DireccionIP`,		`ProgramaID`,	`Sucursal`,		`NumTransaccion` ) VALUES (

			Aud_NumTransaccion,	Con_Relevantes,		Var_EvalCumple,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );

	END IF;

	-- Proceso de Apertura de una Cuenta de Ahorro
	IF(Par_CuentaAhoID != Entero_Cero) THEN

		-- Evaluamos el Origen de los Recursos de la Cuenta
		SELECT Con.RecursoProvTer INTO Var_OrigenRecursos
			FROM CONOCIMIENTOCTA Con
			WHERE Con.CuentaAhoID = Par_CuentaAhoID;

		SET Var_OrigenRecursos := IFNULL(Var_OrigenRecursos, Entero_Cero);

		SET Var_EvalCumple := NO_Cumple;

		IF(Var_OrigenRecursos = Rec_Terceros) THEN

			SET Var_EvalCumple = SI_Cumple;

		END IF;

		INSERT INTO PLDEVALUAPROCESODET(
			`OperacionID`,	`ConceptoMatrizID`,	`Cumple`,		`EmpresaID`,	`Usuario`,
			`FechaActual`,	`DireccionIP`,		`ProgramaID`,	`Sucursal`,		`NumTransaccion` ) VALUES (

			Aud_NumTransaccion,	Con_OriRecursos,	Var_EvalCumple,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );


	END IF;

	-- El Proceso es un Alta de Solicitud de Credito o Alta de Credito
	IF(Par_NombreProc IN (Pld_ProCredito, Pld_ProSolCred)) THEN

		IF(Par_NombreProc = Pld_ProCredito) THEN
			SELECT Pro.ClaveRiesgo, Des.ClaveRiesgo INTO Var_RiesgoProd, Var_RiesgoDes
				FROM CREDITOS Cre,
					 PRODUCTOSCREDITO Pro,
					 DESTINOSCREDITO Des
				WHERE Cre.CreditoID = Par_InstrumentoID
				  AND Cre.ProductoCreditoID = Pro.ProducCreditoID
				  AND Cre.DestinoCreID = Des.DestinoCreID;
		ELSE

			SELECT Pro.ClaveRiesgo, Des.ClaveRiesgo INTO Var_RiesgoProd, Var_RiesgoDes
				FROM SOLICITUDCREDITO Cre,
					 PRODUCTOSCREDITO Pro,
					 DESTINOSCREDITO Des
				WHERE Cre.SolicitudCreditoID = Par_InstrumentoID
				  AND Cre.ProductoCreditoID = Pro.ProducCreditoID
				  AND Cre.DestinoCreID = Des.DestinoCreID;


		END IF;

		SET Var_RiesgoProd := IFNULL(Var_RiesgoProd, Cadena_Vacia);
		SET Var_RiesgoDes := IFNULL(Var_RiesgoDes, Cadena_Vacia);

		-- Evaluamos el Riesgo del Producto de Credito
		SET Var_EvalCumple := NO_Cumple;

		IF(Var_RiesgoProd = Alto_Riesgo) THEN

			SET Var_EvalCumple = SI_Cumple;

		END IF;

		INSERT INTO PLDEVALUAPROCESODET(
			`OperacionID`,	`ConceptoMatrizID`,	`Cumple`,		`EmpresaID`,	`Usuario`,
			`FechaActual`,	`DireccionIP`,		`ProgramaID`,	`Sucursal`,		`NumTransaccion` ) VALUES (

			Aud_NumTransaccion,	Con_ProdCredito,	Var_EvalCumple,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );

		-- Evaluamos el Riesgo del Destino de Credito
		SET Var_EvalCumple := NO_Cumple;

		IF(Var_RiesgoDes = Alto_Riesgo) THEN

			SET Var_EvalCumple = SI_Cumple;

		END IF;

		INSERT INTO PLDEVALUAPROCESODET(
			`OperacionID`,	`ConceptoMatrizID`,	`Cumple`,		`EmpresaID`,	`Usuario`,
			`FechaActual`,	`DireccionIP`,		`ProgramaID`,	`Sucursal`,		`NumTransaccion` ) VALUES (

			Aud_NumTransaccion,	Con_DestinoCred,	Var_EvalCumple,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );

	END IF;

	-- ----------------------------------------------------------------------------------------------------------
	-- Obtenemos Puntajes y Ponderados
	-- ----------------------------------------------------------------------------------------------------------

	-- Cliente Nacional
	IF(Var_Nacionalidad = Cli_Nacional) THEN

		SELECT  SUM(Mat.Valor),
				SUM(	CASE WHEN Det.Cumple = SI_Cumple THEN Mat.Valor
						ELSE Entero_Cero
						END
					)
				INTO Var_TotPonderado, Var_PunObtenido
			FROM PLDEVALUAPROCESODET Det,
				 CATMATRIZRIESGO Mat
			WHERE Det.OperacionID = Aud_NumTransaccion
			  AND Det.ConceptoMatrizID = Mat.ConceptoMatrizID
			  AND Mat.ConceptoMatrizID != Con_PEPExtranjero;

	ELSE  -- Cliente Extranjero

		SELECT  SUM(Mat.Valor),
				SUM(	CASE WHEN Det.Cumple = SI_Cumple THEN Mat.Valor
						ELSE Entero_Cero
						END
					)
				INTO Var_TotPonderado, Var_PunObtenido
			FROM PLDEVALUAPROCESODET Det,
				 CATMATRIZRIESGO Mat
			WHERE Det.OperacionID = Aud_NumTransaccion
			  AND Det.ConceptoMatrizID = Mat.ConceptoMatrizID
			  AND Mat.ConceptoMatrizID != Con_PEPNacional;


	END IF;

	SET Var_TotPonderado := IFNULL(Var_TotPonderado, Entero_Cero);
	SET Var_PunObtenido	:= IFNULL(Var_PunObtenido, Entero_Cero);

	IF(Var_TotPonderado != Entero_Cero) THEN
		SET	Var_PorcePuntos := ROUND((Var_PunObtenido / Var_TotPonderado) * 100, 2);
	ELSE
		SET	Var_PorcePuntos := Entero_Cero;
	END IF;

	-- Obtenemos el Codigo de Vigencia o Identificador de la Matriz de Riesgo
	SELECT MAX(Mat.CodigoMatriz) INTO Var_CodigoMatriz
		FROM CATMATRIZRIESGO Mat;

	SET Var_CodigoMatriz := IFNULL(Var_CodigoMatriz, Entero_Cero);

	-- Obtenemos el Codigo de Vigencia o Identificador del Nivel de Riesgo
	-- Asi como en que Nivel de Riesgo cae: Alto, Bajo o Medio
	SELECT Rie.CodigoNiveles, Rie.NivelRiesgoID, Rie.SeEscala INTO
			Var_CodigoNivel, Var_NivelRiesgoID, Var_SeEscala
		FROM CATNIVELESRIESGO Rie
		WHERE Rie.Minimo <= Var_PorcePuntos
		  AND Rie.Maximo >= Var_PorcePuntos
		  AND Rie.TipoPersona = Var_TipoPersona
			AND   Estatus='A'
		LIMIT 1;

	SET Var_CodigoNivel	:= IFNULL(Var_CodigoNivel, Entero_Cero);
	SET Var_NivelRiesgoID := IFNULL(Var_NivelRiesgoID, Cadena_Vacia);
	SET Var_SeEscala  := IFNULL(Var_SeEscala , Cadena_Vacia);

	-- SE ELIMINA SI EXISTE UNA O MAS EVALUACIONES ANTERIORES EN LA TABLA PARA REGISTRAR CON LA PARAMETRIZACIÓN ACTUAL
    DELETE FROM PLDEVALUAPROCESOENC WHERE OperProcID = Par_InstrumentoID
    	AND ClienteID = Par_ClienteID AND TipoProceso = Par_NombreProc;

	INSERT INTO PLDEVALUAPROCESOENC (
		`OperacionID`,		`OperProcID`,		`ClienteID`,	`TipoProceso`,		`PuntajeTotal`,
		`PuntajeObtenido`,	`Porcentaje`,		`NivelRiesgo`,	`FechaEvaluacion`,	`CodigoNiveles`,
		`CodigoMatriz`,		`EmpresaID`,		`Usuario`,		`FechaActual`,		`DireccionIP`,
		`ProgramaID`,		`Sucursal`,			`NumTransaccion` ) VALUES (

		Aud_NumTransaccion,	Par_InstrumentoID,	Par_ClienteID,		Par_NombreProc,		Var_TotPonderado,
		Var_PunObtenido,	Var_PorcePuntos,	Var_NivelRiesgoID,	Var_FecActual,		Var_CodigoNivel,
		Var_CodigoMatriz,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion );

			END IF;# Fin Matriz 1
	-- Verifica si por el Nivel de Riesgo se Escala o no la Operacion
		END IF;
	IF(Var_SeEscala = Valor_SI) THEN
		-- Damos de Alta el Proceso de Escalamiento
		CALL PLDOPEESCALAINTALT (
			Par_InstrumentoID,	Par_NombreProc,		Var_FecActual,		Par_SucursalID,	Par_ClienteID,
			Match_SI,			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Aud_Usuario,		En_Seguimiento,	Entero_Cero,
			Cadena_Vacia,		Cadena_Vacia,		Fecha_Vacia,		SalidaNO,		Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET	Par_NumErr	:= 501;
		SET	Par_ErrMen	:= "Para continuar el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";

	ELSE
		SET	Par_NumErr	:= 502;
		SET	Par_ErrMen	:= "Exito";
	END IF;


	END ManejoErrores;
	-- FIN MANEJO DE EXCEPCIONES ----------------------------------------------------------------------------------------------------IC
	 IF(Par_Salida = SalidaSI) THEN

		SELECT Par_NumErr AS NumErr,
			   Par_ErrMen AS ErrMen,
			   'clienteID' AS control,
			   Par_ClienteID AS consecutivo;
	 END IF;

END TerminaStore$$