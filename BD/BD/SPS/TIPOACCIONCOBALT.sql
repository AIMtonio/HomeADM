-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOACCIONCOBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOACCIONCOBALT`;DELIMITER $$

CREATE PROCEDURE `TIPOACCIONCOBALT`(

    Par_AccionID		INT(11),
	Par_Descripcion		VARCHAR(200),
    Par_Estatus			CHAR(1),

    Par_Salida			CHAR(1),
    inout Par_NumErr	INT(11),
    inout Par_ErrMen	VARCHAR(150),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

	)
TerminaStore: BEGIN


    DECLARE Var_Control		VARCHAR(50);
    DECLARE Var_Consecutivo	VARCHAR(20);


    DECLARE Fecha_Vacia		DATE;
    DECLARE Entero_Cero		INT(11);
    DECLARE Entero_Uno		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Salida_SI		CHAR(1);


	SET	Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
    SET Cadena_Vacia		:= '';
    SET Salida_SI			:= 'S';

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-TIPOACCIONCOBALT');
		SET Var_Control = 'sqlException' ;
	END;

		IF(IFNULL(Par_AccionID, Entero_Cero) = Entero_Cero )THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El ID del Tipo de Accion esta Vacio';
			SET Var_Control	:= CONCAT('accionID',Par_AccionID);
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'La Descripcion del tipo de Accion esta vacia';
			SET Var_Control	:= CONCAT('descripcion',Par_AccionID);
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El Estatus esta Vacio';
			SET Var_Control	:= CONCAT('estatus',Par_AccionID);
			LEAVE ManejoErrores;
		END IF;

        SET Aud_FechaActual = now();

        INSERT INTO TIPOACCIONCOB
		(	`AccionID`, 		`Descripcion`, 		`Estatus`,	 		`EmpresaID`, 		`Usuario`,
			`FechaActual`,      `DireccionIP`, 		`ProgramaID`, 		`Sucursal`, 		`NumTransaccion`
		)VALUES(
			Par_AccionID,		Par_Descripcion,	Par_Estatus,		Par_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		);

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Alta de Tipo de Accion de Cobranza Realizada Exitosamente: ', CAST(Par_AccionID AS CHAR) );
		SET Var_Control	:= 'agregar';
		SET Var_Consecutivo:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;


END TerminaStore$$