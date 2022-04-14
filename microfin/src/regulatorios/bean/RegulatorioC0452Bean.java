package regulatorios.bean;

import general.bean.BaseBean;

public class RegulatorioC0452Bean extends BaseBean {
	
	private String periodo	;
	private String claveEntidad	;
	private String reporte	;
	private String idencreditoCNBV	;
	private String numeroDisposicion	;
	private String clasificacionConta	;
	private String fechaCorte	;
	private String saldoInsolutoInicialFC	;
	private String montoDispuestoFC	;	
	private String interesOrdinarioFC;
	private String interesMoratorioFC;
	private String comisionGeneFC	;
	private String montoIVAFC	;	
	private String pagoCapitalExFC	;
	private String pagoInteresExFC	;
	private String pagoComisionExFC	;
	private String capitalPagEfecFC	;
	private String pagoInteresOrdinarioFC	;
	private String pagoInteresMoratoriFC;
	private String pagoComisionGeneFC	;
	private String pagoAccesoriosFC	;
	private String tasaAnualFC	;
	private String tasaMoratoriaFC	;
	private String saldoInsolutoFinalFC	;
	
	
	private String fechaUltimaDispoCP	;
	private String plazoVencimienLineaCP	;
	private String saldoPrincipalInicialCP	;	
	private String montoDispuestoCP	;	
	private String credDisponibleLineaCP	;	
	private String tasaInteresOrdinariaCP	;
	private String tasaInteresMoratoriaCP	;
	private String interesOrdinarioCP;
	private String interesMoratorioCP;
	private String interesRefinanciadoCP;
	private String interesReversoCobroCP;
	private String saldoBaseCobroCP;
	private String numeroDiasCalculoCP	;
	private String comisionGeneCP	;
	private String montoCondonacionCP	;
	private String montoQuitasCP	;
	private String montoBonificacionCP	;
	private String montoDescuentosCP	;	
	private String montoAumentosDecreCP	;
	private String capitalPagEfecCP	;
	private String pagoIntOrdinarioCP	;
	private String pagoIntMoratorioCP	;
	private String pagoComisionesCP	;
	private String pagoAccesoriosCP	;
	private String pagoTotalCP	;
	private String saldoPrincipalFinalCP	;
	private String saldoInsolutoCP	;
	private String situacionCreditoCP	;	
	private String tipoRecuperacionCP	;
	private String numeroDiasMoraCP	;
	private String fechaUltPagoCompleto	;
	private String montoUltPagocompleto	;
	private String fechaPrimAmortizacionNC	;
	
	
	private String tipoGarantia	;
	private String numeroGarantias	;
	private String progCredGobierno	;
	private String montoGarantia	;
	private String porcentajeGarSaldo	;
	private String gradoPrelacionGar	;	
	private String fechaValuacion	;
	private String numeroAvales	;
	private String porcentajeGarAvales	;
	private String nombreGarante	;
	private String rfcGarante	;
	
	
	private String tipoCartera	;
	private String calParteCubierta	;
	private String calParteExpuesta	;
	private String zonaMarginada	;
	private String clavePrevencion	;	
	private String fuenteFondeo	;
	private String porcentajeCubierto	;
	private String montoCubierto	;
	private String montoEPRCCubierto	;
	private String porcentajeExpuesto	;
	private String montoExpuesto	;
	private String montoEPRCExpuesto	;
	private String montoEPRCTotales	;
	private String montoEPRCAdiRiesgoOpe	;
	private String montoEPRCAdiIntDevNC	;
	private String montoEPRCAdiCNBV	;
	private String montoEPRCAdiTotales;
	private String montoEPRCAdiCtaOrden	;
	private String montoEPRCMesAnterior	;
	
