-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOTETARJETABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOTETARJETABAJ`;DELIMITER $$

CREATE PROCEDURE `LOTETARJETABAJ`(

	Par_LoteDebitoID        INT(11),
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


DECLARE BajaRegistro		INT;
DECLARE Cadena_Vacia		CHAR;
DECLARE Entero_Cero			INT;
DECLARE SalidaSI			CHAR;

SET BajaRegistro			:= 1;
SET Cadena_Vacia			:= '';
SET Entero_Cero				:= 0;
SET SalidaSI				:= 'S';

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          SET Par_NumErr = 999;
          SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
                          concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-LOTETARJETABAJ');
          SET Var_Control = 'sqlException';
        END;

	IF (Par_TipoBaja=BajaRegistro)THEN

		IF (Par_LoteDebitoID=Entero_Cero)THEN
				SET Par_NumErr  :=  001;
				SET Par_ErrMen  :=  'No existe el Lote de Tarjetas';
				SET Var_Control :=  'loteDebitoID' ;
				LEAVE ManejoErrores;
		END IF;

		DELETE FROM `LOTETARJETADEB` WHERE LoteDebitoID = Par_LoteDebitoID;

		SET Par_NumErr := 0;
        SET Par_ErrMen := CONCAT('Ha ocurrido un Error. No se pudieron insertar los registros.');
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