-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREGARLIQCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREGARLIQCON`;DELIMITER $$

CREATE PROCEDURE `CREGARLIQCON`(

    Par_CreditoID       BIGINT(12),
    Par_Salida          CHAR(1),
    INOUT montoGarLiq   DECIMAL(14,2),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),

    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Mon_Inversion   DECIMAL(14,2);



DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(14,2);
DECLARE Est_Bloq        CHAR(1);
DECLARE tipMovGL        INT;
DECLARE Salida_SI       CHAR(1);


SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.0;
SET Est_Bloq        := 'B';
SET tipMovGL        := 8;
SET Salida_SI       := 'S';


SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := '';
SET montoGarLiq := Entero_Cero;
SET Mon_Inversion := Entero_Cero;


SET montoGarLiq := IFNULL((SELECT SUM(MontoBloq)
                            FROM    BLOQUEOS
                            WHERE   TiposBloqID = tipMovGL
                            AND Referencia  = Par_CreditoID
                            AND NatMovimiento = Est_Bloq
                            AND IFNULL(FolioBloq,Entero_Cero) = Entero_Cero),Decimal_Cero);

SET montoGarLiq := IFNULL(montoGarLiq, Entero_Cero);


SELECT SUM(Inc.MontoEnGar) INTO Mon_Inversion
    FROM CREDITOINVGAR Inc,
         INVERSIONES Inv
    WHERE Inc.CreditoID = Par_CreditoID
      AND Inc.InversionID = Inv.InversionID;

SET Mon_Inversion := IFNULL(Mon_Inversion, Entero_Cero);

SET montoGarLiq := montoGarLiq + Mon_Inversion;

IF( Par_Salida = Salida_SI ) THEN
    SELECT montoGarLiq;
END IF;

END TerminaStore$$