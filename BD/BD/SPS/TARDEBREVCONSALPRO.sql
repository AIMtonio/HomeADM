-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBREVCONSALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBREVCONSALPRO`;
DELIMITER $$


CREATE PROCEDURE `TARDEBREVCONSALPRO`(
	Par_NumeroTarjeta 			CHAR(16),
	Par_Referencia				VARCHAR(12),
	Par_MontoSurcharge			DECIMAL(12,2),
	Par_IdTerminal				VARCHAR(40),
	Par_MonedaID				INT(11),

	Par_FechaActual				DATETIME,
	Par_NumTransaccion			VARCHAR(20),
	INOUT NumeroTransaccion		VARCHAR(6),
	INOUT SaldoContableAct		VARCHAR(13),
	INOUT SaldoDisponibleAct	VARCHAR(13),

    INOUT CodigoRespuesta 	  	VARCHAR(3),
	INOUT FechaAplicacion		VARCHAR(4),
	Par_TardebMovID				INT(11)

)

TerminaStore:BEGIN


	DECLARE Var_Poliza			BIGINT(20);
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_NumTransaccion	BIGINT(20);
	DECLARE Var_MontoCom		DECIMAL(12,2);

	DECLARE Var_MontoIVACom		DECIMAL(12,2);
	DECLARE Var_ReferenciaMov	VARCHAR(50);
	DECLARE Var_IVA				DECIMAL(12,2);
	DECLARE Var_SaldoDispoAct	DECIMAL(12,2);
	DECLARE Var_SaldoContable	DECIMAL(12,2);



	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero   	 	DECIMAL(12,2);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);

	DECLARE Saldo_Cero			VARCHAR(13);
	DECLARE Error_Key			INT(11);
	DECLARE Aud_EmpresaID		INT(11);
	DECLARE Aud_Usuario     	INT(11);
	DECLARE Aud_FechaActual		DATETIME;

	DECLARE Aud_DireccionIP		VARCHAR(15);
	DECLARE Aud_ProgramaID  	VARCHAR(50);
	DECLARE Aud_Sucursal    	INT(11);
	DECLARE Mov_RevComRet		CHAR(4);
	DECLARE Mov_RevIVACom		CHAR(4);

	DECLARE Des_ComCons			VARCHAR(50);
	DECLARE Des_IVAComCon		VARCHAR(50);
	DECLARE	Pol_Automatica		CHAR(1);
	DECLARE ConceptoTarDeb		INT(11);
	DECLARE Con_AhoCapital		INT(11);

	DECLARE Par_NumErr          INT(11);
	DECLARE Par_ErrMen          VARCHAR(150);
	DECLARE ProActualiza		INT(11);
	DECLARE Con_ConATM          INT(11);
	DECLARE Est_Procesado		CHAR(1);

	DECLARE Est_Registrado		CHAR(1);
	DECLARE Nat_Abono			CHAR(1);


	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.00;
	SET Salida_NO			:= 'N';
	SET Salida_SI			:= 'S';

	SET Saldo_Cero			:= 'C000000000000';
	SET Error_Key       	:= Entero_Cero;
	SET Aud_EmpresaID   	:= 1;
	SET Aud_Usuario     	:= 1;
	SET Aud_DireccionIP 	:= 'localhost';

	SET Aud_ProgramaID  	:= 'workbench';
	SET Aud_Sucursal    	:= 1;
	SET	Nat_Abono			:= 'A';
	SET Des_ComCons     	:= 'REVERSO COMISION POR CONSULTA SALDO TD';
	SET Des_IVAComCon   	:= 'REVERSO IVA COMISION POR CONSULTA SALDO TD';

	SET Mov_RevComRet		:= '94';
	SET Mov_RevIVACom   	:= '95';
	SET Pol_Automatica  	:= 'A';
	SET ConceptoTarDeb  	:= 300;
	SET Con_AhoCapital  	:= 1;

	SET ProActualiza		:= 2;
	SET Con_ConATM      	:= 1;
	SET Var_ReferenciaMov	:= Par_NumTransaccion;
	SET Est_Procesado		:= 'P';
	SET Est_Registrado		:= 'R';


	SET Aud_FechaActual	:= NOW();


	ManejoErrores:BEGIN
		SET FechaAplicacion	:=	(SELECT DATE_FORMAT(FechaSistema , '%m%d') FROM PARAMETROSSIS);


		SELECT tar.CuentaAhoID, tar.ClienteID
 		  INTO Var_CuentaAhoID, Var_ClienteID
                  FROM TARJETADEBITO tar
                 WHERE tar.TarjetaDebID = Par_NumeroTarjeta;


		CALL TARDEBTRANSACPRO(Var_NumTransaccion);


		IF NOT EXISTS (	SELECT CajeroID FROM CATCAJEROSATM WHERE NumCajeroPROSA = Par_IdTerminal )THEN



                SET Par_MontoSurcharge	:= IFNULL(Par_MontoSurcharge, Entero_Cero);
                SET Var_MontoCom    	:= Decimal_Cero;
                SET Var_MontoIVACom 	:= Decimal_Cero;

				UPDATE CUENTASAHO SET
					AbonosDia   = AbonosDia   + Par_MontoSurcharge,
					AbonosMes   = AbonosMes   + Par_MontoSurcharge,
					Saldo       = Saldo       + Par_MontoSurcharge,
					SaldoDispon = SaldoDispon + Par_MontoSurcharge
					WHERE CuentaAhoID = Var_CuentaAhoID;

				SELECT IVA INTO Var_IVA
                        FROM SUCURSALES
                        WHERE SucursalID = Aud_Sucursal;

				SET Var_MontoIVACom := ROUND(Par_MontoSurcharge / (1 + Var_IVA) * Var_IVA, 2);
				SET Var_MontoCom    := Par_MontoSurcharge - Var_MontoIVACom;

				INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
				VALUES	(
					Var_CuentaAhoID,    Var_NumTransaccion, Par_FechaActual,    Nat_Abono,     	 	Var_MontoCom,
					Des_ComCons,        Var_ReferenciaMov,	Mov_RevComRet,	    Par_MonedaID,   	Entero_Cero,
					Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP, 	Aud_ProgramaID,
					Aud_Sucursal,       Var_NumTransaccion  );

				INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
				VALUES	(
					Var_CuentaAhoID,    Var_NumTransaccion, Par_FechaActual,    Nat_Abono,      	Var_MontoIVACom,
					Des_IVAComCon,      Var_ReferenciaMov,	Mov_RevIVACom,		Par_MonedaID,		Entero_Cero,
					Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
					Aud_Sucursal,       Var_NumTransaccion);


				CALL MAESTROPOLIZAALT(
					Var_Poliza,         Aud_EmpresaID,  	Par_FechaActual, 	Pol_Automatica,		ConceptoTarDeb,
					Des_ComCons,        Salida_NO,      	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,   	Var_NumTransaccion );


				CALL POLIZAAHORROPRO(
					Var_Poliza,         	Aud_EmpresaID,  	Par_FechaActual, 	Var_ClienteID,  	Con_AhoCapital,
					Var_CuentaAhoID,    	Par_MonedaID, 		Entero_Cero,    	Var_MontoCom,		Des_ComCons,
					Var_NumTransaccion,		Aud_Usuario,    	Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,       	Var_NumTransaccion);

				CALL POLIZATARJETAPRO(
					Var_Poliza,             Aud_EmpresaID,      Par_FechaActual, 	Par_NumeroTarjeta, 	Var_ClienteID,
					Con_ConATM,             Par_MonedaID,      	Var_MontoCom,		Entero_Cero,		Des_ComCons,
					Var_NumTransaccion,		Entero_Cero,		Salida_NO,          Par_NumErr,         Par_ErrMen,
					Aud_Usuario,           	Aud_FechaActual, 	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
					Var_NumTransaccion);

				CALL POLIZAAHORROPRO(
					Var_Poliza,         	Aud_EmpresaID,  	Par_FechaActual, 	Var_ClienteID,  	Con_AhoCapital,
					Var_CuentaAhoID,    	Par_MonedaID,   	Entero_Cero,    	Var_MontoIVACom,	Des_IVAComCon,
					Var_NumTransaccion, 	Aud_Usuario,    	Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,       	Var_NumTransaccion);

				CALL POLIZATARJETAPRO(
					Var_Poliza,             Aud_EmpresaID,      Par_FechaActual, 	Par_NumeroTarjeta, 	Var_ClienteID,
					Con_ConATM,             Par_MonedaID,      	Var_MontoIVACom,	Entero_Cero,		Des_IVAComCon,
					Var_NumTransaccion,		Entero_Cero,		Salida_NO,         	Par_NumErr,         Par_ErrMen,
					Aud_Usuario,            Aud_FechaActual, 	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
					Var_NumTransaccion);
		END IF;

		UPDATE TARJETADEBITO SET
			NoConsultaSaldoMes  =   IFNULL(NoConsultaSaldoMes, Entero_Cero)  - 1,
			MontoDispoDiario    =   IFNULL(MontoDispoDiario, Decimal_Cero)  - Par_MontoSurcharge,
			MontoDispoMes       =   IFNULL(MontoDispoMes, Decimal_Cero)     - Par_MontoSurcharge
			WHERE TarjetaDebID  =   Par_NumeroTarjeta;


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