	private String valor;
	private String anio;
	private String mes;
	
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	public String getClaveEntidad() {
		return claveEntidad;
	}
	public void setClaveEntidad(String claveEntidad) {
		this.claveEntidad = claveEntidad;
	}
	public String getReporte() {
		return reporte;
	}
	public void setReporte(String reporte) {
		this.reporte = reporte;
	}
	public String getIdencreditoCNBV() {
		return idencreditoCNBV;
	}
	public void setIdencreditoCNBV(String idencreditoCNBV) {
		this.idencreditoCNBV = idencreditoCNBV;
	}
	public String getNumeroDisposicion() {
		return numeroDisposicion;
	}
	public void setNumeroDisposicion(String numeroDisposicion) {
		this.numeroDisposicion = numeroDisposicion;
	}
	public String getClasificacionConta() {
		return clasificacionConta;
	}
	public void setClasificacionConta(String clasificacionConta) {
		this.clasificacionConta = clasificacionConta;
	}
	public String getFechaCorte() {
		return fechaCorte;
	}
	public void setFechaCorte(String fechaCorte) {
		this.fechaCorte = fechaCorte;
	}
	public String getSaldoInsolutoInicialFC() {
		return saldoInsolutoInicialFC;
	}
	public void setSaldoInsolutoInicialFC(String saldoInsolutoInicialFC) {
		this.saldoInsolutoInicialFC = saldoInsolutoInicialFC;
	}
	public String getMontoDispuestoFC() {
		return montoDispuestoFC;
	}
	public void setMontoDispuestoFC(String montoDispuestoFC) {
		this.montoDispuestoFC = montoDispuestoFC;
	}
	public String getInteresOrdinarioFC() {
		return interesOrdinarioFC;
	}
	public void setInteresOrdinarioFC(String interesOrdinarioFC) {
		this.interesOrdinarioFC = interesOrdinarioFC;
	}
	public String getInteresMoratorioFC() {
		return interesMoratorioFC;
	}
	public void setInteresMoratorioFC(String interesMoratorioFC) {
		this.interesMoratorioFC = interesMoratorioFC;
	}
	public String getComisionGeneFC() {
		return comisionGeneFC;
	}
	public void setComisionGeneFC(String comisionGeneFC) {
		this.comisionGeneFC = comisionGeneFC;
	}
	public String getMontoIVAFC() {
		return montoIVAFC;
	}
	public void setMontoIVAFC(String montoIVAFC) {
		this.montoIVAFC = montoIVAFC;
	}
	public String getPagoCapitalExFC() {
		return pagoCapitalExFC;
	}
	public void setPagoCapitalExFC(String pagoCapitalExFC) {
		this.pagoCapitalExFC = pagoCapitalExFC;
	}
	public String getPagoInteresExFC() {
		return pagoInteresExFC;
	}
	public void setPagoInteresExFC(String pagoInteresExFC) {
		this.pagoInteresExFC = pagoInteresExFC;
	}
	public String getPagoComisionExFC() {
		return pagoComisionExFC;
	}
	public void setPagoComisionExFC(String pagoComisionExFC) {
		this.pagoComisionExFC = pagoComisionExFC;
	}
	public String getCapitalPagEfecFC() {
		return capitalPagEfecFC;
	}
	public void setCapitalPagEfecFC(String capitalPagEfecFC) {
		this.capitalPagEfecFC = capitalPagEfecFC;
	}
	public String getPagoInteresOrdinarioFC() {
		return pagoInteresOrdinarioFC;
	}
	public void setPagoInteresOrdinarioFC(String pagoInteresOrdinarioFC) {
		this.pagoInteresOrdinarioFC = pagoInteresOrdinarioFC;
	}
	public String getPagoInteresMoratoriFC() {
		return pagoInteresMoratoriFC;
	}
	public void setPagoInteresMoratoriFC(String pagoInteresMoratoriFC) {
		this.pagoInteresMoratoriFC = pagoInteresMoratoriFC;
	}
	public String getPagoComisionGeneFC() {
		return pagoComisionGeneFC;
	}
	public void setPagoComisionGeneFC(String pagoComisionGeneFC) {
		this.pagoComisionGeneFC = pagoComisionGeneFC;
	}
	public String getPagoAccesoriosFC() {
		return pagoAccesoriosFC;
	}
	public void setPagoAccesoriosFC(String pagoAccesoriosFC) {
		this.pagoAccesoriosFC = pagoAccesoriosFC;
	}
	public String getTasaAnualFC() {
		return tasaAnualFC;
	}
	public void setTasaAnualFC(String tasaAnualFC) {
		this.tasaAnualFC = tasaAnualFC;
	}
	public String getTasaMoratoriaFC() {
		return tasaMoratoriaFC;
	}
	public void setTasaMoratoriaFC(String tasaMoratoriaFC) {
		this.tasaMoratoriaFC = tasaMoratoriaFC;
	}
	public String getSaldoInsolutoFinalFC() {
		return saldoInsolutoFinalFC;
	}
	public void setSaldoInsolutoFinalFC(String saldoInsolutoFinalFC) {
		this.saldoInsolutoFinalFC = saldoInsolutoFinalFC;
	}
	public String getFechaUltimaDispoCP() {
		return fechaUltimaDispoCP;
	}
	public void setFechaUltimaDispoCP(String fechaUltimaDispoCP) {
		this.fechaUltimaDispoCP = fechaUltimaDispoCP;
	}
	public String getPlazoVencimienLineaCP() {
		return plazoVencimienLineaCP;
	}
	public void setPlazoVencimienLineaCP(String plazoVencimienLineaCP) {
		this.plazoVencimienLineaCP = plazoVencimienLineaCP;
	}
	public String getSaldoPrincipalInicialCP() {
		return saldoPrincipalInicialCP;
	}
	public void setSaldoPrincipalInicialCP(String saldoPrincipalInicialCP) {
		this.saldoPrincipalInicialCP = saldoPrincipalInicialCP;
	}
	public String getMontoDispuestoCP() {
		return montoDispuestoCP;
	}
	public void setMontoDispuestoCP(String montoDispuestoCP) {
		this.montoDispuestoCP = montoDispuestoCP;
	}
	public String getCredDisponibleLineaCP() {
		return credDisponibleLineaCP;
	}
	public void setCredDisponibleLineaCP(String credDisponibleLineaCP) {
		this.credDisponibleLineaCP = credDisponibleLineaCP;
	}
	public String getTasaInteresOrdinariaCP() {
		return tasaInteresOrdinariaCP;
	}
	public void setTasaInteresOrdinariaCP(String tasaInteresOrdinariaCP) {
		this.tasaInteresOrdinariaCP = tasaInteresOrdinariaCP;
	}
	public String getTasaInteresMoratoriaCP() {
		return tasaInteresMoratoriaCP;
	}
	public void setTasaInteresMoratoriaCP(String tasaInteresMoratoriaCP) {
		this.tasaInteresMoratoriaCP = tasaInteresMoratoriaCP;
	}
	public String getInteresOrdinarioCP() {
		return interesOrdinarioCP;
	}
	public void setInteresOrdinarioCP(String interesOrdinarioCP) {
		this.interesOrdinarioCP = interesOrdinarioCP;
	}
	public String getInteresMoratorioCP() {
		return interesMoratorioCP;
	}
	public void setInteresMoratorioCP(String interesMoratorioCP) {
		this.interesMoratorioCP = interesMoratorioCP;
	}
	public String getInteresRefinanciadoCP() {
		return interesRefinanciadoCP;
	}
	public void setInteresRefinanciadoCP(String interesRefinanciadoCP) {
		this.interesRefinanciadoCP = interesRefinanciadoCP;
	}
	public String getInteresReversoCobroCP() {
		return interesReversoCobroCP;
	}
	public void setInteresReversoCobroCP(String interesReversoCobroCP) {
		this.interesReversoCobroCP = interesReversoCobroCP;
	}
	public String getSaldoBaseCobroCP() {
		return saldoBaseCobroCP;
	}
	public void setSaldoBaseCobroCP(String saldoBaseCobroCP) {
		this.saldoBaseCobroCP = saldoBaseCobroCP;
	}
	public String getNumeroDiasCalculoCP() {
		return numeroDiasCalculoCP;
	}
	public void setNumeroDiasCalculoCP(String numeroDiasCalculoCP) {
		this.numeroDiasCalculoCP = numeroDiasCalculoCP;
	}
	public String getComisionGeneCP() {
		return comisionGeneCP;
	}
	public void setComisionGeneCP(String comisionGeneCP) {
		this.comisionGeneCP = comisionGeneCP;
	}
	public String getMontoCondonacionCP() {
		return montoCondonacionCP;
	}
	public void setMontoCondonacionCP(String montoCondonacionCP) {
		this.montoCondonacionCP = montoCondonacionCP;
	}
	public String getMontoQuitasCP() {
		return montoQuitasCP;
	}
	public void setMontoQuitasCP(String montoQuitasCP) {
		this.montoQuitasCP = montoQuitasCP;
	}
	public String getMontoBonificacionCP() {
		return montoBonificacionCP;
	}
	public void setMontoBonificacionCP(String montoBonificacionCP) {
		this.montoBonificacionCP = montoBonificacionCP;
	}
	public String getMontoDescuentosCP() {
		return montoDescuentosCP;
	}
	public void setMontoDescuentosCP(String montoDescuentosCP) {
		this.montoDescuentosCP = montoDescuentosCP;
	}
	public String getMontoAumentosDecreCP() {
		return montoAumentosDecreCP;
	}
	public void setMontoAumentosDecreCP(String montoAumentosDecreCP) {
		this.montoAumentosDecreCP = montoAumentosDecreCP;
	}
	public String getCapitalPagEfecCP() {
		return capitalPagEfecCP;
	}
	public void setCapitalPagEfecCP(String capitalPagEfecCP) {
		this.capitalPagEfecCP = capitalPagEfecCP;
	}
	public String getPagoIntOrdinarioCP() {
		return pagoIntOrdinarioCP;
	}
	public void setPagoIntOrdinarioCP(String pagoIntOrdinarioCP) {
		this.pagoIntOrdinarioCP = pagoIntOrdinarioCP;
	}
	public String getPagoIntMoratorioCP() {
		return pagoIntMoratorioCP;
	}
	public void setPagoIntMoratorioCP(String pagoIntMoratorioCP) {
		this.pagoIntMoratorioCP = pagoIntMoratorioCP;
	}
	public String getPagoComisionesCP() {
		return pagoComisionesCP;
	}
	public void setPagoComisionesCP(String pagoComisionesCP) {
		this.pagoComisionesCP = pagoComisionesCP;
	}
	public String getPagoAccesoriosCP() {
		return pagoAccesoriosCP;
	}
	public void setPagoAccesoriosCP(String pagoAccesoriosCP) {
		this.pagoAccesoriosCP = pagoAccesoriosCP;
	}
	public String getPagoTotalCP() {
		return pagoTotalCP;
	}
	public void setPagoTotalCP(String pagoTotalCP) {
		this.pagoTotalCP = pagoTotalCP;
	}
	public String getSaldoPrincipalFinalCP() {
		return saldoPrincipalFinalCP;
	}
	public void setSaldoPrincipalFinalCP(String saldoPrincipalFinalCP) {
		this.saldoPrincipalFinalCP = saldoPrincipalFinalCP;
	}
	public String getSaldoInsolutoCP() {
		return saldoInsolutoCP;
	}
	public void setSaldoInsolutoCP(String saldoInsolutoCP) {
		this.saldoInsolutoCP = saldoInsolutoCP;
	}
	
