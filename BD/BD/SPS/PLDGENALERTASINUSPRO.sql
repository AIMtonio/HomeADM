
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDGENALERTASINUSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDGENALERTASINUSPRO`;

DELIMITER $$
CREATE PROCEDURE `PLDGENALERTASINUSPRO`(
/** SP QUE GENERA ALERTAS INUSUALES CUANDO SE DETECTA COINCIDENCIA EN 
 ** EL PROCESO DE BÚSQUEDA DE COINCIDENCIAS.*/
	Par_NumTransaccion			BIGINT(20),		-- Número de Transacción del proceso de busqueda.
	Par_TipoLista				INT(11),		-- Tipo de lista 1: Listas Negras 2: Listas Pers.Bloq.
	Par_Salida					CHAR(1),		-- Tipo de Salida S. Si N. No
	INOUT Par_NumErr 			INT(11),		-- Numero de Error
	INOUT Par_ErrMen  			VARCHAR(400),	-- Mensaje de Error

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
DECLARE Var_ListaID				BIGINT(12);
DECLARE Var_TipoLista			CHAR(1);
DECLARE Var_TipoListaID			VARCHAR(45);
DECLARE Var_ClavePersonaInv		INT(11);
DECLARE Var_PrimerNombre		VARCHAR(50);
DECLARE Var_SegundoNombre		VARCHAR(50);
DECLARE Var_TercerNombre		VARCHAR(50);
DECLARE Var_ApellidoPaterno		VARCHAR(50);
DECLARE Var_ApellidoMaterno		VARCHAR(50);
DECLARE Var_RFC					CHAR(13);
DECLARE Var_FechaNacimiento		DATE;
DECLARE Var_NombreCompleto		VARCHAR(200);
DECLARE Var_CuentaAhoID			BIGINT(12);
DECLARE Var_PaisID				INT(11);
DECLARE Var_EstadoID			INT(11);
DECLARE Var_TipoPersSAFI		VARCHAR(3);
DECLARE Var_TipoPersona			CHAR(1);
DECLARE Var_TipoListaProc		CHAR(1);

DECLARE Var_TotalRegs			BIGINT(20);
DECLARE Var_TmpID				BIGINT(20);
DECLARE Var_TmpInicialID		BIGINT(20);
DECLARE Var_TmpFinalID			BIGINT(20);
DECLARE Var_Coincidencias		INT(11);
DECLARE Var_PersonaBloqID		BIGINT(12);


-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Decimal_Cero		DECIMAL;
DECLARE Entero_Cero			INT;
DECLARE Estatus_Activo		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Mayusculas			CHAR(2);
DECLARE PersActEmp			CHAR(1);
DECLARE PersFisica			CHAR(1);
DECLARE PersMoral 			CHAR(1);
DECLARE Str_No				CHAR(1);
DECLARE Str_Si				CHAR(1);
DECLARE	Lista_Negra			INT;
DECLARE	Lista_PBloq			INT;
DECLARE Con_LPB				CHAR(3);
DECLARE Tipo_Cliente		VARCHAR(3);
DECLARE Tipo_UsuarioServ	VARCHAR(3);
DECLARE Tipo_Prospecto		CHAR(3);
DECLARE Tipo_Aval			CHAR(3);
DECLARE Tipo_RelCuenta		CHAR(3);
DECLARE Tipo_ObligSol		CHAR(3);
DECLARE Tipo_Proveedor		CHAR(3);
DECLARE Total_Coinc			INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';				-- Cadena vacia
SET Decimal_Cero			:= 0.0;				-- DECIMAL Cero
SET Entero_Cero				:= 0;				-- Entero Cero
SET Estatus_Activo			:= 'A';				-- Estatus Activo
SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
SET Mayusculas				:= 'MA';			-- Obtener el resultado en Mayusculas
SET PersActEmp				:= 'A';				-- Tipo de persona fisica con actividad empresarial
SET PersFisica				:= 'F';				-- Tipo de persona fisica
SET PersMoral				:= 'M';				-- Tipo de persona moral
SET Str_No					:= 'N';				-- Constante no
SET Str_Si					:= 'S';				-- Constante si
SET Con_LPB					:= 'LPB';			-- Inidica que es de lista de personas bloqueadas
SET Lista_Negra				:= 1;				-- Tipo de Lista Negra
SET Lista_PBloq				:= 2;				-- Tipo de Lista Pers. Bloq.
SET Tipo_Cliente			:= 'CTE';			-- Tipo de Persona SAFI: Cliente.
SET Tipo_UsuarioServ		:= 'USU';			-- Tipo de Persona SAFI: Usuario de Servicios.
SET Tipo_Prospecto			:= 'PRO';			-- Tipo de Persona Prospectos.
SET Tipo_Aval				:= 'AVA';			-- Tipo de Persona Aval.
SET Tipo_RelCuenta			:= 'REL';			-- Tipo de Persona Relacionados a la cuenta.
SET Tipo_ObligSol			:= 'OBS';			-- Tipo de Persona Obligado solidario.
SET Tipo_Proveedor			:= 'PRV';			-- Tipo de Persona Proveedor

SET Total_Coinc				:= 3;				-- Número mínimo de coincidencias.
SET Aud_FechaActual			:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		GET DIAGNOSTICS condition 1
		@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDGENALERTASINUSPRO [',@Var_SQLState,'-' , @Var_SQLMessage,']');
		SET Var_Control := 'SQLEXCEPTION';
	END;

	# LIMPIEZA POR TRANSACCION.
	DELETE FROM TMPPLDDETCOINCINUS WHERE NumTransaccion = Par_NumTransaccion;

	SET Var_TipoListaProc := IF(Par_TipoLista = Lista_Negra,'N','B');

	# CLIENTES.
	INSERT INTO TMPPLDDETCOINCINUS(
		ListaPLDID,			TipoLista,			TipoListaID,		ClavePersonaInv,		PrimerNombre,
		SegundoNombre,		TercerNombre,		ApellidoPaterno,	ApellidoMaterno,		RFCOficial,
		FechaNacimiento,	NombreCompleto,		CuentaAhoID,		LugarNacimiento,		EstadoID,
		TipoPersonaSAFI,	TipoPersona,		NumTransaccion)
	SELECT
		PLD.ListaPLDID,		PLD.TipoLista,		PLD.TipoListaID,	PLD.ClavePersonaInv,	C.PrimerNombre,
		C.SegundoNombre,	C.TercerNombre,		C.ApellidoPaterno,	C.ApellidoMaterno,		C.RFCOficial,
		C.FechaNacimiento,	C.NombreCompleto,	Entero_Cero,		C.LugarNacimiento,		C.EstadoID,
		PLD.TipoPersonaSAFI,C.TipoPersona,		PLD.NumTransaccion
	FROM PLDDETECPERS PLD
		INNER JOIN CLIENTES C ON PLD.ClavePersonaInv = C.ClienteID AND PLD.TipoPersonaSAFI = Tipo_Cliente
	WHERE PLD.NumTransaccion = Par_NumTransaccion
		AND PLD.TipoLista = Var_TipoListaProc;

	# USUARIOS DE SERVICIOS.
	INSERT INTO TMPPLDDETCOINCINUS(
		ListaPLDID,			TipoLista,			TipoListaID,		ClavePersonaInv,		PrimerNombre,
		SegundoNombre,		TercerNombre,		ApellidoPaterno,	ApellidoMaterno,		RFCOficial,
		FechaNacimiento,	NombreCompleto,		CuentaAhoID,		LugarNacimiento,		EstadoID,
		TipoPersonaSAFI,	TipoPersona,		NumTransaccion)
	SELECT
		PLD.ListaPLDID,		PLD.TipoLista,		PLD.TipoListaID,	PLD.ClavePersonaInv,	C.PrimerNombre,
		C.SegundoNombre,	C.TercerNombre,		C.ApellidoPaterno,	C.ApellidoMaterno,		C.RFCOficial,
		C.FechaNacimiento,	C.NombreCompleto,	Entero_Cero,		C.PaisNacimiento,		C.EstadoID,
		PLD.TipoPersonaSAFI,C.TipoPersona,		PLD.NumTransaccion
	FROM PLDDETECPERS PLD
		INNER JOIN USUARIOSERVICIO C ON PLD.ClavePersonaInv = C.UsuarioServicioID AND PLD.TipoPersonaSAFI = Tipo_UsuarioServ
	WHERE PLD.NumTransaccion = Par_NumTransaccion
		AND PLD.TipoLista = Var_TipoListaProc;

	# PROSPECTOS
	INSERT INTO TMPPLDDETCOINCINUS(
		ListaPLDID,			TipoLista,			TipoListaID,		ClavePersonaInv,		PrimerNombre,
		SegundoNombre,		TercerNombre,		ApellidoPaterno,	ApellidoMaterno,		RFCOficial,
		FechaNacimiento,	NombreCompleto,		CuentaAhoID,		LugarNacimiento,		EstadoID,
		TipoPersonaSAFI,	TipoPersona,		NumTransaccion)
	SELECT
		PLD.ListaPLDID,		PLD.TipoLista,		PLD.TipoListaID,	PLD.ClavePersonaInv,	C.PrimerNombre,
		C.SegundoNombre,	C.TercerNombre,		C.ApellidoPaterno,	C.ApellidoMaterno,		IF(C.TipoPersona='M',C.RFCpm,C.RFC),
		C.FechaNacimiento,	C.NombreCompleto,	Entero_Cero,		C.LugarNacimiento,		C.EstadoID,
		PLD.TipoPersonaSAFI,C.TipoPersona,		PLD.NumTransaccion
	FROM PLDDETECPERS PLD
		INNER JOIN PROSPECTOS C ON PLD.ClavePersonaInv = C.ProspectoID AND PLD.TipoPersonaSAFI = Tipo_Prospecto
	WHERE PLD.NumTransaccion = Par_NumTransaccion
		AND PLD.TipoLista = Var_TipoListaProc;

	# AVALES
	INSERT INTO TMPPLDDETCOINCINUS(
		ListaPLDID,			TipoLista,			TipoListaID,		ClavePersonaInv,		PrimerNombre,
		SegundoNombre,		TercerNombre,		ApellidoPaterno,	ApellidoMaterno,		RFCOficial,
		FechaNacimiento,	NombreCompleto,		CuentaAhoID,		LugarNacimiento,		EstadoID,
		TipoPersonaSAFI,	TipoPersona,		NumTransaccion)
	SELECT
		PLD.ListaPLDID,		PLD.TipoLista,		PLD.TipoListaID,	PLD.ClavePersonaInv,	C.PrimerNombre,
		C.SegundoNombre,	C.TercerNombre,		C.ApellidoPaterno,	C.ApellidoMaterno,		IF(C.TipoPersona='M',C.RFCpm,C.RFC),
		C.FechaNac,			C.NombreCompleto,	Entero_Cero,		C.LugarNacimiento,		C.EstadoID,
		PLD.TipoPersonaSAFI,C.TipoPersona,		PLD.NumTransaccion
	FROM PLDDETECPERS PLD
		INNER JOIN AVALES C ON PLD.ClavePersonaInv = C.AvalID AND PLD.TipoPersonaSAFI = Tipo_Aval
	WHERE PLD.NumTransaccion = Par_NumTransaccion
		AND PLD.TipoLista = Var_TipoListaProc;

	# CUENTASPERSONA
	INSERT INTO TMPPLDDETCOINCINUS(
		ListaPLDID,			TipoLista,			TipoListaID,		ClavePersonaInv,		PrimerNombre,
		SegundoNombre,		TercerNombre,		ApellidoPaterno,	ApellidoMaterno,		RFCOficial,
		FechaNacimiento,	NombreCompleto,		CuentaAhoID,		LugarNacimiento,		EstadoID,
		TipoPersonaSAFI,	TipoPersona,		NumTransaccion)
	SELECT
		PLD.ListaPLDID,		PLD.TipoLista,		PLD.TipoListaID,	PLD.ClavePersonaInv,	C.PrimerNombre,
		C.SegundoNombre,	C.TercerNombre,		C.ApellidoPaterno,	C.ApellidoMaterno,		C.RFC,
		C.FechaNac,			C.NombreCompleto,	C.CuentaAhoID,		C.PaisNacimiento,		C.EdoNacimiento,
		PLD.TipoPersonaSAFI,'F',		PLD.NumTransaccion
	FROM PLDDETECPERS PLD
		INNER JOIN CUENTASPERSONA C ON PLD.ClavePersonaInv = C.PersonaID AND PLD.CuentaAhoID = C.CuentaAhoID AND PLD.TipoPersonaSAFI = Tipo_RelCuenta
	WHERE PLD.NumTransaccion = Par_NumTransaccion
		AND PLD.TipoLista = Var_TipoListaProc;

	# OBLIGADOS SOLIDARIOS
	INSERT INTO TMPPLDDETCOINCINUS(
		ListaPLDID,			TipoLista,			TipoListaID,		ClavePersonaInv,		PrimerNombre,
		SegundoNombre,		TercerNombre,		ApellidoPaterno,	ApellidoMaterno,		RFCOficial,
		FechaNacimiento,	NombreCompleto,		CuentaAhoID,		LugarNacimiento,		EstadoID,
		TipoPersonaSAFI,	TipoPersona,		NumTransaccion)
	SELECT
		PLD.ListaPLDID,		PLD.TipoLista,		PLD.TipoListaID,	PLD.ClavePersonaInv,	C.PrimerNombre,
		C.SegundoNombre,	C.TercerNombre,		C.ApellidoPaterno,	C.ApellidoMaterno,		IF(C.TipoPersona='M',C.RFCpm,C.RFC),
		C.FechaNac,			C.NombreCompleto,	Entero_Cero,		C.LugarNacimiento,		C.EstadoID,
		PLD.TipoPersonaSAFI,C.TipoPersona,		PLD.NumTransaccion
	FROM PLDDETECPERS PLD
		INNER JOIN OBLIGADOSSOLIDARIOS C ON PLD.ClavePersonaInv = C.OblSolidID AND PLD.TipoPersonaSAFI = Tipo_ObligSol
	WHERE PLD.NumTransaccion = Par_NumTransaccion
		AND PLD.TipoLista = Var_TipoListaProc;

	# PROVEEDORES
	INSERT INTO TMPPLDDETCOINCINUS(
		ListaPLDID,			TipoLista,			TipoListaID,		ClavePersonaInv,		PrimerNombre,
		SegundoNombre,		TercerNombre,		ApellidoPaterno,	ApellidoMaterno,		RFCOficial,
		FechaNacimiento,	NombreCompleto,		CuentaAhoID,		LugarNacimiento,		EstadoID,
		TipoPersonaSAFI,	TipoPersona,		NumTransaccion)
	SELECT
		PLD.ListaPLDID,		PLD.TipoLista,		PLD.TipoListaID,	PLD.ClavePersonaInv,	C.PrimerNombre,
		C.SegundoNombre,	Cadena_Vacia,		C.ApellidoPaterno,	C.ApellidoMaterno,		IF(C.TipoPersona='M',C.RFCpm,C.RFC),
		C.FechaNacimiento,	PLD.NombreCompleto,	Entero_Cero,		C.PaisNacimiento,		C.EstadoNacimiento,
		PLD.TipoPersonaSAFI,C.TipoPersona,		PLD.NumTransaccion
	FROM PLDDETECPERS PLD
		INNER JOIN PROVEEDORES C ON PLD.ClavePersonaInv = C.ProveedorID AND PLD.TipoPersonaSAFI = Tipo_Proveedor
	WHERE PLD.NumTransaccion = Par_NumTransaccion
		AND PLD.TipoLista = Var_TipoListaProc;

	SELECT
		MIN(PLD.Aut_TmpID),	MAX(PLD.Aut_TmpID),	COUNT(PLD.Aut_TmpID)
	INTO
		Var_TmpInicialID,	Var_TmpFinalID,		Var_TotalRegs
	FROM TMPPLDDETCOINCINUS PLD
	WHERE PLD.NumTransaccion = Par_NumTransaccion
		AND PLD.TipoLista = Var_TipoListaProc;

	SET Var_TmpInicialID:= IFNULL(Var_TmpInicialID,Entero_Cero);
	SET Var_TmpFinalID	:= IFNULL(Var_TmpFinalID,Entero_Cero);
	SET Var_TotalRegs	:= IFNULL(Var_TotalRegs,Entero_Cero);

	# SI EXISTEN REGISTROS.
	IF(Var_TotalRegs > Entero_Cero)THEN
		SET Var_TmpID	:= Var_TmpInicialID;

		WHILE(Var_TmpID <= Var_TmpFinalID)DO
			# INICIALIZACIÓN DE VARIABLES.
			SET Var_ListaID				:= Entero_Cero;		SET Var_TipoLista			:= Cadena_Vacia;
			SET Var_TipoListaID			:= Cadena_Vacia;	SET Var_ClavePersonaInv		:= Entero_Cero;
			SET Var_PrimerNombre		:= Cadena_Vacia;	SET Var_SegundoNombre		:= Cadena_Vacia;
			SET Var_TercerNombre		:= Cadena_Vacia;	SET Var_ApellidoPaterno		:= Cadena_Vacia;
			SET Var_ApellidoMaterno		:= Cadena_Vacia;	SET Var_RFC					:= Cadena_Vacia;
			SET Var_FechaNacimiento		:= Fecha_Vacia;		SET Var_NombreCompleto		:= Cadena_Vacia;
			SET Var_CuentaAhoID			:= Entero_Cero;		SET Var_PaisID				:= Entero_Cero;
			SET Var_EstadoID			:= Entero_Cero;		SET Var_TipoPersSAFI		:= Cadena_Vacia;
			SET Var_Coincidencias		:= Entero_Cero;		SET Var_PersonaBloqID		:= Entero_Cero;
			SET Var_TipoPersona			:= Cadena_Vacia;

			# SETEO CON LOS VALORES DE LA TABLA.
			SELECT
				PLD.ListaPLDID,			PLD.TipoLista,		PLD.TipoListaID,		PLD.ClavePersonaInv,	PLD.PrimerNombre,
				PLD.SegundoNombre,		PLD.TercerNombre,	PLD.ApellidoPaterno,	PLD.ApellidoMaterno,	PLD.RFCOficial,
				PLD.FechaNacimiento,	PLD.NombreCompleto,	PLD.CuentaAhoID,		PLD.LugarNacimiento,	PLD.EstadoID,
				PLD.TipoPersonaSAFI,	PLD.TipoPersona
			INTO
				Var_ListaID,			Var_TipoLista,		Var_TipoListaID,		Var_ClavePersonaInv,	Var_PrimerNombre,
				Var_SegundoNombre,		Var_TercerNombre,	Var_ApellidoPaterno,	Var_ApellidoMaterno,	Var_RFC,
				Var_FechaNacimiento,	Var_NombreCompleto,	Var_CuentaAhoID,		Var_PaisID,				Var_EstadoID,
				Var_TipoPersSAFI,		Var_TipoPersona
			FROM TMPPLDDETCOINCINUS PLD
			WHERE PLD.Aut_TmpID = Var_TmpID
				AND PLD.NumTransaccion = Par_NumTransaccion;

			# SI EXISTE EL REGISTRO.
			IF(Var_ListaID != Entero_Cero)THEN
				# GENERACIÓN DE ALERTAS INUSUALES.
				CALL PLDDETECLISTASLVPRO(
					Var_ListaID,			Par_TipoLista,		Var_TipoListaID,		Var_ClavePersonaInv,	Var_PrimerNombre,
					Var_SegundoNombre,		Var_TercerNombre,	Var_ApellidoPaterno,	Var_ApellidoMaterno,	Var_RFC,
					Var_FechaNacimiento,	Var_NombreCompleto,	Var_CuentaAhoID,		Var_PaisID,				Var_EstadoID,
					Var_TipoPersSAFI,		Var_TipoPersona,	Str_No,					Par_NumErr, 			Par_ErrMen,
					Var_Coincidencias,		Var_PersonaBloqID,	Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP, 		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				# SI EXISTE UN ERROR, SE ALMACENA EN LA BITÁCORA DE ERRORES.
				IF(Par_NumErr!=Entero_Cero)THEN
					INSERT INTO BITPLDDETCOINCINUS(
						ListaPLDID,			TipoLista,			TipoListaID,		ClavePersonaInv,		TipoPersonaSAFI,
						NumErr,				ErrMen,				EmpresaID,			Usuario,				FechaActual,
						DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES (
						Var_ListaID,		Var_TipoLista,		Var_TipoListaID,	Var_ClavePersonaInv,	Var_TipoPersSAFI,
						Par_NumErr, 		Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				END IF;
			END IF;

			SET Var_TmpID	:= (Var_TmpID + 1);
		END WHILE;
	END IF;

	# LIMPIEZA POR TRANSACCION.
	DELETE FROM TMPPLDDETCOINCINUS WHERE NumTransaccion = Par_NumTransaccion;

	SET Par_NumErr	:= 00;
	SET Par_ErrMen	:= CONCAT('Proceso Terminado Exitosamente: ',Aud_NumTransaccion,'.');

END ManejoErrores;

	IF(Par_Salida=Str_Si)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Aud_NumTransaccion AS Consecutivo,
				'OpeInusualID' AS Control;
	END IF;

END TerminaStore$$

