package fira.bean;

import java.util.List;

import general.bean.BaseBean;

public class GarantiaFiraBean extends BaseBean {
	
	
	private String creditoID;
	private String tipoGarantiaID;
	private String esCancelado; 
		
	private List lisCreditoID;
	private List lisTipoGarantiaID;
	private List lisCancelado;

	// Para pantalla de aplicacion de garantias	
	private String clienteID;
	private String nombreCliente;
	private String cuentaID;
	private String nomCuenta;
	private String monedaID;
	private String estatus;
	private String diasFaltaPago;
	private String tasaFija;
	private String fechaProxPago;
	private String adeudoTotal;
	private String pagoExigible;
	private String saldoIVAInteres;
	private String saldoCapVigent;
	private String saldoInterOrdin;
	private String saldoComFaltPago;
	private String salIVAComFalPag;
	private String saldoCapAtrasad;
	private String saldoInterAtras;
	private String saldoMoratorios;
	private String saldoOtrasComis;
	private String saldoIVAComisi;
	private String saldoCapVencido;
	private String saldoInterVenc;
	private String saldoIVAMorator;
	private String saldoAdmonComis;
	private String saldoIVAAdmonComisi;
	private String saldCapVenNoExi;
	private String saldoInterProvi;
	private String totalComisi;
	private String totalIVACom;
	private String totalCapital;
	private String saldoIntNoConta;
	private String totalInteres;
	private String lineaCreditoID;
	private String producCreditoID;
	private String fechaSistema;
	private String garantiaLiquida;
	private String cuentaCompleta;
	private String saldo;
	private String polizaID;
	private String montoTotCredSinIVA;
	private String estatusGarantia;
	private String porcentajeGtia;
	private String garantiaAplicar; 
	private String programaEsp;
	private String progEspecial;
	private String existeGtia; 
	private String creditoContFondeador;
	private String observacion;
	
	// Reporte Créditos con Afectación de Garantía Periódico
	private String consecutivo;
	private String tipoCredito;
	private String creditoActivo;
	private String creditoPasivo;
	private String creditoContigente;
	
	private String creditoFondeador;
	private String creditoPasivoContigente;
	private String fuenteFondeo;
	private String causaPago;
	private String cadenaProductiva;
	
	private String montoGarantia;
	private String fechaGarantia;
	private String fechaAfectacion;
	private String fechaRecuperacion;
	private String saldoCapital;
	
	private String saldoInteres;
	private String montoTotalCapitalRecuperado;
	private String montoTotalInteresRecuperado;
	private String montoPendienteCapitalRecuperado;
	private String montoPendienteInteresRecuperado;
	
	private String saldoIncobrable;
	private String totalRecuperado;
	private String antiguedad;
	private String fechaInicio;
	private String fechaFin;
	
	private String sucursalID;
	private String nombreSucursal;
	private String productoCreditoID;
	private String nombreProductoCredito;
	private String tipoGarantia;
	
	private String rangoFechas;
	private String usuarioReporte;
	private String fechaEmision;
	private String horaEmision;
	private String nombreInstitucion;
	
	private String nombreUsuario;
	
