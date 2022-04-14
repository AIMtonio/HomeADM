-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDETECGAFIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDETECGAFIPRO`;

DELIMITER $$
CREATE PROCEDURE `PLDDETECGAFIPRO`(
	/*PROCESO QUE DETECTA SI EL PAIS DEL INVOLUCRADO SE ENCUENTRA DENTRO DEL CATALOGO DE LOS PAISES DE LA GAFI, SI ES ASI LO REPORTA COMO OP INUSUAL 24 HRS*/
	Par_ClavePersonaInv		INT(11),		# Numero de Cliente o Usuario de Servicios Modificado, cero si es en el alta
	Par_PaisID				INT(11),		# ID del Pais
	Par_PrimerNombre		VARCHAR(50),	# Primer Nombre
	Par_SegundoNombre		VARCHAR(50),	# Segundo Nombre
	Par_TercerNombre		VARCHAR(50),	# Tercer Nombre

	Par_ApellidoPaterno		VARCHAR(50),	# Apellido Paterno
	Par_ApellidoMaterno		VARCHAR(50),	# Apellido Materno
	Par_TipoPersona			CHAR(1),		# F. Fisica A. Fisica con Act Empresarial M. Moral
	Par_RazonSocial			VARCHAR(150),	# Razon social
	Par_TipoPersSAFI		VARCHAR(3),		# CTE. Cliente USU. Usuario de Servicios AVA Aval PRO NA. No Aplica

	Par_Salida				CHAR(1),		# Tipo de Salida S. Si N. No
	INOUT	Par_NumErr 		INT(11),		# Numero de Error
	INOUT	Par_ErrMen  	VARCHAR(400),	# Mensaje de Error

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);				# Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;					# Fecha Vacia
	DECLARE	Entero_Cero				INT;					# Entero Cero
	DECLARE	Decimal_Cero			DECIMAL;				# Decimal Cero
	DECLARE DescPaisNoCooperante	VARCHAR(30);			# Pais No cooperante
	DECLARE DescPaisPorIntegrar		VARCHAR(30);			# Pais por Integrarse
	DECLARE	TipoNoCoop				CHAR(1);				# Tipo de Lista No Cooperante
	DECLARE	TipoMejora				CHAR(1);				# Tipo de Lista en Mejora
	DECLARE CatProcIntID			VARCHAR(10); 			# ID del Procesos Internos
	DECLARE	CatMotivInusualID		VARCHAR(15); 			# ID del Motivo Inusual
	DECLARE	ClavePersonaInv			INT;					# Clave de la persona involucrada
	DECLARE	DescripOpera			VARCHAR(52);			# Descripcion de la operacion
	DECLARE	DescripOPMod			VARCHAR(52);			# Descripcion por modificacion
	DECLARE	TipoOperaAlt			INT;					# Tipo de Operacion de alta
	DECLARE	ClaveRegistra			CHAR(2);				# Clave de Registro
	DECLARE	RegistraSAFI			CHAR(4);				# Clave de Registro Interno SAFI
	DECLARE	Str_No					CHAR(1);				# Constante SI
	DECLARE	Str_Si					CHAR(1);				# Constante NO
	DECLARE Mayusculas				CHAR(2);				# Tipo Mayusculas para limpieza de cadenas
	DECLARE	PersFisica				CHAR(1);				# Tipo de Persona Fisica
	DECLARE	PersActEmp				CHAR(1);				# Tipo de persona fisica con act empresarial
	DECLARE	PersMoral 				CHAR(1);				# Tipo de persona moral

	-- Declaracion de Variables
	DECLARE Var_TipoPais		CHAR(1);					# Tipo de Catalogo: M: Por Integrarse (En Mejora), N: No cooperante
	DECLARE Var_PaisID			INT(11);					# ID del Pais
	DECLARE Var_NombrePais		VARCHAR(150);				# Nombre del pais
	DECLARE Var_DesOperacion	VARCHAR(300);				# Descripcion de la operacion
	DECLARE Var_FechaDeteccion	DATE;						# Fecha de Deteccion
	DECLARE Var_NombreComplet	VARCHAR(200);				# Nombre completo
	DECLARE Var_OpeInusualID	BIGINT(20);					# ID de la operacion inusual
	DECLARE Var_SoloNombres		VARCHAR(150);				# Solo guarda los tres nombres
	DECLARE Var_TipoPersona		CHAR(1);					# tipo de persona
	DECLARE Var_RazonSocial		VARCHAR(150);				# razon social
	DECLARE	Var_RFCpm			VARCHAR(13);				# RFC de persona moral
	DECLARE Var_Control			VARCHAR(50);				# Nombre del control en pantalla
	DECLARE Var_NumErr 			INT(11);					-- Variable usada para la bitacora de fallos de pld
	DECLARE Var_ErrMen 			TEXT;						-- Variable usada para la bitacora de fallos de pld


	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';				-- Cadena vacia
	SET	Fecha_Vacia					:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero					:= 0;				-- Entero Cero
	SET DescPaisNoCooperante		:= 'PAISES NO COOPERANTES GAFI';
	SET DescPaisPorIntegrar			:= 'PAISES POR INTEGRARSE GAFI';
	SET	TipoNoCoop					:= 'N';					# Tipo de Pais No Cooperante
	SET	TipoMejora					:= 'M'; 				# Tipo de Pais en Mejora
	SET Decimal_Cero				:= 0.0;				-- Decimal Cero
	SET	CatProcIntID				:='PR-SIS-000';		-- Clave interna Tabla catalogo PLDCATPROCEDINT: PROCEDIMIENTOS AUTOMATICO DE ALERTAS
	SET	CatMotivInusualID			:='PAISES';			-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU
	SET	DescripOpera				:='PAISES GAFI';	-- Comentario en operaciones de alta o modificacion de clientes
	SET	TipoOperaAlt				:= 10;				-- Tipo de Operacion Alta
	SET	ClaveRegistra				:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
	SET	RegistraSAFI				:= 'SAFI';			-- Clave que registra la operacion
	SET	Str_No						:= 'N';				-- Constante no
	SET	Str_Si						:= 'S';				-- Constante si
	SET	PersFisica					:= 'F';				-- Tipo de persona fisica
	SET	PersActEmp					:= 'A';				-- Tipo de persona fisica con actividad empresarial
	SET	PersMoral					:= 'M';				-- Tipo de persona moral
	-- Asignacion de Variable
	SET Var_FechaDeteccion		:= (SELECT FechaSistema FROM PARAMETROSSIS);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDDETECGAFIPRO');
			SET Var_Control := 'sqlException';
		END;

		SET Par_PrimerNombre 		:= TRIM(Par_PrimerNombre);
		SET Par_SegundoNombre 		:= TRIM(Par_SegundoNombre);
		SET Par_TercerNombre 		:= TRIM(Par_TercerNombre);
		SET Par_ApellidoPaterno 	:= TRIM(Par_ApellidoPaterno);
		SET Par_ApellidoMaterno 	:= TRIM(Par_ApellidoMaterno);
		SET Par_RazonSocial 		:= TRIM(Par_RazonSocial);
		SET Var_NombreComplet 		:= IF(Par_TipoPersona = PersMoral, Par_RazonSocial, FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Par_TercerNombre,Par_ApellidoPaterno,Par_ApellidoMaterno));
		SET Var_SoloNombres 		:= FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Par_TercerNombre,Cadena_Vacia,Cadena_Vacia);

		SELECT
			PaisID,			Nombre,				TipoPais
			INTO
			Var_PaisID,		Var_NombrePais,		Var_TipoPais
			FROM CATPAISESGAFI
				WHERE PaisID = Par_PaisID;

		SET Var_PaisID			:= IFNULL(Var_PaisID,Entero_Cero);

		IF(Var_PaisID != Entero_Cero) THEN
			SET Var_DesOperacion := CONCAT(IF(Var_TipoPais = TipoMejora,DescPaisPorIntegrar,DescPaisNoCooperante),': ',Var_PaisID,' - ',Var_NombrePais);
			SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES
										WHERE Fecha=Var_FechaDeteccion
											AND FechaDeteccion = Var_FechaDeteccion
											AND ClaveRegistra=ClaveRegistra
											AND NombreReg = RegistraSAFI
											AND CatProcedIntID = CatProcIntID
											AND CatMotivInuID = CatMotivInusualID
											AND NomPersonaInv = Var_NombreComplet
											AND DesOperacion = Var_DesOperacion LIMIT 1);

				-- Si ya se detecto anteriormente, ya no se vuelve a registrar como operacion inusual
				IF(IFNULL(Var_OpeInusualID,Entero_Cero)=Entero_Cero)THEN
					CALL PLDOPEINUSUALESALT(
						CatProcIntID,		CatMotivInusualID,		Var_FechaDeteccion,		Par_ClavePersonaInv,		Var_NombreComplet,
						Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Var_DesOperacion,			Entero_Cero,
						Entero_Cero,		Aud_NumTransaccion,		Cadena_Vacia,			Decimal_Cero,				Entero_Cero,
						Par_TipoPersSAFI,	Var_SoloNombres,		Par_ApellidoPaterno,	Par_ApellidoMaterno,		Cadena_Vacia,Str_No,
						Par_NumErr, 		Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,
						Aud_DireccionIP, 	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion );

					SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES
												WHERE Fecha=Var_FechaDeteccion
													AND FechaDeteccion = Var_FechaDeteccion
													AND ClaveRegistra=ClaveRegistra
													AND NombreReg = RegistraSAFI
													AND CatProcedIntID = CatProcIntID
													AND CatMotivInuID = CatMotivInusualID
													AND NomPersonaInv = Var_NombreComplet
													AND DesOperacion = Var_DesOperacion LIMIT 1);

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

				END IF;
				SET Par_NumErr	:= IF(Var_TipoPais=TipoMejora,0,01);
				SET Par_ErrMen	:= CONCAT('El Pais de Nacimiento se encontro en los ',Var_DesOperacion,'.');
		ELSE
			SET Par_NumErr	:= 0;
			SET Par_ErrMen	:='Puede Continuar con el Proceso.';
		END IF;

END ManejoErrores;

IF(Par_Salida=Str_Si)THEN
	SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_OpeInusualID AS Consecutivo,
			'OpeInusualID' AS Control;
END IF;

END TerminaStore$$