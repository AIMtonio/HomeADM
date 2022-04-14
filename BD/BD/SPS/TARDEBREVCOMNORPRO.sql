-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBREVCOMNORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBREVCOMNORPRO`;
DELIMITER $$


CREATE PROCEDURE `TARDEBREVCOMNORPRO`(

    Par_NumeroTarjeta       	CHAR(16),
	Par_Referencia				VARCHAR(12),
    Par_MontoTransaccion    	DECIMAL(12,2),
	Par_ValorDispensado			DECIMAL(12,2),
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


	DECLARE Var_CuentaAhoID 	BIGINT(12);
	DECLARE Var_DesRevAhorro	VARCHAR(50);
	DECLARE Var_ReferenciaMov	VARCHAR(50);
	DECLARE Var_SaldoDispoAct   DECIMAL(12,2);
	DECLARE Var_SaldoContable	DECIMAL(12,2);

	DECLARE Var_NumTransaccion  BIGINT(20);
	DECLARE Var_Poliza          BIGINT(20);
	DECLARE Var_ClienteID		INT(11);


	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);

	DECLARE Saldo_Cero			VARCHAR(13);
	DECLARE Error_Key			INT(11);
	DECLARE Aud_EmpresaID		INT(11);
	DECLARE Aud_Usuario			INT(11);
	DECLARE Aud_DireccionIP		VARCHAR(15);

	DECLARE Aud_ProgramaID		VARCHAR(50);
	DECLARE Aud_Sucursal		INT(11);
	DECLARE Aud_FechaActual		DATETIME;
	DECLARE Nat_Abono			CHAR(1);
	DECLARE Mov_RevCompra		INT(11);

	DECLARE ProActualiza		INT(11);
	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE ConceptoTarDeb  	INT(11);
	DECLARE Con_DescriMov		VARCHAR(100);
	DECLARE Con_AhoCapital  	INT(11);

	DECLARE Con_OperacPOS		INT(11);
	DECLARE Par_NumErr			INT(11);
	DECLARE Par_ErrMen			VARCHAR(150);
	DECLARE Est_Procesado		CHAR(1);
	DECLARE Est_Registrado		CHAR(1);


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
	SET Nat_Abono			:= 'A';
	SET Mov_RevCompra		:= 90;
	SET ProActualiza		:= 2;

	SET Pol_Automatica  	:= 'A';
	SET ConceptoTarDeb  	:= 300;
	SET Con_DescriMov   	:= 'REVERSA COMPRA CON TARJETA DE DEBITO';
	SET Con_AhoCapital  	:= 1;
	SET Con_OperacPOS   	:= 2;

	SET Est_Procesado		:= 'P';
	SET Est_Registrado		:= 'R';


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

	        SELECT tar.CuentaAhoID, tar.ClienteID
 		  INTO Var_CuentaAhoID, Var_ClienteID
                  FROM TARJETADEBITO tar
                 WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

		IF (Par_ValorDispensado != Decimal_Cero) THEN
			SET Par_MontoTransaccion	:= Par_MontoTransaccion - Par_ValorDispensado;
		END IF;


		SET Var_DesRevAhorro	:= CONCAT('REVERSA COMPRA CON TARJETA DE DEBITO');
		SET Var_ReferenciaMov  	:= Par_NumTransaccion;

				CALL TARDEBTRANSACPRO(Var_NumTransaccion);


				UPDATE CUENTASAHO SET
					AbonosDia   =   AbonosDia   +   Par_MontoTransaccion,
					AbonosMes   =   AbonosMes   +   Par_MontoTransaccion,
					Saldo       =   Saldo       +   Par_MontoTransaccion,
					SaldoDispon =   SaldoDispon +   Par_MontoTransaccion
				WHERE CuentaAhoID =   Var_CuentaAhoID;


				INSERT INTO CUENTASAHOMOV	(
					CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
					DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
					EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
					Sucursal,						NumTransaccion)
				VALUES	(
					Var_CuentaAhoID,    	Var_NumTransaccion, 	Par_FechaActual,    	Nat_Abono,				Par_MontoTransaccion,
                    Var_DesRevAhorro,		Var_ReferenciaMov,		Mov_RevCompra,      	Par_MonedaID,   		Entero_Cero,
                    Aud_EmpresaID,			Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,    	Aud_ProgramaID,
                    Aud_Sucursal,			Var_NumTransaccion);


				CALL MAESTROPOLIZAALT(
					Var_Poliza,         	Aud_EmpresaID,  		Par_FechaActual, 		Pol_Automatica,			ConceptoTarDeb,
					Con_DescriMov,      	Salida_NO,      		Aud_Usuario,            Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,     	Aud_Sucursal,   		Var_NumTransaccion);


				CALL POLIZAAHORROPRO(
					Var_Poliza,         	Aud_EmpresaID,  		Par_FechaActual, 		Var_ClienteID,      	Con_AhoCapital,
					Var_CuentaAhoID,    	Par_MonedaID,   		Entero_Cero, 			Par_MontoTransaccion,	Con_DescriMov,
					Var_NumTransaccion,		Aud_Usuario,    		Aud_FechaActual, 		Aud_DireccionIP,    	Aud_ProgramaID,
					Aud_Sucursal,       	Var_NumTransaccion);


				CALL POLIZATARJETAPRO(
					Var_Poliza,             Aud_EmpresaID,      	Par_FechaActual,		Par_NumeroTarjeta,		Var_ClienteID,
					Con_OperacPOS,          Par_MonedaID,       	Par_MontoTransaccion,	Entero_Cero,        	Con_DescriMov,
					Var_NumTransaccion,		Entero_Cero,			Salida_NO,          	Par_NumErr,             Par_ErrMen,
                    Aud_Usuario,			Aud_FechaActual, 		Aud_DireccionIP,   	 	Aud_ProgramaID,         Aud_Sucursal,
                    Var_NumTransaccion );

			UPDATE TARDEBBITACORAMOVS SET
				   NumTransaccion 	= Var_NumTransaccion,
				   Estatus			= Est_Procesado
			 WHERE TarjetaDebID = Par_NumeroTarjeta
			   AND NumTransaccion = Entero_Cero
			   AND Estatus = Est_Registrado
			   AND TardebMovID = Par_TardebMovID;

				UPDATE TARJETADEBITO SET
					NoCompraDiario      =   IFNULL(NoCompraDiario,Entero_Cero) - 1,
                    NoCompraMes         =   IFNULL(NoCompraMes, Entero_Cero) - 1,
                    MontoCompraDiario   =   IFNULL(MontoCompraDiario, Decimal_Cero) - Par_MontoTransaccion,
					MontoCompraMes      =   IFNULL(MontoCompraMes, Decimal_Cero) - Par_MontoTransaccion
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
