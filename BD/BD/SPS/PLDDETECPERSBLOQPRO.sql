-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDETECPERSBLOQPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDETECPERSBLOQPRO`;

DELIMITER $$
CREATE PROCEDURE `PLDDETECPERSBLOQPRO`(
	/* SP DE PROCESO QUE DETECTA A UN CLIENTE EN LISTAS DE PERS. BLOQ. EN EL ALTA O EN LA MODIFICACION */
	Par_ClavePersonaInv			INT(11),	    	-- Numero de Cliente o Usuario de Servicios Modificado, cero si es en el alta
	Par_PrimerNombre			VARCHAR(50),	-- Primer Nombre
	Par_SegundoNombre			VARCHAR(50),	-- Segundo Nombre
	Par_TercerNombre			VARCHAR(50),	-- Tercer Nombre
	Par_ApellidoPaterno			VARCHAR(50),	-- Apellido Paterno

	Par_ApellidoMaterno			VARCHAR(50),	-- Apellido Materno
	Par_RFC						CHAR(13),		-- RFC de la persona (fisica o moral)
	Par_FechaNacimiento			DATE,			-- Fecha de nacimiento
	Par_NombreCompleto			VARCHAR(500),	-- Contiene el nombre completo de la persona o la razon social
	Par_CuentaAhoID				BIGINT(12),		-- Numero de la Cuenta de Ahorro

	Par_PaisID					INT(11),		-- ID del Pais
	Par_EstadoID				INT(11),		-- ID del Estado (si aplica)
	Par_TipoPersSAFI			VARCHAR(3),		-- CTE. Cliente USU. Usuario de Servicios NA. No Aplica
	Par_TipoPersona				CHAR(1),		-- F. Fisica A. Fisica con Act Empresarial M. Moral
	Par_Salida					CHAR(1),		-- Tipo de Salida S. Si N. No

	INOUT	Par_NumErr 			INT(11),		-- Numero de Error
	INOUT	Par_ErrMen  		VARCHAR(400),	-- Mensaje de Error
	INOUT	Par_Coincidencias	INT(11),		-- Numero de coincidencias
	INOUT	Par_PersonaBloqID	BIGINT(12),		-- Persona bloqueada id
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_FechaDeteccion	DATE;
	DECLARE Var_Indice			INT(11);
	DECLARE Var_NombreComplet	VARCHAR(200);
	DECLARE Var_OpeInusualID	BIGINT(20);
	DECLARE Var_ParamPorcen		INT(11);
	DECLARE Var_PersonaBloqID	BIGINT(12);
	DECLARE Var_RazonSocial		VARCHAR(150);
	DECLARE Var_RFCpm			VARCHAR(13);
	DECLARE Var_SoloApellidos	VARCHAR(150);
	DECLARE Var_SoloNombres		VARCHAR(150);
	DECLARE Var_TipoLista		VARCHAR(45);
	DECLARE Var_TipoPersona		CHAR(1);
	DECLARE Var_NumErr 			INT(11);		-- Variable usada para la bitacora de fallos de pld
	DECLARE Var_ErrMen 			TEXT;			-- Variable usada para la bitacora de fallos de pld
	DECLARE Var_OpeInusualIDSPL	BIGINT(20);
	DECLARE Var_PermiteOperacion CHAR(1);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE CatMotivInusualID	VARCHAR(15);
	DECLARE CatProcIntID		VARCHAR(10);
	DECLARE ClaveRegistra		CHAR(2);
	DECLARE Coincidencia 		INT;
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE DescripOpera		VARCHAR(52);
	DECLARE DescripOPMod		VARCHAR(52);
	DECLARE Entero_Cero			INT;
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Mayusculas			CHAR(2);
	DECLARE Mexico				INT(11);
	DECLARE PersActEmp			CHAR(1);
	DECLARE PersFisica			CHAR(1);
	DECLARE PersMoral 			CHAR(1);
	DECLARE RegistraSAFI		CHAR(4);
	DECLARE Str_No				CHAR(1);
	DECLARE Str_Si				CHAR(1);
	DECLARE TipoOperaAlt		INT;
	DECLARE	NivelBusquedaPLD	INT;
	DECLARE Con_LPB				CHAR(3);

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET CatMotivInusualID		:='LISBLOQ';		-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
	SET CatProcIntID			:='PR-SIS-000';		-- Clave interna
	SET ClaveRegistra			:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
	SET Coincidencia 			:= 0;				-- No. Coincidencia
	SET Decimal_Cero			:= 0.0;				-- DECIMAL Cero
	SET DescripOpera			:='LISTA DE PERSONAS BLOQUEADAS';	-- Comentario en operaciones de alta o modificacion de clientes
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Estatus_Activo			:= 'A';				-- Estatus Activo
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET Mayusculas				:= 'MA';			-- Obtener el resultado en Mayusculas
	SET Mexico					:= 700;				-- Pais Mexico
	SET PersActEmp				:= 'A';				-- Tipo de persona fisica con actividad empresarial
	SET PersFisica				:= 'F';				-- Tipo de persona fisica
	SET PersMoral				:= 'M';				-- Tipo de persona moral
	SET RegistraSAFI			:= 'SAFI';			-- Clave que registra la operacion
	SET Str_No					:= 'N';				-- Constante no
	SET Str_Si					:= 'S';				-- Constante si
	SET TipoOperaAlt			:= 10;				-- Tipo de Operacion Alta
	SET Con_LPB					:= 'LPB';			-- Inidica que es de lista de personas bloqueadas

	-- Asignacion de Variable
	SET Var_FechaDeteccion		:= (SELECT FechaSistema FROM PARAMETROSSIS);

	SET Par_PrimerNombre 		:=TRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia));
	SET Par_SegundoNombre 		:=TRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia));
	SET Par_TercerNombre 		:=TRIM(IFNULL(Par_TercerNombre, Cadena_Vacia));
	SET Par_ApellidoPaterno 	:=TRIM(IFNULL(Par_ApellidoPaterno, Cadena_Vacia));
	SET Par_ApellidoMaterno 	:=TRIM(IFNULL(Par_ApellidoMaterno, Cadena_Vacia));
	SET Par_RFC 				:=TRIM(IFNULL(Par_RFC, Cadena_Vacia));

	SET Var_SoloNombres			:=  FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Par_TercerNombre,Cadena_Vacia,Cadena_Vacia);
	SET Var_SoloApellidos		:=  FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,Par_ApellidoPaterno,Par_ApellidoMaterno);
	SET Var_NombreComplet 		:=  FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Par_TercerNombre,Par_ApellidoPaterno,Par_ApellidoMaterno);
	SET Var_PersonaBloqID		:= Entero_Cero;

	SELECT ValorParametro INTO NivelBusquedaPLD
		FROM PARAMGENERALES
	    WHERE LlaveParametro = 'NivelBusquedaPLD';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDDETECPERSBLOQPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		SET Var_ParamPorcen := (SELECT PorcCoincidencias FROM PARAMETROSSIS LIMIT 1);

		IF(Var_ParamPorcen = 100) THEN
			ManejoDeteccion: BEGIN
				SET Var_NombreComplet := IFNULL(Var_NombreComplet,Cadena_Vacia);
				-- BUSCA COINCIDENCIAS PERSONAS FISICAS y PERSONAS FISICAS CON ACT EMPRESARIAL
				IF(IFNULL(Par_TipoPersona,PersFisica)=PersFisica OR IFNULL(Par_TipoPersona,PersFisica)=PersActEmp)THEN
					/* DETECCION POR 2 COINCIDENCIAS: NOMBRES, APELLIDOS*/
					SELECT PersonaBloqID, TipoLista
					INTO
					Var_PersonaBloqID, Var_TipoLista
					FROM PLDLISTAPERSBLOQ AS PERS
					WHERE SoloNombres LIKE Var_SoloNombres/*NOMBRES*/
							AND SoloApellidos LIKE Var_SoloApellidos/*APELLIDOS*/
							AND TipoPersona IN (PersFisica,PersActEmp)
							AND Estatus = Estatus_Activo
						LIMIT 1;

					IF(Var_PersonaBloqID!=Entero_Cero) THEN
						SET Coincidencia := 3;
						LEAVE ManejoDeteccion;
					END IF;
					/* DETECCION POR LAS 4 COINCIDENCIAS: NOMBRES, APELLIDOS, FECHA DE NACIMIENTO, PAIS-EDO */
					SELECT PersonaBloqID, TipoLista
					INTO
					Var_PersonaBloqID, Var_TipoLista
					FROM PLDLISTAPERSBLOQ AS PERS
					WHERE SoloNombres LIKE Var_SoloNombres
								/*NOMBRES*/
							AND SoloApellidos LIKE Var_SoloApellidos
								/*APELLIDOS*/
							AND (FechaNacimiento = Par_FechaNacimiento
								)/*FECHA DE NACIMIENTO*/
							AND (PaisID = Par_PaisID
								AND EstadoID = Par_EstadoID
								)/*PAIS-ESTADO*/
							AND TipoPersona IN (PersFisica,PersActEmp)
							AND PERS.Estatus = Estatus_Activo
						LIMIT 1;

					SET Var_PersonaBloqID 	:= IFNULL(Var_PersonaBloqID, Entero_Cero);
					SET Var_TipoLista 		:= IFNULL(Var_TipoLista, Cadena_Vacia);

					IF(Var_PersonaBloqID!=Entero_Cero) THEN
						SET Coincidencia := 4;
						LEAVE ManejoDeteccion;
					END IF;

					/* DETECCION POR 3 COINCIDENCIAS: APELLIDOS, FECHA DE NACIMIENTO, PAIS-EDO */
					SELECT PersonaBloqID, TipoLista
					INTO
					Var_PersonaBloqID, Var_TipoLista
					FROM PLDLISTAPERSBLOQ AS PERS
					WHERE SoloApellidos LIKE Var_SoloApellidos
								/*APELLIDOS*/
							AND (FechaNacimiento = Par_FechaNacimiento
								)/*FECHA DE NACIMIENTO*/
							AND (PaisID = Par_PaisID
								AND EstadoID = Par_EstadoID
								)/*PAIS-ESTADO*/
							AND TipoPersona IN (PersFisica,PersActEmp)
							AND Estatus = Estatus_Activo
						LIMIT 1;

					SET Var_PersonaBloqID 	:= IFNULL(Var_PersonaBloqID, Entero_Cero);
					SET Var_TipoLista 		:= IFNULL(Var_TipoLista, Cadena_Vacia);

					IF(Var_PersonaBloqID!=Entero_Cero) THEN
						SET Coincidencia := 3;
						LEAVE ManejoDeteccion;
					END IF;

					/* DETECCION POR 3 COINCIDENCIAS: NOMBRES, FECHA DE NACIMIENTO, PAIS-EDO */
					SELECT PersonaBloqID, TipoLista
					INTO
					Var_PersonaBloqID, Var_TipoLista
					FROM PLDLISTAPERSBLOQ AS PERS
					WHERE SoloNombres LIKE Var_SoloNombres
								/*NOMBRES*/
							AND (FechaNacimiento = Par_FechaNacimiento
								)/*FECHA DE NACIMIENTO*/
							AND (PaisID = Par_PaisID
								AND EstadoID = Par_EstadoID
								)/*PAIS-ESTADO*/
							AND TipoPersona IN (PersFisica,PersActEmp)
							AND Estatus = Estatus_Activo
						LIMIT 1;

					IF(Var_PersonaBloqID!=Entero_Cero) THEN
						SET Coincidencia := 3;
						LEAVE ManejoDeteccion;
					END IF;

					/* DETECCION POR 3 COINCIDENCIAS: NOMBRES, APELLIDOS, PAIS-EDO */
					SELECT PersonaBloqID, TipoLista
					INTO
					Var_PersonaBloqID, Var_TipoLista
					FROM PLDLISTAPERSBLOQ AS PERS
					WHERE SoloNombres LIKE Var_SoloNombres
								/*NOMBRES*/
							AND SoloApellidos LIKE Var_SoloApellidos
								/*APELLIDOS*/
							AND (PaisID = Par_PaisID
								AND EstadoID = Par_EstadoID
								)/*PAIS-ESTADO*/
							AND TipoPersona IN (PersFisica,PersActEmp)
							AND Estatus = Estatus_Activo
						LIMIT 1;

					IF(Var_PersonaBloqID!=Entero_Cero) THEN
						SET Coincidencia := 3;
						LEAVE ManejoDeteccion;
					END IF;

					/* DETECCION POR 3 COINCIDENCIAS: NOMBRES, APELLIDOS, FECHA DE NACIMIENTO */
					SELECT PersonaBloqID, TipoLista
					INTO
					Var_PersonaBloqID, Var_TipoLista
					FROM PLDLISTAPERSBLOQ AS PERS
					WHERE SoloNombres LIKE Var_SoloNombres
								/*NOMBRES*/
							AND SoloApellidos LIKE Var_SoloApellidos
								/*APELLIDOS*/
							AND (FechaNacimiento = Par_FechaNacimiento
								)/*FECHA DE NACIMIENTO*/
							AND TipoPersona IN (PersFisica,PersActEmp)
							AND Estatus = Estatus_Activo
						LIMIT 1;

					IF(Var_PersonaBloqID!=Entero_Cero) THEN
						SET Coincidencia := 3;
						LEAVE ManejoDeteccion;
					END IF;


				END IF;
				-- FIN BUSCA COINCIDENCIA PERSONAS FISICAS y PERSONAS FISICAS CON ACT EMPRESARIAL

				-- BUSCA COINCIDENCIAS MORALES
				IF(IFNULL(Par_TipoPersona,PersFisica)=PersMoral)THEN
					-- Se toma el nombre de la razon social de la persona moral
					SET Var_NombreComplet	:= FNLIMPIACARACTERESGEN(TRIM(Par_NombreCompleto),'M');
					SET Var_NombreComplet	:= IFNULL(Var_NombreComplet,Cadena_Vacia);
					/* DETECCION POR 1 COINCIDENCIA QUE SE CONSIDERA COMO 3: RAZON SOCIAL */
					SELECT PersonaBloqID, TipoLista
					INTO
					Var_PersonaBloqID, Var_TipoLista
					FROM PLDLISTAPERSBLOQ AS PERS
					WHERE RazonSocialPLD LIKE Var_NombreComplet
							/*RAZON SOCIAL*/
							AND TipoPersona = PersMoral
							AND Estatus = Estatus_Activo
						LIMIT 1;
						/*Partiendo de la deteccion de pers fisicas se toma como 3 coincidencias
						 * debido a que no hay mas datos para realizar la deteccion de pers morales */
						IF(Var_PersonaBloqID!=Entero_Cero) THEN
							SET Coincidencia := 3;
							LEAVE ManejoDeteccion;
						END IF;

					/* DETECCION POR 1 COINCIDENCIA QUE SE CONSIDERA COMO 3: RFC */
					IF(IFNULL(Par_RFC, Cadena_Vacia) != Cadena_Vacia) THEN
						SELECT PersonaBloqID, TipoLista
						INTO Var_PersonaBloqID, Var_TipoLista
						FROM PLDLISTAPERSBLOQ AS PERS
						WHERE RFCm != Cadena_Vacia
						  AND RFCm LIKE Par_RFC
							/*RFC PERS MORAL*/
						  AND TipoPersona = PersMoral
						  AND Estatus = Estatus_Activo
						LIMIT 1;
					END IF;

						/*Partiendo de la deteccion de pers fisicas se toma como 3 coincidencias
						 * debido a que no hay mas datos para realizar la deteccion de pers morales */
						IF(Var_PersonaBloqID!=Entero_Cero) THEN
							SET Coincidencia := 3;
							LEAVE ManejoDeteccion;
						END IF;
						-- No se toma en cuenta ni el pais ni el estado para la deteccion
				END IF;
				-- FIN BUSCA COINCIDENCIA MORALES
			END ManejoDeteccion;
		ELSE
			ManejoDeteccion: BEGIN
				SET Var_NombreComplet := IFNULL(Var_NombreComplet,Cadena_Vacia);
				-- BUSCA COINCIDENCIAS PERSONAS FISICAS y PERSONAS FISICAS CON ACT EMPRESARIAL
				IF(IFNULL(Par_TipoPersona,PersFisica)=PersFisica OR IFNULL(Par_TipoPersona,PersFisica)=PersActEmp)THEN
				/* DETECCION POR LAS 2 COINCIDENCIAS: NOMBRES, APELLIDOS*/
					SELECT
						PERS.PersonaBloqID, TipoLista
						INTO
						Var_PersonaBloqID, Var_TipoLista
						FROM
							PLDLISTAPERSBLOQ AS PERS
							WHERE
								FNPORCENTAJEDIFF(Var_SoloNombres,SoloNombres)>= Var_ParamPorcen AND /*NOMBRES*/
								FNPORCENTAJEDIFF(Var_SoloApellidos,SoloApellidos)>= Var_ParamPorcen AND /*APELLIDOS*/
								TipoPersona IN (PersFisica,PersActEmp) AND
								PERS.Estatus = Estatus_Activo
								ORDER BY FNPORCENTAJEDIFF(Var_SoloNombres,SoloNombres) DESC, FNPORCENTAJEDIFF(Var_SoloApellidos,SoloApellidos) DESC
								LIMIT 1;

					SET Var_PersonaBloqID 	:= IFNULL(Var_PersonaBloqID, Entero_Cero);
					SET Var_TipoLista 		:= IFNULL(Var_TipoLista, Cadena_Vacia);

					IF(Var_PersonaBloqID!=Entero_Cero) THEN
						SET Coincidencia := 4;
						LEAVE ManejoDeteccion;
					END IF;

					/* DETECCION POR LAS 4 COINCIDENCIAS: NOMBRES, APELLIDOS, FECHANACIMIENTO-RFC, PAIS-EDO */
					SELECT
						PERS.PersonaBloqID, TipoLista
						INTO
						Var_PersonaBloqID, Var_TipoLista
						FROM
							PLDLISTAPERSBLOQ AS PERS
							WHERE
								FNPORCENTAJEDIFF(Var_SoloNombres,SoloNombres)>= Var_ParamPorcen AND /*NOMBRES*/
								FNPORCENTAJEDIFF(Var_SoloApellidos,SoloApellidos)>= Var_ParamPorcen AND /*APELLIDOS*/
								(RFC = Par_RFC AND FechaNacimiento = Par_FechaNacimiento)/*FECHA DE NACIMIENTO - RFC*/ AND
								(PaisID = Par_PaisID AND EstadoID = Par_EstadoID)/*PAIS-ESTADO*/ AND
								TipoPersona IN (PersFisica,PersActEmp) AND
								PERS.Estatus = Estatus_Activo
								ORDER BY FNPORCENTAJEDIFF(Var_SoloNombres,SoloNombres) DESC, FNPORCENTAJEDIFF(Var_SoloApellidos,SoloApellidos) DESC
								LIMIT 1;

					SET Var_PersonaBloqID 	:= IFNULL(Var_PersonaBloqID, Entero_Cero);
					SET Var_TipoLista 		:= IFNULL(Var_TipoLista, Cadena_Vacia);

					IF(Var_PersonaBloqID!=Entero_Cero) THEN
						SET Coincidencia := 4;
						LEAVE ManejoDeteccion;
					END IF;

					/* DETECCION POR 3 COINCIDENCIAS: APELLIDOS, FECHANACIMIENTO-RFC, PAIS-EDO */
					SELECT
						PERS.PersonaBloqID, TipoLista
						INTO
						Var_PersonaBloqID, Var_TipoLista
						FROM PLDLISTAPERSBLOQ AS PERS
							WHERE
								FNPORCENTAJEDIFF(Var_SoloApellidos,SoloApellidos)>= Var_ParamPorcen AND /*APELLIDOS*/
								(RFC = Par_RFC AND FechaNacimiento = Par_FechaNacimiento)/*FECHA DE NACIMIENTO - RFC*/ AND
								(PaisID = Par_PaisID AND EstadoID = Par_EstadoID)/*PAIS-ESTADO*/ AND
								TipoPersona IN (PersFisica,PersActEmp) AND
								Estatus = Estatus_Activo
								ORDER BY FNPORCENTAJEDIFF(Var_SoloApellidos,SoloApellidos) DESC
								LIMIT 1;

						SET Var_PersonaBloqID 	:= IFNULL(Var_PersonaBloqID, Entero_Cero);
						SET Var_TipoLista 		:= IFNULL(Var_TipoLista, Cadena_Vacia);

						IF(Var_PersonaBloqID!=Entero_Cero) THEN
							SET Coincidencia := 3;
							LEAVE ManejoDeteccion;
						END IF;

						/* DETECCION POR 3 COINCIDENCIAS: NOMBRES, FECHANACIMIENTO-RFC, PAIS-EDO */
						SELECT
							PERS.PersonaBloqID,			TipoLista
							INTO
							Var_PersonaBloqID,		Var_TipoLista
							FROM
								PLDLISTAPERSBLOQ AS PERS
								WHERE
									FNPORCENTAJEDIFF(Var_SoloNombres,SoloNombres)>= Var_ParamPorcen AND /*NOMBRES*/
									(RFC = Par_RFC AND FechaNacimiento = Par_FechaNacimiento)/*FECHA DE NACIMIENTO - RFC*/ AND
									(PaisID = Par_PaisID AND EstadoID = Par_EstadoID)/*PAIS-ESTADO*/ AND
									TipoPersona IN (PersFisica,PersActEmp) AND
									Estatus = Estatus_Activo
									ORDER BY FNPORCENTAJEDIFF(Var_SoloNombres,SoloNombres) DESC
									LIMIT 1;

						IF(Var_PersonaBloqID!=Entero_Cero) THEN
							SET Coincidencia := 3;
							LEAVE ManejoDeteccion;
						END IF;

						/* DETECCION POR 3 COINCIDENCIAS: NOMBRES, APELLIDOS, PAIS-EDO */
						SELECT
							PERS.PersonaBloqID, TipoLista
							INTO
							Var_PersonaBloqID, Var_TipoLista
							FROM
								PLDLISTAPERSBLOQ AS PERS
								WHERE
									FNPORCENTAJEDIFF(Var_SoloNombres,SoloNombres)>= Var_ParamPorcen AND /*NOMBRES*/
									FNPORCENTAJEDIFF(Var_SoloApellidos,SoloApellidos)>= Var_ParamPorcen AND /*APELLIDOS*/
									(PaisID = Par_PaisID AND EstadoID = Par_EstadoID)/*PAIS-ESTADO*/ AND
									TipoPersona IN (PersFisica,PersActEmp) AND
									Estatus = Estatus_Activo
									ORDER BY FNPORCENTAJEDIFF(Var_SoloNombres,SoloNombres) DESC
									LIMIT 1;

						IF(Var_PersonaBloqID!=Entero_Cero) THEN
							SET Coincidencia := 3;
							LEAVE ManejoDeteccion;
						END IF;

						/* DETECCION POR 3 COINCIDENCIAS: NOMBRES, APELLIDOS, FECHANACIMIENTO-RFC */
						SELECT
							PERS.PersonaBloqID, TipoLista
							INTO
							Var_PersonaBloqID, Var_TipoLista
							FROM PLDLISTAPERSBLOQ AS PERS
							WHERE
								FNPORCENTAJEDIFF(Var_SoloNombres,SoloNombres)>= Var_ParamPorcen AND /*NOMBRES*/
								FNPORCENTAJEDIFF(Var_SoloApellidos,SoloApellidos)>= Var_ParamPorcen AND /*APELLIDOS*/
								(RFC = Par_RFC AND FechaNacimiento = Par_FechaNacimiento)/*FECHA DE NACIMIENTO - RFC*/ AND
								TipoPersona IN (PersFisica,PersActEmp) AND
								Estatus = Estatus_Activo
								ORDER BY FNPORCENTAJEDIFF(Var_SoloNombres,SoloNombres) DESC, FNPORCENTAJEDIFF(Var_SoloApellidos,SoloApellidos) DESC
								LIMIT 1;

						IF(Var_PersonaBloqID!=Entero_Cero) THEN
							SET Coincidencia := 3;
							LEAVE ManejoDeteccion;
						END IF;
				END IF;
				-- FIN BUSCA COINCIDENCIA PERSONAS FISICAS y PERSONAS FISICAS CON ACT EMPRESARIAL

				-- BUSCA COINCIDENCIAS MORALES
				IF(IFNULL(Par_TipoPersona,PersFisica)=PersMoral)THEN
					-- Se toma el nombre de la razon social de la persona moral
					SET Var_NombreComplet	:= FNLIMPIACARACTERESGEN(TRIM(Par_NombreCompleto),'MA');
					SET Var_NombreComplet	:= IFNULL(Var_NombreComplet,Cadena_Vacia);
					/* DETECCION POR 1 COINCIDENCIA QUE SE CONSIDERA COMO 3: RAZON SOCIAL */
					SELECT
						PERS.PersonaBloqID,			TipoLista
						INTO
						Var_PersonaBloqID,		Var_TipoLista
						FROM
							PLDLISTAPERSBLOQ AS PERS
							WHERE
							FNPORCENTAJEDIFF(Par_NombreCompleto,RazonSocialPLD)>=Var_ParamPorcen AND
								TipoPersona = PersMoral AND
								Estatus = Estatus_Activo
								ORDER BY FNPORCENTAJEDIFF(Par_NombreCompleto,RazonSocialPLD) DESC
								LIMIT 1;
						/*Partiendo de la deteccion de pers fisicas se toma como 3 coincidencias
						 * debido a que no hay mas datos para realizar la deteccion de pers morales */
						IF(Var_PersonaBloqID!=Entero_Cero) THEN
							SET Coincidencia := 3;
							LEAVE ManejoDeteccion;
						END IF;

					/* DETECCION POR 1 COINCIDENCIA QUE SE CONSIDERA COMO 3: RFC */
					IF(LENGTH(Par_RFC)>0) THEN
						SELECT PERS.PersonaBloqID, TipoLista
						INTO Var_PersonaBloqID, Var_TipoLista
						FROM PLDLISTAPERSBLOQ AS PERS
						WHERE RFCm LIKE Par_RFC
								/*RFC PERS MORAL*/
						  AND TipoPersona = PersMoral
						  AND Estatus = Estatus_Activo
						LIMIT 1;
					END IF;
						/*Partiendo de la deteccion de pers fisicas se toma como 3 coincidencias
						 * debido a que no hay mas datos para realizar la deteccion de pers morales */
						IF(IFNULL(Var_PersonaBloqID, Entero_Cero) !=Entero_Cero) THEN
							SET Coincidencia := 3;
							LEAVE ManejoDeteccion;
						END IF;
						-- No se toma en cuenta ni el pais ni el estado para la deteccion
				END IF;
				-- FIN BUSCA COINCIDENCIA MORALES
			END ManejoDeteccion;
		END IF;-- FIN MANEJO DETECCION

		SET Par_CuentaAhoID := IFNULL(Par_CuentaAhoID,Entero_Cero);
		SET Par_Coincidencias := IFNULL(Coincidencia,Entero_Cero);

		-- Si el número de coincidecias es mayor o igual a lo parametrizado se registra como operacion inusual.
		IF(Coincidencia >2)THEN
			SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES
										WHERE Fecha=Var_FechaDeteccion
											AND FechaDeteccion = Var_FechaDeteccion
											AND ClaveRegistra=ClaveRegistra
											AND NombreReg = RegistraSAFI
											AND CatProcedIntID = CatProcIntID
											AND CatMotivInuID = CatMotivInusualID
											AND NomPersonaInv = Var_NombreComplet
											AND TipoPersonaSAFI = Par_TipoPersSAFI
											AND DesOperacion = DescripOpera
											AND ClavePersonaInv = Par_ClavePersonaInv LIMIT 1);

			-- Si ya se detecto anteriormente, ya no se vuelve a registrar como operacion inusual
			IF(IFNULL(Var_OpeInusualID,Entero_Cero)=Entero_Cero)THEN
				CALL PLDOPEINUSUALESALT(
					CatProcIntID,		CatMotivInusualID,		Var_FechaDeteccion,		Par_ClavePersonaInv,		Var_NombreComplet,
					Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			DescripOpera,				Entero_Cero,
					Par_CuentaAhoID,	Aud_NumTransaccion,		Cadena_Vacia,			Decimal_Cero,				Entero_Cero,
					Par_TipoPersSAFI,	Var_SoloNombres,		Par_ApellidoPaterno,	Par_ApellidoMaterno,		Var_TipoLista,
					Str_No,				Par_NumErr, 			Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion );

				IF(Par_NumErr!=Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES
											WHERE Fecha=Var_FechaDeteccion
												AND FechaDeteccion = Var_FechaDeteccion
												AND ClaveRegistra=ClaveRegistra
												AND NombreReg = RegistraSAFI
												AND CatProcedIntID = CatProcIntID
												AND CatMotivInuID = CatMotivInusualID
												AND NomPersonaInv = Var_NombreComplet
												AND TipoPersonaSAFI = Par_TipoPersSAFI
												AND DesOperacion = DescripOpera
												AND ClavePersonaInv = Par_ClavePersonaInv LIMIT 1);

				-- Se inicializan las variables para el error por correo
				SET Var_NumErr := Entero_Cero;
				SET Var_ErrMen := Cadena_Vacia;
				
				-- Se registra la operacion inusual para que se envie una alerta por correo
				CALL PLDALERTAINUSPRO(
					Var_OpeInusualID,		Str_No,					Var_NumErr, 			Var_ErrMen,				Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP, 		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion );

				IF( Var_NumErr <> Entero_Cero ) THEN
					CALL BITACORAERRORNOTICAPLDALT(
						Var_OpeInusualID,		Var_NumErr,			Var_ErrMen,
						Str_No,					Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
				END IF;

				INSERT INTO PLDCOINCIDENCIAS(
					ClavePersonaInv,			PersonaBloqID,			ListaNegraID,			TipoPersSAFI,			FechaDeteccion,
					HoraDeteccion,				OpeInusualID,			EmpresaID,				Usuario,				FechaActual,
					DireccionIP,				ProgramaID,				Sucursal,				NumTransaccion)
					VALUES(
					Par_ClavePersonaInv,		Var_PersonaBloqID,		NULL,					Par_TipoPersSAFI,		Var_FechaDeteccion,
					CURRENT_TIME(),				Var_OpeInusualID,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			END IF;

			

			SELECT OpeInusualID,PermiteOperacion INTO Var_OpeInusualIDSPL,Var_PermiteOperacion
			FROM PLDSEGPERSONALISTAS
			WHERE OpeInusualID = Var_OpeInusualID;

			SET Var_PermiteOperacion := IFNULL(Var_PermiteOperacion,Cadena_Vacia);
			

			SET Par_NumErr	:= 01;

			IF(IFNULL(Par_TipoPersona,PersFisica)=PersMoral)THEN
				SET Par_ErrMen	:=CONCAT('Coincidencias Detectadas. La Persona se encuentra en La Lista de Personas Bloqueadas.');
			ELSE
				SET Par_ErrMen	:=CONCAT('Coincidencias Detectadas: ',Coincidencia,'. La Persona se encuentra en La Lista de Personas Bloqueadas.');
			END IF;

			IF Var_PermiteOperacion != Cadena_Vacia THEN
				IF Var_PermiteOperacion = Str_Si THEN
					SET Par_NumErr	:= 00;
					SET Par_ErrMen	:='Operacion permitida desde Seguimiento de personas en listas';
				END IF;
			END IF;


		  ELSE
			SET Par_NumErr	:= 00;
			SET Par_ErrMen	:='No hay suficientes coincidencias.';
		END IF;
	END ManejoErrores;

	IF(Par_Salida=Str_Si)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_OpeInusualID AS Consecutivo,
				'OpeInusualID' AS Control,
				Var_PersonaBloqID AS PersonaBloqID;
	END IF;

	IF(Par_Salida = Str_No) THEN
		SET Par_PersonaBloqID := Var_PersonaBloqID;
	END IF;

END TerminaStore$$