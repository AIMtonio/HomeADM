DELIMITER ;
DROP PROCEDURE IF EXISTS `BANPAGOPREPAGOCREDITOPRO`;
DELIMITER $$
CREATE PROCEDURE `BANPAGOPREPAGOCREDITOPRO`(
		-- SP DE PROCESO QUE REALIZA EL PAGO DE CREDITO
		Par_CreditoID         BIGINT(12),
		Par_CuentaAhoID       BIGINT(12),
		Par_MontoPagar        DECIMAL(12,2),
		Par_MonedaID          INT(11),
		Par_EmpresaID         INT(11),

		Par_Salida            CHAR(1),
		Par_AltaEncPoliza     CHAR(1),
		INOUT Var_MontoPago   DECIMAL(12,2),
		Var_Poliza            BIGINT,
		INOUT Par_NumErr      INT(11),

		INOUT Par_ErrMen      VARCHAR(400),
		INOUT Par_Consecutivo BIGINT,
		Par_ModoPago          CHAR(1),
		Par_Origen            CHAR(1),
		Par_RespaldaCred          CHAR(1),      -- Bandera que indica si se realizara el proceso de Respaldo de la informacion del Credito (S = Si se respalda, N = No se respalda)
		-- Parametros de Auditoria
		Aud_Usuario           INT(11),
		Aud_FechaActual       DATETIME,
		Aud_DireccionIP       VARCHAR(15),
		Aud_ProgramaID        VARCHAR(50),
		Aud_Sucursal          INT(11),

		Aud_NumTransaccion    BIGINT(20)
)
TerminaStore: BEGIN

		-- Declaracion de constantes
		DECLARE Salida_NO   CHAR(1);
		DECLARE Salida_SI   CHAR(1);
		DECLARE Entero_Cero INT(11);

		-- Seteo de valores
		SET Salida_NO   := 'N';
		SET Salida_SI   := 'S';
		SET Entero_Cero := 0;

		ManejoErrores:BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := 999;
					SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-BANPAGOPREPAGOCREDITOPRO');
				END;

				CALL PAGOPREPAGOCREDITOPRO( Par_CreditoID,  Par_CuentaAhoID,    Par_MontoPagar,     Par_MonedaID,   Par_EmpresaID,
																		Salida_NO,      Par_AltaEncPoliza,  Var_MontoPago,      Var_Poliza,     Par_NumErr,
																		Par_ErrMen,     Par_Consecutivo,    Par_ModoPago,       Par_Origen,     Par_RespaldaCred,
																		Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
																		Aud_NumTransaccion);

				IF Par_NumErr <> Entero_Cero THEN
						LEAVE ManejoErrores;
				END IF;

	END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  Par_NumErr      AS NumErr,
					Par_ErrMen      AS ErrMen,
					'creditoID'     AS Control,
					Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$