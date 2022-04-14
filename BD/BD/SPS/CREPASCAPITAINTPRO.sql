-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPASCAPITAINTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPASCAPITAINTPRO`;
DELIMITER $$


CREATE PROCEDURE `CREPASCAPITAINTPRO`(

    Par_Fecha           DATE,
    Par_EmpresaID       INT,

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)

TERMINASTORE: BEGIN

/* Declaracion de Variables */
DECLARE Var_CreditoFondeoID BIGINT(20);		    -- Variables para el Cursor
DECLARE Var_InstitutFondID  INT(11);
DECLARE Var_PlazoContable   CHAR(1);
DECLARE Var_TipoInstitID    INT(11);
DECLARE Var_NacionalidadIns	CHAR(1);
DECLARE Var_AmortizacionID	INT;
DECLARE Var_SaldoIntPro     DECIMAL(14,4);
DECLARE Var_Retencion       DECIMAL(12,2);
DECLARE Var_MonedaID        INT;
DECLARE Var_LineaFondeoID   INT;
DECLARE Var_NumAmortInte    INT;
DECLARE Var_TipoFondeador   CHAR(1);


DECLARE Var_FecApl          DATE;
DECLARE Var_EsHabil         CHAR(1);
DECLARE Var_ContadorCre		INT;
DECLARE Var_Poliza          BIGINT;
DECLARE Error_Key           INT;
DECLARE Var_CreditoStr		VARCHAR(30);
DECLARE Var_Consecutivo     BIGINT;
DECLARE Var_NumErr          INT(11);
DECLARE Var_ErrMen          VARCHAR(400);
DECLARE Var_TotCapitaliza   DECIMAL(14,4);

/* Declaracion de Constantes */
DECLARE Entero_Cero     INT;
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Est_Vigente     CHAR(1);
DECLARE Est_Pagada      CHAR(1);
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE SI_Capitaliza   CHAR(1);
DECLARE Pol_Automatica  CHAR(1);
DECLARE Con_CapIntere   INT(11);
DECLARE Var_SalidaNO    CHAR(1);
DECLARE Pro_CapIntere   INT;
DECLARE Con_Capital     INT;
DECLARE Con_IntProvis   INT;
DECLARE Con_IntReten    INT;
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE AltaMovCre_SI   CHAR(1);
DECLARE AltaMovCre_NO   CHAR(1);
DECLARE AltaMovTes_NO   CHAR(1);
DECLARE Mov_Capital     INT;
DECLARE Mov_IntProvis   INT;
DECLARE Mov_Retencion   INT;
DECLARE Alta_ConFonSI   CHAR(1);

DECLARE Ref_Poliza      VARCHAR(50);
DECLARE Des_IntDev      VARCHAR(50);
DECLARE Des_Retencion   VARCHAR(50);
DECLARE Des_CapIntere   VARCHAR(50);
DECLARE Ref_CieDiaPas   VARCHAR(50);


-- Cursor para los Creditos Pasivos que Capitalizan Interes
DECLARE CURSORCAPITA CURSOR FOR
    SELECT Cre.CreditoFondeoID, Cre.InstitutFondID, Cre.PlazoContable,      Cre.TipoInstitID,
           Cre.NacionalidadIns, Amo.AmortizacionID, Amo.SaldoInteresPro,    Amo.Retencion,
           Cre.MonedaID,        Cre.LineaFondeoID,  Cre.NumAmortInteres,    Cre.TipoFondeador

		FROM	AMORTIZAFONDEO Amo,
				CREDITOFONDEO Cre
		WHERE Amo.CreditoFondeoID	= Cre.CreditoFondeoID
        AND Cre.CapitalizaInteres = SI_Capitaliza
		  AND Amo.FechaExigible	=  Par_Fecha
        AND Amo.AmortizacionID != Cre.NumAmortInteres       -- Que no sea la ultima Cuota
		  AND (	Amo.Estatus			=  Est_Vigente	)
		  AND (	Cre.Estatus			=  Est_Vigente	);

/* Asignacion de Constantes */
SET Entero_Cero     := 0;				-- Entero en Cero
SET Cadena_Vacia    := '';				-- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';	-- Fecha Vacia
SET Est_Vigente     := 'N';				-- Estatus Amortizacion: Vigente
SET Est_Pagada      := 'P';				-- Estatus Amortizacion: Pagada
SET Nat_Cargo       := 'C';				-- Naturaleza de Cargo
SET Nat_Abono       := 'A';				-- Naturaleza de Abono
SET SI_Capitaliza   := 'S';				-- Si Capitaliza Interes
SET Pol_Automatica  := 'A';				-- Tipo de Poliza: Automatica
SET Con_CapIntere   := 27;				-- Concepto Contable: Capitalizacion de Interes. Tabla:CONCEPTOSCONTA
SET Var_SalidaNO    := 'N';          -- El store no Arroja una Salida
SET Pro_CapIntere   := 306;          -- Proceso Batch: Capitalizacion de Interes. Tabla: PROCESOSBATCH
SET Con_Capital     := 1;			   -- Concepto Contable: Capitak. Tabla: CONCEPTOSFONDEO
SET Con_IntProvis   := 8;			   -- Concepto Contable: Interes Provisionado. Tabla: CONCEPTOSFONDEO
SET Con_IntReten    := 19;          -- Pasivo. Concepto Contable: Interes Retener (ISR). Tabla: CONCEPTOSFONDEO

SET AltaPoliza_NO   := 'N';         -- Alta del Encabezado de la Poliza:NO
SET AltaMovCre_SI   := 'S';         -- Alta del Movimiento de Credito-Fondeo:SI
SET AltaMovCre_NO   := 'N';         -- Alta del Movimiento de Credito-Fondeo:NO
SET AltaMovTes_NO   := 'N';         -- Alta del Movimiento de Tesoreria:NO
SET Mov_Capital     := 1;           -- Movimiento Operativo de Credito: Capital. Tabla - TIPOSMOVSFONDEO
SET Mov_IntProvis   := 10;          -- Movimiento Operativo de Credito: Interes Provisionado. Tabla - TIPOSMOVSFONDEO
SET Mov_Retencion   := 30;          -- Movimiento de RETENCION; tabla - TIPOSMOVSFONDEO

SET Alta_ConFonSI   := 'S';         -- Alta de la Contabilidad del Fondeo:SI

SET Ref_Poliza      := 'CAPITALIZACION INTERES. FONDEO';
SET Des_IntDev      := 'INTERES DEVENGADO';
SET Des_Retencion   := 'RETENCION';
SET Des_CapIntere   := 'CAPITALIZACION INTERES';
SET Ref_CieDiaPas   := 'CIERRE DIA PASIVOS';


CALL DIASFESTIVOSCAL(
    Par_Fecha,      Entero_Cero,        Var_FecApl,         Var_EsHabil,    Par_EmpresaID,
    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
    Aud_NumTransaccion);


SELECT COUNT(Cre.CreditoFondeoID) INTO Var_ContadorCre
    FROM	AMORTIZAFONDEO Amo,
            CREDITOFONDEO Cre
    WHERE Amo.CreditoFondeoID	= Cre.CreditoFondeoID
    AND Cre.CapitalizaInteres = SI_Capitaliza
      AND Amo.FechaExigible	=  Par_Fecha
    AND Amo.AmortizacionID != Cre.NumAmortInteres       -- Que no sea la ultima Cuota
      AND (	Amo.Estatus			=  Est_Vigente	)
      AND (	Cre.Estatus			=  Est_Vigente	);

SET Var_ContadorCre := IFNULL(Var_ContadorCre, Entero_Cero);

IF (Var_ContadorCre > Entero_Cero) THEN /* Si hay creditos que entren en las condiciones*/

    /* Se da de alta el encabezado de la poliza */
	 CALL MAESTROPOLIZAALT(
        Var_Poliza,     Par_EmpresaID,  Var_FecApl,         Pol_Automatica,     Con_CapIntere,
        Ref_Poliza,     Var_SalidaNO,   Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
END IF;

DELETE FROM TMPAMORTICRE
    WHERE Transaccion = Aud_NumTransaccion;

OPEN CURSORCAPITA;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP
	FETCH CURSORCAPITA INTO
        Var_CreditoFondeoID,    Var_InstitutFondID, Var_PlazoContable,  Var_TipoInstitID,   Var_NacionalidadIns,
        Var_AmortizacionID,     Var_SaldoIntPro,    Var_Retencion,      Var_MonedaID,       Var_LineaFondeoID,
        Var_NumAmortInte,       Var_TipoFondeador;

	START TRANSACTION;
	BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
	DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
	DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
	DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

	-- Inicalizacion
    SET Error_Key       := Entero_Cero;
    SET Var_Consecutivo := Entero_Cero;
    SET Var_NumErr      := Entero_Cero;
    SET Var_ErrMen      := Cadena_Vacia;
    SET Var_TotCapitaliza   := Entero_Cero;

    SET Var_SaldoIntPro := IFNULL(Var_SaldoIntPro, Entero_Cero);
    SET Var_Retencion   := IFNULL(Var_Retencion, Entero_Cero);

    SET Var_TotCapitaliza := ROUND(Var_SaldoIntPro - Var_Retencion, 2);

    SET Var_CreditoStr  := CONVERT(Var_CreditoFondeoID, CHAR);

    IF (Var_SaldoIntPro > Entero_Cero) THEN

        /* se generan los movimientos contables para Interes Devengado */
        CALL CONTAFONDEOPRO(
            Var_MonedaID,           Var_LineaFondeoID,      Var_InstitutFondID, Entero_Cero,
            Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
            Var_NacionalidadIns,    Con_IntProvis,          Des_IntDev,         Par_Fecha,
            Var_FecApl,             Var_FecApl,             Var_SaldoIntPro,    Ref_CieDiaPas,
            Var_CreditoStr,         AltaPoliza_NO,          Entero_Cero,        Nat_Cargo,
            Entero_Cero,            Nat_Abono,              Cadena_Vacia,       AltaMovTes_NO,
            Cadena_Vacia,           AltaMovCre_SI,          Var_AmortizacionID, Mov_IntProvis,
            Alta_ConFonSI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
            Var_Consecutivo,        Var_NumErr,             Var_ErrMen,         Par_EmpresaID,
            Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,           Aud_NumTransaccion  );

    END IF;

    IF (Var_Retencion > Entero_Cero) THEN

        /* se generan los movimientos contables por la Retencion */
        CALL CONTAFONDEOPRO(
            Var_MonedaID,           Var_LineaFondeoID,      Var_InstitutFondID, Entero_Cero,
            Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
            Var_NacionalidadIns,    Con_IntReten,           Des_Retencion,      Par_Fecha,
            Var_FecApl,             Var_FecApl,             Var_Retencion,      Ref_CieDiaPas,
            Var_CreditoStr,         AltaPoliza_NO,          Entero_Cero,        Nat_Abono,
            Entero_Cero,            Nat_Cargo,              Cadena_Vacia,       AltaMovTes_NO,
            Cadena_Vacia,           AltaMovCre_SI,          Var_AmortizacionID, Mov_Retencion,
            Alta_ConFonSI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
            Var_Consecutivo,        Var_NumErr,             Var_ErrMen,         Par_EmpresaID,
            Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,           Aud_NumTransaccion  );

    END IF;


    IF (Var_TotCapitaliza > Entero_Cero) THEN

        /* Se generan los movimientos contables por la Capitalizacion */
        CALL CONTAFONDEOPRO(
            Var_MonedaID,           Var_LineaFondeoID,      Var_InstitutFondID, Entero_Cero,
            Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
            Var_NacionalidadIns,    Con_Capital,            Des_CapIntere,      Par_Fecha,
            Var_FecApl,             Var_FecApl,             Var_TotCapitaliza,  Ref_CieDiaPas,
            Var_CreditoStr,         AltaPoliza_NO,          Entero_Cero,        Nat_Abono,
            Entero_Cero,            Nat_Cargo,              Cadena_Vacia,       AltaMovTes_NO,
            Cadena_Vacia,           AltaMovCre_SI,          Var_NumAmortInte,   Mov_Capital,
            Alta_ConFonSI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
            Var_Consecutivo,        Var_NumErr,             Var_ErrMen,         Par_EmpresaID,
            Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,           Aud_NumTransaccion  );

    END IF;

    -- Registramos la Amortizacion que se Afecta, para Posteriormente Verificar si la marcamos como Pagada
    IF NOT EXISTS(SELECT Tem.Transaccion
                    FROM TMPAMORTICRE Tem
                    WHERE Tem.Transaccion = Aud_NumTransaccion
                      AND Tem.AmortizacionID = Var_AmortizacionID
                      AND Tem.CreditoID = Var_CreditoFondeoID) THEN

        INSERT INTO `TMPAMORTICRE`	(
				`Transaccion`,					`AmortizacionID`,					`CreditoID`)
		VALUES(
            Aud_NumTransaccion, Var_AmortizacionID, Var_CreditoFondeoID );
    END IF;

	 END;

	 IF Error_Key = 0 THEN
	 COMMIT;
	 END IF;
	 IF Error_Key = 1 THEN
	 ROLLBACK;
	 START TRANSACTION;
		  CALL EXCEPCIONBATCHALT(
			Pro_CapIntere, 		Par_Fecha, 			Var_CreditoStr, 	'ERROR DE SQL GENERAL', 		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,					Aud_Sucursal,
			Aud_NumTransaccion);
	 COMMIT;
	 END IF;
	 IF Error_Key = 2 THEN
	 ROLLBACK;
	 START TRANSACTION;
		  CALL EXCEPCIONBATCHALT(
			Pro_CapIntere, 		Par_Fecha, 			Var_CreditoStr, 	'ERROR EN ALTA, LLAVE DUPLICADA',	Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,						Aud_Sucursal,
			Aud_NumTransaccion);
	 COMMIT;
	 END IF;
	 IF Error_Key = 3 THEN
	 ROLLBACK;
	 START TRANSACTION;
		  CALL EXCEPCIONBATCHALT(
			Pro_CapIntere, 		Par_Fecha, 			Var_CreditoStr, 	'ERROR AL LLAMAR A STORE PROCEDURE', 	Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,							Aud_Sucursal,
			Aud_NumTransaccion);
	 COMMIT;
	 END IF;
	 IF Error_Key = 4 THEN
	 ROLLBACK;
	 START TRANSACTION;
		  CALL EXCEPCIONBATCHALT(
			Pro_CapIntere, 	Par_Fecha, 			Var_CreditoStr, 	'ERROR VALORES NULOS', 		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	 Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);
	 COMMIT;
	 END IF;

	 END LOOP;
END;

CLOSE CURSORCAPITA;

IF (Var_ContadorCre > Entero_Cero) THEN /* Si hay creditos que entren en las condiciones*/
    -- Marcamos las Cuotas como Pagadas
    UPDATE AMORTIZAFONDEO Amo, TMPAMORTICRE Tem  SET
        Amo.Estatus         = Est_Pagada,
        Amo.FechaLiquida    = Par_Fecha
        WHERE Amo.Estatus 		!= Est_Pagada
		  AND Tem.Transaccion = Aud_NumTransaccion    -- Futuras que no Tienen Capital que son de Solo Interes
          AND Tem.AmortizacionID = Amo.AmortizacionID    -- Amortizaciones que hayan Sido Afectada con el Pago
          AND Tem.CreditoID = Amo.CreditoFondeoID ;      -- Para evitar Marcar Como Pagadas, aquellas Amortizaciones

END IF;

DELETE FROM TMPAMORTICRE
    WHERE Transaccion = Aud_NumTransaccion;

END TerminaStore$$
