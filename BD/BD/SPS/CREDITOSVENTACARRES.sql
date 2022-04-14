-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOARCHIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS CREDITOSVENTACARRES;
DELIMITER $$

CREATE PROCEDURE CREDITOSVENTACARRES(
    Par_CreditoID           BIGINT(12),
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
            )
TerminaStore: BEGIN

-- SE RESPALDA CREDITOS
INSERT INTO CREDITOSVTA (
            CreditoID,          LineaCreditoID,             ClienteID,              CuentaID,               Clabe,
            MonedaID,           ProductoCreditoID,          DestinoCreID,           MontoCredito,           TipoCredito,
            Relacionado,        SolicitudCreditoID,         TipoFondeo,             InstitFondeoID,         LineaFondeo,
            FechaInicio,        FechaInicioAmor,            FechaVencimien,         CalcInteresID,          TasaBase,
            TasaFija,           SobreTasa,                  PisoTasa,               TechoTasa,              TipCobComMorato,
            FactorMora,         FrecuenciaCap,              PeriodicidadCap,        FrecuenciaInt,          PeriodicidadInt,
            TipoPagoCapital,    NumAmortizacion,            MontoCuota,             FechTraspasVenc,        FechTerminacion,
            IVAInteres,         IVAComisiones,              Estatus,                FechaAutoriza,          UsuarioAutoriza,
            SaldoCapVigent,     SaldoCapAtrasad,            SaldoCapVencido,        SaldCapVenNoExi,        SaldoInterOrdin,
            SaldoInterAtras,    SaldoInterVenc,             SaldoInterProvi,        SaldoIntNoConta,        SaldoIVAInteres,
            SaldoMoratorios,    SaldoIVAMorator,            SaldComFaltPago,        SalIVAComFalPag,        SaldoComServGar,
            SaldoIVAComSerGar,  SaldoOtrasComis,            SaldoIVAComisi,         ProvisionAcum,          PagareImpreso,
            FechaInhabil,       CalendIrregular,            DiaPagoInteres,         DiaPagoCapital,         DiaPagoProd,
            DiaMesInteres,      DiaMesCapital,              AjusFecUlVenAmo,        AjusFecExiVen,          NumTransacSim,
            FechaMinistrado,    FolioDispersion,            SucursalID,             ValorCAT,               ClasifRegID,
            MontoComApert,      IVAComApertura,             PlazoID,                TipoDispersion,         CuentaCLABE,
            TipoCalInteres,     TipoGeneraInteres,          MontoDesemb,            MontoPorDesemb,         NumAmortInteres,
            AporteCliente,      PorcGarLiq,                 MontoSeguroVida,        SeguroVidaPagado,       ForCobroSegVida,
            ComAperPagado,      ForCobroComAper,            ClasiDestinCred,        CicloGrupo,             GrupoID,
            TipoPrepago,        SaldoMoraVencido,           SaldoMoraCarVen,        DescuentoSeguro,        MontoSegOriginal,
            IdenCreditoCNBV,    CobraSeguroCuota,           CobraIVASeguroCuota,    MontoSeguroCuota,       IVASeguroCuota,
            CobraComAnual,      TipoComAnual,               BaseCalculoComAnual,    MontoComAnual,          PorcentajeComAnual,
            DiasGraciaComAnual, SaldoComAnual,              TipoLiquidacion,        CantidadPagar,          ComAperCont,
            IVAComAperCont,     ComAperReest,               IVAComAperReest,        FechaAtrasoCapital,     FechaAtrasoInteres,
            TipoConsultaSIC,    FolioConsultaBC,            FolioConsultaCC,        EsAgropecuario,         TipoCancelacion,
            Refinancia,         CadenaProductivaID,         RamaFIRAID,             SubramaFIRAID,          ActividadFIRAID,
            TipoGarantiaFIRAID, EstatusGarantiaFIRA,        ProgEspecialFIRAID,     FechaCobroComision,     EsAutomatico,
            TipoAutomatico,     InvCredAut,                 CtaCredAut,             AcreditadoIDFIRA,       CreditoIDFIRA,
            InteresAcumulado,   InteresRefinanciar,         Reacreditado,           TipoComXApertura,       MontoComXApertura,
            DiasAtrasoMin,      ReferenciaPago,             NivelID,                CobraAccesorios,        EstatusInstalacion,
            FolioInstalacion,   AprobadoInfoComercial,      ClabeCtaDomici,         MontoClienteCartas,     AplicaDescServicio,
            EsConsolidado,      FlujoOrigen,                ConvenioNominaID,       EmpresaID,              InstitNominaID,
            EtiquetaFondeo,     FechaEtiqueta,              EtiquetaAFM,            FecEtiquetaAFM,         Usuario,
            FechaActual,        DireccionIP,                ProgramaID,             Sucursal,               NumTransaccion

)
    SELECT  C.CreditoID,          C.LineaCreditoID,             C.ClienteID,              C.CuentaID,               C.Clabe,
            C.MonedaID,           C.ProductoCreditoID,          C.DestinoCreID,           C.MontoCredito,           C.TipoCredito,
            C.Relacionado,        C.SolicitudCreditoID,         C.TipoFondeo,             C.InstitFondeoID,         C.LineaFondeo,
            C.FechaInicio,        C.FechaInicioAmor,            C.FechaVencimien,         C.CalcInteresID,          C.TasaBase,
            C.TasaFija,           C.SobreTasa,                  C.PisoTasa,               C.TechoTasa,              C.TipCobComMorato,
            C.FactorMora,         C.FrecuenciaCap,              C.PeriodicidadCap,        C.FrecuenciaInt,          C.PeriodicidadInt,
            C.TipoPagoCapital,    C.NumAmortizacion,            C.MontoCuota,             C.FechTraspasVenc,        C.FechTerminacion,
            C.IVAInteres,         C.IVAComisiones,              C.Estatus,                C.FechaAutoriza,          C.UsuarioAutoriza,
            C.SaldoCapVigent,     C.SaldoCapAtrasad,            C.SaldoCapVencido,        C.SaldCapVenNoExi,        C.SaldoInterOrdin,
            C.SaldoInterAtras,    C.SaldoInterVenc,             C.SaldoInterProvi,        C.SaldoIntNoConta,        C.SaldoIVAInteres,
            C.SaldoMoratorios,    C.SaldoIVAMorator,            C.SaldComFaltPago,        C.SalIVAComFalPag,        C.SaldoComServGar,
            C.SaldoIVAComSerGar,  C.SaldoOtrasComis,            C.SaldoIVAComisi,         C.ProvisionAcum,          C.PagareImpreso,
            C.FechaInhabil,       C.CalendIrregular,            C.DiaPagoInteres,         C.DiaPagoCapital,         C.DiaPagoProd,
            C.DiaMesInteres,      C.DiaMesCapital,              C.AjusFecUlVenAmo,        C.AjusFecExiVen,          C.NumTransacSim,
            C.FechaMinistrado,    C.FolioDispersion,            C.SucursalID,             C.ValorCAT,               C.ClasifRegID,
            C.MontoComApert,      C.IVAComApertura,             C.PlazoID,                C.TipoDispersion,         C.CuentaCLABE,
            C.TipoCalInteres,     C.TipoGeneraInteres,          C.MontoDesemb,            C.MontoPorDesemb,         C.NumAmortInteres,
            C.AporteCliente,      C.PorcGarLiq,                 C.MontoSeguroVida,        C.SeguroVidaPagado,       C.ForCobroSegVida,
            C.ComAperPagado,      C.ForCobroComAper,            C.ClasiDestinCred,        C.CicloGrupo,             C.GrupoID,
            C.TipoPrepago,        C.SaldoMoraVencido,           C.SaldoMoraCarVen,        C.DescuentoSeguro,        C.MontoSegOriginal,
            C.IdenCreditoCNBV,    C.CobraSeguroCuota,           C.CobraIVASeguroCuota,    C.MontoSeguroCuota,       C.IVASeguroCuota,
            C.CobraComAnual,      C.TipoComAnual,               C.BaseCalculoComAnual,    C.MontoComAnual,          C.PorcentajeComAnual,
            C.DiasGraciaComAnual, C.SaldoComAnual,              C.TipoLiquidacion,        C.CantidadPagar,          C.ComAperCont,
            C.IVAComAperCont,     C.ComAperReest,               C.IVAComAperReest,        C.FechaAtrasoCapital,     C.FechaAtrasoInteres,
            C.TipoConsultaSIC,    C.FolioConsultaBC,            C.FolioConsultaCC,        C.EsAgropecuario,         C.TipoCancelacion,
            C.Refinancia,         C.CadenaProductivaID,         C.RamaFIRAID,             C.SubramaFIRAID,          C.ActividadFIRAID,
            C.TipoGarantiaFIRAID, C.EstatusGarantiaFIRA,        C.ProgEspecialFIRAID,     C.FechaCobroComision,     C.EsAutomatico,
            C.TipoAutomatico,     C.InvCredAut,                 C.CtaCredAut,             C.AcreditadoIDFIRA,       C.CreditoIDFIRA,
            C.InteresAcumulado,   C.InteresRefinanciar,         C.Reacreditado,           C.TipoComXApertura,       C.MontoComXApertura,
            C.DiasAtrasoMin,      C.ReferenciaPago,             C.NivelID,                C.CobraAccesorios,        C.EstatusInstalacion,
            C.FolioInstalacion,   C.AprobadoInfoComercial,      C.ClabeCtaDomici,         C.MontoClienteCartas,     C.AplicaDescServicio,
            C.EsConsolidado,      C.FlujoOrigen,                C.ConvenioNominaID,       C.EmpresaID,              C.InstitNominaID,
            C.EtiquetaFondeo,     C.FechaEtiqueta,              C.EtiquetaAFM,            C.FecEtiquetaAFM,         C.Usuario,
            C.FechaActual,        C.DireccionIP,                C.ProgramaID,             C.Sucursal,               C.NumTransaccion
    FROM CREDITOS C
        INNER JOIN CREDITOSVENTACAR V ON C.CreditoID = V.CreditoID
    WHERE C.CreditoID = Par_CreditoID;


