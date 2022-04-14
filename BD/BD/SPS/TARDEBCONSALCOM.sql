-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONSALCOM
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONSALCOM`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONSALCOM`(

	Par_TipoMensaje			CHAR(4),
    Par_TipoOperacion       CHAR(2),
    Par_NumeroTarjeta       CHAR(16),
    Par_OrigenInstrumento   CHAR(2),
    Par_MontoTransaccion    DECIMAL(12,2),

    Par_FechaHoraOperacion  DATE,
    Par_NumeroTransaccion   BIGINT(20),
    Par_GiroNegocio         CHAR(4),
    Par_PuntoEntrada        CHAR(2),
    Par_IdTerminal          CHAR(40),

    Par_NomUbicTerminal     CHAR(50),
    Par_Nip                 VARCHAR(50),
    Par_CodMonedaOpe        CHAR(4),
    Par_MontosAdicionales   DECIMAL(12,2),
    Par_MontoSurcharge      DECIMAL(12,2),

    Par_MontoLoyaltyfee     DECIMAL(12,2),
	Par_Referencia			VARCHAR(12),
	Par_Salida				CHAR(1),
	INOUT Error_Key         INT(11),
	INOUT CodigoRespuesta	VARCHAR(3)
	)
TerminaStore: BEGIN


	DECLARE Var_Poliza          BIGINT(20);
	DECLARE Var_ClienteID       INT(11);
	DECLARE Var_CuentaAhoID     BIGINT(12);
	DECLARE Var_MontoIVACom     DECIMAL(12,2);
	DECLARE Var_MontoCom        DECIMAL(12,2);

	DECLARE Var_IVA             DECIMAL(12,2);


	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT(11);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);
	DECLARE Decimal_Cero    	DECIMAL(12,2);

	DECLARE Aud_EmpresaID   	INT(11);
	DECLARE Aud_Usuario     	INT(11);
	DECLARE Aud_FechaActual		DATETIME;
	DECLARE Aud_DireccionIP 	VARCHAR(15);
	DECLARE Aud_ProgramaID  	VARCHAR(50);

	DECLARE Aud_Sucursal    	INT(11);
	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE ConceptoTarDeb  	INT(11);
	DECLARE Con_DescriMov   	VARCHAR(100);
	DECLARE Par_MonedaID        INT(11);

	DECLARE Par_Referencia      VARCHAR(50);
	DECLARE Con_AhoCapital      INT(11);
	DECLARE Par_NumErr          INT(11);
	DECLARE Par_ErrMen          VARCHAR(150);
	DECLARE Error_Key           INT(11);

	DECLARE Con_ConATM          INT(11);
	DECLARE Par_ReferenciaMov   VARCHAR(50);



	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;
	SET Salida_NO       	:= 'N';
	SET Salida_SI       	:= 'S';
	SET Decimal_Cero    	:= 0.00;

	SET Error_Key       	:= Entero_Cero;
	SET Aud_EmpresaID   	:= 1;
	SET Aud_Usuario     	:= 1;
	SET Aud_DireccionIP 	:= 'localhost';
	SET Aud_ProgramaID  	:= 'workbench';

	SET Aud_Sucursal    	:= 1;
	SET Pol_Automatica  	:= 'A';
	SET ConceptoTarDeb  	:= 300;
	SET Par_MonedaID    	:= 1;
	SET Con_AhoCapital  	:= 1;

	SET Par_Referencia  	:= Par_NumeroTransaccion;
	SET Con_ConATM      	:= 1;


	SET Aud_FechaActual		:= NOW();


	IF NOT EXISTS (	SELECT CajeroID FROM CATCAJEROSATM WHERE NumCajeroPROSA = Par_IdTerminal )THEN

	  SELECT tar.CuentaAhoID, tar.ClienteID
	    INTO Var_CuentaAhoID, Var_ClienteID
	    FROM TARJETADEBITO tar
	    WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

			SET Con_DescriMov   := 'CONSULTA DE SALDO EN OTRO BANCO CON TDD';
            CALL MAESTROPOLIZAALT(
                Var_Poliza,         Aud_EmpresaID,  Par_FechaHoraOperacion, Pol_Automatica,		ConceptoTarDeb,
                Con_DescriMov,      Salida_NO,      Aud_Usuario,            Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,   Par_NumeroTransaccion);

            SELECT IVA INTO Var_IVA
                        FROM SUCURSALES
                        WHERE SucursalID = Aud_Sucursal;

            SET Var_MontoIVACom := ROUND(Par_MontoSurcharge / (1 + Var_IVA) * Var_IVA, 2);
            SET Var_MontoCom    := Par_MontoSurcharge - Var_MontoIVACom;


			SET Con_DescriMov   := 'COMISION POR CONSULTA SALDO TDD';
            CALL POLIZAAHORROPRO(
                Var_Poliza,         Aud_EmpresaID,  			Par_FechaHoraOperacion, 	Var_ClienteID,  		Con_AhoCapital,
                Var_CuentaAhoID,    Par_MonedaID,   			Var_MontoCom,     			Entero_Cero,    		Con_DescriMov,
                Par_Referencia,     Aud_Usuario,    			Aud_FechaActual, 			Aud_DireccionIP,		Aud_ProgramaID,
                Aud_Sucursal,       Par_NumeroTransaccion );

			SET Con_DescriMov   := 'IVA COMISION POR CONSULTA SALDO TDD';
            CALL POLIZAAHORROPRO(
                Var_Poliza,         Aud_EmpresaID,  			Par_FechaHoraOperacion, 	Var_ClienteID,  		Con_AhoCapital,
                Var_CuentaAhoID,    Par_MonedaID,   			Var_MontoIVACom,     		Entero_Cero,    		Con_DescriMov,
                Par_Referencia,     Aud_Usuario,    			Aud_FechaActual, 			Aud_DireccionIP,		Aud_ProgramaID,
                Aud_Sucursal,       Par_NumeroTransaccion );


			SET Con_DescriMov   := 'COMISION POR CONSULTA SALDO TDD';
            CALL POLIZATARJETAPRO(
                Var_Poliza,             Aud_EmpresaID,      	Par_FechaHoraOperacion, 	Par_NumeroTarjeta,  	Var_ClienteID,
                Con_ConATM,             Par_MonedaID,       	Entero_Cero,            	Var_MontoCom, 			Con_DescriMov,
                Par_Referencia,         Entero_Cero,			Salida_NO,          		Par_NumErr,             Par_ErrMen,
                Aud_Usuario,			Aud_FechaActual, 		Aud_DireccionIP,    		Aud_ProgramaID,         Aud_Sucursal,
                Par_NumeroTransaccion);

			SET Con_DescriMov   := 'IVA COMISION POR CONSULTA SALDO TDD';
            CALL POLIZATARJETAPRO(
                Var_Poliza,             Aud_EmpresaID,      	Par_FechaHoraOperacion, 	Par_NumeroTarjeta,  	Var_ClienteID,
                Con_ConATM,             Par_MonedaID,       	Entero_Cero,            	Var_MontoIVACom, 		Con_DescriMov,
                Par_Referencia,         Entero_Cero,			Salida_NO,          		Par_NumErr,             Par_ErrMen,
                Aud_Usuario,			Aud_FechaActual, 		Aud_DireccionIP,   		 	Aud_ProgramaID,         Aud_Sucursal,
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