-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCOMRETCOM
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCOMRETCOM`;DELIMITER $$

CREATE PROCEDURE `TARDEBCOMRETCOM`(

	Par_TipoMensaje			CHAR(4),
    Par_TipoOperacion       CHAR(2),
    Par_NumeroTarjeta       CHAR(16),
    Par_OrigenInstrumento   CHAR(2),
    Par_MontoTransaccion    DECIMAL(12,2),

    Par_FechaHoraOperacion  DATE,
    Par_NumeroTransaccion   BIGINT(20),
    Par_MontosAdicionales   DECIMAL(12,2),
    Par_MontoSurcharge      DECIMAL(12,2),
	Par_CompraEnLinea		CHAR(1),

    Par_Salida				CHAR(1),
	INOUT Error_Key         INT(11),
	INOUT CodigoRespuesta	VARCHAR(3)
	)
TerminaStore: BEGIN


	DECLARE Var_CuentaAhoID 	BIGINT(12);
	DECLARE Var_ClienteID   	INT(11);
	DECLARE Var_Poliza      	BIGINT(20);
	DECLARE Var_MontoCompra 	DECIMAL(12,2);


	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT(11);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);
	DECLARE Decimal_Cero    	DECIMAL(12,2);

	DECLARE CompraEnLineaSI 	CHAR(1);
	DECLARE Error_Key   		INT(11);
	DECLARE Aud_EmpresaID   	INT(11);
	DECLARE Aud_Usuario     	INT(11);
	DECLARE Aud_FechaActual		DATETIME;

	DECLARE Aud_DireccionIP 	VARCHAR(15);
	DECLARE Aud_ProgramaID  	VARCHAR(50);
	DECLARE Aud_Sucursal    	INT(11);
	DECLARE Par_NumErr  		INT(11);
	DECLARE Par_ErrMen  		VARCHAR(150);

	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE ConceptoTarDeb  	INT(11);
	DECLARE Con_DescriMov   	VARCHAR(50);
	DECLARE Con_AhoCapital  	INT(11);
	DECLARE Par_MonedaID    	INT(11);

	DECLARE Par_Referencia  	BIGINT(20);
	DECLARE Con_OperacPOS   	INT(11);



	SET Cadena_Vacia    := '';
	SET Entero_Cero     := 0;
	SET Salida_NO       := 'N';
	SET Salida_SI       := 'S';
	SET Decimal_Cero    := 0.00;

	SET CompraEnLineaSI := 'S';
	SET Error_Key       := Entero_Cero;
	SET Aud_EmpresaID   := 1;
	SET Aud_Usuario     := 1;
	SET Aud_DireccionIP := 'localhost';

	SET Aud_ProgramaID  := 'workbench';
	SET Aud_Sucursal    := 1;
	SET Pol_Automatica  := 'A';
	SET ConceptoTarDeb  := 300;
	SET Con_DescriMov   := 'RETIRO EN COMPRA CON TDD';

	SET Con_AhoCapital  := 1;
	SET Par_MonedaID    := 1;
	SET Par_Referencia  := Par_NumeroTransaccion;
	SET Con_OperacPOS   := 2;



	SET Aud_FechaActual	:= NOW();

      SELECT tar.CuentaAhoID, tar.ClienteID
	INTO Var_CuentaAhoID, Var_ClienteID
	FROM TARJETADEBITO tar
	WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

        IF ( Par_CompraEnLinea = CompraEnLineaSI ) THEN

            CALL MAESTROPOLIZAALT(
                Var_Poliza,		Aud_EmpresaID,	Par_FechaHoraOperacion,	Pol_Automatica,		ConceptoTarDeb,
                Con_DescriMov,	Salida_NO,		Aud_Usuario,        	Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,	Aud_Sucursal,	Par_NumeroTransaccion);

            SET Par_MontosAdicionales := IFNULL(Par_MontosAdicionales, Decimal_Cero);
            SET Var_MontoCompra := (Par_MontoTransaccion - Par_MontosAdicionales);

            IF (Var_MontoCompra <> Decimal_Cero ) THEN

				SET Con_DescriMov	:= 'COMPRA CON TARJETA DE DEBITO';
                CALL POLIZAAHORROPRO(
                    Var_Poliza,         Aud_EmpresaID,  	Par_FechaHoraOperacion, Var_ClienteID,      Con_AhoCapital,
                    Var_CuentaAhoID,    Par_MonedaID,   	Var_MontoCompra,        Entero_Cero,        Con_DescriMov,
                    Par_Referencia,     Aud_Usuario,    	Aud_FechaActual, 		Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Par_NumeroTransaccion);


                CALL POLIZATARJETAPRO(
                    Var_Poliza,         Aud_EmpresaID,      Par_FechaHoraOperacion,	Par_NumeroTarjeta,  Var_ClienteID,
                    Con_OperacPOS,      Par_MonedaID,       Entero_Cero,			Var_MontoCompra,    Con_DescriMov,
                    Par_Referencia,     Entero_Cero,		Salida_NO,          	Par_NumErr,     	Par_ErrMen,
                    Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,
                    Par_NumeroTransaccion);
            END IF;

			SET Con_DescriMov	:= 'RETIRO EN COMPRA CON TARJETA DE DEBITO';
            CALL POLIZAAHORROPRO(
                Var_Poliza,         Aud_EmpresaID,  	Par_FechaHoraOperacion, 	Var_ClienteID,   		Con_AhoCapital,
                Var_CuentaAhoID,    Par_MonedaID,   	Par_MontosAdicionales,  	Entero_Cero,    		Con_DescriMov,
                Par_Referencia,     Aud_Usuario,    	Aud_FechaActual, 			Aud_DireccionIP, 		Aud_ProgramaID,
                Aud_Sucursal,       Par_NumeroTransaccion);

            CALL POLIZATARJETAPRO(
                Var_Poliza,			Aud_EmpresaID,   	Par_FechaHoraOperacion,    	Par_NumeroTarjeta,      Var_ClienteID,
                Con_OperacPOS,		Par_MonedaID,    	Entero_Cero,               	Par_MontosAdicionales,  Con_DescriMov,
                Par_Referencia,		Entero_Cero,		Salida_NO,       			Par_NumErr,             Par_ErrMen,
                Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP, 			Aud_ProgramaID,         Aud_Sucursal,
                Par_NumeroTransaccion);

        END IF;
	IF (Error_Key != Entero_Cero) THEN
		SET CodigoRespuesta	:= "909";
		ROLLBACK;
	END IF;

	IF ( Par_Salida = Salida_SI ) THEN
        SELECT '000',
			'Transaccion Realizada Correctamente.';
    ELSE
        SET Par_NumErr   := 00;
        SET Par_ErrMen  := 'Transaccion Realizada Correctamente.';
    END IF;

END TerminaStore$$