-- SE RESPALDA AMORTICREDITO
INSERT INTO AMORTICREDITOVTA (
            AmortizacionID,         CreditoID,              ClienteID,              CuentaID,               FechaInicio,
            FechaVencim,            FechaExigible,          Estatus,                FechaLiquida,           Capital,
            Interes,                IVAInteres,             SaldoCapVigente,        SaldoCapAtrasa,         SaldoCapVencido,
            SaldoCapVenNExi,        SaldoInteresOrd,        SaldoInteresAtr,        SaldoInteresVen,        SaldoInteresPro,
            SaldoIntNoConta,        SaldoIVAInteres,        SaldoMoratorios,        SaldoIVAMorato,         SaldoComFaltaPa,
            SaldoIVAComFalP,        SaldoComServGar,        SaldoIVAComSerGar,      MontoOtrasComisiones,   MontoIVAOtrasComisiones,
            SaldoOtrasComis,        SaldoIVAComisi,         ProvisionAcum,          SaldoCapital,           NumProyInteres,
            SaldoMoraVencido,       SaldoMoraCarVen,        MontoSeguroCuota,       IVASeguroCuota,         SaldoSeguroCuota,
            SaldoIVASeguroCuota,    SaldoComisionAnual,     SaldoComisionAnualIVA,  EmpresaID,              Usuario,
            FechaActual,            DireccionIP,            ProgramaID,             Sucursal,               NumTransaccion
)
    SELECT  C.AmortizacionID,         C.CreditoID,              C.ClienteID,              C.CuentaID,               C.FechaInicio,
            C.FechaVencim,            C.FechaExigible,          C.Estatus,                C.FechaLiquida,           C.Capital,
            C.Interes,                C.IVAInteres,             C.SaldoCapVigente,        C.SaldoCapAtrasa,         C.SaldoCapVencido,
            C.SaldoCapVenNExi,        C.SaldoInteresOrd,        C.SaldoInteresAtr,        C.SaldoInteresVen,        C.SaldoInteresPro,
            C.SaldoIntNoConta,        C.SaldoIVAInteres,        C.SaldoMoratorios,        C.SaldoIVAMorato,         C.SaldoComFaltaPa,
            C.SaldoIVAComFalP,        C.SaldoComServGar,        C.SaldoIVAComSerGar,      C.MontoOtrasComisiones,   C.MontoIVAOtrasComisiones,
            C.SaldoOtrasComis,        C.SaldoIVAComisi,         C.ProvisionAcum,          C.SaldoCapital,           C.NumProyInteres,
            C.SaldoMoraVencido,       C.SaldoMoraCarVen,        C.MontoSeguroCuota,       C.IVASeguroCuota,         C.SaldoSeguroCuota,
            C.SaldoIVASeguroCuota,    C.SaldoComisionAnual,     C.SaldoComisionAnualIVA,  C.EmpresaID,              C.Usuario,
            C.FechaActual,            C.DireccionIP,            C.ProgramaID,             C.Sucursal,               C.NumTransaccion
    FROM AMORTICREDITO C
        INNER JOIN CREDITOSVENTACAR V ON C.CreditoID = V.CreditoID
    WHERE C.CreditoID = Par_CreditoID;


