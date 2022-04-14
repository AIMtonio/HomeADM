-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBTRANSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBTRANSPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBTRANSPRO`(
    -- SP para afectaciones contables con operaciones de Tarjetas
	Par_TipoMensaje			CHAR(4),		-- Tipo de Mensaje
    Par_TipoOperacion       CHAR(2), 		-- Tipo de Operacion
    Par_NumeroTarjeta       CHAR(16),		-- Numero de Tarjeta
    Par_OrigenInstrumento   CHAR(2),		-- Origen del Instrumento
    Par_MontoTransaccion    VARCHAR(12),	-- Monto de la Transaccion

    Par_FechaHoraOperacion  VARCHAR(20),	-- Fecha y Hora de la operacion
    Par_NumeroTransaccion   VARCHAR(20),	-- Numero de Transaccion
    Par_GiroNegocio         CHAR(4), 		-- Giro del Negocio
    Par_PuntoEntrada        CHAR(2),		-- Punto de Entrada
    Par_IdTerminal          VARCHAR(40),	-- ID de la terminal

    Par_NomUbicTerminal     VARCHAR(50),	-- Nombre de la ubicacion de la terminal
    Par_Nip                 VARCHAR(50),	-- NIP
    Par_CodMonedaOpe        CHAR(4),		-- Codigo Moneda de operacion
    Par_MontosAdicionales   VARCHAR(12),	-- Montos Adicionales
    Par_MontoSurcharge      VARCHAR(12),

    Par_MontoLoyaltyfee     VARCHAR(12),
	Par_Referencia			VARCHAR(12),	-- Referencia
	Par_DatosTiempoAire		VARCHAR(90),	-- Datos del tiempo aire
	Par_CheckIn				CHAR(1),
	Par_CodigoAprobacion	VARCHAR(20)		-- Codigo de aprobacion
		)
TerminaStore:BEGIN

-- Declaracion de variables
DECLARE Var_EstatusTar  	INT(11);			-- Almacena el estatus de la tarjeta
DECLARE Var_FechaVencim 	CHAR(5);			-- Indica la fecha de vencimiento de la tarjeta
DECLARE Var_CuentaAhoID 	BIGINT(12);			-- Almacena el numero de la cuenta de la tarjeta
DECLARE Var_EstatusCta  	CHAR(1);			-- Indica el estatus de la cuenta
DECLARE Var_Cuenta      	INT(11);		    -- Almacena el numero de la cuenta de ahorro
DECLARE Var_TipoCancela    	INT(11);		    -- Almacena el motivo de cancelacion
DECLARE Var_TipoOperacion  	INT(11);		    -- Almacena el motivo de cancelacion

DECLARE Var_AnioActual  	VARCHAR(25);		-- Indica el valor del anio actual
DECLARE Par_FechaActual 	DATETIME;			-- INdica la fecha actual
DECLARE Var_TarDebMovID		INT(11); 			-- Id llave de la tabla TARDEBBITACORAMOVS
DECLARE Var_Referencia		VARCHAR(30); 		-- Almaneca referencia
DECLARE NumeroTransaccion	VARCHAR(6);         -- Se obtiene el numero de transaccion
DECLARE SaldoContableAct	VARCHAR(13);		-- Almacena el saldo contable

DECLARE SaldoDisponibleAct	VARCHAR(13);		-- Almacena el saldo disponible
DECLARE CodigoRespuesta   	VARCHAR(3);			-- Almacena el mensaje de respuesta
DECLARE FechaAplicacion		VARCHAR(4);			-- Almacena la fecha del sistema
DECLARE Var_CntTrDbBtcrMvs 	INT(11);   			-- Variable Para contar los registros existentes en la tabla TARDEBBITACORAMOVS
DECLARE Var_NumeroTransaccion 	BIGINT(20);   	-- Almacena el numero de transaccion
DECLARE Var_CodigoAprobacion 	BIGINT(20);   	-- Almacena el codigo de aprovacion
DECLARE Var_FechaSistema 	DATE;   			-- Almacena la fecha del sistema


DECLARE Cadena_Vacia    	CHAR(1);			-- Cadena vacia
DECLARE Entero_Cero     	INT(11);			-- Entero cero
DECLARE Entero_Uno			INT(11);			-- Entero uno
DECLARE Decimal_Cero    	DECIMAL(12,2);		-- DECIMAL cero
DECLARE String_Cero			CHAR(1);			-- String cero

DECLARE String_Uno			CHAR(1);			-- String uno
DECLARE Salida_NO       	CHAR(1);			-- Store salida NO
DECLARE Salida_SI       	CHAR(1);			-- Store salida SI
DECLARE CompraEnLinea   	CHAR(1);			-- Compra en linea
DECLARE OrigenCuentaAho 	CHAR(2);			-- Origen Instrumento: cuenta de ahorro

DECLARE OrigenCuentaChe 	CHAR(2);			-- Origen Instrumento: cuenta de chequera
DECLARE Error_Key			INT(11);			-- Valor del Error
DECLARE TransATMPOS			CHAR(4);			-- Numero de transaccion en cajeros POS
DECLARE AutorizaCheck		CHAR(4);			-- Numero de autorizacion CHECK
DECLARE MsjRevPreA			CHAR(4);			-- Numero de mensaje de reversa autorizado

DECLARE MsjRevPreAuto		CHAR(4);			-- Numero de mensaje de reversa pre autorizado
DECLARE Par_FecTranOrig		CHAR(4);			-- Fecha de transaccion de origen
DECLARE Par_HorTranOrig 	CHAR(8);			-- Hora de transaccion de origen
DECLARE Par_ValorDispensado	VARCHAR(12);		-- Valor dispersado
DECLARE CompraNormal        CHAR(2);			-- Tipo de compra normal

DECLARE RetiroEfectivo      CHAR(2);			-- Tipo retiro en efectivo
DECLARE ConsultaSaldo       CHAR(2);			-- Tipo consulta de saldo
DECLARE CompraRetiroEfec    CHAR(2);			-- Tipo compra retiro en efectivo
DECLARE CompraTiempoAire	CHAR(2);			-- Tipo compra de tiempo aire
DECLARE AjusteCompra		CHAR(2);			-- Tipo ajuste de compra

DECLARE Devolucion			CHAR(2);			-- Tipo devolucion
DECLARE CuentaActiva    	CHAR(1);			-- Estatus de la cuenta activa
DECLARE TarjetaActiva   	INT(11);			-- Numero que indica tarjeta activa
DECLARE TarjetaExpirada 	INT(11);			-- Numero que indica tarjeta expirada
DECLARE MonedaPesosTD   	INT(11);			-- Numero que indica la moneda en pesos de tarjeta

DECLARE MonedaPesosSF   	INT(11);			-- Numero que indica la modena en pesos
DECLARE Saldo_Cero			VARCHAR(13);		-- Saldo cero
DECLARE POSEnLineaSi		CHAR(1);			-- Operacion POS en linea SI
DECLARE Aud_EmpresaID       INT(11);			-- Campo auditoria
DECLARE Aud_Usuario         INT(11);			-- Campo auditoria

DECLARE Aud_DireccionIP     VARCHAR(15);		-- Campo auditoria
DECLARE Aud_ProgramaID      VARCHAR(50);		-- Campo auditoria
DECLARE Aud_Sucursal        INT(11);			-- Campo auditoria
DECLARE Aud_NumTransaccion	BIGINT(20);			-- Campo auditoria

DECLARE Par_NumErr          INT(11);			-- Numero de error
DECLARE Reporte_Robo        INT(11);			-- Reporte de robo
DECLARE Par_ErrMen          VARCHAR(150);		-- Mensaje de error
DECLARE IdentSocio	        CHAR(1);			-- Indica tipo de tarjeta identificacion de socio
DECLARE ComisionManejoUso	VARCHAR(13);		-- Comision por manejo de uso
DECLARE Var_Local			VARCHAR(18);		-- Conciliacion
DECLARE Tar_Bloqueada 		INT(11);			-- Tarjeta bloqueda
DECLARE Tar_Cancelada 		INT(11);			-- Tarjeta Cancelada
DECLARE Tar_Expirada   		INT(11);			-- Tarjeta Expirada

DECLARE Abono_EnLinea		INT(11);			-- Transaccion en Linea OXXO
DECLARE Abono_Archivo		INT(11);			-- Archivo Batch 510 (WALMART y SORIANA)


-- Asignacion de constantes
SET Cadena_Vacia    	:= '';				-- Cadena vacia
SET Entero_Cero     	:= 0;				-- Entero cero
SET Entero_Uno			:= 1;				-- Entero uno
SET Decimal_Cero    	:= 0.00;			-- DECIMAL cero
SET String_Cero			:= '0';				-- Cadena cero

SET String_Uno			:= '1';				-- Cadena uno
SET Salida_NO       	:= 'N';				-- Salida: NO
SET Salida_SI       	:= 'S';				-- Salida: SI
SET OrigenCuentaAho 	:= '10';			-- Origen Instrumento: Cuenta de Ahorro
SET OrigenCuentaChe 	:= '20';			-- Origen Instrumento: Cuenta de cheques

SET Saldo_Cero			:= 'C000000000000';	-- Saldo cero
SET Error_Key 			:= Entero_Cero;		-- Clave erroneo: Entero cero
SET POSEnLineaSi		:= 'S';				-- Operacion POS en linea: SI
SET TransATMPOS			:= '1200';			-- Numero de transaccion en cajeros POS
SET AutorizaCheck		:= '1220';			-- Numero de Aturozacion CHECK

SET MsjRevPreA			:= '1420';          -- Numero de mensaje reversa autorizado
SET MsjRevPreAuto		:= '1421';          -- Numero de mensaje reversa pre autorizado
SET CompraNormal        := '00';			-- Tipo de Operacion: Compra Normal
SET RetiroEfectivo      := '01';			-- Tipo de Operacion: Retiro Efectivo
SET ConsultaSaldo       := '31';			-- Tipo de Operacion: Consulta de Saldo

SET CompraRetiroEfec    := '09';			-- Tipo de Operacion: Compra con retiro en efectivo
SET CompraTiempoAire	:= '65';			-- Tipo de Operacion: Compra tiempo aire
SET AjusteCompra		:= '02';			-- Tipo de Operacion: Ajuste de compra
SET Devolucion			:= '20';			-- Tipo de Operacion: Devolucion
SET CuentaActiva    	:= 'A';				-- Estatus de la cuenta: Activa


SET TarjetaActiva   	:= 7;				-- Numero que indica que la tarjeta se encuentra activa
SET TarjetaExpirada 	:= 10;				-- Numero que indica que la tarjetase encuentra expirada
SET MonedaPesosTD   	:= 484;				-- Numero que identifica la moneda en pesos de Tarjetas
SET MonedaPesosSF   	:= 1;				-- Numero que identifica la moneda en pesos
SET Aud_EmpresaID   	:= 1;				-- Numero de empresa que realiza la transaccion

SET Aud_Usuario     	:= 1;				-- Numero de usuario que realiza la transaccion
SET Aud_DireccionIP 	:= '172.16.5.18';   -- Numero de direccion que realiza la transaccion
SET Aud_ProgramaID  	:= 'BrokerTD';      -- Nombre del recurso que realiza la transaccion
SET Aud_Sucursal    	:= 1;				-- Numero de sucursal que realiza la transaccion
SET Aud_NumTransaccion	:= Entero_Cero;     -- Numero de transaccion: Cero

SET IdentSocio      	:= 'S';   			-- Indica que el tipo de tarjeta es de identificacion de socio
SET Reporte_Robo		:= 	8; 				-- Reporte de robo
SET Var_Local			:= 	'WORKBENCH'; 	-- Conciliacion
SET Tar_Bloqueada 		:= 8;				-- Tarjeta blqueada
SET Tar_Cancelada 		:= 9;				-- Tarjeta Cancelada
SET Tar_Expirada  		:= 10;  			-- Tarjeta Expirada
SET Abono_EnLinea		:= '50';			-- Transaccion en Linea OXXO
SET Abono_Archivo		:= '51';			-- Archivo Batch 510 (WALMART y SORIANA)

    ManejoErrores:BEGIN

		SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);


		SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS LIMIT 1;

        IF TRIM(Par_GiroNegocio) = '' THEN
			SET Par_GiroNegocio := 0;
		END IF;

        IF TRIM(Par_CodigoAprobacion) = '' THEN
			SET Par_CodigoAprobacion := 0;
		END IF;


		SET Var_NumeroTransaccion	:= CONVERT(TRIM(Par_NumeroTransaccion),UNSIGNED);
		SET Par_GiroNegocio			:= CONVERT(TRIM(Par_GiroNegocio),UNSIGNED);
		SET Par_DatosTiempoAire		:= TRIM(Par_DatosTiempoAire);
		SET Par_CheckIn				:= TRIM(Par_CheckIn);
		SET Var_CodigoAprobacion	:= CONVERT(TRIM(Par_CodigoAprobacion),UNSIGNED);
		SET Par_Referencia			:= TRIM(Par_Referencia);

		SET Par_IdTerminal			:= TRIM(Par_IdTerminal);

		SET Par_MontoTransaccion    := (SELECT CONVERT(CONCAT(CAST(SUBSTRING(Par_MontoTransaccion, 1, 10) AS SIGNED) ,'.',
										SUBSTRING(Par_MontoTransaccion, 11,2)), DECIMAL(12,2)));
        SET Par_MontosAdicionales   := (SELECT CONVERT(CONCAT(CAST(SUBSTRING(Par_MontosAdicionales, 1, 10) AS SIGNED) ,'.',
										SUBSTRING(Par_MontosAdicionales, 11,2)), DECIMAL(12,2)));
        SET Par_MontoSurcharge      := (SELECT CONVERT(CONCAT(CAST(SUBSTRING(Par_MontoSurcharge, 1, 10) AS SIGNED) ,'.',
										SUBSTRING(Par_MontoSurcharge, 11,2)), DECIMAL(12,2)));
        SET Par_MontoLoyaltyfee     := (SELECT CONVERT(CONCAT(CAST(SUBSTRING(Par_MontoLoyaltyfee, 1, 10) AS SIGNED) ,'.',
										SUBSTRING(Par_MontoLoyaltyfee, 11,2)), DECIMAL(12,2)));

        IF Par_IdTerminal = Var_Local THEN
           SET Par_FechaHoraOperacion = substr(Par_FechaHoraOperacion,3);
        END IF;

		SET Par_FechaActual := STR_TO_DATE(CONCAT(DATE_FORMAT(Var_FechaSistema,'%Y'),TRIM(Par_FechaHoraOperacion)),'%Y%m%d%H%i%s');
		SET Par_FechaHoraOperacion := DATE_FORMAT(Par_FechaActual, '%Y-%m-%d %H:%i:%s');

        SET CompraEnLinea   := (SELECT IFNULL(tip.CompraPOSLinea, POSEnLineaSi)
                                  FROM TARJETADEBITO tar, TIPOTARJETADEB tip
                                 WHERE tar.TipoTarjetaDebID = tip.TipoTarjetaDebID
                                   AND tip.IdentificacionSocio != IdentSocio
                                   AND tar.TarjetaDebID = Par_NumeroTarjeta);

		SET CompraEnLinea := IFNULL(CompraEnLinea, POSEnLineaSi);


      IF(Par_TipoMensaje = TransATMPOS) THEN
        SELECT COUNT(*)
		  INTO Var_CntTrDbBtcrMvs
		  FROM TARDEBBITACORAMOVS
		 WHERE TARJETADEBID = Par_NumeroTarjeta
           AND REFERENCIA = Par_Referencia
           AND TERMINALID = Par_IdTerminal
		   AND MONTOOPE = Par_MontoTransaccion
           AND ESTATUS = 'P'
           AND DATE_FORMAT(fechahrope, '%Y-%m-%d %H:%i:%s') = DATE_FORMAT( Par_FechaActual, '%Y-%m-%d %H:%i:%s');
       END IF;

		CALL TARDEBBITACORAMOVSALT(
			Par_TipoMensaje,    	Par_TipoOperacion,		Par_NumeroTarjeta,	Par_OrigenInstrumento,	Par_MontoTransaccion,
			Par_FechaActual,		Var_NumeroTransaccion,	Par_GiroNegocio,	Par_PuntoEntrada,    	Par_IdTerminal,
			Par_NomUbicTerminal,    Par_Nip,    			Par_CodMonedaOpe,	Par_MontosAdicionales,	Par_MontoSurcharge,
			Par_MontoLoyaltyfee,	Par_Referencia, 		Par_DatosTiempoAire,Par_CheckIn,			Var_CodigoAprobacion,
			CompraEnLinea,			Var_TarDebMovID, 		Salida_NO,			Aud_EmpresaID,			Aud_Usuario,
			Par_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion );

        IF(Par_TipoOperacion = Abono_EnLinea OR Par_TipoOperacion = Abono_Archivo) THEN
        	SET Var_TipoOperacion := Par_TipoOperacion;
			SET Par_TipoOperacion := Abono_EnLinea;
        END IF;

       IF(Var_CntTrDbBtcrMvs > Entero_Cero)THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "308";
			SET FechaAplicacion		:= FechaAplicacion;
			LEAVE ManejoErrores;
	   END IF;

		IF (IFNULL(Par_TipoMensaje, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
			LEAVE ManejoErrores;
        END IF;

        IF (IFNULL(Par_TipoOperacion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
			LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_NumeroTarjeta, Cadena_Vacia) != Cadena_Vacia)THEN
            IF(CHAR_LENGTH(Par_NumeroTarjeta) != 16) THEN
				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "214";
				SET FechaAplicacion		:= FechaAplicacion;
                SET ComisionManejoUso	:= Saldo_Cero;
                LEAVE ManejoErrores;
            END IF;
        ELSE
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "214";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;


        IF (IFNULL(Par_OrigenInstrumento, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;


        IF (IFNULL(Par_FechaHoraOperacion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_NumeroTransaccion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;

        IF(Par_CodMonedaOpe != MonedaPesosTD) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_MontoTransaccion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_GiroNegocio, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_IdTerminal, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;

        SELECT tar.Estatus, tar.FechaVencimiento, tar.CuentaAhoID, tar.MotivoCancelacion
          INTO Var_EstatusTar, Var_FechaVencim, Var_CuentaAhoID, Var_TipoCancela
          FROM TARJETADEBITO tar
          WHERE tar.TarjetaDebID = Par_NumeroTarjeta;


        IF(IFNULL(Var_EstatusTar, Entero_Cero)<> TarjetaActiva ) THEN
            IF(IFNULL(Var_EstatusTar, Entero_Cero) = Tar_Bloqueada ) THEN

				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "334";
				SET FechaAplicacion		:= FechaAplicacion;
                SET ComisionManejoUso	:= Saldo_Cero;

            ELSEIF(IFNULL(Var_EstatusTar, Entero_Cero) = Tar_Cancelada AND IFNULL(Var_TipoCancela,Entero_Cero) = Reporte_Robo  ) THEN

				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "333";
				SET FechaAplicacion		:= FechaAplicacion;
                SET ComisionManejoUso	:= Saldo_Cero;

            ELSEIF(IFNULL(Var_EstatusTar, Entero_Cero) = Tar_Expirada ) THEN

				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "215";
				SET FechaAplicacion		:= FechaAplicacion;
                SET ComisionManejoUso	:= Saldo_Cero;
            ELSE

				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "214";
				SET FechaAplicacion		:= FechaAplicacion;
                SET ComisionManejoUso	:= Saldo_Cero;
            END IF;
            LEAVE ManejoErrores;
        END IF;

        SELECT Estatus, CuentaAhoID
            INTO Var_EstatusCta, Var_Cuenta
            FROM CUENTASAHO
            WHERE CuentaAhoID = Var_CuentaAhoID;

        IF( IFNULL(Var_Cuenta,Entero_Cero) = Entero_Cero) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "116";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;

        IF(Var_EstatusCta<> CuentaActiva) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "116";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_MontosAdicionales, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;


		CASE Par_TipoOperacion
            WHEN    CompraNormal    THEN

				IF ( Par_TipoMensaje = TransATMPOS AND Par_CheckIn = String_Cero ) THEN

					START TRANSACTION;
						BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;

						CALL TARDEBPREAUTORIZAPRO(
							Par_TipoOperacion,	Par_NumeroTarjeta,	Par_Referencia,			Par_MontoTransaccion,	Par_MontosAdicionales,
							Par_GiroNegocio,	MonedaPesosSF,		Var_NumeroTransaccion,  CompraEnLinea,          Par_FechaActual,
							NumeroTransaccion, 	SaldoContableAct,	SaldoDisponibleAct,		CodigoRespuesta, 		FechaAplicacion,
							Var_TarDebMovID);



						IF (CodigoRespuesta = Entero_Cero) THEN
							SET NumeroTransaccion	:= NumeroTransaccion;
							SET SaldoContableAct	:= SaldoContableAct;
							SET SaldoDisponibleAct	:= SaldoDisponibleAct;
							SET CodigoRespuesta   	:= "000";
							SET FechaAplicacion		:= FechaAplicacion;
                            SET ComisionManejoUso	:= ComisionManejoUso;
							COMMIT;
						ELSEIF (CodigoRespuesta != Entero_Cero) THEN
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= CodigoRespuesta;
							SET FechaAplicacion		:= FechaAplicacion;
							SET ComisionManejoUso	:= Saldo_Cero;
							ROLLBACK;
							LEAVE ManejoErrores;
						END IF;
					 END;
					IF (Error_Key != Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Cadena_Vacia;
						SET SaldoDisponibleAct	:= Cadena_Vacia;
						SET CodigoRespuesta 	:= "909";
						SET FechaAplicacion		:= FechaAplicacion;
						SET ComisionManejoUso	:= Cadena_Vacia;
						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;

				ELSEIF (Par_TipoMensaje = AutorizaCheck AND Par_CheckIn = Entero_Uno) THEN

					START TRANSACTION;
						BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;

						CALL TARDEBAUTORIZAPRO(
							Par_TipoOperacion,	Par_NumeroTarjeta,	Par_Referencia,			Par_MontoTransaccion,	Par_MontosAdicionales,
							Par_GiroNegocio,	MonedaPesosSF,		Var_NumeroTransaccion,  CompraEnLinea,          Var_CodigoAprobacion,
							Par_FechaActual,	NumeroTransaccion, 	SaldoContableAct,		SaldoDisponibleAct,		CodigoRespuesta,
							FechaAplicacion, 	Var_TarDebMovID);


						IF (CodigoRespuesta != Entero_Cero) THEN
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= CodigoRespuesta;
							SET FechaAplicacion		:= FechaAplicacion;
                            SET ComisionManejoUso	:= Saldo_Cero;
							ROLLBACK;
							LEAVE ManejoErrores;
						END IF;

						CALL TARDEBAUTORIZACOM(
							Par_TipoMensaje, 		Par_TipoOperacion,		Par_NumeroTarjeta,	Par_OrigenInstrumento,	Par_MontoTransaccion,
							Par_FechaActual,		NumeroTransaccion,		Par_GiroNegocio,	Par_PuntoEntrada,		Par_IdTerminal,
							Par_NomUbicTerminal,	Par_Nip,				Par_CodMonedaOpe,	Par_MontosAdicionales,	Par_MontoSurcharge,
							Par_MontoLoyaltyfee,	Par_Referencia, 		CompraEnLinea,		Var_CodigoAprobacion,	Salida_NO,
							Error_Key,				CodigoRespuesta);

						IF (CodigoRespuesta = Entero_Cero) THEN
							SET NumeroTransaccion	:= NumeroTransaccion;
							SET SaldoContableAct	:= SaldoContableAct;
							SET SaldoDisponibleAct	:= SaldoDisponibleAct;
							SET CodigoRespuesta   	:= "000";
							SET FechaAplicacion		:= FechaAplicacion;
							SET ComisionManejoUso	:= ComisionManejoUso;

							COMMIT;
						ELSEIF (CodigoRespuesta != Entero_Cero) THEN
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= CodigoRespuesta;
							SET FechaAplicacion		:= FechaAplicacion;
							SET ComisionManejoUso	:= Saldo_Cero;

							ROLLBACK;
							LEAVE ManejoErrores;
						END IF;
					END;
					IF (Error_Key != Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Cadena_Vacia;
						SET SaldoDisponibleAct	:= Cadena_Vacia;
						SET CodigoRespuesta 	:= "909";
						SET FechaAplicacion		:= FechaAplicacion;
						SET ComisionManejoUso	:= Cadena_Vacia;

						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;

				ELSEIF ( (Par_TipoMensaje = MsjRevPreA) OR (Par_TipoMensaje = MsjRevPreAuto )) THEN

					START TRANSACTION;
						BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;

						CALL TARDEBREVPREAUTORIZA(
							Par_TipoOperacion,	Par_NumeroTarjeta,	Par_Referencia,			Par_MontoTransaccion,	Par_MontosAdicionales,
							Par_GiroNegocio,	MonedaPesosSF,		Var_NumeroTransaccion,  CompraEnLinea,          Var_CodigoAprobacion,
							Par_FechaActual,	NumeroTransaccion, 	SaldoContableAct,		SaldoDisponibleAct,		CodigoRespuesta,
							FechaAplicacion, 	Var_TarDebMovID);

						IF (CodigoRespuesta = Entero_Cero) THEN
							SET NumeroTransaccion	:= NumeroTransaccion;
							SET SaldoContableAct	:= SaldoContableAct;
							SET SaldoDisponibleAct	:= SaldoDisponibleAct;
							SET CodigoRespuesta   	:= "000";
							SET FechaAplicacion		:= FechaAplicacion;
							SET ComisionManejoUso	:= ComisionManejoUso;

							COMMIT;
						ELSEIF (CodigoRespuesta != Entero_Cero) THEN
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= CodigoRespuesta;
							SET FechaAplicacion		:= FechaAplicacion;
							SET ComisionManejoUso	:= Saldo_Cero;

							ROLLBACK;
							LEAVE ManejoErrores;
						END IF;
					END;
					IF (Error_Key != Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Cadena_Vacia;
						SET SaldoDisponibleAct	:= Cadena_Vacia;
						SET CodigoRespuesta 	:= "909";
						SET FechaAplicacion		:= FechaAplicacion;
						SET ComisionManejoUso	:= Cadena_Vacia;

						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;

				ELSE  -- validar que sea compra con tarjeta

					START TRANSACTION;
						BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;


						CALL TARDEBCOMNORPRO(
							Par_TipoOperacion,	Par_NumeroTarjeta,	Par_Referencia,			Par_MontoTransaccion,	Par_MontosAdicionales,
							Par_GiroNegocio,	MonedaPesosSF,		Var_NumeroTransaccion,  CompraEnLinea,          Par_FechaActual,
							Par_NomUbicTerminal,NumeroTransaccion, 	SaldoContableAct,		SaldoDisponibleAct,		CodigoRespuesta,
							FechaAplicacion, 	Var_TarDebMovID);

						IF (CodigoRespuesta != Entero_Cero) THEN
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= CodigoRespuesta;
							SET FechaAplicacion		:= FechaAplicacion;
							SET ComisionManejoUso	:= Saldo_Cero;

							ROLLBACK;
							LEAVE ManejoErrores;
						END IF;

						CALL TARDEBCOMNORCOM(
							Par_TipoMensaje, 		Par_TipoOperacion,		Par_NumeroTarjeta,	Par_OrigenInstrumento,	Par_MontoTransaccion,
							Par_FechaActual,		NumeroTransaccion,		Par_GiroNegocio,	Par_PuntoEntrada,		Par_IdTerminal,
							Par_NomUbicTerminal,	Par_Nip,				Par_CodMonedaOpe,	Par_MontosAdicionales,	Par_MontoSurcharge,
							Par_MontoLoyaltyfee,	Par_Referencia, 		CompraEnLinea,		Salida_NO, 				Error_Key,
							CodigoRespuesta);

						IF (CodigoRespuesta = Entero_Cero) THEN
							SET NumeroTransaccion	:= NumeroTransaccion;
							SET SaldoContableAct	:= SaldoContableAct;
							SET SaldoDisponibleAct	:= SaldoDisponibleAct;
							SET CodigoRespuesta   	:= "000";
							SET FechaAplicacion		:= FechaAplicacion;
							SET ComisionManejoUso	:= ComisionManejoUso;

							COMMIT;
						ELSEIF (CodigoRespuesta != Entero_Cero) THEN
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= CodigoRespuesta;
							SET FechaAplicacion		:= FechaAplicacion;
							SET ComisionManejoUso	:= Saldo_Cero;

							ROLLBACK;
							LEAVE ManejoErrores;
						END IF;
					END;

					IF ( Error_Key != Entero_Cero ) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Cadena_Vacia;
						SET SaldoDisponibleAct	:= Cadena_Vacia;
						SET CodigoRespuesta 	:= "909";
						SET FechaAplicacion		:= FechaAplicacion;
						SET ComisionManejoUso	:= Cadena_Vacia;
						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;
				END IF;

			WHEN AjusteCompra	THEN
				IF (Par_TipoMensaje = AutorizaCheck) THEN

					START TRANSACTION;
						BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;


						CALL TARDEBAJUSTECOMPRO(
							Par_TipoOperacion,	Par_NumeroTarjeta,	Var_CodigoAprobacion,	Par_MontoTransaccion,	Par_MontosAdicionales,
							Par_IdTerminal, 	Par_GiroNegocio,	MonedaPesosSF,		Var_NumeroTransaccion,  CompraEnLinea,
							Par_FechaActual,	NumeroTransaccion, 	SaldoContableAct,	SaldoDisponibleAct,		CodigoRespuesta,
							FechaAplicacion,	Var_TarDebMovID);

						IF (CodigoRespuesta = Entero_Cero) THEN
							SET NumeroTransaccion	:= NumeroTransaccion;
							SET SaldoContableAct	:= SaldoContableAct;
							SET SaldoDisponibleAct	:= SaldoDisponibleAct;
							SET CodigoRespuesta   	:= "000";
							SET FechaAplicacion		:= FechaAplicacion;
                            SET ComisionManejoUso	:= ComisionManejoUso;
							COMMIT;
						ELSEIF (CodigoRespuesta != Entero_Cero) THEN
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= CodigoRespuesta;
							SET FechaAplicacion		:= FechaAplicacion;
                            SET ComisionManejoUso	:= Saldo_Cero;
							ROLLBACK;
							LEAVE ManejoErrores;
						END IF;
					END;

					IF ( Error_Key != Entero_Cero ) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Cadena_Vacia;
						SET SaldoDisponibleAct	:= Cadena_Vacia;
						SET CodigoRespuesta 	:= "909";
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= Cadena_Vacia;
						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;

				END IF;
            WHEN    RetiroEfectivo  THEN
				START TRANSACTION;
					BEGIN
                    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;


					CALL TARDEBRETEFEPRO(
						Par_TipoOperacion, 	Par_NumeroTarjeta,  	Par_Referencia,		Par_MontoTransaccion,   Par_MontosAdicionales,
						Par_MontoSurcharge,	Par_MontoLoyaltyfee,	MonedaPesosSF,      Var_NumeroTransaccion,  Par_FechaActual,
						Par_NomUbicTerminal,NumeroTransaccion, 		SaldoContableAct, 	SaldoDisponibleAct, 	CodigoRespuesta,
						FechaAplicacion, Var_TarDebMovID);

					IF (CodigoRespuesta != Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= CodigoRespuesta;
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= Saldo_Cero;
						ROLLBACK;
						LEAVE ManejoErrores;
					ELSE


						CALL TARDEBRETEFECOM(
							Par_TipoMensaje, 		Par_TipoOperacion,		Par_NumeroTarjeta,	Par_OrigenInstrumento,	Par_MontoTransaccion,
							Par_FechaActual,		NumeroTransaccion,		Par_GiroNegocio,	Par_PuntoEntrada,		Par_IdTerminal,
							Par_NomUbicTerminal,	Par_Nip,				Par_CodMonedaOpe,	Par_MontosAdicionales,	Par_MontoSurcharge,
							Par_MontoLoyaltyfee,	Par_Referencia, 		Salida_NO,			Error_Key, 				CodigoRespuesta);

						IF (CodigoRespuesta = Entero_Cero) THEN
							SET NumeroTransaccion	:= NumeroTransaccion;
							SET SaldoContableAct	:= SaldoContableAct;
							SET SaldoDisponibleAct	:= SaldoDisponibleAct;
							SET CodigoRespuesta   	:= "000";
							SET FechaAplicacion		:= FechaAplicacion;
                            SET ComisionManejoUso	:= ComisionManejoUso;
							COMMIT;
						ELSEIF (CodigoRespuesta != Entero_Cero) THEN
							SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
							SET SaldoContableAct	:= Saldo_Cero;
							SET SaldoDisponibleAct	:= Saldo_Cero;
							SET CodigoRespuesta   	:= CodigoRespuesta;
							SET FechaAplicacion		:= FechaAplicacion;
                            SET ComisionManejoUso	:= Saldo_Cero;
							ROLLBACK;
							LEAVE ManejoErrores;
						END IF;

					END IF;-- codigo de r4espuesta<>0
				END;

				IF (Error_Key != Entero_Cero) THEN
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Cadena_Vacia;
					SET SaldoDisponibleAct	:= Cadena_Vacia;
					SET CodigoRespuesta 	:= "909";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Cadena_Vacia;
					ROLLBACK;
					LEAVE ManejoErrores;
				END IF;

            WHEN    ConsultaSaldo   THEN
				START TRANSACTION;
					BEGIN
                    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;

					CALL TARDEBCONSALPRO (
						Par_TipoOperacion, 		Par_NumeroTarjeta,  	Par_Referencia,			Par_MontoTransaccion,   Par_MontoSurcharge,
						Par_MontoLoyaltyfee,	MonedaPesosSF,			Var_NumeroTransaccion,  Par_FechaActual,    	Par_NomUbicTerminal,
						NumeroTransaccion,		SaldoContableAct,		SaldoDisponibleAct,		CodigoRespuesta, 		FechaAplicacion,
                        Var_TarDebMovID);

					IF (CodigoRespuesta != Entero_Cero) THEN

						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= CodigoRespuesta;
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= Saldo_Cero;
						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;

					CALL TARDEBCONSALCOM(
						Par_TipoMensaje, 		Par_TipoOperacion,		Par_NumeroTarjeta,	Par_OrigenInstrumento,	Par_MontoTransaccion,
						Par_FechaActual,		NumeroTransaccion,		Par_GiroNegocio,	Par_PuntoEntrada,		Par_IdTerminal,
						Par_NomUbicTerminal,	Par_Nip,				Par_CodMonedaOpe,	Par_MontosAdicionales,	Par_MontoSurcharge,
						Par_MontoLoyaltyfee,	Par_Referencia, 		Salida_NO, 			Error_Key, 				CodigoRespuesta);

					IF (CodigoRespuesta = Entero_Cero) THEN
						SET NumeroTransaccion	:= NumeroTransaccion;
						SET SaldoContableAct	:= SaldoContableAct;
						SET SaldoDisponibleAct	:= SaldoDisponibleAct;
						SET CodigoRespuesta   	:= "000";
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= ComisionManejoUso;
						COMMIT;
					ELSEIF (CodigoRespuesta != Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= CodigoRespuesta;
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= Saldo_Cero;
						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;
				END;

				IF (Error_Key != Entero_Cero) THEN
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Cadena_Vacia;
					SET SaldoDisponibleAct	:= Cadena_Vacia;
					SET CodigoRespuesta 	:= "909";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Cadena_Vacia;
					ROLLBACK;
					LEAVE ManejoErrores;
				END IF;

            WHEN    CompraRetiroEfec    THEN
				START TRANSACTION;
					BEGIN
                    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;

					CALL TARDEBCOMRETPRO(
						Par_TipoOperacion, 		Par_NumeroTarjeta,	Par_Referencia,			Par_MontoTransaccion,   Par_MontosAdicionales,
						Par_GiroNegocio,    	MonedaPesosSF,		Var_NumeroTransaccion,  CompraEnLinea,      	Par_FechaActual,
						Par_NomUbicTerminal, 	NumeroTransaccion, 	SaldoContableAct,		SaldoDisponibleAct,		CodigoRespuesta,
						FechaAplicacion, 		Var_TarDebMovID);

					IF (CodigoRespuesta != Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= CodigoRespuesta;
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= Saldo_Cero;
						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;

					CALL TARDEBCOMRETCOM(
						Par_TipoMensaje,		Par_TipoOperacion,		Par_NumeroTarjeta,		Par_OrigenInstrumento,	Par_MontoTransaccion,
						Par_FechaActual,		NumeroTransaccion,		Par_MontosAdicionales,	Par_MontoSurcharge,		CompraEnLinea,
						Salida_NO,				Error_Key, 				CodigoRespuesta);

					IF (CodigoRespuesta = Entero_Cero) THEN
						SET NumeroTransaccion	:= NumeroTransaccion;
						SET SaldoContableAct	:= SaldoContableAct;
						SET SaldoDisponibleAct	:= SaldoDisponibleAct;
						SET CodigoRespuesta   	:= "000";
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= ComisionManejoUso;
						COMMIT;
					ELSEIF (CodigoRespuesta != Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= CodigoRespuesta;
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= Saldo_Cero;
						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;
				END;

				IF (Error_Key != Entero_Cero) THEN
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Cadena_Vacia;
					SET SaldoDisponibleAct	:= Cadena_Vacia;
					SET CodigoRespuesta 	:= "909";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Cadena_Vacia;
					ROLLBACK;
					LEAVE ManejoErrores;
				END IF;

			WHEN    CompraTiempoAire	THEN
				START TRANSACTION;
					BEGIN
                    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;


					CALL TARDEBCOMTPOPRO(
						Par_TipoOperacion, 	Par_NumeroTarjeta,  	Par_Referencia,		Par_MontoTransaccion,   Par_MontosAdicionales,
						Par_MontoSurcharge,	Par_IdTerminal,			Par_DatosTiempoAire,MonedaPesosSF,      	Var_NumeroTransaccion,
						Par_FechaActual,	Par_NomUbicTerminal, 	NumeroTransaccion, 	SaldoContableAct, 		SaldoDisponibleAct,
						CodigoRespuesta, 	FechaAplicacion, Var_TarDebMovID);

					IF (CodigoRespuesta != Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= CodigoRespuesta;
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= Saldo_Cero;
						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;

					CALL TARDEBCOMTPOCOM(
						Par_TipoMensaje, 		Par_TipoOperacion,		Par_NumeroTarjeta,	Par_OrigenInstrumento,	Par_MontoTransaccion,
						Par_FechaActual,		NumeroTransaccion,		Par_GiroNegocio,	Par_PuntoEntrada,		Par_IdTerminal,
						Par_NomUbicTerminal,	Par_Nip,				Par_CodMonedaOpe,	Par_MontosAdicionales,	Par_MontoSurcharge,
						Par_DatosTiempoAire,	Par_Referencia, 		Salida_NO,			Error_Key, 				CodigoRespuesta);

					IF (CodigoRespuesta = Entero_Cero) THEN
						SET NumeroTransaccion	:= NumeroTransaccion;
						SET SaldoContableAct	:= SaldoContableAct;
						SET SaldoDisponibleAct	:= SaldoDisponibleAct;
						SET CodigoRespuesta   	:= "000";
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= ComisionManejoUso;
						COMMIT;
					ELSEIF (CodigoRespuesta != Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= CodigoRespuesta;
						SET FechaAplicacion		:= FechaAplicacion;
                        SET ComisionManejoUso	:= Saldo_Cero;
						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;
				END;

				IF (Error_Key != Entero_Cero) THEN
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Cadena_Vacia;
					SET SaldoDisponibleAct	:= Cadena_Vacia;
					SET CodigoRespuesta 	:= "909";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Cadena_Vacia;
					ROLLBACK;
					LEAVE ManejoErrores;
				END IF;

			WHEN	Devolucion	THEN

				IF ( (Par_TipoMensaje = TransATMPOS	) OR (Par_TipoMensaje = AutorizaCheck )) THEN
					SELECT Referencia  INTO Var_Referencia
					FROM TARDEBBITACORAMOVS
					WHERE CONVERT(NumTransaccion, UNSIGNED) = CONVERT(Var_CodigoAprobacion, UNSIGNED);


                    SET Par_FecTranOrig		:= DATE_FORMAT(Par_FechaHoraOperacion,'%m%d');
					SET Par_HorTranOrig		:= DATE_FORMAT(Par_FechaHoraOperacion,'%H%i%s');
					SET Par_MontoTransaccion:= (SELECT LPAD(REPLACE(CONVERT(Par_MontoTransaccion,CHAR) , '.', ''), 12, 0));
					SET Par_ValorDispensado	:= '000000000000';

					CALL TARDEBTRANSREVPRO(
						Par_TipoMensaje,		Var_Referencia,			Par_FecTranOrig,	Par_HorTranOrig,		Par_FecTranOrig,
						Par_MontoTransaccion,	Par_IdTerminal,			Par_NumeroTarjeta,	Par_ValorDispensado,	Par_CodigoAprobacion,	Par_TipoOperacion );



                    LEAVE TerminaStore;
				END IF;

			# CUANDO EL PAGO DE UN CREDITO SEA EN LINEA O POR MEDIO DEL ARCHIVO BATCH 150
			WHEN    Abono_EnLinea THEN

				START TRANSACTION;
					BEGIN
                    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;

                    SET Par_TipoOperacion := Var_TipoOperacion;

					CALL TARDEBABONOCREPRO(
						Par_TipoOperacion,		Par_NumeroTarjeta,	Par_Referencia,		Par_MontoTransaccion,	MonedaPesosSF,
                        Var_NumeroTransaccion,	Par_FechaActual,	NumeroTransaccion, 	SaldoContableAct,		SaldoDisponibleAct,
                        CodigoRespuesta, 		FechaAplicacion,	Var_TarDebMovID);

					IF (CodigoRespuesta = Entero_Cero) THEN
						SET NumeroTransaccion	:= NumeroTransaccion;
						SET SaldoContableAct	:= SaldoContableAct;
						SET SaldoDisponibleAct	:= SaldoDisponibleAct;
						SET CodigoRespuesta   	:= "000";
						SET FechaAplicacion		:= FechaAplicacion;
						SET ComisionManejoUso	:= Saldo_Cero;
						COMMIT;
					ELSEIF (CodigoRespuesta != Entero_Cero) THEN
						SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
						SET SaldoContableAct	:= Saldo_Cero;
						SET SaldoDisponibleAct	:= Saldo_Cero;
						SET CodigoRespuesta   	:= CodigoRespuesta;
						SET FechaAplicacion		:= FechaAplicacion;
						SET ComisionManejoUso	:= Saldo_Cero;
						ROLLBACK;
						LEAVE ManejoErrores;
					END IF;

				END;

				IF (Error_Key != Entero_Cero) THEN
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Cadena_Vacia;
					SET SaldoDisponibleAct	:= Cadena_Vacia;
					SET CodigoRespuesta 	:= "909";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Cadena_Vacia;
					ROLLBACK;
					LEAVE ManejoErrores;
				END IF;

			ELSE


				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "412";
				SET FechaAplicacion		:= FechaAplicacion;
                SET ComisionManejoUso	:= Saldo_Cero;
                LEAVE ManejoErrores;
            END CASE;
    END ManejoErrores;

	CALL TARDEBCODIGORESPUESTAPRO(
		CodigoRespuesta,		CodigoRespuesta,		Par_TipoOperacion, 		Salida_NO, 			Par_NumErr,
        Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,				Par_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,			Aud_Sucursal,			NumeroTransaccion);



	CALL TARDEBBITACORESPALT(
		Par_NumeroTarjeta,	Par_TipoMensaje,    Par_TipoOperacion,	Par_FechaHoraOperacion,	Par_MontoTransaccion,
		Par_IdTerminal,		Par_Referencia, 	NumeroTransaccion, 	SaldoContableAct, 		SaldoDisponibleAct,
		CodigoRespuesta,	Par_NumErr,			Par_ErrMen,			Salida_NO,				Aud_EmpresaID,
		Aud_Usuario,		Par_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
		NumeroTransaccion	);

    SELECT
		NumeroTransaccion,

        CONVERT(CONCAT(CAST(SUBSTRING(SaldoContableAct, 2, 10) AS SIGNED) ,'.',
										SUBSTRING(SaldoContableAct, 12)), DECIMAL(12,2)) AS SaldoContableAct,

         CONVERT(CONCAT(CAST(SUBSTRING(SaldoDisponibleAct, 2, 10) AS SIGNED) ,'.',
										SUBSTRING(SaldoDisponibleAct, 12)), DECIMAL(12,2)) AS SaldoDisponibleAct,
		CodigoRespuesta,
		FechaAplicacion,

        CONVERT(CONCAT(CAST(SUBSTRING(IFNULL(ComisionManejoUso,0), 2, 10) AS SIGNED) ,'.',
										SUBSTRING(IFNULL(ComisionManejoUso,0), 12)), DECIMAL(12,2)) AS ComisionManejoUso;


END TerminaStore$$