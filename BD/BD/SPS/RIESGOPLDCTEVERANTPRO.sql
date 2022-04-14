-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOPLDCTEVERANTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RIESGOPLDCTEVERANTPRO`;DELIMITER $$

CREATE PROCEDURE `RIESGOPLDCTEVERANTPRO`(
-- Store para consultar el Nivel de Riesgo Actual de un Cliente
	Par_ClienteID         	BIGINT(11),     -- Cliente ID

	Par_Salida            	CHAR(1),        -- Indica si el SP genera una salida
	INOUT Par_NumErr      	INT,          	-- No. error
	INOUT Par_ErrMen      	VARCHAR(400),   -- Msg Error

	Par_EmpresaID           INT(11),        -- Auditoria
	Aud_Usuario             INT(11),        -- Auditoria
	Aud_FechaActual         DATETIME,       -- Auditoria
	Aud_DireccionIP         VARCHAR(15),    -- Auditoria
	Aud_ProgramaID          VARCHAR(50),    -- Auditoria
	Aud_Sucursal            INT(11),        -- Auditoria
	Aud_NumTransaccion      BIGINT(20)      -- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_EvalCumple			CHAR(1);
	DECLARE Var_PEPs				CHAR(1);
	DECLARE Var_ParentescoPEP   	CHAR(1);
	DECLARE Var_Nacionalidad    	CHAR(1);
	DECLARE Var_RieLocalidad    	CHAR(1);
	DECLARE Var_RieActividad    	CHAR(1);
	DECLARE Var_RiesgoPaisNac		CHAR(1);
	DECLARE Var_RiesgoPaisRes		CHAR(1);
	DECLARE Var_NumCtasAho      	INT;
	DECLARE Var_FecActual       	DATE;
	DECLARE Var_NumOpeInusuales		INT;
	DECLARE Var_NumOpeRelevante		INT;
	DECLARE Var_LimOpeInu       	INT;
	DECLARE Var_LimOpeRele      	INT;
	DECLARE Var_PorcePuntos     	DECIMAL(12,0);
	DECLARE Var_TotPonderado    	DECIMAL(12,0);
	DECLARE VarTotPuntaje       	DECIMAL(12,0);
	DECLARE Var_NivelRiesgo     	VARCHAR(50);
	DECLARE Var_RiesgoCte       	CHAR(1);
	DECLARE Var_TipoPersona			CHAR(1);

	-- Declaracion de Constantes
	DECLARE Entero_Cero         INT;
	DECLARE Cadena_Cero         CHAR(1);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE SalidaSI          	CHAR(1);
	DECLARE Con_PEPNAcional     INT;
	DECLARE Con_PEPExtranjero   INT;
	DECLARE Con_Localidad       INT;
	DECLARE Con_Actividad       INT;
	DECLARE Con_Inusuales       INT;
	DECLARE Con_Relevantes      INT;
	DECLARE Con_PaisNacimiento	INT(11);
	DECLARE Con_PaisResidencia	INT(11);
	DECLARE Valor_SI			CHAR(1);
	DECLARE Valor_NO          	CHAR(1);
	DECLARE SI_Cumple         	CHAR(1);
	DECLARE NO_Cumple         	CHAR(1);
	DECLARE Cli_Nacional        CHAR(1);
	DECLARE Cli_Extranjero      CHAR(1);
	DECLARE Alto_Riesgo         CHAR(1);
	DECLARE Cue_Activa          CHAR(1);
	DECLARE Cue_Bloqueada       CHAR(1);
	DECLARE Cue_Cancelada       CHAR(1);
	DECLARE Tip_Cliente         CHAR(3);

	DECLARE TotalPonderadoID    INT;
	DECLARE TotalPuntajeID      INT;
	DECLARE TotalPorcentajeID   INT;
	DECLARE TotalNivelRiesgoID	INT;

	DECLARE Text_TotPonderado	VARCHAR(50);
	DECLARE Text_TotPuntaje		VARCHAR(50);
	DECLARE Text_TotPorcentaje	VARCHAR(50);
	DECLARE Text_NivelRiesgo    VARCHAR(50);

	DECLARE Riesgo_Bajo			CHAR(1);
	DECLARE Act_RiesgoAlto      INT;
	DECLARE PersonaFisica		CHAR(1);
	DECLARE PersonaFisActE		CHAR(1);
	DECLARE PersonaMoral		CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero         := 0;     	-- Entero en Cero
	SET Cadena_Vacia        := '';      -- Cadena Vacia
	SET Cadena_Cero         := '0';     -- Cadena Vacia
	SET SalidaSI          	:= 'S';     -- Salida SI

	SET Con_PEPNAcional     := 1;     -- Concepto: PEP Nacional
	SET Con_PEPExtranjero   := 2;     -- Concepto: PEP Extranjero
	SET Con_Localidad       := 3;     -- Concepto: Localidad
	SET Con_Actividad       := 4;     -- Concepto: Actividad Economica
	SET Con_Inusuales       := 8;     -- Concepto: Numero de Alertas Inusuales
	SET Con_Relevantes      := 9;     -- Concepto: Numero de Alertas Relevantes
	SET Con_PaisNacimiento	:= 10;	  -- Concepto: Pais de Nacimiento
	SET Con_PaisResidencia	:= 11;	  -- Concepto: Pais de Residencia

	SET Valor_SI          	:= 'S';     -- Valor SI
	SET Valor_NO          	:= 'N';     -- Valor NO
	SET SI_Cumple         	:= 'S';     -- SI Cumple el Criterio
	SET NO_Cumple         	:= 'N';     -- NO Cumple el Criterio
	SET Cli_Nacional        := 'N';     -- Cliente Nacional
	SET Cli_Extranjero      := 'E';     -- Cliente Extranjero
	SET Alto_Riesgo         := 'A';     -- Nivel de Riesgo Alto

	SET Cue_Activa          := 'A';     -- Cuenta Activa
	SET Cue_Bloqueada       := 'B';     -- Cuenta Bloqueada
	SET Cue_Cancelada       := 'C';     -- Cuenta Cancelada
	SET Tip_Cliente         := 'CTE';   -- Tipo de Persona: Cliente

	SET TotalPonderadoID    := 901;     -- Titulo columna totales
	SET TotalPuntajeID      := 902;     -- Titulo columna totales
	SET TotalPorcentajeID   := 903;     -- Titulo columna totales
	SET TotalNivelRiesgoID	:= 904;     -- Titulo columna totales

	SET Text_TotPonderado	:= 'Total Puntaje Que Aplica';  -- Texto de columna de totales
	SET Text_TotPuntaje		:= 'Puntaje Obtenido';      -- Texto de columna de totales
	SET Text_TotPorcentaje	:= 'Porcentaje de Puntos';    -- Texto de columna de totales
	SET Text_NivelRiesgo	:= 'Nivel de Riesgo';     -- Texto de columna de totales

	SET Riesgo_Bajo       	:= 'B';
	SET Act_RiesgoAlto      :=  8;
	SET PersonaFisica 		:= 'F';     -- Tipo de persona física
	SET PersonaFisActE	 	:= 'A';     -- Tipo de persona física con act. empresarial
	SET PersonaMoral		:= 'M';     -- Tipo de persona moral

	-- Inicializaciones
	SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);

	ManejoErrores: BEGIN
	  DECLARE EXIT HANDLER FOR SQLEXCEPTION
		  BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-RIESGOPLDCTEVERANTPRO');
		  END;

	DELETE FROM TMPPLDNIVELRIESGO WHERE NumTransaccion = Aud_NumTransaccion;
	-- ----------------------------------------------------------------------
	-- Revision del Criterio de PEP Nacional
	-- ----------------------------------------------------------------------

	SET Var_EvalCumple := NO_Cumple;

	SELECT Nacion, TipoPersona INTO Var_Nacionalidad, Var_TipoPersona
		FROM CLIENTES Cli
		WHERE Cli.ClienteID = Par_ClienteID;

	SET Var_Nacionalidad	:= IFNULL(Var_Nacionalidad, Cadena_Vacia);
	SET Var_TipoPersona		:= IFNULL(Var_TipoPersona, Cadena_Vacia);

	SELECT PEPs, ParentescoPEP INTO Var_PEPs, Var_ParentescoPEP
		FROM CONOCIMIENTOCTE
		WHERE ClienteID = Par_ClienteID;

	SET Var_PEPs := IFNULL(Var_PEPs, Cadena_Vacia);
	SET Var_ParentescoPEP := IFNULL(Var_ParentescoPEP, Cadena_Vacia);

	IF(Var_Nacionalidad = Cli_Nacional AND (Var_PEPs = SI_Cumple OR Var_ParentescoPEP = SI_Cumple) ) THEN

		SET Var_EvalCumple = SI_Cumple;

	END IF;

	INSERT INTO TMPPLDNIVELRIESGO(
		`ConceptoMatrizID`,		`NumTransaccion`,   `Concepto`,     `Descripcion`,  `PonderadoMatriz`,
		`Limite`,       		`CumpleCriterio`, 	`PuntajeObtenido`)
		SELECT ConceptoMatrizID, Aud_NumTransaccion,Concepto, Descripcion, Valor, LimiteValida, Var_EvalCumple,
				CASE WHEN Var_EvalCumple = SI_Cumple THEN CONVERT(Valor, CHAR)
					 ELSE Cadena_Cero
				END

			FROM CATMATRIZRIESGO
			WHERE ConceptoMatrizID = Con_PEPNAcional;

	-- ----------------------------------------------------------------------
	-- Revision del Criterio de PEP Extranjero
	-- ----------------------------------------------------------------------

	SET Var_EvalCumple := NO_Cumple;

	IF(Var_Nacionalidad = Cli_Extranjero AND (Var_PEPs = SI_Cumple OR Var_ParentescoPEP = SI_Cumple) ) THEN

		SET Var_EvalCumple = SI_Cumple;

	END IF;

	INSERT INTO TMPPLDNIVELRIESGO(
		`ConceptoMatrizID`,		`NumTransaccion`,   `Concepto`,     `Descripcion`,  `PonderadoMatriz`,
		`Limite`,       		`CumpleCriterio`, 	`PuntajeObtenido`)

		SELECT ConceptoMatrizID, Aud_NumTransaccion,Concepto, Descripcion, Valor, LimiteValida, Var_EvalCumple,
				CASE WHEN Var_EvalCumple = SI_Cumple THEN CONVERT(Valor, CHAR)
					 ELSE Cadena_Cero
				END

			FROM CATMATRIZRIESGO
			WHERE ConceptoMatrizID = Con_PEPExtranjero;


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

	INSERT INTO TMPPLDNIVELRIESGO(
		`ConceptoMatrizID`,		`NumTransaccion`,   `Concepto`,     `Descripcion`,  `PonderadoMatriz`,
		`Limite`,       		`CumpleCriterio`, 	`PuntajeObtenido`)

		SELECT  ConceptoMatrizID, Aud_NumTransaccion,Concepto, Descripcion, Valor, LimiteValida, Var_EvalCumple,
				CASE WHEN  Var_EvalCumple = SI_Cumple THEN CONVERT(Valor, CHAR)
					 ELSE Cadena_Cero
				END

			FROM CATMATRIZRIESGO
			WHERE ConceptoMatrizID = Con_Localidad;

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

	INSERT INTO TMPPLDNIVELRIESGO(
		`ConceptoMatrizID`,		`NumTransaccion`,   `Concepto`,     `Descripcion`,  `PonderadoMatriz`,
		`Limite`,       		`CumpleCriterio`, 	`PuntajeObtenido`)

		SELECT ConceptoMatrizID, Aud_NumTransaccion,Concepto, Descripcion, Valor, LimiteValida, Var_EvalCumple,
				CASE WHEN Var_EvalCumple = SI_Cumple THEN CONVERT(Valor, CHAR)
					 ELSE Cadena_Cero
				END

			FROM CATMATRIZRIESGO
			WHERE ConceptoMatrizID = Con_Actividad;

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

		INSERT INTO TMPPLDNIVELRIESGO(
			ConceptoMatrizID,	NumTransaccion,			Concepto, 			Descripcion,  	PonderadoMatriz,
			Limite,				CumpleCriterio,			PuntajeObtenido)
		SELECT
			ConceptoMatrizID, 	Aud_NumTransaccion,		Concepto, 			Descripcion, 	Valor,
			LimiteValida, 		Var_EvalCumple,			IF(Var_EvalCumple = SI_Cumple, CONVERT(Valor, CHAR), Cadena_Cero)
			FROM CATMATRIZRIESGO
			WHERE ConceptoMatrizID = Con_PaisNacimiento;
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

	INSERT INTO TMPPLDNIVELRIESGO(
		ConceptoMatrizID,	NumTransaccion,			Concepto, 			Descripcion,  	PonderadoMatriz,
		Limite,				CumpleCriterio,			PuntajeObtenido)
	SELECT
		ConceptoMatrizID, 	Aud_NumTransaccion,		Concepto, 			Descripcion, 	Valor,
		LimiteValida, 		Var_EvalCumple,			IF(Var_EvalCumple = SI_Cumple, CONVERT(Valor, CHAR), Cadena_Cero)
		FROM CATMATRIZRIESGO
		WHERE ConceptoMatrizID = Con_PaisResidencia;

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


	SELECT  LimiteValida INTO Var_LimOpeInu
		FROM CATMATRIZRIESGO
		WHERE ConceptoMatrizID = Con_Inusuales;

	SET Var_LimOpeInu := IFNULL(Var_LimOpeInu, Entero_Cero);

	IF(Var_NumCtasAho != Entero_Cero) THEN

		SELECT COUNT(FechaDeteccion) INTO Var_NumOpeInusuales
			FROM PLDOPEINUSUALES
			WHERE FechaDeteccion BETWEEN DATE_ADD(Var_FecActual, INTERVAL -1 MONTH)AND Var_FecActual
				AND TipoPersonaSAFI = Tip_Cliente
			 AND ClavePersonaInv = Par_ClienteID;

		SET Var_NumOpeInusuales := IFNULL(Var_NumOpeInusuales, Entero_Cero);

		SET Var_EvalCumple := NO_Cumple;

		IF(Var_NumOpeInusuales >= Var_LimOpeInu) THEN

			SET Var_EvalCumple = SI_Cumple;

		END IF;

	INSERT INTO TMPPLDNIVELRIESGO(
		`ConceptoMatrizID`,		`NumTransaccion`,   `Concepto`,     `Descripcion`,  `PonderadoMatriz`,
		`Limite`,       		`CumpleCriterio`, 	`PuntajeObtenido`)

			SELECT  ConceptoMatrizID, Aud_NumTransaccion,Concepto, Descripcion, Valor, LimiteValida, Var_EvalCumple,
					CASE WHEN Var_EvalCumple = SI_Cumple THEN CONVERT(Valor, CHAR)
						 ELSE Cadena_Cero
					END

				FROM CATMATRIZRIESGO
				WHERE ConceptoMatrizID = Con_Inusuales;

		-- --------------------------------------------------------------------------------
		-- Numero de Operaciones Relevantes
		-- --------------------------------------------------------------------------------

		SELECT  LimiteValida INTO Var_LimOpeRele
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

	INSERT INTO TMPPLDNIVELRIESGO(
		`ConceptoMatrizID`,		`NumTransaccion`,   `Concepto`,     `Descripcion`,  `PonderadoMatriz`,
		`Limite`,       		`CumpleCriterio`, 	`PuntajeObtenido`)

			SELECT ConceptoMatrizID, Aud_NumTransaccion,Concepto, Descripcion, Valor, LimiteValida, Var_EvalCumple,
					CASE WHEN Var_EvalCumple = SI_Cumple THEN CONVERT(Valor, CHAR)
						 ELSE Cadena_Cero
					END

				FROM CATMATRIZRIESGO
				WHERE ConceptoMatrizID = Con_Relevantes;

	END IF;

	-- Obtenemos Puntajes y Ponderados
	-- Cliente Nacional
	IF(Var_Nacionalidad = Cli_Nacional) THEN

		SELECT  SUM(PonderadoMatriz), SUM(CONVERT(PuntajeObtenido,UNSIGNED))INTO Var_TotPonderado, VarTotPuntaje
			FROM TMPPLDNIVELRIESGO
			WHERE ConceptoMatrizID != Con_PEPExtranjero
		AND NumTransaccion = Aud_NumTransaccion;

	ELSE  -- Cliente Extranjero

		SELECT  SUM(PonderadoMatriz), SUM(CONVERT(PuntajeObtenido, UNSIGNED))INTO Var_TotPonderado, VarTotPuntaje
			FROM TMPPLDNIVELRIESGO
			WHERE ConceptoMatrizID != Con_PEPNacional
		AND NumTransaccion = Aud_NumTransaccion;

	END IF;


	SET Var_TotPonderado := IFNULL(Var_TotPonderado, Entero_Cero);
	SET VarTotPuntaje := IFNULL(VarTotPuntaje, Entero_Cero);

	IF(Var_TotPonderado != Entero_Cero) THEN
		SET Var_PorcePuntos := ROUND((VarTotPuntaje / Var_TotPonderado)*100, 0);
	ELSE
		SET Var_PorcePuntos := Entero_Cero;
	END IF;

	INSERT INTO TMPPLDNIVELRIESGO(
		`ConceptoMatrizID`,		`NumTransaccion`,   `Concepto`,     `Descripcion`,  `PonderadoMatriz`,
		`Limite`,       		`CumpleCriterio`, 	`PuntajeObtenido`) VALUES
		-- ID 901
		(TotalPonderadoID, Aud_NumTransaccion,Text_TotPonderado, Text_TotPonderado,Entero_Cero,Entero_Cero,
		 Valor_NO, CONVERT(Var_TotPonderado, CHAR));

	INSERT INTO TMPPLDNIVELRIESGO(
		`ConceptoMatrizID`,		`NumTransaccion`,   `Concepto`,     `Descripcion`,  `PonderadoMatriz`,
		`Limite`,       		`CumpleCriterio`, 	`PuntajeObtenido`) VALUES
		-- ID 902
		(TotalPuntajeID , Aud_NumTransaccion,Text_TotPuntaje , Text_TotPuntaje , Entero_Cero, Entero_Cero,
		Valor_NO, CONVERT(VarTotPuntaje,CHAR));

	INSERT INTO TMPPLDNIVELRIESGO(
		`ConceptoMatrizID`,		`NumTransaccion`,   `Concepto`,     `Descripcion`,  `PonderadoMatriz`,
		`Limite`,       		`CumpleCriterio`, 	`PuntajeObtenido`) VALUES
		-- ID 903
		(TotalPorcentajeID  , Aud_NumTransaccion,Text_TotPorcentaje, Text_TotPorcentaje,Entero_Cero, Entero_Cero,
		Valor_NO, CONVERT(Var_PorcePuntos, CHAR));

	SELECT Descripcion,NivelRiesgoID INTO Var_NivelRiesgo,Var_RiesgoCte
		FROM CATNIVELESRIESGO
		WHERE Minimo <= Var_PorcePuntos
			AND Maximo >= Var_PorcePuntos
			AND TipoPersona = Var_TipoPersona
			AND  Estatus='A';

	SET Var_NivelRiesgo := IFNULL(Var_NivelRiesgo, Cadena_Vacia);
	SET Var_RiesgoCte   := IFNULL(Var_RiesgoCte, Riesgo_Bajo);

	INSERT INTO TMPPLDNIVELRIESGO(
		`ConceptoMatrizID`,		`NumTransaccion`,   `Concepto`,     `Descripcion`,  `PonderadoMatriz`,
		`Limite`,       		`CumpleCriterio`, 	`PuntajeObtenido`) VALUES
		-- ID 904
		(TotalNivelRiesgoID, Aud_NumTransaccion, Text_NivelRiesgo , Text_NivelRiesgo , Entero_Cero,Entero_Cero,
		Valor_NO, Var_NivelRiesgo);

		/*Se actualiza el nivel de riesgo del Cliente*/
	UPDATE CLIENTES SET NivelRiesgo = Var_RiesgoCte
				WHERE ClienteID = Par_ClienteID;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			CASE
				WHEN ConceptoMatrizID = 10 THEN 6
				WHEN ConceptoMatrizID = 11 THEN 7
				WHEN ConceptoMatrizID > 5  AND ConceptoMatrizID < 15 THEN ConceptoMatrizID +2
				ELSE ConceptoMatrizID
			END ConceptoMatrizID,   Concepto,     Descripcion,
			FORMAT(PonderadoMatriz, Entero_Cero) AS PonderadoMatriz,
			FORMAT(Limite, Entero_Cero) AS Limite,
			CumpleCriterio,PuntajeObtenido,Aud_NumTransaccion
		FROM TMPPLDNIVELRIESGO WHERE NumTransaccion = Aud_NumTransaccion
		ORDER BY ConceptoMatrizID;
	END IF;

END TerminaStore$$