-- SE RESPALDA SALDOS CREDITO
INSERT INTO SALDOSCREDITOSVTA (
            SaldosCreditosID,       CreditoID,              FechaCorte,             SalCapVigente,          SalCapAtrasado,
            SalCapVencido,          SalCapVenNoExi,         SalIntOrdinario,        SalIntAtrasado,         SalIntVencido,
            SalIntProvision,        SalIntNoConta,          SalMoratorios,          SaldoMoraVencido,       SaldoMoraCarVen,
            SalComFaltaPago,        SaldoComServGar,        SalOtrasComisi,         SalIVAInteres,          SalIVAMoratorios,
            SalIVAComFalPago,       SaldoIVAComSerGar,      SalIVAComisi,           PasoCapAtraDia,         PasoCapVenDia,
            PasoCapVNEDia,          PasoIntAtraDia,         PasoIntVenDia,          CapRegularizado,        IntOrdDevengado,
            IntMorDevengado,        ComisiDevengado,        PagoCapVigDia,          PagoCapAtrDia,          PagoCapVenDia,
            PagoCapVenNexDia,       PagoIntOrdDia,          PagoIntVenDia,          PagoIntAtrDia,          PagoIntCalNoCon,
            PagoComisiDia,          PagoMoratorios,         PagoIvaDia,             IntCondonadoDia,        MorCondonadoDia,
            DiasAtraso,             NoCuotasAtraso,         MaximoDiasAtraso,       LineaCreditoID,         ClienteID,
            MonedaID,               FechaInicio,            FechaVencimiento,       FechaExigible,          FechaLiquida,
            ProductoCreditoID,      EstatusCredito,         SaldoPromedio,          MontoCredito,           FrecuenciaCap,
            PeriodicidadCap,        FrecuenciaInt,          PeriodicidadInt,        NumAmortizacion,        FechTraspasVenc,
            FechAutoriza,           ClasifRegID,            DestinoCreID,           Calificacion,           PorcReserva,
            TipoFondeo,             InstitFondeoID,         IntDevCtaOrden,         CapCondonadoDia,        ComAdmonPagDia,
            ComCondonadoDia,        DesembolsosDia,         CapVigenteExi,          MontoTotalExi,          SalMontoAccesorio,
            SalIVAAccesorio,        EmpresaID,              Usuario,                FechaActual,            DireccionIP,
            ProgramaID,             Sucursal,               NumTransaccion
)
    SELECT  C.SaldosCreditosID,       C.CreditoID,             C.FechaCorte,             C.SalCapVigente,          C.SalCapAtrasado,
            C.SalCapVencido,          C.SalCapVenNoExi,        C.SalIntOrdinario,        C.SalIntAtrasado,         C.SalIntVencido,
            C.SalIntProvision,        C.SalIntNoConta,         C.SalMoratorios,          C.SaldoMoraVencido,       C.SaldoMoraCarVen,
            C.SalComFaltaPago,        C.SaldoComServGar,       C.SalOtrasComisi,         C.SalIVAInteres,          C.SalIVAMoratorios,
            C.SalIVAComFalPago,       C.SaldoIVAComSerGar,     C.SalIVAComisi,           C.PasoCapAtraDia,         C.PasoCapVenDia,
            C.PasoCapVNEDia,          C.PasoIntAtraDia,        C.PasoIntVenDia,          C.CapRegularizado,        C.IntOrdDevengado,
            C.IntMorDevengado,        C.ComisiDevengado,       C.PagoCapVigDia,          C.PagoCapAtrDia,          C.PagoCapVenDia,
            C.PagoCapVenNexDia,       C.PagoIntOrdDia,         C.PagoIntVenDia,          C.PagoIntAtrDia,          C.PagoIntCalNoCon,
            C.PagoComisiDia,          C.PagoMoratorios,        C.PagoIvaDia,             C.IntCondonadoDia,        C.MorCondonadoDia,
            C.DiasAtraso,             C.NoCuotasAtraso,        C.MaximoDiasAtraso,       C.LineaCreditoID,         C.ClienteID,
            C.MonedaID,               C.FechaInicio,           C.FechaVencimiento,       C.FechaExigible,          C.FechaLiquida,
            C.ProductoCreditoID,      C.EstatusCredito,        C.SaldoPromedio,          C.MontoCredito,           C.FrecuenciaCap,
            C.PeriodicidadCap,        C.FrecuenciaInt,         C.PeriodicidadInt,        C.NumAmortizacion,        C.FechTraspasVenc,
            C.FechAutoriza,           C.ClasifRegID,           C.DestinoCreID,           C.Calificacion,           C.PorcReserva,
            C.TipoFondeo,             C.InstitFondeoID,        C.IntDevCtaOrden,         C.CapCondonadoDia,        C.ComAdmonPagDia,
            C.ComCondonadoDia,        C.DesembolsosDia,        C.CapVigenteExi,          C.MontoTotalExi,          C.SalMontoAccesorio,
            C.SalIVAAccesorio,        C.EmpresaID,             C.Usuario,                C.FechaActual,            C.DireccionIP,
            C.ProgramaID,             C.Sucursal,              C.NumTransaccion
