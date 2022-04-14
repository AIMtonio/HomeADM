
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDETECLISTASLVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDETECLISTASLVPRO`;

DELIMITER $$
CREATE PROCEDURE `PLDDETECLISTASLVPRO`(
/** SP QUE GENERA LA ALERTA INUSUAL CUANDO SE DETECTA COINCIDENCIA POR NOMBRES
 ** MEDIANTE JAVA POR EL ALGORITMO LEVEINSHTEIN UKKONEN.*/
	Par_ListaID					BIGINT(12),		-- ID DE LISTAS NEGRAS / PEROSNAS BLOQUEADAS
	Par_TipoLista				INT(11),		-- Tipo de lista 1: Listas Negras 2: Listas Pers.Bloq.
	Par_TipoListaID				VARCHAR(45),	-- Tipo de lista CATTIPOLISTAPLD.
	Par_ClavePersonaInv			INT(11),		-- Numero de Cliente o Usuario de Servicios Modificado, cero si es en el alta
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
	INOUT Par_NumErr 			INT(11),		-- Numero de Error
	INOUT Par_ErrMen  			VARCHAR(400),	-- Mensaje de Error

	INOUT Par_Coincidencias		INT(11),		-- Numero de coincidencias
	INOUT Par_PersonaBloqID		BIGINT(12),		-- Persona bloqueada id
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_FechaDeteccion	DATE;
	DECLARE Var_Indice			INT(11);
	DECLARE Var_NombreComplet	VARCHAR(200);
	DECLARE Var_OpeInusualID	BIGINT(20);
	DECLARE Var_ParamPorcen		INT(11);
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
	DECLARE Var_ActualizaPEP	CHAR(1);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE CatMotivInusualID	VARCHAR(15);
	DECLARE CatProcIntID		VARCHAR(10);
	DECLARE ClaveRegistra		CHAR(2);
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
	DECLARE	Lista_Negra			INT;
	DECLARE	Lista_PBloq			INT;
	DECLARE Con_LPB				CHAR(3);
	DECLARE TipoPers_Cliente	VARCHAR(3);
	DECLARE TipoAct_PEP			INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET CatMotivInusualID		:='LISBLOQ';		-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
	SET CatProcIntID			:='PR-SIS-000';		-- Clave interna
	SET ClaveRegistra			:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
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
	SET Lista_Negra				:= 1;				-- Tipo de Lista Negra
	SET Lista_PBloq				:= 2;				-- Tipo de Lista Pers. Bloq.
	SET TipoPers_Cliente		:= 'CTE';			-- Tipo de Persona SAFI: Cliente.
	SET TipoAct_PEP				:= 1;				-- Tipo de Actualización PEP.

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDDETECLISTASLVPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		SET Var_ParamPorcen 		:= (SELECT PorcCoincidencias FROM PARAMETROSSIS LIMIT 1);
		SET Var_FechaDeteccion		:= (SELECT FechaSistema FROM PARAMETROSSIS);

		SET Par_PrimerNombre 		:=TRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia));
		SET Par_SegundoNombre 		:=TRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia));
		SET Par_TercerNombre 		:=TRIM(IFNULL(Par_TercerNombre, Cadena_Vacia));
		SET Par_ApellidoPaterno 	:=TRIM(IFNULL(Par_ApellidoPaterno, Cadena_Vacia));
		SET Par_ApellidoMaterno 	:=TRIM(IFNULL(Par_ApellidoMaterno, Cadena_Vacia));
		SET Par_RFC 				:=TRIM(IFNULL(Par_RFC, Cadena_Vacia));

		SET Var_SoloNombres			:= FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Par_TercerNombre,Cadena_Vacia,Cadena_Vacia);
		SET Var_SoloApellidos		:= FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,Par_ApellidoPaterno,Par_ApellidoMaterno);
		SET Var_NombreComplet 		:= FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Par_TercerNombre,Par_ApellidoPaterno,Par_ApellidoMaterno);

		SET Par_ListaID			:= IFNULL(Par_ListaID,Entero_Cero);
		SET Par_CuentaAhoID		:= IFNULL(Par_CuentaAhoID,Entero_Cero);
		SET Par_TipoLista		:= IFNULL(Par_TipoLista,Entero_Cero);
		SET Par_TipoListaID		:= IFNULL(Par_TipoListaID,Cadena_Vacia);
		SET Par_Coincidencias	:= IF(Par_ListaID != Entero_Cero, 3, Entero_Cero);
		SET CatMotivInusualID	:= IF(Par_TipoLista = Lista_PBloq,'LISBLOQ','LISNEG');
		SET Aud_FechaActual		:= NOW();

		-- Si el número de coincidecias es mayor o igual a lo parametrizado se registra como operacion inusual.
		IF(Par_Coincidencias > 2)THEN
			IF(Par_TipoLista = Lista_Negra)THEN
				SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES
										WHERE Fecha=Var_FechaDeteccion
											AND FechaDeteccion = Var_FechaDeteccion
											AND ClaveRegistra=ClaveRegistra
											AND NombreReg = RegistraSAFI
											AND CatProcedIntID = CatProcIntID
											AND CatMotivInuID = CatMotivInusualID
											AND NomPersonaInv = Var_NombreComplet
											AND TipoPersonaSAFI = Par_TipoPersSAFI
											AND ClavePersonaInv = Par_ClavePersonaInv LIMIT 1);
			ELSE
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
			END IF;

			-- Si ya se detecto anteriormente, ya no se vuelve a registrar como operacion inusual
			IF(IFNULL(Var_OpeInusualID,Entero_Cero)=Entero_Cero)THEN
				IF(Par_TipoLista = Lista_Negra)THEN
					# SE ACTUALIZA DESCRIPCIÓN CUANDO ES POR LISTAS NEGRAS.
					SET DescripOpera := 'REPORTE DE 24 HRS';

					# SI LA PERSONA ENCONTRADA ES PEP, SE REPORTA COMO OP NORMAL (NO 24 HRS).
					IF(Par_TipoListaID = 'PEP' OR Par_TipoListaID = 'PPE' OR Par_TipoListaID = 'PEPINT' OR Par_TipoListaID = 'PPEINT')THEN
						SET DescripOpera := 'PEP. PERSONA POLITICAMENTE EXPUESTA.';
						SET CatMotivInusualID :='PEP';
						# SE CONSULTA EL PARÁMETRO SI SE ENCUENTRA ENCENDIDO (SI).
						SET Var_ActualizaPEP := LEFT(TRIM(FNPARAMGENERALES('ActClientePEPPLD')),1);
						SET Var_ActualizaPEP := IFNULL(Var_ActualizaPEP,Str_No);

						# SI ESTA ENCENDIDO, SE EJECUTA LA ACTUALIZACIÓN PEP EN EL CONOCIMIENTO DE CTE.
						IF(Var_ActualizaPEP = Str_Si)THEN
							/** SI LA PERSONA ES UN CLIENTE, SE ACTUALIZA EL CONOCIMIENTO DEL CLIENTE A PEP SI.*/
							IF(Par_TipoPersSAFI = TipoPers_Cliente)THEN
								# SE ACTUALIZA EL CONOCIMIENTO DEL CLIENTE.
								CALL CONOCIMIENTOCTEACT(
									Par_ClavePersonaInv,TipoAct_PEP,		Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Str_Si,			Entero_Cero,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,	Entero_Cero,
									Entero_Cero,		Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,		Entero_Cero,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,
									Cadena_Vacia,		Cadena_Vacia,		Fecha_Vacia,		Cadena_Vacia,	Entero_Cero,
									Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,	Entero_Cero,
									Str_No,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE ManejoErrores;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;

				CALL PLDOPEINUSUALESALT(
					CatProcIntID,		CatMotivInusualID,		Var_FechaDeteccion,		Par_ClavePersonaInv,		Var_NombreComplet,
					Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			DescripOpera,				Entero_Cero,
					Par_CuentaAhoID,	Aud_NumTransaccion,		Cadena_Vacia,			Decimal_Cero,				Entero_Cero,
					Par_TipoPersSAFI,	Var_SoloNombres,		Par_ApellidoPaterno,	Par_ApellidoMaterno,		Par_TipoListaID,
					Str_No,				Par_NumErr, 			Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

				IF(Par_NumErr!=Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES WHERE NumTransaccion = Aud_NumTransaccion LIMIT 1);

				IF(Par_TipoLista = Lista_PBloq)THEN
					IF(IFNULL(Var_OpeInusualID,Entero_Cero) != Entero_Cero)THEN
						SET Var_OpeInusualIDSPL:=(SELECT OpeInusualID FROM PLDSEGPERSONALISTAS WHERE OpeInusualID = Var_OpeInusualID);

						IF(IFNULL(Var_OpeInusualIDSPL,Entero_Cero) = Entero_Cero)THEN
							-- Damos de alta en la tabla de coincidencias de personas en listas e personas bloqueadas por el momento es para este tipo de lista
							CALL PLDSEGPERSONALISTASALT(
								Var_OpeInusualID,	Par_TipoPersSAFI,	Par_ClavePersonaInv,	Var_NombreComplet,	Var_FechaDeteccion,
								Con_LPB,			Var_SoloNombres,	Var_SoloApellidos,		Par_FechaNacimiento,Par_RFC,
								Par_PaisID,			Str_No,				Par_NumErr, 			Par_ErrMen,			Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
						END IF;
					END IF;
				END IF;
				-- Se inicializan las variables para el error por correo
				SET Var_NumErr := Entero_Cero;
				SET Var_ErrMen := Cadena_Vacia;

				-- Se registra la operacion inusual para que se envie una alerta por correo
				CALL PLDALERTAINUSPRO(
					Var_OpeInusualID,		Str_No,				Var_NumErr,			Var_ErrMen,				Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion );

				IF(Var_NumErr != Entero_Cero) THEN
					CALL BITACORAERRORNOTICAPLDALT(
						Var_OpeInusualID,	Var_NumErr,			Var_ErrMen,			Str_No,					Par_NumErr,
						Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
				END IF;

				INSERT INTO PLDCOINCIDENCIAS(
					ClavePersonaInv,			PersonaBloqID,			ListaNegraID,			TipoPersSAFI,			FechaDeteccion,
					HoraDeteccion,				OpeInusualID,			EmpresaID,				Usuario,				FechaActual,
					DireccionIP,				ProgramaID,				Sucursal,				NumTransaccion)
				VALUES(
					Par_ClavePersonaInv,
					IF(Par_TipoLista = Lista_PBloq,Par_ListaID,NULL),
					IF(Par_TipoLista = Lista_Negra,Par_ListaID,NULL),
					Par_TipoPersSAFI,			Var_FechaDeteccion,
					CURRENT_TIME(),				Var_OpeInusualID,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			END IF;

			IF(Par_TipoLista = Lista_PBloq)THEN
				SELECT
					OpeInusualID,		PermiteOperacion
				INTO
					Var_OpeInusualIDSPL,Var_PermiteOperacion
				FROM PLDSEGPERSONALISTAS
				WHERE OpeInusualID = Var_OpeInusualID;

				SET Var_PermiteOperacion := IFNULL(Var_PermiteOperacion,Cadena_Vacia);
			END IF;

			/** ERROR PLD, 50 SI ES DETECCIÓN EN LISTAS DE PERSONAS BLOQUEADAS
			 ** CERO SI ES EN LISTAS NEGRAS PARA QUE PUEDA CONTINUAR CON EL ALTA DEL CLIENTE.*/
			SET Par_NumErr	:= IF(Par_TipoLista = Lista_PBloq,50,Entero_Cero);

			IF(IFNULL(Par_TipoPersona,PersFisica)=PersMoral)THEN
				SET Par_ErrMen	:=CONCAT('Coincidencias Detectadas. La Persona se encuentra en ',IF(Par_TipoLista = Lista_PBloq,'Lista de Personas Bloqueadas.','Listas Negras.'));
			ELSE
				SET Par_ErrMen	:=CONCAT('Coincidencias Detectadas: ',Par_Coincidencias,'. La Persona se encuentra en ',IF(Par_TipoLista = Lista_PBloq,'Lista de Personas Bloqueadas.','Listas Negras.'));
			END IF;

			IF(Par_TipoLista = Lista_PBloq)THEN
				IF(Var_PermiteOperacion != Cadena_Vacia)THEN
					IF(Var_PermiteOperacion = Str_Si)THEN
						SET Par_NumErr	:= 00;
						SET Par_ErrMen	:='Operacion permitida desde Seguimiento de personas en listas.';
					END IF;
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
				IF(Par_TipoLista = Lista_PBloq,Entero_Cero,Par_ListaID) AS Consecutivo,
				'OpeInusualID' AS Control,
				Par_ListaID AS PersonaBloqID;
	END IF;

	IF(Par_TipoLista = Lista_PBloq)THEN
		IF(Par_Salida = Str_No) THEN
			SET Par_PersonaBloqID := Par_ListaID;
		END IF;
	END IF;

END TerminaStore$$

