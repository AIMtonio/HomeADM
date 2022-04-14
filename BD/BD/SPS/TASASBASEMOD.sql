-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASBASEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASBASEMOD`;DELIMITER $$

CREATE PROCEDURE `TASASBASEMOD`(
	# === SP PARA MODIFICAR UNA TASA BASE ===================
	Par_TasaBaseID 			INT,
	Par_Nombre 				VARCHAR(200),
	Par_Descripcion 		VARCHAR(200),
    Par_ClaveCNBV			INT,
    Par_Salida          	CHAR(1),

OUT Par_NumErr          	INT,
OUT Par_ErrMen          	VARCHAR(400),
	Aud_Empresa				INT(11),
	Aud_Usuario				INT,
    Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

	)
TerminaStore: BEGIN

DECLARE Var_Control		VARCHAR(50);

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Observacion		VARCHAR(200);
DECLARE Salida_SI		CHAR(1);



SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Observacion 	:= 'Sin Observacion';
SET Salida_SI		:= 'S';

ManejoErrores: BEGIN

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr   = 999;
        SET Par_ErrMen   = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
            'esto le ocasiona. Ref: SP-TASASBASEMOD');
		SET Var_Control  = 'SQLEXCEPTION';
    END;


	IF(NOT EXISTS(SELECT TasaBaseID FROM TASASBASE WHERE TasaBaseID = Par_TasaBaseID)) THEN
		SET Par_NumErr	:= 1;
        SET Par_ErrMen	:= 'La Tasa Base no Existe.';
        SET Var_Control	:= 'numero';

		LEAVE ManejoErrores;


	END IF;


	SET Aud_FechaActual := CURRENT_TIMESTAMP();


	UPDATE TASASBASE SET
			TasaBaseID 		= Par_TasaBaseID,
			Nombre 			= Par_Nombre,
			Descripcion		= Par_Descripcion,
            ClaveCNBV		= Par_ClaveCNBV,

			EmpresaID		= Aud_Empresa,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
	WHERE TasaBaseID = Par_TasaBaseID;


	SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= CONCAT("Tasa Base Modificada Exitosamente: ", CONVERT(Par_TasaBaseID, CHAR));
    SET Var_Control	:= 'tasaBaseID';


END ManejoErrores;


	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control,
				Par_TasaBaseID 	AS Consecutivo;
	END IF;


END TerminaStore$$