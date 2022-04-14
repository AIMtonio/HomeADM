-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRANSACCIONESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TRANSACCIONESCON`;DELIMITER $$

CREATE PROCEDURE `TRANSACCIONESCON`(
    Par_CreditoID       BIGINT(12),
    Par_NumCon          INT(11)
        )
TerminaStore: BEGIN

DECLARE Con_NumTran     INT(11);
DECLARE NumTransac      BIGINT(20);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE NumConCredito   INT;
DECLARE SalidaNO        CHAR(1);
DECLARE Par_NumErr      INT;
DECLARE Par_ErrMen      VARCHAR(400);

SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Con_NumTran         := 6;
SET NumConCredito       := 3;
SET SalidaNO            :='N';
SET Par_NumErr          := 0;
SET Par_ErrMen          :="";

IF(Par_NumCon = Con_NumTran) THEN

   SET Numtransac = (SELECT NumeroTransaccion FROM TRANSACCIONES);


   CALL CREDITOSACT(    Par_CreditoID,   Numtransac,        Fecha_Vacia,        Entero_Cero,        NumConCredito,
                        Fecha_Vacia,     Fecha_Vacia,       Entero_Cero,        Entero_Cero,        Entero_Cero,
                        Cadena_Vacia,    Cadena_Vacia,      Entero_Cero,        SalidaNO,           Par_NumErr,
                        Par_ErrMen,      Entero_Cero,       Entero_Cero,        Fecha_Vacia,        Cadena_Vacia,
                        Cadena_Vacia,    Entero_Cero,       Entero_Cero);

    SELECT Numtransac;
END IF;


END TerminaStore$$