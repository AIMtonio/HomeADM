-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCOMTPOCOM
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCOMTPOCOM`;DELIMITER $$

CREATE PROCEDURE `TARDEBCOMTPOCOM`(
	Par_TipoMensaje			CHAR(4),
    Par_TipoOperacion       CHAR(2),
    Par_NumeroTarjeta       CHAR(16),
    Par_OrigenInstrumento   CHAR(2),
    Par_MontoTransaccion    DECIMAL(12,2),

    Par_FechaHoraOperacion  DATETIME,
    Par_NumeroTransaccion   BIGINT(20),
    Par_GiroNegocio         CHAR(4),
    Par_PuntoEntrada        CHAR(2),
    Par_IdTerminal          CHAR(40),

    Par_NomUbicTerminal     CHAR(50),
    Par_Nip                 VARCHAR(50),
    Par_CodMonedaOpe        CHAR(4),
    Par_MontosAdicionales   DECIMAL(12,2),
    Par_MontoSurcharge      DECIMAL(12,2),

    Par_DatosTiempoAire     VARCHAR(90),
	Par_Referencia			VARCHAR(12),
	Par_Salida				CHAR(1),
	INOUT Error_Key         INT(11),
	INOUT CodigoRespuesta	VARCHAR(3)
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Poliza          BIGINT(20);			-- Numero de poliza contable
	DECLARE Var_ClienteID       INT(11);			-- Valor del numero del cliente
	DECLARE Var_CuentaAhoID     BIGINT(12);			-- Valor del numero de la cuenta
	DECLARE Par_Referencia      VARCHAR(50);		-- Descripcion de la referencia
	DECLARE Var_MontoDispo      DECIMAL(12,2);		-- Valor del monto disponible

	DECLARE Var_IVA             DECIMAL(12,2);		-- Valor del IVA de la sucursal
	DECLARE Var_MontoIVACom     DECIMAL(12,2);		-- Valor de IVA del monto de la compra
	DECLARE Var_MontoCom        DECIMAL(12,2);		-- Valor del monto de la compra
	DECLARE Var_CajeroID		VARCHAR(30);		-- Numero del cajero ATM
	DECLARE Var_Compania		CHAR(4);			-- Descripcion de la compania

	DECLARE Var_NumCel			CHAR(10);			-- Valor del numero celular
	DECLARE Var_ComSusMis		DECIMAL(12,2);		-- Tipo de compra: socio que realiza compra de tiempo aire en otro banco
	DECLARE Var_CentroATM		INT(11);			-- Centro de costo del cajero ATM

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);

	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE CompraEnLineaSI 	CHAR(1);
	DECLARE Aud_EmpresaID   	INT(11);
	DECLARE Aud_Usuario     	INT(11);
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
	DECLARE Aud_FechaActual		DATETIME;
	DECLARE Con_OperacATM		INT(11);
	DECLARE Con_OpeIVAATM		INT(11);
	DECLARE Con_OpeComATM		INT(11);


	-- Asignacion de constantes
	SET Cadena_Vacia    	:= '';				-- Cadena vacia
	SET Fecha_Vacia     	:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero     	:= 0;				-- Entero cero
	SET Salida_NO       	:= 'N';				-- El Store NO genera una Salida
	SET Salida_SI       	:= 'S';				-- El Store SI genera una Salida

	SET Decimal_Cero    	:= 0.00;  			-- DECIMAL cero
	SET CompraEnLineaSI 	:= 'S';				-- Compra en linea: SI
	SET Error_Key       	:= Entero_Cero;		-- Numero de error: Cero
	SET Aud_EmpresaID   	:= 1;				-- Campo de Auditoria
	SET Aud_Usuario     	:= 1;				-- Campo de Auditoria

	SET Aud_DireccionIP 	:= 'localhost';		-- Campo de Auditoria
	SET Aud_ProgramaID  	:= 'workbench';		-- Campo de Auditoria
	SET Aud_Sucursal    	:= 1;				-- Campo de Auditoria
	SET Pol_Automatica  	:= 'A';  			-- Genera poliza automaticamente
	SET ConceptoTarDeb  	:= 300;   			-- Concepto contable correspondiente a operaciones con tarjetas

	SET Con_DescriMov   	:= 'COMPRA DE TIEMPO AIRE ATM';		-- Descripcion: Compra de tiempo aire ATM
	SET Par_MonedaID    	:= 1;           	-- Tipo de Moneda: Pesos mexicanos
	SET Nat_Cargo       	:= 'C';				-- Naturaleza de movimiento: Cargo
	SET Nat_Abono       	:= 'A';				-- Naturaleza de movimiento: Abono
	SET Con_AhoCapital  	:= 1;

	SET Con_OperacATM		:= 1;				-- Concepto de ahorro capital
	SET Con_OpeIVAATM 		:= 6;	            -- Tipo de operacion: IVA por otros ingresos   CONCEPTOSTARDEB
	SET Con_OpeComATM 		:= 7;				-- Tipo de operacion: Comisiones ATM CONCEPTOSTARDEB

	-- Se obtiene la fecha actual
	SET Aud_FechaActual 	:= NOW();

	SELECT tar.CuentaAhoID, tar.ClienteID
	  INTO Var_CuentaAhoID, Var_ClienteID
	  FROM TARJETADEBITO tar
	  WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

	IF IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero THEN
		SET Error_Key = 1;
		SET CodigoRespuesta	:= "412";
	END IF;

	IF IFNULL(Var_CuentaAhoID, Entero_Cero) = Entero_Cero THEN
		SET Error_Key = 1;
		SET CodigoRespuesta	:= "412";
	END IF;


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


		SET Var_Compania	:= SUBSTRING(TRIM(Par_DatosTiempoAire),1, 4);
		SET Var_NumCel		:= SUBSTRING(TRIM(Par_DatosTiempoAire),5, 10);
		SET Par_Referencia	:= CONCAT("COM TPO AIRE", Var_NumCel);

	IF NOT EXISTS (	SELECT CajeroID FROM CATCAJEROSATM WHERE NumCajeroPROSA = Par_IdTerminal )THEN



			CALL POLIZAAHORROPRO(
				Var_Poliza,         Aud_EmpresaID,  	Par_FechaHoraOperacion, Var_ClienteID,      Con_AhoCapital,
				Var_CuentaAhoID,    Par_MonedaID,   	Par_MontoTransaccion,	Entero_Cero,        Con_DescriMov,
				Par_Referencia,     Aud_Usuario,    	Aud_FechaActual, 		Aud_DireccionIP,    Aud_ProgramaID,
				Aud_Sucursal,       Par_NumeroTransaccion);


			CALL POLIZATARJETAPRO(
				Var_Poliza,         Aud_EmpresaID,      Par_FechaHoraOperacion, Par_NumeroTarjeta,      Var_ClienteID,
				Con_OperacATM,      Par_MonedaID,       Entero_Cero,            Par_MontoTransaccion,   Con_DescriMov,
				Par_Referencia,     Entero_Cero,		Salida_NO,          	Par_NumErr,             Par_ErrMen,
                Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP,    	Aud_ProgramaID,         Aud_Sucursal,
                Par_NumeroTransaccion);



	ELSE
		SET Con_RetMisSus   := 1;

		SELECT IVA INTO Var_IVA
		FROM SUCURSALES
		WHERE SucursalID = Aud_Sucursal;

		SELECT IFNULL(ComisionMisMis, Decimal_Cero) 	INTO Var_ComSusMis
		FROM TARDEBCOMTPOAIRE
		WHERE CompaniaID = Var_Compania;
		SET Var_MontoCom	:= ROUND((Par_MontoTransaccion * Var_ComSusMis) /100  / (1 + Var_IVA), 2);
		SET Var_MontoIVACom	:= ROUND(((Par_MontoTransaccion * Var_ComSusMis)/100) - (((Par_MontoTransaccion * Var_ComSusMis)/100 ) / (1 + Var_IVA)), 2);
		SET Var_MontoDispo	:= (Par_MontoTransaccion - (Var_MontoCom + Var_MontoIVACom));


		CALL POLIZAAHORROPRO(
			Var_Poliza,         Aud_EmpresaID,  	Par_FechaHoraOperacion, Var_ClienteID,      Con_AhoCapital,
			Var_CuentaAhoID,    Par_MonedaID,   	Par_MontoTransaccion,	Entero_Cero,        Con_DescriMov,
			Par_Referencia,     Aud_Usuario,    	Aud_FechaActual, 		Aud_DireccionIP,    Aud_ProgramaID,
			Aud_Sucursal,       Par_NumeroTransaccion);


		CALL POLIZATARJETAPRO(
			Var_Poliza,         Aud_EmpresaID,      Par_FechaHoraOperacion, Par_NumeroTarjeta,      Var_ClienteID,
			Con_OperacATM,      Par_MonedaID,       Entero_Cero,            Var_MontoDispo,  		Con_DescriMov,
			Par_Referencia,     Entero_Cero,		Salida_NO,          	Par_NumErr,             Par_ErrMen,
            Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP,    	Aud_ProgramaID,         Aud_Sucursal,
            Par_NumeroTransaccion);

		SELECT SUC.CentroCostoID INTO Var_CentroATM
			FROM CATCAJEROSATM ATM
				INNER JOIN SUCURSALES SUC ON ATM.SucursalID=SUC.SucursalID
			WHERE NumCajeroPROSA= Par_IdTerminal;

		SET Con_DescriMov	:= 'COMISION COMPRA TIEMPO AIRE ATM';
		CALL POLIZATARJETAPRO(
			Var_Poliza,         Aud_EmpresaID,      Par_FechaHoraOperacion, Par_NumeroTarjeta,      Var_ClienteID,
			Con_OpeComATM,      Par_MonedaID,       Entero_Cero,            Var_MontoCom,   		Con_DescriMov,
			Par_Referencia,     Var_CentroATM,		Salida_NO,          	Par_NumErr,             Par_ErrMen,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    	Aud_ProgramaID,         Aud_Sucursal,
			Par_NumeroTransaccion);



		SET Con_DescriMov	:= 'IVA COMISION COMPRA TIEMPO AIRE';

		CALL POLIZATARJETAPRO(
			Var_Poliza,         Aud_EmpresaID,      Par_FechaHoraOperacion, Par_NumeroTarjeta,      Var_ClienteID,
			Con_OpeIVAATM,      Par_MonedaID,       Entero_Cero,            Var_MontoIVACom,   		Con_DescriMov,
			Par_Referencia,     Entero_Cero,		Salida_NO,         	 	Par_NumErr,             Par_ErrMen,
            Aud_Usuario,		Aud_FechaActual, 	Aud_DireccionIP,    	Aud_ProgramaID,         Aud_Sucursal,
            Par_NumeroTransaccion);

	END IF;

    IF (Error_Key != Entero_Cero) THEN
		SET CodigoRespuesta	:= "412";
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