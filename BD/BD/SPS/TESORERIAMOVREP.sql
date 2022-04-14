-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESORERIAMOVREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESORERIAMOVREP`;
DELIMITER $$


CREATE PROCEDURE `TESORERIAMOVREP`(
    Par_InstitucionID       INT,
    Par_NumCtaInstit        VARCHAR(20),
    Par_Fecha               DATE,
    Par_Formato             CHAR(1),

    Par_EmpresaID           INT,
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT  )

TerminaStore: BEGIN


DECLARE Var_CuentaAhoID     BIGINT(12);
DECLARE Var_SaldoIniMes     DECIMAL(14,2);
DECLARE Var_FecIniMes       DATE;
DECLARE Var_SaldoAcum       DECIMAL(14,2);

DECLARE Var_FechaMov        DATE;
DECLARE Var_NatMovimiento   CHAR(1);
DECLARE Var_MontoMov        DECIMAL(14,2);
DECLARE Var_DescripcionMov  VARCHAR(150);
DECLARE Var_ReferenciaMov   VARCHAR(150);
DECLARE Var_Status          CHAR(1);

DECLARE Var_DesNatMovimi    VARCHAR(10);
DECLARE Var_Cargos          DECIMAL(14,2);
DECLARE Var_Abonos          DECIMAL(14,2);


DECLARE Entero_Cero         INT;
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Des_Cargo           VARCHAR(10);
DECLARE Des_Abono           VARCHAR(10);
DECLARE Mov_DescriIni       VARCHAR(100);
DECLARE For_Pantalla        CHAR(1);
DECLARE For_Reporte         CHAR(1);


DECLARE CURSORMOVSTESO CURSOR FOR
    SELECT  FechaMov, NatMovimiento, MontoMov, DescripcionMov, ReferenciaMov,
            Status
        FROM TESORERIAMOVS
        WHERE CuentaAhoID   = Var_CuentaAhoID
          AND FechaMov      >= Var_FecIniMes
           AND FechaMov      <= Par_Fecha
          ORDER BY FechaMov, NatMovimiento, FolioMovimiento;


SET Entero_Cero     := 0;
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Des_Cargo       := 'CARGO';
SET Des_Abono       := 'ABONO';
SET For_Pantalla    := 'P';
SET For_Reporte     := 'R';

SET Mov_DescriIni   := 'SALDO INICIAL DEL MES';



SELECT CuentaAhoID INTO Var_CuentaAhoID
    FROM CUENTASAHOTESO
    WHERE InstitucionID = Par_InstitucionID
      AND NumCtaInstit  = Par_NumCtaInstit;

SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);
SET Var_SaldoIniMes := Entero_Cero;

SET Var_FecIniMes   = DATE_ADD(Par_Fecha, INTERVAL -1 * (DAY(Par_Fecha)) + 1 DAY);





SELECT  SUM( CASE WHEN NatMovimiento = Nat_Abono THEN MontoMov
                  ELSE MontoMov * -1
                  END) INTO Var_SaldoIniMes
    FROM TESORERIAMOVS
    WHERE CuentaAhoID   = Var_CuentaAhoID
      AND FechaMov      < Var_FecIniMes;

SET Var_SaldoIniMes = IFNULL(Var_SaldoIniMes, Entero_Cero);

DELETE FROM TMPTESORERIAMOV
    WHERE NumTransaccion = Aud_NumTransaccion;

INSERT INTO TMPTESORERIAMOV VALUES(
    Aud_NumTransaccion, Entero_Cero,        Var_CuentaAhoID,    Entero_Cero,    Var_FecIniMes,
    Cadena_Vacia,       Entero_Cero,        Cadena_Vacia,       Mov_DescriIni,  Cadena_Vacia,
    Cadena_Vacia,       Cadena_Vacia,       Entero_Cero,        Entero_Cero,    Var_SaldoIniMes,
    Var_SaldoIniMes);

SET Var_SaldoAcum   := Var_SaldoIniMes;

OPEN CURSORMOVSTESO;
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    LOOP

    FETCH CURSORMOVSTESO INTO
        Var_FechaMov,   Var_NatMovimiento,  Var_MontoMov,   Var_DescripcionMov, Var_ReferenciaMov,
        Var_Status;

    IF (Var_NatMovimiento = Nat_Abono) THEN
        SET Var_DesNatMovimi    := Des_Abono;
        SET Var_SaldoAcum       := Var_SaldoAcum + Var_MontoMov;
        SET Var_Cargos          := Entero_Cero;
        SET Var_Abonos          := Var_MontoMov;
    ELSE
        SET Var_DesNatMovimi    := Des_Cargo;
        SET Var_SaldoAcum       := Var_SaldoAcum - Var_MontoMov;
        SET Var_Cargos          := Var_MontoMov;
        SET Var_Abonos          := Entero_Cero;
    END IF;

    INSERT INTO TMPTESORERIAMOV VALUES(
        Aud_NumTransaccion, Entero_Cero,    Var_CuentaAhoID,    Entero_Cero,        Var_FechaMov,
        Var_DesNatMovimi,   Entero_Cero,    Cadena_Vacia,       Var_DescripcionMov, Var_ReferenciaMov,
        Cadena_Vacia,       Cadena_Vacia,   Entero_Cero,        Var_Cargos,         Var_Abonos,
        Var_SaldoAcum);

    END LOOP;

END;
CLOSE CURSORMOVSTESO;

IF Par_Formato = For_Reporte THEN
    SELECT  FechaMov,       DescripcionMov, NatMovimiento,  ReferenciaMov,  MontoMov,
            SaldoAcumulado, Cargos,         Abonos
        FROM TMPTESORERIAMOV
        WHERE NumTransaccion = Aud_NumTransaccion;
ELSE
    SELECT  FechaMov,       DescripcionMov, NatMovimiento,  ReferenciaMov,  MontoMov,
            FORMAT(SaldoAcumulado, 2), FORMAT(Cargos,2),    FORMAT(Abonos, 2)
        FROM TMPTESORERIAMOV
        WHERE NumTransaccion = Aud_NumTransaccion;
END IF;


DELETE FROM TMPTESORERIAMOV
    WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$