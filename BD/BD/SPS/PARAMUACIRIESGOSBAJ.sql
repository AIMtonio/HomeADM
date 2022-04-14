-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMUACIRIESGOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMUACIRIESGOSBAJ`;DELIMITER $$

CREATE PROCEDURE `PARAMUACIRIESGOSBAJ`(

	Par_ParamRiesgosID		INT(11),

	Par_Salida		    	CHAR(1),
	inout Par_NumErr	 	INT(11),
	inout Par_ErrMen	 	VARCHAR(400),
	Par_EmpresaID		 	INT(11),
	Aud_Usuario		    	INT(11),
	Aud_FechaActual		 	DATETIME,
	Aud_DireccionIP		 	VARCHAR(15),
	Aud_ProgramaID		 	VARCHAR(50),
	Aud_Sucursal		    INT(11),
	Aud_NumTransaccion  	BIGINT
)
TerminaStore: BEGIN


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATETIME;
DECLARE Entero_Cero         INT(11);
DECLARE Salida_SI           CHAR(1);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Salida_SI           := 'S';

ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                         "estamos trabajando para resolverla. Disculpe las molestias que ",
                         "esto le ocasiona. Ref: SP-PARAMUACIRIESGOSBAJ");
        END;

		 DELETE FROM PARAMUACIRIESGOS
					WHERE CatParamRiesgosID = Par_ParamRiesgosID;

		SET Par_NumErr := Entero_Cero;
        SET Par_ErrMen := 'Parametros de Riesgos Eliminados Correctamente';

        IF(Par_Salida = Salida_SI) then
            SELECT '000' as NumErr,
				Par_ErrMen  as ErrMen,
				'paramRiesgosID' as control,
				Par_ParamRiesgosID as consecutivo;
        END IF;

 END ManejoErrores;

END TerminaStore$$