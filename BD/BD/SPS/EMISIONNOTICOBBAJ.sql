-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMISIONNOTICOBBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMISIONNOTICOBBAJ`;DELIMITER $$

CREATE PROCEDURE `EMISIONNOTICOBBAJ`(

    Par_CreditoID		BIGINT(12),
    Par_FechaEmision 	DATE,
    Par_FormatoID		INT(11),

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
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-EMISIONNOTICOBBAJ');
		SET Var_Control = 'sqlException' ;
	END;

		DELETE FROM EMISIONNOTICOB
			WHERE CreditoID = Par_CreditoID
				AND FechaEmision = Par_FechaEmision
					AND FormatoID = Par_FormatoID;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Baja de Emision de Notificacion Realizada Exitosamente ');
		SET Var_Control	:= 'SucursalID';
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