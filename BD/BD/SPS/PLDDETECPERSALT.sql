
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------

-- PLDDETECPERSALT

DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDETECPERSALT`;

DELIMITER $$
CREATE PROCEDURE `PLDDETECPERSALT`(
/* SP DE ALTA DE PERSONAS DETECTADAS POR PROCESO MASIVO DE BÚSQUEDA DE COINCIDENCIAS. */
	Par_TipoPersonaSAFI			VARCHAR(3),			-- Tipo de la persona involucrada CTE.- Cliente USU.- Usuario de Servicios AVA.- Avales PRO.- Prospectos REL.-  Relacionados de la cuenta (Que no son socios/clientes) NA.- No Aplica (cuando no se trata de Clientes ni de Usuarios)
	Par_ClavePersonaInv			INT(11),			-- ID o Clave de la Persona Involucrada
	Par_NombreCompleto			VARCHAR(250),		-- Nombre completo de la persona
	Par_TipoLista				CHAR(1),			-- Tipo de Lista PLD  N: Listas Negras  B: Listas Pers. Bloqueadas
	Par_ListaPLDID				BIGINT(12),			-- Id que corresponde a las tablas de PLDLISTANEGRAS, PLDLISTAPERSBLOQ dependiendo del tipo de Lista.

	Par_IDQEQ					VARCHAR(20),		-- ID del catalogo de Quien es Quien
	Par_NumeroOficio			VARCHAR(50),		-- Numero de Oficio. Este campo no es obligatorio y por default es 0.
	Par_OrigenDeteccion			CHAR(1),			-- Origen de la Deteccion. P.- Pantallas C.- Carga Masiva
	Par_FechaAlta				DATE,				-- Fecha de Registro en la listas Negras / Personas Bloq.
	Par_TipoListaID				VARCHAR(45),		-- Subtipo de lista: PEP, SAT, OFAC, ETC. Corresponde al catálogo CATTIPOLISTAPLD.

	Par_Salida           		CHAR(1),			-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT,				-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),		-- Mensaje de Error
    /* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),

	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control			CHAR(15);
DECLARE Var_FechaSistema	DATE;

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Str_SI			CHAR(1);
DECLARE	Str_NO			CHAR(1);
DECLARE Es_Cliente		VARCHAR(3);
DECLARE Es_Usuario		VARCHAR(3);
DECLARE Es_Usuario2		VARCHAR(3);
DECLARE Es_Aval			VARCHAR(3);
DECLARE Es_Prospecto	VARCHAR(3);
DECLARE Es_Relacionado	VARCHAR(3);
DECLARE Es_Proveedor	VARCHAR(3);
DECLARE Es_ObligSol		VARCHAR(3);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	Str_SI				:= 'S';				-- Salida Si
SET	Str_NO				:= 'N'; 			-- Salida No
SET Aud_FechaActual 	:= NOW();
SET Es_Cliente			:= 'CTE';			-- Tipo de Persona Cliente.
SET Es_Usuario			:= 'USU';			-- Tipo de Persona Usuario de Serv.
SET Es_Usuario2			:= 'USU';			-- Tipo de Persona Usuario de Serv. 2.
SET Es_Aval				:= 'AVA';			-- Tipo de Persona Aval.
SET Es_Prospecto		:= 'PRO';			-- Tipo de Persona Prospecto.
SET Es_Relacionado		:= 'REL';			-- Tipo de Persona Relacionado a la cuenta.
SET Es_Proveedor		:= 'PRV';			-- Tipo de Persona Proveedor.
SET Es_ObligSol			:= 'OBS';			-- Tipo de Persona Obligado solidario.

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDDETECPERSALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_TipoPersonaSAFI, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Tipo de Persona SAI esta Vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ListaPLDID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El ListaPLDID esta Vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_OrigenDeteccion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'El Origen de Deteccion esta Vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaAlta, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'La Fecha de Alta esta Vacia.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoListaID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'El Tipo de ListaID esta Vacio.';
		LEAVE ManejoErrores;
	END IF;

	SET Par_NombreCompleto := (
		CASE Par_TipoPersonaSAFI
			WHEN Es_Cliente		THEN (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Par_ClavePersonaInv)
			WHEN Es_Proveedor	THEN (SELECT NombreCompleto FROM PROVEEDORES WHERE ProveedorID = Par_ClavePersonaInv)
			ELSE IFNULL(Par_NombreCompleto,Cadena_Vacia)
		END);

	SET Par_NumeroOficio		:= IFNULL(Par_NumeroOficio,Cadena_Vacia);
	SET Var_FechaSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
  	SET @Var_IDPLDDetectPers	:= (SELECT MAX(IDPLDDetectPers) FROM PLDDETECPERS);
  	SET @Var_IDPLDDetectPers	:= (IFNULL(@Var_IDPLDDetectPers, Entero_Cero)+1);

	INSERT INTO PLDDETECPERS(
		IDPLDDetectPers,
		TipoPersonaSAFI,		ClavePersonaInv,		NombreCompleto,		TipoLista,				FechaDeteccion,
		ListaPLDID,				IDQEQ,					NumeroOficio,		OrigenDeteccion,		FechaAlta,
		TipoListaID,			EmpresaID,				Usuario,			FechaActual,			DireccionIP,
		ProgramaID,				Sucursal,				NumTransaccion)
	VALUES(
		@Var_IDPLDDetectPers,
		Par_TipoPersonaSAFI,	Par_ClavePersonaInv,	Par_NombreCompleto,	Par_TipoLista,			Var_FechaSistema,
		Par_ListaPLDID,			Par_IDQEQ,				Par_NumeroOficio,	Par_OrigenDeteccion,	Par_FechaAlta,
		Par_TipoListaID,		Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
        Aud_ProgramaID, 		Aud_Sucursal,			Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Persona Detectada Agregada Exitosamente.';
	SET Var_Control:= 'ClavePersonaInv' ;

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            IFNULL(Var_Control,Cadena_Vacia) AS Control,
			Par_ClavePersonaInv AS Consecutivo;
END IF;

END TerminaStore$$

