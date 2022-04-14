-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTRIESGOCTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTRIESGOCTEPRO`;
DELIMITER $$


CREATE PROCEDURE `ACTRIESGOCTEPRO`(
-- Store para Actualizar el Nivel de Riesgo Actual de los Clientes
	Par_TipoCliente     	INT,        	-- Aplicar Evaluacion a Clientes: 1- Activos 2.- Inactivos, 3 .- Ambos, excepto inactivos que no permita reingreso
	Par_Salida        		CHAR(1),      	-- Indica si el SP genera una salida
	INOUT Par_NumErr    	INT,        	-- No. error
	INOUT Par_ErrMen    	VARCHAR(400),   -- Msg Error
		/* Parametros de Auditoria */
	Par_EmpresaID         	INT(11),

	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),

	Aud_NumTransaccion  	BIGINT(20)
	)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_EvalCumple    	CHAR(1);
	DECLARE Var_PEPs      		CHAR(1);
	DECLARE Var_ParentescoPEP 	CHAR(1);
	DECLARE Var_Nacionalidad  	CHAR(1);
	DECLARE Var_RieLocalidad  	CHAR(1);

	DECLARE Var_RieActividad  	CHAR(1);
	DECLARE Var_NumCtasAho    	INT(11);
	DECLARE Var_FecActual     	DATE;
	DECLARE Var_FechaEvalMat    	DATE;
	DECLARE Var_ValorPepNac   	SMALLINT;
	DECLARE Var_ValorPepExt   	SMALLINT;

	DECLARE Var_ValorActivi   	SMALLINT;
	DECLARE Var_ValorLocali   	SMALLINT;
	DECLARE Var_ValorOperIn   	SMALLINT;
	DECLARE Var_ValorOperRe   	SMALLINT;
	DECLARE Var_ValorPaisNac   	SMALLINT;
	DECLARE Var_ValorPaisRes   	SMALLINT;
	DECLARE Var_LimOperInus   	SMALLINT;

	DECLARE Var_LimOperRele   		SMALLINT;
	DECLARE Var_TotalPepNac   		SMALLINT;
	DECLARE Var_TotalPepExt   		SMALLINT;
	DECLARE Var_ClienteInst    		INT(11);
	DECLARE Var_CodigoMatriz    		INT(11);
	DECLARE Var_MinutosBit			INT(11);
	DECLARE Var_EvaluacionMatriz		CHAR(1);
	DECLARE Var_FrecuenciaMensual		INT(11);
	DECLARE Var_FechaEvaluacionMatriz	DATE;
	DECLARE Var_FechaBitacora			DATETIME;
	DECLARE Var_TipoMatriz			INT(1);

	-- Declaracion de Constantes
	DECLARE Entero_Cero     	INT(11);
	DECLARE Cadena_Cero     	CHAR(1);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia    	DATE;
	DECLARE SalidaSI      	CHAR(1);
	DECLARE Con_PEPNAcional   INT(11);

	DECLARE Con_PEPExtranjero 	INT(11);
	DECLARE Con_Localidad   		INT(11);
	DECLARE Con_Actividad   		INT(11);
	DECLARE Con_Inusuales   		INT(11);
	DECLARE Con_Relevantes    	INT(11);
	DECLARE Con_PaisNacimiento    INT(11);
	DECLARE Con_PaisResidencia    INT(11);

	DECLARE Valor_SI      	CHAR(1);
	DECLARE Valor_NO      	CHAR(1);
	DECLARE SI_Cumple     	CHAR(1);
	DECLARE NO_Cumple     	CHAR(1);
	DECLARE Cli_Nacional    	CHAR(1);

	DECLARE Cli_Extranjero    CHAR(1);
	DECLARE Alto_Riesgo     	CHAR(1);
	DECLARE Cue_Activa      	CHAR(1);
	DECLARE Cue_Bloqueada   	CHAR(1);
	DECLARE Cue_Cancelada   	CHAR(1);

	DECLARE Tip_Cliente     		CHAR(3);
	DECLARE Var_EstatusCliente  	VARCHAR(6);
	DECLARE Cli_Activo      		CHAR(1);
	DECLARE Cli_Inactivo    		CHAR(1);
	DECLARE EstCancPagado    		CHAR(1);
	DECLARE Riesgo_Bajo     		CHAR(1);

	DECLARE Act_RiesgoAlto    	INT(11);
	DECLARE Riesgo_Medio    		CHAR(1);
	DECLARE Tipo_Activos    		INT(11);
	DECLARE Tipo_Inactivos    	INT(11);
	DECLARE Tipo_Todos      		INT(11);
	DECLARE EvaluacionPeriodica	VARCHAR(16);
	DECLARE Pro_EvalMatrizPLD		INT(11);
	DECLARE PersonaFisica    		CHAR(1);
	DECLARE PersonaFisActE   		CHAR(1);
	DECLARE PersonaMoral   			CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero     		:= 0;     	-- Entero en Cero
	SET Cadena_Vacia    		:= '';      -- Cadena Vacia
	SET Fecha_Vacia    		:= '1900-01-01';-- Fecha Vacia
	SET Cadena_Cero     		:= '0';     -- Cadena Cero
	SET SalidaSI      		:= 'S';     -- Salida SI
	SET Con_PEPNAcional   	:= 1;     	-- Concepto: PEP Nacional

	SET Con_PEPExtranjero 	:= 2;     	-- Concepto: PEP Extranjero
	SET Con_Localidad   		:= 3;     	-- Concepto: Localidad
	SET Con_Actividad   		:= 4;     	-- Concepto: Actividad Economica
	SET Con_Inusuales   		:= 8;     	-- Concepto: Numero de Alertas Inusuales
	SET Con_Relevantes    	:= 9;     	-- Concepto: Numero de Alertas Relevantes
	SET Con_PaisNacimiento   	:= 10;     	-- Concepto: Pais de Nacimiento
	SET Con_PaisResidencia   	:= 11;     	-- Concepto: Pais de Residencia

	SET Valor_SI      		:= 'S';     -- Valor SI
	SET Valor_NO      		:= 'N';     -- Valor NO
	SET SI_Cumple     		:= 'S';     -- SI Cumple el Criterio
	SET NO_Cumple     		:= 'N';     -- NO Cumple el Criterio
	SET Cli_Nacional    		:= 'N';     -- Cliente Nacional

	SET Cli_Extranjero    	:= 'E';     -- Cliente Extranjero
	SET Alto_Riesgo     		:= 'A';     -- Nivel de Riesgo Alto
	SET Cue_Activa      		:= 'A';     -- Cuenta Activa
	SET Cue_Bloqueada   		:= 'B';     -- Cuenta Bloqueada
	SET Cue_Cancelada   		:= 'C';     -- Cuenta Cancelada

	SET Tip_Cliente     		:= 'CTE';   -- Tipo de Persona: Cliente
	SET Riesgo_Bajo     		:= 'B';     -- Tipo Riesgo Bajo
	SET Act_RiesgoAlto  		:=  8;      -- Tipo Actualizacion Riesgo Alto
	SET Riesgo_Medio    		:= 'M';     -- Tipo Riesgo Medio
	SET Tipo_Activos    		:= 1;     	-- Actualizar Clientes Activos

	SET Tipo_Inactivos    	:= 2;     	-- Actualizar Clientes Inactivos
	SET Tipo_Todos      		:= 3;     	-- Actualizar Ambos (Activos e Inactivos)
	SET Cli_Activo      		:= 'A';     -- Cliente Activo
	SET Cli_Inactivo    		:= 'I';     -- Clientes Inactivo
	SET EstCancPagado    		:= 'P';     -- Estatus de cancelación Pagado
	SET EvaluacionPeriodica	:= 'EVALPERIODO';-- Tipo de Procedimiento: Evaluacion Periodica ID de PROCESCALINTPLD
	SET Pro_EvalMatrizPLD		:= 505;		-- Proceso batch 9007 Evaluacion Nivel de Riesgo Matriz PLD
	SET PersonaFisica    		:= 'F';     -- Tipo de persona física
	SET PersonaFisActE    	:= 'A';     -- Tipo de persona física con act. empresarial
	SET PersonaMoral    		:= 'M';     -- Tipo de persona moral

	ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ACTRIESGOCTEPRO.');
			END;
	SET Var_TipoMatriz := (SELECT TipoMatrizPLD FROM PARAMETROSSIS LIMIT 1);
	SET Var_TipoMatriz := IFNULL(Var_TipoMatriz,1);

	-- Se obtiene la fecha de inicio de ejecución para la bitacora batch.
	SET Var_FechaBitacora	:= NOW();
	SET Aud_FechaActual		:= NOW();
	-- Se obtiene la fecha del sistema y el cliente institucional.
	SET Var_FecActual := (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);
	SET Var_ClienteInst := (SELECT ClienteInstitucion FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);
	IF(Var_TipoMatriz = 1) THEN


		-- Se obtiene el código de la matriz por la que se está evaluando.
			SET Var_CodigoMatriz:= (SELECT CodigoMatriz FROM CATMATRIZRIESGO LIMIT 1);

			SET Var_ValorPepNac := (SELECT Valor FROM CATMATRIZRIESGO WHERE ConceptoMatrizID = Con_PEPNAcional);
			SET Var_ValorPepExt := (SELECT Valor FROM CATMATRIZRIESGO WHERE ConceptoMatrizID = Con_PEPExtranjero);
			SET Var_ValorActivi := (SELECT Valor FROM CATMATRIZRIESGO WHERE ConceptoMatrizID = Con_Actividad);
			SET Var_ValorLocali := (SELECT Valor FROM CATMATRIZRIESGO WHERE ConceptoMatrizID = Con_Localidad);

			SET Var_ValorOperRe := (SELECT Valor FROM CATMATRIZRIESGO WHERE ConceptoMatrizID = Con_Relevantes);
			SET Var_LimOperRele := (SELECT LimiteValida FROM CATMATRIZRIESGO WHERE ConceptoMatrizID = Con_Relevantes);

			SET Var_ValorOperIn := (SELECT Valor FROM CATMATRIZRIESGO WHERE ConceptoMatrizID = Con_Inusuales);
			SET Var_LimOperInus := (SELECT LimiteValida FROM CATMATRIZRIESGO WHERE ConceptoMatrizID = Con_Inusuales);

			SET Var_ValorPaisNac := (SELECT Valor FROM CATMATRIZRIESGO WHERE ConceptoMatrizID = Con_PaisNacimiento);
			SET Var_ValorPaisRes := (SELECT Valor FROM CATMATRIZRIESGO WHERE ConceptoMatrizID = Con_PaisResidencia);

		SET Var_TotalPepNac := (IFNULL(Var_ValorPepNac,Entero_Cero) +
								IFNULL(Var_ValorActivi,Entero_Cero) +
								IFNULL(Var_ValorLocali,Entero_Cero) +
								IFNULL(Var_ValorOperRe,Entero_Cero) +
								IFNULL(Var_ValorOperIn,Entero_Cero) +
								IFNULL(Var_ValorPaisNac,Entero_Cero) +
								IFNULL(Var_ValorPaisRes,Entero_Cero));

		SET Var_TotalPepExt := (IFNULL(Var_ValorPepExt,Entero_Cero) +
								IFNULL(Var_ValorActivi,Entero_Cero) +
								IFNULL(Var_ValorLocali,Entero_Cero) +
								IFNULL(Var_ValorOperRe,Entero_Cero) +
								IFNULL(Var_ValorOperIn,Entero_Cero) +
								IFNULL(Var_ValorPaisNac,Entero_Cero) +
								IFNULL(Var_ValorPaisRes,Entero_Cero));

		-- Se obtiene la fecha de la última evaluación de la matriz.
		SET Var_FechaEvalMat := (SELECT MAX(FechaEvaluacionMatriz) FROM HISEVALUACTEMATRIZ);
		SET Var_FechaEvalMat := IFNULL(Var_FechaEvalMat, Fecha_Vacia);

		-- alta de histórico evaluacion matriz
		CALL HISEVALUACTEMATRIZALT(
			Valor_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(IFNULL(Par_NumErr, Entero_Cero) != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

			IF(Par_TipoCliente = Tipo_Activos) THEN
				SET Var_EstatusCliente = Cli_Activo;
			END IF;

			IF(Par_TipoCliente = Tipo_Inactivos) THEN
				SET Var_EstatusCliente = Cli_Inactivo;
			END IF;

			IF(Par_TipoCliente = Tipo_Todos OR Par_TipoCliente = 4) THEN
				SET Var_EstatusCliente = CONCAT(Cli_Activo,',',Cli_Inactivo);
			END IF;

			SET Var_EstatusCliente := IFNULL(Var_EstatusCliente,Cli_Activo);

		/* Se guardan los clientes que fueron cancelados tomándose la cancelación más reciente
		* y cuyo estatus sea pagado. */
		DROP TABLE IF EXISTS TMPCLIENTESCANCELA;
		CREATE TABLE IF NOT EXISTS TMPCLIENTESCANCELA (
			`RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			ClienteID				BIGINT(20),
			PermiteReactivacion		CHAR(1),
			FechaCancelacion		DATETIME,
			INDEX(ClienteID)
		);

		INSERT INTO TMPCLIENTESCANCELA(
			ClienteID,			PermiteReactivacion,						FechaCancelacion)
		SELECT Can.ClienteID,	IFNULL(Mot.PermiteReactivacion,Valor_SI),	MAX(Can.FechaActual)
			FROM CLIENTESCANCELA Can
			INNER JOIN MOTIVACTIVACION Mot ON (Can.MotivoActivaID = Mot.MotivoActivaID)
			WHERE Can.Estatus = EstCancPagado
			GROUP BY Can.ClienteID, Mot.PermiteReactivacion;

			-- Validar Pep Nacional o Extranjero, y actividad Económica
			INSERT INTO EVALUACIONCTEMATRIZ(
				FechaEvaluacionMatriz,	ClienteID,				Nacionalidad, 		PepNacional,		PepExtr,
				Actividad,				Localidad,				OperInusual,		OperRelevan,		PaisNacimiento,
			PaisResidencia,			PuntajeObt,				Porcentaje,			NivelRiesgo,		PorcentajeAnterior,
			NivelRiesgoAnterior,	PermiteReactivacion,	TipoPersona,		EmpresaID,			Usuario,
			FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
			SELECT Var_FecActual,		Cli.ClienteID,			Cli.Nacion,
					CASE WHEN Cli.Nacion = Cli_Nacional AND (IFNULL(Con.PEPs,Cadena_Vacia) = Valor_SI OR IFNULL(Con.ParentescoPEP,Cadena_Vacia) = Valor_SI) THEN Var_ValorPepNac ELSE Entero_Cero END,
					CASE WHEN Cli.Nacion = Cli_Extranjero AND (IFNULL(Con.PEPs,Cadena_Vacia) = Valor_SI OR IFNULL(Con.ParentescoPEP,Cadena_Vacia) = Valor_SI) THEN Var_ValorPepExt ELSE Entero_Cero END,
					CASE WHEN Act.ClaveRiesgo = Alto_Riesgo THEN Var_ValorActivi ELSE Entero_Cero END,
					Entero_Cero, 			Entero_Cero, 			Entero_Cero,		Entero_Cero,		Entero_Cero,
					Entero_Cero,			Entero_Cero,			Cadena_Vacia,		His.Porcentaje,		Cli.NivelRiesgo,
					IFNULL(Can.PermiteReactivacion,Valor_SI),		Cli.TipoPersona,	Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES Cli INNER JOIN ACTIVIDADESBMX Act ON (Cli.ActividadBancoMX = Act.ActividadBMXID)
				LEFT OUTER JOIN TMPCLIENTESCANCELA Can ON (Cli.ClienteID = Can.ClienteID AND Cli.Estatus = Cli_Inactivo)
				LEFT OUTER JOIN CONOCIMIENTOCTE Con ON (Cli.ClienteID = Con.ClienteID)
				LEFT OUTER JOIN HISEVALUACTEMATRIZ His ON (Cli.ClienteID = His.ClienteID AND His.FechaEvaluacionMatriz=Var_FechaEvalMat)
				WHERE FIND_IN_SET(Cli.Estatus,Var_EstatusCliente) > Entero_Cero;

		-- SE ELIMINAN LOS INACTIVOS QUE NO PERMITEN REACTIVACIÓN Y AL CLIENTE INSTITUCIONAL
		DELETE FROM EVALUACIONCTEMATRIZ
			WHERE ClienteID = Var_ClienteInst
				OR PermiteReactivacion = Valor_NO;

			-- Validar si la localidad es de Alto Riesgo
			DROP TABLE IF EXISTS TMPLOCALIDADESRIESGO;
			CREATE TEMPORARY TABLE TMPLOCALIDADESRIESGO
			SELECT Dir.ClienteID,Loc.ClaveRiesgo
					FROM DIRECCLIENTE Dir,
						 LOCALIDADREPUB Loc,
									 CLIENTES Cli
					WHERE Cli.ClienteID = Dir.ClienteID
					 AND Dir.Oficial = Valor_SI
						AND Dir.EstadoID = Loc.EstadoID
						AND Dir.MunicipioID = Loc.MunicipioID
						AND Dir.LocalidadID = Loc.LocalidadID;


			ALTER TABLE `TMPLOCALIDADESRIESGO`
				ADD COLUMN `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;


			CREATE INDEX idx_TMPLOCALIDADESRIESGO_1 ON TMPLOCALIDADESRIESGO(ClienteID);
			

			UPDATE EVALUACIONCTEMATRIZ tmp, TMPLOCALIDADESRIESGO loc
				SET tmp.Localidad = CASE WHEN loc.ClaveRiesgo = Alto_Riesgo THEN Var_ValorLocali ELSE Entero_Cero END
				WHERE tmp.ClienteID = loc.ClienteID;

			-- Validar si el País de Nacimiento es de Alto Riesgo
			DROP TABLE IF EXISTS TMPPAISCLIENTEMAT;

			-- Para personas físicas y físicas con act. empresarial
			CREATE TEMPORARY TABLE TMPPAISCLIENTEMAT
			SELECT C.ClienteID, P.ClaveRiesgo
					FROM CLIENTES C INNER JOIN PAISES P ON(C.LugarNacimiento = P.PaisID)
					WHERE C.TipoPersona != PersonaMoral;
					
            ALTER TABLE `TMPPAISCLIENTEMAT`
                ADD COLUMN `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;

			CREATE INDEX idx_TMPPAISCLIENTEMAT_1 ON TMPPAISCLIENTEMAT(ClienteID);

			UPDATE EVALUACIONCTEMATRIZ tmp, TMPPAISCLIENTEMAT P
				SET tmp.PaisNacimiento = IF(P.ClaveRiesgo = Alto_Riesgo, Var_ValorPaisNac, Entero_Cero)
				WHERE tmp.ClienteID = P.ClienteID;

			-- Validar si el País de Residencia es de Alto Riesgo
			TRUNCATE TABLE TMPPAISCLIENTEMAT;

			-- Para personas físicas y físicas con act. empresarial
			INSERT INTO TMPPAISCLIENTEMAT(
				ClienteID, ClaveRiesgo)
			SELECT C.ClienteID, P.ClaveRiesgo
					FROM CLIENTES C INNER JOIN PAISES P ON(C.PaisResidencia = P.PaisID)
					WHERE C.TipoPersona != PersonaMoral;

			-- Para personas morales
			INSERT INTO TMPPAISCLIENTEMAT(
				ClienteID, ClaveRiesgo)
			SELECT C.ClienteID, P.ClaveRiesgo
					FROM CLIENTES C INNER JOIN PAISES P ON(C.PaisConstitucionID = P.PaisID)
					WHERE C.TipoPersona = PersonaMoral;

			UPDATE EVALUACIONCTEMATRIZ tmp, TMPPAISCLIENTEMAT P
				SET tmp.PaisResidencia = IF(P.ClaveRiesgo = Alto_Riesgo, Var_ValorPaisRes, Entero_Cero)
				WHERE tmp.ClienteID = P.ClienteID;

			-- Validar Num de Operaciones Inusuales
			DROP TABLE IF EXISTS TMPOPERINUSUALES;
			CREATE TEMPORARY TABLE TMPOPERINUSUALES
			SELECT ClavePersonaInv AS ClienteID, COUNT(FechaDeteccion) AS NumOper
						FROM PLDOPEINUSUALES
						WHERE FechaDeteccion BETWEEN DATE_ADD(Var_FecActual, INTERVAL - 1 MONTH)AND Var_FecActual
							AND TipoPersonaSAFI = Tip_Cliente
						 GROUP BY ClavePersonaInv;

			ALTER TABLE `TMPOPERINUSUALES`
				ADD COLUMN `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;

			CREATE INDEX idx_TMPOPERINUSUALES_1 ON TMPOPERINUSUALES(ClienteID);

			UPDATE EVALUACIONCTEMATRIZ tmp, TMPOPERINUSUALES opr
				SET tmp.OperInusual = CASE WHEN opr.NumOper >=  Var_LimOperInus THEN Var_ValorOperIn ELSE Entero_Cero END
				WHERE tmp.ClienteID = opr.ClienteID;


			-- Validar Num de Operaciones Relevantes
			DROP TABLE IF EXISTS TMPOPERRELEVANT;
			CREATE TEMPORARY TABLE TMPOPERRELEVANT
			SELECT ClienteID,COUNT(Fecha) AS NumOper
						FROM PLDOPEREELEVANT
						WHERE Fecha BETWEEN DATE_ADD(Var_FecActual, INTERVAL - 1 MONTH) AND Var_FecActual
									GROUP BY ClienteID;

			ALTER TABLE `TMPOPERRELEVANT`
				ADD COLUMN `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;

			CREATE INDEX idx_TMPOPERRELEVANT_1 ON TMPOPERRELEVANT(ClienteID);

			UPDATE EVALUACIONCTEMATRIZ tmp, TMPOPERRELEVANT opr
				SET tmp.OperRelevan = CASE WHEN opr.NumOper >=  Var_LimOperRele THEN Var_ValorOperRe ELSE Entero_Cero END
				WHERE tmp.ClienteID = opr.ClienteID;

		/* Actualizar El total de puntaje y porcentaje obtenido.
		* Personas Físicas y Personas Físicas con Act. Empresarial. */
		UPDATE EVALUACIONCTEMATRIZ SET
			PuntajeObt = (Actividad + Localidad + OperInusual + OperRelevan + PepExtr +
							PepNacional + PaisNacimiento + PaisResidencia),
			Porcentaje = ROUND(((Actividad + Localidad + OperInusual + OperRelevan + PepExtr +
							PepNacional + PaisNacimiento + PaisResidencia) /
							(IF(PepExtr > Entero_Cero, Var_TotalPepExt, Var_TotalPepNac)) * 100),2)
			WHERE TipoPersona != PersonaMoral;

		/* Actualizar El total de puntaje y porcentaje obtenido sin ponderar el país de nacimiento.
		* Personas Morales.*/
		UPDATE EVALUACIONCTEMATRIZ SET
			PuntajeObt = (Actividad + Localidad + OperInusual + OperRelevan + PepExtr +
							PepNacional + PaisResidencia),
			Porcentaje = ROUND(((Actividad + Localidad + OperInusual + OperRelevan + PepExtr +
							PepNacional + PaisResidencia) /
							(IF(PepExtr > Entero_Cero, Var_TotalPepExt, Var_TotalPepNac) - PaisNacimiento) * 100),2)
			WHERE TipoPersona = PersonaMoral;

			-- Actualizamos los Bajos
			UPDATE EVALUACIONCTEMATRIZ tmp,CATNIVELESRIESGO cat SET
					tmp.NivelRiesgo = cat.NivelRiesgoID
				 WHERE  tmp.Porcentaje BETWEEN cat.Minimo AND cat.Maximo
				 AND tmp.TipoPersona = cat.TipoPersona
				 AND cat.NivelRiesgoID = Riesgo_Bajo
				 AND Estatus = Cue_Activa;

					-- Actualizamos los Medios
			UPDATE EVALUACIONCTEMATRIZ tmp,CATNIVELESRIESGO cat SET
					tmp.NivelRiesgo = cat.NivelRiesgoID
				 WHERE  tmp.Porcentaje BETWEEN cat.Minimo AND cat.Maximo
				 AND tmp.TipoPersona = cat.TipoPersona
				 AND cat.NivelRiesgoID = Riesgo_Medio
				 AND Estatus = Cue_Activa;

					 -- Actualizamos los Altos
			 UPDATE EVALUACIONCTEMATRIZ tmp,CATNIVELESRIESGO cat SET
					tmp.NivelRiesgo = cat.NivelRiesgoID
				 WHERE  tmp.Porcentaje BETWEEN cat.Minimo AND cat.Maximo
				 AND tmp.TipoPersona = cat.TipoPersona
				 AND cat.NivelRiesgoID = Alto_Riesgo
				 AND Estatus = Cue_Activa;

			-- Actualizar el Nivel de Riesgo de los Clientes
			 UPDATE CLIENTES Cli, EVALUACIONCTEMATRIZ Tmp
				 SET Cli.NivelRiesgo = Tmp.NivelRiesgo
				 WHERE Cli.ClienteID = Tmp.ClienteID;

		-- Se obtiene la fecha de la última evaluación de la matriz periódica.
		SET Var_FechaEvalMat := (SELECT MAX(FechaEvaluacion) FROM PLDEVALUAPROCESOENC WHERE TipoProceso = EvaluacionPeriodica);
		SET Var_FechaEvalMat := IFNULL(Var_FechaEvalMat, Fecha_Vacia);

		-- Se guardan el histórico de la evaluación por Cliente, con el nivel de riesgo anterior.
		INSERT INTO PLDEVALUAPROCESOENC(
			OperacionID,		OperProcID,				ClienteID,				TipoProceso,			PuntajeTotal,
			PuntajeObtenido,	Porcentaje,				NivelRiesgo,			FechaEvaluacion,		CodigoNiveles,
			CodigoMatriz,		PorcentajeAnterior,		NivelRiesgoAnterior,	EmpresaID,				Usuario,
			FechaActual,		DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
		SELECT
			Aud_NumTransaccion,	Entero_Cero,			T.ClienteID,			EvaluacionPeriodica,	(IF(Nacionalidad=Cli_Nacional,Var_TotalPepNac,Var_TotalPepExt) - IF(TipoPersona != PersonaMoral,Entero_Cero,Var_ValorPaisNac)),
			T.PuntajeObt,		IFNULL(T.Porcentaje, Entero_Cero),				T.NivelRiesgo,			Var_FecActual,		Entero_Cero,
			Var_CodigoMatriz,	Entero_Cero,			T.NivelRiesgoAnterior,	Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
		 FROM EVALUACIONCTEMATRIZ AS T;

		UPDATE PLDEVALUAPROCESOENC P INNER JOIN EVALUACIONCTEMATRIZ T ON(P.ClienteID = T.ClienteID)
			SET P.PorcentajeAnterior = IFNULL(T.PorcentajeAnterior, Entero_Cero)
			WHERE P.NumTransaccion = Aud_NumTransaccion
				AND P.TipoProceso = EvaluacionPeriodica;

		-- SE OBTIENE LA FECHA ACTUAL DE LA DE EVALUACION
		SET Var_FechaEvaluacionMatriz	:= (SELECT FechaEvaluacionMatriz FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID LIMIT 1);
		SET Var_EvaluacionMatriz		:= (SELECT EvaluacionMatriz FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID LIMIT 1);
		SET Var_FrecuenciaMensual		:= (SELECT FrecuenciaMensual FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID LIMIT 1);

			/* SE CALCULA LA FECHA EN LA QUE SE REALIZARÁ DE NUEVO LA EVALUCION DEL NIVEL DE RIESGO DE LOS CLIENTES */
		-- SE SUMA A LA FECHA DEL SISTEMA LA FRECUENCIA EN MESES
		SET Var_FechaEvaluacionMatriz	:= DATE_ADD(Var_FecActual, INTERVAL Var_FrecuenciaMensual MONTH);
		-- SE OBTIENE LA ULTIMA FECHA, DE LA FECHA CALCULADA
		SET Var_FechaEvaluacionMatriz	:= LAST_DAY(Var_FechaEvaluacionMatriz);

		-- SE CALCULA UN DIA HÁBIL ANTERIOR A LA FECHA CALCULADA PARA QUE SE EJECUTE JUSTO EN EL CIERRE DE MES PRÓXIMO.
		CALL DIASFESTIVOSCAL(
			Var_FechaEvaluacionMatriz,  (-1),       Var_FechaEvaluacionMatriz,    Valor_SI,     Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,  Aud_DireccionIP,        Aud_ProgramaID,   Aud_Sucursal,
			Aud_NumTransaccion);

		-- SE ACTUALIZA LA NUEVA FECHA DE EVALUACIÓN
		UPDATE PARAMETROSSIS SET
			FechaEvaluacionMatriz = Var_FechaEvaluacionMatriz
		WHERE EmpresaID = Par_EmpresaID;
	  ELSE
	  	IF(Par_TipoCliente = 3) THEN
			CALL PLDNIVELRIESGOPUNTOSMASACT(
				Par_TipoCliente,	'N',							Par_NumErr,				Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,					Aud_NumTransaccion);
		ELSEIF(Par_TipoCliente = 4) THEN
			CALL PLDNIVELRIESGOPUNTOSMASACT(
				Par_TipoCliente,	'N',							Par_NumErr,				Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,					Aud_NumTransaccion);
		END IF;
	END IF;

	/* Si el proceso de evaluación ya ha sido ejecutado, se elimina de la bitácota batch. */
	IF(EXISTS(SELECT ProcesoBatchID FROM BITACORABATCH WHERE ProcesoBatchID = Pro_EvalMatrizPLD AND Fecha = Var_FecActual))THEN
		DELETE FROM BITACORABATCH
			WHERE ProcesoBatchID = Pro_EvalMatrizPLD AND Fecha = Var_FecActual;
	END IF;

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FechaBitacora, NOW());

	SET Aud_FechaActual		:= NOW();

	-- Se guarda la nueva ejecución.
	CALL BITACORABATCHALT(
		Pro_EvalMatrizPLD,	Var_FecActual,		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Evaluacion por Matriz de Riesgo Ejecutado Correctamente.';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'fechaEvaluar' AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$
