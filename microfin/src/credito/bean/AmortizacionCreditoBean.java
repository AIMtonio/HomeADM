package credito.bean;

import general.bean.BaseBean;

public class AmortizacionCreditoBean extends BaseBean {
	
	//Declaracion de Constantes
	public static final String STATUS_VIGENTE = "V";
	public static final String STATUS_PAAGADA = "P";
	
	//Atributos o Variables
	private String amortizacionID;
	private String creditoID;
	private String clienteID;
	private String cuentaID;
	private String fechaInicio;
	private String fechaVencim;
	private String fechaExigible;
	private String estatus;
	private String fechaLiquida;
	private String saldoInsoluto;
	private String totalPago;		
	private String capital;
	private String interes;
	private String ivaInteres;
	private String empresaID;
	private String cuotasCapital;
	private String cuotasInteres;
	private String dias;
	private String capitalInteres;
	private String saldoCapital;
	private String cat;
	private String montoSeguroCuota;
	private String iVASeguroCuota;
	private String cobraSeguroCuota;
	private String cobraIVASeguroCuota;
	private String montoOtrasComisiones;
	private String montoIVAOtrasComisiones;
	
	private int numPaginas;
	//Saldos
	private String saldoCapVigente;
	private String saldoCapAtrasado;
	private String saldoCapVencido;
	private String saldoCapVNE;

	private String saldoIntProvisionado;
	private String saldoIntAtrasado;
	private String saldoIntVencido;
	private String saldoIntCalNoCont;
	private String saldoIVAInteres;
		
	private String saldoMoratorios;
	private String saldoIVAMora;	

	private String saldoComFaltaPago;
	private String saldoIVAComFaltaPago;	

	private String saldoOtrasComisiones;
	private String saldoIVAOtrasCom;
	private String saldoSeguroCuota;
	private String saldoIVASeguroCuota;
	
	
	//Parametros Auditoria	
	
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	// Auxiliar de amortizaciones de Credito
	private String fecUltAmor;
	private String fecInicioAmor;
	private String montoCuota;
	//dias de atraso
	private String diasAtraso;

	private String totalCap;
	private String totalIva;
	private String totalInteres;
	private String totalSeguroCuota;
	private String totalIVASeguroCuota;
	private String totalOtrasComisiones;
	private String totalIVAOtrasComisiones;
	
	// Auxiliares del reporte
	private String nombreInstitucion;
	private String califCliente;
	private String nombreCliente;
	private String frecuencia;
	private String frecuenciaInt;
	private String frecuenciaDes;
	private String tasaFija;
	private String numCuotas;
	private String numCuotasInt;
	private String montoSol;
	private String periodicidad;
	private String periodicidadInt;
	private String diaPago;
	private String diaPagoInt;
	private String diaMes;
	private String diaMesInt;
	private String producCreditoID;
	private String diaHabilSig;
	private String ajustaFecAmo;
	private String ajusFecExiVen;
	private String comApertura;
	private String calculoInt;
	private String tipoCalculoInt;
	private String tipoPagCap;
	
	//Auxiliares SOFIEXPRESS
	private String cuotasPagadas;
	private String totalCuotas;
	
	//Auxiliar SANA TUS FINANZAS WS
	private String saldoFinalPlazo;
	
	// Auxiliar reporte de proyección
	private String leyendaTasaVariable;
	private String saldoComisionAnual; //Comision de anualidad de crédito
	private String saldoComisionAnualIVA;//IVA Comision de anualidad de crédito
	
	//MEXI
	private String convenioNominaID;
	
	// Auxiliares para simulares para el manejo de errores
	private String codigoError;
	private String mensajeError;
	
	//Campos para el cobro de accesorios
	private String cobraAccesorios;
	private String cobraAccesoriosGen;
	private String plazoID;

	private String saldoNotasCargo;
	private String montoIvaNotaCargo;
	
	public String getCalculoInt() {
		return calculoInt;
	}
	public void setCalculoInt(String calculoInt) {
		this.calculoInt = calculoInt;
	}
	public String getFrecuenciaInt() {
		return frecuenciaInt;
	}
	public void setFrecuenciaInt(String frecuenciaInt) {
		this.frecuenciaInt = frecuenciaInt;
	}
	public String getNumCuotasInt() {
		return numCuotasInt;
	}
	public void setNumCuotasInt(String numCuotasInt) {
		this.numCuotasInt = numCuotasInt;
	}
	public String getPeriodicidadInt() {
		return periodicidadInt;
	}
	public void setPeriodicidadInt(String periodicidadInt) {
		this.periodicidadInt = periodicidadInt;
	}
	public String getDiaPagoInt() {
		return diaPagoInt;
	}
	public void setDiaPagoInt(String diaPagoInt) {
		this.diaPagoInt = diaPagoInt;
	}
	public String getDiaMesInt() {
		return diaMesInt;
	}
	public void setDiaMesInt(String diaMesInt) {
		this.diaMesInt = diaMesInt;
	}
	
