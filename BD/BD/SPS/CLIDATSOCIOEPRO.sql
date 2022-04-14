-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIDATSOCIOEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIDATSOCIOEPRO`;DELIMITER $$

CREATE PROCEDURE `CLIDATSOCIOEPRO`(

	Par_LinNegID     	INT(11),
    Par_ProspectoID     INT(11),
    Par_ClienteID       INT(11),
	Par_SolicCreID		INT(11),
	Par_CatSocioEID		INT(11),

	Par_Monto			DECIMAL(14,2),
	Par_FechaReg		DATE,
	Par_SocioEID        INT(11),
    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT,

    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),

    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
		)
TerminaStore: BEGIN


DECLARE Var_Consecutivo   	INT;
DECLARE Var_Control			VARCHAR(15);
DECLARE Var_Cte				INT;
DECLARE Var_LinNegID		INT;
DECLARE Var_MenorEdad		CHAR(1);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATETIME;
DECLARE Entero_Cero         INT(11);
DECLARE Str_SI              CHAR(1);
DECLARE Str_NO              CHAR(1);
DECLARE MenorEdad			CHAR(1);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Str_SI              := 'S';
SET Str_NO              := 'N';
SET MenorEdad			:= 'S';


SET Aud_FechaActual := CURRENT_TIMESTAMP();


SET	Par_FechaReg	:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Var_Consecutivo := Par_ClienteID;

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := '999';
					SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CLIDATSOCIOEPRO');
					SET Var_Control := 'sqlException' ;
				END;


	CALL HISCLIDATSOCIOEALT(
		Par_LinNegID,		Par_ProspectoID,		Par_ClienteID,		Par_CatSocioEID,		Str_NO,
		Par_NumErr, 		Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

	IF (Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	CALL CLIDATSOCIOEBAJ(
		Par_LinNegID,		Par_ProspectoID,	Par_ClienteID,			Par_CatSocioEID,		Str_NO,
		Par_NumErr, 		Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

	IF (Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	CALL CLIDATSOCIOEALT(
		Par_LinNegID,	Par_ProspectoID,	Par_ClienteID,			Par_SolicCreID,		Par_CatSocioEID,
		Par_Monto,		Par_FechaReg,		Str_NO,					Par_NumErr, 		Par_ErrMen,
		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,	Aud_NumTransaccion);

	IF (Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	SET	Par_NumErr	:= Entero_Cero;
	SET	Par_ErrMen	:= 'Datos Socioeconomicos Agregados Exitosamente.' ;
	SET Var_Control := 'clienteID' ;

END ManejoErrores;

IF(Par_Salida = Str_SI) THEN
	SELECT 	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
END IF;

END TerminaStore$$