-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPAGCREPRO`;
DELIMITER $$

CREATE PROCEDURE `DETALLEPAGCREPRO`(
    Par_AmortizacionID      INT(4),
    Par_CreditoID           BIGINT(12),
    Par_FechaPago           DATE,
    Par_Transaccion         BIGINT(20),
    Par_ClienteID           INT(11),
    Par_MontoPago           DECIMAL(14,4),
    Par_TipoMovCreID        INT(4),
    Par_OrigenPago          VARCHAR(2),                 -- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
    Par_Salida              CHAR(1),
OUT Par_NumErr              INT(11),
OUT Par_ErrMen              VARCHAR(400),
    Par_ModoPago            CHAR(1),
    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Transaccion     BIGINT;
DECLARE Var_MontoCapOrd     DECIMAL(12,2);
DECLARE Var_MontoCapAtr     DECIMAL(12,2);
DECLARE Var_MontoCapVen     DECIMAL(12,2);
DECLARE Var_MontoIntOrd     DECIMAL(14,4);
DECLARE Var_MontoIntAtr     DECIMAL(14,4);
DECLARE Var_MontoIntVen     DECIMAL(14,4);
DECLARE Var_MontoIntMora    DECIMAL(12,2);
DECLARE Var_MontoIVA        DECIMAL(12,2);
DECLARE Var_MontoComision   DECIMAL(12,2);
DECLARE Var_MontoGasAdmon   DECIMAL(12,2);
#COMISION ANUALIDAD
DECLARE Var_MontoSeguroCuota        DECIMAL(14,2);
DECLARE Var_MontoIVASeguroCuota     DECIMAL(14,2);
#COMISION ANUALIDAD
DECLARE Var_MontoComAnual           DECIMAL(14,2);
DECLARE Var_MontoComAnualIVA        DECIMAL(14,2);
DECLARE Var_MontoNotaCargo			DECIMAL(12,2);		-- Variable por monto de nota de cargo
DECLARE Var_MontoNotaCargoIVA		DECIMAL(12,2);		-- Variable por monto de nota de cargo Iva
DECLARE Var_MontoComServGar         DECIMAL(14,2);  -- Monto Comision por Servicio de Garantia Agro
DECLARE Var_MontoIvaComServGar      DECIMAL(14,2);  -- Monto Iva Comision por Servicio de Garantia Agro
/*
RQN 31_FMEX_0031_ConfiguraciónAccesoriosPorConvenio
Fecha de ajuste: 24-07-2020
Dev: RLA
Desc: vVariables para considerar el IVA de las comisiones, importe e IVA de accesorios
*/
DECLARE Var_MontoIVAComision        DECIMAL(14,2);
DECLARE Var_MontoAccesorios         DECIMAL(14,2);
DECLARE Var_MontoIVAAccesorios      DECIMAL(14,2);
DECLARE Var_MontoIntAccesorios		DECIMAL(14,2);
DECLARE Var_MontoIVAIntAccesor		DECIMAL(14,2);

-- Declaracion de Constantes
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE Salida_SI           CHAR(1);
DECLARE Mov_CapOrd          INT;
DECLARE Mov_CapAtr          INT;
DECLARE Mov_CapVen          INT;
DECLARE Mov_CapVNE          INT;
DECLARE Mov_IntOrd          INT;
DECLARE Mov_IntAtr          INT;
DECLARE Mov_IntVen          INT;
DECLARE Mov_IntPro          INT;
DECLARE Mov_IntCalNoCon     INT;
DECLARE Mov_IntMor          INT;
DECLARE Mov_IVAInt          INT;
DECLARE Mov_IVAMor          INT;
DECLARE Mov_IVAFalPag       INT;
DECLARE Mov_IVAComApe       INT;
DECLARE Mov_ComFalPag       INT;
DECLARE Mov_ComApeCre       INT;
DECLARE Mov_ComLiqAnt       INT;
DECLARE Mov_IVAComLiqAnt    INT;
DECLARE Mov_IntMoratoVen    INT;
DECLARE Mov_IntMoraCarVen   INT;
DECLARE Mov_SeguroCuota     INT;
DECLARE Mov_IVASegCuota     INT;
#COMISION ANUALIDAD
DECLARE Mov_ComAnual        INT;
DECLARE Mov_ComAnualIVA     INT;

DECLARE Mov_OtrasComisiones INT(11);
DECLARE Mov_IVAOtrasComisiones  INT(11);

DECLARE	Mov_NotaCargoConIVA		INT(11);		-- Movimiento de credito por Nota de Cargo con iva
DECLARE	Mov_NotaCargoSinIVA		INT(11);		-- Movimiento de credito por Nota de Cargo sin iva
DECLARE	Mov_NotaCargoNoRecon	INT(11);		-- Movimiento de credito por Nota de Cargo no reconocido
DECLARE	Mov_IVANotaCargo		INT(11);		-- Movimiento de credito por Nota de Cargo IVA
DECLARE Mov_ComSerGarantia      INT(11);        -- Movimiento de credito por Comision de Servicio de Garantia
DECLARE Mov_IVAComSerGarantia   INT(11);        -- Movimiento de credito por IVA Comision de Servicio de Garantia
DECLARE Var_TipoMovIntAcc		INT(11);		-- Tipo de movimiento de credito Interes Accesorios
DECLARE Var_TipoMovIvaIntAc		INT(11);		-- Tipo de movimiento de credito Iva Interes Accesorios

-- Asignacion de Constantes
SET Cadena_Vacia           := '';
SET Fecha_Vacia            := '1900-01-01';
SET Entero_Cero            := 0;
SET Decimal_Cero           := 0.00;
SET Salida_SI              := 'S';

SET Mov_CapOrd             := 1;
SET Mov_CapAtr             := 2;
SET Mov_CapVen             := 3;
SET Mov_CapVNE             := 4;
SET Mov_IntOrd             := 10;
SET Mov_IntAtr             := 11;
SET Mov_IntVen             := 12;
SET Mov_IntCalNoCon        := 13;
SET Mov_IntPro             := 14;
SET Mov_IntMor             := 15;
SET Mov_IVAInt             := 20;         -- IVA Interes
SET Mov_IVAMor             := 21;         -- IVA Interes Moratorio
SET Mov_IVAFalPag          := 22;         -- IVA Comision Falta Pago
SET Mov_IVAComApe          := 23;         -- IVA Comision Apertura Credito
SET Mov_ComFalPag          := 40;         -- Comision por Falta de Pago
SET Mov_ComApeCre          := 41;         -- Comision por Apertura Credito
SET Mov_ComLiqAnt           := 42;          -- Comision por Administracion: Liquidacion Anticipada
SET Mov_IVAComLiqAnt        := 24;          -- IVA Comision por Administracion: Liquidacion Anticipada
SET Mov_IntMoratoVen        := 16;          -- Tipo de Movimiento: Interes Moratorio Vencido
SET Mov_IntMoraCarVen       := 17;          -- Tipo de Movimiento: Interes Moratorio de Cartera Vencida
#SEGURO
SET Mov_SeguroCuota         := 50;          -- Tipo de Movimiento TIPOSMOVSCRE: Seguro por Cuota
SET Mov_IVASegCuota         := 25;          -- Tipo de Movimiento TIPOSMOVSCRE: IVA Seguro por Cuota
#COMISION ANUALIDAD
SET Mov_ComAnual            := 51;              -- TIPOSMOVSCRE: 51 Comision por Anualidad
SET Mov_ComAnualIVA         := 52;              -- TIPOSMOVSCRE: 52 IVA Comision por Anualidad

SET Mov_OtrasComisiones     := 43;          -- TIPOSMOVSCRE: 43 Otras Comisiones
SET Mov_IVAOtrasComisiones  := 26;      -- TIPOSMOVSCRE: 26 IVA Otras Comisiones

-- Nota de cargo
SET	Mov_NotaCargoConIVA		:= 53;		-- Movimiento de credito por Nota de Cargo con iva
SET	Mov_NotaCargoSinIVA		:= 54;		-- Movimiento de credito por Nota de Cargo sin iva
SET	Mov_NotaCargoNoRecon	:= 55;		-- Movimiento de credito por Nota de Cargo no reconocido
SET	Mov_IVANotaCargo		:= 56;		-- Movimiento de credito por Nota de Cargo IVA
SET Var_TipoMovIntAcc		:= 57;		-- Tipo de movimiento de credito Interes Accesorios
SET Var_TipoMovIvaIntAc		:= 58;		-- Tipo de movimiento de credito Iva Interes Accesorios
SET Mov_ComSerGarantia      := 59;
SET Mov_IVAComSerGarantia   := 60;

-- Inicializaciones
SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;

SET Aud_FechaActual := NOW();

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                            'esto le ocasiona. Ref: SP-DETALLEPAGCREPRO');
        END;

        SET Var_MontoCapOrd     := Decimal_Cero;
        SET Var_MontoCapAtr     := Decimal_Cero;
        SET Var_MontoCapVen     := Decimal_Cero;
        SET Var_MontoIntOrd     := Decimal_Cero;
        SET Var_MontoIntAtr     := Decimal_Cero;
        SET Var_MontoIntVen     := Decimal_Cero;
        SET Var_MontoIntMora    := Decimal_Cero;
        SET Var_MontoIVA        := Decimal_Cero;
        SET Var_MontoComision   := Decimal_Cero;
        SET Var_MontoGasAdmon   := Decimal_Cero;
        SET Var_MontoSeguroCuota := Decimal_Cero;
        SET Var_MontoIVASeguroCuota := Decimal_Cero;
        /*COMISION ANUAL*/
        SET Var_MontoComAnual       := Decimal_Cero;
        SET Var_MontoComAnualIVA    := Decimal_Cero;
        SET Var_MontoNotaCargo		:= Decimal_Cero;
        SET Var_MontoNotaCargoIVA	:= Decimal_Cero;
        SET Var_MontoComServGar     := Decimal_Cero;
        SET Var_MontoIvaComServGar  := Decimal_Cero;

        /*
        RQN 31_FMEX_0031_ConfiguraciónAccesoriosPorConvenio
        Fecha de ajuste: 24-07-2020
        Dev: RLA
        Desc: vVariable para considerar el IVA de las comisiones
        */
        SET Var_MontoIVAComision    := Decimal_Cero;
        SET Var_MontoAccesorios     := Decimal_Cero;
        SET Var_MontoIVAAccesorios  := Decimal_Cero;
		SET Var_MontoIntAccesorios	:= Entero_Cero;
		SET Var_MontoIVAIntAccesor	:= Entero_Cero;

        IF (Par_TipoMovCreID = Mov_IntOrd OR
            Par_TipoMovCreID = Mov_IntCalNoCon OR
            Par_TipoMovCreID = Mov_IntPro) THEN
            SET Var_MontoIntOrd := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_CapOrd OR
                Par_TipoMovCreID = Mov_CapVNE) THEN
            SET Var_MontoCapOrd := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_CapAtr) THEN
            SET Var_MontoCapAtr := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_CapVen) THEN
            SET Var_MontoCapVen := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_IntAtr) THEN
            SET Var_MontoIntAtr := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_IntVen) THEN
            SET Var_MontoIntVen := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_IntMor OR
                Par_TipoMovCreID = Mov_IntMoratoVen OR
                Par_TipoMovCreID = Mov_IntMoraCarVen ) THEN

            SET Var_MontoIntMora    := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_IVAInt OR
                Par_TipoMovCreID = Mov_IVAMor OR
                Par_TipoMovCreID = Mov_IVAComApe OR
                Par_TipoMovCreID = Mov_IVAFalPag OR
                Par_TipoMovCreID = Mov_IVAComLiqAnt OR
                Par_TipoMovCreID = Var_TipoMovIvaIntAc) THEN
            SET Var_MontoIVA    := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_ComFalPag OR Par_TipoMovCreID = Mov_ComApeCre ) THEN -- Se quita el movimiento (OR Par_TipoMovCreID = Mov_OtrasComisiones) para calcularlo en su propio campo
            SET Var_MontoComision   := Par_MontoPago;

        ELSEIF (Par_TipoMovCreID = Mov_ComLiqAnt) THEN
            SET Var_MontoGasAdmon   := Par_MontoPago;
        ELSEIF(Par_TipoMovCreID = Mov_SeguroCuota) THEN
            SET Var_MontoSeguroCuota := Par_MontoPago;
        ELSEIF(Par_TipoMovCreID = Mov_IVASegCuota) THEN
            SET Var_MontoIVASeguroCuota := Par_MontoPago;
        ELSEIF(Par_TipoMovCreID = Mov_ComAnual) THEN
            SET Var_MontoComAnual := Par_MontoPago;
        ELSEIF(Par_TipoMovCreID = Mov_ComAnualIVA) THEN
            SET Var_MontoComAnualIVA := Par_MontoPago;

		ELSEIF (Par_TipoMovCreID = Mov_NotaCargoConIVA OR Par_TipoMovCreID = Mov_NotaCargoSinIVA OR Par_TipoMovCreID = Mov_NotaCargoNoRecon) THEN
			SET Var_MontoNotaCargo		:= Par_MontoPago;

		ELSEIF (Par_TipoMovCreID = Mov_IVANotaCargo) THEN
			SET Var_MontoNotaCargoIVA	:= Par_MontoPago;
        ELSEIF ( Par_TipoMovCreID = Mov_ComSerGarantia ) THEN
            SET Var_MontoComServGar     := Par_MontoPago;
        ELSEIF ( Par_TipoMovCreID = Mov_IVAComSerGarantia ) THEN
            SET Var_MontoIvaComServGar  := Par_MontoPago;
		END IF;

        /* RQN 31_FMEX_0031_ConfiguraciónAccesoriosPorConvenio
           Fecha de ajuste: 24-07-2020
           Dev: RLA
           Desc: Acumula los IVAs de las comisiones en el campo IVA_Comision
            Mov_IVAFalPag           22; -- IVA Comision Falta Pago
            Mov_IVAComApe           23; -- IVA Comision Apertura Credito
            Mov_IVAComLiqAnt        24; -- IVA Comision por Administracion: Liquidacion Anticipada.
                                    (El IVA de "MontoGastoAdmon" Se incluye a la suma del IVA del campo  "MontoIVAComision"
                                    ya que el campo "MontoGastoAdmon" no tiene campo de IVA. )
        */
        IF (Par_TipoMovCreID = Mov_IVAFalPag OR
                Par_TipoMovCreID = Mov_IVAComApe OR
                Par_TipoMovCreID = Mov_IVAComLiqAnt )THEN
            SET Var_MontoIVAComision    := Par_MontoPago;
        END IF;

        /* RQN 31_FMEX_0031_ConfiguraciónAccesoriosPorConvenio
           Fecha de ajuste: 24-07-2020
           Dev: RLA
           Desc: >Pobla el importe de los accesorios en el campo  MontoAccesorios
            Mov_OtrasComisiones 43 Otras Comisiones
            (Aunque ya se incluye en el campo MontoComision, se debe separar para utilizarlo en otros procesos)
        */
        IF (Par_TipoMovCreID = Mov_OtrasComisiones) THEN
            SET Var_MontoAccesorios    := Par_MontoPago;
        END IF;

        /* RQN 31_FMEX_0031_ConfiguraciónAccesoriosPorConvenio
           Fecha de ajuste: 24-07-2020
           Dev: RLA
           Desc: Acumula el IVA de los accesorios el campo MontoIVAAccesorios
            Mov_IVAOtrasComisiones: 26 IVA Otras Comisiones
        */
        IF (Par_TipoMovCreID = Mov_IVAOtrasComisiones ) THEN
            SET Var_MontoIVAAccesorios    := Par_MontoPago;
        END IF;

		IF (Par_TipoMovCreID = Var_TipoMovIntAcc) THEN
			SET Var_MontoIntAccesorios		:= Par_MontoPago;
		END IF;

		IF (Par_TipoMovCreID = Var_TipoMovIvaIntAc) THEN
			SET Var_MontoIVAIntAccesor		:= Par_MontoPago;
		END IF;

        SELECT  Transaccion INTO Var_Transaccion
            FROM DETALLEPAGCRE
            WHERE AmortizacionID    = Par_AmortizacionID
              AND CreditoID         = Par_CreditoID
              AND FechaPago         = Par_FechaPago
              AND Transaccion       = Par_Transaccion;

        SET Var_Transaccion := IFNULL(Var_Transaccion, Entero_Cero);
        SET Par_OrigenPago := IFNULL(Par_OrigenPago, Cadena_Vacia);

        IF (Var_Transaccion = Entero_Cero) THEN
            /*
                31_FMEX_0031_ConfiguraciónAccesoriosPorConvenio
                Fecha de ajuste: 24-07-2020
                Dev: RLA
                Desc:Se agregan los campos: MontoIVAComision, MontoAccesorios, MontoIVAAccesorios.
            */
            INSERT INTO DETALLEPAGCRE(
				AmortizacionID,		    CreditoID,			    FechaPago,				Transaccion,			     ClienteID,
				MontoTotPago,		    MontoCapOrd,		    MontoCapAtr,			MontoCapVen,			     MontoIntOrd,
				MontoIntAtr,		    MontoIntVen,		    MontoIntMora,			MontoIVA,				     MontoComision,
				MontoGastoAdmon,	    FormaPago,			    MontoSeguroCuota,		MontoIVASeguroCuota,	     MontoComAnual,
				MontoComAnualIVA,	    MontoIVAComision,	    MontoAccesorios,		MontoIVAAccesorios,		     MontoNotasCargo,
				MontoIVANotasCargo,	    OrigenPago,			    MontoComServGar,        MontoIvaComServGar,
				MontoIntAccesorios,		MontoIVAIntAccesorios,
                EmpresaID,			    Usuario,			    FechaActual,	       	DireccionIP,		         ProgramaID,
                Sucursal,				NumTransaccion)
			VALUES(
				Par_AmortizacionID,		Par_CreditoID,			Par_FechaPago,			Par_Transaccion,			 Par_ClienteID,
				Par_MontoPago,			Var_MontoCapOrd,		Var_MontoCapAtr,		Var_MontoCapVen,			 Var_MontoIntOrd,
				Var_MontoIntAtr,		Var_MontoIntVen,		Var_MontoIntMora,		Var_MontoIVA,				 Var_MontoComision,
				Var_MontoGasAdmon,		Par_ModoPago,			Var_MontoSeguroCuota,	Var_MontoIVASeguroCuota,	 Var_MontoComAnual,
				Var_MontoComAnualIVA,	Var_MontoIVAComision,	Var_MontoAccesorios,	Var_MontoIVAAccesorios,		 Var_MontoNotaCargo,
				Var_MontoNotaCargoIVA,	Par_OrigenPago,			Var_MontoComServGar,    Var_MontoIvaComServGar,
				Var_MontoIntAccesorios,	Var_MontoIVAIntAccesor,
                Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,        Aud_DireccionIP,		     Aud_ProgramaID,
            	Aud_Sucursal,			Aud_NumTransaccion);
        ELSE
            UPDATE DETALLEPAGCRE SET
                MontoTotPago        = MontoTotPago          + Par_MontoPago,
                MontoCapOrd         = MontoCapOrd           + Var_MontoCapOrd,
                MontoCapAtr         = MontoCapAtr           + Var_MontoCapAtr,
                MontoCapVen         = MontoCapVen           + Var_MontoCapVen,
                MontoIntOrd         = MontoIntOrd           + Var_MontoIntOrd,
                MontoIntAtr         = MontoIntAtr           + Var_MontoIntAtr,
                MontoIntVen         = MontoIntVen           + Var_MontoIntVen,
                MontoIntMora        = MontoIntMora          + Var_MontoIntMora,
                MontoIVA            = MontoIVA              + Var_MontoIVA,
                MontoComision       = MontoComision         + Var_MontoComision,
                MontoGastoAdmon     = MontoGastoAdmon       + Var_MontoGasAdmon,
                MontoSeguroCuota    = MontoSeguroCuota      + Var_MontoSeguroCuota,
                MontoIVASeguroCuota = MontoIVASeguroCuota   + Var_MontoIVASeguroCuota,
                MontoComAnual       = MontoComAnual         + Var_MontoComAnual,
                MontoComAnualIVA    = MontoComAnualIVA      + Var_MontoComAnualIVA,
                MontoIVAComision    = MontoIVAComision      + Var_MontoIVAComision,
                MontoAccesorios     = MontoAccesorios       + Var_MontoAccesorios,
                MontoIVAAccesorios  = MontoIVAAccesorios    + Var_MontoIVAAccesorios,
                MontoNotasCargo     = MontoNotasCargo       + Var_MontoNotaCargo,
                MontoIVANotasCargo  = MontoIVANotasCargo    + Var_MontoNotaCargoIVA,
                MontoIntAccesorios	= MontoIntAccesorios	+ Var_MontoIntAccesorios,
                MontoIVAIntAccesorios	= MontoIVAIntAccesorios + Var_MontoIVAIntAccesor,
                MontoComServGar     = MontoComServGar       + Var_MontoComServGar,
                MontoIvaComServGar  = MontoIvaComServGar    + Var_MontoIvaComServGar,
                OrigenPago          = Par_OrigenPago,

                EmpresaID       = Aud_EmpresaID,
                Usuario         = Aud_Usuario,
                FechaActual     = Aud_FechaActual,
                DireccionIP     = Aud_DireccionIP,
                ProgramaID      = Aud_ProgramaID,
                Sucursal        = Aud_Sucursal,
                NumTransaccion  = Aud_NumTransaccion
            WHERE AmortizacionID    = Par_AmortizacionID
              AND CreditoID         = Par_CreditoID
              AND FechaPago         = Par_FechaPago
              AND Transaccion       = Par_Transaccion;
        END IF;

END;

 IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
            Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$