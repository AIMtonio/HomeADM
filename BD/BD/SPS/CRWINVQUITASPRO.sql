-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWINVQUITASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWINVQUITASPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWINVQUITASPRO`(
	Par_CreditoID		BIGINT(12),
	Par_Fecha			DATE,
	Par_FechaVencCre	DATE,
	Par_MontoMoratorios DECIMAL(12,2),
    Par_PorceMoratorio	DECIMAL(12,9),
    Par_MontoInteres    DECIMAL(12,2),

    Par_PorceInteres    DECIMAL(12,9),
    Par_MontoCapital    DECIMAL(12,2),
    Par_PorceCapital    DECIMAL(12,9),
	Par_MontoIntCO    	DECIMAL(12,2),
    Par_PorceIntCO    	DECIMAL(12,9),

    Par_MontoCapCO    	DECIMAL(12,2),
    Par_PorceCapCO    	DECIMAL(12,9),
	Par_Poliza          BIGINT,
    Par_AltaPoliza      CHAR(1),
    Par_Salida          CHAR(1),

    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)
TerminaStore : BEGIN

DECLARE	Var_FechaSis		DATE;
DECLARE	Var_EstatusCre		CHAR(1);
DECLARE	Var_SaldoCapInv		DECIMAL(12,2);
DECLARE	Var_SaldoIntInv		DECIMAL(12,2);
DECLARE	Var_SaldoMoraInv	DECIMAL(12,2);
DECLARE	Var_SaldoIntCOInv	DECIMAL(12,2);
DECLARE	Var_SaldoCapCOInv	DECIMAL(12,2);
DECLARE	Var_CuentaAhoID		BIGINT(12);
DECLARE	Var_PagoCapVig		DECIMAL(12,2);
DECLARE	Var_PagoCapEx		DECIMAL(12,2);
DECLARE	Var_PagoInteres		DECIMAL(12,2);
DECLARE	Var_PagoIntMora		DECIMAL(12,2);
DECLARE	Var_PagoCapCO		DECIMAL(12,2);
DECLARE	Var_PagoIntCO		DECIMAL(12,2);
DECLARE	Var_RetirosMes		TINYINT;
DECLARE	Var_SolFondeoID		BIGINT(20);
DECLARE	Var_AmortizacionID	INT(12);
DECLARE	Var_ClienteID		INT(12);
DECLARE	Var_SaldoCapVig		DECIMAL(12,2);
DECLARE	Var_SaldoCapEx		DECIMAL(12,2);
DECLARE	Var_SaldoInteres	DECIMAL(12,2);
DECLARE	Var_SaldoIntMora	DECIMAL(12,2);
DECLARE	Var_SaldoCapCO		DECIMAL(12,2);
DECLARE	Var_SaldoIntCO		DECIMAL(12,2);
DECLARE	Var_SucOrigen		TINYINT;
DECLARE	Var_MonedaID		TINYINT;
DECLARE	Var_PagoTotal		DECIMAL(12,2);

DECLARE	Salida_SI			CHAR(1);
DECLARE	Entero_Cero			TINYINT(1);
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Decimal_Cero		DECIMAL(3,2);
DECLARE	Des_MovimientoMora	VARCHAR(50);
DECLARE	Des_MovimientoCap	VARCHAR(50);
DECLARE	Des_MovimientoInt	VARCHAR(50);
DECLARE	AltaPoliza_NO		CHAR(1);
DECLARE	AltaPolKubo_SI		CHAR(1);
DECLARE	AltaMovKubo_SI		CHAR(1);
DECLARE	AltaMovKubo_NO		CHAR(1);
DECLARE	AltaMovAho_NO		CHAR(1);
DECLARE	AltaPolKubo_NO		CHAR(1);
DECLARE	CtaOrdenMora		TINYINT;
DECLARE CorrCtaOrdenMora	TINYINT;
DECLARE	MovKuboIntMora		TINYINT;
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Par_Consecutivo		TINYINT;
DECLARE	StringNO			CHAR(1);
DECLARE	Var_DivideCastigo	CHAR(1);
DECLARE	CtaOrdenCasMora		TINYINT;
DECLARE	CorrCtaOrdenCasMora	TINYINT;
DECLARE	CtaOrdenInt			TINYINT;
DECLARE	TipoMovIntCtaOr		TINYINT;
DECLARE	TipoMovCapCtaOr		TINYINT;
DECLARE	CorrCtaOrdenInt		TINYINT;
DECLARE	CtaOrdenCap			TINYINT;
DECLARE	CorrCtaOrdenCap		TINYINT;
DECLARE	Des_Movimiento		VARCHAR(40);
DECLARE	CtaOrdenInvCast		TINYINT;
DECLARE	CorrCtaOrdenInvCast	TINYINT;
DECLARE	Estatus_Pagada		CHAR(1);
DECLARE	Estatus_Vigente		CHAR(1);

DECLARE	CURSORINVQUITA	CURSOR FOR
SELECT	FK.SolFondeoID,	AF.AmortizacionID,		FK.CuentaAhoID,		FK.ClienteID,
		AF.SaldoCapVigente,	AF.SaldoCapExigible,	AF.SaldoInteres,	AF.SaldoIntMoratorio,
		AF.SaldoCapCtaOrden,AF.SaldoIntCtaOrden,	FK.NumRetirosMes
FROM		CRWFONDEO FK
INNER JOIN	AMORTICRWFONDEO AF
	ON 		FK.SolFondeoID 	= AF.SolFondeoID
WHERE 		CreditoID			= Par_CreditoID
AND			AF.Estatus			= 'N'
AND			AF.FechaVencimiento = Par_FechaVencCre;

SET		Var_FechaSis		:= (SELECT FechaSistema FROM PARAMETROSSIS);

SET		Entero_Cero			:=	0;
SET		Cadena_Vacia		:= '';
SET		Decimal_Cero		:= 0.00;
SET		Salida_SI			:= 'S';
SET		AltaPoliza_NO		:= 'N';
SET		AltaPolKubo_SI		:= 'S';
SET		AltaPolKubo_NO		:= 'N';
SET		AltaMovKubo_SI		:= 'S';
SET		AltaMovKubo_NO		:= 'N';
SET		AltaMovAho_NO		:= 'N';
SET 	CtaOrdenMora		:= 15;	-- Cta. Orden Intereses Moratorios CONCEPTOSKUBO
SET		CorrCtaOrdenMora	:= 16;
SET 	MovKuboIntMora		:= 15;	-- Movimiento de interes moratorio TIPOSMOVSCRW
SET		Nat_Abono			:= 'A';
SET		Par_Consecutivo		:= 1;
SET		StringNO			:= 'N';
SET 	CtaOrdenCasMora		:= 21;	-- Cta. Orden Castigo Intereses Moratorios CONCEPTOSKUBO
SET 	CorrCtaOrdenCasMora	:= 22;	-- Corr Cta. Orden Castigo Intereses Moratorios CONCEPTOSKUBO
SET 	Des_MovimientoMora	:= 'CONDONACION INV. MORATORIO';
SET 	Des_MovimientoCap	:= 'CONDONACION INV. CAPITAL';
SET 	Des_MovimientoInt	:= 'CONDONACION INV. INTERES';
SET 	CtaOrdenInt			:= 13;	-- Conceptos kubo
SET 	TipoMovIntCtaOr		:= 16;	-- Movimientos kubo interes cuentas de orden
SET 	TipoMovCapCtaOr		:= 3;	-- Movimientos kubo capital cuentas de orden
SET 	CorrCtaOrdenInt		:= 14;	-- Conceptos Kubo
SET		Nat_Cargo			:= 'C';
SET 	CtaOrdenCap			:= 11;	-- Conceptos kubo
SET 	CorrCtaOrdenCap		:= 12;	-- Conceptos Kubo
SET 	Des_Movimiento		:= 'CASTIGO INV. KUBO';
SET 	CtaOrdenInvCast		:= 17;			-- Conceptos kubo
SET 	CorrCtaOrdenInvCast	:= 18;			-- Conceptos Kubo
SET		Estatus_Pagada		:= 'P';
SET		Estatus_Vigente		:= 'N';

Proceso : BEGIN


IF(Par_Fecha < Var_FechaSis)THEN
	SET	Par_NumErr	:= 101;
	SET	Par_ErrMen	:= 'La fecha es menor a la fecha del sistema. El proceso no es retroactivo.';
	LEAVE Proceso;
END IF;

SELECT	Estatus
INTO	Var_EstatusCre
FROM 	CREDITOS
WHERE 	CreditoID = Par_CreditoID;


IF Var_EstatusCre = 'K' THEN
	-- En las pantallas no se puede condonar cartera castigada.
	SET	Var_EstatusCre := Var_EstatusCre;
ELSE

	SELECT		SUM(AF.SaldoCapVigente + AF.SaldoCapExigible) SaldoCapInv,
				SUM(AF.SaldoInteres)SaldoIntInv,
				SUM(AF.SaldoIntMoratorio)SaldoMoraInv,
				SUM(AF.SaldoIntCtaOrden) SaldoIntCOInv,
				SUM(AF.SaldoCapCtaOrden) SaldoCapCOInv
		INTO	Var_SaldoCapInv, 	Var_SaldoIntInv,	Var_SaldoMoraInv,
				Var_SaldoIntCOInv,	Var_SaldoCapCOInv
	FROM 		CRWFONDEO FK
	INNER JOIN	AMORTICRWFONDEO AF
		ON 		FK.SolFondeoID = AF.SolFondeoID
	WHERE		FK.CreditoID =  Par_CreditoID
		AND		AF.Estatus = 'N';

	IF	(Var_SaldoCapInv+Var_SaldoIntInv+Var_SaldoMoraInv+Var_SaldoIntCOInv+Var_SaldoCapCOInv) <= Decimal_Cero THEN
		LEAVE Proceso;
	END IF;
END IF;

DELETE FROM TMPAMORTIFONCRECRW
    WHERE Transaccion = Aud_NumTransaccion;


OPEN CURSORINVQUITA;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	CICLO: LOOP
		FETCH	CURSORINVQUITA
		INTO	Var_SolFondeoID,	Var_AmortizacionID, Var_CuentaAhoID,	Var_ClienteID,	Var_SaldoCapVig,
				Var_SaldoCapEx,		Var_SaldoInteres,	Var_SaldoIntMora,	Var_SaldoCapCO,	Var_SaldoIntCO,
				Var_RetirosMes;

		SET	Var_SucOrigen		:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Var_ClienteID);
		SET	Var_MonedaID		:= (SELECT MonedaID FROM CUENTASAHO WHERE CuentaAhoID = Var_CuentaAhoID);

		SET	Var_SaldoCapVig		:= IFNULL(Var_SaldoCapVig,Decimal_Cero);
		SET	Var_SaldoCapEx		:= IFNULL(Var_SaldoCapEx,Decimal_Cero);
		SET	Var_SaldoInteres	:= IFNULL(Var_SaldoInteres,Decimal_Cero);
		SET	Var_SaldoIntMora	:= IFNULL(Var_SaldoIntMora,Decimal_Cero);
		SET	Var_SaldoCapCO		:= IFNULL(Var_SaldoCapCO,Decimal_Cero);
		SET	Var_SaldoIntCO		:= IFNULL(Var_SaldoIntCO,Decimal_Cero);

			IF Var_SaldoIntMora > Decimal_Cero AND Par_PorceMoratorio > Decimal_Cero THEN
				SET	Var_PagoIntMora	:= IFNULL(ROUND((Var_SaldoIntMora * Par_PorceMoratorio),2),Decimal_Cero);

				IF Var_PagoIntMora > Decimal_Cero THEN
				-- ----Cancelamos las Cuentas de Orden de moratorios ------
					CALL CRWCONTAINVPRO(
						Var_SolFondeoID,		Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,		Par_Fecha,
						Par_Fecha,				Var_PagoIntMora,	Var_MonedaID,		Var_RetirosMes,		Var_SucOrigen,
						Des_MovimientoMora,		Var_SolFondeoID,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
						AltaPolKubo_SI,			AltaMovKubo_SI,		CtaOrdenMora,		MovKuboIntMora,		Nat_Abono,
						Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,		Par_NumErr,
						Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,		NOW(),
						Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF Par_NumErr <> Decimal_Cero THEN
						LEAVE CICLO;
					END IF;

					CALL CRWCONTAINVPRO(
						Var_SolFondeoID,		Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,		Par_Fecha,
						Par_Fecha,				Var_PagoIntMora,	Var_MonedaID,		Var_RetirosMes,		Var_SucOrigen,
						Des_MovimientoMora,		Var_SolFondeoID,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
						AltaPolKubo_SI,			AltaMovKubo_NO,		CorrCtaOrdenMora,	Entero_Cero,		Nat_Cargo,
						Cadena_Vacia,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,		Par_NumErr,
						Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,		NOW(),
						Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF Par_NumErr <> Decimal_Cero THEN
						LEAVE CICLO;
					END IF;

				END IF;
			END IF;

			IF Var_SaldoIntCO > Decimal_Cero AND Par_PorceIntCO > Decimal_Cero THEN
				SET	Var_PagoIntCO	:= IFNULL(ROUND((Var_SaldoIntCO * Par_PorceIntCO),2),Decimal_Cero);

				IF Var_PagoIntCO > Decimal_Cero THEN
					CALL CRWCONTAINVPRO(
						Var_SolFondeoID,		Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,		Par_Fecha,
						Par_Fecha,				Var_PagoIntCO,		Var_MonedaID,		Var_RetirosMes,		Var_SucOrigen,
						Des_MovimientoInt,		Var_SolFondeoID,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
						AltaPolKubo_SI,			AltaMovKubo_SI,		CtaOrdenInt,		TipoMovIntCtaOr,	Nat_Abono,
						Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,		Par_NumErr,
						Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,		NOW(),
						Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF Par_NumErr <> Decimal_Cero THEN
						LEAVE CICLO;
					END IF;

					CALL CRWCONTAINVPRO(
						Var_SolFondeoID,		Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,		Par_Fecha,
						Par_Fecha,				Var_PagoIntCO,		Var_MonedaID,		Var_RetirosMes,		Var_SucOrigen,
						Des_MovimientoInt,		Var_SolFondeoID,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
						AltaPolKubo_SI,			AltaMovKubo_NO,		CorrCtaOrdenInt,	Entero_Cero,		Nat_Cargo,
						Cadena_Vacia,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,		Par_NumErr,
						Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,		NOW(),
						Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
					IF Par_NumErr <> Decimal_Cero THEN
						LEAVE CICLO;
					END IF;
				END IF;
			END IF;

			IF Var_SaldoCapCO > Decimal_Cero AND Par_PorceCapCO > Decimal_Cero THEN
				SET	Var_PagoCapCO	:= IFNULL(ROUND((Var_SaldoCapCO * Par_PorceCapCO),2),Decimal_Cero);

				IF Var_PagoCapCO > Decimal_Cero	THEN

					CALL CRWCONTAINVPRO(
						Var_SolFondeoID,		Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,		Par_Fecha,
						Par_Fecha,				Var_PagoCapCO,		Var_MonedaID,		Var_RetirosMes,		Var_SucOrigen,
						Des_MovimientoCap,		Var_SolFondeoID,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
						AltaPolKubo_SI,			AltaMovKubo_SI,		CtaOrdenCap,		TipoMovCapCtaOr,	Nat_Abono,
						Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,		Par_NumErr,
						Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,		NOW(),
						Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF Par_NumErr <> Decimal_Cero THEN
						LEAVE CICLO;
					END IF;

					CALL CRWCONTAINVPRO(
						Var_SolFondeoID,		Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,		Par_Fecha,
						Par_Fecha,				Var_PagoCapCO,		Var_MonedaID,		Var_RetirosMes,		Var_SucOrigen,
						Des_MovimientoCap,		Var_SolFondeoID,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
						AltaPolKubo_SI,			AltaMovKubo_NO,		CorrCtaOrdenCap,	Entero_Cero,		Nat_Cargo,
						Cadena_Vacia,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,		Par_NumErr,
						Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,		NOW(),
						Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF Par_NumErr <> Decimal_Cero THEN
						LEAVE CICLO;
					END IF;
				END IF;
			END IF;

			SET	Var_PagoIntMora :=	IFNULL(Var_PagoIntMora, Decimal_Cero);
			SET	Var_PagoCapCO 	:=	IFNULL(Var_PagoCapCO, Decimal_Cero);
			SET	Var_PagoIntCO 	:=	IFNULL(Var_PagoIntCO, Decimal_Cero);

			SET	Var_PagoTotal	:= IFNULL(Var_PagoIntMora + Var_PagoCapCO + Var_PagoIntCO,Decimal_Cero);

			IF Var_PagoTotal > Decimal_Cero THEN
				INSERT INTO CRWINVCONDONA(
					SolFondeoID,	AmortizacionID,		ClienteID,			CuentaAhoID,	CreditoID,
					FechaCondona,	SaldoCapVigente,	SaldoCapExigible,	SaldoInteres,	SaldoCapitalCO,
					SaldoInteresCO,	SaldoIntMoratorio,	EmpresaID,			Usuario,		FechaActual,
					DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion
				)VALUES(
					Var_SolFondeoID,	Var_AmortizacionID,	Var_ClienteID,	Var_CuentaAhoID,	Par_CreditoID,
					Par_Fecha,			Decimal_Cero,		Decimal_Cero,	Decimal_Cero,		Var_PagoCapCO,
					Var_PagoIntCO,		Var_PagoIntMora,	Par_EmpresaID,	Aud_Usuario,		NOW(),
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
				);

				IF NOT EXISTS(SELECT Tem.Transaccion
							FROM TMPAMORTIFONCRECRW Tem
							WHERE Tem.Transaccion = Aud_NumTransaccion
							  AND Tem.AmortizacionID = Var_AmortizacionID
							  AND Tem.SolFondeoID = Var_SolFondeoID) THEN
					INSERT INTO `TMPAMORTIFONCRECRW` (
                        `Transaccion`,                  `AmortizacionID`,                   `SolFondeoID`)
                    VALUES  (Aud_NumTransaccion, Var_AmortizacionID, Var_SolFondeoID );
				END IF;
			END IF;
		END LOOP CICLO;
	END;
CLOSE CURSORINVQUITA;

IF Par_NumErr <> Decimal_Cero THEN
	LEAVE Proceso;
END IF;

-- Actualizamos la Amortizacion Como Pagada Si Paga Todo el Saldo de Capital e Interes
UPDATE AMORTICRWFONDEO Amo, TMPAMORTIFONCRECRW Tem SET
    Estatus			= Estatus_Pagada,
    FechaLiquida	= Par_Fecha,

    EmpresaID		= Par_EmpresaID,
    Usuario			= Aud_Usuario,
    FechaActual 	= Aud_FechaActual,
    DireccionIP 	= Aud_DireccionIP,
    ProgramaID  	= Aud_ProgramaID,
    Sucursal		= Aud_Sucursal,
    NumTransaccion	= Aud_NumTransaccion

    WHERE Amo.SolFondeoID	= Tem.SolFondeoID          -- Amortizaciones que hayan Sido Afectada con el Pago
      AND Amo.AmortizacionID = Tem.AmortizacionID
      AND Tem.Transaccion = Aud_NumTransaccion

   AND (IFNULL(SaldoCapVigente, Entero_Cero) +
        IFNULL(SaldoCapExigible, Entero_Cero) +
        IFNULL(SaldoInteres, Entero_Cero)+
		IFNULL(SaldoCapCtaOrden,Entero_Cero)+
		IFNULL(SaldoIntCtaOrden,Entero_Cero )+
		IFNULL(SaldoIntMoratorio,Entero_Cero)) <= 0.01;

-- Marcamos el Fondeo como Pagado
UPDATE CRWFONDEO Fon, TMPAMORTIFONCRECRW Tem SET
    Fon.Estatus = Estatus_Pagada
    WHERE Fon.SolFondeoID	= Tem.SolFondeoID          -- Amortizaciones que hayan Sido Afectada con el Pago
      AND Tem.Transaccion 	= Aud_NumTransaccion
      AND (SELECT COUNT(Amo.SolFondeoID)
            FROM AMORTICRWFONDEO Amo
             WHERE Amo.SolFondeoID = Fon.SolFondeoID
               AND Amo.SolFondeoID = Tem.SolFondeoID
               AND Amo.Estatus = Estatus_Vigente ) <= Entero_Cero;

DELETE FROM TMPAMORTIFONCRECRW
    WHERE Transaccion = Aud_NumTransaccion;

SET	Par_NumErr	:= 0;
SET	Par_ErrMen	:= 'Quitas inversion ejecutado con exito.';

END Proceso;

IF Par_Salida = Salida_SI THEN
	SELECT	Par_NumErr NumErr,
			Par_ErrMen, ErrMen;
END IF;

END TerminaStore$$
