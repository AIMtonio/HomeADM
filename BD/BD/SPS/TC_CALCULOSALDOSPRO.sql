-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_CALCULOSALDOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_CALCULOSALDOSPRO`;DELIMITER $$

CREATE PROCEDURE `TC_CALCULOSALDOSPRO`(
-- ---------------------------------------------------------------------------------
-- CALCULO DE SALDOS MENSUALES DE LAS LINEAS DE CREDITO
-- ---------------------------------------------------------------------------------
    Par_Fecha           DATE,               -- Fecha De Operacion
    Par_Salida          CHAR(1),            -- Parametro de Salida
    INOUT Par_NumErr    INT(11),            -- Numero de Error
    INOUT Par_ErrMen    VARCHAR(400),       -- Descripcion del Error
    Par_EmpresaID       INT(11),            -- Parametro de Auditoria

    Aud_Usuario         INT(11),            -- Parametro de Auditoria
    Aud_FechaActual     DATETIME,           -- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),        -- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),        -- Parametro de Auditoria
    Aud_Sucursal        INT(11),            -- Parametro de Auditoria

    Aud_NumTransaccion  BIGINT(20)          -- Parametro de Auditoria
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_InicioMes   DATE;
DECLARE Var_FinMes      DATE;
DECLARE Var_CorteMesAnt DATE;
DECLARE Var_FecAnioAnt  DATE;
DECLARE Var_DiasMes     INT;

-- Declaracion de constantes
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Sig_DiaHab          DATE;
DECLARE Var_EsHabil         CHAR(1);


SET Fecha_Vacia         := '1900-01-01';
SET Cadena_Vacia        := '';
SET Decimal_Cero        := 0.00;
SET Nat_Cargo           := 'C';
SET Nat_Abono           := 'A';

ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_CALCULOSALDOSPRO');
            END;

        SET Var_InicioMes = DATE_ADD(Par_Fecha, INTERVAL -1*(DAY(Par_Fecha))+1 DAY);
        SET Var_FinMes = LAST_DAY(Par_Fecha);
        SET Var_DiasMes = (DATEDIFF(Var_FinMes, Var_InicioMes) + 1);
        SET Var_FecAnioAnt = DATE_SUB(Par_Fecha, INTERVAL 1 YEAR);


        SELECT  MAX(FechaCorte) INTO Var_CorteMesAnt
            FROM TC_SALDOSLINEA
            WHERE FechaCorte < Var_InicioMes;

        SET Var_CorteMesAnt = IFNULL(Var_CorteMesAnt, Fecha_Vacia);

        INSERT INTO TC_SALDOSLINEA
        SELECT
          Par_Fecha,
          Lin.LineaTarCredID,
          Lin.ClienteID,
          Lin.TarjetaPrincipal,
          Lin.MontoDisponible,
          Lin.MontoLinea,
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
          Lin.SaldoCorte,
          Lin.PagoNoGenInteres,
          Lin.PagoMinimo,
          Lin.SaldoInicial,
          Lin.TipoTarjetaDeb,
          Lin.ProductoCredID,
          Lin.TasaFija,
          Lin.TipoCorte,
          Lin.DiaCorte,
          Lin.TipoPago,
          Lin.DiaPago,
          Lin.CobraMora,
          Lin.TipoCobMora,
          Lin.FactorMora,
          Lin.TipoPagMin,
          Lin.FactorPagMin,
          Lin.Estatus,
          Lin.FechaUltCorte,
          Lin.FechaProxCorte,
         SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 1
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS CapitalVigente,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 3
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS CapitalVencido,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 14
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS InteresOrdinario,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 20
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS IVAInteresOrd,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 15
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS InteresMoratorio,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 21
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS IVAInteresMora,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 40
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS ComisionFaltaPag,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 22
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS IVAComFaltaPag,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 41
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS ComisionApertura,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 23
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS IVAComApertura,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 51
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS ComisionAnual,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND Mov.TipoMovLinID = 52
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS IVAComAnual,

          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 1
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoCapVigente,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 3
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoCapVencido,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 14
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoIntOrdinario,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 20
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoIVAIntOrd,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 15
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoIntMoratorio,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 21
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoIVAIntMora,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 40
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoComFaltaPag,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 22
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoIVAComFaltaPag,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 41
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoComApertura,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 23
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoIVAComApertura,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 51
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoComAnual,
          SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND Mov.TipoMovLinID = 52
                    THEN IFNULL(Mov.CantidadMov,Decimal_Cero) ELSE Decimal_Cero END) AS PagoIVAComAnual,
          Par_EmpresaID,
          Aud_Usuario,
          Aud_FechaActual,
          Aud_DireccionIP,
          Aud_ProgramaID,
          Aud_Sucursal,
          Aud_NumTransaccion
        FROM  LINEATARJETACRED Lin LEFT OUTER JOIN TC_LINEACREDITOMOVS Mov
        ON Mov.LineaTarCredID = Lin.LineaTarCredID
        AND Mov.FechaAplicacion BETWEEN Var_InicioMes AND Par_Fecha
        WHERE Lin.Estatus = 'A'
        GROUP BY LineaTarCredID;

        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Saldos de Lineas Calculados Exitosamente';

END ManejoErrores;

IF Par_Salida = 'S' THEN
    SELECT Par_NumErr AS NumErr,
           Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$