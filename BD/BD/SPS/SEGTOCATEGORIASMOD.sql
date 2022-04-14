-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCATEGORIASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOCATEGORIASMOD`;DELIMITER $$

CREATE PROCEDURE `SEGTOCATEGORIASMOD`(
	Par_CategoriaID		INT(11),
	Par_TipoGestionID	INT(11),
	Par_Descripcion		VARCHAR(150),
	Par_NombreCorto		VARCHAR(45),
	Par_TipoCobranza	CHAR(1),
	Par_Estatus			CHAR(1),

	Par_Salida			CHAR(1),
	inout Par_NumErr	INT(11),
	inout Par_ErrMen	VARCHAR(150),

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore:BEGIN



	DECLARE Var_Control		VARCHAR(30);
	DECLARE Var_Consecutivo	VARCHAR(35);



	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Entero_Cero		INT(11);
	DECLARE Salida_SI		CHAR(1);



	SET Cadena_Vacia	:= '';
	SET	Entero_Cero		:= 0;
	SET Salida_SI		:= 'S';

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTOCATEGORIASMOD');
		SET Var_Control = 'sqlException' ;
	END;

	IF (ifnull(Par_CategoriaID, Entero_Cero) = Entero_Cero ) THEN
		SET Par_NumErr	:= '01';
		SET Par_ErrMen	:= 'Especifique la Categoria de Seguimiento';
		SET Var_Control	:= 'categoriaID';
		SET Var_Consecutivo:= Par_CategoriaID;
		LEAVE ManejoErrores;
	END IF;

	IF (ifnull(Par_TipoGestionID, Entero_Cero) = Entero_Cero ) THEN
		SET Par_NumErr	:= '02';
		SET Par_ErrMen	:= 'Especifique el Tipo de Gestion';
		SET Var_Control	:= 'tipoGestionID';
		SET Var_Consecutivo:= Par_TipoGestionID;
		LEAVE ManejoErrores;
	END IF;

	IF (ifnull(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia ) THEN
		SET Par_NumErr	:= '03';
		SET Par_ErrMen	:= 'Especifique la Descripcion';
		SET Var_Control	:= 'descripcion';
		SET Var_Consecutivo:= Par_Descripcion;
		LEAVE ManejoErrores;
	END IF;

	IF (ifnull(Par_NombreCorto, Cadena_Vacia) = Cadena_Vacia ) THEN
		SET Par_NumErr	:= '04';
		SET Par_ErrMen	:= 'Especifique el Nombre Corto';
		SET Var_Control	:= 'nombreCorto';
		SET Var_Consecutivo:= Par_NombreCorto;
		LEAVE ManejoErrores;
	END IF;

	IF (ifnull(Par_Estatus, Cadena_Vacia) = Cadena_Vacia ) THEN
		SET Par_NumErr	:= '05';
		SET Par_ErrMen	:= 'Especifique el Estatus';
		SET Var_Control	:= 'estatus';
		SET Var_Consecutivo:= Par_Estatus;
		LEAVE ManejoErrores;
	END IF;

	IF (ifnull(Par_TipoCobranza, Cadena_Vacia) = Cadena_Vacia ) THEN
		SET Par_NumErr	:= '06';
		SET Par_ErrMen	:= 'Especifique el Tipo Cobranza';
		SET Var_Control	:= 'tipoCobranza';
		SET Var_Consecutivo:= Par_TipoCobranza;
		LEAVE ManejoErrores;
	END IF;

	UPDATE `SEGTOCATEGORIAS`	SET
		TipoGestionID 	= Par_TipoGestionID,
		Descripcion 	= Par_Descripcion,
		NombreCorto 	= Par_NombreCorto,
		Estatus 		= Par_Estatus,
		TipoCobranza 	= Par_TipoCobranza,
		EmpresaID 		= Aud_EmpresaID,
		Usuario 		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID 		= Aud_ProgramaID,
		Sucursal 		= Aud_Sucursal,
		NumTransaccion 	= Aud_NumTransaccion
	WHERE CategoriaID = Par_CategoriaID;

	SET Par_NumErr	:= '000';
	SET Par_ErrMen	:= CONCAT('Categoria de Seguimiento Modificado Exitosamente: ', CAST(Par_CategoriaID AS CHAR) );
	SET Var_Control	:= 'categoriaID';
	SET Var_Consecutivo:= Par_CategoriaID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$