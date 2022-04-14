
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDETECPERSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDETECPERSPRO`;

DELIMITER $$
CREATE PROCEDURE `PLDDETECPERSPRO`(
	/*SP PARA REALIZAR LA DETECCIÓN EN CLIENTES A UNA PERSONA QUE SE REGISTRA EN LISTAS NEGRAS O PERSONAS BLOQUEADAS*/
	Par_TipoLista				CHAR(1),			# N: Listas Negras B: Listas de Personas Bloqueadas
	Par_Masivo					CHAR(1),			# Indica si realiza la busqueda masiva en clientes. S:Si  N:No
	Par_SoloNombres				VARCHAR(500),		# Solo Nombres
	Par_SoloApellidos			VARCHAR(500),		# Solo Apellidos
	Par_NombresConocidos		VARCHAR(500),		# Nombres Conocidos

	Par_RFC						CHAR(13) ,			# RFC Persona Fisica
	Par_RFCm					CHAR(13) ,			# RFC Persona Moral
	Par_TipoPersona				CHAR(1),			# Tipo de Persona
	Par_RazonSocial				VARCHAR(150),		# Razon Social
	Par_FechaNac				DATE,				# Fecha de Nacimiento

	Par_PaisID					INT(11),			# Pais de Nacimiento
	Par_ListaPLDID				BIGINT(20),			# ID de la Lista
	Par_IDQEQ					VARCHAR(20),		# IDQEQ
	Par_NumeroOficio			VARCHAR(50),		# Numero de Oficio
	Par_EstadoID				INT(11),			# Estado

	Par_OrigenDeteccion			CHAR(1),			# Origen de la deteccion
	Par_TipoListaID				VARCHAR(45),		# Tipo de lista. CATTIPOLISTAPLD.
	Par_FechaAlta				DATE,				# Fecha de Alta
	Par_Salida					CHAR(1),			# Salida S:Si N:No
	INOUT Par_NumErr			INT(11),			# Numero de Error

	INOUT Par_ErrMen			VARCHAR(400),		# Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),			# Auditoria
	Aud_Usuario					INT(11),			# Auditoria
	Aud_FechaActual				DATETIME,			# Auditoria
	Aud_DireccionIP				VARCHAR(15),		# Auditoria

	Aud_ProgramaID				VARCHAR(50),		# Auditoria
	Aud_Sucursal				INT(11),			# Auditoria
	Aud_NumTransaccion			VARCHAR(20)			# Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(20);			-- Nombre del control de pantalla
	DECLARE Var_Consecutivo		VARCHAR(50);			-- Nombre del control de pantalla
	DECLARE Var_Coincidencias	INT(11);				-- Numero de Coincidencias
	DECLARE Var_FechaDeteccion	DATE;					-- Fecha de Detección.
	DECLARE Var_FechaAltaCarga	DATE;					-- Fecha de Carga de lista.
	DECLARE Var_ParamPorcen		INT(11);				-- Porcentaje de Detección.
	DECLARE Var_ActualizaPEP	CHAR(1);				-- Parámetro de Actualización PEP.
	DECLARE Var_TipoLista		INT(11);				-- Tipo de Lista para SP de alertas.

	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Salida_SI			CHAR(1);
	DECLARE Listas_Negras		CHAR(1);
	DECLARE Listas_Bloqueadas	CHAR(1);
	DECLARE PersFisica			CHAR(1);
	DECLARE PersFisActEmp		CHAR(1);
	DECLARE PersMoral			CHAR(1);
	DECLARE TipoListasNegras	CHAR(1);
	DECLARE TipoListaspBloq		CHAR(1);
	DECLARE ConstSI				CHAR(1);
	DECLARE ConstNO				CHAR(1);
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Estatus_Vigente		CHAR(1);
	DECLARE TipoCTE				CHAR(3);
	DECLARE TipoProveedor		CHAR(3);
	DECLARE Tipo_UsuarioServ	CHAR(3);
	DECLARE Tipo_Prospecto		CHAR(3);
	DECLARE Tipo_Aval			CHAR(3);
	DECLARE Tipo_RelCuenta		CHAR(3);
	DECLARE Tipo_ObligSol		CHAR(3);

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';					-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero				:= 0;					-- Entero Cero
	SET Salida_SI				:= 'S';					-- Salida Si
	SET Listas_Negras			:= 'N';					-- Tipo de Listas Negras
	SET Listas_Bloqueadas		:= 'B';					-- Tipo de Listas Bloqueadas
	SET PersFisica				:= 'F';					-- Tipo de Persona Fisica
	SET PersFisActEmp			:= 'A';					-- Tipo de Persona Fisica con Actividad Empresarial
	SET PersMoral				:= 'M';					-- Tipo de Persona Moral
	SET TipoListasNegras		:= 'N';					-- Listas Negras
	SET TipoListaspBloq			:= 'B';					-- Listas de Pers. Bloqueadas
	SET ConstSI					:= 'S';					-- SI
	SET ConstNO					:= 'N';					-- NO
	SET Estatus_Activo			:= 'A';					-- Estatus Activo
	SET Estatus_Vigente			:= 'V';					-- Estatus Vigente
	SET TipoCTE					:= 'CTE';				-- Tipo de Persona Cliente
	SET TipoProveedor			:= 'PRV';				-- Tipo de Persona Proveedor
	SET Tipo_UsuarioServ		:= 'USU';				-- Tipo de Persona Usuario de Servicio.
	SET Tipo_Prospecto			:= 'PRO';				-- Tipo de Persona Prospectos.
	SET Tipo_Aval				:= 'AVA';				-- Tipo de Persona Aval.
	SET Tipo_RelCuenta			:= 'REL';				-- Tipo de Persona Relacionados a la cuenta.
	SET Tipo_ObligSol			:= 'OBS';				-- Tipo de Persona Obligado solidario.
	SET Var_FechaDeteccion		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Aud_FechaActual			:= NOW();				-- Fecha Actual

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDDETECPERSPRO [',@Var_SQLState,'-' , @Var_SQLMessage,']');
			SET Var_Control:= 'sqlException';
		END;

	SET Var_ParamPorcen			:= (SELECT PorcCoincidencias FROM PARAMETROSSIS LIMIT 1);
	SET @Var_IDPLDDetectPers	:= (SELECT MAX(IDPLDDetectPers) FROM PLDDETECPERS);
	SET @Var_IDPLDDetectPers	:= IFNULL(@Var_IDPLDDetectPers, Entero_Cero);
	SET Par_RazonSocial			:= IFNULL(Par_RazonSocial, Cadena_Vacia);
	SET Par_RFCm				:= IFNULL(Par_RFCm, Cadena_Vacia);

	-- Busqueda individual en los procesos de alta en listas negras o de personas bloqueadas.
	IF(IFNULL(Par_Masivo,ConstNO)=ConstNO)THEN
		IF(Par_TipoPersona=PersFisica OR Par_TipoPersona=PersFisActEmp)THEN
			/* BÚSQUEDA EN CLIENTES */
			IF(Var_ParamPorcen=100) THEN
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			ClienteID,			NombreCompleto,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS PERS
				WHERE
					/*CASO 1: Nombres, Apellidos*/
					((SoloNombres LIKE Par_SoloNombres OR SoloNombres LIKE Par_NombresConocidos) AND SoloApellidos LIKE Par_SoloApellidos)
					OR
					/*CASO 2: Nombres, Apellidos, Pais-Estado*/
					((SoloNombres LIKE Par_SoloNombres OR SoloNombres LIKE Par_NombresConocidos) AND SoloApellidos LIKE Par_SoloApellidos AND (LugarNacimiento = Par_PaisID AND EstadoID = Par_EstadoID))
					OR
					/*CASO 3: Apellidos, FechaNac, Pais-Estado*/
					(SoloApellidos LIKE Par_SoloApellidos AND FechaNacimiento = Par_FechaNac AND LugarNacimiento = Par_PaisID AND EstadoID = Par_EstadoID)
					OR
					/*CASO 4: Nombres, FechaNac, Pais-Estado*/
					((SoloNombres LIKE Par_SoloNombres OR SoloNombres LIKE Par_NombresConocidos) AND FechaNacimiento = Par_FechaNac AND LugarNacimiento = Par_PaisID AND EstadoID = Par_EstadoID)
					OR
					/*CASO 5: Nombres, Apellidos, FechaNac*/
					((SoloNombres LIKE Par_SoloNombres OR SoloNombres LIKE Par_NombresConocidos) AND SoloApellidos LIKE Par_SoloApellidos AND FechaNacimiento = Par_FechaNac)
					AND PERS.Estatus = Estatus_Activo
					AND TipoPersona IN (PersFisica,PersFisActEmp);

				/* BÚSQUEDA EN USUARIOS DE SERVICIOS. */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					Tipo_UsuarioServ,	UsuarioServicioID,	NombreCompleto,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM USUARIOSERVICIO AS PERS
				WHERE
					/*CASO 1: Nombres, Apellidos*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos)
					OR
					/*CASO 2: Nombres, Apellidos, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND (PERS.PaisNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID))
					OR
					/*CASO 3: Apellidos, FechaNac, Pais-Estado*/
					(PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNacimiento = Par_FechaNac AND PERS.PaisNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID)
					OR
					/*CASO 4: Nombres, FechaNac, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.FechaNacimiento = Par_FechaNac AND PERS.PaisNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID)
					OR
					/*CASO 5: Nombres, Apellidos, FechaNac*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNacimiento = Par_FechaNac)
					AND PERS.Estatus = Estatus_Activo
					AND PERS.TipoPersona IN (PersFisica,PersFisActEmp);

				/* BÚSQUEDA EN PROSPECTOS. */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					Tipo_Prospecto,		ProspectoID,		NombreCompleto,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROSPECTOS AS PERS
				WHERE
					/*CASO 1: Nombres, Apellidos*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos)
					OR
					/*CASO 2: Nombres, Apellidos, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND (PERS.LugarNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID))
					OR
					/*CASO 3: Apellidos, FechaNac, Pais-Estado*/
					(PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNacimiento = Par_FechaNac AND PERS.LugarNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID)
					OR
					/*CASO 4: Nombres, FechaNac, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.FechaNacimiento = Par_FechaNac AND PERS.LugarNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID)
					OR
					/*CASO 5: Nombres, Apellidos, FechaNac*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNacimiento = Par_FechaNac)
					#AND PERS.Estatus = Estatus_Activo
					AND PERS.TipoPersona IN (PersFisica,PersFisActEmp);

				/* BÚSQUEDA EN AVALES. */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					Tipo_Aval,			AvalID,				NombreCompleto,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM AVALES AS PERS
				WHERE
					/*CASO 1: Nombres, Apellidos*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos)
					OR
					/*CASO 2: Nombres, Apellidos, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND (PERS.LugarNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID))
					OR
					/*CASO 3: Apellidos, FechaNac, Pais-Estado*/
					(PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNac = Par_FechaNac AND PERS.LugarNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID)
					OR
					/*CASO 4: Nombres, FechaNac, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.FechaNac = Par_FechaNac AND PERS.LugarNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID)
					OR
					/*CASO 5: Nombres, Apellidos, FechaNac*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNac = Par_FechaNac)
					#AND PERS.Estatus = Estatus_Activo
					AND PERS.TipoPersona IN (PersFisica,PersFisActEmp);

				/* BÚSQUEDA EN RELACIONADOS A LA CUENTA. */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion,		CuentaAhoID)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					Tipo_RelCuenta,		PersonaID,			NombreCompleto,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,	CuentaAhoID
				FROM CUENTASPERSONA AS PERS
				WHERE
					/*CASO 1: Nombres, Apellidos*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos)
					OR
					/*CASO 2: Nombres, Apellidos, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND (PERS.PaisNacimiento = Par_PaisID AND PERS.EdoNacimiento = Par_EstadoID))
					OR
					/*CASO 3: Apellidos, FechaNac, Pais-Estado*/
					(PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNac = Par_FechaNac AND PERS.PaisNacimiento = Par_PaisID AND PERS.EdoNacimiento = Par_EstadoID)
					OR
					/*CASO 4: Nombres, FechaNac, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.FechaNac = Par_FechaNac AND PERS.PaisNacimiento = Par_PaisID AND PERS.EdoNacimiento = Par_EstadoID)
					OR
					/*CASO 5: Nombres, Apellidos, FechaNac*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNac = Par_FechaNac)
					AND PERS.EstatusRelacion = Estatus_Vigente
					AND PERS.ClienteID = Entero_Cero;

				/* BÚSQUEDA EN OBLIGADOS SOLIDARIOS. */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					Tipo_ObligSol,		OblSolidID,			NombreCompleto,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM OBLIGADOSSOLIDARIOS AS PERS
				WHERE
					/*CASO 1: Nombres, Apellidos*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos)
					OR
					/*CASO 2: Nombres, Apellidos, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND (PERS.LugarNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID))
					OR
					/*CASO 3: Apellidos, FechaNac, Pais-Estado*/
					(PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNac = Par_FechaNac AND PERS.LugarNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID)
					OR
					/*CASO 4: Nombres, FechaNac, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.FechaNac = Par_FechaNac AND PERS.LugarNacimiento = Par_PaisID AND PERS.EstadoID = Par_EstadoID)
					OR
					/*CASO 5: Nombres, Apellidos, FechaNac*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNac = Par_FechaNac)
					AND PERS.TipoPersona IN (PersFisica,PersFisActEmp);

				/* BÚSQUEDA EN PROVEEDORES. */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoProveedor,		ProveedorID,		FNGENNOMBRECOMPLETO(PrimerNombre,SegundoNombre,'',ApellidoPaterno,ApellidoMaterno),		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROVEEDORES AS PERS
				WHERE
					/*CASO 1: Nombres, Apellidos*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos)
					OR
					/*CASO 2: Nombres, Apellidos, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND (PERS.PaisNacimiento = Par_PaisID AND PERS.EstadoNacimiento = Par_EstadoID))
					OR
					/*CASO 3: Apellidos, FechaNac, Pais-Estado*/
					(PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNacimiento = Par_FechaNac AND PERS.PaisNacimiento = Par_PaisID AND PERS.EstadoNacimiento = Par_EstadoID)
					OR
					/*CASO 4: Nombres, FechaNac, Pais-Estado*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.FechaNacimiento = Par_FechaNac AND PERS.PaisNacimiento = Par_PaisID AND PERS.EstadoNacimiento = Par_EstadoID)
					OR
					/*CASO 5: Nombres, Apellidos, FechaNac*/
					((PERS.SoloNombres LIKE Par_SoloNombres OR PERS.SoloNombres LIKE Par_NombresConocidos) AND PERS.SoloApellidos LIKE Par_SoloApellidos AND PERS.FechaNacimiento = Par_FechaNac)
					AND PERS.Estatus = Estatus_Activo
					AND PERS.TipoPersona IN (PersFisica,PersFisActEmp);
			ELSE
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			ClienteID,			NombreCompleto,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS PERS
				WHERE
					/*CASO 1: Nombres, Apellidos, RFC-FechaNac, Pais-Estado*/
					(((FNPORCENTAJEDIFF(Par_SoloNombres,SoloNombres)>= Var_ParamPorcen OR
						FNPORCENTAJEDIFF(Par_NombresConocidos,SoloNombres)>= Var_ParamPorcen)
						AND FNPORCENTAJEDIFF(Par_SoloApellidos,SoloApellidos)>= Var_ParamPorcen
						AND (RFC = Par_RFC AND FechaNacimiento = Par_FechaNac) AND (LugarNacimiento = Par_PaisID AND EstadoID = Par_EstadoID))
					OR
					/*CASO 2: Nombres, Apellidos, RFC-FechaNac*/
					((FNPORCENTAJEDIFF(Par_SoloNombres,SoloNombres)>= Var_ParamPorcen OR
						FNPORCENTAJEDIFF(Par_NombresConocidos,SoloNombres)>= Var_ParamPorcen)
						AND FNPORCENTAJEDIFF(Par_SoloApellidos,SoloApellidos)>= Var_ParamPorcen
						AND (RFC = Par_RFC AND FechaNacimiento = Par_FechaNac))
					OR
					/*CASO 3: Nombres, Apellidos, Pais-Estado*/
					((FNPORCENTAJEDIFF(Par_SoloNombres,SoloNombres)>= Var_ParamPorcen OR
						FNPORCENTAJEDIFF(Par_NombresConocidos,SoloNombres)>= Var_ParamPorcen)
						AND FNPORCENTAJEDIFF(Par_SoloApellidos,SoloApellidos)>= Var_ParamPorcen
						AND (LugarNacimiento = Par_PaisID AND EstadoID = Par_EstadoID))
					OR
					/*CASO 4: Nombres, RFC-FechaNac, Pais-Estado*/
					((FNPORCENTAJEDIFF(Par_SoloNombres,SoloNombres)>= Var_ParamPorcen OR
						FNPORCENTAJEDIFF(Par_NombresConocidos,SoloNombres)>= Var_ParamPorcen)
					AND (RFC = Par_RFC AND FechaNacimiento = Par_FechaNac)
					AND (LugarNacimiento = Par_PaisID AND EstadoID = Par_EstadoID))
					OR
					/*CASO 5: Apellidos, RFC-FechaNac, Pais-Estado*/
					(FNPORCENTAJEDIFF(Par_SoloApellidos,SoloApellidos)>= Var_ParamPorcen
					AND (RFC = Par_RFC AND FechaNacimiento = Par_FechaNac) AND (LugarNacimiento = Par_PaisID AND EstadoID = Par_EstadoID)))
					AND PERS.Estatus = Estatus_Activo
					AND TipoPersona IN (PersFisica,PersFisActEmp);
				END IF;
		ELSEIF(Par_TipoPersona = PersMoral) THEN
			IF(Var_ParamPorcen=100) THEN
				/* BÚSQUEDA EN CLIENTES */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			ClienteID,			RazonSocial,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS PERS
				WHERE
					/*CASO 1: RazonSocial, RFC*/
					((PERS.RazonSocial = Par_RazonSocial) OR (Par_RFCm != Cadena_Vacia AND PERS.RFCOficial = Par_RFCm))
					AND PERS.Estatus = Estatus_Activo
					AND TipoPersona IN (PersMoral);

				/* BÚSQUEDA EN USUARIOS SERVICIOS.*/
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					Tipo_UsuarioServ,	UsuarioServicioID,	RazonSocial,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM USUARIOSERVICIO AS PERS
				WHERE
					/*CASO 1: RazonSocial, RFC*/
					((PERS.RazonSocialPLD = Par_RazonSocial) OR (Par_RFCm != Cadena_Vacia AND PERS.RFCOficial = Par_RFCm))
					AND PERS.Estatus = Estatus_Activo
					AND PERS.TipoPersona IN (PersMoral);

				/* BÚSQUEDA EN PROSPECTOS.*/
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					Tipo_Prospecto,		ProspectoID,		RazonSocial,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROSPECTOS AS PERS
				WHERE
					/*CASO 1: RazonSocial, RFC*/
					((PERS.RazonSocialPLD = Par_RazonSocial) OR (Par_RFCm != Cadena_Vacia AND PERS.RFCpm = Par_RFCm))
					#AND PERS.Estatus = Estatus_Activo
					AND PERS.TipoPersona IN (PersMoral);

				/* BÚSQUEDA EN OBLIGADOS SOLIDARIOS.*/
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					Tipo_ObligSol,		OblSolidID,			RazonSocial,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM OBLIGADOSSOLIDARIOS AS PERS
				WHERE
					/*CASO 1: RazonSocial, RFC*/
					((PERS.RazonSocialPLD = Par_RazonSocial) OR (Par_RFCm != Cadena_Vacia AND PERS.RFCpm = Par_RFCm))
					#AND PERS.Estatus = Estatus_Activo
					AND PERS.TipoPersona IN (PersMoral);

				/* BÚSQUEDA EN PROVEEDORES.*/
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoProveedor,		ProveedorID,		RazonSocial,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROVEEDORES AS PERS
				WHERE
					/*CASO 1: RazonSocial, RFC*/
					((PERS.RazonSocialPLD = Par_RazonSocial) OR (Par_RFCm != Cadena_Vacia AND PERS.RFCpm = Par_RFCm))
					AND PERS.Estatus = Estatus_Activo
					AND PERS.TipoPersona IN (PersMoral);
			ELSE
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			ClienteID,			RazonSocial,		Par_TipoLista,		Var_FechaDeteccion,
					Par_ListaPLDID,		Par_IDQEQ,			Par_NumeroOficio,	Par_OrigenDeteccion,Par_FechaAlta,
					Par_TipoListaID,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS PERS
				WHERE
					/*CASO 1: RazonSocial, RFC*/
					(FNPORCENTAJEDIFF(Par_RazonSocial,PERS.RazonSocial)>= Var_ParamPorcen OR (Par_RFCm != Cadena_Vacia AND PERS.RFCOficial = Par_RFCm))
					AND PERS.Estatus = Estatus_Activo
					AND TipoPersona IN (PersMoral);
			END IF;
		END IF;

		# SOLO SI ES DETECCIÓN EN LISTAS NEGRAS.
		IF(Par_TipoLista = TipoListasNegras)THEN
			# SE CONSULTA EL PARÁMETRO SI SE ENCUENTRA ENCENDIDO (SI).
			SET Var_ActualizaPEP := LEFT(TRIM(FNPARAMGENERALES('ActClientePEPPLD')),1);
			SET Var_ActualizaPEP := IFNULL(Var_ActualizaPEP,ConstNO);

			# SI ESTA ENCENDIDO, SE EJECUTA LA ACTUALIZACIÓN MASIVA DE PEPS EN EL CONOCIMIENTO DE CTE.
			IF(Var_ActualizaPEP = ConstSI)THEN
				CALL CONOCIMIENTOCTEPRO(
					Par_TipoLista,		Par_Masivo,			Var_FechaAltaCarga,		ConstNO,			Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SET Var_Coincidencias := (SELECT COUNT(*) FROM PLDDETECPERS
									WHERE NumTransaccion 	= Aud_NumTransaccion
										AND TipoLista 		= Par_TipoLista);

		SET Par_NumErr := Entero_Cero;
		IF(Var_Coincidencias>Entero_Cero) THEN
			SET Var_TipoLista := IF(Par_TipoLista = Listas_Negras,1,2);
			CALL PLDGENALERTASINUSPRO(
				Aud_NumTransaccion,	Var_TipoLista,		ConstNO,			Par_NumErr,			Par_ErrMen,
				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			SET Par_ErrMen := CONCAT('<br>Existe uno o mas clientes registrados que coinciden con el nuevo registro.');
		ELSE
			SET Par_ErrMen := Cadena_Vacia;
		END IF;
		LEAVE ManejoErrores;
	END IF;

	-- Búsqueda masiva en todos los clientes y proveedores activos
	IF(IFNULL(Par_Masivo,ConstNO)=ConstSI)THEN
		-- Búsqueda en Listas Negras
		IF(IFNULL(Par_TipoLista,Cadena_Vacia)=TipoListasNegras)THEN
			SET Var_FechaAltaCarga := (SELECT FechaAlta FROM PLDLISTANEGRAS
										WHERE ProgramaID != '/microfin/listaNegrasVista.htm'
											ORDER by FechaActual DESC LIMIT 1);
			/* CUANDO EL PORCENTAJE DE COINCIDENCIAS ES DIFERENTE AL 100%*/
			IF(Var_ParamPorcen!=100) THEN
				/* BÚSQUEDA EN CLIENTES */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			Cli.ClienteID,		Cli.NombreCompleto,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.ListaNegraID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS Cli, PLDLISTANEGRAS AS PLD
				WHERE
					/*CASO 1: Nombres, Apellidos, RFC-FechaNac, Pais-Estado*/
					(((FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
					AND FNPORCENTAJEDIFF(Cli.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen
					AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento)
					AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
					OR
					/*CASO 2: Nombres, Apellidos, RFC-FechaNac*/
					((FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
					AND FNPORCENTAJEDIFF(Cli.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento))
					OR
					/*CASO 3: Nombres, Apellidos, Pais-Estado*/
					((FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
					AND FNPORCENTAJEDIFF(Cli.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
					OR
					/*CASO 4: Nombres, RFC-FechaNac, Pais-Estado*/
					((FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
					AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento)
					AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
					OR
					/*CASO 5: Apellidos, RFC-FechaNac, Pais-Estado*/
					(FNPORCENTAJEDIFF(Cli.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen
						AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento)
						AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
					OR
					/*CASO 6: Razon Social, RFC*/
					(FNPORCENTAJEDIFF(Cli.RazonSocial,PLD.RazonSocialPLD)>= Var_ParamPorcen
						OR (Cli.RFC = PLD.RFC))
					)
					AND Cli.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Cli.TipoPersona IN (PersFisica,PersFisActEmp)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listaNegrasVista.htm';

				/* BÚSQUEDA EN PROVEEDORES */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoProveedor,		Prov.ProveedorID,	FNGENNOMBRECOMPLETO(Prov.PrimerNombre,Prov.SegundoNombre,'',Prov.ApellidoPaterno,Prov.ApellidoMaterno),	Par_TipoLista,	Var_FechaDeteccion,
					PLD.ListaNegraID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROVEEDORES AS Prov, PLDLISTANEGRAS AS PLD
				WHERE
					/*CASO 1: Nombres, Apellidos, RFC-FechaNac, Pais-Estado*/
					(((FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
						AND (FNPORCENTAJEDIFF(Prov.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen)
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 2: Nombres, Apellidos, RFC-FechaNac*/
					((FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
						AND (FNPORCENTAJEDIFF(Prov.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen)
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento))
					OR
					/*CASO 3: Nombres, Apellidos, Pais-Estado*/
					((FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
						AND (FNPORCENTAJEDIFF(Prov.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 4: Nombres, RFC-FechaNac, Pais-Estado*/
					((FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 5: Apellidos, RFC-FechaNac, Pais-Estado*/
					(FNPORCENTAJEDIFF(Prov.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID)))
					AND Prov.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Prov.TipoPersona IN (PersFisica)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listaNegrasVista.htm';

				/* BÚSQUEDA EN CLIENTES
				 * Si el cliente es persona moral */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			Cli.ClienteID,		Cli.RazonSocial,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.ListaNegraID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS Cli, PLDLISTANEGRAS AS PLD
				WHERE
					/*CASO 1: RazonSocial o RFC*/
					(FNPORCENTAJEDIFF(Cli.RazonSocial,PLD.RazonSocial)>= Var_ParamPorcen OR Cli.RFCOficial = PLD.RFCm)
					AND Cli.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Cli.TipoPersona = PersMoral
					AND PLD.TipoPersona = PersMoral
					AND (PLD.RFCm IS NOT NULL OR PLD.RFCm != Cadena_Vacia)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listaNegrasVista.htm';

				/* BÚSQUEDA EN PROVEEDORES
				 * Proveedores personas morales */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoProveedor,		Prov.ProveedorID,	Prov.RazonSocial,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.ListaNegraID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROVEEDORES AS Prov, PLDLISTANEGRAS AS PLD
				WHERE
					/*CASO 1: RazonSocial o RFC*/
					(FNPORCENTAJEDIFF(Prov.RazonSocial,PLD.RazonSocial)>= Var_ParamPorcen OR Prov.RFCOficial = PLD.RFCm)
					AND Prov.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Prov.TipoPersona = PersMoral
					AND PLD.TipoPersona = PersMoral
					AND (PLD.RFCm IS NOT NULL OR PLD.RFCm != Cadena_Vacia)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listaNegrasVista.htm';
			END IF;-- IF PORCENTAJE != 100

			IF(Var_ParamPorcen = 100) THEN
				/* BÚSQUEDA EN CLIENTES
				 * Si el cliente es persona fisica o con actividad empresarial */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			Cli.ClienteID,		Cli.NombreCompleto,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.ListaNegraID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS Cli, PLDLISTANEGRAS AS PLD
				WHERE
					/*CASO 1: Nombres, Apellidos, RFC-FechaNac, Pais-Estado*/
					(((Cli.SoloNombres LIKE PLD.SoloNombres OR Cli.SoloNombres LIKE PLD.NombresConocidos) AND Cli.SoloApellidos LIKE PLD.SoloApellidos AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento) AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
					OR
					/*CASO 2: Nombres, Apellidos, RFC-FechaNac*/
					((Cli.SoloNombres LIKE PLD.SoloNombres OR Cli.SoloNombres LIKE PLD.NombresConocidos) AND Cli.SoloApellidos LIKE PLD.SoloApellidos AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento))
					OR
					/*CASO 3: Nombres, Apellidos, Pais-Estado*/
					((Cli.SoloNombres LIKE PLD.SoloNombres OR Cli.SoloNombres LIKE PLD.NombresConocidos) AND Cli.SoloApellidos LIKE PLD.SoloApellidos AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
					OR
					/*CASO 4: Nombres, RFC-FechaNac, Pais-Estado*/
					((Cli.SoloNombres LIKE PLD.SoloNombres OR Cli.SoloNombres LIKE PLD.NombresConocidos)
					AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento)
					AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
					OR
					/*CASO 5: Apellidos, RFC-FechaNac, Pais-Estado*/
					(Cli.SoloApellidos LIKE PLD.SoloApellidos AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento) AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID)))
					AND Cli.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Cli.TipoPersona IN (PersFisica,PersFisActEmp)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listaNegrasVista.htm';

				/* BÚSQUEDA EN PROVEEDORES
				 * Si el proveedor es persona fisica */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoProveedor,		Prov.ProveedorID,	FNGENNOMBRECOMPLETO(Prov.PrimerNombre,Prov.SegundoNombre,'',Prov.ApellidoPaterno,Prov.ApellidoMaterno),	Par_TipoLista,	Var_FechaDeteccion,
					PLD.ListaNegraID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROVEEDORES AS Prov, PLDLISTANEGRAS AS PLD
				WHERE
					/*CASO 1: Nombres, Apellidos, RFC-FechaNac, Pais-Estado*/
					(((Prov.SoloNombres LIKE PLD.SoloNombres OR Prov.SoloNombres LIKE PLD.NombresConocidos)
						AND (Prov.SoloApellidos LIKE PLD.SoloApellidos)
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 2: Nombres, Apellidos, RFC-FechaNac*/
					((Prov.SoloNombres LIKE PLD.SoloNombres OR Prov.SoloNombres LIKE PLD.NombresConocidos)
						AND (Prov.SoloApellidos LIKE PLD.SoloApellidos)
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento))
					OR
					/*CASO 3: Nombres, Apellidos, Pais-Estado*/
					((Prov.SoloNombres LIKE PLD.SoloNombres OR Prov.SoloNombres LIKE PLD.NombresConocidos)
						AND (Prov.SoloApellidos LIKE PLD.SoloApellidos)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 4: Nombres, RFC-FechaNac, Pais-Estado*/
					((Prov.SoloNombres LIKE PLD.SoloNombres OR Prov.SoloNombres LIKE PLD.NombresConocidos)
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 5: Apellidos, RFC-FechaNac, Pais-Estado*/
					(Prov.SoloApellidos LIKE PLD.SoloApellidos
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID)))
					AND Prov.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Prov.TipoPersona IN (PersFisica)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listaNegrasVista.htm';

				/* BÚSQUEDA EN CLIENTES
				 * Si el cliente es persona moral */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			Cli.ClienteID,		Cli.RazonSocial,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.ListaNegraID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS Cli, PLDLISTANEGRAS AS PLD
				WHERE
					/*CASO 1: RazonSocial o RFC*/
					(Cli.RazonSocial LIKE PLD.RazonSocial OR Cli.RFCOficial = PLD.RFCm)
					AND Cli.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Cli.TipoPersona = PersMoral
					AND PLD.TipoPersona = PersMoral
					AND (PLD.RFCm IS NOT NULL OR PLD.RFCm != Cadena_Vacia)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listaNegrasVista.htm';

				/* BÚSQUEDA EN PROVEEDORES
				 * Proveedores personas morales */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoProveedor,		Prov.ProveedorID,	Prov.RazonSocial,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.ListaNegraID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROVEEDORES AS Prov, PLDLISTANEGRAS AS PLD
				WHERE
					/*CASO 1: RazonSocial o RFC*/
					(Prov.RazonSocial LIKE PLD.RazonSocial OR Prov.RFCpm = PLD.RFCm)
					AND Prov.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Prov.TipoPersona = PersMoral
					AND PLD.TipoPersona = PersMoral
					AND (PLD.RFCm IS NOT NULL OR PLD.RFCm != Cadena_Vacia)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listaNegrasVista.htm';
			END IF;-- IF PORCENTAJE = 100

			# SE CONSULTA EL PARÁMETRO SI SE ENCUENTRA ENCENDIDO (SI).
			SET Var_ActualizaPEP := LEFT(TRIM(FNPARAMGENERALES('ActClientePEPPLD')),1);
			SET Var_ActualizaPEP := IFNULL(Var_ActualizaPEP,ConstNO);

			# SI ESTA ENCENDIDO, SE EJECUTA LA ACTUALIZACIÓN MASIVA DE PEPS EN EL CONOCIMIENTO DE CTE.
			IF(Var_ActualizaPEP = ConstSI)THEN
				CALL CONOCIMIENTOCTEPRO(
					Par_TipoLista,		Par_Masivo,			Var_FechaAltaCarga,		ConstNO,			Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		-- Búsqueda en Listas de Personas Bloqueadas
		IF(IFNULL(Par_TipoLista,Cadena_Vacia)=TipoListaspBloq)THEN
			SET Var_FechaAltaCarga := (SELECT FechaAlta FROM PLDLISTAPERSBLOQ
										WHERE ProgramaID != '/microfin/listasPersBVista.htm'
											ORDER by FechaActual DESC LIMIT 1);
			IF(Var_ParamPorcen != 100) THEN
			/* BÚSQUEDA EN CLIENTES
			 * Si el cliente es persona fisica o con actividad empresarial */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			Cli.ClienteID,		Cli.NombreCompleto,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.PersonaBloqID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS Cli, PLDLISTAPERSBLOQ AS PLD
				WHERE
						/*CASO 1: Nombres, Apellidos, RFC-FechaNac, Pais-Estado*/
						(((FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
							OR FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
							AND FNPORCENTAJEDIFF(Cli.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen
							AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento)
							AND (Cli.LugarNacimiento = PLD.PaisID
							AND Cli.EstadoID = PLD.EstadoID))
						OR
						/*CASO 2: Nombres, Apellidos, RFC-FechaNac*/
						((FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
							OR FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen) AND FNPORCENTAJEDIFF(Cli.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento))
						OR
						/*CASO 3: Nombres, Apellidos, Pais-Estado*/
						((FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
							OR FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen) AND FNPORCENTAJEDIFF(Cli.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
						OR
						/*CASO 4: Nombres, RFC-FechaNac, Pais-Estado*/
						((FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
							OR FNPORCENTAJEDIFF(Cli.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
						AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento)
						AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
						OR
						/*CASO 5: Apellidos, RFC-FechaNac, Pais-Estado*/
						(FNPORCENTAJEDIFF(Cli.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento) AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID)))
					AND Cli.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Cli.TipoPersona IN (PersFisica,PersFisActEmp)
					AND PLD.TipoPersona IN (PersFisica)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listasPersBVista.htm';

			/* BÚSQUEDA EN PROVEEDORES
			 * Proveedores personas físicas */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoProveedor,		Prov.ProveedorID,	FNGENNOMBRECOMPLETO(Prov.PrimerNombre,Prov.SegundoNombre,'',Prov.ApellidoPaterno,Prov.ApellidoMaterno),	Par_TipoLista,	Var_FechaDeteccion,
					PLD.PersonaBloqID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROVEEDORES AS Prov, PLDLISTAPERSBLOQ AS PLD
				WHERE
					/*CASO 1: Nombres, Apellidos, RFC-FechaNac, Pais-Estado*/
					(((FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
						AND (FNPORCENTAJEDIFF(Prov.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen)
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 2: Nombres, Apellidos, RFC-FechaNac*/
					((FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
						AND (FNPORCENTAJEDIFF(Prov.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen)
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento))
					OR
					/*CASO 3: Nombres, Apellidos, Pais-Estado*/
					((FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
						AND (FNPORCENTAJEDIFF(Prov.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 4: Nombres, RFC-FechaNac, Pais-Estado*/
					((FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.SoloNombres)>= Var_ParamPorcen
						OR FNPORCENTAJEDIFF(Prov.SoloNombres,PLD.NombresConocidos)>= Var_ParamPorcen)
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 5: Apellidos, RFC-FechaNac, Pais-Estado*/
					(FNPORCENTAJEDIFF(Prov.SoloApellidos,PLD.SoloApellidos)>= Var_ParamPorcen
						AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
						AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID)))
					AND Prov.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Prov.TipoPersona IN (PersFisica)
					AND PLD.TipoPersona IN (PersFisica)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listasPersBVista.htm';

			/* BÚSQUEDA EN CLIENTES
			 * Si el cliente es persona moral */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			Cli.ClienteID,		Cli.RazonSocial,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.PersonaBloqID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS Cli, PLDLISTAPERSBLOQ AS PLD
				WHERE
						/*CASO 1: RazonSocial o RFC*/
						(FNPORCENTAJEDIFF(Cli.RazonSocial,PLD.RazonSocial)>= Var_ParamPorcen OR Cli.RFCOficial = PLD.RFCm)
					AND Cli.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Cli.TipoPersona = PersMoral
					AND PLD.TipoPersona = PersMoral
					AND (PLD.RFCm IS NOT NULL OR PLD.RFCm != Cadena_Vacia)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listasPersBVista.htm';

			/* BÚSQUEDA EN PROVEEDORES
			 * Proveedores personas morales */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoProveedor,		Prov.ProveedorID,	Prov.RazonSocial,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.PersonaBloqID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROVEEDORES AS Prov, PLDLISTAPERSBLOQ AS PLD
				WHERE
					/*CASO 1: RazonSocial o RFC*/
					(FNPORCENTAJEDIFF(Prov.RazonSocial,PLD.RazonSocial)>= Var_ParamPorcen OR Prov.RFCOficial = PLD.RFCm)
					AND Prov.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Prov.TipoPersona = PersMoral
					AND PLD.TipoPersona = PersMoral
					AND (PLD.RFCm IS NOT NULL OR PLD.RFCm != Cadena_Vacia)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listasPersBVista.htm';
			END IF;-- IF PORCENTAJE != 100

			IF(Var_ParamPorcen = 100) THEN
				/* BÚSQUEDA EN CLIENTES
				 * Si el cliente es persona fisica o con actividad empresarial */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			Cli.ClienteID,		Cli.NombreCompleto,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.PersonaBloqID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS Cli, PLDLISTAPERSBLOQ AS PLD
				WHERE
					/*CASO 1: Nombres, Apellidos, RFC-FechaNac, Pais-Estado*/
					(((Cli.SoloNombres LIKE PLD.SoloNombres OR Cli.SoloNombres LIKE PLD.NombresConocidos) AND Cli.SoloApellidos LIKE PLD.SoloApellidos AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento) AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
					OR
					/*CASO 2: Nombres, Apellidos, RFC-FechaNac*/
					((Cli.SoloNombres LIKE PLD.SoloNombres OR Cli.SoloNombres LIKE PLD.NombresConocidos) AND Cli.SoloApellidos LIKE PLD.SoloApellidos AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento))
					OR
					/*CASO 3: Nombres, Apellidos, Pais-Estado*/
					((Cli.SoloNombres LIKE PLD.SoloNombres OR Cli.SoloNombres LIKE PLD.NombresConocidos) AND Cli.SoloApellidos LIKE PLD.SoloApellidos AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
					OR
					/*CASO 4: Nombres, RFC-FechaNac, Pais-Estado*/
					((Cli.SoloNombres LIKE PLD.SoloNombres OR Cli.SoloNombres LIKE PLD.NombresConocidos)
					AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento)
					AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID))
					OR
					/*CASO 5: Apellidos, RFC-FechaNac, Pais-Estado*/
					(Cli.SoloApellidos LIKE PLD.SoloApellidos AND (Cli.RFC = PLD.RFC AND Cli.FechaNacimiento = PLD.FechaNacimiento) AND (Cli.LugarNacimiento = PLD.PaisID AND Cli.EstadoID = PLD.EstadoID)))
					AND Cli.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Cli.TipoPersona IN (PersFisica,PersFisActEmp)
					AND PLD.TipoPersona IN (PersFisica)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listasPersBVista.htm';

				/* BÚSQUEDA EN PROVEEDORES
				 * Proveedores personas físicas */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoProveedor,		Prov.ProveedorID,	FNGENNOMBRECOMPLETO(Prov.PrimerNombre,Prov.SegundoNombre,'',Prov.ApellidoPaterno,Prov.ApellidoMaterno),	Par_TipoLista,	Var_FechaDeteccion,
					PLD.PersonaBloqID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROVEEDORES AS Prov, PLDLISTAPERSBLOQ AS PLD
				WHERE
					/*CASO 1: Nombres, Apellidos, RFC-FechaNac, Pais-Estado*/
					(((Prov.SoloNombres LIKE PLD.SoloNombres OR Prov.SoloNombres LIKE PLD.NombresConocidos)
					AND (Prov.SoloApellidos LIKE PLD.SoloApellidos)
					AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
					AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 2: Nombres, Apellidos, RFC-FechaNac*/
					((Prov.SoloNombres LIKE PLD.SoloNombres OR Prov.SoloNombres LIKE PLD.NombresConocidos)
					AND (Prov.SoloApellidos LIKE PLD.SoloApellidos)
					AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento))
					OR
					/*CASO 3: Nombres, Apellidos, Pais-Estado*/
					((Prov.SoloNombres LIKE PLD.SoloNombres OR Prov.SoloNombres LIKE PLD.NombresConocidos)
					AND (Prov.SoloApellidos LIKE PLD.SoloApellidos)
					AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 4: Nombres, RFC-FechaNac, Pais-Estado*/
					((Prov.SoloNombres LIKE PLD.SoloNombres OR Prov.SoloNombres LIKE PLD.NombresConocidos)
					AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
					AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID))
					OR
					/*CASO 5: Apellidos, RFC-FechaNac, Pais-Estado*/
					(Prov.SoloApellidos LIKE PLD.SoloApellidos
					AND (Prov.RFC = PLD.RFC AND Prov.FechaNacimiento = PLD.FechaNacimiento)
					AND (Prov.PaisNacimiento = PLD.PaisID AND Prov.EstadoNacimiento = PLD.EstadoID)))
					AND Prov.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Prov.TipoPersona IN (PersFisica)
					AND PLD.TipoPersona IN (PersFisica)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listasPersBVista.htm';

				/* BÚSQUEDA EN CLIENTES
				 * Si el cliente es persona moral */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoCTE,			Cli.ClienteID,		Cli.RazonSocial,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.PersonaBloqID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM CLIENTES AS Cli, PLDLISTAPERSBLOQ AS PLD
				WHERE
					/*CASO 1: RazonSocial o RFC*/
					(Cli.RazonSocial LIKE PLD.RazonSocial OR Cli.RFCOficial = PLD.RFCm)
					AND Cli.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Cli.TipoPersona = PersMoral
					AND PLD.TipoPersona = PersMoral
					AND (PLD.RFCm IS NOT NULL OR PLD.RFCm != Cadena_Vacia)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listasPersBVista.htm';

				/* BÚSQUEDA EN PROVEEDORES
				 * Proveedores personas morales */
				INSERT INTO PLDDETECPERS(
					IDPLDDetectPers,
					TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,		TipoLista,			FechaDeteccion,
					ListaPLDID,			IDQEQ,				NumeroOficio,		OrigenDeteccion,	FechaAlta,
					TipoListaID,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					(@Var_IDPLDDetectPers:= @Var_IDPLDDetectPers +1),
					TipoProveedor,		Prov.ProveedorID,	Prov.RazonSocial,	Par_TipoLista,		Var_FechaDeteccion,
					PLD.PersonaBloqID,	PLD.IDQEQ,			PLD.NumeroOficio,	Par_OrigenDeteccion,PLD.FechaAlta,
					PLD.TipoLista,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				FROM PROVEEDORES AS Prov, PLDLISTAPERSBLOQ AS PLD
				WHERE
					/*CASO 1: RazonSocial o RFC*/
					(Prov.RazonSocial LIKE PLD.RazonSocial OR Prov.RFCpm = PLD.RFCm)
					AND Prov.Estatus = Estatus_Activo
					AND PLD.Estatus = Estatus_Activo
					AND Prov.TipoPersona = PersMoral
					AND PLD.TipoPersona = PersMoral
					AND (PLD.RFCm IS NOT NULL OR PLD.RFCm != Cadena_Vacia)
					AND PLD.FechaAlta = Var_FechaAltaCarga
					AND PLD.ProgramaID  != '/microfin/listasPersBVista.htm';
			END IF;-- IF PORCENTAJE = 100
		END IF;

		SET Var_Coincidencias := (SELECT COUNT(*) FROM PLDDETECPERS
									WHERE NumTransaccion 	= Aud_NumTransaccion
										AND TipoLista 		= Par_TipoLista);
		SET Par_NumErr := Entero_Cero;
		IF(Var_Coincidencias>Entero_Cero) THEN
			SET Par_ErrMen := CONCAT('Existe(n) ',Var_Coincidencias,' Registro(s) que coincide(n) con la Nueva Carga.');
		ELSE
			SET Par_ErrMen := 'No se Encontraron Coincidencias.';
		END IF;

		LEAVE ManejoErrores;
	END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$

