DELIMITER ;
DROP PROCEDURE IF EXISTS `BANMAESTROPOLIZASALT`;
DELIMITER $$
CREATE PROCEDURE `BANMAESTROPOLIZASALT`(

	INOUT	Par_Poliza	BIGINT(20),			
	Par_Empresa			INT(11),			
	Par_Fecha			DATE,				
	Par_Tipo			CHAR(1),			
	Par_ConceptoID		INT(11),			
	Par_Concepto		VARCHAR(150),		

	Par_Salida			CHAR(1), 			
	INOUT	Par_NumErr	INT(11),			
	INOUT	Par_ErrMen	VARCHAR(400),		

	Aud_Usuario			INT(11),			
	Aud_FechaActual		DATETIME,			
	Aud_DireccionIP		VARCHAR(15),		
	Aud_ProgramaID		VARCHAR(50),		
	Aud_Sucursal		INT(11),			
	Aud_NumTransaccion	BIGINT(20)			
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Salida_NO	CHAR(1);
	DECLARE Salida_SI	CHAR(1);

	-- Seteo de valores
	SET Salida_NO	:= 'N';
	SET Salida_SI	:= 'S';

	ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SET Par_NumErr := 999;
      SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                'Disculpe las molestias que esto le ocasiona. Ref: SP-BANMAESTROPOLIZASALT');
    END;

		CALL MAESTROPOLIZASALT(	Par_Poliza,			Par_Empresa,		Par_Fecha,		Par_Tipo,		Par_ConceptoID,
								Par_Concepto,		Salida_NO,			Par_NumErr,		Par_ErrMen,		Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
  		SELECT  Par_NumErr      AS NumErr,
          		Par_ErrMen      AS ErrMen,
          		'PolizaID' AS control,	
          		Par_Poliza AS consecutivo;
	END IF;

END TerminaStore$$