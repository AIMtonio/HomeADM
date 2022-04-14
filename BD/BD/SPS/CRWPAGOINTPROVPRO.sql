-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWPAGOINTPROVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWPAGOINTPROVPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWPAGOINTPROVPRO`(
	Par_CreditoID           BIGINT(12),
	Par_FechaInicio         DATE,
	Par_FechaVencim         DATE,
	Par_FechaOperacion      DATE,
	Par_FechaAplicacion     DATE,

	Par_Monto               DECIMAL(14,2),
	Par_MonedaID            INT(11),
	Par_SucCliente          INT(11),
	Par_Poliza              BIGINT,
	Par_Salida				CHAR(1),

	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,
	Par_Empresa             INT(11),
	Aud_Usuario             INT(11),

	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	Var_Contador		BIGINT;
DECLARE Var_SolFondeoID		BIGINT;
DECLARE Var_ClienteID       BIGINT;
DECLARE Var_CuentaAhoID 	BIGINT;
DECLARE Var_AmortizaID  	BIGINT;
DECLARE Var_PorcInteres 	DECIMAL(10,6);
DECLARE Var_InteresAcum 	DECIMAL(14,4);
DECLARE Var_RetencAcum  	DECIMAL(14,4);
DECLARE Var_NumRetMes       INT;
DECLARE Var_SucCliente  	INT;
DECLARE Var_PagaISR     	CHAR(1);
DECLARE Var_SaldoInteres    DECIMAL(14,4);
DECLARE	Var_Control			VARCHAR(30);
DECLARE Var_MonAplicar  DECIMAL(14,6);
DECLARE Var_MonRetener  DECIMAL(14,6);
DECLARE Var_FondeoIdStr VARCHAR(30);
DECLARE Aho_MovPago     VARCHAR(4);

DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12, 2);
DECLARE Decimal_Moneda  DECIMAL(12,2);
DECLARE Des_PagoInt     VARCHAR(50);
DECLARE Des_RetenInt    VARCHAR(50);
DECLARE Estatus_Pagada  CHAR(1);
DECLARE Estatus_Vigente CHAR(1);

DECLARE AltaPoliza_NO       CHAR(1);
DECLARE AltaPolKubo_SI  	CHAR(1);
DECLARE AltaMovKubo_SI  	CHAR(1);
DECLARE AltaMovAho_SI       CHAR(1);
DECLARE Nat_Cargo       	CHAR(1);
DECLARE Nat_Abono       	CHAR(1);
DECLARE Tol_DifPago     	DECIMAL(6, 4);
DECLARE Con_IntDeven        INT;
DECLARE Con_RetInt      	INT;
DECLARE Mov_IntPro      	INT;
DECLARE Mov_RetInt      	INT;
DECLARE Aho_PagIntGra       CHAR(4);
DECLARE Aho_PagIntExe       CHAR(4);
DECLARE Aho_RetInteres  	CHAR(4);
DECLARE PagaISR_SI      	CHAR(1);

DECLARE Var_FondeoCon   	INT;
DECLARE Var_NumFondeos		INT;
DECLARE StringSI        	CHAR(1);
DECLARE StringNO        	CHAR(1);
DECLARE MontoMinPago    	DECIMAL(6,4);
DECLARE SumaInteres     	DECIMAL(14,6);
DECLARE SumaISR         	DECIMAL(14,6);
DECLARE EstPendiente    	CHAR(1);
DECLARE	Proc_TipoPago		INT;

/* Asignacion de Constantes */
SET Cadena_Vacia    := '';              -- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
SET Entero_Cero     := 0;               -- Entero Cero
SET Decimal_Cero    := 0.00;            -- DECIMAL Cero
SET AltaPoliza_NO   := 'N';             -- Alta en Poliza NO
SET AltaPolKubo_SI  := 'S';             -- Alta en Poliza de Kubo NO
SET AltaMovKubo_SI  := 'S';             -- Alta en movimientos de Kubo NO
SET AltaMovAho_SI   := 'S';             -- Alta en Movimientos de Ahorro NO
SET Nat_Cargo       := 'C';             -- Naturaleza Cargo
SET Nat_Abono       := 'A';             -- Naturaleza Abono
SET Tol_DifPago     := 0.01;            -- Diferencia Maxima para realizar el Pago a inversionistas

SET Estatus_Pagada  := 'P';             -- Estatus Pagado
SET Estatus_Vigente := 'N';             -- Estatus Vigente

SET Mov_IntPro      := 10;              -- Tipo de Movimiento de Kubo Interes Ordinario
SET Mov_RetInt      := 50;              -- Tipo de Movimiento de Kubo Retencion por Interes
SET Con_RetInt      := 5;               -- Concepto Kubo retencion de intres
SET Con_IntDeven    := 8;               -- Concepto de kubo, devengamiento de interes
SET Aho_PagIntGra   := '72';            -- Movimiento de ahorro PAGO INV KUBO. INTERES GRAVADO
SET Aho_PagIntExe   := '73';            -- Movimiento de ahorro PAGO INV KUBO. INTERES EXCENTO
SET Aho_RetInteres  := '76';            -- Movimiento de ahorro RETENCION ISR INTERES INVERSION
SET PagaISR_SI      := 'S';             -- Si el cliente Paga ISR
SET Des_PagoInt     := 'PAGO DE INVERSION. INTERES';
SET Des_RetenInt    := 'PAGO DE INVERSION. ISR INT.';
SET Decimal_Moneda  := 0.01;            -- DECIMAL Moneda
SET MontoMinPago    :=0.01;             -- Monto Minimo para pagar a inversionistas
SET SumaInteres     :=0.0;              -- Suma total a pagar de Interes
SET SumaISR         :=0.0;              -- Suma total a pagar de ISR
SET EstPendiente    :='P';              -- Estatus Pendiente de aplicar
SET StringSI            :='S';
SET StringNO            :='N';
SET Proc_TipoPago       := 3;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWPAGOINTPROVPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	DELETE FROM TMPAMORTIFONCRECRW
		WHERE Transaccion = Aud_NumTransaccion;

	DELETE FROM TMPPAGOSCREDCRW
		WHERE TipoProcesoPago = Proc_TipoPago
			AND NumTransaccion	= Aud_NumTransaccion;

	SET @Consecutivo := Entero_Cero;

	INSERT INTO TMPPAGOSCREDCRW(
		TmpID,
		SolFondeoID,			ClienteID,			CuentaAhoID,			AmortizacionID,
		PorcentajeInteres,		ProvisionAcum,		RetencionIntAcum,		NumRetirosMes,
		SucursalOrigen,			PagaISR,			SaldoInteres,			NumTransaccion,
		TipoProcesoPago)
	SELECT
		(@Consecutivo:= @Consecutivo+1),
		Fon.SolFondeoID,		Fon.ClienteID,		Fon.CuentaAhoID,		Amo.AmortizacionID,
		Amo.PorcentajeInteres,	Amo.ProvisionAcum,	Amo.RetencionIntAcum,	Fon.NumRetirosMes,
		Cli.SucursalOrigen,		Cli.PagaISR,		Amo.SaldoInteres,		Aud_NumTransaccion,
		Proc_TipoPago
	FROM CRWFONDEO Fon,
		 AMORTICRWFONDEO Amo,
		 CLIENTES Cli,
		 CRWTIPOSFONDEADOR Tip
	WHERE Fon.SolFondeoID  = Amo.SolFondeoID
		AND Amo.FechaVencimiento  = Par_FechaVencim
		AND Fon.ClienteID     = Cli.ClienteID
		AND Fon.CreditoID     = Par_CreditoID
		AND Fon.TipoFondeo        = Tip.TipoFondeadorID
		AND Fon.TipoFondeo        = 1
		AND Tip.PagoEnIncumple    = 'N'
		AND Fon.Estatus           = 'N'
		AND Amo.Estatus           = 'N';


	SET Var_NumFondeos :=   (SELECT COUNT(SolFondeoID)
								FROM TMPPAGOSCREDCRW
								WHERE TipoProcesoPago = Proc_TipoPago
									AND NumTransaccion	= Aud_NumTransaccion);

	SET Var_Contador := 1;

	WHILE(Var_Contador <= Var_NumFondeos)DO
		SELECT
			SolFondeoID,		ClienteID,			CuentaAhoID,		AmortizacionID,		PorcentajeInteres,
			ProvisionAcum,		RetencionIntAcum,	NumRetirosMes,		SucursalOrigen,		PagaISR,
			SaldoInteres
		INTO
			Var_SolFondeoID,	Var_ClienteID,		Var_CuentaAhoID,	Var_AmortizaID,		Var_PorcInteres,
			Var_InteresAcum,	Var_RetencAcum,		Var_NumRetMes,		Var_SucCliente,		Var_PagaISR,
			Var_SaldoInteres
		FROM TMPPAGOSCREDCRW
			WHERE TipoProcesoPago = Proc_TipoPago
				AND NumTransaccion = Aud_NumTransaccion
				AND TmpID = Var_Contador;

		SET Var_MonAplicar  := Decimal_Cero;
		SET Var_MonRetener  := Decimal_Cero;
		SET Var_FondeoIdStr := CONVERT(Var_SolFondeoID, CHAR);
		SET SumaInteres     :=Decimal_Cero;
		SET SumaISR         :=Decimal_Cero;

		SET Var_MonAplicar  := ROUND(Par_Monto * Var_PorcInteres, 2);

		IF (Var_MonAplicar >= Var_SaldoInteres ) THEN
			SET Var_MonAplicar  := Var_SaldoInteres ;
		END IF;

		SET Var_MonRetener  := ROUND((Var_RetencAcum / Var_InteresAcum) * ROUND(Var_MonAplicar, 2), 2);

		IF (Var_MonAplicar >= MontoMinPago) THEN

			IF (Var_PagaISR = PagaISR_SI) THEN
				SET Aho_MovPago := Aho_PagIntGra;
			ELSE
				SET Aho_MovPago := Aho_PagIntExe;
			END IF;

			CALL CRWCONTAINVPRO(
				Var_SolFondeoID,		Var_AmortizaID,     Var_CuentaAhoID,    Var_ClienteID,      Par_FechaOperacion,
				Par_FechaAplicacion,    Var_MonAplicar,     Par_MonedaID,       Var_NumRetMes,      Var_SucCliente,
				Des_PagoInt,            Var_FondeoIdStr,    AltaPoliza_NO,      Entero_Cero,        Par_Poliza,
				AltaPolKubo_SI,         AltaMovKubo_SI,     Con_IntDeven,       Mov_IntPro,         Nat_Cargo,
				Nat_Abono,              AltaMovAho_SI,      Aho_MovPago,        Nat_Abono,          StringNO,
				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,    Par_Empresa,        Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Registramos la Amortizacion que se Afecta en el Pago
			-- Para Posteriormente Verificar si la marcamos como Pagada
			IF NOT EXISTS(SELECT Tem.Transaccion
							FROM TMPAMORTIFONCRECRW Tem
							WHERE Tem.Transaccion = Aud_NumTransaccion
							  AND Tem.AmortizacionID = Var_AmortizaID
							  AND Tem.SolFondeoID = Var_SolFondeoID) THEN

				INSERT INTO `TMPAMORTIFONCRECRW` (
						`Transaccion`,					`AmortizacionID`,					`SolFondeoID`)
				VALUES  (Aud_NumTransaccion, Var_AmortizaID, Var_SolFondeoID );

			END IF;
			IF NOT EXISTS(SELECT Tem.Transaccion
							FROM TMPCRWPREPAGOAMOR Tem
							WHERE Tem.Transaccion = Aud_NumTransaccion
								AND Tem.SolFondeoID = Var_SolFondeoID) THEN

					INSERT INTO `TMPCRWPREPAGOAMOR` (
                                                    `Transaccion`,                  `SolFondeoID`)
                    VALUES  (Aud_NumTransaccion, Var_SolFondeoID );
			END IF;
		END IF;


		IF (Var_MonRetener >= MontoMinPago) AND (Var_PagaISR = PagaISR_SI) THEN

			CALL CRWCONTAINVPRO(
				Var_SolFondeoID,		Var_AmortizaID,     Var_CuentaAhoID,    Var_ClienteID,      Par_FechaOperacion,
				Par_FechaAplicacion,    Var_MonRetener,     Par_MonedaID,       Var_NumRetMes,      Var_SucCliente,
				Des_RetenInt,           Var_FondeoIdStr,    AltaPoliza_NO,      Entero_Cero,        Par_Poliza,
				AltaPolKubo_SI,         AltaMovKubo_SI,     Con_RetInt,         Mov_RetInt,         Nat_Abono,
				Nat_Cargo,              AltaMovAho_SI,      Aho_RetInteres,     Nat_Cargo,          StringNO,
				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,    Par_Empresa,        Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Var_MonAplicar < MontoMinPago AND Var_MonAplicar > Decimal_Cero)THEN
			SET SumaInteres :=Var_MonAplicar;
		END IF;

		IF(Var_MonRetener < MontoMinPago AND Var_MonRetener > Decimal_Cero)THEN
			SET SumaISR :=Var_MonRetener;
		END IF;

		IF(SumaInteres > Decimal_Cero  OR SumaISR >Decimal_Cero)THEN
			INSERT INTO CRWPAGOPENINV(
				SolFondeoID,   AmortizacionID, Transaccion,    CuentaAhoID,    ClienteID,  Fecha,
				Monto,          TipoMovAhoID,   Naturaleza,     Estatus,    Retencion,
				PolizaID,       CreditoID,      EmpresaID,      Usuario,    FechaActual,
				DireccionIP,    ProgramaID,     Sucursal,       NumTransaccion)
			VALUES (
				Var_SolFondeoID,   Var_AmortizaID,     Aud_NumTransaccion, Var_CuentaAhoID,    Var_ClienteID,      Par_FechaAplicacion,
				SumaInteres,        Aho_MovPago,        Nat_Abono,          EstPendiente,       SumaISR,
				Par_Poliza,         Par_CreditoID,      Par_Empresa,        Aud_Usuario,        Aud_FechaActual,
				Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
		END IF;

		SET Var_Contador := Var_Contador + 1;
	END WHILE;

	-- Actualizamos la Amortizacion Como Pagada Si Paga Todo el Saldo de Capital e Interes
	UPDATE AMORTICRWFONDEO Amo, TMPAMORTIFONCRECRW Tem SET
		Estatus         = Estatus_Pagada,
		FechaLiquida        = Par_FechaOperacion,

		EmpresaID       = Par_Empresa,
		Usuario         = Aud_Usuario,
		FechaActual         = Aud_FechaActual,
		DireccionIP         = Aud_DireccionIP,
		ProgramaID          = Aud_ProgramaID,
		Sucursal            = Aud_Sucursal,
		NumTransaccion  = Aud_NumTransaccion

		WHERE Amo.SolFondeoID  = Tem.SolFondeoID          -- Amortizaciones que hayan Sido Afectada con el Pago
		  AND Amo.AmortizacionID = Tem.AmortizacionID
		  AND Tem.Transaccion = Aud_NumTransaccion

	   AND (IFNULL(SaldoCapVigente, Entero_Cero) +
			IFNULL(SaldoCapExigible, Entero_Cero) +
			IFNULL(SaldoInteres, Entero_Cero)+
			IFNULL(SaldoCapCtaOrden,Entero_Cero)+
			IFNULL(SaldoIntCtaOrden,Entero_Cero )+
			IFNULL(SaldoIntMoratorio,Entero_Cero)) <= Tol_DifPago;

	-- Marcamos el Fondeo como Pagado
	UPDATE CRWFONDEO Fon, TMPAMORTIFONCRECRW Tem SET
		Fon.Estatus = Estatus_Pagada
		WHERE Fon.SolFondeoID  = Tem.SolFondeoID          -- Amortizaciones que hayan Sido Afectada con el Pago
		  AND Tem.Transaccion = Aud_NumTransaccion
		  AND (SELECT COUNT(Amo.SolFondeoID)
				FROM AMORTICRWFONDEO Amo
				 WHERE Amo.SolFondeoID = Fon.SolFondeoID
				   AND Amo.SolFondeoID = Tem.SolFondeoID
				   AND Amo.Estatus = Estatus_Vigente ) <= 0;


	DELETE FROM TMPAMORTIFONCRECRW
		WHERE Transaccion = Aud_NumTransaccion;

	DELETE FROM TMPCRWPREPAGOAMOR
		WHERE Transaccion = Aud_NumTransaccion;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Proceso Terminado Exitosamente.';

END ManejoErrores;

IF (Par_Salida = StringSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_CreditoID AS Consecutivo;
END IF;

END TerminaStore$$
