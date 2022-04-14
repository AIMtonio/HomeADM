-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSENVMENADICALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSENVMENADICALT`;DELIMITER $$

CREATE PROCEDURE `SMSENVMENADICALT`(
# ===================================================================
# ----------- SP PARA ENVIO DE  LOS MENSAJES SMS---------
# ===================================================================
    Par_EnvioID     	INT(11),
	Par_CtaAsoc     	VARCHAR(45),
	Par_NumCliente  	VARCHAR(45),
	Par_Salida      	CHAR(1),

	INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

	)
TerminaStore: BEGIN
	-- Declaracion de variables
    DECLARE Var_Control			VARCHAR(100);
	DECLARE Consecutivo			VARCHAR(100);
	-- Declaracion de constantes
	DECLARE  Entero_Cero		INT(11);
	DECLARE  SalidaSI			CHAR(1);
	DECLARE  SalidaNO			CHAR(1);
	DECLARE  Cadena_Vacia		CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero     := 0;		-- Entero Cero
	SET SalidaSI        :='S';		-- Salida Si
	SET SalidaNO        :='N';		-- Salida No
	SET Cadena_Vacia    := '';		-- String Vacio

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSENVMENADICALT');
				SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		INSERT INTO SMSENVMENADIC (
			EnvioID,		    CuentaAsociada,		NumeroCliente,  EmpresaID,
			Usuario,		    FechaActual,		DireccionIP,    ProgramaID,
			Sucursal,       	NumTransaccion)
		VALUES(
			Par_EnvioID,     Par_CtaAsoc,			Par_NumCliente,		Par_EmpresaID,
			Aud_Usuario,    Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr 	:= 000;
        SET Par_ErrMen 	:= 'Registro Guardado';
        SET Var_Control	:= 'campaniaID';
		SET Consecutivo := Par_EnvioID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
			SELECT	Par_NumErr  AS NumErr,
					Par_ErrMen  AS ErrMen,
					Var_Control AS control,
					Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$