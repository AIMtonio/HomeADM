-- SP TIPOSNOTASCARGOMOD

DELIMITER ;

DROP PROCEDURE IF EXISTS TIPOSNOTASCARGOMOD;

DELIMITER $$

CREATE PROCEDURE `TIPOSNOTASCARGOMOD`(
	-- Stored procedure para dar modificar los registros de la tabla de tipos de notas de cargo
	Par_TipNotCarID						INT(11),			-- Identificador del registro
	Par_NombreCorto						VARCHAR(50),		-- Nombre corto de la nota de cargo
	Par_Descripcion						VARCHAR(500),		-- Descripcion de la nota de cargo
	Par_Estatus							CHAR(1),			-- Estatus del tipo de nota. A = Activo. I = Inactivo.
	Par_CobraIVA						CHAR(1),			-- Indica si el tipo de nota cobra o no cobra un IVA correspondiente. S = Si. N = No.

	Par_Salida							CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr					INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen					VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID 						INT(11),			-- Parametros de auditoria
	Aud_Usuario							INT(11),			-- Parametros de auditoria
	Aud_FechaActual						DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP						VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID						VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal						INT(11), 			-- Parametros de auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de control
	DECLARE Var_TipNotCarID				INT(11);			-- Variable para el identificador de un tipo de nota de cargo

	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(11);			-- Entero cero
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATE;				-- Fecha vacia
	DECLARE Var_SalidaSI				CHAR(1);			-- Salida si
	DECLARE Var_SalidaNO				CHAR(1);			-- Salida no
	DECLARE Var_EstActivo				CHAR(1);			-- Estatus Activo
	DECLARE Var_EstInactivo				CHAR(1);			-- Estatus Inactivo

	-- Asignacion de constantes
	SET Entero_Cero						:= 0;				-- Asignacion de entero cero
	SET Cadena_Vacia					:= '';				-- Asignacion de cadena vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de fecha vacia
	SET Var_SalidaSI					:= 'S';				-- Salida si
	SET Var_SalidaNO					:= 'N';				-- Salida no
	SET Var_EstActivo					:= 'A';				-- Estatus Activo
	SET Var_EstInactivo					:= 'I';				-- Estatus Inactivo

	-- Valores por default
	SET Par_TipNotCarID					:= IFNULL(Par_TipNotCarID, Entero_Cero);
	SET Par_NombreCorto					:= IFNULL(Par_NombreCorto, Cadena_Vacia);
	SET Par_Descripcion					:= IFNULL(Par_Descripcion, Cadena_Vacia);
	SET Par_Estatus						:= IFNULL(Par_Estatus, Cadena_Vacia);
	SET Par_CobraIVA					:= IFNULL(Par_CobraIVA, Cadena_Vacia);

	SET Par_EmpresaID					:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario						:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual					:= NOW();
	SET Aud_DireccionIP					:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID					:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal					:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion				:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-TIPOSNOTASCARGOMOD');
			SET Var_Control = 'sqlException';
		END;

		-- Validaciones
		IF (Par_TipNotCarID = Entero_Cero) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'El tipo de notas de cargo indicado esta vacio.';
			SET Var_Control := 'nombreCorto';
			LEAVE ManejoErrores;
		END IF;

		SELECT		TipoNotaCargoID
			INTO	Var_TipNotCarID
			FROM	TIPOSNOTASCARGO
			WHERE	TipoNotaCargoID = Par_TipNotCarID
			LIMIT	1;

		SET Var_TipNotCarID	:= IFNULL(Var_TipNotCarID, Entero_Cero);

		IF (Var_TipNotCarID = Entero_Cero) THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen	:= 'El tipo de notas de cargo indicado no existe.';
			SET Var_Control := 'nombreCorto';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_NombreCorto = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen	:= 'El nombre corto indicado esta vacio.';
			SET Var_Control := 'nombreCorto';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen	:= 'La descripcion indicada esta vacia.';
			SET Var_Control := 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Estatus NOT IN (Var_EstActivo, Var_EstInactivo)) THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen	:= 'No especifico un estatus valido.';
			SET Var_Control := 'cobraIVA';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_CobraIVA = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 006;
			SET Par_ErrMen	:= 'No especifico si el tipo de notas de cobro cobra IVA.';
			SET Var_Control := 'cobraIVA';
			LEAVE ManejoErrores;
		END IF;

		UPDATE TIPOSNOTASCARGO SET
			NombreCorto			= Par_NombreCorto,
			Descripcion			= Par_Descripcion,
			Estatus				= Par_Estatus,
			CobraIVA			= Par_CobraIVA,
			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE TipoNotaCargoID	= Var_TipNotCarID;

		-- El registro se modifico exitosamente
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Tipo de Notas de Cargo Modificado exitosamente: ', CAST(Var_TipNotCarID AS CHAR));
		SET Var_Control	:= 'tipoNotaCargoID';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Var_TipNotCarID			AS consecutivo;
	END IF;
-- Fin del SP

END TerminaStore$$