FROM SALDOSCREDITOS C
    INNER JOIN CREDITOSVENTACAR V ON C.CreditoID = V.CreditoID
    WHERE C.CreditoID = Par_CreditoID;

-- SE RESPALDA RESERVA DE CREDITOS
INSERT INTO CALRESCREDITOSVTA(
            RegistroID,             Fecha,                  CreditoID,              Capital,                Interes,
            IVA,                    Total,                  DiasAtraso,             Calificacion,           PorcReservaExp,
            PorcReservaCub,         Reserva,                TipoCalificacion,       ClienteID,              GarantiaID,
            FechaValuacion,         TipoGarantiaID,         MontoGarantia,          GradoPrelacion,         Metodologia,
            MonedaID,               ProductoCreditoID,      Clasificacion,          AplicaConta,            ReservaInteres,
            ReservaCapital,         SaldoResCapital,        SaldoResInteres,        ReservaTotCubierto,     ReservaTotExpuesto,
            ZonaMarginada,          MontoBaseEstCub,        MontoBaseEstExp,        EmpresaID,              Usuario,
            FechaActual,            DireccionIP,            ProgramaID,             Sucursal,               NumTransaccion
)
    SELECT  C.RegistroID,             C.Fecha,                  C.CreditoID,              C.Capital,               C.Interes,
            C.IVA,                    C.Total,                  C.DiasAtraso,             C.Calificacion,          C.PorcReservaExp,
            C.PorcReservaCub,         C.Reserva,                C.TipoCalificacion,       C.ClienteID,             C.GarantiaID,
            C.FechaValuacion,         C.TipoGarantiaID,         C.MontoGarantia,          C.GradoPrelacion,        C.Metodologia,
            C.MonedaID,               C.ProductoCreditoID,      C.Clasificacion,          C.AplicaConta,           C.ReservaInteres,
            C.ReservaCapital,         C.SaldoResCapital,        C.SaldoResInteres,        C.ReservaTotCubierto,    C.ReservaTotExpuesto,
            C.ZonaMarginada,          C.MontoBaseEstCub,        C.MontoBaseEstExp,        C.EmpresaID,             C.Usuario,
            C.FechaActual,            C.DireccionIP,            C.ProgramaID,             C.Sucursal,              C.NumTransaccion
    FROM CALRESCREDITOS C
        INNER JOIN CREDITOSVENTACAR V ON C.CreditoID = V.CreditoID
    WHERE C.CreditoID = Par_CreditoID;


END TerminaStore$$