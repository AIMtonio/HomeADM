-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWTRANSFERINTERPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWTRANSFERINTERPRO`;

DELIMITER $$
CREATE PROCEDURE `APPWTRANSFERINTERPRO`(

	Par_TarjetaOriID		VARCHAR(16),
	Par_TarjetaDesID		VARCHAR(16),
	Par_Concepto			VARCHAR(100),
	Par_ReferenciaMov		VARCHAR(35),
	Par_Monto				DECIMAL(14,2),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore: BEGIN

	DECLARE Var_Poliza			BIGINT;
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_FecAplicacion	DATE;
	DECLARE Var_SucCliente		INT;

	DECLARE Var_ClienteOri		INT(11);
	DECLARE Var_SaldoCtaOri		DECIMAL(14,2);
	DECLARE Var_MonedaCtaOri	INT(11);
	DECLARE Var_StatusCtaOri	CHAR(1);

	DECLARE Var_ClienteDes		INT(11);
	DECLARE Var_SaldoCtaDes		DECIMAL(14,2);
	DECLARE Var_MonedaCtaDes	INT;
	DECLARE Var_StatusCtaDes	CHAR(1);
	DECLARE Var_CuentaAhoOriID	BIGINT(12);
	DECLARE Var_CuentaAhoDesID	BIGINT(12);



	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Entero_Uno			INT(11);
	DECLARE Entero_Dos			INT(11);
	DECLARE Sta_Activa			CHAR(1);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE Mov_TransCtas		VARCHAR(4);
	DECLARE Con_TransCta		INT(11);
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE Alta_EncPolSI		CHAR(1);
	DECLARE Alta_EncPolNO		CHAR(1);
	DECLARE Alta_DetPolSI   	CHAR(1);
	DECLARE Aho_ConCapital  	INT(11);
	DECLARE Var_Consecutivo		BIGINT(20);
    DECLARE Var_MontLimite		DECIMAL(12,2);
    DECLARE Var_EstatusActivo	CHAR(1);

	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Entero_Dos			:= 2;
	SET Sta_Activa			:= 'A';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';
	SET Mov_TransCtas		:= '19';
	SET Con_TransCta		:= 501;
	SET SalidaSI			:= 'S';
	SET SalidaNO			:= 'N';
	SET Alta_EncPolSI		:= 'S';
	SET Alta_EncPolNO		:= 'N';
	SET Alta_DetPolSI   	:= 'S';
	SET Aho_ConCapital  	:= 1;
    SET Var_EstatusActivo	:= 'A';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APPWTRANSFERINTERPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		SELECT CuentaAhoID INTO Var_CuentaAhoOriID FROM TARJETADEBITO WHERE TarjetaDebID = Par_TarjetaOriID;

		SET Var_CuentaAhoOriID := IFNULL(Var_CuentaAhoOriID, Entero_Cero);
		IF(Var_CuentaAhoOriID = Entero_Cero) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Numero de la tarjeta de origen no existe.';
			SET Var_Control := 'cuentaCargoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT CuentaAhoID INTO Var_CuentaAhoDesID FROM TARJETADEBITO WHERE TarjetaDebID = Par_TarjetaDesID;

		SET Var_CuentaAhoDesID := IFNULL(Var_CuentaAhoDesID, Entero_Cero);
		IF(Var_CuentaAhoDesID = Entero_Cero) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Numero de la tarjeta de destino no existe.';
			SET Var_Control := 'cuentaCargoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FechaSistema
			INTO Var_FecAplicacion
			FROM PARAMETROSSIS;

		CALL SALDOSAHORROCON(Var_ClienteOri,     Var_SaldoCtaOri,    Var_MonedaCtaOri,   Var_StatusCtaOri,		Var_CuentaAhoOriID  );

		IF(Var_StatusCtaOri != Sta_Activa) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Estatus de la Cuenta de Cargo no esta Activa';
			SET Var_Control := 'cuentaCargoID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_Monto := IFNULL(Par_Monto, Entero_Cero);

		IF Par_Monto = Entero_Cero THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'El monto de la transferencia esta vacio';
			SET Var_Control := 'cuentaCargoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_SaldoCtaOri < Par_Monto) THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := 'Saldo Disponible Insuficiente para Realizar la Transferencia';
			SET Var_Control := 'cuentaCargoID';
			LEAVE ManejoErrores;
		END IF;


		SELECT  SucursalOrigen INTO Var_SucCliente
			FROM CLIENTES
			WHERE ClienteID = Var_ClienteOri;

		CALL CONTAAHORROPRO(
			Var_CuentaAhoOriID, Var_ClienteOri,     Aud_NumTransaccion, Var_FecAplicacion,  Var_FecAplicacion,
			Nat_Cargo,          Par_Monto,          Par_Concepto,      Par_ReferenciaMov,  Mov_TransCtas,
			Var_MonedaCtaOri,   Var_SucCliente,     Alta_EncPolSI,      Con_TransCta,       Var_Poliza,
			Alta_DetPolSI,      Aho_ConCapital,     Nat_Cargo,          Par_NumErr,         Par_ErrMen,
			Entero_Uno,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		CALL SALDOSAHORROCON(Var_ClienteDes,     Var_SaldoCtaDes,    Var_MonedaCtaDes,   Var_StatusCtaDes,	Var_CuentaAhoDesID );

		IF(Var_StatusCtaDes != Sta_Activa) THEN
			SET Par_NumErr  := 6;
			SET Par_ErrMen  := 'El Estatus de la Cuenta Beneficiaria no esta Activa';
			SET Var_Control := 'cuentaCargoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_MonedaCtaOri != Var_MonedaCtaDes) THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'La Moneda de la Cuenta Origen y del Beneficiario son Distintas';
			SET Var_Control := 'cuentaCargoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT  SucursalOrigen INTO Var_SucCliente
			FROM CLIENTES
			WHERE ClienteID = Var_ClienteDes;


		CALL CONTAAHORROPRO(
			Var_CuentaAhoDesID, Var_ClienteDes,     Aud_NumTransaccion, Var_FecAplicacion,  Var_FecAplicacion,
			Nat_Abono,          Par_Monto,          Par_Concepto,      	Par_ReferenciaMov,  Mov_TransCtas,
			Var_MonedaCtaDes,   Var_SucCliente,     Alta_EncPolNO,      Con_TransCta,       Var_Poliza,
			Alta_DetPolSI,      Aho_ConCapital,     Nat_Abono,          Par_NumErr,         Par_ErrMen,
			Entero_Dos,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Transferencia Realizada Correctamente';
		SET Var_Control := 'cuentaCargoID';
		SET Var_Consecutivo := Aud_NumTransaccion;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$