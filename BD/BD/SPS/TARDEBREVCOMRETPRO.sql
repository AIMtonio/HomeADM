-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBREVCOMRETPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBREVCOMRETPRO`;
DELIMITER $$


CREATE PROCEDURE `TARDEBREVCOMRETPRO`(
	Par_NumeroTarjeta       	CHAR(16),
	Par_Referencia				VARCHAR(12),
    Par_MontoTransaccion   	 	DECIMAL(12,2),
	Par_MontoAdicional    		DECIMAL(12,2),
    Par_MonedaID            	INT(11),

    Par_CompraPOSLinea      	CHAR(1),
    Par_FechaActual         	DATETIME,
	Par_NumTransaccion			VARCHAR(20),
	INOUT NumeroTransaccion		VARCHAR(6),
	INOUT SaldoContableAct		VARCHAR(13),

    INOUT SaldoDisponibleAct	VARCHAR(13),
	INOUT CodigoRespuesta 	  	VARCHAR(3),
	INOUT FechaAplicacion		VARCHAR(4),
	Par_TardebMovID				INT(11)

)

TerminaStore:BEGIN


	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_ReferenciaMov	VARCHAR(50);
	DECLARE Var_MontoCompra		DECIMAL(12,2);
	DECLARE Var_DesAhorro		VARCHAR(50);

	DECLARE	Var_NumTransaccion	BIGINT(20);
	DECLARE Var_SaldoDispoAct	DECIMAL(12,2);
	DECLARE Var_SaldoContable	DECIMAL(12,2);
	DECLARE Var_Poliza			BIGINT(20);


	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);

	DECLARE Saldo_Cero			VARCHAR(13);
	DECLARE Error_Key			INT(11);
	DECLARE Aud_EmpresaID       INT(11);
	DECLARE Aud_Usuario         INT(11);
	DECLARE Aud_FechaActual		DATETIME;

	DECLARE Aud_DireccionIP     VARCHAR(15);
	DECLARE Aud_ProgramaID      VARCHAR(50);
	DECLARE Aud_Sucursal        INT(11);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE Mov_RevCompra   	CHAR(4);

	DECLARE Mov_RevRetEfe		CHAR(4);
	DECLARE ProActualiza		INT(11);
	DECLARE Pol_Automatica		CHAR(1);
	DECLARE ConceptoTarDeb		INT(11);
	DECLARE Con_DescriMov		VARCHAR(50);

	DECLARE Con_AhoCapital		INT(11);
	DECLARE Con_OperacPOS		INT(11);
	DECLARE Par_NumErr  		INT(11);
	DECLARE Par_ErrMen  		VARCHAR(150);
	DECLARE Est_Procesado		CHAR(1);

	DECLARE Est_Registrado		CHAR(1);


	SET Cadena_Vacia	:= '';
	SET Entero_Cero		:= 0;
	SET Decimal_Cero	:= 0.00;
	SET Salida_NO		:= 'N';
	SET Salida_SI		:= 'S';

	SET Saldo_Cero		:= 'C000000000000';
	SET Error_Key       := Entero_Cero;
	SET Aud_EmpresaID   := 1;
	SET Aud_Usuario     := 1;
	SET Aud_DireccionIP := 'localhost';

	SET Aud_ProgramaID  := 'workbench';
	SET Aud_Sucursal    := 1;
	SET Nat_Abono		:= 'A';
	SET Mov_RevCompra   := '90';
	SET Mov_RevRetEfe   := '91';

	SET ProActualiza	:= 2;
	SET Pol_Automatica  := 'A';
	SET ConceptoTarDeb  := 300;
	SET Con_DescriMov   := 'REVERSO DE COMPRA+RETIRO CON TD';
	SET Con_AhoCapital  := 1;

	SET Con_OperacPOS   := 2;
	SET Est_Procesado	:= 'P';
	SET Est_Registrado	:= 'R';


	SET Aud_FechaActual	:= NOW();


	IF (Par_MontoTransaccion = Decimal_Cero )THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "110";
		SET FechaAplicacion		:= FechaAplicacion;
		LEAVE TerminaStore;
	END IF;

	SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);

	SELECT tar.CuentaAhoID, tar.ClienteID
	  INTO Var_CuentaAhoID, Var_ClienteID
	  FROM TARJETADEBITO tar
	  WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

	SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
	SET Var_ReferenciaMov  := Par_NumTransaccion;
	SET Par_MontoAdicional := IFNULL(Par_MontoAdicional, Decimal_Cero);
	SET Var_MontoCompra := (Par_MontoTransaccion - Par_MontoAdicional);


	CALL TARDEBTRANSACPRO(Var_NumTransaccion);

	UPDATE CUENTASAHO SET
		AbonosDia   = AbonosDia   + Par_MontoTransaccion,
		AbonosMes   = AbonosMes   + Par_MontoTransaccion,
		Saldo       = Saldo       + Par_MontoTransaccion,
		SaldoDispon = SaldoDispon + Par_MontoTransaccion
	WHERE CuentaAhoID = Var_CuentaAhoID;



	CALL MAESTROPOLIZAALT(
		Var_Poliza,         Aud_EmpresaID,  Par_FechaActual,	Pol_Automatica,     ConceptoTarDeb,
		Con_DescriMov,      Salida_NO,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
		Aud_ProgramaID,     Aud_Sucursal,   Var_NumTransaccion);


	IF (Var_MontoCompra <> Decimal_Cero ) THEN

		SET Var_DesAhorro := CONCAT('REVERSO DE COMPRA CON TDD');

		INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
		VALUES	(
			Var_CuentaAhoID,    Var_NumTransaccion, Par_FechaActual,	Nat_Abono,  		Var_MontoCompra,
			Var_DesAhorro,      Var_ReferenciaMov,	Mov_RevCompra,      Par_MonedaID,   	Entero_Cero,
			Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
			Aud_Sucursal,       Var_NumTransaccion);

		SET Con_DescriMov   := 'REVERSO DE COMPRA CON TDD';
		CALL POLIZAAHORROPRO(
			Var_Poliza,         Aud_EmpresaID,  	Par_FechaActual,	Var_ClienteID,		Con_AhoCapital,
			Var_CuentaAhoID,    Par_MonedaID,   	Entero_Cero,        Var_MontoCompra,	Con_DescriMov,
			Var_NumTransaccion,	Aud_Usuario,    	Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,       Var_NumTransaccion);


		CALL POLIZATARJETAPRO(
			Var_Poliza,         Aud_EmpresaID,      Par_FechaActual,	Par_NumeroTarjeta,	Var_ClienteID,
			Con_OperacPOS,      Par_MonedaID,		Var_MontoCompra,	Entero_Cero,		Con_DescriMov,
			Var_NumTransaccion, Entero_Cero,		Salida_NO,          Par_NumErr,     	Par_ErrMen,
			Aud_Usuario,	    Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,
			Var_NumTransaccion);

	END IF;

	SET Var_DesAhorro := CONCAT('REVERSO DE RETIRO EN COMPRA CON TDD ');
		INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
		VALUES	(
		Var_CuentaAhoID,    Var_NumTransaccion,	Par_FechaActual,	Nat_Abono,      	Par_MontoAdicional,
		Var_DesAhorro,      Var_ReferenciaMov,	Mov_RevRetEfe,      Par_MonedaID,   	Entero_Cero,
		Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
		Aud_Sucursal,       Var_NumTransaccion);



	SET Con_DescriMov   := 'REVERSO DE RETIRO EN COMPRA CON TDD';
	CALL POLIZAAHORROPRO(
		Var_Poliza,         Aud_EmpresaID,	Par_FechaActual,	Var_ClienteID,		Con_AhoCapital,
		Var_CuentaAhoID,    Par_MonedaID,   Entero_Cero,		Par_MontoAdicional,	Con_DescriMov,
		Var_NumTransaccion,	Aud_Usuario,    Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,
		Aud_Sucursal,       Var_NumTransaccion);

	CALL POLIZATARJETAPRO(
		Var_Poliza,			Aud_EmpresaID,  Par_FechaActual,    Par_NumeroTarjeta,	Var_ClienteID,
		Con_OperacPOS,		Par_MonedaID,   Par_MontoAdicional, Entero_Cero,  		Con_DescriMov,
		Var_NumTransaccion,	Entero_Cero,	Salida_NO,          Par_NumErr,         Par_ErrMen,
		Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
		Var_NumTransaccion);



	UPDATE TARJETADEBITO SET
		NoDispoDiario       =   IFNULL(NoDispoDiario, Entero_Cero)  - 1,
		NoDispoMes          =   IFNULL(NoDispoMes, Entero_Cero)     - 1,
		MontoDispoDiario    =   IFNULL(MontoDispoDiario, Decimal_Cero)  - Par_MontoTransaccion,
		MontoDispoMes       =   IFNULL(MontoDispoMes, Decimal_Cero)     - Par_MontoTransaccion,
		NoCompraDiario      =   IFNULL(NoCompraDiario,Entero_Cero)  - 1,
		NoCompraMes         =   IFNULL(NoCompraMes, Entero_Cero)    - 1,
		MontoCompraDiario   =   IFNULL(MontoCompraDiario, Decimal_Cero) - Par_MontoTransaccion,
		MontoCompraMes      =   IFNULL(MontoCompraMes, Decimal_Cero)    - Par_MontoTransaccion
	WHERE TarjetaDebID      =   Par_NumeroTarjeta;

	UPDATE TARDEBBITACORAMOVS SET
		   NumTransaccion 	= Var_NumTransaccion,
		   Estatus			= Est_Procesado
	 WHERE Referencia	 = Par_Referencia
	   AND TarjetaDebID = Par_NumeroTarjeta
	   AND NumTransaccion = Entero_Cero
	   AND Estatus = Est_Registrado
	   AND TardebMovID = Par_TardebMovID;


	SELECT IFNULL(SaldoDispon,Decimal_Cero), IFNULL(Saldo, Decimal_Cero)
			INTO Var_SaldoDispoAct, Var_SaldoContable
		FROM CUENTASAHO
		WHERE CuentaAhoID = Var_CuentaAhoID;

	IF ( Error_Key = Entero_Cero ) THEN
		SET NumeroTransaccion	:= LPAD(CONVERT(Var_NumTransaccion,CHAR), 6, 0);
		SET SaldoContableAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoContable,CHAR) , '.', ''), 12, 0));
		SET SaldoDisponibleAct	:= CONCAT('C' , LPAD(REPLACE(CONVERT(Var_SaldoDispoAct,CHAR) , '.', ''), 12, 0));
		SET CodigoRespuesta   	:= "000";
		SET FechaAplicacion		:= FechaAplicacion;
	ELSE
		SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
		SET SaldoContableAct	:= Saldo_Cero;
		SET SaldoDisponibleAct	:= Saldo_Cero;
		SET CodigoRespuesta   	:= "412";
		SET FechaAplicacion		:= FechaAplicacion;
		ROLLBACK;
	END IF;



END TerminaStore$$
