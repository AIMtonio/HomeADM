-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALIFICACIONCLIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALIFICACIONCLIPRO`;
DELIMITER $$


CREATE PROCEDURE `CALIFICACIONCLIPRO`(





    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),


    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
        )

TerminaStore:BEGIN


DECLARE varControl          CHAR(15);
DECLARE Var_FechaSis        DATE;
DECLARE Var_TotalClientes   INT;
DECLARE Var_InteresPromGen  DECIMAL(14,2);
DECLARE Var_SaldoPromGen    DECIMAL(14,2);
DECLARE Var_FechaAnterior   DATE;
DECLARE Var_FechaSig        DATE;
DECLARE Es_DiaHabil         CHAR(1);
DECLARE Var_FecBitaco       DATETIME;
DECLARE Var_MinutosBit      INT;
DECLARE Var_CtaOrdinaria    INT;
DECLARE Fec_UltAsamblea     DATE;



DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL;
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Salida_SI           CHAR(1);
DECLARE Cliente_Activo      CHAR(1);
DECLARE Credito_Pagado      CHAR(1);
DECLARE Credito_Vigente     CHAR(1);
DECLARE Credito_Vencido     CHAR(1);
DECLARE Credito_Castigado   CHAR(1);
DECLARE Un_DiaHabil         INT(1);
DECLARE Numero_Meses        INT(4);
DECLARE Cuenta_Activa       CHAR(1);
DECLARE No_Asignada         CHAR(1);
DECLARE Tipo_Reestruc       CHAR(1);
DECLARE Tipo_Renova         CHAR(1);
DECLARE Base_Asistencia     INT;
DECLARE Todas_Asistencia    INT;
DECLARE Si_AsisteAsa        CHAR(1);
DECLARE EstatusDesembolso   CHAR(1);

DECLARE Con_A1              INT(1);
DECLARE Con_A2              INT(1);
DECLARE Con_A3              INT(1);
DECLARE Con_A4              INT(1);
DECLARE Con_M1              INT(1);
DECLARE Con_M2              INT(1);
DECLARE Con_B1              INT(1);
DECLARE Con_B2              INT(1);
DECLARE Con_B3              INT(1);
DECLARE Proceso_A1          CHAR(2);
DECLARE Proceso_A2          CHAR(2);
DECLARE Proceso_A3          CHAR(2);
DECLARE Proceso_A4          CHAR(2);
DECLARE Proceso_M1          CHAR(2);
DECLARE Proceso_M2          CHAR(2);
DECLARE Proceso_B1          CHAR(2);
DECLARE Proceso_B2          CHAR(2);
DECLARE Proceso_B3          CHAR(2);
DECLARE Proceso_Calif       CHAR(50);


SET Entero_Cero         :=0;
SET Decimal_Cero        :=0.0;
SET Cadena_Vacia        :='';
SET Fecha_Vacia         :='1900-01-01';
SET Salida_SI           :='S';
SET Cliente_Activo      :='A';
SET Credito_Pagado      :='P';
SET Credito_Vigente     :='V';
SET Credito_Vencido     :='B';
SET Credito_Castigado   :='K';
SET Un_DiaHabil         :=1;
SET Numero_Meses        := 36;
SET Cuenta_Activa       := 'A';
SET No_Asignada         := 'N';
SET Tipo_Reestruc       := 'R';
SET Tipo_Renova         := 'O';
SET Base_Asistencia     := 25;
SET Todas_Asistencia    := 100;
SET Si_AsisteAsa        := 'S';
SET EstatusDesembolso   := 'D';

SET Con_A1              :=1;
SET Con_A2              :=2;
SET Con_A3              :=3;
SET Con_A4              :=4;
SET Con_M1              :=5;
SET Con_M2              :=6;
SET Con_B1              :=7;
SET Con_B2              :=8;
SET Con_B3              :=9;
SET Proceso_A1          := 'A1';
SET Proceso_A2          := 'A2';
SET Proceso_A3          := 'A3';
SET Proceso_A4          := 'A4';
SET Proceso_M1          := 'M1';
SET Proceso_M2          := 'M2';
SET Proceso_B1          := 'B1';
SET Proceso_B2          := 'B2';
SET Proceso_B3          := 'B3';

SET Proceso_Calif       :='Asignacion de Calificacion y Clasificacion del cliente';



SET Par_NumErr      := 0;
SET Par_ErrMen      := '';

    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = '999';
                SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ' ,
                                         'Disculpe las molestias que esto le ocasiona. Ref: SP-CALIFICACIONCLIPRO');
                SET varControl = 'sqlException' ;
            END;


    SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);

    CALL AUXCALIFICACLIPRO(Var_TotalClientes,       Var_InteresPromGen,     Var_SaldoPromGen,    Par_EmpresaID,     Aud_Usuario,
                           Aud_FechaActual,         Aud_DireccionIP,        Aud_ProgramaID,      Aud_Sucursal,      Aud_NumTransaccion);




    DROP TABLE IF EXISTS TMPCALIFCLIENTE;
    CREATE TABLE IF NOT EXISTS TMPCALIFCLIENTE (
      ClienteID         INT(11)         COMMENT 'ID del cliente',
      PuntosA1          DECIMAL(12,2)   COMMENT 'Anios como cliente en la institucion',
      PuntosA2          DECIMAL(12,2)   COMMENT 'Numero de creditos liquidados',
      PuntosA3          DECIMAL(12,2)   COMMENT 'Morosidad promedio creditos',
      PuntosA4          DECIMAL(12,2)   COMMENT 'Forma de pagar(liquidar) de sus creditos',
      PuntosM1          DECIMAL(12,2)   COMMENT 'Anios como cliente en la institucion',
      PuntosM2          DECIMAL(12,2)   COMMENT 'Numero de creditos liquidados',
      PuntosB1          DECIMAL(12,2)   COMMENT 'Morosidad promedio creditos',
      PuntosB2          DECIMAL(12,2)   COMMENT 'Forma de pagar(liquidar) de sus creditos',
      PuntosB3          DECIMAL(12,2)   COMMENT 'Forma de pagar(liquidar) de sus creditos',
      PagoCredAntes     INT(11)         COMMENT 'Numero de creditos pagados antes de la fecha de vencimiento',
      PagoCredEn        INT(11)         COMMENT 'Numero de creditos pagados en la fecha de vencimiento',
      PagoCredDesp      INT(11)         COMMENT 'Numero de creditos pagados despues de la fecha de vencimiento',
      TotalPuntos       DECIMAL(12,2)   COMMENT 'Sumatoria de puntos obtenidos por todos los conceptos ',
      NumReestruc       INT(11)         COMMENT 'Numero de creditos Reestrcuturados',
      NumRenova         INT(11)         COMMENT 'Numero de creditos Renovados',
      AsistenciaAsam    INT(11)         COMMENT 'Valor de la Asistencia a Asamblea',
    PRIMARY KEY (ClienteID))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = LATIN1
    COMMENT = 'Almacena datos temporales para calcular calificacion de los clientes';


    DROP TABLE IF EXISTS TMPCALIFCREDITOS;
    CREATE TABLE IF NOT EXISTS TMPCALIFCREDITOS (
      CreditoID         BIGINT(12)      COMMENT 'ID del credito',
      ClienteID         INT(11)         COMMENT 'ID de cliente al que pertenece el credito',
      Estatus           CHAR(1)         COMMENT 'Estatus del credito',
      FechaInicio       DATE            COMMENT 'Fecha de entrega del credito',
      FechTerminacion   DATE            COMMENT 'Fecha de terminacin',
      FechaVencimien    DATE            COMMENT 'Fecha de vencimiento',

    PRIMARY KEY (CreditoID))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = LATIN1
    COMMENT = 'Almacena datos temporales para calcular puntajes sobre creditos';


    DROP TABLE IF EXISTS TMPCALCRECLIENTE;
    CREATE TABLE IF NOT EXISTS TMPCALCRECLIENTE (
      ClienteID         INT(11)         COMMENT 'ID de cliente',
      NumCreditos       INT(11)         COMMENT 'Numero de creditos liquidados de un cliente',
      PagoCredAntes     DECIMAL(12,2)   COMMENT ' % de creditos pagados antes de la fecha de vencimiento',
      PagoCredEn        DECIMAL(12,2)   COMMENT ' % de creditos pagados en la fecha de vencimiento',
      PagoCredDesp      DECIMAL(12,2)   COMMENT ' % de creditos pagados despues de la fecha de vencimiento',

    PRIMARY KEY (ClienteID))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = LATIN1
    COMMENT = 'Almacena datos temporales para calcular numeros de credito por cliente';


    DROP TABLE IF EXISTS TMPCALIFCREDITOSMOR;
    CREATE TABLE IF NOT EXISTS TMPCALIFCREDITOSMOR (
      ClienteID         INT(11)         COMMENT 'ID del cliente',
      NumCreMoroso      INT(11)         COMMENT 'Numero de creditos morosos',

    PRIMARY KEY (ClienteID))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = LATIN1
    COMMENT = 'Almacena datos temporales para calcular puntajes sobre creditos morosos';


    DROP TABLE IF EXISTS TMPCALINTPAGA;
    CREATE TABLE IF NOT EXISTS TMPCALINTPAGA (
      ClienteID         INT(11)         COMMENT 'ID del cliente',
      InteresPagado     DECIMAL(12,2)   COMMENT 'Monto de Interes Pagado',
      InteresPonderado  DECIMAL(12,2)   COMMENT 'Monto de Interes Pagado Ponderado',

    PRIMARY KEY (ClienteID))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = LATIN1
    COMMENT = 'Almacena datos temporales para calcular el interes pagado por el cte';


    DROP TABLE IF EXISTS TMPCALIFCUENTASAHO;
    CREATE TABLE IF NOT EXISTS TMPCALIFCUENTASAHO (
      CuentaAhoID       BIGINT(12)      COMMENT 'ID de de la cuenta de ahorro',
      ClienteID         INT(11)         COMMENT 'ID de del cliente al que pertenece la cuenta',
      SaldoProm         INT(11)         COMMENT 'Saldo promedio',
    PRIMARY KEY (ClienteID))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = LATIN1
    COMMENT = 'Almacena cuentas de ahorro e historial de cuentas de ahorro.';


    DELETE FROM BITACORACALCLI;



    SET Var_FecBitaco   := NOW();

    INSERT INTO TMPCALIFCLIENTE(
            ClienteID,      PuntosA1,       PuntosA2,   PuntosA3,       PuntosA4,
            PuntosM1,       PuntosM2,       PuntosB1,   PuntosB2,       PuntosB3,
            TotalPuntos,    PagoCredAntes,  PagoCredEn, PagoCredDesp,   NumReestruc,
            NumRenova,      AsistenciaAsam)
        SELECT  ClienteID,  IFNULL((YEAR (Var_FechaSis)- YEAR (FechaAlta)) - (RIGHT(Var_FechaSis,5)<RIGHT(FechaAlta,5)), Entero_Cero) AS Antiguedad,
                Decimal_Cero,   Decimal_Cero,   Decimal_Cero,   Decimal_Cero,
                Decimal_Cero,   Decimal_Cero,   Decimal_Cero,   Decimal_Cero,
                Entero_Cero,    Entero_Cero,    Entero_Cero,    Decimal_Cero,
                Entero_Cero,    Entero_Cero,    Base_Asistencia
        FROM CLIENTES
            WHERE Estatus = Cliente_Activo;


    UPDATE TMPCALIFCLIENTE Cli, PUNTOSCONCEPTO Pun
    SET Cli.PuntosA1 = IFNULL(Pun.Puntos, Entero_Cero),
        Cli.TotalPuntos = Cli.TotalPuntos + Pun.Puntos
    WHERE Cli.PuntosA1 BETWEEN Pun.RangoInferior AND Pun.RangoSuperior
        AND Pun.ConceptoCalifID = Con_A1;

    SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    INSERT INTO BITACORACALCLI	(
						Fecha,					Proceso,					Tiempo,					Empresa,					Usuario,
						FechaActual,			DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
                VALUES( Var_FechaSis,       Proceso_A1,         Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);






    SET Var_FecBitaco   := NOW();


    INSERT INTO TMPCALCRECLIENTE (NumCreditos, ClienteID)
        SELECT IFNULL(COUNT(Cre.CreditoID), Entero_Cero), Tmp.ClienteID
            FROM CREDITOS Cre,
                 TMPCALIFCLIENTE Tmp
            WHERE Tmp.ClienteID  = Cre.ClienteID
             AND Cre.Estatus = Credito_Pagado
            GROUP BY Tmp.ClienteID;


    UPDATE TMPCALIFCLIENTE Cli, TMPCALCRECLIENTE Cre, PUNTOSCONCEPTO Pun
    SET Cli.PuntosA2 = IFNULL(Pun.Puntos, Decimal_Cero),
        Cli.TotalPuntos = Cli.TotalPuntos + Pun.Puntos
    WHERE Cre.ClienteID = Cli.ClienteID
        AND IFNULL(Cre.NumCreditos, Entero_Cero) BETWEEN Pun.RangoInferior AND Pun.RangoSuperior
        AND Pun.ConceptoCalifID = Con_A2;

    SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    INSERT INTO BITACORACALCLI	(
				Fecha,					Proceso,					Tiempo,					Empresa,					Usuario,
				FechaActual,			DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
	VALUES(
				Var_FechaSis,       Proceso_A2,         Var_MinutosBit, Par_EmpresaID,  Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );




    SET Var_FecBitaco   := NOW();
    TRUNCATE TMPCALIFCREDITOS;
    SET Var_FechaAnterior  := (SELECT DATE_SUB(Var_FechaSis, INTERVAL 3 YEAR));


    TRUNCATE TMPCALCRECLIENTE;

    INSERT INTO TMPCALCRECLIENTE (NumCreditos, ClienteID)
        SELECT COUNT(Cre.CreditoID), Cli.ClienteID
        FROM CREDITOS Cre,
             TMPCALIFCLIENTE Cli
        WHERE Cli.ClienteID = Cre.ClienteID
            AND Cre.FechaInicio BETWEEN Var_FechaAnterior AND Var_FechaSis
            AND  (Cre.Estatus = Credito_Pagado OR
                Cre.Estatus = Credito_Vigente OR
                Cre.Estatus = Credito_Vencido OR
                Cre.Estatus = Credito_Castigado)
            GROUP BY Cli.ClienteID;


    INSERT INTO TMPCALIFCREDITOSMOR (NumCreMoroso, ClienteID)
        SELECT MAX(Sal.DiasAtraso), Tmp.ClienteID
            FROM CREDITOS Cre,
                 TMPCALIFCLIENTE Tmp,
                 SALDOSCREDITOS Sal
            WHERE Tmp.ClienteID = Cre.ClienteID
              AND Cre.FechaInicio BETWEEN Var_FechaAnterior AND Var_FechaSis
              AND  (Cre.Estatus = Credito_Pagado OR
                    Cre.Estatus = Credito_Vigente OR
                    Cre.Estatus = Credito_Vencido OR
                    Cre.Estatus = Credito_Castigado)
              AND Cre.CreditoID = Sal.CreditoID
            GROUP BY Tmp.ClienteID
            HAVING MAX(Sal.DiasAtraso) > 30;


        UPDATE TMPCALIFCLIENTE Cli, TMPCALCRECLIENTE Cre, TMPCALIFCREDITOSMOR Mor, PUNTOSCONCEPTO Pun
        SET Cli.PuntosA3 = Pun.Puntos,
            Cli.TotalPuntos = Cli.TotalPuntos + Pun.Puntos
        WHERE Cli.clienteID = Cre.ClienteID
            AND  Cre.ClienteID = Mor.ClienteID
            AND ((IFNULL(Mor.NumCreMoroso,Entero_Cero) / IFNULL(Cre.NumCreditos, Entero_Cero)) * 100) BETWEEN
                    Pun.RangoInferior AND Pun.RangoSuperior
            AND ConceptoCalifID = Con_A3;


        UPDATE TMPCALIFCLIENTE SET PuntosA3 = 99 WHERE PuntosA3 >99;

    SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    INSERT INTO BITACORACALCLI	(
						Fecha,					Proceso,					Tiempo,					Empresa,					Usuario,
						FechaActual,			DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
                VALUES( Var_FechaSis,       Proceso_A3,         Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);



    SET Var_FecBitaco   := NOW();

    TRUNCATE TMPCALIFCREDITOS;
    TRUNCATE TMPCALCRECLIENTE;

    INSERT INTO TMPCALIFCREDITOS (CreditoID, ClienteID, Estatus, FechaInicio, FechTerminacion, FechaVencimien)
        SELECT Cre.CreditoID, Cli.ClienteID, Cre.Estatus, Cre.FechaInicio, Cre.FechTerminacion, Cre.FechaVencimien
            FROM CREDITOS Cre,
            TMPCALIFCLIENTE Cli
        WHERE Cli.ClienteID = Cre.ClienteID
            AND Cre.Estatus = Credito_Pagado;


    UPDATE TMPCALIFCLIENTE Tmp , (SELECT Cli.ClienteID, COUNT(Cre.CreditoID) AS Creditos
                                    FROM CREDITOS Cre,
                                         TMPCALIFCLIENTE Cli
                                    WHERE Cli.ClienteID = Cre.ClienteID
                                      AND Cre.Estatus = Credito_Pagado
                                      AND Cre.FechTerminacion < Cre.FechaVencimien
                                    GROUP BY Cli.ClienteID) AS Sub
    SET Tmp.PagoCredAntes = IFNULL(Sub.Creditos,Decimal_Cero)
    WHERE Tmp.ClienteID = Sub.ClienteID;

    UPDATE TMPCALIFCLIENTE Tmp , (SELECT Cli.ClienteID, COUNT(Cre.CreditoID) AS Creditos
                                    FROM CREDITOS Cre,
                                         TMPCALIFCLIENTE Cli
                                    WHERE Cli.ClienteID = Cre.ClienteID
                                    AND Cre.Estatus = Credito_Pagado
                                    AND Cre.FechTerminacion = Cre.FechaVencimien
                                    GROUP BY Cli.ClienteID) AS Sub
    SET Tmp.PagoCredEn = IFNULL(Sub.Creditos,Decimal_Cero)
    WHERE Tmp.ClienteID = Sub.ClienteID;

    UPDATE TMPCALIFCLIENTE Tmp , (SELECT Cli.ClienteID, COUNT(Cre.CreditoID) AS Creditos
                                    FROM CREDITOS Cre,
                                         TMPCALIFCLIENTE Cli
                                    WHERE Cli.ClienteID = Cre.ClienteID
                                    AND Cre.Estatus = Credito_Pagado
                                    AND Cre.FechTerminacion > Cre.FechaVencimien
                                    GROUP BY Cli.ClienteID) AS Sub
    SET Tmp.PagoCredDesp = IFNULL(Sub.Creditos,Decimal_Cero)
    WHERE Tmp.ClienteID = Sub.ClienteID;


    INSERT INTO TMPCALCRECLIENTE (ClienteID, PagoCredAntes, PagoCredEn, PagoCredDesp)
                            SELECT ClienteID,
                                IFNULL(ROUND((PagoCredAntes * 100 ) / (PagoCredAntes + PagoCredEn + PagoCredDesp) , 2) , Entero_Cero) AS Antes,
                                IFNULL(ROUND((PagoCredEn * 100 ) / (PagoCredAntes + PagoCredEn + PagoCredDesp) , 2) , Entero_Cero) AS En,
                                IFNULL(ROUND((PagoCredDesp * 100 ) / (PagoCredAntes + PagoCredEn + PagoCredDesp) , 2) , Entero_Cero) AS Despues
                            FROM TMPCALIFCLIENTE
                            WHERE (PagoCredAntes + PagoCredEn + PagoCredDesp) > 0;


    UPDATE TMPCALIFCLIENTE Cli, (SELECT Sub.ClienteID,Pun.Puntos
                                FROM PUNTOSCONCEPTO Pun, (SELECT ClienteID, CASE
                                                                WHEN PagoCredAntes > PagoCredEn AND PagoCredAntes > PagoCredDesp THEN PagoCredAntes
                                                                WHEN PagoCredEn > PagoCredAntes AND PagoCredEn > PagoCredDesp THEN PagoCredEn
                                                                WHEN PagoCredDesp > PagoCredAntes AND PagoCredDesp > PagoCredEn THEN PagoCredDesp
                                                                WHEN PagoCredAntes = PagoCredEn AND PagoCredAntes >= PagoCredDesp THEN PagoCredEn
                                                                WHEN PagoCredAntes = PagoCredDesp AND PagoCredAntes >= PagoCredEn THEN PagoCredEn
                                                                WHEN PagoCredEn > PagoCredDesp AND PagoCredEn >= PagoCredAntes THEN PagoCredEn
                                                                ELSE PagoCredEn
                                                                END AS Mayor
                                                            FROM TMPCALCRECLIENTE) AS Sub
                                WHERE Pun.ConceptoCalifID = Con_A4
                                AND Sub.Mayor BETWEEN Pun.RangoInferior AND Pun.RangoSuperior) AS Sub
    SET PuntosA4 = IFNULL(Sub.Puntos , Decimal_Cero ),
        TotalPuntos = Cli.TotalPuntos +  IFNULL(Sub.Puntos , Decimal_Cero)
    WHERE Cli.ClienteID = Sub.ClienteID;

    SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    INSERT INTO BITACORACALCLI	(
						Fecha,					Proceso,					Tiempo,					Empresa,					Usuario,
						FechaActual,			DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
                VALUES( Var_FechaSis,       Proceso_A4,         Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);



    SET Var_FecBitaco   := NOW();

    CALL DIASFESTIVOSCAL(
            Var_FechaSis,       Un_DiaHabil,        Var_FechaSig,           Es_DiaHabil,        Par_EmpresaID,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);
    IF(MONTH(Var_FechaSis) != MONTH(Var_FechaSig))THEN
        SET Var_FechaAnterior := (SELECT DATE_SUB(Var_FechaSis, INTERVAL 3 YEAR));
    ELSE
        SET Var_FechaAnterior := (SELECT DATE_SUB(Var_FechaSis, INTERVAL '3-1' YEAR_MONTH));
    END IF;

    TRUNCATE TMPCALIFCUENTASAHO;

    SELECT Par.CtaOrdinaria INTO Var_CtaOrdinaria
        FROM PARAMETROSCAJA Par;


    INSERT INTO TMPCALIFCUENTASAHO (CuentaAhoID, ClienteID, SaldoProm)
        SELECT Entero_Cero, Cue.ClienteID, SUM(IFNULL(Cue.SaldoProm, Entero_Cero))
        FROM `HIS-CUENTASAHO` Cue,
              TMPCALIFCLIENTE Cli
        WHERE Cue.ClienteID = Cli.ClienteID
          AND Cue.TipoCuentaID = Var_CtaOrdinaria
          AND (Cue.Fecha BETWEEN Var_FechaAnterior AND Var_FechaSis)
        GROUP BY Cue.ClienteID;


    UPDATE TMPCALIFCLIENTE Cli, PUNTOSCONCEPTO Pun, TMPCALIFCUENTASAHO Sub SET
        Cli.PuntosM1 = Pun.Puntos,
        Cli.TotalPuntos = Cli.TotalPuntos + Pun.Puntos

        WHERE Cli.ClienteID = Sub.ClienteID
            AND CASE
                    WHEN ((Var_SaldoPromGen / (IFNULL(Sub.SaldoProm, Decimal_Cero ) / Numero_Meses)) * 100) > 100
                        THEN 100.00 BETWEEN Pun.RangoInferior AND Pun.RangoSuperior
                    ELSE
                        ((Var_SaldoPromGen / (IFNULL(Sub.SaldoProm, Decimal_Cero ) / Numero_Meses)) * 100) BETWEEN Pun.RangoInferior AND Pun.RangoSuperior
                END
            AND Pun.ConceptoCalifID = Con_M1;

    SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    INSERT INTO BITACORACALCLI	(
						Fecha,					Proceso,					Tiempo,					Empresa,					Usuario,
						FechaActual,			DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
                VALUES( Var_FechaSis,       Proceso_M1,         Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);



    SET Var_FecBitaco   := NOW();
    SET Var_FechaAnterior  := (SELECT DATE_SUB(Var_FechaSis, INTERVAL 3 YEAR));

    TRUNCATE TMPCALINTPAGA;


    INSERT INTO TMPCALINTPAGA (ClienteID, InteresPagado, InteresPonderado)
        SELECT Cli.ClienteID,
               SUM(IFNULL(Det.MontoIntOrd, Entero_Cero) + IFNULL(Det.MontoIntAtr, Entero_Cero) + IFNULL(Det.MontoIntVen, Entero_Cero)),
               (Var_InteresPromGen / SUM(IFNULL(Det.MontoIntOrd, Entero_Cero) +
                                         IFNULL(Det.MontoIntAtr, Entero_Cero) +
                                         IFNULL(Det.MontoIntVen, Entero_Cero)
                                         ) ) * 100
        FROM CREDITOS Cre,
             DETALLEPAGCRE Det,
             TMPCALIFCLIENTE Cli
        WHERE Cli.ClienteID = Cre.ClienteID
          AND Cre.FechaInicio BETWEEN Var_FechaAnterior AND Var_FechaSis
          AND Cre.CreditoID = Det.CreditoID
          AND ( (   IFNULL(Det.MontoIntOrd, Entero_Cero) +
                    IFNULL(Det.MontoIntAtr, Entero_Cero) +
                    IFNULL(Det.MontoIntVen, Entero_Cero)
                ) > Entero_Cero);


    UPDATE TMPCALINTPAGA SET
        InteresPonderado = 100
        WHERE InteresPonderado > 100;

    UPDATE TMPCALIFCLIENTE Cli, PUNTOSCONCEPTO Pun, TMPCALINTPAGA Sub SET
        Cli.PuntosM2 = Pun.Puntos,
        Cli.TotalPuntos = Cli.TotalPuntos + Pun.Puntos
        WHERE Cli.ClienteID = Sub.ClienteID
          AND Sub.InteresPonderado BETWEEN Pun.RangoInferior AND Pun.RangoSuperior
          AND Pun.ConceptoCalifID = Con_M2;

    SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    INSERT INTO BITACORACALCLI	(
						Fecha,					Proceso,					Tiempo,					Empresa,					Usuario,
						FechaActual,			DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
                VALUES( Var_FechaSis,       Proceso_M2,         Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


    SET Var_FecBitaco   := NOW();

    TRUNCATE TMPCALCRECLIENTE;

    INSERT INTO TMPCALCRECLIENTE (NumCreditos, ClienteID)
        SELECT IFNULL(COUNT(Cre.CreditoID), Entero_Cero), Tmp.ClienteID
            FROM TMPCALIFCLIENTE Tmp,
                 CREDITOS Cre,
                 REESTRUCCREDITO Res
            WHERE Tmp.ClienteID  = Cre.ClienteID
              AND Res.CreditoDestinoID = Cre.CreditoID
              AND Res.Origen = Tipo_Reestruc
              AND Res.EstatusReest = EstatusDesembolso
            GROUP BY Tmp.ClienteID;

    UPDATE TMPCALIFCLIENTE Cli, TMPCALCRECLIENTE Tem SET
        Cli.NumReestruc = Tem.NumCreditos
        WHERE Cli.ClienteID = Tem.ClienteID;


    UPDATE TMPCALIFCLIENTE Cli, PUNTOSCONCEPTO Pun
        SET Cli.PuntosB1 = IFNULL(Pun.Puntos, Decimal_Cero),
            Cli.TotalPuntos = Cli.TotalPuntos + Pun.Puntos
        WHERE NumReestruc BETWEEN Pun.RangoInferior AND Pun.RangoSuperior
         AND Pun.ConceptoCalifID = Con_B1;

    SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    INSERT INTO BITACORACALCLI	(
				Fecha,					Proceso,					Tiempo,					Empresa,					Usuario,
				FechaActual,			DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
	VALUES(
				Var_FechaSis,       Proceso_B1,         Var_MinutosBit, Par_EmpresaID,  Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );



    TRUNCATE TMPCALCRECLIENTE;

    INSERT INTO TMPCALCRECLIENTE (NumCreditos, ClienteID)
        SELECT IFNULL(COUNT(Cre.CreditoID), Entero_Cero), Tmp.ClienteID
            FROM TMPCALIFCLIENTE Tmp,
                 CREDITOS Cre,
                 REESTRUCCREDITO Res
            WHERE Tmp.ClienteID  = Cre.ClienteID
              AND Res.CreditoDestinoID = Cre.CreditoID
              AND Res.Origen = Tipo_Renova
              AND Res.EstatusReest = EstatusDesembolso
            GROUP BY Tmp.ClienteID;

    UPDATE TMPCALIFCLIENTE Cli, TMPCALCRECLIENTE Tem SET
        Cli.NumRenova = Tem.NumCreditos
        WHERE Cli.ClienteID = Tem.ClienteID;


    UPDATE TMPCALIFCLIENTE Cli, PUNTOSCONCEPTO Pun SET
        Cli.PuntosB2 = IFNULL(Pun.Puntos, Decimal_Cero),
        Cli.TotalPuntos = Cli.TotalPuntos + Pun.Puntos

        WHERE NumRenova BETWEEN Pun.RangoInferior AND Pun.RangoSuperior
          AND Pun.ConceptoCalifID = Con_B2;

    SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    INSERT INTO BITACORACALCLI	(
				Fecha,					Proceso,					Tiempo,					Empresa,					Usuario,
				FechaActual,			DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
	VALUES(
				Var_FechaSis,       Proceso_B2,         Var_MinutosBit, Par_EmpresaID,  Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);




    SET Var_FecBitaco   := NOW();

    SELECT MAX(Fec_UltAsamblea) INTO Fec_UltAsamblea
        FROM ASAMBLEAASISTE
        WHERE Fecha <= Var_FechaSis;

    SET Fec_UltAsamblea := IFNULL(Fec_UltAsamblea, Fecha_Vacia);


    UPDATE TMPCALIFCLIENTE Cli, ASAMBLEAASISTE Asa SET
        AsistenciaAsam   = Todas_Asistencia
        WHERE Cli.ClienteID = Asa.ClienteID
          AND Asa.Fecha = Fec_UltAsamblea
          AND Asa.AsistenciaReal = Si_AsisteAsa;

    UPDATE TMPCALIFCLIENTE Cli, PUNTOSCONCEPTO Pun SET
        Cli.PuntosB3 = IFNULL(Pun.Puntos, Decimal_Cero),
        Cli.TotalPuntos = Cli.TotalPuntos + Pun.Puntos

        WHERE AsistenciaAsam BETWEEN Pun.RangoInferior AND Pun.RangoSuperior
          AND Pun.ConceptoCalifID = Con_B3;

    SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    INSERT INTO BITACORACALCLI	(
						Fecha,					Proceso,					Tiempo,					Empresa,					Usuario,
						FechaActual,			DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
                VALUES( Var_FechaSis,       Proceso_B3,         Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);








    SET Var_FecBitaco   := NOW();
    TRUNCATE CALIFICACIONCLI;

    INSERT INTO CALIFICACIONCLI(ClienteID,          Fecha,              Antiguedad,             Creditos,               Morosidad,
                                FormaPago,          AhorroNeto,         PromedioInteres,        Reestructuras,          Renovaciones,
                                AsisteAsamblea ,    Calificacion,       ClasificaCliID,         EmpresaID,              Usuario,
                                FechaActual,        DireccionIP,        ProgramaID,             Sucursal,               NumTransaccion)
        SELECT                  Tmp.ClienteID,       Var_FechaSis,      Tmp.PuntosA1,           Tmp.PuntosA2,           Tmp.PuntosA3,
                                Tmp.PuntosA4,        Tmp.PuntosM1,      Tmp.PuntosM2,           Tmp.PuntosB3,           Tmp.PuntosB2,
                                Tmp.PuntosB3,        Tmp.TotalPuntos,   Cla.ClasificaCliID,     Par_EmpresaID,          Aud_Usuario,
                                Aud_FechaActual,     Aud_DireccionIP,   Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
        FROM TMPCALIFCLIENTE Tmp,
                CLASIFICACIONCLI    Cla
                WHERE Tmp.TotalPuntos BETWEEN Cla.RangoInferior AND Cla.RangoSuperior;



     UPDATE CLIENTES Cli, CALIFICACIONCLI Cal, CLASIFICACIONCLI Cla
        SET Cli.CalificaCredito = IFNULL(Cla.Clasificacion,No_Asignada)
        WHERE Cli.ClienteID = Cal.ClienteID
            AND Cal.ClasificaCliID = Cla.ClasificaCliID;

    SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    INSERT INTO BITACORACALCLI	(
						Fecha,					Proceso,					Tiempo,					Empresa,					Usuario,
						FechaActual,			DireccionIP,				ProgramaID,				Sucursal,					NumTransaccion)
                VALUES( Var_FechaSis,       Proceso_Calif,      Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


    SET Par_NumErr  := '000';
    SET Par_ErrMen  := 'Calificacion Asignada Exitosamente';
    SET varControl  := 'clienteID' ;
    LEAVE ManejoErrores;

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen          AS ErrMen,
                varControl          AS control,
                ''      AS consecutivo;
    END IF;

END TerminaStore$$
