-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-REGULATORIO0842BAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-REGULATORIO0842BAJ`;DELIMITER $$

CREATE PROCEDURE `HIS-REGULATORIO0842BAJ`(

	Par_Anio				INT(11),
	Par_Mes					INT(11),
	Par_TipoBaja			TINYINT UNSIGNED,
	Par_Salida          	CHAR(1),
	INOUT Par_NumErr    	INT,

    INOUT Par_ErrMen   		VARCHAR(400),
	Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),

    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT,
	Aud_NumTransaccion  	BIGINT(20)

		)
TerminaStore:BEGIN

DECLARE Var_Control		VARCHAR(50);


DECLARE BajaPeriodo			INT;
DECLARE Cadena_Vacia		CHAR;
DECLARE Entero_Cero			INT;
DECLARE SalidaSI			CHAR;

SET BajaPeriodo				:=1;
SET Cadena_Vacia			:='';
SET Entero_Cero				:=0;
SET SalidaSI				:='S';

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          SET Par_NumErr = 999;
          SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.
          Disculpe las molestias que esto le ocasiona. Ref: SP-HIS-REGULATORIOI0842BAJ');
          SET Var_Control = 'sqlException';
        END;
	IF (Par_TipoBaja=BajaPeriodo)THEN

		IF (Par_Anio=Entero_Cero)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'El Año del Periodo esta vacio';
				SET Var_Control  := 'anio' ;
				LEAVE ManejoErrores;
		END IF;

	    IF (Par_Mes=Entero_Cero)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'El Mes del Periodo esta vacio';
				SET Var_Control  := 'mes' ;
				LEAVE ManejoErrores;
		END IF;


		DELETE FROM `HIS-REGULATORIOD0842` WHERE Anio = Par_Anio  AND Mes = Par_Mes;

		SET Par_NumErr := 0;
        SET Par_ErrMen := CONCAT("Historial Regulatorio D-0842 eliminado.");
        LEAVE ManejoErrores;
	END IF;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
            SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                    Par_ErrMen AS ErrMen,
                    Var_Control AS control,
                    Entero_Cero AS consecutivo;
    END IF;


END TerminaStore$$