	// Datos de Fondeo
	private String acreditadoIDFIRA;
	private String creditoIDFIRA;
	
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getTipoGarantiaID() {
		return tipoGarantiaID;
	}
	public void setTipoGarantiaID(String tipoGarantiaID) {
		this.tipoGarantiaID = tipoGarantiaID;
	}
	public String getEsCancelado() {
		return esCancelado;
	}
	public void setEsCancelado(String esCancelado) {
		this.esCancelado = esCancelado;
	}
	public List getLisCreditoID() {
		return lisCreditoID;
	}
	public void setLisCreditoID(List lisCreditoID) {
		this.lisCreditoID = lisCreditoID;
	}
	public List getLisTipoGarantiaID() {
		return lisTipoGarantiaID;
	}
	public void setLisTipoGarantiaID(List lisTipoGarantiaID) {
		this.lisTipoGarantiaID = lisTipoGarantiaID;
	}
	public List getLisCancelado() {
		return lisCancelado;
	}
	public void setLisCancelado(List lisCancelado) {
		this.lisCancelado = lisCancelado;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getCuentaID() {
		return cuentaID;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
	}
	public String getNomCuenta() {
		return nomCuenta;
	}
	public void setNomCuenta(String nomCuenta) {
		this.nomCuenta = nomCuenta;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getDiasFaltaPago() {
		return diasFaltaPago;
	}
	public void setDiasFaltaPago(String diasFaltaPago) {
		this.diasFaltaPago = diasFaltaPago;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getFechaProxPago() {
		return fechaProxPago;
	}
	public void setFechaProxPago(String fechaProxPago) {
		this.fechaProxPago = fechaProxPago;
	}
	public String getAdeudoTotal() {
		return adeudoTotal;
	}
	public void setAdeudoTotal(String adeudoTotal) {
		this.adeudoTotal = adeudoTotal;
	}
	public String getPagoExigible() {
		return pagoExigible;
	}
	public void setPagoExigible(String pagoExigible) {
		this.pagoExigible = pagoExigible;
	}
	public String getSaldoIVAInteres() {
		return saldoIVAInteres;
	}
	public void setSaldoIVAInteres(String saldoIVAInteres) {
		this.saldoIVAInteres = saldoIVAInteres;
	}
	public String getSaldoCapVigent() {
		return saldoCapVigent;
	}
	public void setSaldoCapVigent(String saldoCapVigent) {
		this.saldoCapVigent = saldoCapVigent;
	}
	public String getSaldoInterOrdin() {
		return saldoInterOrdin;
	}
	public void setSaldoInterOrdin(String saldoInterOrdin) {
		this.saldoInterOrdin = saldoInterOrdin;
	}
	public String getSaldoComFaltPago() {
		return saldoComFaltPago;
	}
	public void setSaldoComFaltPago(String saldoComFaltPago) {
		this.saldoComFaltPago = saldoComFaltPago;
	}
	public String getSalIVAComFalPag() {
		return salIVAComFalPag;
	}
	public void setSalIVAComFalPag(String salIVAComFalPag) {
		this.salIVAComFalPag = salIVAComFalPag;
	}
	public String getSaldoCapAtrasad() {
		return saldoCapAtrasad;
	}
	public void setSaldoCapAtrasad(String saldoCapAtrasad) {
		this.saldoCapAtrasad = saldoCapAtrasad;
	}
	public String getSaldoInterAtras() {
		return saldoInterAtras;
	}
	public void setSaldoInterAtras(String saldoInterAtras) {
		this.saldoInterAtras = saldoInterAtras;
	}
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public String getSaldoOtrasComis() {
		return saldoOtrasComis;
	}
	public void setSaldoOtrasComis(String saldoOtrasComis) {
		this.saldoOtrasComis = saldoOtrasComis;
	}
	public String getSaldoIVAComisi() {
		return saldoIVAComisi;
	}
	public void setSaldoIVAComisi(String saldoIVAComisi) {
		this.saldoIVAComisi = saldoIVAComisi;
	}
	public String getSaldoCapVencido() {
		return saldoCapVencido;
	}
	public void setSaldoCapVencido(String saldoCapVencido) {
		this.saldoCapVencido = saldoCapVencido;
	}
	public String getSaldoInterVenc() {
		return saldoInterVenc;
	}
	public void setSaldoInterVenc(String saldoInterVenc) {
		this.saldoInterVenc = saldoInterVenc;
	}
	public String getSaldoIVAMorator() {
		return saldoIVAMorator;
	}
	public void setSaldoIVAMorator(String saldoIVAMorator) {
		this.saldoIVAMorator = saldoIVAMorator;
	}
	public String getSaldoAdmonComis() {
		return saldoAdmonComis;
	}
	public void setSaldoAdmonComis(String saldoAdmonComis) {
		this.saldoAdmonComis = saldoAdmonComis;
	}
	public String getSaldoIVAAdmonComisi() {
		return saldoIVAAdmonComisi;
	}
	public void setSaldoIVAAdmonComisi(String saldoIVAAdmonComisi) {
		this.saldoIVAAdmonComisi = saldoIVAAdmonComisi;
	}
	public String getSaldCapVenNoExi() {
		return saldCapVenNoExi;
	}
	public void setSaldCapVenNoExi(String saldCapVenNoExi) {
		this.saldCapVenNoExi = saldCapVenNoExi;
	}
	public String getSaldoInterProvi() {
		return saldoInterProvi;
	}
	public void setSaldoInterProvi(String saldoInterProvi) {
		this.saldoInterProvi = saldoInterProvi;
	}
	public String getTotalComisi() {
		return totalComisi;
	}
	public void setTotalComisi(String totalComisi) {
		this.totalComisi = totalComisi;
	}
	public String getTotalIVACom() {
		return totalIVACom;
	}
	public void setTotalIVACom(String totalIVACom) {
		this.totalIVACom = totalIVACom;
	}
	public String getTotalCapital() {
		return totalCapital;
	}
	public void setTotalCapital(String totalCapital) {
		this.totalCapital = totalCapital;
	}
	public String getSaldoIntNoConta() {
		return saldoIntNoConta;
	}
	public void setSaldoIntNoConta(String saldoIntNoConta) {
		this.saldoIntNoConta = saldoIntNoConta;
	}
	public String getTotalInteres() {
		return totalInteres;
	}
	public void setTotalInteres(String totalInteres) {
		this.totalInteres = totalInteres;
	}
	public String getLineaCreditoID() {
		return lineaCreditoID;
	}
	public void setLineaCreditoID(String lineaCreditoID) {
		this.lineaCreditoID = lineaCreditoID;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getGarantiaLiquida() {
		return garantiaLiquida;
	}
	public void setGarantiaLiquida(String garantiaLiquida) {
		this.garantiaLiquida = garantiaLiquida;
	}
	public String getCuentaCompleta() {
		return cuentaCompleta;
	}
	public void setCuentaCompleta(String cuentaCompleta) {
		this.cuentaCompleta = cuentaCompleta;
	}
	public String getSaldo() {
		return saldo;
	}
	public void setSaldo(String saldo) {
		this.saldo = saldo;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getMontoTotCredSinIVA() {
		return montoTotCredSinIVA;
	}
	public void setMontoTotCredSinIVA(String montoTotCredSinIVA) {
		this.montoTotCredSinIVA = montoTotCredSinIVA;
	}
	public String getEstatusGarantia() {
		return estatusGarantia;
	}
	public void setEstatusGarantia(String estatusGarantia) {
		this.estatusGarantia = estatusGarantia;
	}
	public String getPorcentajeGtia() {
		return porcentajeGtia;
	}
	public void setPorcentajeGtia(String porcentajeGtia) {
		this.porcentajeGtia = porcentajeGtia;
	}
	public String getGarantiaAplicar() {
		return garantiaAplicar;
	}
	public void setGarantiaAplicar(String garantiaAplicar) {
		this.garantiaAplicar = garantiaAplicar;
	}
	public String getProgramaEsp() {
		return programaEsp;
	}
	public void setProgramaEsp(String programaEsp) {
		this.programaEsp = programaEsp;
	}
	public String getProgEspecial() {
		return progEspecial;
	}
	public void setProgEspecial(String progEspecial) {
		this.progEspecial = progEspecial;
	}
	public String getExisteGtia() {
		return existeGtia;
	}
	public void setExisteGtia(String existeGtia) {
		this.existeGtia = existeGtia;
	}
	public String getCreditoContFondeador() {
		return creditoContFondeador;
	}
	public void setCreditoContFondeador(String creditoContFondeador) {
		this.creditoContFondeador = creditoContFondeador;
	}
	public String getObservacion() {
		return observacion;
	}
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getTipoCredito() {
		return tipoCredito;
	}
	public void setTipoCredito(String tipoCredito) {
		this.tipoCredito = tipoCredito;
	}
	public String getCreditoActivo() {
		return creditoActivo;
	}
	public void setCreditoActivo(String creditoActivo) {
		this.creditoActivo = creditoActivo;
	}
	public String getCreditoPasivo() {
		return creditoPasivo;
	}
	public void setCreditoPasivo(String creditoPasivo) {
		this.creditoPasivo = creditoPasivo;
	}
	public String getCreditoContigente() {
		return creditoContigente;
	}
	public void setCreditoContigente(String creditoContigente) {
		this.creditoContigente = creditoContigente;
	}
	public String getCreditoFondeador() {
		return creditoFondeador;
	}
	public void setCreditoFondeador(String creditoFondeador) {
		this.creditoFondeador = creditoFondeador;
	}
	public String getCreditoPasivoContigente() {
		return creditoPasivoContigente;
	}
	public void setCreditoPasivoContigente(String creditoPasivoContigente) {
		this.creditoPasivoContigente = creditoPasivoContigente;
	}
	public String getFuenteFondeo() {
		return fuenteFondeo;
	}
	public void setFuenteFondeo(String fuenteFondeo) {
		this.fuenteFondeo = fuenteFondeo;
	}
	public String getCausaPago() {
		return causaPago;
	}
	public void setCausaPago(String causaPago) {
		this.causaPago = causaPago;
	}
	public String getCadenaProductiva() {
		return cadenaProductiva;
	}
	public void setCadenaProductiva(String cadenaProductiva) {
		this.cadenaProductiva = cadenaProductiva;
	}
	public String getMontoGarantia() {
		return montoGarantia;
	}
	public void setMontoGarantia(String montoGarantia) {
		this.montoGarantia = montoGarantia;
	}
	public String getFechaGarantia() {
		return fechaGarantia;
	}
	public void setFechaGarantia(String fechaGarantia) {
		this.fechaGarantia = fechaGarantia;
	}
	public String getFechaRecuperacion() {
		return fechaRecuperacion;
	}
	public void setFechaRecuperacion(String fechaRecuperacion) {
		this.fechaRecuperacion = fechaRecuperacion;
	}
	public String getSaldoCapital() {
		return saldoCapital;
	}
	public void setSaldoCapital(String saldoCapital) {
		this.saldoCapital = saldoCapital;
	}
	public String getSaldoInteres() {
		return saldoInteres;
	}
	public void setSaldoInteres(String saldoInteres) {
		this.saldoInteres = saldoInteres;
	}
	public String getMontoTotalCapitalRecuperado() {
		return montoTotalCapitalRecuperado;
	}
	public void setMontoTotalCapitalRecuperado(String montoTotalCapitalRecuperado) {
		this.montoTotalCapitalRecuperado = montoTotalCapitalRecuperado;
	}
	public String getMontoTotalInteresRecuperado() {
		return montoTotalInteresRecuperado;
	}
	public void setMontoTotalInteresRecuperado(String montoTotalInteresRecuperado) {
		this.montoTotalInteresRecuperado = montoTotalInteresRecuperado;
	}
	public String getMontoPendienteCapitalRecuperado() {
		return montoPendienteCapitalRecuperado;
	}
	public void setMontoPendienteCapitalRecuperado(
			String montoPendienteCapitalRecuperado) {
		this.montoPendienteCapitalRecuperado = montoPendienteCapitalRecuperado;
	}
	public String getMontoPendienteInteresRecuperado() {
		return montoPendienteInteresRecuperado;
	}
	public void setMontoPendienteInteresRecuperado(
			String montoPendienteInteresRecuperado) {
		this.montoPendienteInteresRecuperado = montoPendienteInteresRecuperado;
	}
	public String getSaldoIncobrable() {
		return saldoIncobrable;
	}
	public void setSaldoIncobrable(String saldoIncobrable) {
		this.saldoIncobrable = saldoIncobrable;
	}
	public String getTotalRecuperado() {
		return totalRecuperado;
	}
	public void setTotalRecuperado(String totalRecuperado) {
		this.totalRecuperado = totalRecuperado;
	}
	public String getAntiguedad() {
		return antiguedad;
	}
	public void setAntiguedad(String antiguedad) {
		this.antiguedad = antiguedad;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getNombreProductoCredito() {
		return nombreProductoCredito;
	}
	public void setNombreProductoCredito(String nombreProductoCredito) {
		this.nombreProductoCredito = nombreProductoCredito;
	}
	public String getTipoGarantia() {
		return tipoGarantia;
	}
	public void setTipoGarantia(String tipoGarantia) {
		this.tipoGarantia = tipoGarantia;
	}
	public String getRangoFechas() {
		return rangoFechas;
	}
	public void setRangoFechas(String rangoFechas) {
		this.rangoFechas = rangoFechas;
	}
	public String getUsuarioReporte() {
		return usuarioReporte;
	}
	public void setUsuarioReporte(String usuarioReporte) {
		this.usuarioReporte = usuarioReporte;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getFechaAfectacion() {
		return fechaAfectacion;
	}
	public void setFechaAfectacion(String fechaAfectacion) {
		this.fechaAfectacion = fechaAfectacion;
	}
	public String getAcreditadoIDFIRA() {
		return acreditadoIDFIRA;
	}
	public void setAcreditadoIDFIRA(String acreditadoIDFIRA) {
		this.acreditadoIDFIRA = acreditadoIDFIRA;
	}
	public String getCreditoIDFIRA() {
		return creditoIDFIRA;
	}
	public void setCreditoIDFIRA(String creditoIDFIRA) {
		this.creditoIDFIRA = creditoIDFIRA;
	}	
}
