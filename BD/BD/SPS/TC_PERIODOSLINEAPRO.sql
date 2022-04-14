-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_PERIODOSLINEAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_PERIODOSLINEAPRO`;
DELIMITER $$


CREATE PROCEDURE `TC_PERIODOSLINEAPRO`(
-- ---------------------------------------------------------------------------------
-- SP PARA EL CIERRE DE PERIODOS DE LINEA DE CREDITO
-- ---------------------------------------------------------------------------------
    Par_Fecha           DATE,                   -- Fecha De Operacion
    Par_Salida          CHAR(1),                -- Parametro de Salida
    INOUT Par_NumErr    INT(11),                -- Numero de Error
    INOUT Par_ErrMen    VARCHAR(400),           -- Descripcion del Error
    Par_EmpresaID       INT(11),                -- Parametro de Auditoria

    Aud_Usuario         INT(11),                -- Parametro de Auditoria
    Aud_FechaActual     DATETIME,               -- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),            -- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),            -- Parametro de Auditoria
    Aud_Sucursal        INT(11),                -- Parametro de Auditoria

    Aud_NumTransaccion  BIGINT(20)              -- Parametro de Auditoria
)

TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_InicioPeriodo   DATE;
DECLARE Var_FinPeriodo      DATE;
DECLARE Var_CorteMesAnt     DATE;
DECLARE Var_DiasPeriodo     INT;

-- Declaracion de constantes
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Cadena_Vacia        VARCHAR(2);
DECLARE Tipo_Dia            CHAR(1);
DECLARE Tipo_Veinte         CHAR(1);
DECLARE Tipo_Mes            CHAR(1);
DECLARE Tipo_FinMes         CHAR(1);
DECLARE Salida_SI           CHAR(1);
DECLARE Entero_Cero         INT;

SET Fecha_Vacia             := '1900-01-01';
SET Cadena_Vacia            := '';
SET Decimal_Cero            := 0.00;
SET Nat_Cargo               := 'C';
SET Nat_Abono               := 'A';
SET Entero_Cero             := 0;
SET Tipo_Dia                := 'D';
SET Tipo_Veinte             := 'V';
SET Tipo_Mes                := 'M';
SET Tipo_FinMes             := 'F';
SET Salida_SI               := 'S';

ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_PERIODOSLINEAPRO');
            END;

        SET Var_InicioPeriodo   = DATE_ADD(Par_Fecha, INTERVAL -1*(DAY(Par_Fecha))+1 DAY);
        SET Var_FinPeriodo      = LAST_DAY(Par_Fecha);
        SET Var_DiasPeriodo     = (DATEDIFF(Var_FinPeriodo, Var_InicioPeriodo) + 1);


        SELECT  MAX(FechaCorte) INTO Var_CorteMesAnt
            FROM TC_SALDOSLINEA
            WHERE FechaCorte < Var_InicioPeriodo;

        SET Var_CorteMesAnt = IFNULL(Var_CorteMesAnt, Fecha_Vacia);

        INSERT INTO TC_PERIODOSLINEA (
            FechaCorte,
            FechaInicio,
            LineaTarCredID,
            SaldoInicial,
            TotalCompras,
            TotalInteres,
            TotalComisiones,
            TotalCargosPer,
            TotalPagos,
            SaldoCorte,
            PagoNoGenInteres,
            PagoMinimo,
            DiasPeriodo,
            SaldoPromedio,
            FechaExigible,
            FechaProxCorte,
            FechaUltPago,
            MontoPagado,
            TipoPagMin,
            FactorPagMin,
            MontoLinea,
            MontoDisponible,
            MontoBloqueado,
            SaldoAFavor,
            SaldoCapVigente,
            SaldoCapVencido,
            SaldoInteres,
            SaldoIVAInteres,
            SaldoMoratorios,
            SaldoIVAMoratorios,
            SalComFaltaPag,
            SalIVAComFaltaPag,
            SalOrtrasComis,
            SalIVAOrtrasComis,
            EmpresaID,
            Usuario,
            FechaActual,
            DireccionIP,
            ProgramaID,
            Sucursal,
            NumTransaccion
        )
        SELECT
        Par_Fecha AS FechaCorte,
        CASE WHEN Lin.FechaUltCorte = Fecha_Vacia THEN Lin.FechaActivacion ELSE  DATE_ADD(Lin.FechaUltCorte,INTERVAL 1 DAY) END AS FechaInicio,
        Lin.LineaTarCredID,
        Lin.SaldoInicial AS SaldoInicial,
        SUM(CASE WHEN Mov.NatMovimiento = 'C' AND Mov.TipoMovLinID IN (1,2)
                THEN IFNULL(Mov.CantidadMov,Entero_Cero)
                ELSE Entero_Cero END) AS TotalCompras,
        SUM(CASE WHEN Mov.NatMovimiento = 'C' AND Mov.TipoMovLinID IN (10,12,14,15, /* IVA */ 20,21)
                THEN IFNULL(Mov.CantidadMov,Entero_Cero)
                ELSE Entero_Cero END) AS TotalIntereses,
        SUM(CASE WHEN Mov.NatMovimiento = 'C' AND Mov.TipoMovLinID IN (40,41, 51 ,/* IVA */ 22,23,52 )
                THEN IFNULL(Mov.CantidadMov,Entero_Cero)
                ELSE Entero_Cero END) AS TotalCompras,
        Decimal_Cero AS TotalCargos,
        SUM(CASE WHEN Mov.NatMovimiento = 'A' AND Mov.TipoMovLinID IN (1,2, /* */ 10,12,14,15, /* IVA */ 20,21 /* */ ,40,41, 51, /* IVA */ 22,23,52)
                THEN IFNULL(Mov.CantidadMov,Entero_Cero)
                ELSE Entero_Cero END) AS TotalPagos,
        Decimal_Cero  AS SaldoCorte,
        Decimal_Cero  AS PagoNoGenInteres,
        Decimal_Cero  AS PagoMinimo,
        DATEDIFF(Par_Fecha,CASE WHEN Lin.FechaUltCorte = Fecha_Vacia THEN date_sub(Lin.FechaActivacion,INTERVAL 1 DAY) ELSE  Lin.FechaUltCorte END) AS DiasPeriodo,
        Decimal_Cero  AS SaldoPromedio,

        CASE WHEN Lin.TipoPago = Tipo_Dia AND DAY(Par_Fecha) > Lin.DiaPago THEN
                STR_TO_DATE(CONCAT(DATE_FORMAT(DATE_ADD(Par_Fecha,INTERVAL 1 MONTH), '%Y-%m-'),Lin.DiaPago),'%Y-%m-%d')
            WHEN Lin.TipoPago = Tipo_Dia AND DAY(Par_Fecha) <= Lin.DiaPago THEN
                STR_TO_DATE(CONCAT(DATE_FORMAT(Par_Fecha, '%Y-%m-'),Lin.DiaPago),'%Y-%m-%d')
            WHEN Lin.TipoPago = Tipo_Veinte THEN
                DATE_ADD(Par_Fecha, INTERVAL 20 DAY)
            WHEN Lin.TipoPago = Tipo_Mes THEN
                DATE_ADD(Par_Fecha, INTERVAL 30 DAY)
            ELSE Fecha_Vacia END
        AS FechaExigible,

        CASE WHEN Lin.TipoCorte = Tipo_Dia AND DAY(Par_Fecha) >= Lin.DiaCorte THEN
            STR_TO_DATE(CONCAT(DATE_FORMAT(DATE_ADD(Par_Fecha,INTERVAL 1 MONTH), '%Y-%m-'),Lin.DiaCorte),'%Y-%m-%d')
        WHEN Lin.TipoCorte = Tipo_Dia AND DAY(Par_Fecha) < Lin.DiaCorte THEN
            STR_TO_DATE(CONCAT(DATE_FORMAT(Par_Fecha, '%Y-%m-'),Lin.DiaCorte),'%Y-%m-%d')
        WHEN Lin.TipoCorte = Tipo_FinMes THEN
            LAST_DAY(STR_TO_DATE(DATE_FORMAT(DATE_ADD(Par_Fecha,INTERVAL 1 MONTH), '%Y-%m-01'),'%Y-%m-%d'))
        ELSE Fecha_Vacia END
        AS ProximoCorte,

        Fecha_Vacia AS FechaUltPago,
        Decimal_Cero AS MontoPagado,
        /* *********************************************** */
        Lin.TipoPagMin,
        Lin.FactorPagMin,
        Lin.MontoLinea,
        Lin.MontoDisponible,
        Lin.MontoBloqueado,
        Lin.SaldoAFavor,
        Lin.SaldoCapVigente,
        Lin.SaldoCapVencido,
        Lin.SaldoInteres,
        Lin.SaldoIVAInteres,
        Lin.SaldoMoratorios,
        Lin.SaldoIVAMoratorios,
        Lin.SalComFaltaPag,
        Lin.SalIVAComFaltaPag,
        Lin.SalOrtrasComis,
        Lin.SalIVAOrtrasComis,

        /* ------------------------------------------------- */
        Par_EmpresaID,
        Aud_Usuario,
        Aud_FechaActual,
        Aud_DireccionIP,
        Aud_ProgramaID,
        Aud_Sucursal,
        Aud_NumTransaccion
        FROM LINEATARJETACRED Lin LEFT OUTER JOIN TC_LINEACREDITOMOVS Mov
            ON Lin.LineaTarCredID = Mov.LineaTarCredID
        WHERE Mov.FechaConsumo > Lin.FechaUltCorte
        AND Mov.FechaConsumo <= Par_Fecha
        AND Lin.FechaProxCorte = Par_Fecha
        GROUP BY Lin.LineaTarCredID;

        UPDATE TC_PERIODOSLINEA
            SET TotalCargosPer      = TotalCompras + TotalInteres + TotalComisiones,
                SaldoCorte          = SaldoInicial + (TotalCompras + TotalInteres + TotalComisiones) - TotalPagos,
                PagoNoGenInteres    = SaldoInicial + (TotalCompras + TotalInteres + TotalComisiones) - TotalPagos,
                PagoMinimo = ROUND((SaldoInicial + (TotalCompras + TotalInteres + TotalComisiones) - TotalPagos) * (FactorPagMin/100),2)
                                    + (SaldoInteres+SaldoIVAInteres+SaldoMoratorios+SaldoIVAMoratorios+SalComFaltaPag+SalIVAComFaltaPag)
        WHERE FechaCorte = Par_Fecha
        AND NumTransaccion = Aud_NumTransaccion;

    -- +--------------------------------------------------+
    -- |   SALDO PROMEDIO                                 |
    -- +--------------------------------------------------+

        TRUNCATE TABLE TC_TMPLINEAMOVS;

        INSERT INTO `TC_TMPLINEAMOVS`	(
				`Transaccion`,					`LineaTarCredID`,					`Fecha`,					`SaldoDia`)
            SELECT  Aud_NumTransaccion,
                    Mov.LineaTarCredID, Mov.FechaConsumo,
                    (   SUM(LOCATE(Nat_Cargo, Mov.NatMovimiento) * Mov.CantidadMov ) -
                                     SUM(LOCATE(Nat_Abono, Mov.NatMovimiento) * Mov.CantidadMov ) ) *
                                    (DATEDIFF(Par_Fecha, Mov.FechaConsumo) + 1)

            FROM TC_LINEACREDITOMOVS Mov,
                 TC_PERIODOSLINEA Sal
            WHERE  Sal.FechaCorte = Par_Fecha
              AND Sal.LineaTarCredID = Mov.LineaTarCredID
              AND Mov.FechaConsumo  >= Sal.FechaInicio
              AND Mov.FechaConsumo  <= Par_Fecha
            GROUP BY Mov.LineaTarCredID, FechaConsumo;


        INSERT INTO `TC_TMPLINEAMOVS`	(
				`Transaccion`,					`LineaTarCredID`,					`Fecha`,					`SaldoDia`)
        SELECT  Aud_NumTransaccion,
                Lin.LineaTarCredID,
                Lin.FechaInicio,
                SUM( Lin.SaldoInicial * Lin.DiasPeriodo ) AS Cantidad
        FROM  TC_PERIODOSLINEA Lin
        WHERE Lin.FechaCorte  = Par_Fecha
        GROUP BY Lin.LineaTarCredID,Lin.FechaInicio ;

        UPDATE TC_PERIODOSLINEA Sal SET
        Sal.SaldoPromedio = ( SELECT (IFNULL(SUM(Mov.SaldoDia),Decimal_Cero) / Sal.DiasPeriodo)
                                 AS SaldoProm
                            FROM TC_TMPLINEAMOVS Mov
                            WHERE Sal.LineaTarCredID = Mov.LineaTarCredID)
        WHERE Sal.FechaCorte  = Par_Fecha;

    -- +--------------------------------------------------+
    -- |   ACTUALIZAR LINEAS DE CREDITO                   |
    -- +--------------------------------------------------+
        UPDATE LINEATARJETACRED Lin, TC_PERIODOSLINEA Per
            SET Lin.SaldoCorte       = Per.SaldoCorte,
                Lin.PagoNoGenInteres = Per.PagoNoGenInteres,
                Lin.PagoMinimo       = Per.PagoMinimo,
                Lin.SaldoInicial     = Per.SaldoCorte,
                Lin.FechaUltCorte    = Per.FechaCorte,
                Lin.FechaProxCorte   = CASE WHEN Lin.TipoCorte = Tipo_Dia AND DAY(Par_Fecha) >= Lin.DiaCorte THEN
                                            STR_TO_DATE(CONCAT(DATE_FORMAT(DATE_ADD(Par_Fecha,INTERVAL 1 MONTH), '%Y-%m-'),Lin.DiaCorte),'%Y-%m-%d')
                                        WHEN Lin.TipoCorte = Tipo_Dia AND DAY(Par_Fecha) < Lin.DiaCorte THEN
                                            STR_TO_DATE(CONCAT(DATE_FORMAT(Par_Fecha, '%Y-%m-'),Lin.DiaCorte),'%Y-%m-%d')
                                        WHEN Lin.TipoCorte = Tipo_FinMes THEN
                                            LAST_DAY(STR_TO_DATE(DATE_FORMAT(DATE_ADD(Par_Fecha,INTERVAL 1 MONTH), '%Y-%m-01'),'%Y-%m-%d'))
                                        ELSE Fecha_Vacia END,
                Lin.MontoBaseCal    = Per.SaldoPromedio
        WHERE Lin.LineaTarCredID = Per.LineaTarCredID
        AND Per.FechaCorte  = Par_Fecha;

        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Cierre de Periodo de Linea Realizado Exitosamente';

END ManejoErrores;

IF Par_Salida = Salida_SI THEN
    SELECT Par_NumErr AS NumErr,
           Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$
