-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGCAPTRAD811REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGCAPTRAD811REP`;
DELIMITER $$


CREATE PROCEDURE `REGCAPTRAD811REP`(
  Par_Fecha             DATE,
  Par_NumReporte        TINYINT UNSIGNED,

    Par_EmpresaID         INT(11),
    Aud_Usuario           INT(11),
    Aud_FechaActual       DATETIME,
    Aud_DireccionIP       VARCHAR(15),
    Aud_ProgramaID        VARCHAR(50),
    Aud_Sucursal          INT(11),
    Aud_NumTransaccion    BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Reg_Concepto      VARCHAR(200);
DECLARE Var_Reg_Orden       INT;
DECLARE Var_FechaSistema  DATE;
DECLARE Var_ClaveEntidad  VARCHAR(300);
DECLARE Var_NivelEntidad    VARCHAR(300);
DECLARE Var_ClaveFederacion VARCHAR(300);
DECLARE Var_FechaInicioMes  DATE;
DECLARE Var_FechaIniMesSis  DATE;
DECLARE Var_DiasAnio    INT;
DECLARE Var_FechaHis    DATE;
DECLARE Var_FechaSalInv   DATE;
DECLARE Var_SaldoCap      DECIMAL(14,2);
DECLARE Var_SaldoCapPla     DECIMAL(14,2);
DECLARE Var_SaldoCapRet     DECIMAL(14,2);
DECLARE Var_IntMes        DECIMAL(14,2);
DECLARE Var_IntMesPla     DECIMAL(14,2);
DECLARE Var_IntMesRet     DECIMAL(14,2);
DECLARE Var_IntNoPagPla     DECIMAL(14,2);
DECLARE Var_IntNoPagRet     DECIMAL(14,2);
DECLARE Var_ComMes        DECIMAL(14,2);
DECLARE Var_SalCiePla     DECIMAL(14,2);
DECLARE Var_FechaCieInv   DATE;
DECLARE Cliente_Inst    INT;

DECLARE Var_DepVista	decimal(16,2);
DECLARE var_DepAhorro	decimal(16,2);
DECLARE Var_DepPlazo	decimal(16,2);
DECLARE Var_HisIntMesPla decimal(16,2);
DECLARE	Var_Diferencia	decimal(16,2);
DECLARE Var_MinCenCos INT;
DECLARE Var_MaxCenCos INT;

DECLARE Var_SaldoCapAho   DECIMAL(14,2);
DECLARE Var_IntMesAho   DECIMAL(14,2);
DECLARE Var_ComMesAho   DECIMAL(14,2);
DECLARE Var_NumReporte      VARCHAR(10);

DECLARE Entero_Cero       INT;
DECLARE Entero_Cien       INT;
DECLARE Cadena_Vacia      CHAR(1);
DECLARE Decimal_Cero      DECIMAL(14,2);
DECLARE Fecha_Vacia     DATE;
DECLARE Str_Tabulador   VARCHAR(5);
DECLARE Est_Vigente     CHAR(1);
DECLARE Est_Pagado      CHAR(1);
DECLARE Rep_Excel           INT;
DECLARE Rep_Csv         INT;
DECLARE Tipo_Vista      CHAR;
DECLARE Tipo_Ahorro     CHAR;

DECLARE Cuenta_DepPlazo   VARCHAR(5);
DECLARE Nat_Deudora     CHAR(1);

SET Entero_Cero     := 0;
SET Entero_Cien     := 100;
SET Cadena_Vacia    := '';
SET Decimal_Cero  := 0.00;
SET Fecha_Vacia   := '1900-01-01';
SET Str_Tabulador   := '     ';
SET Rep_Excel       := 1;
SET Rep_Csv     := 2;

SET Est_Vigente   := 'N';
SET Est_Pagado    := 'P';

SET Tipo_Vista    := 'V';
SET Tipo_Ahorro   := 'A';

SET Cuenta_DepPlazo := '6102';
SET Nat_Deudora   := 'D';
SET Var_NumReporte  := '0811';

SET Var_ClaveFederacion :='123';
SELECT  ClaveEntidad,ClaveNivInstitucion
       INTO Var_ClaveEntidad, Var_NivelEntidad
        FROM `PARAMETROSSIS`
        WHERE EmpresaID = Par_EmpresaID;

SELECT FechaSistema, DiasInversion INTO Var_FechaSistema, Var_DiasAnio FROM  PARAMETROSSIS;
SET Var_FechaInicioMes := DATE_ADD(Par_Fecha, INTERVAL -1*(DAY(Par_Fecha))+1 DAY);
SET Var_FechaIniMesSis := DATE_ADD(Var_FechaSistema, INTERVAL -1*(DAY(Var_FechaSistema))+1 DAY);
SET Cliente_Inst    := (SELECT ClienteInstitucion FROM PARAMETROSSIS);

    DROP TABLE IF EXISTS TMPREGR08A0811;

    CREATE TEMPORARY TABLE TMPREGR08A0811(
      Reg_Concepto        VARCHAR(200),
      Reg_SalCapCie   DECIMAL(14,2),
      Reg_SalIntNoPa    DECIMAL(14,2),
      Reg_SalCieMes   DECIMAL(14,2),
      Reg_IntMes      DECIMAL(14,2),
      Reg_ComMes      DECIMAL(14,2),
      Reg_Orden     INT(11),
            Reg_ConCNBV     VARCHAR(20));

    SET Reg_Concepto    := 'Total (1+2)';
    SET Var_Reg_Orden := 1;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'200000000000');

    SET Reg_Concepto    := '1. Captación Tradicional Depósitos';
    SET Var_Reg_Orden   := 2;
    INSERT INTO TMPREGR08A0811 VALUES(
    Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'210000000000');


    IF (Par_Fecha < Var_FechaIniMesSis) THEN

      SET Var_FechaHis := (SELECT MAX(Fecha) FROM `HIS-CUENTASAHO` WHERE Fecha <=Par_Fecha);
      SET Var_FechaHis := IFNULL(Var_FechaHis, Fecha_Vacia);
      SELECT  SUM(Cue.Saldo),   SUM(Cue.InteresesGen),  SUM(Cue.Comisiones)
       INTO Var_SaldoCap, Var_IntMes,     Var_ComMes
        FROM `HIS-CUENTASAHO` Cue,TIPOSCUENTAS Tip
        WHERE Cue.TipoCuentaID = Tip.TipoCuentaID
        AND Cue.Fecha = Var_FechaHis
        AND Tip.ClasificacionConta = Tipo_Vista;

      SELECT  SUM(Cue.Saldo),   SUM(Cue.InteresesGen),  SUM(Cue.Comisiones)
       INTO Var_SaldoCapAho,  Var_IntMesAho,      Var_ComMesAho
        FROM `HIS-CUENTASAHO` Cue,TIPOSCUENTAS Tip
        WHERE Cue.TipoCuentaID = Tip.TipoCuentaID
        AND Cue.Fecha = Var_FechaHis
        AND Tip.ClasificacionConta = Tipo_Ahorro;
    ELSE
      SELECT  SUM(Cue.Saldo),   SUM(Cue.InteresesGen),  SUM(Cue.Comisiones)
       INTO Var_SaldoCap, Var_IntMes,     Var_ComMes
        FROM CUENTASAHO Cue,TIPOSCUENTAS Tip
                WHERE Cue.TipoCuentaID = Tip.TipoCuentaID
        AND Tip.ClasificacionConta = Tipo_Vista;

      SELECT  SUM(Cue.Saldo),   SUM(Cue.InteresesGen),  SUM(Cue.Comisiones)
       INTO Var_SaldoCapAho,  Var_IntMesAho,      Var_ComMesAho
        FROM CUENTASAHO Cue,TIPOSCUENTAS Tip
                WHERE Cue.TipoCuentaID = Tip.TipoCuentaID
        AND Tip.ClasificacionConta = Tipo_Vista;


    END IF;

    SET Var_SaldoCap  := ROUND(IFNULL(Var_SaldoCap,Entero_Cero),Entero_Cero);
    SET Var_IntMes    := ROUND(IFNULL(Var_IntMes,Entero_Cero),Entero_Cero);
    SET Var_ComMes    := ROUND(IFNULL(Var_ComMes,Entero_Cero),Entero_Cero);

    SET Var_SaldoCapAho := ROUND(IFNULL(Var_SaldoCapAho,Entero_Cero),Entero_Cero);
    SET Var_IntMesAho := ROUND(IFNULL(Var_IntMesAho,Entero_Cero),Entero_Cero);
    SET Var_ComMesAho := ROUND(IFNULL(Var_ComMesAho,Entero_Cero),Entero_Cero);


    SELECT Monto INTO Var_DepVista FROM `HIS-CATALOGOMINIMO` WHERE
	Anio = YEAR(Par_Fecha)  AND Mes = MONTH(Par_Fecha) AND CuentaContable = '210101000000';
    SELECT Monto INTO Var_DepAhorro FROM `HIS-CATALOGOMINIMO` WHERE
	Anio = YEAR(Par_Fecha)  AND Mes = MONTH(Par_Fecha) AND CuentaContable = '210102000000';

    SET Var_DepVista := IFNULL(Var_DepVista,Entero_Cero);
    SET Var_DepAhorro := IFNULL(Var_DepAhorro,Entero_Cero);

    SET Var_Diferencia := Var_DepVista - Var_SaldoCap;
    IF IFNULL(ABS(Var_Diferencia),Entero_Cero) > Entero_Cero AND IFNULL(ABS(Var_Diferencia),Entero_Cero) < 1000 THEN
		SET Var_SaldoCap := Var_DepVista;
    END IF;

    SET Var_Diferencia := Var_DepAhorro - Var_SaldoCapAho;
    IF IFNULL(ABS(Var_Diferencia),Entero_Cero) > Entero_Cero AND IFNULL(ABS(Var_Diferencia),Entero_Cero) < 1000 THEN
		SET Var_SaldoCapAho := Var_DepAhorro;
    END IF;


    SET Reg_Concepto  := CONCAT(Str_Tabulador,'Depósitos de exigibilidad inmediata');
    SET Var_Reg_Orden   := 3;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   (Var_SaldoCap+Var_SaldoCapAho),   Entero_Cero, (Var_SaldoCap+Var_SaldoCapAho),(Var_IntMes+Var_IntMesAho),(Var_ComMes+Var_ComMesAho), Var_Reg_Orden,'210100000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Depósitos a la vista');
    SET Var_Reg_Orden   := 4;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Var_SaldoCap,   Entero_Cero, Var_SaldoCap,Var_IntMes,Var_ComMes, Var_Reg_Orden,'210104000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Depósitos de ahorro');
    SET Var_Reg_Orden   := 5;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,    Var_SaldoCapAho,   Entero_Cero, Var_SaldoCapAho,Var_IntMesAho,Var_ComMesAho, Var_Reg_Orden,'210105000000');

    SET Reg_Concepto    := CONCAT(Str_Tabulador,'Depósitos a plazo');
    SET Var_Reg_Orden   := 6;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'211100000000');



    SET Var_FechaCieInv := (SELECT MAX(FechaCorte) FROM HISINVERSIONES WHERE FechaCorte <= Par_Fecha);


    SELECT SUM(IFNULL(Inv.Monto, Entero_Cero)),
        SUM(IFNULL(Inv.SaldoProvision, Entero_Cero))
        INTO
        Var_SaldoCapPla, Var_IntNoPagPla
        FROM HISINVERSIONES Inv
        WHERE Inv.Estatus = Est_Vigente
        AND Inv.FechaCorte  = Var_FechaCieInv
         AND Inv.ClienteID <> Cliente_Inst;


    SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
    FROM CENTROCOSTOS;

        SELECT
      CASE WHEN (Cue.Naturaleza) = Nat_Deudora  THEN
          SUM((IFNULL(Pol.Cargos, Entero_Cero)))-SUM((IFNULL(Pol.Abonos, Entero_Cero)))
         ELSE
          Entero_Cero
        END AS IntMesPlazo
      INTO Var_IntMesPla
      FROM CUENTASCONTABLES Cue
      LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
                         AND Pol.Fecha <= Par_Fecha
                         AND Pol.CentroCostoID >= Var_MinCenCos
                         AND Pol.CentroCostoID <= Var_MaxCenCos )
      WHERE Cue.CuentaCompleta LIKE CONCAT(Cuenta_DepPlazo,'%')
      GROUP BY Cue.Naturaleza;

        SELECT
      CASE WHEN (Cue.Naturaleza) = Nat_Deudora  THEN
          SUM((IFNULL(Pol.Cargos, Entero_Cero)))-SUM((IFNULL(Pol.Abonos, Entero_Cero)))
         ELSE
          Entero_Cero
        END AS HisIntMesPlazo
      INTO Var_HisIntMesPla
      FROM CUENTASCONTABLES Cue
      LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
                         AND Pol.Fecha <= Par_Fecha
                         AND Pol.CentroCostoID >= Var_MinCenCos
                         AND Pol.CentroCostoID <= Var_MaxCenCos )
      WHERE Cue.CuentaCompleta LIKE CONCAT(Cuenta_DepPlazo,'%')
      GROUP BY Cue.Naturaleza;

    SET Var_SaldoCapPla := ROUND(IFNULL(Var_SaldoCapPla,Entero_Cero),Entero_Cero);
    SET Var_IntNoPagPla := ROUND(IFNULL(Var_IntNoPagPla,Entero_Cero),Entero_Cero);
    SET Var_IntMesPla := ROUND(IFNULL(Var_IntMesPla,Entero_Cero)+Var_HisIntMesPla,Entero_Cero);
    SET Var_SalCiePla := Var_SaldoCapPla+Var_IntNoPagPla;


	SELECT Monto INTO Var_DepPlazo FROM `HIS-CATALOGOMINIMO` WHERE
	Anio = YEAR(Par_Fecha)  AND Mes = MONTH(Par_Fecha) AND CuentaContable = '211100000000';

    SET Var_Diferencia := Var_DepPlazo - (Var_SaldoCapPla+Var_IntNoPagPla);
    IF IFNULL(ABS(Var_Diferencia),Entero_Cero) > Entero_Cero AND IFNULL(ABS(Var_Diferencia),Entero_Cero) < 1000 THEN
		SET Var_SaldoCapPla := Var_SaldoCapPla + Var_Diferencia;
    END IF;


    SET Reg_Concepto  := CONCAT(REPEAT(Str_Tabulador, 2),'Depósitos a plazo');
    SET Var_Reg_Orden   := 7;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Var_SaldoCapPla,   Var_IntNoPagPla, Var_SaldoCapPla+Var_IntNoPagPla,Var_IntMesPla,Entero_Cero, Var_Reg_Orden,'211104000000');


    IF (Par_Fecha < Var_FechaSistema) THEN

      SET Var_FechaSalInv := (SELECT MAX(FechaCorte) FROM SALDOSINVKUBO WHERE FechaCorte <= Par_Fecha);
      SET Var_FechaSalInv := IFNULL(Var_FechaSalInv, Fecha_Vacia);



      SELECT SUM(SalCapVigente+ SalCapExigible) , SUM(SaldoInteres), SUM(ProvisionAcum - SaldoInteres)
      INTO Var_SaldoCapRet, Var_IntNoPagRet, Var_IntMesRet
      FROM SALDOSINVKUBO
      WHERE FechaCorte = Var_FechaSalInv;
    ELSE

      SET Var_SaldoCapRet =0;
    END IF;

    SET Var_SaldoCapRet := IFNULL(Var_SaldoCapRet,Entero_Cero);
    SET Var_IntNoPagRet := IFNULL(Var_IntNoPagRet,Entero_Cero);
    SET Var_IntMesRet := IFNULL(Var_IntMesRet,Entero_Cero);
    SET Var_SalCiePla := Var_SalCiePla +Var_SaldoCapRet+Var_IntNoPagRet;
    SET Reg_Concepto  := CONCAT(REPEAT(Str_Tabulador, 2),'Depósitos retirables en días preestablecidos');
    SET Var_Reg_Orden := 8;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Var_SaldoCapRet,   Var_IntNoPagRet, Var_SaldoCapRet+Var_IntNoPagRet,Var_IntMesRet,Entero_Cero, Var_Reg_Orden,'211105000000');


    UPDATE  TMPREGR08A0811 SET
      Reg_SalCapCie = Var_SaldoCapRet + Var_SaldoCapPla,
      Reg_SalIntNoPa  = Var_IntNoPagPla + Var_IntNoPagRet,
      Reg_IntMes    =Var_IntMesPla ,
      Reg_SalCieMes = Var_SalCiePla
    WHERE Reg_Orden   = 6;


    UPDATE  TMPREGR08A0811 SET
      Reg_SalCapCie = Var_SaldoCap+Var_SaldoCapAho +Var_SaldoCapRet + Var_SaldoCapPla,
      Reg_SalCieMes = Var_SalCiePla+Var_SaldoCap + Var_SaldoCapAho,
      Reg_SalIntNoPa  = Var_IntNoPagPla+Var_IntNoPagRet,
      Reg_IntMes    = Var_IntMes+ Var_IntMesAho +Var_IntMesPla + Var_IntMesRet,
      Reg_ComMes    = Var_ComMes + Var_ComMesAho
    WHERE Reg_Orden   = 2;


    UPDATE  TMPREGR08A0811 SET
      Reg_SalCapCie = Var_SaldoCap + Var_SaldoCapAho +Var_SaldoCapRet + Var_SaldoCapPla,
      Reg_SalCieMes = Var_SalCiePla + Var_SaldoCap + Var_SaldoCapAho,
      Reg_SalIntNoPa  = Var_IntNoPagPla+Var_IntNoPagRet,
      Reg_IntMes    = Var_IntMes +Var_IntMesAho +Var_IntMesPla + Var_IntMesRet,
      Reg_ComMes    = Var_ComMes + Var_ComMesAho
    WHERE Reg_Orden   = 1;

    SET Reg_Concepto  := CONCAT(Str_Tabulador,'Títulos de crédito emitidos 3/');
    SET Var_Reg_Orden := 9;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'212200000000');


    SET Reg_Concepto    := '2. Préstamos bancarios y de otros organismos';
    SET Var_Reg_Orden := 10;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230000000000');

    SET Reg_Concepto    := CONCAT(Str_Tabulador,'De corto plazo');
    SET Var_Reg_Orden := 11;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230200000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Préstamos de instituciones de banca comercial');
    SET Var_Reg_Orden := 12;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230202000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Préstamos de instituciones de banca de desarrollo');
    SET Var_Reg_Orden := 13;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230203000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Préstamos de fideicomisos públicos');
    SET Var_Reg_Orden := 14;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230204000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Préstamos de Entidades de Ahorro y Crédito Popular (De Liquidez)');
    SET Var_Reg_Orden := 15;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230209000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Préstamos de otros organismos');
    SET Var_Reg_Orden       := 16;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230205000000');

    SET Reg_Concepto    := CONCAT(Str_Tabulador,'De largo plazo');
    SET Var_Reg_Orden := 17;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230300000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Préstamos de instituciones de banca comercial');
    SET Var_Reg_Orden := 18;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230302000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Préstamos de instituciones de banca de desarrollo');
    SET Var_Reg_Orden := 19;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230303000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Préstamos de fideicomisos públicos');
    SET Var_Reg_Orden := 20;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230304000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Préstamos de Entidades de Ahorro y Crédito Popular (De Liquidez)');
    SET Var_Reg_Orden := 21;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230309000000');

    SET Reg_Concepto    := CONCAT(REPEAT(Str_Tabulador, 2),'Préstamos de otros organismos');
    SET Var_Reg_Orden := 22;
    INSERT INTO TMPREGR08A0811 VALUES(
      Reg_Concepto,   Entero_Cero,   Entero_Cero, Entero_Cero,Entero_Cero,Entero_Cero, Var_Reg_Orden,'230305000000');



IF(Par_NumReporte = Rep_Excel) THEN
    SELECT  Reg.Reg_Concepto,   Reg.Reg_SalCapCie,    Reg.Reg_SalIntNoPa, Reg.Reg_SalCieMes, Reg.Reg_IntMes,
        Reg.Reg_ComMes,   Reg.Reg_Orden
      FROM TMPREGR08A0811 Reg
       ORDER BY Reg.Reg_Orden;
END IF;



IF(Par_NumReporte = Rep_Csv) THEN

DROP TABLE IF EXISTS TMPTAB1;
CREATE TEMPORARY TABLE TMPTAB1
    SELECT  Var_ClaveFederacion,Var_ClaveEntidad,Var_NivelEntidad,Reg.Reg_ConCNBV,'2' AS NumUno,Reg.Reg_SalCapCie
        FROM TMPREGR08A0811 Reg;

DROP TABLE IF EXISTS TMPTAB2;
CREATE TEMPORARY TABLE TMPTAB2
    SELECT  Var_ClaveFederacion,Var_ClaveEntidad,Var_NivelEntidad,Reg.Reg_ConCNBV,'29' AS NumDos, Reg.Reg_SalIntNoPa
        FROM TMPREGR08A0811 Reg;

DROP TABLE IF EXISTS TMPTAB3;
CREATE TEMPORARY TABLE TMPTAB3
    SELECT  Var_ClaveFederacion,Var_ClaveEntidad,Var_NivelEntidad,Reg.Reg_ConCNBV,'1' AS NumTres,Reg_SalCieMes
        FROM TMPREGR08A0811 Reg;

DROP TABLE IF EXISTS TMPTAB4;
CREATE TEMPORARY TABLE TMPTAB4
    SELECT  Var_ClaveFederacion,Var_ClaveEntidad,Var_NivelEntidad,Reg.Reg_ConCNBV,'4' AS NumCuatro,Reg_IntMes
        FROM TMPREGR08A0811 Reg;

DROP TABLE IF EXISTS TMPTAB5;
CREATE TEMPORARY TABLE TMPTAB5
    SELECT  Var_ClaveFederacion,Var_ClaveEntidad,Var_NivelEntidad,Reg.Reg_ConCNBV,'5' AS NumCinco,Reg_ComMes
        FROM TMPREGR08A0811 Reg;

(SELECT CONCAT(Var_NivelEntidad,';',Reg.Reg_ConCNBV,';',Var_NumReporte,';',Reg.NumTres,';',ROUND(Reg.Reg_SalCieMes)) AS Valor
    FROM TMPTAB3 Reg)
UNION ALL
(SELECT CONCAT(Var_NivelEntidad,';',Reg.Reg_ConCNBV,';',Var_NumReporte,';',Reg.NumUno,';',ROUND(Reg.Reg_SalCapCie)) AS Valor
    FROM TMPTAB1 Reg)
UNION ALL
(SELECT CONCAT(Var_NivelEntidad,';',Reg.Reg_ConCNBV,';',Var_NumReporte,';',Reg.NumCuatro,';',ROUND(Reg.Reg_IntMes)) AS Valor
    FROM TMPTAB4 Reg)
UNION ALL
(SELECT CONCAT(Var_NivelEntidad,';',Reg.Reg_ConCNBV,';',Var_NumReporte,';',Reg.NumCinco,';',ROUND(Reg.Reg_ComMes)) AS Valor
    FROM TMPTAB5 Reg)
UNION ALL
(SELECT CONCAT(Var_NivelEntidad,';',Reg.Reg_ConCNBV,';',Var_NumReporte,';',Reg.NumDos,';',ROUND(Reg.Reg_SalIntNoPa)) AS Valor
    FROM TMPTAB2 Reg);

END IF;
END TerminaStore$$