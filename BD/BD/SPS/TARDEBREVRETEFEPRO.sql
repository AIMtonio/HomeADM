-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBREVRETEFEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBREVRETEFEPRO`;
DELIMITER $$


CREATE PROCEDURE `TARDEBREVRETEFEPRO`(
	Par_NumeroTarjeta 			CHAR(16),
	Par_Referencia				VARCHAR(12),
	Par_MontoTransaccion		DECIMAL(12,2),
	Par_MontoSurcharge			DECIMAL(12,2),
	Par_ValorDispensado			DECIMAL(12,2),

	Par_IdTerminal				VARCHAR(40),
	Par_MonedaID				INT(11),
	Par_FechaActual				DATETIME,
	Par_NumTransaccion			VARCHAR(20),

	INOUT NumeroTransaccion		VARCHAR(6),
	INOUT SaldoContableAct		VARCHAR(13),
	INOUT SaldoDisponibleAct	VARCHAR(13),
	INOUT CodigoRespuesta 	  	VARCHAR(3),
	INOUT FechaAplicacion		VARCHAR(4),

	Par_TardebMovID				INT(11)  -- Id llave de la tabla TARDEBBITACORAMOVS con la cual se esta realizando la
                                         -- preautorizacion de la transaccii¿½i¿½n.
	)

TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_MontoCom		DECIMAL(12,2);		    -- Monto de la comision
	DECLARE Var_MontoIVACom		DECIMAL(12,2);			-- Monto de IVA de comision
	DECLARE Var_MontoDisp		DECIMAL(12,2);			-- Monto de disponibilidad
	DECLARE Var_NumTransaccion  BIGINT(20);				-- Numero de transaccion
	DECLARE Var_CuentaAhoID		BIGINT(12);				-- Numero de la cuenta

	DECLARE Var_ClienteID		INT(11);				-- Numero del cliente
	DECLARE Var_DesAhorro		VARCHAR(50);			-- Descripcion del moviminto
	DECLARE Var_SaldoDispoAct	DECIMAL(12,2);			-- Valor del saldo disponible actual
	DECLARE Var_SaldoContable	DECIMAL(12,2);			-- Valor del saldo contable de la cuenta
	DECLARE Var_IVA				DECIMAL(12,2);			-- Valor del IVA de la sucursal

	DECLARE Var_Poliza			BIGINT(20);				-- Valor del numero de la poliza contable
	DECLARE Var_CajeroID		VARCHAR(40);			-- Numero del cajero ATM

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(12,2);
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
	DECLARE Par_ReferenciaMov	VARCHAR(50);
	DECLARE Mov_RevRetEfe		CHAR(4);

	DECLARE Mov_RevComRet		CHAR(4);
	DECLARE Des_ComRetiro		VARCHAR(50);
	DECLARE Des_IVAComRet		VARCHAR(50);
	DECLARE Mov_RevIVACom		CHAR(4);
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
	DECLARE Par_ErrMen          VARCHAR(150);

	DECLARE Con_OperacATM		INT(11);
	DECLARE TipoInstrumentoID	INT(11);
	DECLARE Cadena_Cero			CHAR(1);
	DECLARE Est_Procesado		CHAR(1);
	DECLARE Est_Registrado		CHAR(1);

	DECLARE Nat_Abono			CHAR(1);


	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';						-- Cadena Vacia
	SET Entero_Cero			:= 0;						-- Entero Cero
	SET Decimal_Cero		:= 0.00;					-- DECIMAL Cero
	SET Salida_NO			:= 'N';						-- Salida en Pantalla NO
	SET Salida_SI			:= 'S';						-- Salida en Pantalla SI

	SET Saldo_Cero			:= 'C000000000000';			-- codigo Saldo Cero
	SET Error_Key       	:= Entero_Cero;				-- Error Cero
	SET Aud_EmpresaID   	:= 1;						-- Parametro de auditoria
	SET Aud_Usuario     	:= 1;						-- Parametro de auditoria
	SET Aud_FechaActual		:= NOW();					-- Parametro de auditoria

	SET Aud_DireccionIP 	:= 'localhost';				-- Parametro de auditoria
	SET Aud_ProgramaID  	:= 'workbench';				-- Parametro de auditoria
	SET Aud_Sucursal    	:= 1;						-- Parametro de auditoria
	SET Nat_Abono			:= 'A';						-- Naturaleza Abono
	SET Var_DesAhorro   	:= 'REVERSO RETIRO CON TDD';-- Descripcion del movimiento de Ahorro

	SET Des_ComRetiro   	:= 'REVERSO COMISION POR RETIRO';
	SET Des_IVAComRet   	:= 'REVERSO IVA COMISION POR RETIRO';
	SET Mov_RevRetEfe   	:= '91'; 					-- Movimiento de Ahorro Reversa Retiro de Efectivo
	SET Mov_RevComRet   	:= '92';					-- movimiento de Ahorro Reversa Comision por Retiro de Efectivo
	SET Mov_RevIVACom		:= '93';					-- Movimiento de Ahorro Reversa IVA Comision por Retiro de Efectuivo

	SET ProActualiza		:= 2;						-- Proceso de actualizacion
	SET Pol_Automatica  	:= 'A'; 					-- Poliza Generada Automatizamente
	SET ConceptoTarDeb  	:= 300;   					-- Concepto contable
	SET Con_AhoCapital  	:= 1;						-- Concepto de ahorro Capital
	SET Nat_Cargo			:= 'C';						-- Naturaleza Cargo

	SET AltaPolizaNO		:= 'N';						-- Alta en Encabezado de la Poliza NO
	SET DetPolizaSI 		:= 'S';						-- Alta en Detalle de Poliza SI
	SET AfectaFirme			:= 'F';						-- Afectacion en Saldo de la cuenta de Ahorro
	SET AfectaSaldoSI		:= 'S';						-- Afectacion en Saldo de la cuenta de Ahorro
	SET Con_OperacATM		:= 1;						-- Concepto de ATMs

	SET TipoInstrumentoID	:= 2;						-- Tipo de Instrumento Cuenta de ahorro
	SET Cadena_Cero			:= '0';						-- Cadena Cero
	SET Est_Procesado		:= 'P';						-- Estatus en Proceso
	SET Est_Registrado		:= 'R';						-- Estatus Registrado

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

		IF (Par_ValorDispensado != Decimal_Cero) THEN
			SET Par_MontoTransaccion	:= Par_MontoTransaccion - Par_ValorDispensado;
			SET Var_MontoDisp   		:= Par_MontoTransaccion;
		ELSE
			SET Var_MontoDisp   		:= (Par_MontoTransaccion - Par_MontoSurcharge);
		END IF;



		SET Var_MontoCom    	:= Decimal_Cero;
		SET Var_MontoIVACom 	:= Decimal_Cero;
		SET Par_ReferenciaMov	:= Par_NumTransaccion;


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
			Var_CuentaAhoID,    Var_NumTransaccion, 	Par_FechaActual,    Nat_Abono,      	Var_MontoDisp,
			Var_DesAhorro,      Par_ReferenciaMov,		Mov_RevRetEfe,		Par_MonedaID,   	Entero_Cero,
			Aud_EmpresaID,      Aud_Usuario,        	Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
			Aud_Sucursal,       Var_NumTransaccion);



		CALL MAESTROPOLIZAALT(
			Var_Poliza,         Aud_EmpresaID,  Par_FechaActual, 	Pol_Automatica,		ConceptoTarDeb,
			Var_DesAhorro,      Salida_NO,      Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,   Var_NumTransaccion);



		IF NOT EXISTS (	SELECT CajeroID FROM CATCAJEROSATM WHERE NumCajeroPROSA = Par_IdTerminal )THEN

			SELECT IVA INTO Var_IVA
				FROM SUCURSALES
				WHERE SucursalID = Aud_Sucursal;

			IF (Par_ValorDispensado != Decimal_Cero) THEN


				CALL POLIZAAHORROPRO(
					Var_Poliza,         	Aud_EmpresaID,  	Par_FechaActual,	Var_ClienteID,      	Con_AhoCapital,
					Var_CuentaAhoID,    	Par_MonedaID,   	Entero_Cero,		Par_MontoTransaccion,	Var_DesAhorro,
					Var_NumTransaccion,		Aud_Usuario,    	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,       	Var_NumTransaccion);

				CALL POLIZATARJETAPRO(
					Var_Poliza,             Aud_EmpresaID,      Par_FechaActual,		Par_NumeroTarjeta,		Var_ClienteID,
					Con_OperacATM,          Par_MonedaID,       Par_MontoTransaccion,	Entero_Cero,        	Var_DesAhorro,
					Var_NumTransaccion,		Entero_Cero,		Salida_NO,          	Par_NumErr,             Par_ErrMen,
                    Aud_Usuario,			Aud_FechaActual, 	Aud_DireccionIP,    	Aud_ProgramaID,         Aud_Sucursal,
                    Var_NumTransaccion);



			ELSE

				SET Var_MontoIVACom := ROUND(Par_MontoSurcharge / (1 + Var_IVA) * Var_IVA, 2);
				SET Var_MontoCom    := Par_MontoSurcharge - Var_MontoIVACom;

				INSERT INTO `CUENTASAHOMOV`     (
                    `CuentaAhoID`,                 `NumeroMov`,                    `Fecha`,                    `NatMovimiento`,                 `CantidadMov`,
                    `DescripcionMov`,                   `ReferenciaMov`,                    `TipoMovAhoID`,                 `MonedaID`,                 `PolizaID`,
                    `EmpresaID`,                        `Usuario`,                  `FechaActual`,                  `DireccionIP`,                  `ProgramaID`,
                    `Sucursal`,                 `NumTransaccion`)
                VALUES  (
					Var_CuentaAhoID,    Var_NumTransaccion, Par_FechaActual,    Nat_Abono,      	Var_MontoCom,
					Des_ComRetiro,      Par_ReferenciaMov,	Mov_RevComRet,   	Par_MonedaID,   	Entero_Cero,
                    Aud_EmpresaID,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,		Var_NumTransaccion);

				INSERT INTO `CUENTASAHOMOV`     (
                    `CuentaAhoID`,                 `NumeroMov`,                    `Fecha`,                    `NatMovimiento`,                 `CantidadMov`,
                    `DescripcionMov`,                   `ReferenciaMov`,                    `TipoMovAhoID`,                 `MonedaID`,                 `PolizaID`,
                    `EmpresaID`,                        `Usuario`,                  `FechaActual`,                  `DireccionIP`,                  `ProgramaID`,
                    `Sucursal`,                 `NumTransaccion`)
                    VALUES  (
					Var_CuentaAhoID,    Var_NumTransaccion, Par_FechaActual,    Nat_Abono,      	Var_MontoIVACom,
					Des_IVAComRet,      Par_ReferenciaMov,	Mov_RevIVACom,      Par_MonedaID,   	Entero_Cero,
                    Aud_EmpresaID,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,		Var_NumTransaccion);



				CALL POLIZAAHORROPRO(
					Var_Poliza,         	Aud_EmpresaID,  	Par_FechaActual,	Var_ClienteID,      Con_AhoCapital,
					Var_CuentaAhoID,    	Par_MonedaID,   	Entero_Cero,		Var_MontoDisp,		Var_DesAhorro,
					Var_NumTransaccion,		Aud_Usuario,    	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,       	Var_NumTransaccion);

				CALL POLIZATARJETAPRO(
					Var_Poliza,             Aud_EmpresaID,      Par_FechaActual,	Par_NumeroTarjeta,	Var_ClienteID,
					Con_OperacATM,          Par_MonedaID,       Var_MontoDisp,		Entero_Cero,        Var_DesAhorro,
					Var_NumTransaccion,		Entero_Cero,		Salida_NO,          Par_NumErr,         Par_ErrMen,
                    Aud_Usuario,			Aud_FechaActual, 	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                    Var_NumTransaccion);

				CALL POLIZAAHORROPRO(
					Var_Poliza,         	Aud_EmpresaID,  	Par_FechaActual,	Var_ClienteID,      Con_AhoCapital,
					Var_CuentaAhoID,    	Par_MonedaID,   	Entero_Cero,		Var_MontoCom,       Des_ComRetiro,
					Var_NumTransaccion,		Aud_Usuario,    	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,       	Var_NumTransaccion);

				CALL POLIZATARJETAPRO(
					Var_Poliza,             Aud_EmpresaID,      Par_FechaActual,	Par_NumeroTarjeta,	Var_ClienteID,
					Con_OperacATM,          Par_MonedaID,       Var_MontoCom,		Entero_Cero,        Des_ComRetiro,
					Var_NumTransaccion,		Entero_Cero,		Salida_NO,          Par_NumErr,			Par_ErrMen,
                    Aud_Usuario,			Aud_FechaActual, 	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,
                    Var_NumTransaccion);

				CALL POLIZAAHORROPRO(
					Var_Poliza,         	Aud_EmpresaID,  	Par_FechaActual, 	Var_ClienteID,		Con_AhoCapital,
					Var_CuentaAhoID,    	Par_MonedaID,   	Entero_Cero,		Var_MontoIVACom,	Des_IVAComRet,
					Var_NumTransaccion,		Aud_Usuario,    	Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,       	Var_NumTransaccion);

				CALL POLIZATARJETAPRO(
					Var_Poliza,             Aud_EmpresaID,      Par_FechaActual,	Par_NumeroTarjeta,	Var_ClienteID,
					Con_OperacATM,          Par_MonedaID,       Var_MontoIVACom,	Entero_Cero,        Des_IVAComRet,
					Var_NumTransaccion,		Entero_Cero,		Salida_NO,          Par_NumErr,			Par_ErrMen,
                    Aud_Usuario,			Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                    Var_NumTransaccion);


			END IF;





		ELSE

			SELECT CajeroID  INTO Var_CajeroID
				FROM CATCAJEROSATM
				WHERE NumCajeroPROSA = Par_IdTerminal;


			CALL POLIZAAHORROPRO(
				Var_Poliza,         Aud_EmpresaID,  	Par_FechaActual, 	Var_ClienteID,      Con_AhoCapital,
				Var_CuentaAhoID,    Par_MonedaID,   	Entero_Cero,        Var_MontoDisp,		Var_DesAhorro,
				Var_NumTransaccion,	Aud_Usuario,    	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,       Var_NumTransaccion);

			CALL CONTAATMPRO (
				Var_CajeroID,	Par_MontoTransaccion,	Var_DesAhorro,		Par_MonedaID,			AltaPolizaNO,
				DetPolizaSI,	Con_AhoCapital,			Nat_Cargo,			Var_NumTransaccion,		Var_CuentaAhoID,
				AfectaFirme,	AfectaSaldoSI,			Nat_Cargo, 			Par_FechaActual, 		TipoInstrumentoID,
				Cadena_Cero,	Var_Poliza,				Salida_NO,			Par_NumErr,				Par_ErrMen,
				Aud_EmpresaID,	Aud_Usuario,    		Aud_FechaActual, 	Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,	Var_NumTransaccion);

		END IF;




		UPDATE TARJETADEBITO SET
			NoDispoDiario       =   IFNULL(NoDispoDiario, Entero_Cero)  - 1,
			NoDispoMes          =   IFNULL(NoDispoMes, Entero_Cero)     - 1,
			MontoDispoDiario    =   IFNULL(MontoDispoDiario, Decimal_Cero)  - Par_MontoTransaccion,
			MontoDispoMes       =   IFNULL(MontoDispoMes, Decimal_Cero)     - Par_MontoTransaccion
		WHERE TarjetaDebID  =   Par_NumeroTarjeta;

	UPDATE TARDEBBITACORAMOVS SET
		   NumTransaccion 	= Var_NumTransaccion,
		   Estatus			= Est_Procesado
	 WHERE Referencia	 	= Par_Referencia
	   AND TarjetaDebID 	= Par_NumeroTarjeta
	   AND NumTransaccion 	= Entero_Cero
	   AND Estatus 			= Est_Registrado
	   AND TardebMovID 		= Par_TardebMovID;


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
