-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWINVCASTIGOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWINVCASTIGOPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWINVCASTIGOPRO`(
	Par_CreditoID			BIGINT,				-- Parametro de numero de credito
	Par_FechaOperacion		DATE,				-- Parametro de fecha de operacion
	Par_FechaAplicacion		DATE,				-- Parametro de fecha de aplicacion
	Par_Poliza				BIGINT,				-- Parametro de numero de poliza

	Par_Salida				CHAR(1),			-- Parametro que indica si el store retornara una salida.
	INOUT Par_NumErr		INT(11),			-- Parametro donde se almacenara el numero de error.
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro donde se almacenara el mensaje de error.
	Par_Consecutivo			INT(11),

	Aud_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT				-- Parametro de Auditoria
)
TerminaStore:BEGIN
-- Declaracion de Variables

DECLARE Var_FondeoID 			BIGINT(20);
DECLARE	Var_ClienteID			INT(11);
DECLARE Var_CuentaAhoID			BIGINT(12);
DECLARE Var_AmortizaID			INT(11);
DECLARE Var_PorcCapital			DECIMAL(9,6);
DECLARE Var_PorcInteres			DECIMAL(9,6);
DECLARE Var_PorcComisi			DECIMAL(9,6);
DECLARE Var_PorcFondeo			DECIMAL(9,6);
DECLARE	Var_SaldoCapVig			DECIMAL(12,2);
DECLARE	Var_SaldoCapExi			DECIMAL(12,2);
DECLARE Var_CapCtaOrden			DECIMAL(14,4);
DECLARE	Var_SaldoInteres		DECIMAL(14,4);
DECLARE	Var_IntCtaOrden			DECIMAL(14,4);
DECLARE	Var_SaldoIntMor			DECIMAL(14,4);
DECLARE	Var_InteresAcum			DECIMAL(14,4);
DECLARE Var_RetencAcum			DECIMAL(14,4);
DECLARE Var_NumRetMes			INT(11);
DECLARE Var_SucCliente			INT(5);
DECLARE Var_PagaISR				CHAR(1);

DECLARE Var_FondeoIdStr			VARCHAR(20);
DECLARE Var_DivideCastigo		CHAR(1);

DECLARE Var_CastigoCap  		DECIMAL(14,2);
DECLARE Var_CastigoInt  		DECIMAL(14,2);
DECLARE Var_CasIntMora  		DECIMAL(14,2);
DECLARE	Var_TotalCastigo		DECIMAL(14,2);
DECLARE Var_CastigoCapCO 		DECIMAL(14,2);
DECLARE Var_CastigoIntCO		DECIMAL(14,2);
DECLARE Var_MonedaID			INT(11);
DECLARE Var_TotalRegs			INT(11);
DECLARE Var_Contador			INT(11);

-- Declaracion de constantes
DECLARE Des_Movimiento			VARCHAR(100);
DECLARE Des_MovimientoCap		VARCHAR(100);
DECLARE Des_MovimientoInt		VARCHAR(100);
DECLARE Des_MovimientoMora		VARCHAR(100);

DECLARE AltaPoliza_NO			CHAR(1);
DECLARE Entero_Cero				INT(11);
DECLARE AltaPol_SI				CHAR(1);
DECLARE AltaMov_SI				CHAR(1);
DECLARE AltaMov_NO				CHAR(1);
DECLARE CtaOrdenInt				INT(11);
DECLARE CorrCtaOrdenInt			INT(11);
DECLARE CtaOrdenCap				INT(11);
DECLARE CorrCtaOrdenCap			INT(11);
DECLARE CtaOrdenInvCast			INT(11);
DECLARE CorrCtaOrdenInvCast		INT(11);
DECLARE CtaOrdenInvIntCast		INT(11);
DECLARE CorrCtaOrdenInvIntCast	INT(11);

DECLARE SalidaNO				CHAR(1);
DECLARE TipoMovIntCtaOr			INT(11);
DECLARE TipoMovCapCtaOr			INT(11);
DECLARE Nat_Abono				CHAR(1);
DECLARE Nat_Cargo				CHAR(1);
DECLARE AltaMovAho_NO			CHAR(1);
DECLARE Cadena_Vacia			CHAR(1);
DECLARE AplicaCapitalSI			CHAR(1);
DECLARE AplicaInteresSI			CHAR(1);
DECLARE MontoPagoMin			DECIMAL(12,2);
DECLARE CtaOrdenMora			INT(11);
DECLARE CorrCtaOrdenMora		INT(11);
DECLARE CtaOrdenCasMora			INT(11);
DECLARE CorrCtaOrdenCasMora		INT(11);

DECLARE MovIntMora				INT(4);
DECLARE StringNO				CHAR(4);
DECLARE Esta_Pagado				CHAR(1);
DECLARE Esta_Castigada			CHAR(1);
DECLARE Par_SalidaSI			CHAR(1);

-- Asignacion de Constantes
SET Des_Movimiento				:='CASTIGO INV. CROWDFUNDING';
SET Des_MovimientoCap			:='CASTIGO INV. CAPITAL';
SET Des_MovimientoInt			:='CASTIGO INV. INTERES';
SET Des_MovimientoMora			:='CASTIGO INV. MORATORIO';
SET AltaPoliza_NO				:='N';
SET Entero_Cero					:=0;
SET AltaPol_SI					:='S';
SET AltaMov_SI					:='S';
SET AltaMov_NO					:='N';
SET CtaOrdenInt					:=13;			-- Conceptos crowdfunding
SET CorrCtaOrdenInt				:=14;			-- Conceptos crowdfunding
SET CtaOrdenCap					:=11;			-- Conceptos crowdfunding
SET CorrCtaOrdenCap				:=12;			-- Conceptos crowdfunding
SET CtaOrdenInvCast				:=17;			-- Conceptos crowdfunding
SET CorrCtaOrdenInvCast			:=18;			-- Conceptos crowdfunding
SET CtaOrdenInvIntCast			:=19;			-- Conceptos crowdfunding
SET CorrCtaOrdenInvIntCast		:=20;			-- Conceptos crowdfunding
SET TipoMovIntCtaOr				:=16;			-- Movimientos crowdfunding interes cuentas de orden
SET TipoMovCapCtaOr				:=3;			-- Movimientos crowdfunding interes cuentas de orden

SET Nat_Abono					:='A';			-- Naturaleza Abono
SET Nat_Cargo					:='C';			-- Naturaleza Cargo
SET AltaMovAho_NO				:='N';			-- Alta en movimiento de ahorro No
SET Cadena_Vacia				:='';			-- Cadena Vacia
SET SalidaNO					:='N';			-- Salida en Pantalla No

SET AplicaCapitalSI				:='S';			-- Aplica Garantias de Capital si
SET AplicaInteresSI				:='S';			-- Aplica Garantias de interes si
SET MontoPagoMin				:=0.01;			-- Monto de Pago minimo
SET CtaOrdenMora				:=15;			-- Cta. Orden Intereses Moratorios CONCEPTOS
SET CorrCtaOrdenMora			:=16;			-- Corr. Cta. Orden Intereses Moratorios CONCEPTOS
SET CtaOrdenCasMora				:=21;			-- Cta. Orden Castigo Intereses Moratorios CONCEPTOS
SET CorrCtaOrdenCasMora			:=22;			-- Corr Cta. Orden Castigo Intereses Moratorios CONCEPTOS
SET MovIntMora					:=15;			-- Movimiento de interes moratorio TIPOSMOVS
SET StringNO					:='N';			-- String No
SET Esta_Pagado					:='P';			-- Estatus Pagado
SET Esta_Castigada				:='K';			-- Estatus Estatus Castigado
SET Par_SalidaSI				:='S';

-- Inicializacion de variables
SET Var_CastigoCap  			:= Entero_Cero;
SET Var_CastigoInt  			:= Entero_Cero;
SET Var_CasIntMora  			:= Entero_Cero;
SET	Var_TotalCastigo			:= Entero_Cero;
SET Var_CastigoIntCO			:= Entero_Cero;
SET Var_CastigoCapCO			:= Entero_Cero;

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		 SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-CRWINVCASTIGOPRO");
	END;

    DELETE FROM TMPINVCASTIGOCRW WHERE NumTransaccion = Aud_NumTransaccion;

	SET @Var_ConsID := Entero_Cero;

	INSERT INTO TMPINVCASTIGOCRW (
		TmpID,
		FondeoID,          		 	 ClienteID,        		 	 CuentaAhoID,      		 	 AmortizacionID,    		 	 PorcentajeCapital,
		PorcentajeInteres, 		 	 PorcentajeComisi, 		 	 PorcentajeFondeo, 		 	 SaldoCapVigente,   		 	 SaldoCapExigible,
		SaldoCapCtaOrden,  		 	 SaldoInteres,     		 	 SaldoIntCtaOrden, 		 	 SaldoIntMoratorio, 		 	 ProvisionAcum,
		RetencionIntAcum,  		 	 NumRetirosMes,    		 	 SucursalOrigen,   		 	 PagaISR,           		 	 MonedaID,
		EmpresaID,         		 	 Usuario,          		 	 FechaActual,      		 	 DireccionIP,       			 ProgramaID,
		Sucursal,         		 	 NumTransaccion)
	SELECT
		(@Var_ConsID := @Var_ConsID + 1),
		Fon.SolFondeoID,      		 Fon.ClienteID,        		 Fon.CuentaAhoID,      		 Amo.AmortizacionID,    		 Amo.PorcentajeCapital,
		Amo.PorcentajeInteres, 		 Fon.PorcentajeComisi, 		 Fon.PorcentajeFondeo, 		 Amo.SaldoCapVigente,   		 Amo.SaldoCapExigible,
		Amo.SaldoCapCtaOrden,  		 Amo.SaldoInteres,     		 Amo.SaldoIntCtaOrden, 		 Amo.SaldoIntMoratorio, 		 Amo.ProvisionAcum,
		Amo.RetencionIntAcum,  		 Fon.NumRetirosMes,    		 Cli.SucursalOrigen,   		 Cli.PagaISR,           		 Fon.MonedaID,
		Aud_EmpresaID,				 Aud_Usuario,				 Aud_FechaActual,			 Aud_DireccionIP,				 Aud_ProgramaID,
		Aud_Sucursal,				 Aud_NumTransaccion
		FROM CRWFONDEO Fon
		INNER JOIN AMORTICRWFONDEO 		Amo 	ON Amo.SolFondeoID 		= Fon.SolFondeoID
		INNER JOIN CLIENTES 			Cli 	ON Cli.ClienteID 		= Fon.ClienteID
		INNER JOIN CRWTIPOSFONDEADOR 	Tip		ON Tip.TipoFondeadorID 	= Fon.TipoFondeo
		WHERE Fon.CreditoID			= Par_CreditoID
		  AND Fon.TipoFondeo		= 1
		  AND Tip.PagoEnIncumple	= StringNO
		  AND Fon.Estatus			= StringNO
		  AND Amo.Estatus			= StringNO;


	SELECT DivideCastigo INTO Var_DivideCastigo
		FROM PARAMSRESERVCASTIG
		WHERE EmpresaID = Aud_EmpresaID;

	SET	Var_DivideCastigo	:= IFNULL(Var_DivideCastigo, StringNO);

	-- Aplicamos las garant[ias Faltantes

	CALL CRWFONDEOAPGPRO (
		Par_CreditoID,		AplicaCapitalSI,	AplicaInteresSI,	AltaPoliza_NO, 		Par_Poliza,
		SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET Var_TotalRegs := (SELECT COUNT(*) FROM TMPINVCASTIGOCRW WHERE NumTransaccion = Aud_NumTransaccion);
	SET Var_TotalRegs := IFNULL(Var_TotalRegs, Entero_Cero);

	SET Var_Contador := 1;

	WHILE(Var_Contador <= Var_TotalRegs)DO

		SELECT
			SolFondeoID,			ClienteID,        	 	CuentaAhoID,			AmortizacionID,    	 	PorcentajeCapital,
			PorcentajeInteres, 	 	PorcentajeComisi, 	 	PorcentajeFondeo,		SaldoCapVigente,   	 	SaldoCapExigible,
			SaldoCapCtaOrden,  	 	SaldoInteres,     	 	SaldoIntCtaOrden, 	 	SaldoIntMoratorio, 	 	ProvisionAcum,
			RetencionIntAcum,  	 	NumRetirosMes,    	 	SucursalOrigen,   	 	PagaISR,           	 	MonedaID
		INTO
			Var_FondeoID,			Var_ClienteID,			Var_CuentaAhoID,		Var_AmortizaID,			Var_PorcCapital,
			Var_PorcInteres,		Var_PorcComisi,			Var_PorcFondeo,			Var_SaldoCapVig,		Var_SaldoCapExi,
			Var_CapCtaOrden,		Var_SaldoInteres,		Var_IntCtaOrden,		Var_SaldoIntMor,		Var_InteresAcum,
			Var_RetencAcum,			Var_NumRetMes,			Var_SucCliente, 		Var_PagaISR, 			Var_MonedaID
		FROM TMPINVCASTIGOCRW
		WHERE TmpID = Var_Contador
			AND NumTransaccion = Aud_NumTransaccion;


		SET Var_SaldoCapVig	:= IFNULL(Var_SaldoCapVig, Entero_Cero);
		SET Var_SaldoCapExi	:= IFNULL(Var_SaldoCapExi, Entero_Cero);
		SET Var_CapCtaOrden	:= IFNULL(Var_CapCtaOrden, Entero_Cero);
		SET Var_SaldoInteres:= IFNULL(Var_SaldoInteres, Entero_Cero);
		SET Var_IntCtaOrden	:= IFNULL(Var_IntCtaOrden, Entero_Cero);
		SET Var_SaldoIntMor	:= IFNULL(Var_SaldoIntMor, Entero_Cero);

		SET	Var_FondeoIdStr	:= CONVERT(Var_FondeoID, CHAR);

		SET Var_CastigoCap  := Entero_Cero;
		SET Var_CastigoInt  := Entero_Cero;
		SET Var_CastigoCapCO:= Entero_Cero;
		SET Var_CastigoIntCO:= Entero_Cero;
		SET Var_CasIntMora	:= Entero_Cero;
		SET Var_TotalCastigo:= Entero_Cero;

		SET Var_CastigoCap  := Var_CastigoCap + Var_SaldoCapVig + Var_SaldoCapExi;
		SET Var_CastigoInt  := Var_CastigoInt + Var_SaldoInteres;
		SET Var_CastigoCapCO:= Var_CastigoCapCO+ Var_CapCtaOrden;
		SET Var_CastigoIntCO:= Var_CastigoIntCO + Var_IntCtaOrden;
		SET Var_CasIntMora	:= Var_CasIntMora + Var_SaldoIntMor;

		-- Cancelamos las Cuentas de Orden de moratorios
		IF(Var_SaldoIntMor >= MontoPagoMin)THEN

			CALL CRWCONTAINVPRO(
				Var_FondeoID,     	 	 	Var_AmortizaID, 	 	Var_CuentaAhoID,   	 Var_ClienteID,    	 Par_FechaOperacion,
				Par_FechaAplicacion, 	 	Var_SaldoIntMor,        Var_MonedaID,      	 Var_NumRetMes,    	 Var_SucCliente,
				Des_MovimientoMora,     	Var_FondeoIdStr,     	AltaPoliza_NO, 	 	 Entero_Cero,  	 	 Par_Poliza,
				AltaPol_SI,      	 		AltaMov_SI,       	 	CtaOrdenMora,  	 	 MovIntMora, 	 	 Nat_Abono,
				Nat_Abono,        	 		AltaMovAho_NO,     	 	Cadena_Vacia,    	 Cadena_Vacia,    	 SalidaNO,
				Par_NumErr,          	 	Par_ErrMen,         	Par_Consecutivo,   	 Aud_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,     	 	Aud_DireccionIP,    	Aud_ProgramaID,    	 Aud_Sucursal,     	 Aud_NumTransaccion);

			CALL CRWCONTAINVPRO(
				Var_FondeoID,     	 	 	Var_AmortizaID, 	 	Var_CuentaAhoID,   	 Var_ClienteID,    	 Par_FechaOperacion,
				Par_FechaAplicacion, 	 	Var_SaldoIntMor,        Var_MonedaID,      	 Var_NumRetMes,    	 Var_SucCliente,
				Des_MovimientoMora,     	Var_FondeoIdStr,     	AltaPoliza_NO, 	 	 Entero_Cero,  	 	 Par_Poliza,
				AltaPol_SI,      	 		AltaMov_NO,       	 	CorrCtaOrdenMora,  	 Entero_Cero, 	 	 Nat_Cargo,
				Cadena_Vacia,        	 	AltaMovAho_NO,     	 	Cadena_Vacia,    	 Cadena_Vacia,    	 SalidaNO,
				Par_NumErr,          	 	Par_ErrMen,         	Par_Consecutivo,   	 Aud_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,     	 	Aud_DireccionIP,    	Aud_ProgramaID,    	 Aud_Sucursal,     	 Aud_NumTransaccion);

		END IF;

		-- Cancelamos las Cuentas de orden de interes
		IF(Var_IntCtaOrden >= MontoPagoMin)THEN
			CALL CRWCONTAINVPRO(
				Var_FondeoID,        	 Var_AmortizaID,  	 Var_CuentaAhoID, 	 Var_ClienteID,   	 Par_FechaOperacion,
				Par_FechaAplicacion, 	 Var_IntCtaOrden, 	 Var_MonedaID,    	 Var_NumRetMes,   	 Var_SucCliente,
				Des_MovimientoInt,   	 Var_FondeoIdStr, 	 AltaPoliza_NO,   	 Entero_Cero,     	 Par_Poliza,
				AltaPol_SI,          	 AltaMov_SI,      	 CtaOrdenInt,     	 TipoMovIntCtaOr, 	 Nat_Abono,
				Nat_Abono,           	 AltaMovAho_NO,   	 Cadena_Vacia,    	 Cadena_Vacia,    	 SalidaNO,
				Par_NumErr,          	 Par_ErrMen,      	 Par_Consecutivo, 	 Par_EmpresaID,   	 Aud_Usuario,
				Aud_FechaActual,     	 Aud_DireccionIP, 	 Aud_ProgramaID,  	 Aud_Sucursal,    	 Aud_NumTransaccion);

			CALL CRWCONTAINVPRO(
				Var_FondeoID,        	 Var_AmortizaID,  	 Var_CuentaAhoID, 	 Var_ClienteID, 	 Par_FechaOperacion,
				Par_FechaAplicacion, 	 Var_IntCtaOrden, 	 Var_MonedaID,    	 Var_NumRetMes, 	 Var_SucCliente,
				Des_MovimientoInt,   	 Var_FondeoIdStr, 	 AltaPoliza_NO,   	 Entero_Cero,   	 Par_Poliza,
				AltaPol_SI,          	 AltaMov_NO,      	 CorrCtaOrdenInt, 	 Entero_Cero,   	 Nat_Cargo,
				Cadena_Vacia,        	 AltaMovAho_NO,   	 Cadena_Vacia,    	 Cadena_Vacia,  	 SalidaNO,
				Par_NumErr,          	 Par_ErrMen,      	 Par_Consecutivo, 	 Par_EmpresaID, 	 Aud_Usuario,
				Aud_FechaActual,     	 Aud_DireccionIP, 	 Aud_ProgramaID,  	 Aud_Sucursal,  	 Aud_NumTransaccion);

		END IF;

		-- Cancelamos las Cuentas de Orden de Capital
		IF(Var_CapCtaOrden >= MontoPagoMin)THEN
			CALL CRWCONTAINVPRO(
				Var_FondeoID,        	 	 Var_AmortizaID,  	 	 Var_CuentaAhoID, 	 	 Var_ClienteID,   	 	 Par_FechaOperacion,
				Par_FechaAplicacion, 	 	 Var_CapCtaOrden, 	 	 Var_MonedaID,    	 	 Var_NumRetMes,   	 	 Var_SucCliente,
				Des_MovimientoCap,   	 	 Var_FondeoIdStr, 	 	 AltaPoliza_NO,   	 	 Entero_Cero,     	 	 Par_Poliza,
				AltaPol_SI,          	 	 AltaMov_SI,      	 	 CtaOrdenCap,     	 	 TipoMovCapCtaOr, 	 	 Nat_Abono,
				Nat_Abono,           	 	 AltaMovAho_NO,   	 	 Cadena_Vacia,    	 	 Cadena_Vacia,    	 	 SalidaNO,
				Par_NumErr,          	 	 Par_ErrMen,      	 	 Par_Consecutivo, 	 	 Par_EmpresaID,   	 	 Aud_Usuario,
				Aud_FechaActual,     	 	 Aud_DireccionIP, 		 Aud_ProgramaID,  	 	 Aud_Sucursal,    	 	 Aud_NumTransaccion);

			CALL CRWCONTAINVPRO(
				Var_FondeoID,        		 Var_AmortizaID,  		 Var_CuentaAhoID, 		 Var_ClienteID, 		 Par_FechaOperacion,
				Par_FechaAplicacion, 		 Var_CapCtaOrden, 		 Var_MonedaID,    		 Var_NumRetMes, 		 Var_SucCliente,
				Des_MovimientoCap,   		 Var_FondeoIdStr, 		 AltaPoliza_NO,   		 Entero_Cero,   		 Par_Poliza,
				AltaPol_SI,          		 AltaMov_NO,      		 CorrCtaOrdenCap, 		 Entero_Cero,   		 Nat_Cargo,
				Cadena_Vacia,        		 AltaMovAho_NO,   		 Cadena_Vacia,    		 Cadena_Vacia,  		 SalidaNO,
				Par_NumErr,          		 Par_ErrMen,      		 Par_Consecutivo, 		 Par_EmpresaID, 		 Aud_Usuario,
				Aud_FechaActual,     		 Aud_DireccionIP, 		 Aud_ProgramaID,  		 Aud_Sucursal,  		 Aud_NumTransaccion);

		END IF;

		SET	Var_TotalCastigo	:= Var_CastigoCap + Var_CastigoInt + Var_CasIntMora + Var_CastigoCapCO + Var_CastigoIntCO;

		-- ------------------------------ Registramos las cuentas del Castigo------------------------------
		IF(Var_DivideCastigo = StringNO) THEN

			CALL CRWCONTAINVPRO(
				Var_FondeoID,        	 Var_AmortizaID,   	 Entero_Cero,     	 Var_ClienteID, 	 Par_FechaOperacion,
				Par_FechaAplicacion, 	 Var_TotalCastigo, 	 Var_MonedaID,    	 Var_NumRetMes, 	 Var_SucCliente,
				Des_Movimiento,      	 Var_FondeoIdStr,  	 AltaPoliza_NO,   	 Entero_Cero,   	 Par_Poliza,
				AltaPol_SI,          	 AltaMov_NO,       	 CtaOrdenInvCast, 	 Entero_Cero,   	 Nat_Cargo,
				Nat_Cargo,           	 AltaMovAho_NO,    	 Cadena_Vacia,    	 Cadena_Vacia,  	 SalidaNO,
				Par_NumErr,          	 Par_ErrMen,       	 Par_Consecutivo, 	 Par_EmpresaID, 	 Aud_Usuario,
				Aud_FechaActual,     	 Aud_DireccionIP,  	 Aud_ProgramaID,  	 Aud_Sucursal,  	 Aud_NumTransaccion);

			CALL CRWCONTAINVPRO(
				Var_FondeoID,        	 Var_AmortizaID,   	 Var_CuentaAhoID,     	 Var_ClienteID, 	 Par_FechaOperacion,
				Par_FechaAplicacion, 	 Var_TotalCastigo, 	 Var_MonedaID,        	 Var_NumRetMes, 	 Var_SucCliente,
				Des_Movimiento,      	 Var_FondeoIdStr,  	 AltaPoliza_NO,       	 Entero_Cero,   	 Par_Poliza,
				AltaPol_SI,          	 AltaMov_NO,       	 CorrCtaOrdenInvCast, 	 Entero_Cero,   	 Nat_Abono,
				Cadena_Vacia,        	 AltaMovAho_NO,    	 Cadena_Vacia,        	 Cadena_Vacia,  	 SalidaNO,
				Par_NumErr,          	 Par_ErrMen,       	 Par_Consecutivo,     	 Par_EmpresaID, 	 Aud_Usuario,
				Aud_FechaActual,     	 Aud_DireccionIP,  	 Aud_ProgramaID,      	 Aud_Sucursal,  	 Aud_NumTransaccion);
		ELSE-- Se divide el castigo

			IF(Var_CasIntMora >= MontoPagoMin)THEN

				CALL CRWCONTAINVPRO(
					Var_FondeoID,        	 Var_AmortizaID,  	 Entero_Cero,     	 Var_ClienteID, 	 Par_FechaOperacion,
					Par_FechaAplicacion, 	 Var_CasIntMora,  	 Var_MonedaID,    	 Var_NumRetMes, 	 Var_SucCliente,
					Des_MovimientoMora,  	 Var_FondeoIdStr, 	 AltaPoliza_NO,   	 Entero_Cero,   	 Par_Poliza,
					AltaPol_SI,          	 AltaMov_NO,      	 CtaOrdenCasMora, 	 Entero_Cero,   	 Nat_Cargo,
					Nat_Cargo,           	 AltaMovAho_NO,   	 Cadena_Vacia,    	 Cadena_Vacia,  	 SalidaNO,
					Par_NumErr,          	 Par_ErrMen,      	 Par_Consecutivo, 	 Par_EmpresaID, 	 Aud_Usuario,
					Aud_FechaActual,     	 Aud_DireccionIP, 	 Aud_ProgramaID,  	 Aud_Sucursal,  	 Aud_NumTransaccion);

				CALL CRWCONTAINVPRO(
					Var_FondeoID,        	 Var_AmortizaID,  	 Var_CuentaAhoID,     	 Var_ClienteID, 	 Par_FechaOperacion,
					Par_FechaAplicacion, 	 Var_CasIntMora,  	 Var_MonedaID,        	 Var_NumRetMes, 	 Var_SucCliente,
					Des_MovimientoMora,  	 Var_FondeoIdStr, 	 AltaPoliza_NO,       	 Entero_Cero,   	 Par_Poliza,
					AltaPol_SI,          	 AltaMov_NO,      	 CorrCtaOrdenCasMora, 	 Entero_Cero,   	 Nat_Abono,
					Cadena_Vacia,        	 AltaMovAho_NO,   	 Cadena_Vacia,        	 Cadena_Vacia,  	 SalidaNO,
					Par_NumErr,          	 Par_ErrMen,      	 Par_Consecutivo,     	 Par_EmpresaID, 	 Aud_Usuario,
					Aud_FechaActual,     	 Aud_DireccionIP, 	 Aud_ProgramaID,      	 Aud_Sucursal,  	 Aud_NumTransaccion);
			END IF;

			IF(Var_CastigoInt >= MontoPagoMin)THEN
				CALL CRWCONTAINVPRO(
					Var_FondeoID,        	 Var_AmortizaID,   	 Entero_Cero,        	 Var_ClienteID, 	 Par_FechaOperacion,
					Par_FechaAplicacion, 	 Var_CastigoIntCO, 	 Var_MonedaID,       	 Var_NumRetMes, 	 Var_SucCliente,
					Des_MovimientoInt,   	 Var_FondeoIdStr,  	 AltaPoliza_NO,      	 Entero_Cero,   	 Par_Poliza,
					AltaPol_SI,          	 AltaMov_NO,       	 CtaOrdenInvIntCast, 	 Entero_Cero,   	 Nat_Cargo,
					Nat_Cargo,           	 AltaMovAho_NO,    	 Cadena_Vacia,       	 Cadena_Vacia,  	 SalidaNO,
					Par_NumErr,          	 Par_ErrMen,       	 Par_Consecutivo,    	 Par_EmpresaID, 	 Aud_Usuario,
					Aud_FechaActual,     	 Aud_DireccionIP,  	 Aud_ProgramaID,     	 Aud_Sucursal,  	 Aud_NumTransaccion);

				CALL CRWCONTAINVPRO(
					Var_FondeoID,        	 Var_AmortizaID,   	 Var_CuentaAhoID,        	 Var_ClienteID, 	 Par_FechaOperacion,
					Par_FechaAplicacion, 	 Var_CastigoIntCO, 	 Var_MonedaID,           	 Var_NumRetMes, 	 Var_SucCliente,
					Des_MovimientoInt,   	 Var_FondeoIdStr,  	 AltaPoliza_NO,          	 Entero_Cero,   	 Par_Poliza,
					AltaPol_SI,          	 AltaMov_NO,       	 CorrCtaOrdenInvIntCast, 	 Entero_Cero,   	 Nat_Abono,
					Cadena_Vacia,        	 AltaMovAho_NO,    	 Cadena_Vacia,           	 Cadena_Vacia,  	 SalidaNO,
					Par_NumErr,          	 Par_ErrMen,       	 Par_Consecutivo,        	 Par_EmpresaID, 	 Aud_Usuario,
					Aud_FechaActual,     	 Aud_DireccionIP,  	 Aud_ProgramaID,         	 Aud_Sucursal,  	 Aud_NumTransaccion);
			END IF;

			IF(Var_CastigoCap >= MontoPagoMin)THEN

				CALL CRWCONTAINVPRO(
					Var_FondeoID,        	 Var_AmortizaID,   	 Entero_Cero,     	 Var_ClienteID, 	 Par_FechaOperacion,
					Par_FechaAplicacion, 	 Var_CastigoCapCO, 	 Var_MonedaID,    	 Var_NumRetMes, 	 Var_SucCliente,
					Des_MovimientoCap,   	 Var_FondeoIdStr,  	 AltaPoliza_NO,   	 Entero_Cero,   	 Par_Poliza,
					AltaPol_SI,          	 AltaMov_NO,       	 CtaOrdenInvCast, 	 Entero_Cero,   	 Nat_Cargo,
					Nat_Cargo,           	 AltaMovAho_NO,    	 Cadena_Vacia,    	 Cadena_Vacia,  	 SalidaNO,
					Par_NumErr,          	 Par_ErrMen,       	 Par_Consecutivo, 	 Par_EmpresaID, 	 Aud_Usuario,
					Aud_FechaActual,     	 Aud_DireccionIP,  	 Aud_ProgramaID,  	 Aud_Sucursal,  	 Aud_NumTransaccion);

				CALL CRWCONTAINVPRO(
					Var_FondeoID,        	 Var_AmortizaID,   	 Var_CuentaAhoID,     	 Var_ClienteID, 	 Par_FechaOperacion,
					Par_FechaAplicacion, 	 Var_CastigoCapCO, 	 Var_MonedaID,        	 Var_NumRetMes, 	 Var_SucCliente,
					Des_MovimientoCap,   	 Var_FondeoIdStr,  	 AltaPoliza_NO,       	 Entero_Cero,   	 Par_Poliza,
					AltaPol_SI,          	 AltaMov_NO,       	 CorrCtaOrdenInvCast, 	 Entero_Cero,   	 Nat_Abono,
					Cadena_Vacia,        	 AltaMovAho_NO,    	 Cadena_Vacia,        	 Cadena_Vacia,  	 SalidaNO,
					Par_NumErr,          	 Par_ErrMen,       	 Par_Consecutivo,     	 Par_EmpresaID, 	 Aud_Usuario,
					Aud_FechaActual,     	 Aud_DireccionIP,  	 Aud_ProgramaID,      	 Aud_Sucursal,  	 Aud_NumTransaccion);
			END IF;

		END IF;

		-- Almacenamos los montos Castigados y posibles a recuperar
		IF NOT EXISTS(SELECT FondeoID
				FROM CRWINVCASTIGO
				WHERE FondeoID = Var_FondeoID
					AND NumTransaccion = Aud_NumTransaccion) THEN

			INSERT INTO CRWINVCASTIGO (
				FondeoID,         		 CreditoID,        		 ClienteID,        		 CuentaahoID,  		 Fecha,
				CapitalCastigado, 		 InteresCastigado, 		 IntMoraCastigado, 		 CapCtaOrden,  		 IntCtaOrden,
				TotalCastigo,     		 MonRecuperado,    		 SaldoCapital,     		 SaldoInteres, 		 SaldoMoratorio,
				SaldoCapCtaOrden, 		 SaldoIntCtaOrden, 		 NumRetirosMes,    		 EmpresaID,    		 Usuario,
				FechaActual,      		 DireccionIP,      		 ProgramaID,       		 Sucursal,     		 NumTransaccion)
			VALUES(
				Var_FondeoID,     	 	 Par_CreditoID,    	 	 Var_ClienteID,  	 	 Var_CuentaAhoID,  	 Par_FechaOperacion,
				Var_CastigoCap,   	 	 Var_CastigoInt,   	 	 Var_CasIntMora, 	 	 Var_CastigoCapCO, 	 Var_CastigoIntCO,
				Var_TotalCastigo, 	 	 Entero_Cero,      	 	 Var_CastigoCap, 	 	 Var_CastigoInt,   	 Var_CasIntMora,
				Var_CastigoCapCO, 	 	 Var_CastigoIntCO, 	 	 Var_NumRetMes,  	 	 Par_EmpresaID,    	 Aud_Usuario,
				Aud_FechaActual,  	 	 Aud_DireccionIP,  	 	 Aud_ProgramaID, 	 	 Aud_Sucursal,     	 Aud_NumTransaccion);
		ELSE
			UPDATE CRWINVCASTIGO SET
				CapitalCastigado	=	CapitalCastigado 	+ Var_CastigoCap,
				InteresCastigado	=	InteresCastigado 	+ Var_CastigoInt,
				IntMoraCastigado	=	IntMoraCastigado 	+ Var_CasIntMora,
				CapCtaOrden			=	CapCtaOrden 		+ Var_CastigoCapCO,
				IntCtaOrden			=	IntCtaOrden 		+ Var_CastigoIntCO,
				TotalCastigo		=	TotalCastigo 		+ Var_TotalCastigo,
				SaldoCapital		=	SaldoCapital 		+ Var_CastigoCap,
				SaldoInteres		=	SaldoInteres 		+ Var_CastigoInt,
				SaldoMoratorio		=	SaldoMoratorio 		+ Var_CasIntMora,
				SaldoCapCtaOrden	=	SaldoCapCtaOrden 	+ Var_CastigoCapCO,
				SaldoIntCtaOrden	=	SaldoIntCtaOrden 	+ Var_CastigoIntCO
				WHERE FondeoID = Var_FondeoID
					AND NumTransaccion = Aud_NumTransaccion;
		END IF;

		SET Var_Contador := Var_Contador + 1;
	END WHILE;

	-- Marcamos las amortizaciones de las inversiones como pagadas
	UPDATE  AMORTICRWFONDEO amor
		INNER JOIN CRWFONDEO fon ON amor.SolFondeoID = fon.SolFondeoID AND fon.CreditoID = Par_CreditoID SET
			amor.Estatus		= 	Esta_Pagado,
			amor.FechaLiquida	= 	Par_FechaOperacion
		WHERE  amor.Estatus		!= 	Esta_Pagado;

	-- Marcamos las inversiones como Castigadas
	UPDATE CRWFONDEO SET
	    Estatus         = Esta_Castigada,

	    Usuario     	= Aud_Usuario,
	    FechaActual 	= Aud_FechaActual,
	    DireccionIP 	= Aud_DireccionIP,
	    ProgramaID  	= Aud_ProgramaID,
	    Sucursal    	= Aud_Sucursal,
	    NumTransaccion	= Aud_NumTransaccion
		WHERE CreditoID = Par_CreditoID;

END ManejoErrores;

IF (Par_Salida = Par_SalidaSI) THEN
    SELECT Par_NumErr 	AS NumErr,
           Par_ErrMen 	AS ErrMen,
           '' 			AS control,
           0 			AS consecutivo;
END IF;

END TerminaStore$$