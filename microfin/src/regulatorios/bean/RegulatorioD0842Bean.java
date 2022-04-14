package regulatorios.bean;

import java.util.List;

import general.bean.BaseBean;

public class RegulatorioD0842Bean extends BaseBean{
	
	//Bean Para realizar los Bloqueos o Desbloqueos
	 
	private String anio;
	private String mes;
	private String claveEntidad;
	private String formulario;
	private String numeroIden;
	private String tipoPrestamista;
	private String clavePrestamista;
	private String numeroContrato;
	private String numeroCuenta;
	private String fechaContra;	
	private String fechaVencim;
	private String tasaAnual;
	private String plazo;
	private String periodoPago;
	private String montoRecibido;	
	private String tipoCredito;
	private String destino;
	private String tipoGarantia; 
	private String montoGarantia;
	private String fechaPago;
	private String montoPago;
	private String clasificaCortLarg;
	private String salInsoluto;
	private String periodo;
	private String renglon;
	private String descripcion;
	
	private List lnumeroIden;
	private List ltipoPrestamista;
	private List lclavePrestamista;
	private List lnumeroContrato;
	private List lnumeroCuenta;
	private List lfechaContra;	
	private List lfechaVencim;
	private List ltasaAnual;
	private List lplazo;
	private List lperiodoPago;
	private List lmontoRecibido;	
	private List ltipoCredito;
	private List ldestino;
	private List ltipoGarantia; 
	private List lmontoGarantia;
	private List lfechaPago;
	private List lmontoPago;
	private List lclasificaCortLarg;
	private List lsalInsoluto;
	private List lrenglon;
	private List ldescripcion;
	
	private List lAnio;
	private List lMes;
	private List lFormulario;
	private List lPeriodo;
	
	//pantalla para sofipos
	
