-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALRESCREDITOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALRESCREDITOSCON`;DELIMITER $$

CREATE PROCEDURE `CALRESCREDITOSCON`(
    Par_Fecha           DATE,
    Par_CreditoID       BIGINT(12),
    Par_NumCon          TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Var_FechaCorte  DATE;
DECLARE Var_FechaSug    DATE;
DECLARE UltimaFecha     DATE;
DECLARE SaldoCap        DECIMAL(12,2);
DECLARE SaldoInt        DECIMAL(12,2);
DECLARE TotalReserva    DECIMAL(12,2);

DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Con_UltFecha    INT;
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Con_FechaReserva    INT;

SET Cadena_Vacia    :='';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Con_UltFecha    := 1;
SET Con_FechaReserva :=2;

IF(Par_NumCon = Con_UltFecha) THEN
    SELECT  MAX(Cal.Fecha) INTO Var_FechaCorte
        FROM CALRESCREDITOS Cal
        WHERE Cal.Fecha  <= Par_Fecha;

    SET Var_FechaCorte := IFNULL(Var_FechaCorte, Fecha_Vacia);

    SELECT  Var_FechaCorte;

END IF;

IF(Par_NumCon =Con_FechaReserva) THEN
SELECT  MAX(Fecha) INTO UltimaFecha
    FROM CALRESCREDITOS
    WHERE   CreditoID = Par_CreditoID;

SELECT SaldoResCapital,SaldoResInteres
    INTO SaldoCap,SaldoInt
    FROM CALRESCREDITOS
    WHERE CreditoID=Par_CreditoID
        AND Fecha = UltimaFecha;
    SET SaldoCap :=IFNULL(SaldoCap,Entero_Cero);
    SET SaldoInt :=IFNULL(SaldoInt,Entero_Cero);
    SET TotalReserva=SaldoCap+SaldoInt;

SELECT UltimaFecha,TotalReserva,SaldoCap,SaldoInt;
END IF;

END TerminaStore$$