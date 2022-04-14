-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBRETEFECOM
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBRETEFECOM`;DELIMITER $$

CREATE PROCEDURE `TARDEBRETEFECOM`(

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
	DECLARE Var_MontoDispo      DECIMAL(12,2);
	DECLARE Var_IVA             DECIMAL(12,2);

	DECLARE Var_MontoIVACom     DECIMAL(12,2);
	DECLARE Var_MontoCom        DECIMAL(12,2);
	DECLARE Var_CajeroID		VARCHAR(30);


	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);

	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE CompraEnLineaSI 	CHAR(1);
	DECLARE Aud_EmpresaID   	INT(11);
	DECLARE Aud_Usuario     	INT(11);
	DECLARE Aud_FechaActual		DATETIME;

	DECLARE Aud_DireccionIP 	VARCHAR(15);
	DECLARE Aud_ProgramaID  	VARCHAR(50);
	DECLARE Aud_Sucursal    	INT(11);
	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE ConceptoTarDeb  	INT(11);

	DECLARE Con_DescriMov   	VARCHAR(100);
	DECLARE CompraEnLinea       CHAR(1);
	DECLARE Par_MonedaID        INT(11);
	DECLARE Nat_Cargo           CHAR(1);
	DECLARE Nat_Abono			CHAR(1);

	DECLARE Par_ReferenciaMov   VARCHAR(50);
	DECLARE Par_Referencia      VARCHAR(50);
	DECLARE Con_AhoCapital      INT(11);
	DECLARE Par_NumErr          INT(11);
	DECLARE Par_ErrMen          VARCHAR(150);

	DECLARE Error_Key           INT(11);
	DECLARE Con_RetMisSus       INT(11);
	DECLARE AltaPolizaSI		CHAR(1);
	DECLARE AltaPolizaNO		CHAR(1);
	DECLARE DetPolizaNO 		CHAR(1);

	DECLARE DetPolizaSI 		CHAR(1);
	DECLARE AfectaFirme			CHAR(1);
	DECLARE AfectaSaldoSI		CHAR(1);
	DECLARE AfectaSaldoNO		CHAR(1);
	DECLARE Con_OperacATM		INT(11);

	DECLARE TipoInstrumentoID	INT(11);


	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Entero_Cero     	:= 0;
	SET Salida_NO       	:= 'N';
	SET Salida_SI       	:= 'S';

	SET Decimal_Cero    	:= '0.00';
	SET CompraEnLineaSI 	:= 'S';
	SET Error_Key       	:= Entero_Cero;
	SET Aud_EmpresaID   	:= 1;
	SET Aud_Usuario     	:= 1;

	SET Aud_DireccionIP 	:= 'localhost';
	SET Aud_ProgramaID  	:= 'workbench';
	SET Aud_Sucursal    	:= 1;
	SET Pol_Automatica  	:= 'A';
	SET ConceptoTarDeb  	:= 300;

	SET Par_MonedaID    	:= 1;
	SET Nat_Cargo       	:= 'C';
	SET Nat_Abono       	:= 'A';
	SET Con_AhoCapital  	:= 1;
	SET Par_Referencia  	:= Par_NumeroTransaccion;

	SET Con_OperacATM		:= 1;
	SET Con_DescriMov   	:= 'RETIRO DE EFECTIVO CON TD';
	SET TipoInstrumentoID	:= 2;


	SET Aud_FechaActual		:= NOW();


	SELECT tar.CuentaAhoID, tar.ClienteID
	  INTO Var_CuentaAhoID, Var_ClienteID
	  FROM TARJETADEBITO tar
	  WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

	CALL MAESTROPOLIZAALT(
		Var_Poliza,         Aud_EmpresaID,  Par_FechaHoraOperacion, Pol_Automatica,		ConceptoTarDeb,
        Con_DescriMov,      Salida_NO,      Aud_Usuario,            Aud_FechaActual, 	Aud_DireccionIP,
        Aud_ProgramaID,     Aud_Sucursal,   Par_NumeroTransaccion);

	SET AltaPolizaSI		:= 'S';
	SET AltaPolizaNO		:= 'N';
	SET DetPolizaNO 		:= 'N';
	SET DetPolizaSI 		:= 'S';
	SET AfectaFirme			:= 'F';
	SET AfectaSaldoSI		:= 'S';
	SET AfectaSaldoNO		:= 'N';

	SET Var_MontoDispo = (Par_MontoTransaccion - Par_MontoSurcharge );


	IF NOT EXISTS (	SELECT CajeroID FROM CATCAJEROSATM WHERE NumCajeroPROSA = Par_IdTerminal )THEN

			SET Con_RetMisSus   := 1;
			SELECT IVA INTO Var_IVA
				FROM SUCURSALES
				WHERE SucursalID = Aud_Sucursal;

			SET Var_MontoIVACom := ROUND(Par_MontoSurcharge / (1 + Var_IVA) * Var_IVA, 2);
			SET Var_MontoCom    := Par_MontoSurcharge - Var_MontoIVACom;


			CALL POLIZAAHORROPRO(
				Var_Poliza,         Aud_EmpresaID,  	Par_FechaHoraOperacion, 	Var_ClienteID,      	Con_AhoCapital,
				Var_CuentaAhoID,    Par_MonedaID,   	Var_MontoDispo,         	Entero_Cero,        	Con_DescriMov,
				Par_Referencia,     Aud_Usuario,    	Aud_FechaActual, 			Aud_DireccionIP,    	Aud_ProgramaID,
				Aud_Sucursal,       Par_NumeroTransaccion);

			CALL POLIZATARJETAPRO(
				Var_Poliza,         Aud_EmpresaID,      Par_FechaHoraOperacion, 	Par_NumeroTarjeta,      Var_ClienteID,
				Con_OperacATM,      Par_MonedaID,       Entero_Cero,            	Var_MontoDispo,   		Con_DescriMov,
				Par_Referencia,     Entero_Cero,		Salida_NO,          		Par_NumErr,             Par_ErrMen,
                Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP,    		Aud_ProgramaID,         Aud_Sucursal,
                Par_NumeroTransaccion);


			SET Con_DescriMov	:= 'COMISION POR RETIRO CON TDD';
			CALL POLIZAAHORROPRO(
				Var_Poliza,         Aud_EmpresaID,  	Par_FechaHoraOperacion, 	Var_ClienteID,      	Con_AhoCapital,
				Var_CuentaAhoID,    Par_MonedaID,   	Var_MontoCom,           	Entero_Cero,        	Con_DescriMov,
				Par_Referencia,     Aud_Usuario,    	Aud_FechaActual, 			Aud_DireccionIP,    	Aud_ProgramaID,
				Aud_Sucursal,       Par_NumeroTransaccion);


			CALL POLIZATARJETAPRO(
				Var_Poliza,         Aud_EmpresaID,      Par_FechaHoraOperacion, 	Par_NumeroTarjeta,      Var_ClienteID,
				Con_OperacATM,      Par_MonedaID,       Entero_Cero,            	Var_MontoCom,   		Con_DescriMov,
				Par_Referencia,     Entero_Cero,		Salida_NO,          		Par_NumErr,             Par_ErrMen,
                Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    		Aud_ProgramaID,         Aud_Sucursal,
                Par_NumeroTransaccion );



			SET Con_DescriMov	:= 'IVA COMISION POR RETIRO CON TDD';
			CALL POLIZAAHORROPRO(
				Var_Poliza,         Aud_EmpresaID,  	Par_FechaHoraOperacion,		Var_ClienteID,      	Con_AhoCapital,
				Var_CuentaAhoID,    Par_MonedaID,   	Var_MontoIVACom,        	Entero_Cero,        	Con_DescriMov,
				Par_Referencia,     Aud_Usuario,    	Aud_FechaActual, 			Aud_DireccionIP,    	Aud_ProgramaID,
				Aud_Sucursal,       Par_NumeroTransaccion);


			CALL POLIZATARJETAPRO(
				Var_Poliza,         Aud_EmpresaID,      Par_FechaHoraOperacion, 	Par_NumeroTarjeta,      Var_ClienteID,
				Con_OperacATM,      Par_MonedaID,       Entero_Cero,            	Var_MontoIVACom,   		Con_DescriMov,
				Par_Referencia,     Entero_Cero,		Salida_NO,          		Par_NumErr,             Par_ErrMen,
                Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP,   		 	Aud_ProgramaID,         Aud_Sucursal,
                Par_NumeroTransaccion);


	ELSE

		SELECT CajeroID  INTO Var_CajeroID
			FROM CATCAJEROSATM
			WHERE NumCajeroPROSA = Par_IdTerminal;


		CALL POLIZAAHORROPRO(
			Var_Poliza,         Aud_EmpresaID,  		Par_FechaHoraOperacion, Var_ClienteID,      Con_AhoCapital,
			Var_CuentaAhoID,    Par_MonedaID,   		Var_MontoDispo,         Entero_Cero,        Con_DescriMov,
			Par_Referencia,     Aud_Usuario,    		Aud_FechaActual, 		Aud_DireccionIP,    Aud_ProgramaID,
			Aud_Sucursal,       Par_NumeroTransaccion);

		CALL CONTAATMPRO (
			Var_CajeroID,		Par_MontoTransaccion,	Con_DescriMov,		Par_MonedaID,			AltaPolizaNO,
			DetPolizaSI,		Con_AhoCapital,			Nat_Abono,			Par_Referencia,			Var_CuentaAhoID,
			AfectaFirme,		AfectaSaldoSI,			Nat_Cargo, 			Par_FechaHoraOperacion, TipoInstrumentoID,
			Par_NumeroTarjeta,	Var_Poliza, 			Salida_NO,			Par_NumErr,				Par_ErrMen,
			Aud_EmpresaID,		Aud_Usuario,    		Aud_FechaActual, 	Aud_DireccionIP,		Aud_ProgramaID,
            Aud_Sucursal,		Par_NumeroTransaccion);
	END IF;

    IF (Error_Key != Entero_Cero) THEN
		SET CodigoRespuesta	:= "90c";
		ROLLBACK;
	END IF;

	IF ( Par_Salida = Salida_SI ) THEN
        SELECT '000',
			'Transaccion Realizada Correctamente.';
    ELSE
        SET Par_NumErr   := 000;
        SET Par_ErrMen  := 'Transaccion Realizada Correctamente.';
    END IF;
END TerminaStore$$