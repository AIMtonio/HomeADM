-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOSEGUROCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULOSEGUROCREPRO`;DELIMITER $$

CREATE PROCEDURE `CALCULOSEGUROCREPRO`(

    Par_CreditoID           BIGINT(12),
    Par_FechaInicio         DATE,
    Par_FechaVencimien      DATE,
    INOUT Par_MontoCredito  DECIMAL(12,2),
    INOUT Par_MontoSeguro   DECIMAL(12,2),

    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),
    Par_Salida              CHAR(1),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
        )
TerminaStore: BEGIN


    DECLARE Var_MontoCredito        DECIMAL(12,2);
    DECLARE Var_ReqSeguroVida       CHAR(1);
    DECLARE Var_TipoPagoSeguro      CHAR(1);
    DECLARE Var_NumDias             INT(10);
    DECLARE Var_FactorRiesgoSeguro  DECIMAL(12,6);
    DECLARE Var_ForCobroSegVida     CHAR(1);
    DECLARE Var_MontoSeguroVida     DECIMAL(12,2);
    DECLARE Var_ForCobroComAper     CHAR(1);
    DECLARE Var_MontoComApert       DECIMAL(12,2);
    DECLARE Var_IVAComApertura      DECIMAL(12,2);
    DECLARE Var_MontoSegOri         DECIMAL(12,2);
    DECLARE Var_DescSeguro          DECIMAL(12,2);
    DECLARE Var_EsqSeguroID         DECIMAL(12,2);
    DECLARE Var_Modalidad           CHAR(1);
    DECLARE Var_ProducCreID         INT(11);

    DECLARE Var_EsquemaSeguro   INT;
    DECLARE Var_ProdCredID      INT;
    DECLARE Var_TipPagSegu      CHAR(1);
    DECLARE Var_FactRiSeg       DECIMAL(12,6);
    DECLARE Var_DescSegu        DECIMAL(12,2);
    DECLARE Var_MontoPolSeg     DECIMAL(12,2);


    DECLARE CobroFinanciado     CHAR(1);
    DECLARE Var_SI              CHAR(1);
    DECLARE Decimal_Cero        DECIMAL(12,2);
    DECLARE Salida_NO           CHAR(1);
    DECLARE Salida_SI           CHAR(1);
    DECLARE ModUnico            CHAR(1);
    DECLARE ModTipPa            CHAR(1);
    DECLARE Entero_Cero         INT;
    DECLARE Cadena_Vacia        VARCHAR(50);



    SET CobroFinanciado := 'F';
    SET Var_SI          := 'S';
    SET Decimal_Cero    := 0.0;
    SET Salida_NO       := 'N';
    SET Salida_SI       := 'S';
    SET ModUnico        := 'U';
    SET ModTipPa        := 'T';
    SET Entero_Cero     :=  0;
    SET Cadena_Vacia    :=  '';


    SELECT Cre.MontoCredito,    Pro.ReqSeguroVida,      Pro.TipoPagoSeguro,         Pro.FactorRiesgoSeguro,     IVAComApertura,
           Cre.ForCobroSegVida, Cre.MontoSeguroVida,    Cre.ForCobroComAper,        Cre.MontoComApert,          Pro.DescuentoSeguro,
           Pro.EsquemaSeguroID, Pro.Modalidad,          Pro.ProducCreditoID
    INTO
           Var_MontoCredito,    Var_ReqSeguroVida,      Var_TipoPagoSeguro,         Var_FactorRiesgoSeguro,     Var_IVAComApertura,
           Var_ForCobroSegVida, Var_MontoSeguroVida,    Var_ForCobroComAper,        Var_MontoComApert,          Var_DescSeguro,
           Var_EsqSeguroID,     Var_Modalidad,          Var_ProducCreID

    FROM CREDITOS Cre
         INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
    WHERE Cre.CreditoID = Par_CreditoID;


    SET Var_MontoCredito        := IFNULL(Var_MontoCredito, Decimal_Cero);
    SET Var_FactorRiesgoSeguro  := IFNULL(Var_FactorRiesgoSeguro, Decimal_Cero);
    SET Var_IVAComApertura      := IFNULL(Var_IVAComApertura, Decimal_Cero);
    SET Var_MontoSeguroVida     := IFNULL(Var_MontoSeguroVida, Decimal_Cero);
    SET Var_MontoComApert       := IFNULL(Var_MontoComApert, Decimal_Cero);
    SET Var_DescSeguro          := IFNULL(Var_DescSeguro, Decimal_Cero);
    SET Var_EsqSeguroID         := IFNULL(Var_EsqSeguroID, Entero_Cero);

SELECT EsquemaSeguroID,     ProducCreditoID,    TipoPagoSeguro,     FactorRiesgoSeguro,     DescuentoSeguro,
       MontoPolSegVida
INTO  Var_EsquemaSeguro,    Var_ProdCredID, Var_TipPagSegu, Var_FactRiSeg, Var_DescSegu,
      Var_MontoPolSeg
FROM  ESQUEMASEGUROVIDA
      WHERE ProducCreditoID = Var_ProducCreID
      AND TipoPagoSeguro = Var_ForCobroSegVida;

SET Var_EsquemaSeguro := IFNULL(Var_EsquemaSeguro, Entero_Cero);



    IF(Var_ReqSeguroVida = Var_SI) THEN

        IF(Var_ForCobroComAper = CobroFinanciado)THEN
            SET Var_MontoCredito := Var_MontoCredito - Var_MontoComApert;
            SET Var_MontoCredito := Var_MontoCredito - Var_IVAComApertura;
        END IF;

        IF(Var_Modalidad = ModUnico)THEN


        IF(Var_ForCobroSegVida = CobroFinanciado)THEN
            SET Var_MontoCredito := Var_MontoCredito - Var_MontoSeguroVida;
        END IF;


            SET Var_NumDias := (SELECT Dias FROM CREDITOSPLAZOS CP INNER JOIN CREDITOS C
                                ON (CP.PlazoID = C.PlazoID) WHERE CreditoID = Par_CreditoID);

            SET Var_DescSeguro := (Var_DescSeguro / 100);
            SET Var_MontoSegOri := ((Var_FactorRiesgoSeguro / 7) * Var_MontoCredito * Var_NumDias );
            SET Var_MontoSeguroVida := (Var_MontoSegOri - (Var_MontoSegOri * Var_DescSeguro));

        ELSE
            IF(Var_Modalidad = ModTipPa)THEN
            IF(Var_TipPagSegu = CobroFinanciado)THEN
                SET Var_MontoCredito := Var_MontoCredito - Var_MontoSeguroVida;
            END IF;

                SET Var_NumDias := (SELECT Dias FROM CREDITOSPLAZOS CP INNER JOIN CREDITOS C
                                ON (CP.PlazoID = C.PlazoID) WHERE CreditoID = Par_CreditoID);
                SET Var_DescSegu := (Var_DescSegu / 100);
                SET Var_MontoSegOri := ((Var_FactRiSeg / 7) * Var_MontoCredito * Var_NumDias );
                SET Var_MontoSeguroVida := (Var_MontoSegOri - (Var_MontoSegOri * Var_DescSegu));
            END IF;
        END IF;



        IF(Var_EsqSeguroID = Entero_Cero)THEN
        IF(Var_TipoPagoSeguro = CobroFinanciado ) THEN
                SET Var_MontoCredito := Var_MontoCredito + Var_MontoSeguroVida;
                SET Var_ForCobroSegVida := Var_TipoPagoSeguro;
        END IF;

    ELSE


        IF(Var_TipPagSegu = CobroFinanciado) THEN
                SET Var_MontoCredito := Var_MontoCredito + Var_MontoSeguroVida;
                SET Var_ForCobroSegVida := Var_TipPagSegu;
        END IF;
        END IF;




        IF(Var_ForCobroComAper = CobroFinanciado)THEN
            SET Var_MontoCredito = Var_MontoCredito + Var_MontoComApert;
            SET Var_MontoCredito = Var_MontoCredito + Var_IVAComApertura;
        END IF;


    END IF;


    SET Par_MontoCredito    := Var_MontoCredito;
    SET Par_MontoSeguro     := Var_MontoSeguroVida;

    UPDATE CREDITOS
    SET ForCobroSegVida = Var_ForCobroSegVida,
        MontoSeguroVida = Par_MontoSeguro,
        MontoCredito    = Par_MontoCredito,

        EmpresaID       = Par_EmpresaID,
        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion
    WHERE CreditoID = Par_CreditoID;


    IF(Par_Salida = Salida_NO) THEN
            SET Par_NumErr      := 0;
            SET Par_ErrMen      := 'Monto de Seguro de Vida Calculado Exitosamente';
    END IF;
    IF(Par_Salida = Salida_SI) THEN
        SELECT  '000'    AS NumErr,
        'Monto de Seguro de Vida Calculado Exitosamente' AS ErrMen,
        'montoSeguroVida' AS control,
        0 AS consecutivo;
    END IF;


END TerminaStore$$