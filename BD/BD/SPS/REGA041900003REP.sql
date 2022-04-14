-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA041900003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA041900003REP`;
DELIMITER $$


CREATE PROCEDURE `REGA041900003REP`(
-- ============================================================================================================
-- ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE R0419 SOFIPO------------------------------------------
-- ============================================================================================================
    Par_Fecha           DATE,               -- Fecha del reporte
    Par_NumReporte      TINYINT UNSIGNED,       -- Tipo de reporte 1: Excel 2: CVS
    Par_NumDecimales    INT,                    -- Numero de Decimales en Cantidades o Montos

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
    DECLARE Var_FecCierre       DATE;
    DECLARE Var_FecAntRes       DATE;
    DECLARE Var_FecActRes       DATE;
    DECLARE Var_MinCenCos       INT;
    DECLARE Var_MaxCenCos       INT;
    DECLARE Var_EPRCInicial     DECIMAL(18,2);
    DECLARE Var_EPRCFinal       DECIMAL(18,2);
    DECLARE Var_EPRCFinalRep       DECIMAL(18,2);
    DECLARE Var_EPRCFinalDifer     DECIMAL(18,2);
    DECLARE Var_EPRCAdicional   DECIMAL(18,2);
    DECLARE Var_UltPeriodoCie   INT;
    DECLARE Var_UltEjercicioCie INT;
    DECLARE Par_FecMesAnterior  DATE;
    DECLARE Var_AntPeriodoCie   INT;
    DECLARE Var_AntEjercicioCie INT;
    DECLARE Var_FechaHisSaldo   DATE;
    DECLARE Var_AjusteSaldo     CHAR(1);


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

    DECLARE Clas_Quirografarios  INT;
    DECLARE Clas_Prendarios      INT;
    DECLARE Clas_Puente          INT;
    DECLARE Clas_Comerciales     INT;

    DECLARE Clas_QuirografaOtr  INT;
    DECLARE Clas_PrendariosOtr  INT;
    DECLARE Clas_PuenteOtr      INT;
    DECLARE Clas_ComercialesOtr INT;

    DECLARE Clas_MediaResiden   INT;
    DECLARE Clas_IntSocial      INT;
    DECLARE Clas_MedResSinGar   INT;
    DECLARE Clas_MedResConGar   INT;
    DECLARE Clas_IntSocSinGar   INT;
    DECLARE Clas_IntSocConGar   INT;
    DECLARE Tipo_Sofipo         INT;

    DECLARE Clas_Vivienda       CHAR(1);
    DECLARE Clas_Consumo        CHAR(1);
    DECLARE Clas_Comercial      CHAR(1);
    DECLARE Nivel_Detalle       CHAR(1);
    DECLARE Nivel_Encabezado    CHAR(1);

    -- Asignacion de Constantes
    SET Entero_Cero     := 0;
    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Si_AplicaConta  := 'S';
    SET Rep_Excel       :=  1;              -- Opcion de Reporte para excel
    SET Rep_Csv         :=  2;              -- Opcion de Reporte para CVS
    SET Folio_Form      :=  '419';          -- Folio del Formulario
    SET Tipo_Moneda     :=  14;             -- Tipo Moneda
    SET Tipo_Cartera    :=  10;             -- Tipo Cartera
    SET Ubi_Actual      := 'A';             -- Ubicacion Actual
    SET Por_Fecha       := 'D';             -- Consulta a una Fecha o Dia Especifico
    SET Est_Cerrado     := 'C';             -- Estatus del Periodo Cerrado
    SET Concepto_Final  := '139000000000';  -- Clave del Concepto de Saldo de la EPRC Final
    SET Concepto_Inicia := '139200000000';  -- Clave del Concepto de Saldo de la EPRC Inicial

    SET Clas_Quirografarios     := 41103;   -- Clasificacion Quirografarios
    SET Clas_Prendarios         := 41104;   -- Clasificacion Prendarios
    SET Clas_Puente             := 41105;   -- Clasificacion Creditos Puente
    SET Clas_Comerciales        := 41102;   -- Clasificacion Cred. Comerciales
    SET Clas_QuirografaOtr      := 4110302; -- Clasificacion Otros Quirografarios
    SET Clas_PrendariosOtr      := 4110403; -- Clasificacion otros Prendarios
    SET Clas_PuenteOtr          := 4110502; -- Clasificacion Otros Cred. Puente
    SET Clas_ComercialesOtr     := 41108;   -- Clasificacion Otros Cred. Comerciales


    SET Clas_MediaResiden       := 41127;    -- Clasificacion Media y Residencial
    SET Clas_IntSocial          := 41128;    -- Clasificacion Interes Social
    SET Clas_MedResSinGar       := 4112702;  -- Clasificacion Media y Residencial sin garantia hipotecaria
    SET Clas_MedResConGar       := 4112701;  -- Clasificacion Media y Residencial con Garantia Hiportecaria
    SET Clas_IntSocSinGar       := 4112802;  -- Clasificacion Interes Social sin garantia hipotecaria
    SET Clas_IntSocConGar       := 4112801;  -- Clasificacion Interes Social con garantia hipotecaria


    SET Clas_Vivienda           := 'H';     -- Creditos hipotecarios
    SET Clas_Consumo            := 'O';     -- Creditos de Consumo
    SET Clas_Comercial          := 'C';     -- Creditos Comerciales
    SET Nivel_Detalle           := 'D';     -- Nivel Detalle
    SET Nivel_Encabezado        := 'E';     -- Encabezados

    SET Tipo_Sofipo             := 3;       -- Formato tipo SOFIPO


    SELECT CuentaEPRC,AjusteSaldo
    INTO Cta_ContaEPRC,Var_AjusteSaldo
    FROM PARAMREGULATORIOS; -- Cuenta Contable de la EPRC

    SET Cta_ContaEPRC := CONCAT(IFNULL(Cta_ContaEPRC,Cadena_Vacia),'%');

    SET Var_Periodo = CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),1,4),
                              SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),5,2));

    SET Var_ClaveEntidad    := IFNULL((SELECT Ins.ClaveEntidad
                                        FROM PARAMETROSSIS Par,
                                             INSTITUCIONES Ins
                                        WHERE Par.InstitucionID = Ins.InstitucionID), CADENA_VACIA);

    SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
        FROM CENTROCOSTOS;

    SET Var_FechaHisSaldo := (
        SELECT MAX(FechaCorte) FROM SALDOSCONTABLES
    );
    SET Var_FechaHisSaldo := IFNULL(Var_FechaHisSaldo,Fecha_Vacia);
    -- -----------------------------------------------------------------
    -- Saldo de la EPRC Final
    -- ----------------------------------------------------------------

    SELECT  MAX(EjercicioID) INTO Var_UltEjercicioCie
        FROM PERIODOCONTABLE Per
        WHERE Per.Fin   < Par_Fecha
          AND Per.Estatus = Est_Cerrado;

    SET Var_UltEjercicioCie    := IFNULL(Var_UltEjercicioCie, Entero_Cero);

    IF(Var_UltEjercicioCie != Entero_Cero) THEN
        SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
            FROM PERIODOCONTABLE Per
            WHERE Per.EjercicioID   = Var_UltEjercicioCie
              AND Per.Estatus = Est_Cerrado
              AND Per.Fin   < Par_Fecha;
    END IF;

    SET Var_FecCierre := (
        SELECT MAX(FechaCorte) FROM SALDOSCONTABLES
        WHERE FechaCorte < Par_Fecha
    );



    IF Par_Fecha > Var_FechaHisSaldo   THEN
        SET Ubi_Actual := 'A';
    ELSE
        SET Ubi_Actual := 'H';
    END IF;

    SET Var_FecIniMes := DATE_ADD(IFNULL(Var_FecCierre,'1900-01-01'),INTERVAL 1 DAY);

    SET Var_UltPeriodoCie    := IFNULL(Var_UltPeriodoCie, Entero_Cero);


    CALL `EVALFORMULACONTAFINPRO`(
        Cta_ContaEPRC,      Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
        Var_UltPeriodoCie,  Var_FecIniMes,      Var_EPRCFinal,      Var_MinCenCos,      Var_MaxCenCos,'S',
        Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion  );

    IF Var_AjusteSaldo = 'S' THEN
     SET Var_EPRCFinal := ROUND(IFNULL(Var_EPRCFinal,Entero_Cero),0) ;
    ELSE
    SET Var_EPRCFinal := ROUND(IFNULL(Var_EPRCFinal,Entero_Cero),2) ;
    END IF;

    -- -----------------------------------------------------------------
    -- Saldo de la EPRC Inicial, la Final del Mes Anterior
    -- -----------------------------------------------------------------
    SET Par_FecMesAnterior := DATE_ADD(Par_Fecha, INTERVAL DAY(Par_Fecha)*-1  DAY);

    SELECT  MAX(EjercicioID) INTO Var_AntEjercicioCie
        FROM PERIODOCONTABLE Per
        WHERE Per.Fin   < Par_FecMesAnterior
          AND Per.Estatus = Est_Cerrado;

    SET Var_AntEjercicioCie    := IFNULL(Var_AntEjercicioCie, Entero_Cero);

    IF(Var_AntEjercicioCie != Entero_Cero) THEN
        SELECT  MAX(PeriodoID) INTO Var_AntPeriodoCie
            FROM PERIODOCONTABLE Per
            WHERE Per.EjercicioID   = Var_AntEjercicioCie
              AND Per.Estatus = Est_Cerrado
              AND Per.Fin   < Par_FecMesAnterior;
    END IF;

    SET Var_AntPeriodoCie    := IFNULL(Var_AntPeriodoCie, Entero_Cero);

    SET Var_FecCierre := (
        SELECT MAX(FechaCorte) FROM SALDOSCONTABLES
        WHERE FechaCorte < Par_FecMesAnterior
    );

    IF   Par_FecMesAnterior > Var_FechaHisSaldo THEN
        SET Ubi_Actual := 'A';
    ELSE
        SET Ubi_Actual := 'H';
    END IF;

    SET Var_FecIniMes := DATE_ADD(IFNULL(Var_FecCierre,'1900-01-01'),INTERVAL 1 DAY);


    CALL `EVALFORMULACONTAFINPRO`(
        Cta_ContaEPRC,      Ubi_Actual,             Por_Fecha,        Par_FecMesAnterior,         Var_AntEjercicioCie,
        Var_AntPeriodoCie,  Var_FecIniMes,     Var_EPRCInicial,       Var_MinCenCos,              Var_MaxCenCos,'S',
        Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,            Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion  );




    IF Var_AjusteSaldo = 'S' THEN
        SET Var_EPRCInicial := ROUND(IFNULL(Var_EPRCInicial,Entero_Cero),Entero_Cero)*-1;
    ELSE
        SET Var_EPRCInicial := ROUND(IFNULL(Var_EPRCInicial,Entero_Cero),2)*-1;
    END IF;

    IF Par_FecMesAnterior = '2019-09-30' THEN
        SET Var_EPRCInicial := -139356095.00;
    END IF;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS REG419_DATOSREPORTE;
CREATE TEMPORARY TABLE REG419_DATOSREPORTE(
    CreditoID   BIGINT,
    Destino     INT,
    ClasifRegID   VARCHAR(20),
    CuentaMayor VARCHAR(10),
    Saldo DECIMAL(16,2),
    Clasificacion CHAR(1) DEFAULT '',
    Descripcion VARCHAR(400),
    Naturaleza CHAR(1),
    INDEX idx_cred_1 (CreditoID),
    INDEX idx_cred_2 (Descripcion)
);


DROP TABLE IF EXISTS REG419_DATOSFINAL;
CREATE TEMPORARY TABLE REG419_DATOSFINAL(
    ClasifRegID   VARCHAR(20),
    CuentaMayor VARCHAR(10),
    Saldo DECIMAL(16,2)
);


-- -------------------------------------------------------------------------------
-- CARGAR DATOS DE POLIZA POR EPRC  ----------------------------------------------
-- -------------------------------------------------------------------------------

IF Par_Fecha <= Var_FechaHisSaldo   THEN
    INSERT INTO REG419_DATOSREPORTE (CreditoID,Saldo,Descripcion,Naturaleza)
    SELECT
    CASE WHEN Instrumento REGEXP '^[0-9]*$' THEN Instrumento  ELSE 0 END ,
    Cargos,Descripcion,'C' FROM  `HIS-DETALLEPOL`
    WHERE CuentaCompleta LIKE Cta_ContaEPRC AND Fecha > Par_FecMesAnterior AND  Fecha <= Par_Fecha AND Cargos > 0;

    INSERT INTO REG419_DATOSREPORTE (CreditoID,Saldo,Descripcion,Naturaleza)
    SELECT CASE WHEN Instrumento REGEXP '^[0-9]*$' THEN Instrumento  ELSE 0 END,
    Abonos,Descripcion,'A' FROM `HIS-DETALLEPOL`
    WHERE CuentaCompleta LIKE Cta_ContaEPRC AND Fecha > Par_FecMesAnterior AND  Fecha <= Par_Fecha AND Abonos > 0;
ELSE
    INSERT INTO REG419_DATOSREPORTE (CreditoID,Saldo,Descripcion,Naturaleza)
    SELECT
    CASE WHEN Instrumento REGEXP '^[0-9]*$' THEN Instrumento  ELSE 0 END ,
    Cargos,Descripcion,'C' FROM DETALLEPOLIZA
    WHERE CuentaCompleta LIKE Cta_ContaEPRC AND Fecha > Par_FecMesAnterior AND  Fecha <= Par_Fecha AND Cargos > 0;

    INSERT INTO REG419_DATOSREPORTE (CreditoID,Saldo,Descripcion,Naturaleza)
    SELECT CASE WHEN Instrumento REGEXP '^[0-9]*$' THEN Instrumento  ELSE 0 END,
    Abonos,Descripcion,'A' FROM DETALLEPOLIZA
    WHERE CuentaCompleta LIKE Cta_ContaEPRC AND Fecha > Par_FecMesAnterior AND  Fecha <= Par_Fecha AND Abonos > 0;
END IF;

UPDATE REG419_DATOSREPORTE Rep,CREDITOS Cre, DESTINOSCREDITO Des
    SET Rep.Destino = Des.DestinoCreID,
        Rep.ClasifRegID = Des.ClasifRegID,
        Rep.Clasificacion = Des.Clasificacion
WHERE Rep.CreditoID = Cre.CreditoID
AND Cre.DestinoCreID = Des.DestinoCreID;


-- Se elimina registro de poliza inicial salia a produccion
DELETE FROM REG419_DATOSREPORTE WHERE Descripcion =  'SALDOS DE MIGRACION AL 10/OCT';

-- Actualiza Destinos ------------------------------------------------------------
UPDATE REG419_DATOSREPORTE Rep,CREDITOS Cre, DESTINOSCREDITO Des
    SET Rep.Destino = Des.DestinoCreID,
        Rep.ClasifRegID = Des.ClasifRegID,
        Rep.Clasificacion = Des.Clasificacion
WHERE Rep.CreditoID = Cre.CreditoID
AND Cre.DestinoCreID = Des.DestinoCreID;


-- -------------------------------------------------------------------------------
-- CASTIGOS y CONDONACIONES -----------------------------------------------------------------
-- -------------------------------------------------------------------------------
UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '11'
WHERE Descripcion IN ('CASTIGO DE CARTERA','CONDONACION CARTERA','ELIMINACION DE CARTERA')
AND Naturaleza = 'C';

-- -------------------------------------------------------------------------------
-- PAGOS DE CREDITO --------------------------------------------------------------
-- -------------------------------------------------------------------------------
UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '14'
WHERE Descripcion IN ('CANC.ESTIMACION. DEL PASO A VENCIDO','CANC.ESTIM.INTERESES DEL PASO A VENC.')
AND Naturaleza = 'C';


UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '15'
WHERE Descripcion IN ('LIBERACION ESTIMACION PREVIA INTERES')
AND Naturaleza = 'C';

-- -------------------------------------------------------------------------------
-- CALIFICACION CREDITOS ---------------------------------------------------------
-- -------------------------------------------------------------------------------
 -- Pendiente revisar en noviembre si se genera correctamente la poliza de EPRC Final

UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '15'
WHERE Descripcion LIKE ('ACT.RESERVAS%')
AND Naturaleza = 'C';

UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '15'
WHERE Descripcion LIKE ('EPRC%')
AND Naturaleza = 'C';
UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '15'
WHERE Descripcion LIKE ('INTERES DE EPRC%')
AND Naturaleza = 'C';
 -- -------------------------------------------------------------------------------
-- OTROS CARGOS QUE NO TIENEN NUMERO DE CREDITO -----------------------------------
-- -------------------------------------------------------------------------------
 UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '17'
WHERE
( CreditoID = 0
OR  Destino IS NULL)
AND Naturaleza = 'C';

-- -------------------------------------------------------------------------------
-- NUEVA RESERVA - ABONOS -----------------------------------------------------------------
-- -------------------------------------------------------------------------------
 UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '17'
WHERE
IFNULL(CuentaMayor,'') = ''
AND Naturaleza = 'C';


UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '21'
WHERE Descripcion IN ('ESTIMACION CAPITALIZACION INTERES','GENERACION COMPLEMENTO DE RESERVAS')
AND Naturaleza = 'A';

UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '21'
WHERE Descripcion IN ('GENERACION DE RESERVAS')
AND Naturaleza = 'A';

UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '21'
WHERE Descripcion LIKE ('EPRC%')
AND Naturaleza = 'A';
UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '21'
WHERE Descripcion LIKE ('INTERES DE EPRC%')
AND Naturaleza = 'A';
-- -------------------------------------------------------------------------------
-- ADICIONAL - ABONOS ------------------------------------------------------------
-- -------------------------------------------------------------------------------
UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '25'
WHERE Descripcion IN ('ESTIMACION PASO A VENCIDO')
AND Naturaleza = 'A';

-- -------------------------------------------------------------------------------
-- ADICIONAL - ELIMINADA ------------------------------------------------------------
-- -------------------------------------------------------------------------------
UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '24'
WHERE Descripcion IN ('ELIMINACION DE CARTERA')
AND Naturaleza = 'A';



-- -------------------------------------------------------------------------------
-- OTROS - ABONOS QUE NO TIENEN NUMERO DE CREDITO --------------------------------
-- -------------------------------------------------------------------------------
UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '24'
WHERE Descripcion IN ('CASTIGO DE CARTERA')
AND Naturaleza = 'A';

UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '24'
WHERE
( CreditoID = 0
OR  Destino IS NULL)
AND Naturaleza = 'A';

UPDATE REG419_DATOSREPORTE
SET CuentaMayor = '24'
WHERE
IFNULL(CuentaMayor,'') = ''
AND Naturaleza = 'A';

-- Actualiza Saldos Abonos Negativo ------------------------------------------------------------
UPDATE REG419_DATOSREPORTE
    SET Saldo = Saldo * -1
WHERE Naturaleza = 'A';


-- Se calcula monto de ajuste para oct 2019 - salida a produccion ------------------------------



UPDATE REG419_DATOSREPORTE tem
SET tem.ClasifRegID =  CASE tem.ClasifRegID WHEN Clas_Quirografarios THEN Clas_QuirografaOtr
                                            WHEN Clas_Prendarios     THEN Clas_PrendariosOtr
                                            WHEN Clas_Puente         THEN Clas_PuenteOtr
                                            WHEN Clas_Comerciales    THEN Clas_ComercialesOtr
                        END
WHERE tem.ClasifRegID IN (Clas_Quirografarios,Clas_Prendarios,Clas_Puente,Clas_Comerciales);


UPDATE REG419_DATOSREPORTE tem SET
    tem.ClasifRegID = CASE WHEN tem.ClasifRegID = Clas_MediaResiden THEN  Clas_MedResSinGar ELSE Clas_IntSocSinGar END
WHERE tem.ClasifRegID IN (Clas_IntSocial,Clas_MediaResiden)
AND tem.Clasificacion = Clas_Vivienda;


UPDATE REG419_DATOSREPORTE tem, CREGARPRENHIPO gar SET
    tem.ClasifRegID = CASE WHEN tem.ClasifRegID = Clas_MedResSinGar THEN  Clas_MedResConGar ELSE Clas_IntSocConGar END
WHERE tem.CreditoID = gar.CreditoID
AND gar.GarHipotecaria > Entero_Cero
AND tem.ClasifRegID IN (Clas_MedResSinGar,Clas_IntSocSinGar)
AND tem.Clasificacion = Clas_Vivienda;



INSERT INTO REG419_DATOSFINAL
SELECT ClasifRegID,CuentaMayor,SUM(Saldo) FROM REG419_DATOSREPORTE GROUP BY CuentaMayor,ClasifRegID;

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------
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
        ClasifRegID         INT(11),

        INDEX TMP_CATCONCREGULA419_idx1 (ClaveConcepto),
        INDEX TMP_CATCONCREGULA419_idx2 (CuentaMayor),
        INDEX TMP_CATCONCREGULA419_idx3 (ClasificacionID)
        );

    INSERT INTO TMP_CATCONCREGULA419
        SELECT  ConceptoID, CuentaMayor,    ClaveConcepto,      Descripcion,    Entero_Cero,
                Orden,      Nivel,          ClasificacionID,    TipoSaldo,      ClasifRegID
            FROM CATCONCREGULA419
            WHERE TipoInstitID = Tipo_Sofipo
            ORDER BY Orden;


    UPDATE TMP_CATCONCREGULA419 Reg,
           REG419_DATOSFINAL Cas SET

        Reg.Monto = Cas.Saldo
        WHERE Reg.ClasifRegID = Cas.ClasifRegID
          AND Reg.CuentaMayor LIKE '11%'
          AND Cas.CuentaMayor = '11';


    UPDATE TMP_CATCONCREGULA419 Reg,
           REG419_DATOSFINAL Cas SET

        Reg.Monto = Cas.Saldo
        WHERE Reg.ClasifRegID = Cas.ClasifRegID
          AND Reg.CuentaMayor LIKE '14%'
          AND Cas.CuentaMayor = '14';


    UPDATE TMP_CATCONCREGULA419 Reg,
           REG419_DATOSFINAL Cas SET

        Reg.Monto = Cas.Saldo
        WHERE Reg.ClasifRegID = Cas.ClasifRegID
          AND Reg.CuentaMayor LIKE '15%'
          AND Cas.CuentaMayor = '15';



    UPDATE TMP_CATCONCREGULA419 Reg,
           REG419_DATOSFINAL Cas SET

        Reg.Monto = Cas.Saldo
        WHERE Reg.ClasifRegID = Cas.ClasifRegID
          AND Reg.CuentaMayor LIKE '21%'
          AND Cas.CuentaMayor = '21';



    -- OTROS CARGOS
    SET Var_EPRCFinalDifer := ( SELECT SUM(Saldo) FROM REG419_DATOSFINAL WHERE CuentaMayor = '17');
    SET Var_EPRCFinalDifer := IFNULL(Var_EPRCFinalDifer,Entero_Cero);

    UPDATE TMP_CATCONCREGULA419 Reg SET
        Reg.Monto = Var_EPRCFinalDifer
        WHERE Reg.ClaveConcepto = '139309000000';

    -- OTROS ABONOS
    SET Var_EPRCFinalDifer := ( SELECT SUM(Saldo) FROM REG419_DATOSFINAL WHERE CuentaMayor = '24');
    SET Var_EPRCFinalDifer := IFNULL(Var_EPRCFinalDifer,Entero_Cero);

    UPDATE TMP_CATCONCREGULA419 Reg SET
        Reg.Monto = Var_EPRCFinalDifer
        WHERE Reg.ClaveConcepto = '139499000000';

    -- EPRC ADICIONAL
    SET Var_EPRCAdicional := ( SELECT SUM(Saldo) FROM REG419_DATOSFINAL WHERE CuentaMayor = '25');
    SET Var_EPRCAdicional := IFNULL(Var_EPRCAdicional,Entero_Cero);

    UPDATE TMP_CATCONCREGULA419 Reg SET
        Reg.Monto = Var_EPRCAdicional
        WHERE Reg.ClaveConcepto = '139497000000';



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

    -- ajuste a Cero decimales
    IF Var_AjusteSaldo = 'S' THEN
     UPDATE TMP_CATCONCREGULA419 set Monto = ROUND(Monto,Entero_Cero);
    END IF;
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



   UPDATE TMP_CATCONCREGULA419 SET
        Monto = Var_EPRCInicial
        WHERE ClaveConcepto = Concepto_Inicia;


SET Var_EPRCFinalRep := (SELECT SUM(Monto) FROM TMP_CATCONCREGULA419 WHERE ClaveConcepto IN ('139200000000','139300000000','139400000000'));
IF Var_AjusteSaldo = 'S' THEN
    SET Var_EPRCFinal := (select Monto
                            from `HIS-CATALOGOMINIMO`
                            where Anio = year(Par_Fecha) and Mes = month(Par_Fecha)
                            and CuentaContable like '139000000000');
    SET Var_EPRCFinal := IFNULL(Var_EPRCFinal,Entero_Cero);
    IF Var_EPRCFinal <> Entero_Cero THEN
        SET Var_EPRCFinalDifer := Var_EPRCFinal - Var_EPRCFinalRep;
        IF Var_EPRCFinalDifer > Entero_Cero  THEN
            UPDATE TMP_CATCONCREGULA419 Reg SET
                Reg.Monto = Reg.Monto - Var_EPRCFinalDifer
            WHERE Reg.ClaveConcepto IN  ('139167020000','139407000000','139400000000','139167000000');
        END IF;
        IF Var_EPRCFinalDifer < Entero_Cero  THEN
            UPDATE TMP_CATCONCREGULA419 Reg SET
                Reg.Monto = Reg.Monto + Var_EPRCFinalDifer
            WHERE Reg.ClaveConcepto IN  ('139167020000','139407000000','139400000000','139167000000');
        END IF;
        SET Var_EPRCFinalRep := Var_EPRCFinal;
    END IF;
END IF;

UPDATE TMP_CATCONCREGULA419 Reg SET
    Reg.Monto = Var_EPRCFinalRep
    WHERE Reg.ClaveConcepto IN  ('139000000000');


    IF( Par_NumReporte = Rep_Excel) THEN
        SELECT  Var_Periodo      AS Periodo,
                Var_ClaveEntidad AS ClaveEntidad,
                Folio_Form       AS SubReporte,
                Tmp.ClaveConcepto,  Tmp.Descripcion,
                Folio_Form       AS Formulario,
                Tipo_Moneda      AS TipoMoneda,
                Tipo_Cartera     AS TipoCartera,
                Tmp.TipoSaldo,
                ROUND(IFNULL(Tmp.Monto, Entero_Cero), 2) AS Monto
            FROM  TMP_CATCONCREGULA419 Tmp, CATCONCREGULA419 Cat
            WHERE Tmp.ConceptoID = Cat.ConceptoID
            AND TipoInstitID = Tipo_Sofipo
            ORDER BY Tmp.Orden;

    ELSE
        IF( Par_NumReporte = Rep_Csv) THEN
            SELECT  CONCAT(ClaveConcepto,';',Folio_Form,';',Tipo_Moneda,';',
                            Tipo_Cartera,';', ROUND(IFNULL(Monto,Entero_Cero),2)) AS Renlgon
            FROM  TMP_CATCONCREGULA419
            ORDER BY Orden;
        END IF;
    END IF;



    DROP TABLE IF EXISTS TMP_CATCONCREGULA419;
    DROP TABLE IF EXISTS TMP_CTASMAYORREG419;


END TerminaStore$$