	public String getTipoPagCap() {
		return tipoPagCap;
	}
	public void setTipoPagCap(String tipoPagCap) {
		this.tipoPagCap = tipoPagCap;
	}
	public String getFrecuenciaDes() {
		return frecuenciaDes;
	}
	public void setFrecuenciaDes(String frecuenciaDes) {
		this.frecuenciaDes = frecuenciaDes;
	}
	public String getTipoCalculoInt() {
		return tipoCalculoInt;
	}
	public void setTipoCalculoInt(String tipoCalculoInt) {
		this.tipoCalculoInt = tipoCalculoInt;
	}
	public String getMontoSol() {
		return montoSol;
	}
	public void setMontoSol(String montoSol) {
		this.montoSol = montoSol;
	}
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public String getDiaPago() {
		return diaPago;
	}
	public void setDiaPago(String diaPago) {
		this.diaPago = diaPago;
	}
	public String getDiaMes() {
		return diaMes;
	}
	public void setDiaMes(String diaMes) {
		this.diaMes = diaMes;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getDiaHabilSig() {
		return diaHabilSig;
	}
	public void setDiaHabilSig(String diaHabilSig) {
		this.diaHabilSig = diaHabilSig;
	}
	public String getAjustaFecAmo() {
		return ajustaFecAmo;
	}
	public void setAjustaFecAmo(String ajustaFecAmo) {
		this.ajustaFecAmo = ajustaFecAmo;
	}
	public String getAjusFecExiVen() {
		return ajusFecExiVen;
	}
	public void setAjusFecExiVen(String ajusFecExiVen) {
		this.ajusFecExiVen = ajusFecExiVen;
	}
	public String getComApertura() {
		return comApertura;
	}
	public void setComApertura(String comApertura) {
		this.comApertura = comApertura;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getNumCuotas() {
		return numCuotas;
	}
	public void setNumCuotas(String numCuotas) {
		this.numCuotas = numCuotas;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getCalifCliente() {
		return califCliente;
	}
	public void setCalifCliente(String califCliente) {
		this.califCliente = califCliente;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public String getAmortizacionID() {
		return amortizacionID;
	}
	public void setAmortizacionID(String amortizacionID) {
		this.amortizacionID = amortizacionID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaID() {
		return cuentaID;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencim() {
		return fechaVencim;
	}
	public void setFechaVencim(String fechaVencim) {
		this.fechaVencim = fechaVencim;
	}
	public String getFechaExigible() {
		return fechaExigible;
	}
	public void setFechaExigible(String fechaExigible) {
		this.fechaExigible = fechaExigible;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getFechaLiquida() {
		return fechaLiquida;
	}
	public void setFechaLiquida(String fechaLiquida) {
		this.fechaLiquida = fechaLiquida;
	}	
	
	public String getSaldoInsoluto() {
		return saldoInsoluto;
	}
	public void setSaldoInsoluto(String saldoInsoluto) {
		this.saldoInsoluto = saldoInsoluto;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getInteres() {
		return interes;
	}
	public void setInteres(String interes) {
		this.interes = interes;
	}
	public String getIvaInteres() {
		return ivaInteres;
	}
	public void setIvaInteres(String ivaInteres) {
		this.ivaInteres = ivaInteres;
	}	
	
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public String getSaldoIVAMora() {
		return saldoIVAMora;
	}
	public void setSaldoIVAMora(String saldoIVAMpra) {
		this.saldoIVAMora = saldoIVAMpra;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getTotalPago() {
		return totalPago;
	}
	public void setTotalPago(String totalPago) {
		this.totalPago = totalPago;
	}

	public String getCuotasCapital() {
		return cuotasCapital;
	}
	public void setCuotasCapital(String cuotasCapital) {
		this.cuotasCapital = cuotasCapital;
	}
	public String getCuotasInteres() {
		return cuotasInteres;
	}
	public void setCuotasInteres(String cuotasInteres) {
		this.cuotasInteres = cuotasInteres;
	}
	public String getDias() {
		return dias;
	}
	public void setDias(String dias) {
		this.dias = dias;
	}
	public String getCapitalInteres() {
		return capitalInteres;
	}
	public void setCapitalInteres(String capitalInteres) {
		this.capitalInteres = capitalInteres;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getCat() {
		return cat;
	}
	public void setCat(String cat) {
		this.cat = cat;
	}
	public String getFecUltAmor() {
		return fecUltAmor;
	}
	public void setFecUltAmor(String fecUltAmor) {
		this.fecUltAmor = fecUltAmor;
	}
	public String getFecInicioAmor() {
		return fecInicioAmor;
	}
	public void setFecInicioAmor(String fecInicioAmor) {
		this.fecInicioAmor = fecInicioAmor;
	}
	public String getSaldoCapital() {
		return saldoCapital;
	}
	public void setSaldoCapital(String saldoCapital) {
		this.saldoCapital = saldoCapital;
	}
	public String getSaldoCapVigente() {
		return saldoCapVigente;
	}
	public void setSaldoCapVigente(String saldoCapVigente) {
		this.saldoCapVigente = saldoCapVigente;
	}
	public String getSaldoCapAtrasado() {
		return saldoCapAtrasado;
	}
	public void setSaldoCapAtrasado(String saldoCapAtrasado) {
		this.saldoCapAtrasado = saldoCapAtrasado;
	}
	public String getSaldoCapVencido() {
		return saldoCapVencido;
	}
	public void setSaldoCapVencido(String saldoCapVencido) {
		this.saldoCapVencido = saldoCapVencido;
	}
	public String getSaldoCapVNE() {
		return saldoCapVNE;
	}
	public void setSaldoCapVNE(String saldoCapVNE) {
		this.saldoCapVNE = saldoCapVNE;
	}
	public String getSaldoIntProvisionado() {
		return saldoIntProvisionado;
	}
	public void setSaldoIntProvisionado(String saldoIntProvisionado) {
		this.saldoIntProvisionado = saldoIntProvisionado;
	}
	public String getSaldoIntAtrasado() {
		return saldoIntAtrasado;
	}
	public void setSaldoIntAtrasado(String saldoIntAtrasado) {
		this.saldoIntAtrasado = saldoIntAtrasado;
	}
	public String getSaldoIntVencido() {
		return saldoIntVencido;
	}
	public void setSaldoIntVencido(String saldoIntVencido) {
		this.saldoIntVencido = saldoIntVencido;
	}
	public String getSaldoIntCalNoCont() {
		return saldoIntCalNoCont;
	}
	public void setSaldoIntCalNoCont(String saldoIntCalNoCont) {
		this.saldoIntCalNoCont = saldoIntCalNoCont;
	}
	public String getSaldoIVAInteres() {
		return saldoIVAInteres;
	}
	public void setSaldoIVAInteres(String saldoIVAInteres) {
		this.saldoIVAInteres = saldoIVAInteres;
	}
	public String getSaldoComFaltaPago() {
		return saldoComFaltaPago;
	}
	public void setSaldoComFaltaPago(String saldoComFaltaPago) {
		this.saldoComFaltaPago = saldoComFaltaPago;
	}
	public String getSaldoIVAComFaltaPago() {
		return saldoIVAComFaltaPago;
	}
	public void setSaldoIVAComFaltaPago(String saldoIVAComFaltaPago) {
		this.saldoIVAComFaltaPago = saldoIVAComFaltaPago;
	}
	public String getSaldoOtrasComisiones() {
		return saldoOtrasComisiones;
	}
	public void setSaldoOtrasComisiones(String saldoOtrasComisiones) {
		this.saldoOtrasComisiones = saldoOtrasComisiones;
	}
	public String getSaldoIVAOtrasCom() {
		return saldoIVAOtrasCom;
	}
	public void setSaldoIVAOtrasCom(String saldoIVAOtrasCom) {
		this.saldoIVAOtrasCom = saldoIVAOtrasCom;
	}

	public String getDiasAtraso() {
		return diasAtraso;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public int getNumPaginas() {
		return numPaginas;
	}
	public void setNumPaginas(int numPaginas) {
		this.numPaginas = numPaginas;
	}
	public String getTotalCap() {
		return totalCap;
	}
	public void setTotalCap(String totalCap) {
		this.totalCap = totalCap;
	}
	public String getTotalIva() {
		return totalIva;
	}
	public void setTotalIva(String totalIva) {
		this.totalIva = totalIva;
	}
	public String getTotalInteres() {
		return totalInteres;
	}
	public void setTotalInteres(String totalInteres) {
		this.totalInteres = totalInteres;
	}
	public String getCuotasPagadas() {
		return cuotasPagadas;
	}
	public void setCuotasPagadas(String cuotasPagadas) {
		this.cuotasPagadas = cuotasPagadas;
	}
	public String getTotalCuotas() {
		return totalCuotas;
	}
	public void setTotalCuotas(String totalCuotas) {
		this.totalCuotas = totalCuotas;
	}
	public String getSaldoFinalPlazo() {
		return saldoFinalPlazo;
	}
	public void setSaldoFinalPlazo(String saldoFinalPlazo) {
		this.saldoFinalPlazo = saldoFinalPlazo;
	}
	public String getLeyendaTasaVariable() {
		return leyendaTasaVariable;
	}
	public void setLeyendaTasaVariable(String leyendaTasaVariable) {
		this.leyendaTasaVariable = leyendaTasaVariable;
	}

	public String getCodigoError() {
		return codigoError;
	}
	public void setCodigoError(String codigoError) {
		this.codigoError = codigoError;
	}
	public String getMensajeError() {
		return mensajeError;
	}
		public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}
	public String getMontoSeguroCuota() {
		return montoSeguroCuota;
	}
	public void setMontoSeguroCuota(String montoSeguroCuota) {
		this.montoSeguroCuota = montoSeguroCuota;
	}
	public String getiVASeguroCuota() {
		return iVASeguroCuota;
	}
	public void setiVASeguroCuota(String iVASeguroCuota) {
		this.iVASeguroCuota = iVASeguroCuota;
	}
	public String getTotalSeguroCuota() {
		return totalSeguroCuota;
	}
	public void setTotalSeguroCuota(String totalSeguroCuota) {
		this.totalSeguroCuota = totalSeguroCuota;
	}
	public String getTotalIVASeguroCuota() {
		return totalIVASeguroCuota;
	}
	public void setTotalIVASeguroCuota(String totalIVASeguroCuota) {
		this.totalIVASeguroCuota = totalIVASeguroCuota;
	}
	public String getTotalOtrasComisiones() {
		return totalOtrasComisiones;
	}
	public void setTotalOtrasComisiones(String totalOtrasComisiones) {
		this.totalOtrasComisiones = totalOtrasComisiones;
	}	
	public String getTotalIVAOtrasComisiones() {
		return totalIVAOtrasComisiones;
	}
	public void setTotalIVAOtrasComisiones(String totalIVAOtrasComisiones) {
		this.totalIVAOtrasComisiones = totalIVAOtrasComisiones;
	}
	public String getCobraSeguroCuota() {
		return cobraSeguroCuota;
	}
	public void setCobraSeguroCuota(String cobraSeguroCuota) {
		this.cobraSeguroCuota = cobraSeguroCuota;
	}
	public String getCobraIVASeguroCuota() {
		return cobraIVASeguroCuota;
	}
	public void setCobraIVASeguroCuota(String cobraIVASeguroCuota) {
		this.cobraIVASeguroCuota = cobraIVASeguroCuota;
	}
	public String getSaldoSeguroCuota() {
		return saldoSeguroCuota;
	}
	public void setSaldoSeguroCuota(String saldoSeguroCuota) {
		this.saldoSeguroCuota = saldoSeguroCuota;
	}
	public String getSaldoIVASeguroCuota() {
		return saldoIVASeguroCuota;
	}
	public void setSaldoIVASeguroCuota(String saldoIVASeguroCuota) {
		this.saldoIVASeguroCuota = saldoIVASeguroCuota;
	}
	public String getSaldoComisionAnual() {
		return saldoComisionAnual;
	}
	public void setSaldoComisionAnual(String saldoComisionAnual) {
		this.saldoComisionAnual = saldoComisionAnual;
	}
	public String getSaldoComisionAnualIVA() {
		return saldoComisionAnualIVA;
	}
	public void setSaldoComisionAnualIVA(String saldoComisionAnualIVA) {
		this.saldoComisionAnualIVA = saldoComisionAnualIVA;
	}
	public String getMontoOtrasComisiones() {
		return montoOtrasComisiones;
	}
	public void setMontoOtrasComisiones(String montoOtrasComisiones) {
		this.montoOtrasComisiones = montoOtrasComisiones;
	}
	public String getMontoIVAOtrasComisiones() {
		return montoIVAOtrasComisiones;
	}
	public void setMontoIVAOtrasComisiones(String montoIVAOtrasComisiones) {
		this.montoIVAOtrasComisiones = montoIVAOtrasComisiones;
	}
	public String getCobraAccesorios() {
		return cobraAccesorios;
	}
	public void setCobraAccesorios(String cobraAccesorios) {
		this.cobraAccesorios = cobraAccesorios;
	}
	public String getCobraAccesoriosGen() {
		return cobraAccesoriosGen;
	}
	public void setCobraAccesoriosGen(String cobraAccesoriosGen) {
		this.cobraAccesoriosGen = cobraAccesoriosGen;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getSaldoNotasCargo() {
		return saldoNotasCargo;
	}
	public void setSaldoNotasCargo(String saldoNotasCargo) {
		this.saldoNotasCargo = saldoNotasCargo;
	}
	public String getMontoIvaNotaCargo() {
		return montoIvaNotaCargo;
	}
	public void setMontoIvaNotaCargo(String montoIvaNotaCargo) {
		this.montoIvaNotaCargo = montoIvaNotaCargo;
	}
	
	
}
