-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA041900006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA041900006REP`;
DELIMITER $$

CREATE PROCEDURE `REGA041900006REP`(
# ============================================================================================================
# ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE R0419 SOCAP ------------------------------------
# ============================================================================================================
    Par_Fecha           DATETIME,               # Fecha del reporte
    Par_NumReporte      TINYINT UNSIGNED,       # Tipo de reporte 1: Excel 2: CVS
    Par_NumDecimales    INT,                    # Numero de Decimales en Cantidades o Montos

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_ClaveEntidad    VARCHAR(300);   -- Clave de la Entidad de la institucion
    DECLARE Var_Periodo         CHAR(6);        -- Periodo al que pertenece el reporte anio+mes
    DECLARE Var_UltFecEPRC      DATE;           -- Fecha del ultima de estimaciones preventivas
    DECLARE Var_FecIniMes       DATE;
    DECLARE Var_FecAntRes       DATE;
    DECLARE Var_FecActRes       DATE;
    DECLARE Var_MinCenCos       INT;
    DECLARE Var_MaxCenCos       INT;
    DECLARE Var_EPRCInicial     DECIMAL(18,2);
    DECLARE Var_EPRCFinal       DECIMAL(18,2);
    DECLARE Var_UltPeriodoCie   INT;
    DECLARE Var_UltEjercicioCie INT;
    DECLARE Par_FecMesAnterior  DATE;
    DECLARE Var_AntPeriodoCie   INT;
    DECLARE Var_AntEjercicioCie INT;


    -- Declaracion de Constantes
    DECLARE Entero_Cero         INT;
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Si_AplicaConta      CHAR(1);
    DECLARE Rep_Excel           INT;
    DECLARE Rep_Csv             INT;
    DECLARE Folio_Form          CHAR(4);
    DECLARE Tipo_Moneda         INT;
    DECLARE Tipo_Cartera        INT;
    DECLARE Cta_ContaEPRC       VARCHAR(25);
    DECLARE Ubi_Actual          CHAR(1);
    DECLARE Por_Fecha           CHAR(1);
    DECLARE Est_Cerrado         CHAR(1);
    DECLARE Concepto_Final      CHAR(12);
    DECLARE Concepto_Inicia     CHAR(12);
    DECLARE Tipo_Socap          INT;
    DECLARE Nivel_Detalle       CHAR(1);
    DECLARE Nivel_Encabezado    CHAR(1);


    -- Asignacion de Constantes
    SET Entero_Cero         := 0;
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Si_AplicaConta      := 'S';
    SET Rep_Excel           :=  1;              -- Opcion de Reporte para excel
    SET Rep_Csv             :=  2;              -- Opcion de Reporte para CVS
    SET Folio_Form          :=  '419';          -- Folio del Formulario
    SET Tipo_Moneda         :=  14;             -- Tipo Moneda
    SET Tipo_Cartera        :=  10;             -- Tipo Cartera
    SET Ubi_Actual          := 'A';             -- Ubicacion Actual
    SET Por_Fecha           := 'D';             -- Consulta a una Fecha o Dia Especifico
    SET Est_Cerrado         := 'C';             -- Estatus del Periodo Cerrado
    SET Concepto_Final      := '139000000000';  -- Clave del Concepto de Saldo de la EPRC Final
    SET Concepto_Inicia     := '139200000000';  -- Clave del Concepto de Saldo de la EPRC Inicial
    SET Nivel_Detalle       := 'D';
    SET Nivel_Encabezado    := 'E';
    SET Tipo_Socap          := 6; -- Formato tipo SOFIPO

    SELECT CuentaEprc INTO Cta_ContaEPRC FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID; -- Cuenta Contable de la EPRC

    SET Cta_ContaEPRC := CONCAT(IFNULL(Cta_ContaEPRC,Cadena_Vacia),'%');

    SET Var_Periodo = CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),1,4),
                              SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),5,2));

    SET Var_ClaveEntidad    := IFNULL((SELECT Ins.ClaveEntidad
                                        FROM PARAMETROSSIS Par,
                                             INSTITUCIONES Ins
                                        WHERE Par.InstitucionID = Ins.InstitucionID), CADENA_VACIA);

    SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
        FROM CENTROCOSTOS;

    -- -----------------------------------------------------------------
    -- Saldo de la EPRC Final
    -- ----------------------------------------------------------------

    SELECT  MAX(EjercicioID) INTO Var_UltEjercicioCie
        FROM PERIODOCONTABLE Per
        WHERE Per.Fin   <= Par_Fecha
          AND Per.Estatus = Est_Cerrado;

    SET Var_UltEjercicioCie    := IFNULL(Var_UltEjercicioCie, Entero_Cero);

    IF(Var_UltEjercicioCie != Entero_Cero) THEN
        SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
            FROM PERIODOCONTABLE Per
            WHERE Per.EjercicioID   = Var_UltEjercicioCie
              AND Per.Estatus = Est_Cerrado
              AND Per.Fin   <= Par_Fecha;
    END IF;

    SET Var_UltPeriodoCie    := IFNULL(Var_UltPeriodoCie, Entero_Cero);


    CALL `EVALFORMULACONTAPRO`(
        Cta_ContaEPRC,      Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
        Var_UltPeriodoCie,  Par_Fecha,      Var_EPRCFinal,      Var_MinCenCos,      Var_MaxCenCos,
        Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion  );

    -- -----------------------------------------------------------------
    -- Saldo de la EPRC Inicial, la Final del Mes Anterior
    -- -----------------------------------------------------------------

    SET Par_FecMesAnterior := DATE_ADD(Par_Fecha, INTERVAL DAY(Par_Fecha)*-1  DAY);

    SELECT  MAX(EjercicioID) INTO Var_AntEjercicioCie
        FROM PERIODOCONTABLE Per
        WHERE Per.Fin   <= Par_FecMesAnterior
          AND Per.Estatus = Est_Cerrado;

    SET Var_AntEjercicioCie    := IFNULL(Var_AntEjercicioCie, Entero_Cero);

    IF(Var_AntEjercicioCie != Entero_Cero) THEN
        SELECT  MAX(PeriodoID) INTO Var_AntPeriodoCie
            FROM PERIODOCONTABLE Per
            WHERE Per.EjercicioID   = Var_AntEjercicioCie
              AND Per.Estatus = Est_Cerrado
              AND Per.Fin   <= Par_FecMesAnterior;
    END IF;

    SET Var_AntPeriodoCie    := IFNULL(Var_AntPeriodoCie, Entero_Cero);


    CALL `EVALFORMULACONTAPRO`(
        Cta_ContaEPRC,      Ubi_Actual,             Por_Fecha,          Par_FecMesAnterior,         Var_AntEjercicioCie,
        Var_AntPeriodoCie,  Par_FecMesAnterior,     Var_EPRCInicial,    Var_MinCenCos,              Var_MaxCenCos,
        Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,            Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion  );

    -- Temporal para Creditos Castigados en el Mes
    DROP TABLE IF EXISTS TMP419_CASTIGOS;

    CREATE TEMPORARY TABLE TMP419_CASTIGOS(
        CreditoID           BIGINT(12),
        Clasificacion       CHAR(2),
        SubClasificacionID  INT,
        DescriSubClasific   VARCHAR(250),

        EPRC_Capital        DECIMAL(14,2),
        EPRC_Interes        DECIMAL(14,2),
        EPRC_Adicional      DECIMAL(14,2),

        INDEX TMP419_CASTIGOS_idx1 (Clasificacion, SubClasificacionID)
        );

    -- Temporal para EPRC Mes Actual
    DROP TABLE IF EXISTS TMP419_EPRCACTUAL;

    CREATE TEMPORARY TABLE TMP419_EPRCACTUAL(
        CreditoID           BIGINT(12),
        EstatusCredito      CHAR(1),
        Clasificacion       CHAR(2),
        SubClasificacionID  INT,
        DescriSubClasific   VARCHAR(250),

        EPRC_Capital        DECIMAL(14,2),
        EPRC_Interes        DECIMAL(14,2),
        EPRC_Adicional      DECIMAL(14,2),

        INDEX TMP419_EPRCACTUAL_idx1 (Clasificacion, SubClasificacionID),
        INDEX TMP419_EPRCACTUAL_idx2 (CreditoID)
        );


    -- Temporal para EPRC Mes Anterior
    DROP TABLE IF EXISTS TMP419_EPRCANTERIOR;

    CREATE TEMPORARY TABLE TMP419_EPRCANTERIOR(
        CreditoID           BIGINT(12),
        EstatusCredito      CHAR(1),
        Clasificacion       CHAR(2),
        SubClasificacionID  INT,
        DescriSubClasific   VARCHAR(250),

        EPRC_Capital        DECIMAL(14,2),
        EPRC_Interes        DECIMAL(14,2),
        EPRC_Adicional      DECIMAL(14,2),

        INDEX TMP419_EPRCANTERIOR_idx1 (Clasificacion, SubClasificacionID),
        INDEX TMP419_EPRCANTERIOR_idx2 (CreditoID)
        );


    SET Var_FecIniMes = DATE_ADD(Par_Fecha, INTERVAL -1 *(DAY(Par_Fecha)) + 1 DAY);


    SELECT  MAX(Fecha) INTO Var_FecAntRes
        FROM CALRESCREDITOS
        WHERE Fecha < Par_Fecha
          AND AplicaConta = Si_AplicaConta;

    SET Var_FecAntRes := IFNULL(Var_FecAntRes, Fecha_Vacia);

    SELECT  MAX(Fecha) INTO Var_FecActRes
        FROM CALRESCREDITOS
        WHERE Fecha <= Par_Fecha
          AND AplicaConta = Si_AplicaConta;

    SET Var_FecActRes := IFNULL(Var_FecActRes, Fecha_Vacia);

    INSERT INTO TMP419_CASTIGOS
        SELECT  Cas.CreditoID,
                Cla.TipoClasificacion, Cla.ClasificacionID,
                Cla.DescripClasifica,
                Epr.Reserva - Epr.ReservaInteres,
                Epr.ReservaInteres,
                IFNULL(Cre.SaldoMoraVencido, Entero_Cero)  + IFNULL(SalIntVencido, Entero_Cero)

            FROM CRECASTIGOS Cas,
                 SALDOSCREDITOS Cre,
                 DESTINOSCREDITO Des,
                 CLASIFICCREDITO Cla,
                 CALRESCREDITOS Epr
            WHERE Cas.Fecha BETWEEN Var_FecIniMes AND Par_Fecha
              AND Cas.CreditoID = Cre.CreditoID
              AND Cre.FechaCorte = Var_FecAntRes
              AND Cre.DestinoCreID = Des.DestinoCreID
              AND Des.SubClasifID = Cla.ClasificacionID
              AND Epr.CreditoID = Cas.CreditoID
              AND Epr.Fecha = Var_FecAntRes;
        -- GROUP BY Cla.ClasificacionID;



    -- EPRC del Mes Anterior
    INSERT INTO TMP419_EPRCANTERIOR
        SELECT  Cre.CreditoID, Cre.EstatusCredito,
                Cla.TipoClasificacion, Cla.ClasificacionID,
                Cla.DescripClasifica,
                Epr.Reserva - Epr.ReservaInteres,
                Epr.ReservaInteres,
                IFNULL(Cre.SaldoMoraVencido, Entero_Cero)  + IFNULL(SalIntVencido, Entero_Cero)

            FROM SALDOSCREDITOS Cre,
                 DESTINOSCREDITO Des,
                 CLASIFICCREDITO Cla,
                 CALRESCREDITOS Epr
            WHERE Cre.FechaCorte = Var_FecAntRes
              AND Cre.DestinoCreID = Des.DestinoCreID
              AND Des.SubClasifID = Cla.ClasificacionID
              AND Epr.CreditoID = Cre.CreditoID
              AND Epr.Fecha = Var_FecAntRes;

    -- EPRC del Mes Actual
    INSERT INTO TMP419_EPRCACTUAL
        SELECT  Cre.CreditoID,  Cre.EstatusCredito,
                Cla.TipoClasificacion, Cla.ClasificacionID,
                Cla.DescripClasifica,
                Epr.Reserva - Epr.ReservaInteres,
                Epr.ReservaInteres,
                IFNULL(Cre.SaldoMoraVencido, Entero_Cero)  + IFNULL(SalIntVencido, Entero_Cero)

            FROM SALDOSCREDITOS Cre,
                 DESTINOSCREDITO Des,
                 CLASIFICCREDITO Cla,
                 CALRESCREDITOS Epr
            WHERE Cre.FechaCorte = Var_FecActRes
              AND Cre.DestinoCreID = Des.DestinoCreID
              AND Des.SubClasifID = Cla.ClasificacionID
              AND Epr.CreditoID = Cre.CreditoID
              AND Epr.Fecha = Var_FecActRes;

    -- ----------------------------------------------------------------------
    -- Disminucion de la Reserva, El Actual menos el Anterior es Negativo
    -- El Actual menos el Anterior es Igual y Disminuye la EPRC Adicional
    -- ----------------------------------------------------------------------

    DROP TABLE IF EXISTS TMP419_DISMINUCION;

    CREATE TEMPORARY TABLE TMP419_DISMINUCION(
        SubClasificacionID  INT,
        EPRC_Calificacion   DECIMAL(14,2),
        EPRC_Adicional      DECIMAL(14,2),

        INDEX TMP419_DISMINUCION_idx1 (SubClasificacionID)
        );

    INSERT INTO TMP419_DISMINUCION
        SELECT Ant.SubClasificacionID,
               SUM( (   IFNULL(Act.EPRC_Capital, Entero_Cero) +
                        IFNULL(Act.EPRC_Interes, Entero_Cero)   ) -

                    (   IFNULL(Ant.EPRC_Capital, Entero_Cero) +
                        IFNULL(Ant.EPRC_Interes, Entero_Cero)   )
                  ),
                SUM(IFNULL(Act.EPRC_Adicional, Entero_Cero) -
                    IFNULL(Ant.EPRC_Adicional, Entero_Cero))

            FROM TMP419_EPRCANTERIOR Ant
            LEFT OUTER JOIN  TMP419_EPRCACTUAL  Act ON Act.CreditoID = Ant.CreditoID
            LEFT OUTER JOIN TMP419_CASTIGOS Cas ON Cas.CreditoID = Ant.CreditoID

                WHERE ( (   (   IFNULL(Act.EPRC_Capital, Entero_Cero) +             -- Si EPRC de la Calificacion anterior es Mayor
                                IFNULL(Act.EPRC_Interes, Entero_Cero)   ) -

                            (   IFNULL(Ant.EPRC_Capital, Entero_Cero) +
                                IFNULL(Ant.EPRC_Interes, Entero_Cero)   )
                        ) < Entero_Cero OR

                        (   (   IFNULL(Act.EPRC_Adicional, Entero_Cero) -               -- Si la EPRC Adicional anterior es Mayor
                                IFNULL(Ant.EPRC_Adicional, Entero_Cero) ) < Entero_Cero -- Y
                            AND
                            (   (   IFNULL(Act.EPRC_Capital, Entero_Cero) +             -- La EPRC de la Calificacion anterior es igual a la actual.
                                    IFNULL(Act.EPRC_Interes, Entero_Cero)   ) -

                                (   IFNULL(Ant.EPRC_Capital, Entero_Cero) +
                                    IFNULL(Ant.EPRC_Interes, Entero_Cero)   )
                            ) = Entero_Cero
                        )
                      )

                AND IFNULL(Cas.Clasificacion, Cadena_Vacia) = Cadena_Vacia
            GROUP BY Ant.SubClasificacionID;

    -- ----------------------------------------------------------------------
    -- Aumento de la Reserva, El Actual menos el Anterior es Positivo
    -- El Actual menos el Anterior es Igual y Disminuye la EPRC Adicional
    -- ----------------------------------------------------------------------

    DROP TABLE IF EXISTS TMP419_AUMENTO;

    CREATE TEMPORARY TABLE TMP419_AUMENTO(
        SubClasificacionID  INT,
        EPRC_Calificacion   DECIMAL(14,2),
        EPRC_Adicional      DECIMAL(14,2),

        INDEX TMP419_AUMENTO_idx1 (SubClasificacionID)
        );

    INSERT INTO TMP419_AUMENTO
        SELECT Act.SubClasificacionID,
               SUM( (   IFNULL(Act.EPRC_Capital, Entero_Cero) +
                        IFNULL(Act.EPRC_Interes, Entero_Cero)   ) -

                    (   IFNULL(Ant.EPRC_Capital, Entero_Cero) +
                        IFNULL(Ant.EPRC_Interes, Entero_Cero)   )
                  ),
                SUM(IFNULL(Act.EPRC_Adicional, Entero_Cero) -
                    IFNULL(Ant.EPRC_Adicional, Entero_Cero))

            FROM TMP419_EPRCACTUAL  Act
            LEFT OUTER JOIN TMP419_EPRCANTERIOR Ant ON Act.CreditoID = Ant.CreditoID
            LEFT OUTER JOIN TMP419_CASTIGOS Cas ON Cas.CreditoID = Ant.CreditoID

                WHERE ( (   (   IFNULL(Act.EPRC_Capital, Entero_Cero) +             -- Si EPRC de la Calificacion Actual es Mayor
                                IFNULL(Act.EPRC_Interes, Entero_Cero)   ) -

                            (   IFNULL(Ant.EPRC_Capital, Entero_Cero) +
                                IFNULL(Ant.EPRC_Interes, Entero_Cero)   )
                        ) > Entero_Cero OR

                        (   (   IFNULL(Act.EPRC_Adicional, Entero_Cero) -               -- Si la EPRC Adicional anterior es Mayor
                                IFNULL(Ant.EPRC_Adicional, Entero_Cero) ) > Entero_Cero -- Y
                            AND
                            (   (   IFNULL(Act.EPRC_Capital, Entero_Cero) +             -- La EPRC de la Calificacion anterior es igual a la actual.
                                    IFNULL(Act.EPRC_Interes, Entero_Cero)   ) -

                                (   IFNULL(Ant.EPRC_Capital, Entero_Cero) +
                                    IFNULL(Ant.EPRC_Interes, Entero_Cero)   )
                            ) = Entero_Cero
                        )
                      )

                AND IFNULL(Cas.Clasificacion, Cadena_Vacia) = Cadena_Vacia

            GROUP BY Act.SubClasificacionID;

    -- Vamos Borrando las Temporales que ya no se usen
    DROP TABLE IF EXISTS TMP419_EPRCANTERIOR;
    DROP TABLE IF EXISTS TMP419_EPRCACTUAL;

    -- Castigos Agrupado por Sub Clasificacion
    DROP TABLE IF EXISTS TMP419_CASTIGOS_SUBCLASIF;

    CREATE TEMPORARY TABLE TMP419_CASTIGOS_SUBCLASIF(
        SubClasificacionID  INT,
        Monto_EPRC          DECIMAL(16,2),

        INDEX TMP419_CASTIGOS_SUBCLASIF_idx1 (SubClasificacionID)
        );

    INSERT INTO TMP419_CASTIGOS_SUBCLASIF
        SELECT  SubClasificacionID,
                SUM(EPRC_Capital + EPRC_Interes + EPRC_Adicional)
            FROM TMP419_CASTIGOS
            GROUP BY SubClasificacionID;

    -- Vamos Borrando las Temporales que ya no se usen
    DROP TABLE IF EXISTS TMP419_CASTIGOS;

    -- ------------------------------------------------------

    DROP TABLE IF EXISTS TMP_CATCONCREGULA419;

    CREATE TEMPORARY TABLE TMP_CATCONCREGULA419(
        `ConceptoID`        INT(11),
        `CuentaMayor`       VARCHAR(45),
        `ClaveConcepto`     VARCHAR(45),
        `Descripcion`       VARCHAR(400),
        `Monto`             DECIMAL(16,2),
        `Orden`             INT(11),
        `Nivel`             CHAR(1),
        `ClasificacionID`   INT(11),
        `TipoSaldo`         INT(11),

        INDEX TMP_CATCONCREGULA419_idx1 (ClaveConcepto),
        INDEX TMP_CATCONCREGULA419_idx2 (CuentaMayor),
        INDEX TMP_CATCONCREGULA419_idx3 (ClasificacionID)
        );

    INSERT INTO TMP_CATCONCREGULA419
        SELECT  ConceptoID, CuentaMayor,    ClaveConcepto,      Descripcion,    Entero_Cero,
                Orden,      Nivel,          ClasificacionID,    TipoSaldo
            FROM CATCONCREGULA419
            WHERE TipoInstitID = Tipo_Socap
            ORDER BY Orden;

    -- Actualizamos en la Tabla Temporal Principal, el monto de los Castigos
    UPDATE TMP_CATCONCREGULA419 Reg,
           TMP419_CASTIGOS_SUBCLASIF Cas SET

        Reg.Monto = Cas.Monto_EPRC
        WHERE Reg.ClasificacionID = Cas.SubClasificacionID
          AND Reg.CuentaMayor LIKE '11%';

    -- Vamos Borrando las Temporales que ya no se usen
    DROP TABLE IF EXISTS TMP419_CASTIGOS_SUBCLASIF;


    -- Actualizamos en la Tabla Temporal Principal, el monto de los CARGOS
    -- O Disminuciones de EPRC por Pagos de Credito
    UPDATE TMP_CATCONCREGULA419 Reg,
           TMP419_DISMINUCION Dis SET

        Reg.Monto = ABS(Dis.EPRC_Calificacion + Dis.EPRC_Adicional)
        WHERE Reg.ClasificacionID = Dis.SubClasificacionID
          AND Reg.CuentaMayor LIKE '14%';

    -- Vamos Borrando las Temporales que ya no se usen
    DROP TABLE IF EXISTS TMP419_DISMINUCION;

    -- Actualizamos en la Tabla Temporal Principal, el monto de los ABONOS
    -- O Auments de EPRC por la Calificacion de la Cartera
    UPDATE TMP_CATCONCREGULA419 Reg,
           TMP419_AUMENTO Aum SET

        Reg.Monto = ABS(Aum.EPRC_Calificacion)
        WHERE Reg.ClasificacionID = Aum.SubClasificacionID
          AND Reg.CuentaMayor LIKE '21%';

    -- Actualizamos en la Tabla Temporal Principal, el monto de los ABONOS
    -- O Auments de EPRC Adicional
    UPDATE TMP_CATCONCREGULA419 Reg,
           TMP419_AUMENTO Aum SET

        Reg.Monto = ABS(Aum.EPRC_Adicional)
        WHERE Reg.ClasificacionID = Aum.SubClasificacionID
          AND Reg.CuentaMayor LIKE '22%';

    -- Vamos Borrando las Temporales que ya no se usen
    DROP TABLE IF EXISTS TMP419_AUMENTO;

    -- PARA EL MANEJO DE LOS CONCEPTOS AGRUPADORES
    DROP TABLE IF EXISTS TMP_CTASMAYORREG419;

    CREATE TEMPORARY TABLE TMP_CTASMAYORREG419(
        `ConceptoID`        INT(11),
        `CuentaMayor`       VARCHAR(45),
        `ClaveConcepto`     VARCHAR(45),
        `Descripcion`       VARCHAR(400),
        `Monto`             DECIMAL(16,2),
        `Orden`             INT(11),
        `Nivel`             CHAR(1),
        `ClasificacionID`   INT(11),

      INDEX TMP_CTASMAYORREG419_idx1 (ClaveConcepto)
    );

    -- Actualizamos los Conceptos Agrupadores
    INSERT INTO TMP_CTASMAYORREG419
        SELECT  ConceptoID,     CuentaMayor,    ClaveConcepto,  Descripcion,    Monto,
                Orden,          Nivel,          ClasificacionID

            FROM TMP_CATCONCREGULA419
            WHERE Nivel = Nivel_Detalle;

    UPDATE TMP_CATCONCREGULA419 Reg SET
        Reg.Monto = (SELECT SUM(Det.Monto)
                        FROM TMP_CTASMAYORREG419 Det
                        WHERE Det.Nivel = Nivel_Detalle
                          AND Det.CuentaMayor LIKE CONCAT(Reg.CuentaMayor, '%')
                    )

        WHERE Reg.Nivel = Nivel_Encabezado;

    -- Actualizamos la EPRC Final.
    UPDATE TMP_CATCONCREGULA419 SET
        Monto = Var_EPRCFinal * -1
        WHERE ClaveConcepto = Concepto_Final;

    -- Actualizamos la EPRC Inicial.
    UPDATE TMP_CATCONCREGULA419 SET
        Monto = Var_EPRCInicial * -1
        WHERE ClaveConcepto = Concepto_Inicia;

    -- ------------------------------------------------
    IF( Par_NumReporte = Rep_Excel) THEN
        SELECT  Var_Periodo AS Periodo, Var_ClaveEntidad AS ClaveEntidad,
                Folio_Form AS SubReporte,
                Tmp.ClaveConcepto,  Tmp.Descripcion,
                Folio_Form AS Formulario,
                Tipo_Moneda AS TipoMoneda,
                Tipo_Cartera AS TipoCartera,
                Tmp.TipoSaldo,
                ROUND(IFNULL(Tmp.Monto, Entero_Cero), Par_NumDecimales) AS Monto
            FROM  TMP_CATCONCREGULA419 Tmp, CATCONCREGULA419 Cat
            WHERE Tmp.ConceptoID = Cat.ConceptoID
            AND Cat.TipoInstitID = Tipo_Socap
            ORDER BY Tmp.Orden;

    ELSE
        IF( Par_NumReporte = Rep_Csv) THEN
            SELECT  CONCAT(ClaveConcepto,';',Folio_Form,';',Tipo_Moneda,';',
                            Tipo_Cartera,';',TipoSaldo,';', ROUND(IFNULL(Monto,Entero_Cero),0)) AS Renlgon
            FROM  TMP_CATCONCREGULA419
            ORDER BY Orden;
        END IF;
    END IF;


    --  Borrado de las Temporales
    DROP TABLE IF EXISTS TMP_CATCONCREGULA419;
    DROP TABLE IF EXISTS TMP_CTASMAYORREG419;


END TerminaStore$$