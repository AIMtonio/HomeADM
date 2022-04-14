-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGC045200003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGC045200003REP`;
DELIMITER $$

CREATE PROCEDURE `REGC045200003REP`(
-- ============================================================================================================
-- ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE C0452 Version SOFIPO -----------------------
-- ============================================================================================================
    Par_Fecha           DATE,                   -- Fecha del reporte
    Par_NumReporte      TINYINT UNSIGNED,       -- Tipo de reporte 1: Excel 2: CVS
    Par_NumDecimales    INT,                    -- Numero de Decimales en Cantidades o Montos
    -- Parametros de Auditoria
    Par_EmpresaID       INT(11),                -- Auditoria
    Aud_Usuario         INT(11),                -- Auditoria

    Aud_FechaActual     DATETIME,               -- Auditoria
    Aud_DireccionIP     VARCHAR(15),            -- Auditoria
    Aud_ProgramaID      VARCHAR(50),            -- Auditoria
    Aud_Sucursal        INT(11),                -- Auditoria
    Aud_NumTransaccion  BIGINT(20)              -- Auditoria
    )
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_UltFecEPRC      DATE;           -- Ultima fecha de estimaciones preventivas
    DECLARE Var_ClaveEntidad    VARCHAR(300);   -- Clave de la Entidad de la institucion
    DECLARE Var_Periodo         CHAR(6);        -- Periodo al que pertenece el reporte ano+mes
    DECLARE Var_IVASucurs       DECIMAL(8,4);
    DECLARE Var_TipoSIC         CHAR(1);        -- Tipo de Clave SIC


    -- Declaracion de Constantes
    DECLARE Rep_Excel           INT;
    DECLARE Rep_Csv             INT;
    DECLARE For_0452            INT;
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Espacio_blanco      VARCHAR(2);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Clave_FechaVacia    CHAR(8);
    DECLARE SI                  CHAR(1);
    DECLARE Con_NO              CHAR(1);
    DECLARE Fisica              CHAR(1);
    DECLARE Moral               CHAR(1);
    DECLARE Fisica_empre        CHAR(1);
    DECLARE Masculino           CHAR(1);
    DECLARE Femenino            CHAR(1);
    DECLARE Tipo_Bloqueo        CHAR(1);
    DECLARE Vencido             CHAR(1);
    DECLARE Vigente             CHAR(1);
    DECLARE Pagado              CHAR(1);
    DECLARE Nacional            CHAR(1);
    DECLARE Extranjero          CHAR(1);

    DECLARE Cadena_Espacio      VARCHAR(2);
    DECLARE Entero_Cero         INT;
    DECLARE Apellido_Vacio      CHAR(1);        -- Cuando no tiene apellido se coloca X
    DECLARE Var_FechaIniMesSis  DATE;
    DECLARE Var_MesAnterior     DATE;

    DECLARE Tipo_Consanguineo   CHAR(1);
    DECLARE Tipo_Afinidad       CHAR(1);
    DECLARE Rel_GradoUno        INT;
    DECLARE Rel_GradoDos        INT;
    DECLARE Tipo_Cliente        INT;
    DECLARE Tipo_Empleado       INT;

    DECLARE Cla_SinRelacion     VARCHAR(2);
    DECLARE Cla_ConsejoAdmon    VARCHAR(2);
    DECLARE Cla_ConsejoVigil    VARCHAR(2);
    DECLARE Cla_ComiteCredito   VARCHAR(2);
    DECLARE Cla_DirGeneral      VARCHAR(2);
    DECLARE Cla_FamFuncionario  VARCHAR(2);
    DECLARE Decimal_Cero        DECIMAL(21,2);
    DECLARE SiPagaIVA           CHAR(1);
    DECLARE Bloq_GtiaCredito    INT;
    DECLARE Sta_Autorizada      CHAR(1);
    DECLARE Gtia_Mobiliaria     INT;
    DECLARE Valor_SI            CHAR(1);
    DECLARE EsMarginada_NO      INT;
    DECLARE EsMarginada_SI      INT;
    DECLARE SIC_BuroCredito     CHAR(1);        -- Clave SIC de consulta Buro
    DECLARE SIC_CirculoCredito  CHAR(1);        -- Clave SIC circulo de credito
    DECLARE Per_Fisica          INT;
    DECLARE Per_Moral           INT;
    DECLARE Pago_Vigente        CHAR(5);
    DECLARE Fon_Gubernamental   CHAR(1);
    DECLARE Fon_PerFisica       CHAR(1);
    DECLARE Fon_PerMoral        CHAR(1);
    DECLARE Fon_PerActEmp       CHAR(1);
    DECLARE Mov_ComFalPago      INT;
    DECLARE Mov_ComAdmon        INT;
    DECLARE Mov_ComAnualidad    INT;
    DECLARE Nat_Cargo           CHAR(1);
    DECLARE Sin_Garantia        INT;
    DECLARE Rfc_Garante         VARCHAR(13);
    DECLARE Es_Fondeado         CHAR(1);
    DECLARE Recursos_Propios    INT;
    DECLARE Recursos_Fondeados  INT;
    DECLARE Var_SuperCadena     VARCHAR(250);
    DECLARE Var_Semana          CHAR(1);
    DECLARE Var_Catorcena       CHAR(1);
    DECLARE Var_Quincena        CHAR(1);
    DECLARE Var_Mensual         CHAR(1);
    DECLARE Var_ProgramaCierre  VARCHAR(22);
    DECLARE Var_CienPorCiento   VARCHAR(6);
    DECLARE Cred_Consumo        CHAR(1);
    DECLARE Cred_Vivienda       CHAR(1);
    DECLARE Cred_Comercial      CHAR(1);
    DECLARE Sin_Aval            VARCHAR(20);
    DECLARE Cred_Resstructura   CHAR(1);
    DECLARE Cred_Renovacion     CHAR(1);
    DECLARE Com_SinReest        INT;
    DECLARE Com_ConReest        INT;
    DECLARE Viv_SinGar          INT;
    DECLARE Viv_ConGar          INT;
    DECLARE Viv_Emproble        INT;
    DECLARE Cons_Marginado      INT;
    DECLARE Cons_GarHipo        INT;
    DECLARE Viv_GarHipo         INT;
    DECLARE Tipo_Consumo        INT;
    DECLARE Var_Mayusculas      VARCHAR(2);

    -- Asignacion de Constantes
    SET Rep_Excel           :=  1;              -- Opcion para generar los datos para el excel
    SET Rep_Csv             :=  2;              -- Opcion para generar datos para el CVS
    SET For_0452            :=  452;            -- Clave del Formulario o Reporte 0452.
    SET Cadena_Vacia        :=  '';             -- Cadena vacia
    SET Espacio_blanco      :=  ' ';            -- Espacio en blanco
    SET Fecha_Vacia         :=  '1900-01-01';   -- Fecha vacia
    SET Clave_FechaVacia    := '99991231';      -- Clave de Fecha DEFAULT
    SET SI                  :=  'S';            -- SI
    SET Con_NO              :=  'N';            -- NO
    SET Fisica              :=  'F';            -- Tipo de persona fisica
    SET Moral               :=  'M';            -- Tipo de persona moral
    SET Fisica_empre        :=  'A';            -- Persona Fisica Con Actividad Empresarial
    SET Masculino           :=  'M';            -- Sexo masculino
    SET Femenino            :=  'F';            -- Sexo femenino
    SET Tipo_Bloqueo        :=  'B';            -- Tipo de Movimiento de Bloqueo de Saldo
    SET Vencido             :=  'B';            -- Estatus del Credito Vencido
    SET Vigente             :=  'V';            -- Estatus del Credito Vigente
    SET Pagado              :=  'P';            -- Pagado
    SET Nacional            :=  'N';            -- Nacionalidad del cliente 'N' = Nacional
    SET Extranjero          :=  'E';            -- Nacionalidad del cliente 'E' = Extranjero

    SET Cadena_Espacio      := ' ';             -- Espacio en blanco
    SET Entero_Cero         := 0;
    SET Par_NumDecimales    := 0;               -- EL reporte se presenta con montos a 0 decimales
    SET Apellido_Vacio      := 'X';
    SET Tipo_Consanguineo   := "C";             -- Tipo de Relacion: Consanguinea
    SET Tipo_Afinidad       := "A";             -- Tipo de Relacion: Afinidad
    SET Rel_GradoUno        := 1;               -- Nivel de la Relacion: UNO
    SET Rel_GradoDos        := 2;               -- Nivel de la Relacion: DOS
    SET Tipo_Cliente        := 1;               -- Tipo de Relacionado: Cliente
    SET Tipo_Empleado       := 2;               -- Tipo de Relacionado: Empleado

    SET Cla_SinRelacion     := '1';             -- Tipo de Relacionado: Sin Relacion
    SET Cla_ConsejoAdmon    := '2';             -- Tipo de Relacionado: Familiar de Funcionario
    SET Cla_ConsejoVigil    := '3';             -- Tipo de Relacionado: Familiar de Funcionario
    SET Cla_ComiteCredito   := '4';             -- Tipo de Relacionado: Familiar de Funcionario
    SET Cla_DirGeneral      := '7';             -- Tipo de Relacionado: Familiar de Funcionario
    SET Cla_FamFuncionario  := '6';             -- Tipo de Relacionado: Familiar de Funcionario
    SET Decimal_Cero        := 0.0;             -- DECIMAL en Ceros
    SET SiPagaIVA           := 'S';             -- Si se paga IVA
    SET Bloq_GtiaCredito    := 8;               -- Bloqueo por Garantia Liquida de Credito
    SET Sta_Autorizada      := 'U';             -- Estatus de Autorizado
    SET Gtia_Mobiliaria     := 2;               -- Tipo de Garantia: Mobiliaria

    SET Valor_SI            := 'S';             -- Constantes SI
    SET EsMarginada_NO      := 1;               -- NO Reside en una Zona Marginada
    SET EsMarginada_SI      := 2;               -- SI Reside en una Zona Marginada
    SET SIC_BuroCredito     := 'B';             -- Tipo de Servicios de Informacion Crediticia: Buro de Credito
    SET SIC_CirculoCredito  := 'C';             -- Tipo de Servicios de Informacion Crediticia: Circulo de Credito
    SET Per_Fisica          := 1;               -- Persona Fisica
    SET Per_Moral           := 2;               -- Persona Moral
    SET Pago_Vigente        := '20999';         -- Pago del Credito Vigente o al Corriente
    SET Fon_Gubernamental   := 'G';             -- Tipo de Fondeador Gubernamental
    SET Fon_PerFisica       := 'F';             -- Tipo de Fondeador Persona Fisica
    SET Fon_PerMoral        := 'M';             -- Tipo de Fondeador Persona Moral
    SET Fon_PerActEmp       := 'A';             -- Persona Fisica Con Actividad Empresarial

    SET Mov_ComFalPago      := 40;              -- Tipo de Movimiento: Comision por Falta de Pago
    SET Mov_ComAdmon        := 42;              -- Tipo de Movimiento: Comision por Administracion
    SET Mov_ComAnualidad    := 51;              -- Tipo de Movimiento: Comision por Anualidad
    SET Nat_Cargo           := 'C';             -- Naturaleza del Movimiento: Cargo
    SET Sin_Garantia        := 1;               -- Credito sin garantia
    SET Rfc_Garante         := 'XXXX010101AAA'; -- RFC del garante
    SET Es_Fondeado         := 'F';             -- Credito fondeado
    SET Recursos_Propios    :=  2;              -- Recursos propios
    SET Recursos_Fondeados  :=  9;              -- Credito fondeado

    SET Var_Semana          := 'S';             -- Semanal
    SET Var_Catorcena       := 'C';             -- Catorcenal
    SET Var_Quincena        := 'Q';             -- Quincenal
    SET Var_Mensual         := 'M';             -- Mensual
    SET Var_ProgramaCierre  := 'CIERREGENERALPRO';

    SET Var_CienPorCiento   := '100.00';        -- 100% de avales
    SET Cred_Consumo        := 'O';             -- Creditos Consumo
    SET Cred_Vivienda       := 'H';             -- Creditos vivienda
    SET Cred_Comercial      := 'C';             -- Creditos comerciales
    SET Sin_Aval            := "SIN AVAL";      -- Credito Sin Aval
    SET Cred_Resstructura   := 'R';             -- reestructura
    SET Cred_Renovacion     := 'O';             -- renovacion

    SET Com_SinReest        := 4;               -- Comercial sin reestructura
    SET Com_ConReest        := 5;               -- Comercial con reestructura
    SET Viv_SinGar          := 9;               -- Vivienda sin garantia hipotecaria
    SET Viv_ConGar          := 10;              -- Vivienda con Garantia hipotecaria
    SET Viv_Emproble        := 11;              -- Vivienda emproblemada

    SET Cons_Marginado      := 2;               -- Consumo en Zona marginada
    SET Cons_GarHipo        := 3;               -- Consumo con Garantia Hipotecaria
    SET Viv_GarHipo         := 8;               -- Vivienda con Garantia hipotecaria
    SET Tipo_Consumo        := 1;               -- Tipo Consumo
    SET Var_Mayusculas      := 'MA';            -- Cambiar texto a mayusculas
    -- Inicializaciones
    SET Var_SuperCadena := '';

    SET Var_Periodo = date_format(Par_Fecha,'%Y%m') ;

    SET Var_ClaveEntidad    := IFNULL((SELECT Par.ClaveEntidad
                                        FROM PARAMETROSSIS Par
                                        WHERE Par.EmpresaID = Par_EmpresaID), Cadena_Vacia);

    CALL TRANSACCIONESPRO(Aud_NumTransaccion);

    SET Var_FechaIniMesSis  := DATE_ADD(Par_Fecha, INTERVAL - 1 * ( DAY(Par_Fecha) ) + 1 DAY);
    SET Var_MesAnterior     := DATE_SUB(Var_FechaIniMesSis, INTERVAL 1 DAY);

    SELECT MAX(Suc.IVA) INTO Var_IVASucurs
        FROM SUCURSALES Suc;

    SET Var_IVASucurs := IFNULL(Var_IVASucurs, Entero_Cero);

    DELETE FROM TMPREGR04C0452
WHERE
    NumTransaccion = Aud_NumTransaccion;

    INSERT INTO TMPREGR04C0452
        SELECT  Aud_NumTransaccion AS NumTransaccion,
                Cre.IdenCreditoCNBV,                    -- Identificardor CNBV
                Cre.CreditoID AS NumeroDispo,           -- Numero de disposicion
                Cadena_Vacia AS ClasifConta,            -- Clasificacion contable, se Actualiza mas Delante

                -- ------------------------------------------------------------------
                --  SECCION SEGUIMIENTO DEL CREDITO CON DATOS A LA FECHA DE CORTE
                -- ------------------------------------------------------------------

                -- Fecha de corte
                Par_Fecha AS FechaCorte,

                -- Saldo insoluto inicial a la fecha de corte
                Decimal_Cero AS SalInsolutoInicial,

                -- Monto dispuesto a la fecha de corte
                CASE WHEN Cre.FechaInicio >= Var_FechaIniMesSis THEN
                    Cre.MontoCredito
                ELSE Decimal_Cero END AS MontoDispuesto,

                -- Monto de Intereses ordinarios
                (Sal.SalIntProvision + Sal.SalIntAtrasado + Sal.SalIntVencido) AS SalIntOrdin,

                 -- Monto de interes moratorio
                (Sal.SalMoratorios + Sal.SaldoMoraVencido) AS SalIntMora,

                -- monto de comisiones generadas en el Periodo
                Decimal_Cero AS MontoComision,

                -- Monto de impuesto al valor agregado
                CASE WHEN Pro.CobraIVAInteres = SiPagaIVA THEN
                    ROUND((Sal.SalIntProvision + Sal.SalIntAtrasado + Sal.SalIntVencido +
                           Sal.SalMoratorios + Sal.SaldoMoraVencido) * Var_IVASucurs,2)
                     ELSE Entero_Cero
                END AS SaldoIVA,

                -- Monto del pago de capital exigible. Se actualiza mas adelante
                -- Inicialmente es el Saldo de Capital Atrasado o Vencido
                (Sal.SalCapAtrasado + Sal.SalCapVencido ) AS SalCapitalExigible,


                CASE WHEN Pro.CobraIVAInteres = SiPagaIVA THEN
                    ROUND((Sal.SalIntAtrasado + Sal.SalIntVencido + Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SalIntNoConta) * (1+ Var_IVASucurs),2)
                     ELSE Entero_Cero
                END AS SalIntExigible,

                -- Monto del pago de comisiones
                (Sal.SalComFaltaPago + Sal.SaldoComServGar + Sal.SalOtrasComisi ) AS MontoComisionExigible,

                -- Monto de capital pagado efectivamente
                Decimal_Cero AS CapitalPagado,

                -- Monto de interes ordinarios pagados
                Decimal_Cero AS IntOrdiPagado,

                -- Monto de interes moratorio pagado
                Decimal_Cero AS IntMoraPagado,

                -- monto de comisiones pagados
                Decimal_Cero AS MtoComisiPagado,


                -- Monto de otros accesorios pagados
                 Decimal_Cero AS OtrAccesoriosPagado,

                -- tasa ordinaria anual
                ROUND(Cre.TasaFija,2) AS TasaAnual,


                CASE WHEN IFNULL(Pro.CobraMora,'N') = 'S' AND Pro.TipCobComMorato = Con_NO THEN ROUND(Cre.TasaFija * Pro.FactorMora,2)
                     WHEN IFNULL(Pro.CobraMora,'N') = 'S' AND Pro.TipCobComMorato = 'T' THEN  ROUND(Pro.FactorMora,2)
                     ELSE Decimal_Cero END AS TasaMora,

                -- Saldo insoluto del credito a la Fecha de Corte
                (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) +
                (Sal.SalIntProvision + Sal.SalIntAtrasado + Sal.SalIntVencido + Sal.SalIntNoConta) +
                (Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen) AS SaldoInsoluto,


                -- ------------------------------------------------------------------
                --  SECCION SEGUIMIENTO DEL CREDITO CON DATOS AL CIERRE DEL PERIODO
                -- ------------------------------------------------------------------
                -- Fecha de ultima disposicion
                Cre.FechaInicio AS FechaUltDispo,

                -- Plazo al vencimiento del credito
                DATEDIFF(Cre.FechaVencimien,Cre.FechaInicio) AS PlazoVencimiento,

                -- saldo del principal al inicio del periodo
                Decimal_Cero AS SaldoPrincipalFP,

                -- Monto dispuesto
                CASE WHEN Cre.FechaInicio >= Var_FechaIniMesSis THEN
                    Cre.MontoCredito
                ELSE Decimal_Cero END AS MontoDispuestoFP,

                -- Credito disponible en la linea
                Decimal_Cero AS CredDisponibleFP,

                -- Tasa de interes anual ordinaria
                ROUND(Cre.TasaFija,2) AS TasaAnualFP,

                -- Tasa de interes anual moratoria
                CASE WHEN Cre.TipCobComMorato = Con_NO THEN ROUND(Cre.TasaFija * Cre.FactorMora,2)
                     ELSE ROUND(Cre.FactorMora,2) END AS TasaMoraFP,

                -- Monto de interes ordinario en el periodo
                (Sal.SalIntProvision + Sal.SalIntAtrasado + Sal.SalIntVencido) AS SalIntOrdinFP,

                -- Monto de interes moratorio
                (Sal.SalMoratorios + Sal.SaldoMoraVencido) AS SalIntMoraFP,

                -- Monto de interes refinanciado. Campo 34
                Decimal_Cero AS IntereRefinanFP,

                -- Monto de Interes por Reversos. Campo 35
                Decimal_Cero AS IntereReversoFP,

                -- Saldo base para el calculo de intereses. Campo 36
                Sal.SaldoPromedio AS SaldoPromedioFP,


                (SELECT datediff(case when Cre.FechaVencimien < Par_Fecha  then Cre.FechaVencimien else Par_Fecha end,IFNULL(MIN(FechaInicio), case when Cre.FechaVencimien < Par_Fecha  then Cre.FechaVencimien else Par_Fecha end))
                    FROM AMORTICREDITO Amo
                    WHERE Amo.CreditoID = Cre.CreditoID
                      AND (Amo.Estatus != Pagado
                       OR  (    Amo.Estatus = Pagado
                           AND  Amo.FechaLiquida  > Par_Fecha ) )
                      AND Amo.FechaExigible <= Par_Fecha ) as NumDiasIntFP,


                 -- Comisiones Generadas en el Periodo, Campo 38
                Decimal_Cero AS MontoComisionFP, -- Se actualiza mas delante

                -- Monto Condonado en el Periodo, Campo 39
                 (SELECT IFNULL(SUM(MontoCapital + MontoInteres), Entero_Cero)
                    FROM  CREQUITAS Quita
                    WHERE Quita.CreditoID = Cre.CreditoID
                      AND Quita.FechaRegistro BETWEEN Var_FechaIniMesSis AND Par_Fecha ) AS MontoCondonaFP,

                -- Monto por quitas, Campo 40
                Decimal_Cero AS MontoQuitasFP,

               -- Monto por bonificacion, Campo 41
                Decimal_Cero AS MontoBonificaFP,

                -- Monto por descuentos, Campo 42
                Decimal_Cero AS MontoDescuentoFP,

                -- Monto de otros aumentos o decrementos, Campo 43
                Decimal_Cero AS MtoAumenDecrePrincFP,

                -- Monto del capital pagado
                Decimal_Cero AS CapitalPagadoFP,

                -- Monto del interes ordinario pagado
                Decimal_Cero AS IntOrdiPagadoFP,

                -- Monto del interes moratorio pagado
                Decimal_Cero AS IntMoraPagadoFP,

                -- Monto de comisiones pagadas
                Decimal_Cero AS MtoComisiPagadoFP,

                -- Monto de otros accesorios
                 Decimal_Cero AS OtrAccesoriosPagadoFP,

                -- Monto total pagado en el periodo
                Decimal_Cero AS MontoPagadoEfecFP,

                -- Saldo del principal al final del periodo
                (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) AS SalCapitalFP,

                -- Saldo insoluto al final del periodo
                (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) +
                (Sal.SalIntProvision + Sal.SalIntAtrasado + Sal.SalIntVencido + Sal.SalMoratorios + Sal.SaldoMoraVencido) AS SaldoInsolutoFP,

                -- Situacion del credito
                Cadena_Vacia AS SituacContable,

                -- Tipo de recuperacion
                CASE WHEN Sal.DiasAtraso = Entero_Cero THEN Entero_Cero
                    WHEN  Sal.DiasAtraso > Entero_Cero AND Sal.EstatusCredito = Vigente THEN 1
                    WHEN Sal.EstatusCredito = Vencido THEN 2
                END AS TipoRecuperacion,

                -- Dias de mora
                Sal.DiasAtraso AS NumDiasAtraso,

                -- Fecha del Ultimo pago exigible, pagado por completo. Campo 55
                 CASE WHEN Cre.FechaInicio >= Var_FechaIniMesSis THEN
                    Par_Fecha
                 ELSE Fecha_Vacia END AS FecUltPagoCapFP,

                -- Monto del ultimo pago exigible, pagado por Completo. Campo 56
                 Decimal_Cero AS MontoUltiPagoFP,

                 -- Primera amortizacion no cubierta. Campo 57
                 (SELECT IFNULL(MIN(FechaExigible), Fecha_Vacia)
                    FROM AMORTICREDITO Amo
                    WHERE Amo.CreditoID = Cre.CreditoID
                      AND (Amo.Estatus != Pagado
                       OR  (    Amo.Estatus = Pagado
                           AND  Amo.FechaLiquida  > Par_Fecha ) )
                      AND Amo.FechaExigible <= Par_Fecha ) AS FecPrimAorNoCubFP,

                -- ------------------------------------------------------------------
                --  SECCION IDENTIFICADOR DE AVALES Y GARANTIAS
                -- ------------------------------------------------------------------
                -- Tipo de garantia. Campo 58
                Sin_Garantia AS TipoGarantia,

                -- Numero de garantias
                Entero_Cero AS NumGarantias,

                -- ProgramaID de credito del gob Federal
                Entero_Cero AS ProgramaCred,

                -- Monto de la garantia
                Decimal_Cero AS MontoTotGarantias,

                -- Porcentaje de la garantia - Saldo insoluto
                Decimal_Cero AS PorcentajeGarantia,

                -- Grado de prelacion garantia
                Entero_Cero AS GradoPrelacionGar,

                -- fecha de valuacion de la garantia
                Fecha_Vacia AS FechaValuacionGar,

                -- Numero de avales
                Entero_Cero AS NumeroAvales,

                -- Porcentaje que garantizan los avales
                Decimal_Cero AS PorcentajeAvales,

                -- Nombre del garante
                Sin_Aval AS NombreGarante,

                -- RFC del garante
                Rfc_Garante AS RFCGarante,

                -- ------------------------------------------------------------------
                --  SECCION CALCULO DE LAS ESTIMACIONES PREVENTIVAS
                -- ------------------------------------------------------------------
                -- Tipo de cartera
               Entero_Cero AS TipoCartera,              -- Campo 69

               Cre.ClasiDestinCred AS CredClas,     -- TODO: REVISAR

                -- Calificacion Parte cubierta
               Entero_Cero AS CalifCubierta,                    -- Campo 70

                -- Calificacion Parte expuesta          -- Campo 70
               Entero_Cero AS CalifExpuesta,

                -- Es zona marginada
                EsMarginada_NO AS ZonaMarginada,            -- Campo 72

                -- Clave de prevencion
                Cadena_Vacia AS ClaveSIC,                   -- Campo 73

                -- fuente del fondeo del credito
                CASE WHEN IFNULL(Cre.TipoFondeo, Cadena_Vacia) = Es_Fondeado THEN Recursos_Fondeados
                     ELSE Recursos_Propios
                END AS TipoRecursos, -- Recursos Propios

                -- Porcentaje de estimaciones preventivas monto cubierto
                Decimal_Cero AS PorcentajeCubierto,

                -- Monto cubierto
                Decimal_Cero AS MontoCubierto,

                -- Porcentaje de estimaciones preventivas monto expuesto
                Decimal_Cero AS ReservaCubierta,


                -- 78
                Decimal_Cero AS PorcentajeExpuesto,

                -- 79
                Decimal_Cero AS MontoExpuesto,

                -- 80
                Decimal_Cero AS ReservaExpuesta,

                -- 81
                Decimal_Cero AS ReservaTotal,

                -- 82
                Decimal_Cero AS ReservaSIC,

                -- 83
                (Sal.SalIntVencido + Sal.SaldoMoraVencido) AS ReservaAdicional,

                -- 84
                Decimal_Cero AS ReservaAdiCNBV,

                -- 85
                (Sal.SalIntVencido + Sal.SaldoMoraVencido) AS ResevaAdiTotal,

                -- 86
                Decimal_Cero AS ResevaAdiCtaOrden,

                -- 87
                Decimal_Cero AS EstimaPrevenMesAnt,

                Sal.CreditoID,

                Pro.Descripcion,
                CASE WHEN Pro.ManejaLinea = SI AND Pro.EsRevolvente = SI    THEN 7
                     WHEN Pro.ManejaLinea = Con_NO AND Sal.NumAmortizacion <= 1 THEN 1
                     WHEN Pro.ManejaLinea = Con_NO AND Sal.NumAmortizacion > 1
                                               AND Sal.FrecuenciaCap = Var_Semana   THEN 4
                     WHEN Pro.ManejaLinea = Con_NO AND Sal.NumAmortizacion > 1
                                               AND Sal.FrecuenciaCap IN (Var_Catorcena, Var_Quincena) THEN 5
                     WHEN Pro.ManejaLinea = Con_NO AND Sal.NumAmortizacion > 1
                                               AND Sal.FrecuenciaCap = Var_Mensual  THEN 6
                     WHEN Pro.ManejaLinea = Con_NO AND Sal.NumAmortizacion > 1
                                               AND Sal.FrecuenciaCap NOT IN (Var_Semana, Var_Catorcena, Var_Quincena,Var_Mensual) THEN 3
                END AS TipoAmorti,
                CONVERT(Cre.SucursalID, CHAR) AS SucursalID, Sal.DestinoCreID,
                Entero_Cero AS ClasifRegID,
                Cre.MontoCredito,
                Entero_Cero AS PeriodicidadCap, Entero_Cero AS PeriodicidadInt,
                CASE WHEN Cre.FechaVencimien > Par_Fecha THEN
                            (SELECT MIN(Amo.AmortizacionID)
                                FROM AMORTICREDITO Amo
                                WHERE Amo.CreditoID = Cre.CreditoID
                                  AND Amo.FechaVencim > Par_Fecha )

                        WHEN Cre.FechaVencimien <= Par_Fecha THEN
                            (SELECT MAX(Amo.AmortizacionID)
                                FROM AMORTICREDITO Amo
                                WHERE Amo.CreditoID = Cre.CreditoID
                                  AND Amo.FechaVencim <= Par_Fecha )
                END AS UltimaAmorti,


                (SELECT IFNULL(MAX(Det.FechaPago), Fecha_Vacia)
                    FROM DETALLEPAGCRE Det
                    WHERE Det.CreditoID  = Sal.CreditoID
                      AND Det.FechaPago <= Par_Fecha
                      AND (Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen) > Entero_Cero ) AS FecUltPagoCap,

                (SELECT IFNULL(MAX(Det.FechaPago), Fecha_Vacia)
                    FROM DETALLEPAGCRE Det
                    WHERE Det.CreditoID  = Sal.CreditoID
                      AND Det.FechaPago <= Par_Fecha
                      AND (Det.MontoIntAtr + Det.MontoIntOrd + Det.MontoIntVen) > Entero_Cero ) AS FecUltPagoInt,

                (SELECT CONVERT(IFNULL(MAX(FechaRegistro), Fecha_Vacia), CHAR)
                    FROM  CREQUITAS Quita
                    WHERE Quita.CreditoID = Cre.CreditoID
                      AND Quita.FechaRegistro <= Par_Fecha ) AS FechaQuitas,


                '1' AS TipoCredito,
                Sal.EstatusCredito,

                (Sal.SalIntNoConta) AS SalIntCtaOrden,
                (Sal.SaldoMoraCarVen + Sal.SalOtrasComisi + Sal.SaldoComServGar + Sal.SalComFaltaPago) AS  SalMoraCtaOrden,

                CASE WHEN Sal.EstatusCredito = Vencido THEN
                            Sal.SalIntProvision + Sal.SalIntVencido +  Sal.SaldoMoraVencido
                     ELSE Entero_Cero
                END AS EPRCAdiCarVen,

                Entero_Cero AS EPRCAdiSIC,
                Entero_Cero AS EPRCAdiCNVB,

                (SELECT SUM(CASE WHEN NatMovimiento = Tipo_Bloqueo THEN  Blo.MontoBloq ELSE Blo.MontoBloq *-1 END)
                    FROM BLOQUEOS Blo,
                         CUENTASAHO Cue
                    WHERE Blo.CuentaAhoID = Cue.CuentaAhoID
                      AND DATE(FechaMov) <= Par_Fecha
                      AND Blo.Referencia = Sal.CreditoID
                      AND Cue.ClienteID = Sal.ClienteID
                      AND Blo.TiposBloqID = Bloq_GtiaCredito) AS GtiaCtaAhorro,

                (SELECT SUM(Gar.MontoEnGar)
                    FROM CREDITOINVGAR Gar
                    WHERE Gar.FechaAsignaGar <= Par_Fecha
                      AND Gar.CreditoID = Sal.CreditoID) AS GtiaInversion,

                (SELECT SUM(Gar.MontoEnGar)
                    FROM HISCREDITOINVGAR Gar
                    WHERE Gar.Fecha > Par_Fecha
                      AND Gar.FechaAsignaGar <= Par_Fecha
                      AND Gar.ProgramaID NOT IN (Var_ProgramaCierre)
                      AND Gar.CreditoID = Sal.CreditoID  ) AS GtiaHisInver,

                Entero_Cero AS GtiaHipotecaria,

                Dir.EstadoID,
                Dir.MunicipioID,
                Dir.LocalidadID,
                Cre.ClasiDestinCred,

                -- ---------------------------------------
                -- Complementarios. No Forman Parte del Layout
                -- ---------------------------------------
                Entero_Cero AS GtiaMobiliaria,
                Cre.SolicitudCreditoID AS SolicitudCreditoID,

                CASE WHEN Cli.TipoPersona = Moral THEN Per_Moral
                     WHEN Cli.TipoPersona IN (Fisica_empre, Fisica)  THEN Per_Fisica
                END AS TipoPersona,

                Sal.NoCuotasAtraso AS NoCuotasAtraso,
                IFNULL(Cre.InstitFondeoID, Entero_Cero) AS InstitFondeoID


            FROM CREDITOS Cre,
                 CLIENTES Cli,
                 PRODUCTOSCREDITO Pro,
                 SALDOSCREDITOS Sal

            LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Sal.ClienteID
                                            AND IFNULL(Dir.Oficial, Con_NO) = SI

        WHERE Sal.FechaCorte = Par_Fecha
          AND Sal.EstatusCredito IN (Vigente, Vencido)
          AND Sal.CreditoID = Cre.CreditoID
          AND Cli.ClienteID = Sal.ClienteID
          AND Cre.ProductoCreditoID = Pro.ProducCreditoID;

    /* -- ----------------------------------------------------------------------------------------------------
    --------------------  Creditos Pagados en el Mes ---------------------------------------------------------*/

    INSERT INTO TMPREGR04C0452
        SELECT  Aud_NumTransaccion AS NumTransaccion,
                Cre.IdenCreditoCNBV,
                Cre.CreditoID AS NumeroDispo,
                Cadena_Vacia AS ClasifConta,

                Par_Fecha AS FechaCorte,
                Decimal_Cero AS SalInsolutoInicial,

                CASE WHEN Cre.FechaInicio >= Var_FechaIniMesSis THEN
                    Cre.MontoCredito
                ELSE Decimal_Cero END AS MontoDispuesto,
                Decimal_Cero AS SalIntOrdin,
                Decimal_Cero AS SalIntMora,
                Decimal_Cero AS MontoComision,
                Decimal_Cero AS SaldoIVA,
                Decimal_Cero AS SalCapitalExigible,
                Decimal_Cero SalIntExigible,
                Decimal_Cero AS MontoComisionExigible,

                (Sal.PagoCapVigDia + Sal.PagoCapAtrDia + Sal.PagoCapVenDia+ Sal.PagoCapVenNexDia) AS CapitalPagado,
                (Sal.PagoIntOrdDia+Sal.PagoIntVenDia + Sal.PagoIntAtrDia + Sal.PagoIntCalNoCon) AS IntOrdiPagado,
                (Sal.PagoMoratorios) AS IntMoraPagado,
                (Sal.PagoComisiDia) AS MtoComisiPagado,

                Decimal_Cero AS OtrAccesoriosPagado,
                ROUND(Cre.TasaFija,2) AS TasaAnual,

                CASE WHEN IFNULL(Pro.CobraMora,'N') = 'S' AND Pro.TipCobComMorato = Con_NO THEN ROUND(Cre.TasaFija * Pro.FactorMora,2)
                     WHEN IFNULL(Pro.CobraMora,'N') = 'S' AND Pro.TipCobComMorato = 'T' THEN  ROUND(Pro.FactorMora,2)
                     ELSE Decimal_Cero END AS TasaMora,

                Decimal_Cero AS SaldoInsoluto,
                Cre.FechaInicio AS FechaUltDispo,

                DATEDIFF(Cre.FechaVencimien,Cre.FechaInicio) AS PlazoVencimiento,


                Decimal_Cero AS SaldoPrincipalFP,
                CASE WHEN Cre.FechaInicio >= Var_FechaIniMesSis THEN
                    Cre.MontoCredito
                ELSE Decimal_Cero END AS MontoDispuestoFP,
                Decimal_Cero AS CredDisponibleFP,
                ROUND(Cre.TasaFija,2) AS TasaAnualFP,

                CASE WHEN Cre.TipCobComMorato = Con_NO THEN ROUND(Cre.TasaFija * Cre.FactorMora,2)
                     ELSE ROUND(Cre.FactorMora,2) END AS TasaMoraFP,


                Decimal_Cero AS SalIntOrdinFP,
                Decimal_Cero AS SalIntMoraFP,
                Decimal_Cero AS IntereRefinanFP,
                Decimal_Cero AS IntereReversoFP,
                Decimal_Cero AS SaldoPromedioFP,
                Entero_Cero as NumDiasIntFP,
                Decimal_Cero AS MontoComisionFP,
                 (SELECT IFNULL(SUM(MontoCapital + MontoInteres), Entero_Cero)
                    FROM  CREQUITAS Quita
                    WHERE Quita.CreditoID = Cre.CreditoID
                      AND Quita.FechaRegistro BETWEEN Var_FechaIniMesSis AND Par_Fecha ) AS MontoCondonaFP,

                Decimal_Cero AS MontoQuitasFP,
                Decimal_Cero AS MontoBonificaFP,
                Decimal_Cero AS MontoDescuentoFP,
                Decimal_Cero AS MtoAumenDecrePrincFP,

                (Sal.PagoCapVigDia + Sal.PagoCapAtrDia + Sal.PagoCapVenDia+ Sal.PagoCapVenNexDia) AS CapitalPagadoFP,
                (Sal.PagoIntOrdDia+Sal.PagoIntVenDia + Sal.PagoIntAtrDia + Sal.PagoIntCalNoCon) AS IntOrdiPagadoFP,
                (Sal.PagoMoratorios) AS IntMoraPagadoFP,
                (Sal.PagoComisiDia) AS MtoComisiPagadoFP,

                 Decimal_Cero AS OtrAccesoriosPagadoFP,

                (Sal.PagoCapVigDia + Sal.PagoCapAtrDia + Sal.PagoCapVenDia+ Sal.PagoCapVenNexDia +
                  Sal.PagoIntOrdDia+Sal.PagoIntVenDia + Sal.PagoIntAtrDia + Sal.PagoIntCalNoCon +
                  Sal.PagoMoratorios + Sal.PagoComisiDia) AS MontoPagadoEfecFP,

                Decimal_Cero AS SalCapitalFP,
                Decimal_Cero AS SaldoInsolutoFP,
                Cadena_Vacia AS SituacContable,

                Entero_Cero AS TipoRecuperacion,


                 Entero_Cero AS NumDiasAtraso,
                 Cre.FechTerminacion AS FecUltPagoCapFP,
                 (Sal.PagoCapVigDia + Sal.PagoCapAtrDia + Sal.PagoCapVenDia+ Sal.PagoCapVenNexDia +
                  Sal.PagoIntOrdDia+Sal.PagoIntVenDia + Sal.PagoIntAtrDia + Sal.PagoIntCalNoCon +
                  Sal.PagoMoratorios + Sal.PagoComisiDia) AS MontoUltiPagoFP,

                 (SELECT IFNULL(MIN(FechaExigible), Fecha_Vacia)
                    FROM AMORTICREDITO Amo
                    WHERE Amo.CreditoID = Cre.CreditoID
                      AND (Amo.Estatus != Pagado
                       OR  (    Amo.Estatus = Pagado
                           AND  Amo.FechaLiquida  > Par_Fecha ) )
                      AND Amo.FechaExigible <= Par_Fecha ) AS FecPrimAorNoCubFP,


                Sin_Garantia AS TipoGarantia,
                Entero_Cero AS NumGarantias,
                Entero_Cero AS ProgramaCred,
                Decimal_Cero AS MontoTotGarantias,
                Decimal_Cero AS PorcentajeGarantia,
                Entero_Cero AS GradoPrelacionGar,
                Fecha_Vacia AS FechaValuacionGar,
                Entero_Cero AS NumeroAvales,
                Decimal_Cero AS PorcentajeAvales,
                Sin_Aval AS NombreGarante,
                Rfc_Garante AS RFCGarante,
               Entero_Cero AS TipoCartera,
               Cre.ClasiDestinCred AS CredClas,
               Entero_Cero AS CalifCubierta,
               Entero_Cero AS CalifExpuesta,
                EsMarginada_NO AS ZonaMarginada,
                Cadena_Vacia AS ClaveSIC,

                CASE WHEN IFNULL(Cre.TipoFondeo, Cadena_Vacia) = Es_Fondeado THEN Recursos_Fondeados
                     ELSE Recursos_Propios
                END AS TipoRecursos,

                Decimal_Cero AS PorcentajeCubierto,
                Decimal_Cero AS MontoCubierto,
                Decimal_Cero AS ReservaCubierta,
                Decimal_Cero AS PorcentajeExpuesto,
                Decimal_Cero AS MontoExpuesto,
                Decimal_Cero AS ReservaExpuesta,
                Decimal_Cero AS ReservaTotal,
                Decimal_Cero AS ReservaSIC,
                Decimal_Cero AS ReservaAdicional,
                Decimal_Cero AS ReservaAdiCNBV,
                Decimal_Cero AS ResevaAdiTotal,
                Decimal_Cero AS ResevaAdiCtaOrden,
                Decimal_Cero AS EstimaPrevenMesAnt,

                Cre.CreditoID,

                Pro.Descripcion,
                Entero_Cero AS TipoAmorti,

                CONVERT(Cre.SucursalID, CHAR) AS SucursalID, Cre.DestinoCreID,
                Entero_Cero AS ClasifRegID,
                Cre.MontoCredito,
                Entero_Cero AS PeriodicidadCap, Entero_Cero AS PeriodicidadInt,
                CASE WHEN Cre.FechaVencimien > Par_Fecha THEN
                            (SELECT MIN(Amo.AmortizacionID)
                                FROM AMORTICREDITO Amo
                                WHERE Amo.CreditoID = Cre.CreditoID
                                  AND Amo.FechaVencim > Par_Fecha )

                        WHEN Cre.FechaVencimien <= Par_Fecha THEN
                            (SELECT MAX(Amo.AmortizacionID)
                                FROM AMORTICREDITO Amo
                                WHERE Amo.CreditoID = Cre.CreditoID
                                  AND Amo.FechaVencim <= Par_Fecha )
                END AS UltimaAmorti,


                (SELECT IFNULL(MAX(Det.FechaPago), Fecha_Vacia)
                    FROM DETALLEPAGCRE Det
                    WHERE Det.CreditoID  = Cre.CreditoID
                      AND Det.FechaPago <= Par_Fecha
                      AND (Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen) > Entero_Cero ) AS FecUltPagoCap,

                (SELECT IFNULL(MAX(Det.FechaPago), Fecha_Vacia)
                    FROM DETALLEPAGCRE Det
                    WHERE Det.CreditoID  = Cre.CreditoID
                      AND Det.FechaPago <= Par_Fecha
                      AND (Det.MontoIntAtr + Det.MontoIntOrd + Det.MontoIntVen) > Entero_Cero ) AS FecUltPagoInt,

                (SELECT CONVERT(IFNULL(MAX(FechaRegistro), Fecha_Vacia), CHAR)
                    FROM  CREQUITAS Quita
                    WHERE Quita.CreditoID = Cre.CreditoID
                      AND Quita.FechaRegistro <= Par_Fecha ) AS FechaQuitas,


                '1' AS TipoCredito,
                Cre.Estatus,

                Decimal_Cero AS SalIntCtaOrden,
                Decimal_Cero AS  SalMoraCtaOrden,
                Decimal_Cero AS EPRCAdiCarVen,
                Entero_Cero AS EPRCAdiSIC,
                Entero_Cero AS EPRCAdiCNVB,

                (SELECT SUM(CASE WHEN NatMovimiento = Tipo_Bloqueo THEN  Blo.MontoBloq ELSE Blo.MontoBloq *-1 END)
                    FROM BLOQUEOS Blo,
                         CUENTASAHO Cue
                    WHERE Blo.CuentaAhoID = Cue.CuentaAhoID
                      AND DATE(FechaMov) <= Par_Fecha
                      AND Blo.Referencia = Cre.CreditoID
                      AND Cue.ClienteID = Cre.ClienteID
                      AND Blo.TiposBloqID = Bloq_GtiaCredito) AS GtiaCtaAhorro,

                (SELECT SUM(Gar.MontoEnGar)
                    FROM CREDITOINVGAR Gar
                    WHERE Gar.FechaAsignaGar <= Par_Fecha
                      AND Gar.CreditoID = Cre.CreditoID) AS GtiaInversion,

                (SELECT SUM(Gar.MontoEnGar)
                    FROM HISCREDITOINVGAR Gar
                    WHERE Gar.Fecha > Par_Fecha
                      AND Gar.FechaAsignaGar <= Par_Fecha
                      AND Gar.ProgramaID NOT IN (Var_ProgramaCierre)
                      AND Gar.CreditoID = Cre.CreditoID  ) AS GtiaHisInver,

                Entero_Cero AS GtiaHipotecaria,

                Dir.EstadoID,
                Dir.MunicipioID,
                Dir.LocalidadID,
                Cre.ClasiDestinCred,




                Entero_Cero AS GtiaMobiliaria,
                Cre.SolicitudCreditoID AS SolicitudCreditoID,

                CASE WHEN Cli.TipoPersona = Moral THEN Per_Moral
                     WHEN Cli.TipoPersona IN (Fisica_empre, Fisica)  THEN Per_Fisica
                END AS TipoPersona,

                Entero_Cero AS NoCuotasAtraso,
                IFNULL(Cre.InstitFondeoID, Entero_Cero) AS InstitFondeoID


            FROM CREDITOS Cre
                LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cre.ClienteID
                                            AND IFNULL(Dir.Oficial, Con_NO) = SI
                LEFT OUTER JOIN SALDOSCREDITOS Sal ON Sal.CreditoID = Cre.CreditoID
                                            AND Sal.FechaCorte = Cre.FechTerminacion,
                 CLIENTES Cli,
                 PRODUCTOSCREDITO Pro

        WHERE Cre.Estatus in ('P','K','X')
          AND Cre.ProductoCreditoID = Pro.ProducCreditoID
          AND Cre.ClienteID = Cli.ClienteID
          AND Cre.FechTerminacion between Var_FechaIniMesSis AND Par_Fecha;

  /* -- ----------------------------------------------------------------------------------------------------
    -------------------- FIN Creditos Pagados en el Mes ---------------------------------------------------------*/
    -- ------------------------------------
    -- GARANTIAS HIPOTECARIAS ------------- REVISADO.
    -- -------------------------------------
    UPDATE TMPREGR04C0452 Tem, CREGARPRENHIPO Gah SET
        Tem.GtiaHipotecaria = Gah.GarHipotecaria,
        Tem.FechaValuacionGar = Gah.FechaAvaluo

        WHERE Tem.CreditoID = Gah.CreditoID
          AND IFNULL(Gah.CreditoID, Entero_Cero) != Entero_Cero
          AND IFNULL(Gah.GarHipotecaria, Entero_Cero) > Entero_Cero
          AND Tem.NumTransaccion = Aud_NumTransaccion;

    -- FIN GARANTIAS HIPOTECARIAS -------------


    -- -------------------------------------------------
    -- TIPOS DE GARANTIA. ------------- SECCION REVISADA
    -- -------------------------------------------------
    DROP TABLE IF EXISTS TMP_GARANTIAS;
    CREATE TEMPORARY TABLE TMP_GARANTIAS(
        CreditoID   BIGINT PRIMARY KEY,
        MontoAsignado DECIMAL(21,2),
        FechaMaxima DATE
    );

    INSERT INTO TMP_GARANTIAS
    SELECT Asi.CreditoID , IFNULL(SUM(Asi.MontoAsignado), Entero_Cero), Fecha_Vacia
        FROM ASIGNAGARANTIAS Asi,
             GARANTIAS Gar
        WHERE Asi.Estatus = Sta_Autorizada
          AND Asi.GarantiaID = Gar.GarantiaID
          AND Gar.TipoGarantiaID = 2
          AND Asi.CreditoID <> Entero_Cero
          GROUP BY Asi.CreditoID ;

    -- Actualizamos las Garantias, Mobiliarias: Autos, Maquinaria, etc
    UPDATE TMPREGR04C0452 Tem, TMP_GARANTIAS Gar SET
        Tem.GtiaMobiliaria = Gar.MontoAsignado
        WHERE Tem.CreditoID = Gar.CreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion;


    TRUNCATE TMP_GARANTIAS;

    INSERT INTO TMP_GARANTIAS
    SELECT Asi.CreditoID, Entero_Cero, IFNULL(MAX(Gar.FechaValuacion), Fecha_Vacia)
        FROM ASIGNAGARANTIAS Asi,
             GARANTIAS Gar
        WHERE Asi.Estatus = Sta_Autorizada
          AND Asi.GarantiaID = Gar.GarantiaID
          AND IFNULL(Gar.FechaValuacion, Fecha_Vacia) != Fecha_Vacia
          AND Asi.CreditoID <> Entero_Cero
          GROUP BY Asi.CreditoID;

    -- Actualizamos la maxima Fecha de Valuacion de la Garantia
    UPDATE TMPREGR04C0452 Tem, TMP_GARANTIAS Gar SET
        Tem.FechaValuacionGar = Gar.FechaMaxima
        WHERE Tem.CreditoID = Gar.CreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion;



    UPDATE TMPREGR04C0452 Tem SET
        TipoGarantia = CASE WHEN IFNULL(GtiaCtaAhorro, Entero_Cero) > Entero_Cero AND
                                 (IFNULL(GtiaInversion, Entero_Cero) > Entero_Cero OR IFNULL(GtiaHisInver, Entero_Cero) > Entero_Cero) THEN 7
                            WHEN IFNULL(GtiaCtaAhorro, Entero_Cero) > Entero_Cero THEN 2
                            WHEN IFNULL(GtiaInversion, Entero_Cero) > Entero_Cero OR IFNULL(GtiaHisInver, Entero_Cero) > Entero_Cero THEN 3
                            WHEN IFNULL(GtiaHipotecaria, Entero_Cero) >  Entero_Cero THEN 6
                            WHEN IFNULL(GtiaMobiliaria, Entero_Cero)>  Entero_Cero THEN 9
                            ELSE 1
                        END,

        NumGarantias = CASE WHEN IFNULL(GtiaCtaAhorro, Entero_Cero) >  Entero_Cero THEN 1 ELSE Entero_Cero END +
                       CASE WHEN IFNULL(GtiaMobiliaria, Entero_Cero) >  Entero_Cero THEN 1 ELSE Entero_Cero END +
                       CASE WHEN IFNULL(GtiaHipotecaria, Entero_Cero) >  Entero_Cero THEN 1 ELSE Entero_Cero END +
                       CASE WHEN IFNULL(GtiaInversion, Entero_Cero) +  IFNULL(GtiaHisInver, Entero_Cero) >  Entero_Cero THEN 1 ELSE Entero_Cero END -- Campo 59

        WHERE Tem.NumTransaccion = Aud_NumTransaccion;

    -- -------------------------------
    -- AVALES. Campos del 65 al 68. SECCION REVISADA
    -- ---------------------------------

    DELETE FROM TMPR04C0452PAVALES
        WHERE NumTransaccion = Aud_NumTransaccion;

    INSERT INTO TMPR04C0452PAVALES
        SELECT  Aud_NumTransaccion, Avs.SolicitudCreditoID,
                COUNT(*) AS NumAvales,
                IFNULL(MAX(Avs.AvalID), Entero_Cero) AS AvalID,
                IFNULL(MAX(Avs.ProspectoID), Entero_Cero) AS ProspectoID,
                IFNULL(MAX(Avs.ClienteID), Entero_Cero) AS ClienteID,
                Cadena_Vacia AS NombreGarante,
                Cadena_Vacia AS RFCGarante

            FROM AVALESPORSOLICI Avs,
                 TMPREGR04C0452 Tem

            WHERE Tem.NumTransaccion = Aud_NumTransaccion
              AND Tem.SolicitudCreditoID = Avs.SolicitudCreditoID
              AND Avs.Estatus = Sta_Autorizada
            GROUP BY Avs.SolicitudCreditoID;

    -- Actualizamos la informacion del Aval, cuando es un Cliente el Aval
    UPDATE TMPR04C0452PAVALES Tem,
    CLIENTES Cli
SET
    Tem.NombreGarante = CONCAT(IFNULL(Cli.ApellidoPaterno, Cadena_Vacia),
            CASE
                WHEN IFNULL(Cli.ApellidoMaterno, Cadena_Vacia) = Cadena_Vacia THEN Cadena_Vacia
                ELSE CONCAT(Espacio_blanco, Cli.ApellidoMaterno)
            END,
            CONCAT(Espacio_blanco,
                    IFNULL(Cli.PrimerNombre, Cadena_Vacia)),
            CASE
                WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) = Cadena_Vacia THEN Cadena_Vacia
                ELSE CONCAT(Espacio_blanco, Cli.SegundoNombre)
            END,
            CASE
                WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) = Cadena_Vacia THEN Cadena_Vacia
                ELSE CONCAT(Espacio_blanco, Cli.TercerNombre)
            END),
    Tem.RFCGarante = Cli.RFCOficial
WHERE
    Tem.NumTransaccion = Aud_NumTransaccion
        AND Tem.ClienteID != Entero_Cero
        AND Tem.ClienteID = Cli.ClienteID;

    -- Actualizamos la informacion del Aval, cuando es un Prospecto el Aval
    UPDATE TMPR04C0452PAVALES Tem,
    PROSPECTOS Pro
SET
    Tem.NombreGarante = CONCAT(IFNULL(Pro.ApellidoPaterno, Cadena_Vacia),
            CASE
                WHEN IFNULL(Pro.ApellidoMaterno, Cadena_Vacia) = Cadena_Vacia THEN Cadena_Vacia
                ELSE CONCAT(Espacio_blanco, Pro.ApellidoMaterno)
            END,
            CONCAT(Espacio_blanco,
                    IFNULL(Pro.PrimerNombre, Cadena_Vacia)),
            CASE
                WHEN IFNULL(Pro.SegundoNombre, Cadena_Vacia) = Cadena_Vacia THEN Cadena_Vacia
                ELSE CONCAT(Espacio_blanco, Pro.SegundoNombre)
            END,
            CASE
                WHEN IFNULL(Pro.TercerNombre, Cadena_Vacia) = Cadena_Vacia THEN Cadena_Vacia
                ELSE CONCAT(Espacio_blanco, Pro.TercerNombre)
            END),
    Tem.RFCGarante = Pro.RFC
WHERE
    Tem.NumTransaccion = Aud_NumTransaccion
        AND Tem.ClienteID = Entero_Cero
        AND Tem.ProspectoID != Entero_Cero
        AND Tem.ProspectoID = Pro.ProspectoID;

    -- Actualizamos la informacion del Aval, cuando el Aval No es Cliente
    UPDATE TMPR04C0452PAVALES Tem, AVALES Avl SET
        Tem.NombreGarante = CONCAT(IFNULL(Avl.ApellidoPaterno,Cadena_Vacia),
                                   CASE WHEN IFNULL(Avl.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
                                        THEN Cadena_Vacia ELSE CONCAT(Espacio_blanco, Avl.ApellidoMaterno) END,
                                   CONCAT(Espacio_blanco,IFNULL(Avl.PrimerNombre,Cadena_Vacia)),
                                   CASE WHEN IFNULL(Avl.SegundoNombre,Cadena_Vacia) = Cadena_Vacia
                                        THEN Cadena_Vacia ELSE CONCAT(Espacio_blanco,Avl.SegundoNombre) END,
                                   CASE WHEN IFNULL(Avl.TercerNombre,Cadena_Vacia)  = Cadena_Vacia
                                        THEN Cadena_Vacia ELSE CONCAT(Espacio_blanco,Avl.TercerNombre) END ),
        Tem.RFCGarante = Avl.RFC

        WHERE Tem.NumTransaccion = Aud_NumTransaccion
          AND Tem.ClienteID = Entero_Cero
          AND Tem.AvalID    != Entero_Cero
          AND Tem.AvalID  = Avl.AvalID;
UPDATE TMPREGR04C0452 Tem,
    TMPR04C0452PAVALES Avl
SET
    Tem.NumeroAvales = Avl.NumAvales,
    Tem.NombreGarante = FNLIMPIACARACTERESGEN(Avl.NombreGarante, Var_Mayusculas),
    Tem.RFCGarante = Avl.RFCGarante,
    Tem.PorcentajeAvales = CASE
        WHEN Avl.NumAvales = Entero_Cero THEN Entero_Cero
        ELSE Var_CienPorCiento
    END
WHERE
    Tem.SolicitudCreditoID = Avl.SolicitudCreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion
        AND Avl.NumTransaccion = Aud_NumTransaccion;

DELETE FROM TMPR04C0452PAVALES
WHERE
    NumTransaccion = Aud_NumTransaccion;

    -- FIN DE LA SECCION DE AVALES -------------------

    -- -------------------------------------------------------
    -- SITUACION DEL CREDITO. Campo 52 -----------------------
    -- -------------------------------------------------------

    UPDATE TMPREGR04C0452 Prin
SET
    SituacContable = CASE
        WHEN
            EstatusCredito = Vigente
                AND NumDiasAtraso = Entero_Cero
        THEN
            '1'
        WHEN
            EstatusCredito = Vigente
                AND NumDiasAtraso >= 1
        THEN
            '2'
        WHEN EstatusCredito = Vencido THEN '3'
        WHEN EstatusCredito in ('P','K') THEN '1'
    END
WHERE
    Prin.NumTransaccion = Aud_NumTransaccion;



    UPDATE TMPREGR04C0452 Prin,
    REESTRUCCREDITO Res
SET
    TipoCredito = CASE
        WHEN Origen = Cred_Resstructura THEN '3'
        WHEN Origen = Cred_Renovacion THEN '2'
        ELSE TipoCredito
    END
WHERE
    Prin.CreditoID = Res.CreditoDestinoID
        AND Prin.NumTransaccion = Aud_NumTransaccion;


    UPDATE TMPREGR04C0452 Prin,
    AMORTICREDITO Amo
SET
    Prin.PeriodicidadCap = DATEDIFF(Amo.FechaVencim, Amo.FechaInicio),
    Prin.PeriodicidadInt = DATEDIFF(Amo.FechaVencim, Amo.FechaInicio)
WHERE
    Prin.CreditoID = Amo.CreditoID
        AND Prin.UltimaAmorti = Amo.AmortizacionID
        AND Prin.NumTransaccion = Aud_NumTransaccion;



    -- --------------------------------------------------
    -- MONTO DEL ULTIMO PAGO COMPLETO EXIGIBLE REALIZADO.- REVISADO
    -- --------------------------------------------------

    DELETE FROM TMPR04C0452PAGEXI
WHERE
    NumTransaccion = Aud_NumTransaccion;

    INSERT INTO TMPR04C0452PAGEXI
        SELECT Tem.CreditoID, MAX(Amo.FechaLiquida), MAX(Amo.AmortizacionID), Aud_NumTransaccion
            FROM TMPREGR04C0452 Tem,
                 AMORTICREDITO Amo
            WHERE Tem.CreditoID = Amo.CreditoID
              AND Tem.NumTransaccion = Aud_NumTransaccion
              AND IFNULL(Amo.FechaLiquida, Fecha_Vacia) <> Fecha_Vacia
              AND Amo.Estatus = Pagado
              AND Amo.FechaLiquida <= Par_Fecha
              AND Amo.FechaExigible <= Par_Fecha
               GROUP BY Tem.CreditoID;

    DELETE FROM TMPR04C0452PAGOS
        WHERE NumTransaccion = Aud_NumTransaccion;

    INSERT INTO TMPR04C0452PAGOS
        SELECT  Det.CreditoID,
                MAX(Exi.FechaLiquida),
                SUM(Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen +
                    Det.MontoIntAtr + Det.MontoIntOrd + Det.MontoIntVen + Det.MontoIntMora +
                    Det.MontoComision + Det.MontoGastoAdmon + Det.MontoComAnual),
                 Aud_NumTransaccion
            FROM TMPR04C0452PAGEXI Exi,
                 DETALLEPAGCRE Det
            WHERE Det.CreditoID = Exi.CreditoID
              AND Det.FechaPago = Exi.FechaLiquida
              AND Det.AmortizacionID = Exi.AmortizacionID

            GROUP BY Det.CreditoID;

    UPDATE TMPREGR04C0452 Prin,
    TMPR04C0452PAGOS Tem
SET
    Prin.FecUltPagoCapFP = Tem.FechaPago,-- Campo 55
    Prin.MontoUltiPagoFP = Tem.MontoPago-- Campo 56
WHERE
    Prin.CreditoID = Tem.CreditoID
        AND Prin.NumTransaccion = Aud_NumTransaccion
        AND Tem.NumTransaccion = Aud_NumTransaccion;

    -- Consideraciones de Cuotas Pagadas, pero que en la migracion no poblaron DETALLEPAGCRE
    UPDATE TMPREGR04C0452 Prin,
    TMPR04C0452PAGEXI Tem,
    AMORTICREDITO Amo
SET
    Prin.FecUltPagoCapFP = Tem.FechaLiquida,
    Prin.MontoUltiPagoFP = Amo.Capital + Amo.Interes
WHERE
    Prin.CreditoID = Tem.CreditoID
        AND Prin.FecUltPagoCapFP = Fecha_Vacia
        AND Prin.MontoUltiPagoFP = Entero_Cero
        AND Prin.NumTransaccion = Aud_NumTransaccion
        AND Tem.CreditoID = Amo.CreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion
        AND Tem.AmortizacionID = Amo.AmortizacionID
        AND Tem.FechaLiquida != Fecha_Vacia;

    DELETE FROM TMPR04C0452PAGEXI
WHERE
    NumTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPR04C0452PAGOS
WHERE
    NumTransaccion = Aud_NumTransaccion;



    -- FIN ULTIMOS PAGOS COMPLETOS REALIZADOS


    -- -------------------------------------
    -- Monto de pagos Realizados -----------
    -- -------------------------------------
    DROP TABLE IF EXISTS TMP_PAGOSCREDITOS;

    CREATE temporary TABLE TMP_PAGOSCREDITOS(
        CreditoID       BIGINT,
        CapitalPagado   DECIMAL(16,2),
        MontoInteres    DECIMAL(16,2),
        MontoMoratorio  DECIMAL(16,2),
        MontoComisiones DECIMAL(16,2),

        PeriodoCapitalPagado    DECIMAL(16,2),
        PeriodoMontoInteres     DECIMAL(16,2),
        PeriodoMontoMoratorio   DECIMAL(16,2),
        PeriodoMontoComisiones  DECIMAL(16,2)

        );

    CREATE INDEX idx_TMP_PAGOSCREDITOS_1 ON TMP_PAGOSCREDITOS(CreditoID);

    INSERT INTO TMP_PAGOSCREDITOS
        SELECT Det.CreditoID,
            SUM(Det.MontoCapOrd + Det.MontoCapAtr + Det.MontoCapVen) AS CapitalPagado,
            SUM(Det.MontoIntOrd + Det.MontoIntAtr + Det.MontoIntVen) AS MontoInteres,
            SUM(Det.MontoIntMora) AS MontoMoratorio,
            SUM(Det.MontoComision) AS MontoComisiones,

            SUM(CASE WHEN FechaPago >= Var_FechaIniMesSis THEN (Det.MontoCapOrd + Det.MontoCapAtr + Det.MontoCapVen)
                     ELSE Entero_Cero
                END) AS PeriodoCapitalPagado,

            SUM(CASE WHEN FechaPago >= Var_FechaIniMesSis THEN (Det.MontoIntOrd + Det.MontoIntAtr + Det.MontoIntVen)
                     ELSE Entero_Cero
                END) AS PeriodoMontoInteres,

            SUM(CASE WHEN FechaPago >= Var_FechaIniMesSis THEN Det.MontoIntMora
                     ELSE Entero_Cero
                END) AS PeriodoMontoMoratorio,

            SUM(CASE WHEN FechaPago >= Var_FechaIniMesSis THEN Det.MontoComision
                     ELSE Entero_Cero
                END) AS PeriodoMontoComisiones

        FROM DETALLEPAGCRE Det,
             TMPREGR04C0452 Tem
        WHERE Tem.CreditoID = Det.CreditoID
          AND Tem.NumTransaccion = Aud_NumTransaccion
          AND Det.FechaPago <=  Par_Fecha
        GROUP BY Det.CreditoID;


UPDATE TMPREGR04C0452 Tem,
    TMP_PAGOSCREDITOS Pag
SET
    Tem.CapitalPagado = IFNULL(Pag.CapitalPagado, Entero_Cero),
    Tem.IntOrdiPagado = IFNULL(Pag.MontoInteres, Entero_Cero),
    Tem.IntMoraPagado = IFNULL(Pag.MontoMoratorio, Entero_Cero),
    Tem.MtoComisiPagado = IFNULL(Pag.MontoComisiones, Entero_Cero),
    Tem.CapitalPagadoFP = IFNULL(Pag.PeriodoCapitalPagado, Entero_Cero),
    Tem.IntOrdiPagadoFP = IFNULL(Pag.PeriodoMontoInteres, Entero_Cero),
    Tem.IntMoraPagadoFP = IFNULL(Pag.PeriodoMontoMoratorio, Entero_Cero),
    Tem.MtoComisiPagadoFP = IFNULL(Pag.PeriodoMontoComisiones, Entero_Cero),
    Tem.MontoPagadoEfecFP = IFNULL(Pag.PeriodoCapitalPagado, Entero_Cero) + IFNULL(PeriodoMontoInteres, Entero_Cero) + IFNULL(PeriodoMontoMoratorio, Entero_Cero) + IFNULL(PeriodoMontoComisiones, Entero_Cero)
WHERE
    Tem.CreditoID = Pag.CreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion;

    -- --------------------------------------
    -- -- LOCALIDADES MARGINADAS  Campo 72--- REVISADO
    -- --------------------------------------


UPDATE TMPREGR04C0452 Tem,
    LOCALIDADREPUB Loc
SET
    Tem.ZonaMarginada = CASE
        WHEN Loc.EsMarginada = Valor_SI THEN EsMarginada_SI
        ELSE EsMarginada_NO
    END
WHERE
    Tem.NumTransaccion = Aud_NumTransaccion
        AND Tem.EstadoID = Loc.EstadoID
        AND Tem.MunicipioID = Loc.MunicipioID
        AND Tem.LocalidadID = Loc.LocalidadID;

    -- ---------------------------------------------------------------
    -- TIPO DE CARTERA PARA FINES DE CALIFICACION. Campo 69. --------- REVISADO
    -- ---------------------------------------------------------------
    UPDATE TMPREGR04C0452 Tem,
    DESTINOSCREDITO Des
SET
    Tem.ClasifRegID = Des.ClasifRegID,
    Tem.TipoCartera = CASE
        WHEN
            Des.Clasificacion = Cred_Consumo
                AND GtiaHipotecaria = Entero_Cero
                AND ZonaMarginada = EsMarginada_NO
        THEN
            Tipo_Consumo
        WHEN
            Des.Clasificacion = Cred_Consumo
                AND ZonaMarginada = EsMarginada_SI
        THEN
            Cons_Marginado
        WHEN
            Des.Clasificacion = Cred_Consumo
                AND GtiaHipotecaria > Entero_Cero
        THEN
            Cons_GarHipo
        WHEN Des.Clasificacion = Cred_Comercial THEN Com_SinReest
        WHEN
            Des.Clasificacion = Cred_Vivienda
                AND GtiaHipotecaria > Entero_Cero
        THEN
            Viv_GarHipo
        WHEN
            Des.Clasificacion = Cred_Vivienda
                AND GtiaHipotecaria = Entero_Cero
                AND ZonaMarginada = EsMarginada_NO
        THEN
            Viv_SinGar
        WHEN
            Des.Clasificacion = Cred_Vivienda
                AND GtiaHipotecaria = Entero_Cero
                AND ZonaMarginada = EsMarginada_SI
        THEN
            Viv_ConGar
    END
WHERE
    Tem.DestinoCreID = Des.DestinoCreID
        AND Tem.NumTransaccion = Aud_NumTransaccion;

    -- Cartera Tipo II. Reestructurada y Renovada
    UPDATE TMPREGR04C0452 Tem,
    REESTRUCCREDITO Res
SET
    Tem.TipoCartera = CASE
        WHEN Tem.TipoCartera = Com_SinReest THEN Com_ConReest
        WHEN Tem.TipoCartera IN (Viv_SinGar , Viv_ConGar) THEN Viv_Emproble
        ELSE Tem.TipoCartera
    END
WHERE
    Tem.CreditoID = Res.CreditoDestinoID
        AND Res.Origen = Cred_Resstructura
        AND Tem.NumTransaccion = Aud_NumTransaccion;




    -- FIN TIPO DE CARTERA PARA FINES DE CALIFICACION.

    -- ------------------------------------------------------
    -- Clasificacion Contable. Campo 6
    -- ------------------------------------------------------
    UPDATE TMPREGR04C0452 Tem,
    CATCLASIFREPREG Cat
SET
    Tem.ClasifConta = CASE
        WHEN Tem.EstatusCredito = Vigente THEN Cat.ClavePorDestino
        WHEN Tem.EstatusCredito = 'B' THEN Cat.ClasifContaVenc
        WHEN Tem.EstatusCredito in ('P','K') THEN Cat.ClavePorDestino
        ELSE Cat.ClasifContaVenc
    END
WHERE
    Tem.ClasifRegID = Cat.ClasifRegID
        AND Tem.NumTransaccion = Aud_NumTransaccion;

    -- ------------------------------------------------------
    -- ESTIMACIONES PREVENTIVAS -----------------------------
    -- CAMPOS 75 AL 87 --------------------------------------
    -- ------------------------------------------------------
    SELECT
    MAX(Fecha)
INTO Var_UltFecEPRC FROM
    CALRESCREDITOS
WHERE
    Fecha <= Par_Fecha;

    SET Var_UltFecEPRC := IFNULL(Var_UltFecEPRC, Fecha_Vacia);

    UPDATE TMPREGR04C0452 Tem,  CALRESCREDITOS Res SET

        Tem.PorcentajeCubierto = Res.PorcReservaCub,
        Tem.MontoCubierto = Res.MontoBaseEstCub,
        Tem.ReservaCubierta = IFNULL(Res.ReservaTotCubierto, Entero_Cero),
        Tem.PorcentajeExpuesto = Res.PorcReservaExp,
        Tem.MontoExpuesto = Res.MontoBaseEstExp,
        Tem.ReservaExpuesta = IFNULL(Res.ReservaTotExpuesto, Entero_Cero),
        Tem.ReservaTotal = IFNULL(Res.Reserva, Entero_Cero),
        Tem.MontoTotGarantias = Res.MontoGarantia,
        Tem.PorcentajeGarantia = CASE WHEN Tem.SaldoInsoluto >  Entero_Cero THEN
                                         Res.MontoGarantia / Tem.SaldoInsoluto
                                  ELSE Entero_Cero
                            END
        WHERE Tem.CreditoID = Res.CreditoID
          AND Res.Fecha = Var_UltFecEPRC
          AND Tem.NumTransaccion = Aud_NumTransaccion;


    -- Estimaciones del Mes Anterior, Campo 87
UPDATE TMPREGR04C0452 Tem,
    CALRESCREDITOS Res
SET
    Tem.EstimaPrevenMesAnt = IFNULL(Res.Reserva, Entero_Cero)
WHERE
    Tem.CreditoID = Res.CreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion
        AND Res.Fecha = Var_MesAnterior;


    -- FIN ESTIMACIONES PREVENTIVAS ------------------

    -- --------------------------------------------------------------
    -- ======== SALDO INSOLUTO INICIAL DEL PERIODO. Campo 8 y 27
    -- --------------------------------------------------------------
    DROP TABLE IF EXISTS TMP_SALDOSINICIALES;

    CREATE temporary TABLE TMP_SALDOSINICIALES
        SELECT Sal.CreditoID,

                (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi +
                 Sal.SalIntProvision + Sal.SalIntAtrasado + Sal.SalIntVencido+
                 Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen ) AS SaldoInsoluto,

                (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) AS SaldoPrincipal


        FROM SALDOSCREDITOS Sal
        WHERE Sal.FechaCorte = Var_MesAnterior;

    CREATE INDEX idx_TMP_SALDOSINICIALES_1 ON TMP_SALDOSINICIALES(CreditoID);

UPDATE TMPREGR04C0452 Tem,
    TMP_SALDOSINICIALES Sal
SET
    Tem.SalInsolutoInicial = Sal.SaldoInsoluto,-- Campo 8. Saldo Insoluto Inicial
    Tem.SaldoPrincipalFP = Sal.SaldoPrincipal -- Campo 27. Saldo de Principal al Inicio del Periodo
WHERE
    Tem.CreditoID = Sal.CreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion;

    -- -------------------------------------------------
    -- CLAVE SIC. CAMPO 73. SECCION REVISAD0 ------------
    -- -------------------------------------------------

    -- Considerar si consulta en Buro o en Circulo de Credito
    SELECT
    ConBuroCreDefaut
INTO Var_TipoSIC FROM
    PARAMETROSSIS;

    SET Var_TipoSIC := IFNULL(Var_TipoSIC, SIC_BuroCredito);

    IF(Var_TipoSIC = SIC_BuroCredito) THEN

        -- De Forma de Pago MOP de acuerdo a Buro de Credito
        UPDATE TMPREGR04C0452 Tem SET
            ClaveSIC = CASE  WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) = Entero_Cero       THEN '10001'   -- Cuenta al Corriente
                             WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 1   AND 29  THEN '10002'   -- Atrasos entre 1 y 29 Dias
                             WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 30  AND 59  THEN '10003'   -- Atrasos entre 30 y 59 Dias
                             WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 60  AND 89  THEN '10004'   -- Atrasos entre 60 y 89 Dias
                             WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 90  AND 119 THEN '10005'   -- Atrasos entre 90 y 119 Dias
                             WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 120 AND 149 THEN '10006'   -- Atrasos entre 120 y 149 Dias
                             WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 150 AND 360 THEN '10007'   -- Atrasos entre 150 y 360 Dias
                             WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) > 360 THEN '10008'                 -- Mas de 360 Dias de atraso
                        END

            WHERE Tem.TipoPersona = Per_Fisica
              AND Tem.NumTransaccion = Aud_NumTransaccion;

    ELSE

        UPDATE TMPREGR04C0452 Tem SET
            ClaveSIC =  CASE WHEN Tem.NoCuotasAtraso = Entero_Cero THEN Pago_Vigente
                             WHEN Tem.NoCuotasAtraso > Entero_Cero AND Tem.NoCuotasAtraso < 84 THEN
                                    CONCAT('200', LPAD(CONVERT(Tem.NoCuotasAtraso, CHAR), 2, '0'))
                             ELSE '20084'
                        END

            WHERE Tem.TipoPersona = Per_Fisica
              AND Tem.NumTransaccion = Aud_NumTransaccion;


    END IF;


    -- CUANDO SE TRATA DE UNA PERSONA MORAL
    UPDATE TMPREGR04C0452 Tem
SET
    ClaveSIC = CONCAT('3',
            LPAD(IFNULL(NumDiasAtraso, Entero_Cero),
                    4,
                    Entero_Cero))
WHERE
    IFNULL(NumDiasAtraso, Entero_Cero) BETWEEN 0 AND 2160
        AND Tem.TipoPersona = Per_Moral
        AND Tem.NumTransaccion = Aud_NumTransaccion;

UPDATE TMPREGR04C0452 Tem
SET
    ClaveSIC = '33000'
WHERE
    IFNULL(NumDiasAtraso, Entero_Cero) > 2160
        AND Tem.TipoPersona = Per_Moral
        AND Tem.NumTransaccion = Aud_NumTransaccion;

    -- FIN CLAVE SIC.
    -- --------------------------------------------------------
    -- TIPO DE RECURSOS, FUENTE DE FONDEO. CAMPO 74. SECCION REVISADA
    -- --------------------------------------------------------
UPDATE TMPREGR04C0452 Tem
        INNER JOIN
    INSTITUTFONDEO Inf ON Inf.InstitutFondID = Tem.InstitFondeoID
        LEFT OUTER JOIN
    INSTITUCIONES Ins ON Ins.InstitucionID = Inf.InstitucionID
        LEFT OUTER JOIN
    TIPOSINSTITUCION Tip ON Tip.TipoInstitID = Ins.TipoInstitID
SET
    Tem.TipoRecursos = CASE
        WHEN Inf.TipoFondeador IN (Fon_PerFisica , Fon_PerMoral, Fon_PerActEmp) THEN 10
        WHEN
            Inf.TipoFondeador = Fon_Gubernamental
                AND IFNULL(Tip.NacionalidadIns, Cadena_Vacia) = Extranjero
        THEN
            4
        WHEN
            Inf.TipoFondeador = Fon_Gubernamental
                AND IFNULL(Tip.NacionalidadIns, Cadena_Vacia) = Nacional
                AND (IFNULL(Tip.EsBancaDesarrollo, Cadena_Vacia) = Valor_SI
                OR IFNULL(Tip.EsFideicomiso, Cadena_Vacia) = Valor_SI)
        THEN
            9
        WHEN
            Inf.TipoFondeador = Fon_Gubernamental
                AND IFNULL(Tip.NacionalidadIns, Cadena_Vacia) = Nacional
                AND (IFNULL(Tip.EsSOFOM, Cadena_Vacia) = Valor_SI
                OR IFNULL(Tip.EsSOFOL, Cadena_Vacia) = Valor_SI)
        THEN
            5
        WHEN
            Inf.TipoFondeador = Fon_Gubernamental
                AND IFNULL(Tip.NacionalidadIns, Cadena_Vacia) = Nacional
                AND (IFNULL(Tip.EsBancaComercial, Cadena_Vacia) = Valor_SI
                OR IFNULL(Tip.EsSOFIPO, Cadena_Vacia) = Valor_SI)
        THEN
            3
    END
WHERE
    Tem.TipoRecursos = 9
        AND Tem.NumTransaccion = Aud_NumTransaccion;


    -- -----------------------------------------------------
    -- Monto de Comisiones Cargadas en el Periodo. Campo 12
    -- -----------------------------------------------------
    DROP TABLE IF EXISTS TMPREG452COMISIONES;
    CREATE temporary TABLE TMPREG452COMISIONES(
        CreditoID   BIGINT,
        Comisiones  DECIMAL(16,2)
    );

    CREATE INDEX idx_TMPREG452COMISIONES_1 ON TMPREG452COMISIONES(CreditoID);

    INSERT INTO TMPREG452COMISIONES
        SELECT Tem.CreditoID, SUM(Cantidad)
            FROM TMPREGR04C0452 Tem,
                CREDITOSMOVS Mov
            WHERE Tem.CreditoID = Mov.CreditoID
              AND Mov.FechaOperacion BETWEEN Var_FechaIniMesSis AND Par_Fecha
              AND Mov.TipoMovCreID IN (Mov_ComFalPago, Mov_ComAdmon, Mov_ComAnualidad)
              AND Mov.NatMovimiento = Nat_Cargo
            GROUP BY Tem.CreditoID;

    UPDATE TMPREGR04C0452 Tem,
    TMPREG452COMISIONES Com
SET
    Tem.MontoComision = Com.Comisiones,
    Tem.MontoComisionFP = Com.Comisiones
WHERE
    Tem.CreditoID = Com.CreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion;

    DROP TABLE IF EXISTS TMPREG452COMISIONES;

    -- -----------------------------------------------------
    -- Monto Exigible de Capital a la Fecha de Corte. Campo 14
    -- -----------------------------------------------------
    DROP TABLE IF EXISTS TMPEXISIGPERIODO;

    CREATE TABLE TMPEXISIGPERIODO (
    CreditoID BIGINT NOT NULL,
    AmortizacionID INT,
    ExigibleSigPeriodo DECIMAL(16 , 2 ),
    INDEX TMPEXISIGPERIODO_1 (CreditoID),
    INDEX TMPEXISIGPERIODO_2 (CreditoID , AmortizacionID)
);

    INSERT INTO TMPEXISIGPERIODO
        SELECT  Tem.CreditoID, MIN(AmortizacionID), Entero_Cero

            FROM AMORTICREDITO Amo,
                 TMPREGR04C0452 Tem
            WHERE Tem.CreditoID = Amo.CreditoID
              AND Amo.FechaExigible > Par_Fecha
              AND ( Amo.Estatus != Pagado
                    OR (Amo.Estatus = Pagado AND Amo.FechaLiquida > Par_Fecha) )
            GROUP BY Tem.CreditoID;

    UPDATE TMPEXISIGPERIODO Tem,
    AMORTICREDITO Amo
SET
    Tem.ExigibleSigPeriodo = Amo.Capital
WHERE
    Tem.CreditoID = Amo.CreditoID
        AND Tem.AmortizacionID = Amo.AmortizacionID;

    UPDATE TMPREGR04C0452 Tem,
    TMPEXISIGPERIODO Per
SET
    Tem.SalCapitalExigible = Tem.SalCapitalExigible + Per.ExigibleSigPeriodo
WHERE
    Tem.CreditoID = Per.CreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion;

    DROP TABLE IF EXISTS TMPREG452COMISIONES;
    -- -----------------------------------------------------

    UPDATE TMPREGR04C0452 Tem
SET
    Tem.NombreGarante = LTRIM(RTRIM(SUBSTRING(Tem.NombreGarante, 1, 250))),
    Tem.CapitalPagado = IFNULL(Tem.CapitalPagado,Entero_Cero),
    Tem.IntOrdiPagado = IFNULL(Tem.IntOrdiPagado,Entero_Cero),
    Tem.IntMoraPagado = IFNULL(Tem.IntMoraPagado,Entero_Cero),
    Tem.MtoComisiPagado = IFNULL(Tem.MtoComisiPagado,Entero_Cero),
    Tem.CapitalPagadoFP = IFNULL(Tem.CapitalPagadoFP,Entero_Cero),
    Tem.IntOrdiPagadoFP = IFNULL(Tem.IntOrdiPagadoFP,Entero_Cero),
    Tem.IntMoraPagadoFP = IFNULL(Tem.IntMoraPagadoFP,Entero_Cero),
    Tem.MtoComisiPagadoFP = IFNULL(Tem.MtoComisiPagadoFP,Entero_Cero),
    Tem.MontoPagadoEfecFP = IFNULL(Tem.MontoPagadoEfecFP,Entero_Cero),
    Tem.SituacContable = IFNULL(Tem.SituacContable,1),
    Tem.ReservaTotal = IFNULL(ReservaExpuesta,Entero_Cero)+IFNULL(ReservaCubierta,Entero_Cero)
WHERE
    Tem.NumTransaccion = Aud_NumTransaccion;





/* Validacion por tipo de Recuperacion */
UPDATE TMPREGR04C0452 SET
     TipoRecuperacion = 2
WHERE NumTransaccion = Aud_NumTransaccion
and SituacContable = 3 AND TipoRecuperacion = 0;
/*
UPDATE TMPREGR04C0452 SET
     FechaValuacionGar = Fecha_Vacia
WHERE TipoGarantia = 1 AND MontoTotGarantias = 0;
*/
UPDATE TMPREGR04C0452 SET
     FechaValuacionGar = Fecha_Vacia
WHERE  NumTransaccion = Aud_NumTransaccion
and TipoGarantia = 1 AND MontoTotGarantias = 0;


update TMPREGR04C0452 set
    NumeroAvales = 0,
    PorcentajeAvales = 0  ,
    RFCGarante = Rfc_Garante,
    NombreGarante = 'SIN AVAL'
where  NumTransaccion = Aud_NumTransaccion
and ifnull(NombreGarante,'') = '';

update TMPREGR04C0452 set
    TipoGarantia = 2,
    NumGarantias = 1
where  NumTransaccion = Aud_NumTransaccion
and MontoTotGarantias <> 0;

update TMPREGR04C0452 set
    NumeroAvales = 1,
    PorcentajeAvales = 100
where  NumTransaccion = Aud_NumTransaccion
and NombreGarante <> 'SIN AVAL'
and NombreGarante <> '';


update TMPREGR04C0452 set
    TipoGarantia = 1,
    NumGarantias = 0,
    PorcentajeGarantia = 0,
    ProgramaCred = 0,
    GradoPrelacionGar = 0,
    FechaValuacionGar = Fecha_Vacia
where NumTransaccion = Aud_NumTransaccion
and  EstatusCredito in ('P','K')
or (TipoGarantia <> 1 AND MontoTotGarantias = 0);


update TMPREGR04C0452 Tem,CREDITOS Cre set
    Tem.FechaValuacionGar = Cre.FechaMinistrado
where Tem.NumTransaccion = Aud_NumTransaccion
and Tem.CreditoID = Cre.CreditoID
and Tem.TipoGarantia = 2 AND Tem.MontoTotGarantias > 0;


IF(Par_NumReporte = Rep_Excel) THEN
        SELECT  Var_Periodo,
                Var_ClaveEntidad,
                For_0452,
                IdenCreditoCNBV,
                NumeroDispo,
                ClasifConta ,
                date_format(FechaCorte,'%Y%m%d') AS FechaCorte,
                SalInsolutoInicial ,
                MontoDispuesto ,
                SalIntOrdin ,
                SalIntMora ,
                MontoComision ,
                SaldoIVA ,
                SalCapitalExigible ,
                SalIntExigible ,
                MontoComisionExigible ,
                CapitalPagado ,
                IntOrdiPagado ,
                IntMoraPagado ,
                MtoComisiPagado ,
                OtrAccesoriosPagado ,
                TasaAnual ,
                TasaMora ,
                SaldoInsoluto ,
                date_format(FechaUltDispo,'%Y%m%d') AS FechaUltDispo,
                PlazoVencimiento,
                SaldoPrincipalFP,
                MontoDispuestoFP,
                CredDisponibleFP,
                TasaAnualFP,
                TasaMoraFP,
                SalIntOrdinFP,
                SalIntMoraFP,
                IntereRefinanFP,
                IntereReversoFP,
                SaldoPromedioFP,
                NumDiasIntFP,
                MontoComisionFP,
                MontoCondonaFP,
                MontoQuitasFP,
                MontoBonificaFP,
                MontoDescuentoFP,
                MtoAumenDecrePrincFP,
                CapitalPagadoFP,
                IntOrdiPagadoFP,
                IntMoraPagadoFP,
                MtoComisiPagadoFP,
                OtrAccesoriosPagadoFP,
                MontoPagadoEfecFP,
                SalCapitalFP ,
                SaldoInsolutoFP,
                SituacContable,
                TipoRecuperacion,
                NumDiasAtraso,

                CASE WHEN FecUltPagoCapFP = Fecha_Vacia THEN DATE_FORMAT(Par_Fecha, '%Y%m%d')
                     ELSE DATE_FORMAT(FecUltPagoCapFP, '%Y%m%d')
                END AS FechaUltPagoCompleto,

                MontoUltiPagoFP,
                CASE WHEN FecPrimAorNoCubFP = Fecha_Vacia THEN Clave_FechaVacia
                     ELSE DATE_FORMAT(FecPrimAorNoCubFP, '%Y%m%d')
                END AS FechaPrimAmortizacionNC,

                TipoGarantia ,
                NumGarantias ,
                ProgramaCred ,
                MontoTotGarantias ,
                PorcentajeGarantia ,
                GradoPrelacionGar ,

                CASE WHEN FechaValuacionGar = Fecha_Vacia THEN Clave_FechaVacia
                     ELSE DATE_FORMAT(FechaValuacionGar, '%Y%m%d')
                END AS FechaValuacion,

                NumeroAvales,
                PorcentajeAvales,
                NombreGarante,
                RFCGarante,
                TipoCartera,
                CalifCubierta,
                CalifExpuesta ,
                ZonaMarginada,
                CONVERT(ClaveSIC, UNSIGNED) AS ClavePrevencion,
                TipoRecursos,
                PorcentajeCubierto,
                MontoCubierto,
                ReservaCubierta,
                PorcentajeExpuesto,
                MontoExpuesto,
                ReservaExpuesta,
                ReservaTotal,
                ReservaSIC,
                ReservaAdicional,
                ReservaAdiCNBV,
                ResevaAdiTotal,
                ResevaAdiCtaOrden,
                EstimaPrevenMesAnt

            FROM TMPREGR04C0452 Tem
            WHERE Tem.NumTransaccion = Aud_NumTransaccion;

    ELSE
        IF(Par_NumReporte = Rep_Csv) THEN

            SELECT  IFNULL(CONCAT(
            For_0452,';',
            IdenCreditoCNBV, ';',
            NumeroDispo, ';',
            ClasifConta,';',
            date_format(FechaCorte,'%Y%m%d'), ';',
            SalInsolutoInicial,';',
            MontoDispuesto, ';',
            SalIntOrdin, ';',
            SalIntMora, ';',
            MontoComision, ';',
            SaldoIVA, ';',
            SalCapitalExigible,';',
            SalIntExigible, ';',
            MontoComisionExigible, ';',
            CapitalPagado, ';',
            IntOrdiPagado, ';',
            IntMoraPagado, ';',
            MtoComisiPagado, ';',
            OtrAccesoriosPagado, ';',
            TasaAnual, ';',
            TasaMora, ';',
            SaldoInsoluto, ';',
            date_format(FechaUltDispo,'%Y%m%d'), ';',
            PlazoVencimiento, ';',
            SaldoPrincipalFP, ';',
            MontoDispuestoFP, ';',
            CredDisponibleFP, ';',
            TasaAnualFP, ';',
            TasaMoraFP, ';',
            SalIntOrdinFP, ';',
            SalIntMoraFP, ';',
            IntereRefinanFP, ';',
            IntereReversoFP, ';',
            SaldoPromedioFP, ';',
            NumDiasIntFP, ';',
            MontoComisionFP, ';',
            MontoCondonaFP, ';',
            MontoQuitasFP, ';',
            MontoBonificaFP, ';',
            MontoDescuentoFP, ';',
            MtoAumenDecrePrincFP, ';',
            CapitalPagadoFP, ';',
            IntOrdiPagadoFP,';',
            IntMoraPagadoFP, ';',
            MtoComisiPagadoFP, ';',
            OtrAccesoriosPagadoFP,';',
            MontoPagadoEfecFP, ';',
            SalCapitalFP , ';',
            SaldoInsolutoFP, ';',
            SituacContable,';',
            TipoRecuperacion, ';',
            NumDiasAtraso, ';',
            CASE WHEN FecUltPagoCapFP = Fecha_Vacia THEN DATE_FORMAT(Par_Fecha, '%Y%m%d')
                ELSE DATE_FORMAT(FecUltPagoCapFP, '%Y%m%d')
            END, ';',
            ifnull(MontoUltiPagoFP,0), ';',

            CASE WHEN FecPrimAorNoCubFP = Fecha_Vacia THEN Clave_FechaVacia
                ELSE DATE_FORMAT(FecPrimAorNoCubFP, '%Y%m%d')
            END, ';',

            TipoGarantia, ';',
            NumGarantias, ';',
            ProgramaCred, ';',
            MontoTotGarantias,';',
            PorcentajeGarantia,';',
            GradoPrelacionGar, ';',
            CASE WHEN FechaValuacionGar = Fecha_Vacia THEN Clave_FechaVacia
                     ELSE DATE_FORMAT(FechaValuacionGar, '%Y%m%d')
                END, ';',
            NumeroAvales, ';',
            PorcentajeAvales,';',
            NombreGarante, ';',
            RFCGarante, ';',
            TipoCartera, ';',
            CalifCubierta, ';',
            CalifExpuesta, ';',
            ZonaMarginada, ';',
            ClaveSIC, ';',
            TipoRecursos, ';',
            PorcentajeCubierto,';',
            MontoCubierto, ';',
            ReservaCubierta, ';',
            PorcentajeExpuesto,';',
            MontoExpuesto, ';',
            ReservaExpuesta,';',
            ReservaTotal, ';',
            ReservaSIC, ';',
            ReservaAdicional, ';',
            ReservaAdiCNBV,';',
            ResevaAdiTotal,';',
            ResevaAdiCtaOrden,';',
            EstimaPrevenMesAnt
                    ),Cadena_Vacia) AS Valor

                FROM TMPREGR04C0452 Tem
                WHERE Tem.NumTransaccion = Aud_NumTransaccion;
        END IF;
    END IF;

    DELETE FROM TMPREGR04C0452
        WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$