	private String montoInicialPrestamo;
	private String valTasaOriginal;
	private String valTasaInt;
	private String tasaIntReferencia;
	private String diferenciaTasaRef;
	private String operaDifTasaRefe;
	private String frecRevisionTasa;
	private String tipoMoneda;
	private String porcentajeComision;
	private String importeComision;
	private String periodoPagoComision;
	private String tipoDisposicionCredito;
	private String pagosRealizados;
	private String comisionPagada;
	private String interesesPagados;
	private String interesesDevengados;
	private String saldoCierre;
	private String porcentajeLinRevolvente;
	private String fechaUltPago;
	private String pagoAnticipado;
	private String montoUltimoPago;
	private String fechaPagoInmediato;
	private String montoPagoInmediato;
	private String fechaValuacionGaran;
	private String paisEntidadExtranjera;
	private String clasificaConta;
	private String tipoTasa;
	private String saldoInicio;
	private String institucionID;
	private String identificadorID;
	private String periodoRep;

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
	public String getClaveEntidad() {
		return claveEntidad;
	}
	public void setClaveEntidad(String claveEntidad) {
		this.claveEntidad = claveEntidad;
	}
	public String getFormulario() {
		return formulario;
	}
	public void setFormulario(String formulario) {
		this.formulario = formulario;
	}
	public String getNumeroIden() {
		return numeroIden;
	}
	public void setNumeroIden(String numeroIden) {
		this.numeroIden = numeroIden;
	}
	public String getTipoPrestamista() {
		return tipoPrestamista;
	}
	public void setTipoPrestamista(String tipoPrestamista) {
		this.tipoPrestamista = tipoPrestamista;
	}
	public String getClavePrestamista() {
		return clavePrestamista;
	}
	public void setClavePrestamista(String clavePrestamista) {
		this.clavePrestamista = clavePrestamista;
	}
	public String getNumeroContrato() {
		return numeroContrato;
	}
	public void setNumeroContrato(String numeroContrato) {
		this.numeroContrato = numeroContrato;
	}
	public String getNumeroCuenta() {
		return numeroCuenta;
	}
	public void setNumeroCuenta(String numeroCuenta) {
		this.numeroCuenta = numeroCuenta;
	}
	public String getFechaContra() {
		return fechaContra;
	}
	public void setFechaContra(String fechaContra) {
		this.fechaContra = fechaContra;
	}
	public String getFechaVencim() {
		return fechaVencim;
	}
	public void setFechaVencim(String fechaVencim) {
		this.fechaVencim = fechaVencim;
	}
	public String getTasaAnual() {
		return tasaAnual;
	}
	public void setTasaAnual(String tasaAnual) {
		this.tasaAnual = tasaAnual;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getPeriodoPago() {
		return periodoPago;
	}
	public void setPeriodoPago(String periodoPago) {
		this.periodoPago = periodoPago;
	}
	public String getMontoRecibido() {
		return montoRecibido;
	}
	public void setMontoRecibido(String montoRecibido) {
		this.montoRecibido = montoRecibido;
	}
	public String getTipoCredito() {
		return tipoCredito;
	}
	public void setTipoCredito(String tipoCredito) {
		this.tipoCredito = tipoCredito;
	}
	public String getDestino() {
		return destino;
	}
	public void setDestino(String destino) {
		this.destino = destino;
	}
	public String getTipoGarantia() {
		return tipoGarantia;
	}
	public void setTipoGarantia(String tipoGarantia) {
		this.tipoGarantia = tipoGarantia;
	}
	public String getMontoGarantia() {
		return montoGarantia;
	}
	public void setMontoGarantia(String montoGarantia) {
		this.montoGarantia = montoGarantia;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getMontoPago() {
		return montoPago;
	}
	public void setMontoPago(String montoPago) {
		this.montoPago = montoPago;
	}
	public String getClasificaCortLarg() {
		return clasificaCortLarg;
	}
	public void setClasificaCortLarg(String clasificaCortLarg) {
		this.clasificaCortLarg = clasificaCortLarg;
	}
	public String getSalInsoluto() {
		return salInsoluto;
	}
	public void setSalInsoluto(String salInsoluto) {
		this.salInsoluto = salInsoluto;
	}
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	public String getRenglon() {
		return renglon;
	}
	public void setRenglon(String renglon) {
		this.renglon = renglon;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public List getlnumeroIden() {
		return lnumeroIden;
	}
	public void setlnumeroIden(List lnumeroIden) {
		this.lnumeroIden = lnumeroIden;
	}
	public List getltipoPrestamista() {
		return ltipoPrestamista;
	}
	public void setltipoPrestamista(List ltipoPrestamista) {
		this.ltipoPrestamista = ltipoPrestamista;
	}
	public List getlclavePrestamista() {
		return lclavePrestamista;
	}
	public void setlclavePrestamista(List lclavePrestamista) {
		this.lclavePrestamista = lclavePrestamista;
	}
	public List getlnumeroContrato() {
		return lnumeroContrato;
	}
	public void setlnumeroContrato(List lnumeroContrato) {
		this.lnumeroContrato = lnumeroContrato;
	}
	public List getlfechaContra() {
		return lfechaContra;
	}
	public void setlfechaContra(List lfechaContra) {
		this.lfechaContra = lfechaContra;
	}
	public List getlfechaVencim() {
		return lfechaVencim;
	}
	public void setlfechaVencim(List lfechaVencim) {
		this.lfechaVencim = lfechaVencim;
	}
	public List getltasaAnual() {
		return ltasaAnual;
	}
	public void setltasaAnual(List ltasaAnual) {
		this.ltasaAnual = ltasaAnual;
	}
	public List getlplazo() {
		return lplazo;
	}
	public void setlplazo(List lplazo) {
		this.lplazo = lplazo;
	}
	public List getlperiodoPago() {
		return lperiodoPago;
	}
	public void setlperiodoPago(List lperiodoPago) {
		this.lperiodoPago = lperiodoPago;
	}
	public List getlmontoRecibido() {
		return lmontoRecibido;
	}
	public void setlmontoRecibido(List lmontoRecibido) {
		this.lmontoRecibido = lmontoRecibido;
	}
	public List getltipoCredito() {
		return ltipoCredito;
	}
	public void setltipoCredito(List ltipoCredito) {
		this.ltipoCredito = ltipoCredito;
	}
	public List getldestino() {
		return ldestino;
	}
	public void setldestino(List ldestino) {
		this.ldestino = ldestino;
	}
	public List getltipoGarantia() {
		return ltipoGarantia;
	}
	public void setltipoGarantia(List ltipoGarantia) {
		this.ltipoGarantia = ltipoGarantia;
	}
	public List getlmontoGarantia() {
		return lmontoGarantia;
	}
	public void setlmontoGarantia(List lmontoGarantia) {
		this.lmontoGarantia = lmontoGarantia;
	}
	public List getlfechaPago() {
		return lfechaPago;
	}
	public void setlfechaPago(List lfechaPago) {
		this.lfechaPago = lfechaPago;
	}
	public List getlmontoPago() {
		return lmontoPago;
	}
	public void setlmontoPago(List lmontoPago) {
		this.lmontoPago = lmontoPago;
	}
	public List getlclasificaCortLarg() {
		return lclasificaCortLarg;
	}
	public void setlclasificaCortLarg(List lclasificaCortLarg) {
		this.lclasificaCortLarg = lclasificaCortLarg;
	}
	public List getlsalInsoluto() {
		return lsalInsoluto;
	}
	public void setlsalInsoluto(List lsalInsoluto) {
		this.lsalInsoluto = lsalInsoluto;
	}
	public List getlrenglon() {
		return lrenglon;
	}
	public void setlrenglon(List lrenglon) {
		this.lrenglon = lrenglon;
	}
	public List getldescripcion() {
		return ldescripcion;
	}
	public void setldescripcion(List ldescripcion) {
		this.ldescripcion = ldescripcion;
	}
	public List getlAnio() {
		return lAnio;
	}
	public void setlAnio(List lAnio) {
		this.lAnio = lAnio;
	}
	public List getlMes() {
		return lMes;
	}
	public void setlMes(List lMes) {
		this.lMes = lMes;
	}
	public List getlFormulario() {
		return lFormulario;
	}
	public void setlFormulario(List lFormulario) {
		this.lFormulario = lFormulario;
	}
	public List getlPeriodo() {
		return lPeriodo;
	}
	public void setlPeriodo(List lPeriodo) {
		this.lPeriodo = lPeriodo;
	}
	public List getlnumeroCuenta() {
		return lnumeroCuenta;
	}
	public void setlnumeroCuenta(List lnumeroCuenta) {
		this.lnumeroCuenta = lnumeroCuenta;
	}
	public List getLnumeroIden() {
		return lnumeroIden;
	}
	public void setLnumeroIden(List lnumeroIden) {
		this.lnumeroIden = lnumeroIden;
	}
	public List getLtipoPrestamista() {
		return ltipoPrestamista;
	}
	public void setLtipoPrestamista(List ltipoPrestamista) {
		this.ltipoPrestamista = ltipoPrestamista;
	}
	public List getLclavePrestamista() {
		return lclavePrestamista;
	}
	public void setLclavePrestamista(List lclavePrestamista) {
		this.lclavePrestamista = lclavePrestamista;
	}
	public List getLnumeroContrato() {
		return lnumeroContrato;
	}
	public void setLnumeroContrato(List lnumeroContrato) {
		this.lnumeroContrato = lnumeroContrato;
	}
	public List getLnumeroCuenta() {
		return lnumeroCuenta;
	}
	public void setLnumeroCuenta(List lnumeroCuenta) {
		this.lnumeroCuenta = lnumeroCuenta;
	}
	public List getLfechaContra() {
		return lfechaContra;
	}
	public void setLfechaContra(List lfechaContra) {
		this.lfechaContra = lfechaContra;
	}
	public List getLfechaVencim() {
		return lfechaVencim;
	}
	public void setLfechaVencim(List lfechaVencim) {
		this.lfechaVencim = lfechaVencim;
	}
	public List getLtasaAnual() {
		return ltasaAnual;
	}
	public void setLtasaAnual(List ltasaAnual) {
		this.ltasaAnual = ltasaAnual;
	}
	public List getLplazo() {
		return lplazo;
	}
	public void setLplazo(List lplazo) {
		this.lplazo = lplazo;
	}
	public List getLperiodoPago() {
		return lperiodoPago;
	}
	public void setLperiodoPago(List lperiodoPago) {
		this.lperiodoPago = lperiodoPago;
	}
	public List getLmontoRecibido() {
		return lmontoRecibido;
	}
	public void setLmontoRecibido(List lmontoRecibido) {
		this.lmontoRecibido = lmontoRecibido;
	}
	public List getLtipoCredito() {
		return ltipoCredito;
	}
	public void setLtipoCredito(List ltipoCredito) {
		this.ltipoCredito = ltipoCredito;
	}
	public List getLdestino() {
		return ldestino;
	}
	public void setLdestino(List ldestino) {
		this.ldestino = ldestino;
	}
	public List getLtipoGarantia() {
		return ltipoGarantia;
	}
	public void setLtipoGarantia(List ltipoGarantia) {
		this.ltipoGarantia = ltipoGarantia;
	}
	public List getLmontoGarantia() {
		return lmontoGarantia;
	}
	public void setLmontoGarantia(List lmontoGarantia) {
		this.lmontoGarantia = lmontoGarantia;
	}
	public List getLfechaPago() {
		return lfechaPago;
	}
	public void setLfechaPago(List lfechaPago) {
		this.lfechaPago = lfechaPago;
	}
	public List getLmontoPago() {
		return lmontoPago;
	}
	public void setLmontoPago(List lmontoPago) {
		this.lmontoPago = lmontoPago;
	}
	public List getLclasificaCortLarg() {
		return lclasificaCortLarg;
	}
	public void setLclasificaCortLarg(List lclasificaCortLarg) {
		this.lclasificaCortLarg = lclasificaCortLarg;
	}
	public List getLsalInsoluto() {
		return lsalInsoluto;
	}
	public void setLsalInsoluto(List lsalInsoluto) {
		this.lsalInsoluto = lsalInsoluto;
	}
	public List getLrenglon() {
		return lrenglon;
	}
	public void setLrenglon(List lrenglon) {
		this.lrenglon = lrenglon;
	}
	public List getLdescripcion() {
		return ldescripcion;
	}
	public void setLdescripcion(List ldescripcion) {
		this.ldescripcion = ldescripcion;
	}
	public String getMontoInicialPrestamo() {
		return montoInicialPrestamo;
	}
	public void setMontoInicialPrestamo(String montoInicialPrestamo) {
		this.montoInicialPrestamo = montoInicialPrestamo;
	}
	public String getValTasaOriginal() {
		return valTasaOriginal;
	}
	public void setValTasaOriginal(String valTasaOriginal) {
		this.valTasaOriginal = valTasaOriginal;
	}
	public String getValTasaInt() {
		return valTasaInt;
	}
	public void setValTasaInt(String valTasaInt) {
		this.valTasaInt = valTasaInt;
	}
	public String getTasaIntReferencia() {
		return tasaIntReferencia;
	}
	public void setTasaIntReferencia(String tasaIntReferencia) {
		this.tasaIntReferencia = tasaIntReferencia;
	}
	public String getDiferenciaTasaRef() {
		return diferenciaTasaRef;
	}
	public void setDiferenciaTasaRef(String diferenciaTasaRef) {
		this.diferenciaTasaRef = diferenciaTasaRef;
	}
	public String getOperaDifTasaRefe() {
		return operaDifTasaRefe;
	}
	public void setOperaDifTasaRefe(String operaDifTasaRefe) {
		this.operaDifTasaRefe = operaDifTasaRefe;
	}
	public String getFrecRevisionTasa() {
		return frecRevisionTasa;
	}
	public void setFrecRevisionTasa(String frecRevisionTasa) {
		this.frecRevisionTasa = frecRevisionTasa;
	}
	public String getTipoMoneda() {
		return tipoMoneda;
	}
	public void setTipoMoneda(String tipoMoneda) {
		this.tipoMoneda = tipoMoneda;
	}
	public String getPorcentajeComision() {
		return porcentajeComision;
	}
	public void setPorcentajeComision(String porcentajeComision) {
		this.porcentajeComision = porcentajeComision;
	}
	public String getImporteComision() {
		return importeComision;
	}
	public void setImporteComision(String importeComision) {
		this.importeComision = importeComision;
	}
	public String getPeriodoPagoComision() {
		return periodoPagoComision;
	}
	public void setPeriodoPagoComision(String periodoPagoComision) {
		this.periodoPagoComision = periodoPagoComision;
	}
	public String getTipoDisposicionCredito() {
		return tipoDisposicionCredito;
	}
	public void setTipoDisposicionCredito(String tipoDisposicionCredito) {
		this.tipoDisposicionCredito = tipoDisposicionCredito;
	}
	public String getPagosRealizados() {
		return pagosRealizados;
	}
	public void setPagosRealizados(String pagosRealizados) {
		this.pagosRealizados = pagosRealizados;
	}
	public String getComisionPagada() {
		return comisionPagada;
	}
	public void setComisionPagada(String comisionPagada) {
		this.comisionPagada = comisionPagada;
	}
	public String getInteresesPagados() {
		return interesesPagados;
	}
	public void setInteresesPagados(String interesesPagados) {
		this.interesesPagados = interesesPagados;
	}
	public String getInteresesDevengados() {
		return interesesDevengados;
	}
	public void setInteresesDevengados(String interesesDevengados) {
		this.interesesDevengados = interesesDevengados;
	}
	public String getSaldoCierre() {
		return saldoCierre;
	}
	public void setSaldoCierre(String saldoCierre) {
		this.saldoCierre = saldoCierre;
	}
	public String getPorcentajeLinRevolvente() {
		return porcentajeLinRevolvente;
	}
	public void setPorcentajeLinRevolvente(String porcentajeLinRevolvente) {
		this.porcentajeLinRevolvente = porcentajeLinRevolvente;
	}
	public String getFechaUltPago() {
		return fechaUltPago;
	}
	public void setFechaUltPago(String fechaUltPago) {
		this.fechaUltPago = fechaUltPago;
	}
	public String getPagoAnticipado() {
		return pagoAnticipado;
	}
	public void setPagoAnticipado(String pagoAnticipado) {
		this.pagoAnticipado = pagoAnticipado;
	}
	public String getMontoUltimoPago() {
		return montoUltimoPago;
	}
	public void setMontoUltimoPago(String montoUltimoPago) {
		this.montoUltimoPago = montoUltimoPago;
	}
	public String getFechaPagoInmediato() {
		return fechaPagoInmediato;
	}
	public void setFechaPagoInmediato(String fechaPagoInmediato) {
		this.fechaPagoInmediato = fechaPagoInmediato;
	}
	public String getMontoPagoInmediato() {
		return montoPagoInmediato;
	}
	public void setMontoPagoInmediato(String montoPagoInmediato) {
		this.montoPagoInmediato = montoPagoInmediato;
	}
	public String getFechaValuacionGaran() {
		return fechaValuacionGaran;
	}
	public void setFechaValuacionGaran(String fechaValuacionGaran) {
		this.fechaValuacionGaran = fechaValuacionGaran;
	}
	public String getPaisEntidadExtranjera() {
		return paisEntidadExtranjera;
	}
	public void setPaisEntidadExtranjera(String paisEntidadExtranjera) {
		this.paisEntidadExtranjera = paisEntidadExtranjera;
	}
	public String getClasificaConta() {
		return clasificaConta;
	}
	public void setClasificaConta(String clasificaConta) {
		this.clasificaConta = clasificaConta;
	}
	public String getTipoTasa() {
		return tipoTasa;
	}
	public void setTipoTasa(String tipoTasa) {
		this.tipoTasa = tipoTasa;
	}
	public String pagosRealizados() {
		return saldoInicio;
	}
	public String getSaldoInicio() {
		return saldoInicio;
	}
	public void setSaldoInicio(String saldoInicio) {
		this.saldoInicio = saldoInicio;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getIdentificadorID() {
		return identificadorID;
	}
	public void setIdentificadorID(String identificadorID) {
		this.identificadorID = identificadorID;
	}
	public String getPeriodoRep() {
		return periodoRep;
	}
	public void setPeriodoRep(String periodoRep) {
		this.periodoRep = periodoRep;
	}
	
	
	
}
