-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-REGULATORIOA1713BAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-REGULATORIOA1713BAJ`;DELIMITER $$

CREATE PROCEDURE `HIS-REGULATORIOA1713BAJ`(

	Par_Fecha				DATE,


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

DECLARE Var_Control		VARCHAR(100);
DECLARE Var_Fecha		INT;


DECLARE Cadena_Vacia		CHAR;
DECLARE Entero_Cero			INT;
DECLARE SalidaSI			CHAR;

SET Cadena_Vacia			:='';
SET Entero_Cero				:=0;
SET SalidaSI				:='S';

ManejoErrores: BEGIN

      DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          SET Par_NumErr = 999;
          SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.'
          'Disculpe las molestias que esto le ocasiona. Ref: SP-HIS-REGULATORIOA1713BAJ');
          SET Var_Control = 'sqlException';
        END;

		SELECT REPLACE (CONVERT(Par_Fecha,CHAR),'-',Cadena_Vacia) INTO Var_Fecha;

	    IF (Par_Fecha=Cadena_Vacia)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'La Fecha esta vacia';
				LEAVE ManejoErrores;
		END IF;

		DELETE FROM `HIS-REGULATORIOA1713` WHERE Fecha = Var_Fecha;

		SET Par_NumErr := 0;
        SET Par_ErrMen := CONCAT("Historial Regulatorio-A1713 eliminado.");
        LEAVE ManejoErrores;


END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
            SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                    Par_ErrMen AS ErrMen,
                    Var_Control AS control,
                    Entero_Cero AS consecutivo;
    END IF;


END TerminaStore$$