	public String getSituacionCreditoCP() {
		return situacionCreditoCP;
	}
	public void setSituacionCreditoCP(String situacionCreditoCP) {
		this.situacionCreditoCP = situacionCreditoCP;
	}
	public String getTipoRecuperacionCP() {
		return tipoRecuperacionCP;
	}
	public void setTipoRecuperacionCP(String tipoRecuperacionCP) {
		this.tipoRecuperacionCP = tipoRecuperacionCP;
	}
	public String getNumeroDiasMoraCP() {
		return numeroDiasMoraCP;
	}
	public void setNumeroDiasMoraCP(String numeroDiasMoraCP) {
		this.numeroDiasMoraCP = numeroDiasMoraCP;
	}
	public String getFechaUltPagoCompleto() {
		return fechaUltPagoCompleto;
	}
	public void setFechaUltPagoCompleto(String fechaUltPagoCompleto) {
		this.fechaUltPagoCompleto = fechaUltPagoCompleto;
	}
	public String getMontoUltPagocompleto() {
		return montoUltPagocompleto;
	}
	public void setMontoUltPagocompleto(String montoUltPagocompleto) {
		this.montoUltPagocompleto = montoUltPagocompleto;
	}
	public String getFechaPrimAmortizacionNC() {
		return fechaPrimAmortizacionNC;
	}
	public void setFechaPrimAmortizacionNC(String fechaPrimAmortizacionNC) {
		this.fechaPrimAmortizacionNC = fechaPrimAmortizacionNC;
	}
	public String getTipoGarantia() {
		return tipoGarantia;
	}
	public void setTipoGarantia(String tipoGarantia) {
		this.tipoGarantia = tipoGarantia;
	}
	public String getNumeroGarantias() {
		return numeroGarantias;
	}
	public void setNumeroGarantias(String numeroGarantias) {
		this.numeroGarantias = numeroGarantias;
	}
	public String getProgCredGobierno() {
		return progCredGobierno;
	}
	public void setProgCredGobierno(String progCredGobierno) {
		this.progCredGobierno = progCredGobierno;
	}
	public String getMontoGarantia() {
		return montoGarantia;
	}
	public void setMontoGarantia(String montoGarantia) {
		this.montoGarantia = montoGarantia;
	}
	public String getPorcentajeGarSaldo() {
		return porcentajeGarSaldo;
	}
	public void setPorcentajeGarSaldo(String porcentajeGarSaldo) {
		this.porcentajeGarSaldo = porcentajeGarSaldo;
	}
	public String getGradoPrelacionGar() {
		return gradoPrelacionGar;
	}
	public void setGradoPrelacionGar(String gradoPrelacionGar) {
		this.gradoPrelacionGar = gradoPrelacionGar;
	}
	public String getFechaValuacion() {
		return fechaValuacion;
	}
	public void setFechaValuacion(String fechaValuacion) {
		this.fechaValuacion = fechaValuacion;
	}
	public String getNumeroAvales() {
		return numeroAvales;
	}
	public void setNumeroAvales(String numeroAvales) {
		this.numeroAvales = numeroAvales;
	}
	public String getPorcentajeGarAvales() {
		return porcentajeGarAvales;
	}
	public void setPorcentajeGarAvales(String porcentajeGarAvales) {
		this.porcentajeGarAvales = porcentajeGarAvales;
	}
	public String getNombreGarante() {
		return nombreGarante;
	}
	public void setNombreGarante(String nombreGarante) {
		this.nombreGarante = nombreGarante;
	}
	public String getRfcGarante() {
		return rfcGarante;
	}
	public void setRfcGarante(String rfcGarante) {
		this.rfcGarante = rfcGarante;
	}
	public String getTipoCartera() {
		return tipoCartera;
	}
	public void setTipoCartera(String tipoCartera) {
		this.tipoCartera = tipoCartera;
	}
	public String getCalParteCubierta() {
		return calParteCubierta;
	}
	public void setCalParteCubierta(String calParteCubierta) {
		this.calParteCubierta = calParteCubierta;
	}
	public String getCalParteExpuesta() {
		return calParteExpuesta;
	}
	public void setCalParteExpuesta(String calParteExpuesta) {
		this.calParteExpuesta = calParteExpuesta;
	}
	public String getZonaMarginada() {
		return zonaMarginada;
	}
	public void setZonaMarginada(String zonaMarginada) {
		this.zonaMarginada = zonaMarginada;
	}
	public String getClavePrevencion() {
		return clavePrevencion;
	}
	public void setClavePrevencion(String clavePrevencion) {
		this.clavePrevencion = clavePrevencion;
	}
	public String getFuenteFondeo() {
		return fuenteFondeo;
	}
	public void setFuenteFondeo(String fuenteFondeo) {
		this.fuenteFondeo = fuenteFondeo;
	}
	public String getPorcentajeCubierto() {
		return porcentajeCubierto;
	}
	public void setPorcentajeCubierto(String porcentajeCubierto) {
		this.porcentajeCubierto = porcentajeCubierto;
	}
	public String getMontoCubierto() {
		return montoCubierto;
	}
	public void setMontoCubierto(String montoCubierto) {
		this.montoCubierto = montoCubierto;
	}
	public String getMontoEPRCCubierto() {
		return montoEPRCCubierto;
	}
	public void setMontoEPRCCubierto(String montoEPRCCubierto) {
		this.montoEPRCCubierto = montoEPRCCubierto;
	}
	public String getPorcentajeExpuesto() {
		return porcentajeExpuesto;
	}
	public void setPorcentajeExpuesto(String porcentajeExpuesto) {
		this.porcentajeExpuesto = porcentajeExpuesto;
	}
	public String getMontoExpuesto() {
		return montoExpuesto;
	}
	public void setMontoExpuesto(String montoExpuesto) {
		this.montoExpuesto = montoExpuesto;
	}
	public String getMontoEPRCExpuesto() {
		return montoEPRCExpuesto;
	}
	public void setMontoEPRCExpuesto(String montoEPRCExpuesto) {
		this.montoEPRCExpuesto = montoEPRCExpuesto;
	}
	public String getMontoEPRCTotales() {
		return montoEPRCTotales;
	}
	public void setMontoEPRCTotales(String montoEPRCTotales) {
		this.montoEPRCTotales = montoEPRCTotales;
	}
	public String getMontoEPRCAdiRiesgoOpe() {
		return montoEPRCAdiRiesgoOpe;
	}
	public void setMontoEPRCAdiRiesgoOpe(String montoEPRCAdiRiesgoOpe) {
		this.montoEPRCAdiRiesgoOpe = montoEPRCAdiRiesgoOpe;
	}
	public String getMontoEPRCAdiIntDevNC() {
		return montoEPRCAdiIntDevNC;
	}
	public void setMontoEPRCAdiIntDevNC(String montoEPRCAdiIntDevNC) {
		this.montoEPRCAdiIntDevNC = montoEPRCAdiIntDevNC;
	}
	public String getMontoEPRCAdiCNBV() {
		return montoEPRCAdiCNBV;
	}
	public void setMontoEPRCAdiCNBV(String montoEPRCAdiCNBV) {
		this.montoEPRCAdiCNBV = montoEPRCAdiCNBV;
	}
	public String getMontoEPRCAdiTotales() {
		return montoEPRCAdiTotales;
	}
	public void setMontoEPRCAdiTotales(String montoEPRCAdiTotales) {
		this.montoEPRCAdiTotales = montoEPRCAdiTotales;
	}
	public String getMontoEPRCAdiCtaOrden() {
		return montoEPRCAdiCtaOrden;
	}
	public void setMontoEPRCAdiCtaOrden(String montoEPRCAdiCtaOrden) {
		this.montoEPRCAdiCtaOrden = montoEPRCAdiCtaOrden;
	}
	public String getMontoEPRCMesAnterior() {
		return montoEPRCMesAnterior;
	}
	public void setMontoEPRCMesAnterior(String montoEPRCMesAnterior) {
		this.montoEPRCMesAnterior = montoEPRCMesAnterior;
	}	
	
	
	
	
	
}
