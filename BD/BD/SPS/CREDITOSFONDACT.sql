-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSFONDACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSFONDACT`;DELIMITER $$

CREATE PROCEDURE `CREDITOSFONDACT`(
# ======================================================
# ------- STORE PARA ACTUALIZACION DE CREDITOS----------
# ======================================================
	Par_CreditoID       BIGINT(12),			-- Numero de Credito Activo
	Par_CreditoFondeoID	BIGINT(20),  		-- Numero de Credito Pasivo
    Par_FolioPagoActivo	BIGINT(20),			-- Transaccion del Pago Correspondiente al Credito Activo

	Par_Salida          CHAR(1),			-- Salida S:SI  N:NO
	INOUT Par_NumErr    INT(11),			-- Numero de Error
	INOUT Par_ErrMen    VARCHAR(400),		-- Mensaje de Error

    -- Parametros de Auditoria
	Par_EmpresaID       INT(11),
	Aud_Usuario	        INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

    -- Declaracion de variables
    DECLARE VarControl           	VARCHAR(100);
    DECLARE Var_Consecutivo      	BIGINT(20);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT;
	DECLARE Str_NO              	CHAR(1);
    DECLARE SalidaSI            	CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia        		:= '';
	SET Fecha_Vacia         		:= '1900-01-01';
	SET Entero_Cero         		:= 0;
	SET Str_NO              		:= 'N';
	SET SalidaSI            		:= 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
										concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CREDITOSFONDACT');
				SET VarControl := 'SQLEXCEPTION' ;
			END;

            -- Se actualiza el numero de credito relacionado al credito pasivo
			UPDATE DETALLEPAGFON SET
				CreditoID  	 		= Par_CreditoID,
                FolioPagoActivo		= Par_FolioPagoActivo
			WHERE CreditoFondeoID	= Par_CreditoFondeoID
            AND NumTransaccion		= Aud_NumTransaccion;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Credito Actualizado.';
			SET VarControl      := 'creditoFondeoID';
			SET Var_Consecutivo :=  Par_CreditoFondeoID;



	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr          AS Par_NumErr,
				Par_ErrMen          AS ErrMen,
				VarControl          AS control,
				Var_Consecutivo     AS consecutivo;
	END IF;

END TerminaStore$$