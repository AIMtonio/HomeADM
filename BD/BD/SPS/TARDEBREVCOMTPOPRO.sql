-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBREVCOMTPOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBREVCOMTPOPRO`;
DELIMITER $$


CREATE PROCEDURE `TARDEBREVCOMTPOPRO`(
	Par_NumeroTarjeta 			CHAR(16),
	Par_Referencia				VARCHAR(12),
	Par_MontoTransaccion		DECIMAL(12,2),
	Par_MontoSurcharge			DECIMAL(12,2),
	Par_ValorDispensado			DECIMAL(12,2),

	Par_IdTerminal				VARCHAR(40),
	Par_MonedaID				INT(11),
	Par_FechaActual				DATETIME,
	Par_NumeroTransaccion		VARCHAR(20),
	Par_DatosTiempoAire			VARCHAR(70),

	INOUT NumeroTransaccion		VARCHAR(6),
	INOUT SaldoContableAct		VARCHAR(13),
	INOUT SaldoDisponibleAct	VARCHAR(13),
	INOUT CodigoRespuesta 	  	VARCHAR(3),
	INOUT FechaAplicacion		VARCHAR(4),

	Par_TardebMovID				INT(11)

)

TerminaStore:BEGIN


	DECLARE Var_MontoCom		DECIMAL(12,2);
	DECLARE Var_MontoIVACom		DECIMAL(12,2);
	DECLARE Var_MontoDispo		DECIMAL(12,2);
	DECLARE Var_NumTransaccion  BIGINT(20);
	DECLARE Var_CuentaAhoID		BIGINT(12);

	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_DesAhorro		VARCHAR(50);
	DECLARE Var_DesComTpo		VARCHAR(50);
	DECLARE Var_DesIvaCom		VARCHAR(50);
	DECLARE Par_ReferenciaMov	VARCHAR(50);

	DECLARE Var_SaldoDispoAct	DECIMAL(12,2);
	DECLARE Var_SaldoContable	DECIMAL(12,2);
	DECLARE Var_IVA				DECIMAL(12,2);
	DECLARE Var_Poliza			BIGINT(20);
	DECLARE Var_CajeroID		VARCHAR(40);

	DECLARE Var_ComSusMis		DECIMAL(12,2);
	DECLARE Var_Compania		CHAR(4);
	DECLARE Var_NumCel			CHAR(10);
	DECLARE Var_CentroATM		INT(11);
	DECLARE Aud_FechaActual		DATETIME;


	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero    	 	INT;
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);

	DECLARE Saldo_Cero			VARCHAR(13);
	DECLARE Error_Key			INT(11);
	DECLARE Aud_EmpresaID		INT(11);
	DECLARE Aud_Usuario     	INT(11);
	DECLARE Aud_DireccionIP		VARCHAR(15);

	DECLARE Aud_ProgramaID  	VARCHAR(50);
	DECLARE Aud_Sucursal    	INT(11);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE Mov_RevTpoAire		CHAR(4);
	DECLARE Mov_RevComTpo		CHAR(4);

	DECLARE Mov_RevIvaCom		CHAR(4);
	DECLARE ProActualiza		INT(11);
	DECLARE Pol_Automatica		CHAR(1);
	DECLARE ConceptoTarDeb  	INT(11);
	DECLARE Con_AhoCapital		INT(11);

	DECLARE Nat_Cargo			CHAR(1);
	DECLARE AltaPolizaNO		CHAR(1);
	DECLARE DetPolizaSI			CHAR(1);
	DECLARE AfectaFirme			CHAR(1);
	DECLARE AfectaSaldoSI		CHAR(1);

	DECLARE Par_NumErr          INT(11);
	DECLARE Par_ErrMen          VARCHAR(200);
	DECLARE Con_OperacATM		INT(11);
	DECLARE Con_DescriMov		VARCHAR(100);
	DECLARE Con_OpeIVAATM		INT(11);

	DECLARE Con_OpeComATM		INT(11);
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
	SET Var_DesAhorro   := 'REVERSO COMPRA TIEMPO AIRE ATM';
	SET Var_DesComTpo	:= 'REVERSO COMISION TIEMPO AIRE ATM';

	SET Var_DesIvaCom	:= 'REVERSO IVA COM TIEMPO AIRE ATM';
	SET Mov_RevTpoAire  := '99';
	SET Mov_RevComTpo	:= '103';
	SET Mov_RevIvaCom	:= '104';
	SET ProActualiza	:= 2;

	SET Pol_Automatica  := 'A';
	SET ConceptoTarDeb  := 300;
	SET Con_AhoCapital  := 1;
	SET Nat_Cargo		:= 'C';
	SET AltaPolizaNO	:= 'N';

	SET DetPolizaSI 	:= 'S';
	SET AfectaFirme		:= 'F';
	SET AfectaSaldoSI	:= 'S';
	SET Con_OperacATM	:= 1;
	SET Con_OpeIVAATM 	:= 6;

	SET Con_OpeComATM 	:= 7;
	SET Est_Procesado	:= 'P';
	SET Est_Registrado	:= 'R';


	SET Aud_FechaActual	:= NOW();

	ManejoErrores:BEGIN

		IF (Par_MontoTransaccion = Decimal_Cero )THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Entero_Cero,CHAR), 6, 0);
			SET SaldoContableAct	:= Saldo_Cero;
			SET SaldoDisponibleAct	:= Saldo_Cero;
			SET CodigoRespuesta   	:= "110";
			SET FechaAplicacion		:= FechaAplicacion;
			LEAVE ManejoErrores;
		END IF;

		SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);

		SELECT tar.CuentaAhoID, tar.ClienteID
 		  INTO Var_CuentaAhoID, Var_ClienteID
                  FROM TARJETADEBITO tar
                 WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

		SELECT IVA INTO Var_IVA
				FROM SUCURSALES
				WHERE SucursalID = Aud_Sucursal;

		SET Var_Compania	:= SUBSTRING(TRIM(Par_DatosTiempoAire),1, 4);
		SET Var_NumCel		:= SUBSTRING(TRIM(Par_DatosTiempoAire),5, 10);
		SET Par_Referencia	:= Par_NumeroTransaccion;



		SET Var_MontoCom    	:= Decimal_Cero;
		SET Var_MontoIVACom 	:= Decimal_Cero;




		CALL TARDEBTRANSACPRO(Var_NumTransaccion);

		UPDATE CUENTASAHO SET
			AbonosDia   = AbonosDia     + Par_MontoTransaccion,
			AbonosMes   = AbonosMes     + Par_MontoTransaccion,
			Saldo       = Saldo         + Par_MontoTransaccion,
			SaldoDispon = SaldoDispon   + Par_MontoTransaccion
		WHERE CuentaAhoID = Var_CuentaAhoID;


		INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
		VALUES	(
			Var_CuentaAhoID,	Var_NumTransaccion,	Par_FechaActual,	Nat_Abono,      Par_MontoTransaccion,
			Var_DesAhorro,		Par_Referencia,		Mov_RevTpoAire,		Par_MonedaID,   Entero_Cero,
			Aud_EmpresaID,		Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,
			Aud_Sucursal,		Var_NumTransaccion);

		CALL MAESTROPOLIZAALT(
			Var_Poliza,         Aud_EmpresaID,  Par_FechaActual, 	Pol_Automatica,		ConceptoTarDeb,
			Var_DesAhorro,      Salida_NO,      Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,   Var_NumTransaccion);

		IF NOT EXISTS (	SELECT CajeroID FROM CATCAJEROSATM WHERE NumCajeroPROSA = Par_IdTerminal )THEN

			CALL POLIZAAHORROPRO(
				Var_Poliza,         Aud_EmpresaID,  	Par_FechaActual, 	Var_ClienteID,      	Con_AhoCapital,
				Var_CuentaAhoID,    Par_MonedaID,   	Entero_Cero,        Par_MontoTransaccion,	Var_DesAhorro,
				Par_Referencia,     Aud_Usuario,    	Aud_FechaActual, 	Aud_DireccionIP,    	Aud_ProgramaID,
				Aud_Sucursal,       Var_NumTransaccion  );


			CALL POLIZATARJETAPRO(
				Var_Poliza,         Aud_EmpresaID,      Par_FechaActual, 		Par_NumeroTarjeta,      Var_ClienteID,
				Con_OperacATM,      Par_MonedaID,       Par_MontoTransaccion,	Entero_Cero,			Var_DesAhorro,
				Par_Referencia,     Entero_Cero,		Salida_NO,              Par_NumErr,             Par_ErrMen,
				Aud_Usuario,	    Aud_FechaActual, 	Aud_DireccionIP,		Aud_ProgramaID,         Aud_Sucursal,
				Var_NumTransaccion );

		ELSE

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
				Var_Poliza,         Aud_EmpresaID,  	Par_FechaActual, 	Var_ClienteID,      	Con_AhoCapital,
				Var_CuentaAhoID,    Par_MonedaID,   	Entero_Cero,		Par_MontoTransaccion,	Var_DesAhorro,
				Par_Referencia,     Aud_Usuario,    	Aud_FechaActual, 	Aud_DireccionIP,    	Aud_ProgramaID,
				Aud_Sucursal,       Var_NumTransaccion  );

			CALL POLIZATARJETAPRO(
				Var_Poliza,         Aud_EmpresaID,      Par_FechaActual, 	Par_NumeroTarjeta,      Var_ClienteID,
				Con_OperacATM,      Par_MonedaID,       Var_MontoDispo,  	Entero_Cero,			Var_DesAhorro,
				Par_Referencia,     Entero_Cero,		Salida_NO,          Par_NumErr,				Par_ErrMen,
				Aud_Usuario,	    Aud_FechaActual, 	Aud_DireccionIP,    Aud_ProgramaID,			Aud_Sucursal,
				Var_NumTransaccion );

			SET Con_DescriMov	:= 'REVERSO COMISION COMPRA TIEMPO AIRE ATM';

		   SELECT SUC.CentroCostoID INTO Var_CentroATM
			 FROM 	CATCAJEROSATM ATM
			 INNER JOIN SUCURSALES SUC ON ATM.SucursalID=SUC.SucursalID
			 WHERE TRIM(NumCajeroPROSA)= TRIM(Par_IdTerminal);


			CALL POLIZATARJETAPRO(
				Var_Poliza,         Aud_EmpresaID,      Par_FechaActual, 	Par_NumeroTarjeta,      Var_ClienteID,
				Con_OpeComATM,      Par_MonedaID,       Var_MontoCom,		Entero_Cero,   			Con_DescriMov,
				Par_Referencia,     Var_CentroATM,		Salida_NO,          Par_NumErr,         	Par_ErrMen,
				Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     	Aud_Sucursal,
				Var_NumTransaccion );


			SET Con_DescriMov	:= 'REVERSO IVA COMISION COMPRA TIEMPO AIRE';

			CALL POLIZATARJETAPRO(
				Var_Poliza,         Aud_EmpresaID,      Par_FechaActual, 	Par_NumeroTarjeta,      Var_ClienteID,
				Con_OpeIVAATM,      Par_MonedaID,       Var_MontoIVACom,   	Entero_Cero,			Con_DescriMov,
				Par_Referencia,     Entero_Cero,		Salida_NO,          Par_NumErr,         	Par_ErrMen,
				Aud_Usuario,	    Aud_FechaActual, 	Aud_DireccionIP,    Aud_ProgramaID,     	Aud_Sucursal,
				Var_NumTransaccion );

		END IF;

  	  UPDATE TARDEBBITACORAMOVS SET
	  	     NumTransaccion 	= Var_NumTransaccion,
		     Estatus			= Est_Procesado
	   WHERE TarjetaDebID = Par_NumeroTarjeta
	     AND NumTransaccion = Entero_Cero
		 AND Estatus = Est_Registrado
	     AND TardebMovID = Par_TardebMovID;

		UPDATE TARJETADEBITO SET
			NoDispoDiario       =   IFNULL(NoDispoDiario, Entero_Cero)  - 1,
			NoDispoMes          =   IFNULL(NoDispoMes, Entero_Cero)     - 1,
			MontoDispoDiario    =   IFNULL(MontoDispoDiario, Decimal_Cero)  - Par_MontoTransaccion,
			MontoDispoMes       =   IFNULL(MontoDispoMes, Decimal_Cero)     - Par_MontoTransaccion
		WHERE TarjetaDebID  =   Par_NumeroTarjeta;

		SELECT IFNULL(SaldoDispon,Decimal_Cero), IFNULL(Saldo, Decimal_Cero)
				INTO Var_SaldoDispoAct, Var_SaldoContable
			FROM CUENTASAHO
			WHERE CuentaAhoID = Var_CuentaAhoID;

		IF Error_Key = Entero_Cero THEN
			SET NumeroTransaccion	:= LPAD(CONVERT(Var_NumTransaccion, CHAR), 6, 0);
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

	END ManejoErrores;
END TerminaStore$$
