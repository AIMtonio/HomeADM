-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCRELIMITESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARCRELIMITESALT`;DELIMITER $$

CREATE PROCEDURE `TARCRELIMITESALT`(
#SP DE ALTA DE LIMITES DE TARJETA DE CREDITO
    Par_TarjetaCredID               CHAR(16),			-- Parametro de tarjeta credito ID
    Par_DisposicionesDia            INT(11),			-- Parametro de disposiciones dia
    Par_MontoMaxDia                 DECIMAL(12,2),		-- Parametro monto maximo dia
    Par_MontoMaxMes                 DECIMAL(12,2),		-- Parametro monto maximo mes
    Par_MontoMaxCompraDia           DECIMAL(12,2),		-- Parametro monto maximo compra dia

    Par_MontoMaxComprasMensual      DECIMAL(12,2),		-- Parametro monto maximo compra mensual
    Par_BloqueoATM                  CHAR(2),			-- Parametro de bloqueo ATM
    Par_BloqueoPOS                  CHAR(2),			-- Parametro bloqueo POS en linea
    Par_BloqueoCashback             CHAR(2),			-- Parametro bloqueo cashback
    Par_Vigencia                    DATE,				-- Parametro Vigencia

    Par_OperacionesMOTO             CHAR(2),  			-- Parametro Operaciones MOTO
	Par_NumConsultaMes				INT(11),			-- Parametro numero consulta mes

    Par_Salida          CHAR(1),						-- Parametro Salida
    INOUT Par_NumErr    INT,							-- Numero Error
    INOUT Par_ErrMen    VARCHAR(400),					-- Mensaje Error

    Aud_EmpresaID       INT(11),						-- Parametro de Auditoria
    Aud_Usuario         INT,							-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,						-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),					-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),  					-- Parametro de Auditoria
    Aud_Sucursal        INT,							-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT							-- Parametro de Auditoria
	)
TerminaStore: BEGIN


DECLARE Entero_Cero     INT;			-- entero cero
DECLARE Cadena_Vacia    CHAR(1);		-- cadena vacia
DECLARE Salida_SI       CHAR(1);		-- salida si
DECLARE Salida_NO       CHAR(1);		-- salida no
DECLARE Decimal_Cero    DECIMAL(12,2);	-- DECIMAL cero
DECLARE Pro_Actualiza   INT(11);		-- proceso actualizacion
DECLARE Fecha_Actual	DATE;			-- fecha actual
DECLARE varControl		VARCHAR(50);	-- variable de control

SET Entero_Cero    		:= 0;
SET Decimal_Cero     	:=0.00;
SET Cadena_Vacia    	:= '';
SET Salida_SI       	:= 'S';
SET Salida_NO       	:= 'N';
SET Pro_Actualiza   	:= 2;
SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();
SET Fecha_Actual		:= DATE(NOW());

ManejoErrores:BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TARCRELIMITESALT');
    END;

	IF(IFNULL(Par_TarjetaCredID,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := 'Especifique el numero de tarjeta';
		SET varControl  := 'TarjetaDebID' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_DisposicionesDia,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := 002;
		SET Par_ErrMen  := 'Especifique el Numero de Disposiones al dia';
		SET varControl  := 'disposicionesDia' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_MontoMaxDia,Decimal_Cero)= Decimal_Cero) THEN
		SET Par_NumErr  := 003;
		SET Par_ErrMen  := 'Especifique el Monto MAX. al Dia';
		SET varControl  := 'montoMaxDia' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_MontoMaxMes,Decimal_Cero)= Decimal_Cero) THEN
		SET Par_NumErr  := 004;
		SET Par_ErrMen  := 'Especifique el Motivo de MAX del Mes';
		SET varControl  := 'motivoID' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_MontoMaxCompraDia,Decimal_Cero)= Decimal_Cero) THEN
		SET Par_NumErr  := 005;
		SET Par_ErrMen  := 'Especifique la Monto MAX. de Compra al Dia';
		SET varControl  := 'montoMaxCompraDia' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_MontoMaxComprasMensual,Decimal_Cero)= Decimal_Cero) THEN
		SET Par_NumErr  := 006;
		SET Par_ErrMen  := 'Especifique el Monto MAX. Compras Mensual';
		SET varControl  := 'montoMaxComprasMensual' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_BloqueoATM,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := 007;
		SET Par_ErrMen  := 'Especifique Bloqueo  de ATM';
		SET varControl  := 'bloqueoATM' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_BloqueoPOS,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := 008;
		SET Par_ErrMen  := 'Especifique Bloqueo  de POS';
		SET varControl  := 'bloqueoPOS' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_BloqueoCashback,Cadena_Vacia)= Cadena_Vacia) THEN
		SET Par_NumErr  := 009;
		SET Par_ErrMen  := 'Especifique el Bloqueo Cashback';
		SET varControl  := 'bloqueoCashback' ;
		LEAVE ManejoErrores;
	END IF;
    IF(Par_Vigencia  < Fecha_Actual) THEN
		SET Par_NumErr  := 010;
		SET Par_ErrMen  := 'La Vigencia No Debe Ser Menor a la Fecha Actual';
		SET varControl  := 'vigencia' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_OperacionesMOTO, Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr  := 011;
		SET Par_ErrMen  := 'Especifique Operaciones MOTO';
		SET varControl  := 'operacionesMOTO' ;
		LEAVE ManejoErrores;
	END IF;

    INSERT INTO TARCRELIMITES(
		TarjetaCredID,			NoDisposiDia,				NumConsultaMes,		DisposiDiaNac,		DisposiMesNac,
		ComprasDiaNac,			ComprasMesNac,				BloquearATM,		BloquearPOS,		BloquearCashBack,
		Vigencia,				AceptaOpeMoto,				EmpresaID,			Usuario,			FechaActual,
		DireccionIP,			ProgramaID,					Sucursal,			NumTransaccion)
    VALUES(
        Par_TarjetaCredID,		Par_DisposicionesDia,   	Par_NumConsultaMes, Par_MontoMaxDia,    Par_MontoMaxMes,
		Par_MontoMaxCompraDia,	Par_MontoMaxComprasMensual, Par_BloqueoATM,		Par_BloqueoPOS,     Par_BloqueoCashback,
		Par_Vigencia,			Par_OperacionesMOTO,		Aud_EmpresaID,		Aud_Usuario,        Aud_FechaActual,
		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion );

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Limites Agregados Exitosamente';
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