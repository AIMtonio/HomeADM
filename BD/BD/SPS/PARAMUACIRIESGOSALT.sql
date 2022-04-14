-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMUACIRIESGOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMUACIRIESGOSALT`;DELIMITER $$

CREATE PROCEDURE `PARAMUACIRIESGOSALT`(

    Par_ParamRiesgosID  	INT(11),
	Par_ReferenciaID  		INT(11),
    Par_Descripcion    		VARCHAR(100),
	Par_Porcentaje    		DECIMAL(10,2),

    Par_Salida          	CHAR(1),
	inout Par_NumErr		INT(11),
	inout Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
    Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN


DECLARE Var_Control  	 VARCHAR(200);
DECLARE Var_RiesgosID	 INT(11);


DECLARE Entero_Cero     INT(11);
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE SalidaSI        CHAR(1);


SET Entero_Cero  		:= 0;
SET SalidaSI     		:= 'S';
SET Cadena_Vacia 		:='';
SET Decimal_Cero        := 0.0;

SET Aud_FechaActual = NOW();

ManejoErrores: BEGIN


DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
									 'estamos trabajando para resolverla. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-PARAMUACIRIESGOSALT');
			SET Var_Control = 'sqlException' ;
	END;

SET Var_RiesgosID   := (SELECT MAX(ParamRiesgosID) FROM PARAMUACIRIESGOS);
SET Var_RiesgosID   := IFNULL(Var_RiesgosID, Entero_Cero) + 1;

	INSERT INTO PARAMUACIRIESGOS (
			ParamRiesgosID,		CatParamRiesgosID,		ReferenciaID,		Descripcion,
			Porcentaje,			EmpresaID,				Usuario,			FechaActual,
			DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion)
	VALUES (Var_RiesgosID,		Par_ParamRiesgosID,		Par_ReferenciaID,	Par_Descripcion,
			Par_Porcentaje,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			SET Par_NumErr := 000;
			SET Par_ErrMen :='Parametros de Riesgos Grabados Exitosamente';
			SET Var_Control := 'paramRiesgosID';
			SET Entero_Cero := Par_ParamRiesgosID;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$