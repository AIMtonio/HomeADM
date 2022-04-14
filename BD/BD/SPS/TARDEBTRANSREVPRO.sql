-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBTRANSREVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBTRANSREVPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBTRANSREVPRO`(

	Par_TipoMensaje			CHAR(4),
	Par_Referencia			VARCHAR(12),
	Par_FecTranOrig			CHAR(4),		-- Fecha Transaccion mmaa
	Par_HorTranOrig			CHAR(8),		-- segundos en formato mmssmm
	Par_FecCaptura			CHAR(4),		-- Fecha Transaccion mmaa


	Par_MontoTransaccion	VARCHAR(13),	-- Monto + comisiones + IVA
	Par_IdTerminal			VARCHAR(40),
	Par_NumeroTarjeta		CHAR(16),
	Par_ValorDispensado		VARCHAR(12),
	Par_NumeroAutorizacion	VARCHAR(6),		-- Transaccion a reversar en SAFI

    Par_TipoTransaccion		VARCHAR(2)
	)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_TipoOperacion 		CHAR(2);			-- Valor tipo de operacion
	DECLARE Var_NumTarjeta			CHAR(16);			-- Numero de tarjeta
	DECLARE Var_MontoTransaccion	DECIMAL(12,2);		-- Monto de operacion
	DECLARE Var_MontoAdicional		DECIMAL(12,2);		-- Valor del monto adicional
	DECLARE Var_MontoSurcharge		DECIMAL(12,2);		-- Valor monto Surcharge

	DECLARE Var_NumTransaccion		BIGINT(20);			-- Numero de transaccion
	DECLARE Var_AnioActual  		CHAR(4);			-- Valor del anio actual
	DECLARE Var_FechaActual			DATETIME;			-- Se obtiene la fecha actual
	DECLARE Var_EstatusTar  		INT(11);			-- Estatus de la tarjeta
	DECLARE Var_CuentaAhoID 		BIGINT(12);			-- Valor de la cuenta de ahorro

	DECLARE Var_EstatusCta  		CHAR(1);			-- Estatus de la cuenta
	DECLARE Var_Cuenta      		INT(11);			-- Valor de la cuenta
	DECLARE Var_TipoMovAho			INT(11);			-- Valor del tipo de movimiento
	DECLARE Var_DatosTiempoAire		VARCHAR(70);		-- Datos tiempo aire
	DECLARE Var_NumAutorizacion     BIGINT(20);			-- Numero de operacion

	DECLARE FechaAplicacion			VARCHAR(4);			-- Fecha del sistema
	DECLARE Var_TarDebMovID	        INT(11); 			-- ID llave de la tabla TARDEBBITACORAMOVS
	DECLARE Var_TipoTRC				INT(11);

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Saldo_Cero				VARCHAR(13);
	DECLARE MonedaPesosSF   		INT(11);

	DECLARE CompraEnLinea			CHAR(1);
	DECLARE CompraNormal        	CHAR(2);
	DECLARE RetiroEfectivo      	CHAR(2);
	DECLARE ConsultaSaldo       	CHAR(2);
	DECLARE CompraRetiroEfec    	CHAR(2);

	DECLARE CompraTpoAire			CHAR(2);
	DECLARE Devolucion				CHAR(2);
	DECLARE NumeroTransaccion		VARCHAR(20);
	DECLARE SaldoContableAct		VARCHAR(13);
	DECLARE SaldoDisponibleAct		VARCHAR(13);

	DECLARE CodigoRespuesta			VARCHAR(3);
	DECLARE TarjetaActiva   		INT(11);
	DECLARE TarjetaExpirada			INT(11);
	DECLARE CuentaActiva			CHAR(1);
	DECLARE POSEnLineaSi			CHAR(1);

	DECLARE Error_Key				INT(11);
	DECLARE TipoMovCompra			INT(11);
	DECLARE TipoMovRetiro			INT(11);
	DECLARE TipoMovComRet			INT(11);
	DECLARE TipoMovIvaComRet		INT(11);

	DECLARE TipoMovComConSal		INT(11);
	DECLARE TipoMovIvaComCon		INT(11);
	DECLARE TipoMovRevTpoAire		INT(11);
	DECLARE Par_NumErr				INT(11);
	DECLARE Par_ErrMen				VARCHAR(150);

	DECLARE Salida_NO				CHAR(1);
	DECLARE Aud_EmpresaID			INT(11);
	DECLARE Aud_Usuario				INT(11);
	DECLARE Aud_FechaActual			DATETIME;
	DECLARE Aud_DireccionIP			VARCHAR(15);

	DECLARE Aud_ProgramaID			VARCHAR(50);
	DECLARE Aud_Sucursal			INT(11);
	DECLARE Aud_NumTransaccion		BIGINT(20);
	DECLARE IdentSocio	        	CHAR(1);
	DECLARE MontosAdiciona			DECIMAL(12,2);

	DECLARE MontoLoyaltyfee			DECIMAL(12,2);
	DECLARE Var_FechaHraOpe		    VARCHAR(19);
	DECLARE CodigoMonOpe    		CHAR(3);
	DECLARE ComisionManejoUso		VARCHAR(13);
	DECLARE Abono_EnLinea			INT(11);			-- Transaccion en Linea OXXO
	DECLARE Abono_Archivo			INT(11);			-- Archivo Batch 510 (WALMART y SORIANA)

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';						-- Cadena Vacia
	SET Entero_Cero			:= 0;						-- Entero Cero
	SET Decimal_Cero		:= 0.00;					-- DECIMAL Cero
	SET Saldo_Cero			:= '0.00';					-- Codigo de Saldo Cero
	SET MonedaPesosSF   	:= 1;   					-- Moneda Pesos

	SET TarjetaActiva   	:= 7;   					-- Estatus Tarjeta Activa
	SET TarjetaExpirada 	:= 10;  					-- Estatus Tarjeta Expirada
	SET CuentaActiva    	:= 'A'; 					-- Cuenta con estatus Activa
	SET TipoMovCompra		:= 90;  					-- Tipo de Movimiento de compra con TD
	SET TipoMovRetiro		:= 91;						-- Tipo de Movimiento de Retiro con TD

	SET TipoMovComRet		:= 92;						-- Tipo de Movimiento de comision retiro con TD
	SET TipoMovIvaComRet	:= 93;						-- Tipo de Movimeinto de IVA Comision retiro con TD
	SET TipoMovComConSal	:= 94;						-- Tipo de Movimeinto de Comision por consulta de Saldo
	SET TipoMovIvaComCon	:= 95; 						-- Tipo de movimiento IVA Comision por consulta de Saldo
	SET TipoMovRevTpoAire	:= 99;						-- Tipo de Movimiento Reversa Compra de tiempo Aire

	SET CompraNormal        :='00';						-- Tipo de Operacion Compra Normal
	SET RetiroEfectivo      :='01';						-- Tipo de Operacion Retiro de Efectivo
	SET ConsultaSaldo       :='31';						-- Tipo de Operacion consulta de saldo
	SET CompraRetiroEfec    :='09';						-- Tipo de Operacion Compra Retiro de Efectivo
	SET CompraTpoAire	    :='65';						-- Tipo de Operacion compra de tiempo aire

	SET Devolucion			:='20';						-- Tipo de Operacion Devolucion
	SET POSEnLineaSi		:= 'S';						-- transaccion realizada en Linea SI
	SET Error_Key       	:= Entero_Cero;				-- Error Cero
	SET Salida_NO			:= 'N';						-- Saldia en Pantalla NO
	SET Aud_EmpresaID		:= 1;						-- Parametro de auditoria

	SET Aud_Usuario			:= 1;						-- Parametro de auditoria
	SET Aud_FechaActual		:= NOW();					-- Parametro de auditoria
	SET Aud_DireccionIP		:= '127.0.0.1';				-- Parametro de auditoria
	SET Aud_ProgramaID		:= 'TARDEBTRANSREVPRO';		-- Parametro de auditoria
	SET Aud_Sucursal		:= 1;						-- Parametro de auditoria

	SET IdentSocio          := 'S';   					-- Si es Tarjeta de identificacion de Socio
	SET CodigoMonOpe    	:= '484';					-- Codigo moneda Pesos
	SET MontosAdiciona		:= 0000000000.00;
	SET MontoLoyaltyfee		:= 0000000000.00;
	SET Aud_NumTransaccion	:= Entero_Cero;

    SET Abono_EnLinea		:= '50';			-- Transaccion en Linea OXXO
	SET Abono_Archivo		:= '51';			-- Archivo Batch 510 (WALMART y SORIANA)

	ManejoErrores:BEGIN

		SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);

		SET Par_Referencia	:= TRIM(Par_Referencia);
		SET Par_IdTerminal	:= TRIM(Par_IdTerminal);


        SET Par_MontoTransaccion    := (SELECT CONVERT(CONCAT(CAST(SUBSTRING(Par_MontoTransaccion, 1, 10) AS SIGNED) ,'.',
										SUBSTRING(Par_MontoTransaccion, 11)), DECIMAL(12,2)));

		SET Par_ValorDispensado		:= (SELECT CONVERT(CONCAT(SUBSTRING(Par_ValorDispensado, 1, 10) ,'.',
										SUBSTRING(Par_ValorDispensado, 11)), DECIMAL(12,2)));

		SET Var_FechaActual := (SELECT FechaSistema FROM PARAMETROSSIS);


		SET CompraEnLinea   := (SELECT IFNULL(tip.CompraPOSLinea, POSEnLineaSi)
                                          FROM TARJETADEBITO tar, TIPOTARJETADEB tip
                                         WHERE tar.TipoTarjetaDebID = tip.TipoTarjetaDebID
                                           AND tip.IdentificacionSocio != IdentSocio
                                           AND tar.TarjetaDebID = Par_NumeroTarjeta);

	    SET Var_NumAutorizacion := CONVERT(Par_NumeroAutorizacion, UNSIGNED);



        SET Var_FechaHraOpe := (SELECT CONCAT(DATE_FORMAT(FechaSistema , '%Y'),Par_FecTranOrig,SUBSTRING(Par_HorTranOrig,1,6))
								  FROM PARAMETROSSIS);

        SET Var_FechaHraOpe := DATE_FORMAT(Var_FechaHraOpe, '%Y-%m-%d %H:%i:%s');

		CALL TARDEBBITACORAMOVSALT(
             Par_TipoMensaje,	Par_TipoTransaccion,	Par_NumeroTarjeta,	Entero_Cero,	Par_MontoTransaccion,
			 Var_FechaHraOpe,	Var_NumAutorizacion,	Entero_Cero,		Cadena_Vacia,	Par_IdTerminal,
			 Cadena_Vacia,		Cadena_Vacia,			CodigoMonOpe,		MontosAdiciona,	Par_ValorDispensado,
			 MontoLoyaltyfee,	Par_Referencia,			Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,
			 CompraEnLinea,		Var_TarDebMovID,		Salida_NO,			Aud_EmpresaID,	Aud_Usuario,
			 Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		IF (IFNULL(Par_TipoMensaje, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_MontoTransaccion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "412";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_IdTerminal, Cadena_Vacia) = Cadena_Vacia) THEN
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

        SELECT tar.Estatus, tar.CuentaAhoID
          INTO Var_EstatusTar, Var_CuentaAhoID
          FROM TARJETADEBITO tar
         WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

        IF(IFNULL(Var_EstatusTar, Entero_Cero) <> TarjetaActiva ) THEN
            IF(IFNULL(Var_EstatusTar, Entero_Cero) = TarjetaExpirada ) THEN
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
			SET CodigoRespuesta   	:= "214";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;

        IF(Var_EstatusCta <> CuentaActiva) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "214";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
            LEAVE ManejoErrores;
        END IF;

		IF (Par_TipoTransaccion != Devolucion) THEN
			IF (IFNULL(Par_ValorDispensado, Cadena_Vacia) = Cadena_Vacia) THEN
				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "502";
				SET FechaAplicacion		:= FechaAplicacion;
                SET ComisionManejoUso	:= Saldo_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF (Var_NumAutorizacion = Entero_Cero) THEN
			SELECT TipoOperacionID, TarjetaDebID, MontoOpe, a.MontosAdiciona, MontoSurcharge, NumTransaccion, DatosTiempoAire
				INTO Var_TipoOperacion, Var_NumTarjeta, Var_MontoTransaccion,Var_MontoAdicional, Var_MontoSurcharge, Var_NumTransaccion, Var_DatosTiempoAire
			FROM TARDEBBITACORAMOVS a
			WHERE CONVERT(Referencia, UNSIGNED) = CONVERT(Par_Referencia, UNSIGNED)
				AND TarjetaDebID = Par_NumeroTarjeta;

		ELSE
			SELECT TipoOperacionID,   	TarjetaDebID,   MontoOpe,            a.MontosAdiciona,     MontoSurcharge,     	NumTransaccion,     DatosTiempoAire
			 INTO Var_TipoOperacion, 	Var_NumTarjeta, Var_MontoTransaccion,Var_MontoAdicional, 	Var_MontoSurcharge, Var_NumTransaccion, Var_DatosTiempoAire
			  FROM TARDEBBITACORAMOVS a
			  WHERE CONVERT(NumTransaccion, UNSIGNED) = CONVERT(Par_NumeroAutorizacion, UNSIGNED)
			   AND TarjetaDebID = Par_NumeroTarjeta;
		END IF;

		IF(Var_TipoOperacion = Abono_EnLinea OR Var_TipoOperacion = Abono_Archivo) THEN
			SET Var_TipoTRC := Var_TipoOperacion;
			SET Var_TipoOperacion := Abono_EnLinea;
        END IF;


        IF(Par_MontoTransaccion <> Var_MontoTransaccion) THEN
				SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
				SET SaldoContableAct	:= Saldo_Cero;
				SET SaldoDisponibleAct	:= Saldo_Cero;
				SET CodigoRespuesta   	:= "503";
				SET FechaAplicacion		:= FechaAplicacion;
                SET ComisionManejoUso	:= Saldo_Cero;
				LEAVE ManejoErrores;
        END IF;

		IF Var_TipoOperacion = CompraNormal THEN
			SET Var_TipoMovAho := TipoMovCompra;
		ELSEIF Var_TipoOperacion = RetiroEfectivo THEN
			SET Var_TipoMovAho := TipoMovRetiro;
		ELSEIF Var_TipoOperacion = ConsultaSaldo THEN
			SET Var_TipoMovAho := TipoMovComConSal;
		ELSEIF Var_TipoOperacion = CompraRetiroEfec THEN
			SET Var_TipoMovAho := TipoMovCompra;
		ELSEIF Var_TipoOperacion = CompraTpoAire THEN
			SET Var_TipoMovAho := TipoMovRevTpoAire;
		ELSEIF Var_TipoOperacion = Abono_EnLinea THEN
			SET Var_TipoMovAho := 12;
		END IF;

		IF EXISTS (SELECT ReferenciaMov FROM CUENTASAHOMOV 	WHERE CuentaAhoID = Var_CuentaAhoID
						AND TipoMovAhoID = Var_TipoMovAho	AND ReferenciaMov = Var_NumTransaccion ) THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "411";
			SET FechaAplicacion		:= FechaAplicacion;
            SET ComisionManejoUso	:= Saldo_Cero;
			LEAVE ManejoErrores;
		END IF;

		CASE Var_TipoOperacion
            WHEN    CompraNormal    THEN
				START TRANSACTION;
				BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;
					CALL TARDEBREVCOMNORPRO(
						Par_NumeroTarjeta,	Par_Referencia,		Par_MontoTransaccion,	Par_ValorDispensado,	MonedaPesosSF,
						CompraEnLinea,		Var_FechaActual,	Var_NumTransaccion,		NumeroTransaccion,		SaldoContableAct,
						SaldoDisponibleAct,	CodigoRespuesta,	FechaAplicacion,		Var_TarDebMovID);
				END;
				IF (Error_Key = Entero_Cero) THEN
					SET NumeroTransaccion	:= NumeroTransaccion;
					SET SaldoContableAct	:= SaldoContableAct;
					SET SaldoDisponibleAct	:= SaldoDisponibleAct;
					SET CodigoRespuesta   	:= "000";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= ComisionManejoUso;
					COMMIT;
				ELSE
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= CodigoRespuesta;
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Saldo_Cero;
					ROLLBACK;
				END IF;

			WHEN    RetiroEfectivo    THEN
				START TRANSACTION;
				BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;

					CALL TARDEBREVRETEFEPRO(
						Par_NumeroTarjeta,	Par_Referencia,		Par_MontoTransaccion,	Var_MontoSurcharge,		Par_ValorDispensado,
						Par_IdTerminal, 	MonedaPesosSF,		Var_FechaActual,		Var_NumTransaccion,		NumeroTransaccion,
						SaldoContableAct,	SaldoDisponibleAct,	CodigoRespuesta,		FechaAplicacion,		Var_TarDebMovID);

				END;
				IF (Error_Key = Entero_Cero) THEN
					SET NumeroTransaccion	:= NumeroTransaccion;
					SET SaldoContableAct	:= SaldoContableAct;
					SET SaldoDisponibleAct	:= SaldoDisponibleAct;
					SET CodigoRespuesta   	:= "000";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= ComisionManejoUso;
					COMMIT;
				ELSE
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= CodigoRespuesta;
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Saldo_Cero;
					ROLLBACK;
				END IF;
			WHEN    ConsultaSaldo    THEN
				START TRANSACTION;
				BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;
					CALL TARDEBREVCONSALPRO(
						Par_NumeroTarjeta,	Par_Referencia,		Var_MontoSurcharge,	Par_IdTerminal,		MonedaPesosSF,
						Var_FechaActual,	Var_NumTransaccion,	NumeroTransaccion,	SaldoContableAct,	SaldoDisponibleAct,
						CodigoRespuesta,	FechaAplicacion,	Var_TarDebMovID	);
				END;
				IF (Error_Key = Entero_Cero) THEN
					SET NumeroTransaccion	:= NumeroTransaccion;
					SET SaldoContableAct	:= SaldoContableAct;
					SET SaldoDisponibleAct	:= SaldoDisponibleAct;
					SET CodigoRespuesta   	:= "000";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= ComisionManejoUso;
					COMMIT;
				ELSE
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= CodigoRespuesta;
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Saldo_Cero;
					ROLLBACK;
				END IF;

			WHEN    CompraRetiroEfec    THEN
				START TRANSACTION;
				BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;
					CALL TARDEBREVCOMRETPRO(
						Par_NumeroTarjeta,	Par_Referencia,		Par_MontoTransaccion,	Var_MontoAdicional,	MonedaPesosSF,
						CompraEnLinea,		Var_FechaActual,	Var_NumTransaccion,		NumeroTransaccion,	SaldoContableAct,
						SaldoDisponibleAct,	CodigoRespuesta,	FechaAplicacion,		Var_TarDebMovID);
				END;
				IF (Error_Key = Entero_Cero) THEN
					SET NumeroTransaccion	:= NumeroTransaccion;
					SET SaldoContableAct	:= SaldoContableAct;
					SET SaldoDisponibleAct	:= SaldoDisponibleAct;
					SET CodigoRespuesta   	:= "000";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= ComisionManejoUso;
					COMMIT;
				ELSE
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= CodigoRespuesta;
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Saldo_Cero;
					ROLLBACK;
				END IF;

			WHEN    CompraTpoAire    THEN
				START TRANSACTION;
				BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;

					CALL TARDEBREVCOMTPOPRO(
						Par_NumeroTarjeta,	Par_Referencia,		Par_MontoTransaccion,	Var_MontoSurcharge,		Par_ValorDispensado,
						Par_IdTerminal, 	MonedaPesosSF,		Var_FechaActual,		Var_NumTransaccion,		Var_DatosTiempoAire,
						NumeroTransaccion,	SaldoContableAct,	SaldoDisponibleAct,		CodigoRespuesta,		FechaAplicacion,
						Var_TarDebMovID);
				END;
				IF (Error_Key = Entero_Cero) THEN
					SET NumeroTransaccion	:= NumeroTransaccion;
					SET SaldoContableAct	:= SaldoContableAct;
					SET SaldoDisponibleAct	:= SaldoDisponibleAct;
					SET CodigoRespuesta   	:= "000";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= ComisionManejoUso;
					COMMIT;
				ELSE
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= CodigoRespuesta;
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Saldo_Cero;
					ROLLBACK;
				END IF;

			WHEN    Abono_EnLinea    THEN
				START TRANSACTION;
				BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1; SET CodigoRespuesta = 412;

					SET Var_TipoOperacion := Var_TipoTRC;

					CALL TARDEBABONOCREREVPRO(Var_TipoOperacion, 	Par_NumeroTarjeta, 		Par_Referencia,
											  Par_MontoTransaccion, MonedaPesosSF,			Par_NumeroAutorizacion,
											  Var_FechaActual, 		NumeroTransaccion,		SaldoContableAct,
											  SaldoDisponibleAct,	CodigoRespuesta,		FechaAplicacion,
											  Var_TarDebMovID);


				END;

				IF (Error_Key = Entero_Cero AND CodigoRespuesta = "000") THEN
					SET NumeroTransaccion	:= NumeroTransaccion;
					SET SaldoContableAct	:= SaldoContableAct;
					SET SaldoDisponibleAct	:= SaldoDisponibleAct;
					SET CodigoRespuesta   	:= "000";
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= ComisionManejoUso;
					COMMIT;
				ELSE
					SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero, CHAR), 6, 0);
					SET SaldoContableAct	:= Saldo_Cero;
					SET SaldoDisponibleAct	:= Saldo_Cero;
					SET CodigoRespuesta   	:= CodigoRespuesta;
					SET FechaAplicacion		:= FechaAplicacion;
                    SET ComisionManejoUso	:= Saldo_Cero;
					ROLLBACK;
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
			CodigoRespuesta,		CodigoRespuesta,		Par_TipoTransaccion,		Salida_NO, 			Par_NumErr,
			Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,				Var_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,			NumeroTransaccion);



        SET NumeroTransaccion := Par_NumeroAutorizacion;





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