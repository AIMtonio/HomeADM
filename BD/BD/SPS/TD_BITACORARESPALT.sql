-- TD_BITACORARESPALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_BITACORARESPALT`;
DELIMITER $$


CREATE PROCEDURE `TD_BITACORARESPALT`(
-- ---------------------------------------------------------------------------------
-- GUARDA LA RESPUESTA DE LA TRANSACCION DE TARJETA DE DEBITO
-- ---------------------------------------------------------------------------------
Par_TarjetaDebID	             CHAR(16),       -- Numero de tarjeta
Par_TipoMensaje                  CHAR(4),        -- Tipo de Mensaje
Par_TipoOperacionID              VARCHAR(45),    -- Tipo de Operacion
Par_FechaOperacion               DATE,           -- Fecha de Operacion
Par_HoraOperacion                DATE,           -- Hora de Operacion
Par_MontoTransaccion             DECIMAL(12,2),  -- Monto de transaccion
Par_Referencia                   VARCHAR(25),    -- Referencia
Par_NumTransResp                 BIGINT(20),     -- Num Transaccion respuesta
Par_SaldoContableAct             DECIMAL(16,2),  -- Saldo Contable
Par_SaldoDisponibleAct           DECIMAL(16,2),  -- Saldo Disponible
Par_CodigoRespuesta              VARCHAR(3),     -- Codigo de Respuesta
Par_MensajeRespuesta             VARCHAR(400),   -- Mensaje de Respuesta

Par_Salida				         CHAR(1),        -- Salida
INOUT Par_NumErr		         INT,            -- Salida
INOUT Par_ErrMen 		         VARCHAR(400),   -- Salida


Par_EmpresaID                    INT(11),        -- Auditoria
Aud_Usuario                      INT(11),        -- Auditoria
Aud_FechaActual                  DATETIME,       -- Auditoria
Aud_DireccionIP                  VARCHAR(15),    -- Auditoria
Aud_ProgramaID                   VARCHAR(45),    -- Auditoria
Aud_Sucursal                     INT(11),        -- Auditoria
Aud_NumTransaccion               BIGINT(20)      -- Auditoria

)

TerminaStore:BEGIN

DECLARE Var_RespID				INT;
DECLARE Var_FechaHrRespuesta DATETIME;


DECLARE Salida_Si   CHAR(1);
DECLARE Entero_Cero INT(11);

SET Salida_Si               := 'S';
SET Entero_Cero             := 0;
SET Var_FechaHrRespuesta	:= NOW();

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-TD_BITACORARESPALT');
		END;

	SELECT MAX(RespID)
	INTO Var_RespID
	FROM TC_BITACORARESP;

	SET Var_RespID := IFNULL(Var_RespID,Entero_Cero) + 1 ;


	INSERT INTO TD_BITACORARESP(
		RespID, 				TarjetaDebID, 			TipoMensaje, 		TipoOperacionID, 		FechaOperacion,
		HoraOperacion, 			MontoTransaccion, 		Referencia, 		FechaHrRespuesta, 		NumTransResp,
		SaldoContableAct, 		SaldoDisponibleAct, 	CodigoRespuesta, 	MensajeRespuesta,

		EmpresaID,				Usuario, 				FechaActual, 		DireccionIP, 			ProgramaID,
		Sucursal, 				NumTransaccion)
	VALUES
	(	Var_RespID, 				Par_TarjetaDebID, 			Par_TipoMensaje, 		Par_TipoOperacionID, 		Par_FechaOperacion,
		Par_HoraOperacion, 			Par_MontoTransaccion, 		Par_Referencia, 		Var_FechaHrRespuesta, 		Par_NumTransResp,
		Par_SaldoContableAct, 		Par_SaldoDisponibleAct, 	Par_CodigoRespuesta, 	Par_MensajeRespuesta,

		Par_EmpresaID,				Aud_Usuario, 				Aud_FechaActual, 		Aud_DireccionIP, 			Aud_ProgramaID,
		Aud_Sucursal, 				Aud_NumTransaccion
		);


	SET Par_NumErr := 0;
	SET Par_ErrMen := 'Registro de Respuesta Exitoso';


END ManejoErrores;

	IF Par_Salida = Salida_Si THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$