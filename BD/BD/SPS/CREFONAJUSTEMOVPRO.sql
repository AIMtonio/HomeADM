-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREFONAJUSTEMOVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREFONAJUSTEMOVPRO`;DELIMITER $$

CREATE PROCEDURE `CREFONAJUSTEMOVPRO`(

    Par_InstitutFondeoID    INT,
    Par_LineaFondeoID       INT,
    Par_CreditoFondeoID     BIGINT(20),
    Par_AmortizacionID      INT,
    Par_EstatusAmortiza     CHAR(1),

    Par_SaldoInteres        DECIMAL(14,2),
    Par_SaldoMora           DECIMAL(14,2),
    Par_SaldoComFalPag      DECIMAL(14,2),
    Par_SaldoOtrasComisi    DECIMAL(14,2),
    Par_AltaEncPoliza       CHAR(1),

    Par_PolizaID            BIGINT,
    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT,
    INOUT   Par_ErrMen      VARCHAR(350),
    Par_EmpresaID           INT(11),

    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,

    Aud_NumTransaccion      BIGINT
        )
TerminaStore: BEGIN


DECLARE Var_SaldoInter      DECIMAL(14,2);
DECLARE Var_SaldoMora       DECIMAL(14,2);
DECLARE Var_SaldoComFP      DECIMAL(14,2);
DECLARE Var_SaldoOtrasCom   DECIMAL(14,2);
DECLARE Par_Consecutivo     BIGINT;

DECLARE Var_Diferencia      DECIMAL(14,2);
DECLARE Par_MonedaID        INT;
DECLARE Var_InstitucionID   INT;
DECLARE Var_NumCtaInstit    VARCHAR(100);
DECLARE Var_PlazoContable   CHAR(1);

DECLARE Var_TipoInstitID    INT;
DECLARE Var_NacionalidadIns CHAR(1);
DECLARE Var_FechaContable   DATE;
DECLARE Var_TipoFondeador   CHAR(1);
DECLARE Var_CobraISR        CHAR(1);
DECLARE Con_Egreso          INT;



DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE Fecha_Vacia         DATE;
DECLARE Salida_SI           CHAR(1);
DECLARE Salida_NO           CHAR(1);

DECLARE Var_Vigente     CHAR(1);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);

DECLARE Var_Pagado          CHAR(1);
DECLARE Var_Fecha           DATE;

DECLARE Con_EgrIntExc       INT;
DECLARE Con_EgrIntGra       INT;
DECLARE Con_IntDeven        INT;
DECLARE Con_OrdenMora       INT;
DECLARE Con_CorreMora       INT;
DECLARE Con_OrdenComFPag    INT;
DECLARE Con_CorreComFPag    INT;


DECLARE Var_ConCon          INT;
DECLARE Var_DescMov         VARCHAR(50);

DECLARE Cadena_Vacia        CHAR(1);
DECLARE Var_Si              CHAR(1);
DECLARE Var_No              CHAR(1);
DECLARE InterVig            INT;
DECLARE InterAtra           INT;

DECLARE NO_CobraISR     CHAR(1);
DECLARE SI_CobraISR     CHAR(1);

DECLARE SaldMora            INT;
DECLARE SaldComFalPag       INT;


SET Entero_Cero             := 0;
SET Salida_SI               := 'S';
SET Salida_NO               := 'N';
SET Decimal_Cero            := 0.00;
SET Fecha_Vacia             := '1900-01-01';

SET Var_Vigente         := 'N';
SET Nat_Cargo           := 'C';
SET Nat_Abono           := 'A';
SET Var_Pagado          := 'P';
SET Par_Consecutivo     := 0;

SET Con_EgrIntExc       := 3;
SET Con_EgrIntGra       := 4;
SET Con_IntDeven        := 8;
SET Con_OrdenMora       := 13;
SET Con_CorreMora       := 14;
SET Con_OrdenComFPag    := 15;
SET Con_CorreComFPag    := 16;

SET Var_ConCon              := 25;
SET Var_DescMov             := 'CONDONACION CARTERA PASIVA';

SET Cadena_Vacia            := '';
SET Var_Si                  := 'S';
SET Var_No                  := 'N';
SET InterVig                := 10;
SET InterAtra               := 11;

SET SaldMora                := 15;
SET SaldComFalPag           := 40;

SET NO_CobraISR     := 'N';
SET SI_CobraISR     := 'S';


IF(IFNULL(Par_InstitutFondeoID,Entero_Cero)) = Entero_Cero THEN
    IF (Par_Salida = Salida_SI) THEN
        SELECT '001' AS NumErr,
             'La Institucion de Fondeo esta Vacia.' AS ErrMen,
             'institutFondID' AS control,
                0 AS consecutivo;
    ELSE
        SET Par_NumErr:=    1;
        SET Par_ErrMen:=    'La Institucion de Fondeo esta Vacia.';
    END IF;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_LineaFondeoID,Entero_Cero)) = Entero_Cero THEN
    IF (Par_Salida = Salida_SI) THEN
        SELECT '001' AS NumErr,
             'La Linea de Fondeo esta Vacia.' AS ErrMen,
             'lineaFondeoID' AS control,
                0 AS consecutivo;
    ELSE
        SET Par_NumErr:=    1;
        SET Par_ErrMen:=    'La Linea de Fondeo esta Vacia.';
    END IF;
    LEAVE TerminaStore;
END IF;


SELECT FechaSistema INTO Var_Fecha
         FROM PARAMETROSSIS;

SELECT  (SaldoInteresAtra + SaldoInteresPro),   SaldoMoratorios,    SaldoComFaltaPa,    SaldoOtrasComis
 INTO   Var_SaldoInter,                         Var_SaldoMora,      Var_SaldoComFP,     Var_SaldoOtrasCom
    FROM AMORTIZAFONDEO
    WHERE   CreditoFondeoID = Par_CreditoFondeoID
    AND     AmortizacionID = Par_AmortizacionID
    AND     FechaInicio < Var_Fecha
    AND     Estatus != Var_Pagado;

SELECT  MonedaID,           InstitucionID,  NumCtaInstit,   PlazoContable,  TipoInstitID,
        NacionalidadIns,    FechaContable,  TipoFondeador,  CobraISR
        INTO
        Par_MonedaID,           Var_InstitucionID,  Var_NumCtaInstit,   Var_PlazoContable,  Var_TipoInstitID,
        Var_NacionalidadIns,    Var_FechaContable,  Var_TipoFondeador,  Var_CobraISR
    FROM CREDITOFONDEO
    WHERE CreditoFondeoID = Par_CreditoFondeoID;

SET Var_TipoFondeador   := IFNULL(Var_TipoFondeador, Cadena_Vacia);
SET Var_CobraISR        := IFNULL(Var_CobraISR, NO_CobraISR);


IF (Var_CobraISR = No_CobraISR) THEN
    SET Con_Egreso := Con_EgrIntExc;
ELSE
    SET Con_Egreso := Con_EgrIntGra;
END IF;



IF (Var_SaldoInter < Par_SaldoInteres) THEN

    SET Var_Diferencia :=   Par_SaldoInteres - Var_SaldoInter;

    CALL CONTAFONDEOPRO(
        Par_MonedaID,               Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,           Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,        Con_Egreso,             Var_DescMov,            Var_Fecha,
        Var_FechaContable,          Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                     Var_ConCon,             Nat_Cargo,              Cadena_Vacia,
        Nat_Cargo,                  Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_Si,                     Par_AmortizacionID,     InterVig,               Var_Si,
        Var_TipoFondeador,          Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,                 Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,            Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion  );

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;

    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_IntDeven,           Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Abono,              Cadena_Vacia,
        Cadena_Vacia,           Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_No,                 Par_AmortizacionID,     InterVig,               Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion);

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;

 END IF;

IF (Var_SaldoInter > Par_SaldoInteres) THEN

    SET Var_Diferencia :=   Var_SaldoInter - Par_SaldoInteres;

    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_Egreso,             Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Abono,              Cadena_Vacia,
        Nat_Abono,              Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_Si,                 Par_AmortizacionID,     InterVig,               Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion);

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;


    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_IntDeven,           Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Cargo,              Cadena_Vacia,
        Cadena_Vacia,           Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_No,                 Par_AmortizacionID,     InterVig,               Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion  );

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;

END IF;


IF (Var_SaldoMora < Par_SaldoMora) THEN

    SET Var_Diferencia :=   Par_SaldoMora - Var_SaldoMora ;


    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_OrdenMora,          Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Cargo,              Cadena_Vacia,
        Nat_Cargo,              Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_Si,                 Par_AmortizacionID,     SaldMora,               Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion);

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;


    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_CorreMora,          Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Abono,              Cadena_Vacia,
        Cadena_Vacia,           Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_No,                 Par_AmortizacionID,     SaldMora,               Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion  );

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;
 END IF;

IF (Var_SaldoMora > Par_SaldoMora) THEN
    SET Var_Diferencia :=   Var_SaldoMora - Par_SaldoMora;

    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_OrdenMora,          Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Abono,              Cadena_Vacia,
        Nat_Abono,              Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_Si,                 Par_AmortizacionID,     SaldMora,               Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion  );

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;


    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_CorreMora,          Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Cargo,              Cadena_Vacia,
        Cadena_Vacia,           Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_No,                 Par_AmortizacionID,     SaldMora,               Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion  );

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;

END IF;


IF (Var_SaldoComFP < Par_SaldoComFalPag) THEN

    SET Var_Diferencia :=   Par_SaldoComFalPag - Var_SaldoComFP ;


    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_OrdenComFPag,       Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Cargo,              Cadena_Vacia,
        Nat_Cargo,              Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_Si,                 Par_AmortizacionID,     SaldComFalPag,          Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion  );

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;


    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_CorreComFPag,       Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Abono,              Cadena_Vacia,
        Cadena_Vacia,           Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_No,                 Par_AmortizacionID,     SaldComFalPag,          Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion  );

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;

END IF;

IF (Var_SaldoComFP > Par_SaldoComFalPag) THEN
    SET Var_Diferencia :=   Var_SaldoComFP - Par_SaldoComFalPag ;

    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_OrdenComFPag,       Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Abono,              Cadena_Vacia,
        Nat_Abono,              Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_Si,                 Par_AmortizacionID,     SaldComFalPag,          Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion  );

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;

    CALL CONTAFONDEOPRO(
        Par_MonedaID,           Par_LineaFondeoID,      Par_InstitutFondeoID,   Var_InstitucionID,
        Var_NumCtaInstit,       Par_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,
        Var_NacionalidadIns,    Con_CorreComFPag,       Var_DescMov,            Var_Fecha,
        Var_FechaContable,      Var_Fecha,              Var_Diferencia,
        CONVERT(Par_AmortizacionID,CHAR),   CONVERT(Par_Par_CreditoFondeoID,CHAR),
        Var_No,                 Var_ConCon,             Nat_Cargo,              Cadena_Vacia,
        Cadena_Vacia,           Cadena_Vacia,           Var_No,                 Cadena_Vacia,
        Var_No,                 Par_AmortizacionID,     SaldComFalPag,          Var_Si,
        Var_TipoFondeador,      Par_Salida,             Par_PolizaID,           Par_Consecutivo,
        Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion  );

    IF(Par_NumErr != Entero_Cero) THEN
        LEAVE TerminaStore;
    END IF;
END IF;

SET Par_NumErr := 0;
SET Par_ErrMen := CONCAT('Ajuste de Movimientos Realizado.');

SELECT  000,
        'Ajuste de Movimientos Realizado.',
        Entero_Cero,
        Entero_Cero;

END TerminaStore$$