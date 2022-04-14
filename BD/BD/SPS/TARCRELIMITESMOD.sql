-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCRELIMITESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARCRELIMITESMOD`;DELIMITER $$

CREATE PROCEDURE `TARCRELIMITESMOD`(
# SP PARA MODIFICACION DE LIMITES DE TARJETA DE CREDITO
    Par_TarjetaCredID           CHAR(16),			-- Parametro de tarjeta credito ID
    Par_DisposicionesDia        INT(11),			-- Parametro de disposiciones dia
    Par_MontoMaxDia             DECIMAL(12,2), 		-- Parametro monto maximo dia
    Par_MontoMaxMes             DECIMAL(12,2),     	-- Parametro monto maximo mes
    Par_MontoMaxCompraDia       DECIMAL(12,2),      -- Parametro monto maximo compra dia

    Par_MontoMaxComprasMensual  DECIMAL(12,2),      -- Parametro monto maximo compra mensual
    Par_BloqueoATM              CHAR(2),			-- Parametro de bloqueo ATM
    Par_BloqueoPOS              CHAR(2),  	 		-- Parametro bloqueo POS en linea
    Par_BloqueoCashback         CHAR(2),			-- Parametro bloqueo cashback
    Par_Vigencia                DATE,            	-- Parametro Vigencia

    Par_OperacionesMOTO         CHAR(2),  			-- Parametro Operaciones MOTO
	Par_NumConsultaMes			INT(11),			-- Parametro numero consulta mes

    Par_Salida              	CHAR(1),          -- Tipo salida
	INOUT Par_NumErr        	INT(11),          -- Numero de error
	INOUT Par_ErrMen        	VARCHAR(400),     -- Mensaje de error

    Aud_EmpresaID               INT(11),			-- Parametro de Auditoria
    Aud_Usuario                 INT(11),			-- Parametro de Auditoria
    Aud_FechaActual             DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP             VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID              VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal                INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion          BIGINT				-- Parametro de Auditoria
	)
TerminaStore: BEGIN

DECLARE Estatus_Activo  CHAR(1);			-- estatus activo
DECLARE Cadena_Vacia    CHAR(1);			-- cadena vacia
DECLARE Fecha_Vacia     DATE;				-- fecha vacia
DECLARE Entero_Cero     INT(11);			-- entero cero
DECLARE Modificar       INT(11); 			-- modificar
DECLARE Decimal_Cero    DECIMAL(12,2); 		-- DECIMAL cero
DECLARE Pro_Actualiza   INT(11);			-- proceso actualizacion
DECLARE varControl		VARCHAR(50);		-- vatriable de control
DECLARE Salida_SI       CHAR(1);			-- salida si

SET Estatus_Activo  := 'A';
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET Aud_FechaActual := NOW();
SET Modificar       := 9;
SET Pro_Actualiza   := 2;
SET Salida_SI       := 'S';

ManejoErrores:BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TARCRELIMITESMOD');
    END;

	IF(IFNULL(Par_DisposicionesDia,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := 'Especifique el NÃºmero de Disposiciones al dia';
		SET varControl  := 'disposicionesDia' ;
		LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_MontoMaxDia,Decimal_Cero)= Decimal_Cero) THEN
		SET Par_NumErr  := 002;
		SET Par_ErrMen  := 'Especifique el Monto MAX. al Dia';
		SET varControl  := 'montoMaxDia' ;
		LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_MontoMaxMes,Decimal_Cero)= Decimal_Cero) THEN
		SET Par_NumErr  := 003;
		SET Par_ErrMen  := 'Especifique el Motivo de MAX del Mes';
		SET varControl  := 'montoMaxMes' ;
		LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_MontoMaxCompraDia,Decimal_Cero)= Decimal_Cero) THEN
		SET Par_NumErr  := 004;
		SET Par_ErrMen  := 'Especifique la Monto MAX. de Compra al Dia';
		SET varControl  := 'montoMaxCompraDia' ;
		LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_MontoMaxComprasMensual,Decimal_Cero)= Decimal_Cero) THEN
		SET Par_NumErr  := 005;
		SET Par_ErrMen  := 'Especifique el Monto MAX. Compras Mensual';
		SET varControl  := 'montoMaxComprasMensual' ;
		LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_BloqueoATM,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := 006;
		SET Par_ErrMen  := 'Especifique Bloqueo  de ATM';
		SET varControl  := 'bloqueoATM' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_BloqueoPOS,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := 007;
		SET Par_ErrMen  := 'Especifique Bloqueo  de POS';
		SET varControl  := 'bloqueoPOS' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_BloqueoCashback,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := 008;
		SET Par_ErrMen  := 'Especifique el Bloqueo Cashback';
		SET varControl  := 'bloqueoCashback' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_OperacionesMOTO,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := 009;
		SET Par_ErrMen  := 'Especifique Operaciones MOTO';
		SET varControl  := 'operacionesMOTO' ;
		LEAVE ManejoErrores;
	END IF;
	IF(Par_Vigencia < DATE(NOW())) THEN
		SET Par_NumErr  := 010;
		SET Par_ErrMen  := 'La Vigencia No Debe Ser Menor a la Fecha Actual';
		SET varControl  := 'vigencia' ;
		LEAVE ManejoErrores;
	END IF;

    UPDATE TARCRELIMITES SET
        NoDisposiDia    = Par_DisposicionesDia,
		NumConsultaMes	= Par_NumConsultaMes,
        DisposiDiaNac   = Par_MontoMaxDia,
        DisposiMesNac   = Par_MontoMaxMes,
        ComprasDiaNac   = Par_MontoMaxCompraDia,
        ComprasMesNac   = Par_MontoMaxComprasMensual,
        BloquearATM     = Par_BloqueoATM,
        BloquearPOS     = Par_BloqueoPOS,
        BloquearCashBack= Par_BloqueoCashback,
        Vigencia        = Par_Vigencia,
        AceptaOpeMoto   = Par_OperacionesMOTO,

        EmpresaID       = Aud_EmpresaID,
        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion
    WHERE TarjetaCredID  = Par_TarjetaCredID;

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Limites Modificados Exitosamente';
		SET varControl  := 'tarjetaDebID' ;
		LEAVE ManejoErrores;

END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				varControl AS control,
				Par_TarjetaCredID AS consecutivo;
	END IF;

END TerminaStore$$