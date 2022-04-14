package tarjetas.bean;

import general.bean.BaseBean;
public class LineaTarjetaCreditoBean extends BaseBean{
	
	public static int LONGITUD_ID = 10;

	private String saldoDisponible	;
	private String saldoDeudor	;
	private String fechaAutoriza	;
	private String usuarioAutoriza	;
	private String tipoTarjetaID;
	private String descripcion;
	private String cuentaAhoID;
	private String nomCompleto;
	
	
	
	private String lineaTarCredID;
	private String clienteID;
	private String montoLinea;
	private String montoDisponible;
	private String montoBloqueado;
	private String saldoAFavor;
	private String saldoCapVigente;
	private String saldoCapVencido;
	private String saldoInteres;
	private String saldoIVAInteres;
	private String saldoMoratorios;
	private String saldoIVAMoratorios;
	private String salComFaltaPag;
	private String salIVAComFaltaPag;
	private String salOrtrasComis;
	private String salIVAOrtrasComis;
	private String montoBaseCal;
	private String saldoCorte;
	private String pagoNoGenInteres;
	private String pagoMinimo;
	private String saldoInicial;
	private String comprasPeriodo;
	private String retirosPeriodo;
	private String pagosPeriodo;
	private String CAT;
	private String tipoTarjetaDeb;
	private String productoCredID;
	private String tasaFija;
	private String tipoCorte;
	private String diaCorte;
	private String tipoPago;
	private String diaPago;
	private String cobraMora;
	private String tipoCobMora;
	private String factorMora;
	private String tipoPagMin;
	private String factorPagMin;
	private String estatus;
	private String fechaRegistro;
	private String fechaActivacion;
	private String fechaCancelacion;
	private String relacion;
	private String tarjetaCredID;
	private String cuentaClabe;
	private String fechaProxCorte;
	
	
	
	
	
	public String getLineaTarCredID() {
		return lineaTarCredID;
	}
	public void setLineaTarCredID(String lineaTarCredID) {
		this.lineaTarCredID = lineaTarCredID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getMontoLinea() {
		return montoLinea;
	}
	public void setMontoLinea(String montoLinea) {
		this.montoLinea = montoLinea;
	}
	public String getSaldoDisponible() {
		return saldoDisponible;
	}
	public void setSaldoDisponible(String saldoDisponible) {
		this.saldoDisponible = saldoDisponible;
	}
	public String getSaldoDeudor() {
		return saldoDeudor;
	}
	public void setSaldoDeudor(String saldoDeudor) {
		this.saldoDeudor = saldoDeudor;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getTipoTarjetaID() {
		return tipoTarjetaID;
	}
	public void setTipoTarjetaID(String tipoTarjetaID) {
		this.tipoTarjetaID = tipoTarjetaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getNomCompleto() {
		return nomCompleto;
	}
	public void setNomCompleto(String nomCompleto) {
		this.nomCompleto = nomCompleto;
	}
	public String getMontoDisponible() {
		return montoDisponible;
	}
	public String getMontoBloqueado() {
		return montoBloqueado;
	}
	public String getSaldoAFavor() {
		return saldoAFavor;
	}
	public String getSaldoCapVigente() {
		return saldoCapVigente;
	}
	public String getSaldoCapVencido() {
		return saldoCapVencido;
	}
	public String getSaldoInteres() {
		return saldoInteres;
	}
	public String getSaldoIVAInteres() {
		return saldoIVAInteres;
	}
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public String getSaldoIVAMoratorios() {
		return saldoIVAMoratorios;
	}
	public String getSalComFaltaPag() {
		return salComFaltaPag;
	}
	public String getSalIVAComFaltaPag() {
		return salIVAComFaltaPag;
	}
	public String getSalOrtrasComis() {
		return salOrtrasComis;
	}
	public String getSalIVAOrtrasComis() {
		return salIVAOrtrasComis;
	}
	public String getMontoBaseCal() {
		return montoBaseCal;
	}
	public String getSaldoCorte() {
		return saldoCorte;
	}
	public String getPagoNoGenInteres() {
		return pagoNoGenInteres;
	}
	public String getPagoMinimo() {
		return pagoMinimo;
	}
	public String getSaldoInicial() {
		return saldoInicial;
	}
	public String getComprasPeriodo() {
		return comprasPeriodo;
	}
	public String getRetirosPeriodo() {
		return retirosPeriodo;
	}
	public String getPagosPeriodo() {
		return pagosPeriodo;
	}
	public String getCAT() {
		return CAT;
	}
	public String getTipoTarjetaDeb() {
		return tipoTarjetaDeb;
	}
	public String getProductoCredID() {
		return productoCredID;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public String getTipoCorte() {
		return tipoCorte;
	}
	public String getDiaCorte() {
		return diaCorte;
	}
	public String getTipoPago() {
		return tipoPago;
	}
	public String getDiaPago() {
		return diaPago;
	}
	public String getCobraMora() {
		return cobraMora;
	}
	public String getTipoCobMora() {
		return tipoCobMora;
	}
	public String getFactorMora() {
		return factorMora;
	}
	public String getTipoPagMin() {
		return tipoPagMin;
	}
	public String getFactorPagMin() {
		return factorPagMin;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public String getFechaActivacion() {
		return fechaActivacion;
	}
	public String getFechaCancelacion() {
		return fechaCancelacion;
	}
	public void setMontoDisponible(String montoDisponible) {
		this.montoDisponible = montoDisponible;
	}
	public void setMontoBloqueado(String montoBloqueado) {
		this.montoBloqueado = montoBloqueado;
	}
	public void setSaldoAFavor(String saldoAFavor) {
		this.saldoAFavor = saldoAFavor;
	}
	public void setSaldoCapVigente(String saldoCapVigente) {
		this.saldoCapVigente = saldoCapVigente;
	}
	public void setSaldoCapVencido(String saldoCapVencido) {
		this.saldoCapVencido = saldoCapVencido;
	}
	public void setSaldoInteres(String saldoInteres) {
		this.saldoInteres = saldoInteres;
	}
	public void setSaldoIVAInteres(String saldoIVAInteres) {
		this.saldoIVAInteres = saldoIVAInteres;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public void setSaldoIVAMoratorios(String saldoIVAMoratorios) {
		this.saldoIVAMoratorios = saldoIVAMoratorios;
	}
	public void setSalComFaltaPag(String salComFaltaPag) {
		this.salComFaltaPag = salComFaltaPag;
	}
	public void setSalIVAComFaltaPag(String salIVAComFaltaPag) {
		this.salIVAComFaltaPag = salIVAComFaltaPag;
	}
	public void setSalOrtrasComis(String salOrtrasComis) {
		this.salOrtrasComis = salOrtrasComis;
	}
	public void setSalIVAOrtrasComis(String salIVAOrtrasComis) {
		this.salIVAOrtrasComis = salIVAOrtrasComis;
	}
	public void setMontoBaseCal(String montoBaseCal) {
		this.montoBaseCal = montoBaseCal;
	}
	public void setSaldoCorte(String saldoCorte) {
		this.saldoCorte = saldoCorte;
	}
	public void setPagoNoGenInteres(String pagoNoGenInteres) {
		this.pagoNoGenInteres = pagoNoGenInteres;
	}
	public void setPagoMinimo(String pagoMinimo) {
		this.pagoMinimo = pagoMinimo;
	}
	public void setSaldoInicial(String saldoInicial) {
		this.saldoInicial = saldoInicial;
	}
	public void setComprasPeriodo(String comprasPeriodo) {
		this.comprasPeriodo = comprasPeriodo;
	}
	public void setRetirosPeriodo(String retirosPeriodo) {
		this.retirosPeriodo = retirosPeriodo;
	}
	public void setPagosPeriodo(String pagosPeriodo) {
		this.pagosPeriodo = pagosPeriodo;
	}
	public void setCAT(String cAT) {
		CAT = cAT;
	}
	public void setTipoTarjetaDeb(String tipoTarjetaDeb) {
		this.tipoTarjetaDeb = tipoTarjetaDeb;
	}
	public void setProductoCredID(String productoCredID) {
		this.productoCredID = productoCredID;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public void setTipoCorte(String tipoCorte) {
		this.tipoCorte = tipoCorte;
	}
	public void setDiaCorte(String diaCorte) {
		this.diaCorte = diaCorte;
	}
	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}
	public void setDiaPago(String diaPago) {
		this.diaPago = diaPago;
	}
	public void setCobraMora(String cobraMora) {
		this.cobraMora = cobraMora;
	}
	public void setTipoCobMora(String tipoCobMora) {
		this.tipoCobMora = tipoCobMora;
	}
	public void setFactorMora(String factorMora) {
		this.factorMora = factorMora;
	}
	public void setTipoPagMin(String tipoPagMin) {
		this.tipoPagMin = tipoPagMin;
	}
	public void setFactorPagMin(String factorPagMin) {
		this.factorPagMin = factorPagMin;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public void setFechaActivacion(String fechaActivacion) {
		this.fechaActivacion = fechaActivacion;
	}
	public void setFechaCancelacion(String fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}
	public String getRelacion() {
		return relacion;
	}
	public void setRelacion(String relacion) {
		this.relacion = relacion;
	}
	public String getTarjetaCredID() {
		return tarjetaCredID;
	}
	public void setTarjetaCredID(String tarjetaCredID) {
		this.tarjetaCredID = tarjetaCredID;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getFechaProxCorte() {
		return fechaProxCorte;
	}
	public void setFechaProxCorte(String fechaProxCorte) {
		this.fechaProxCorte = fechaProxCorte;
	}
	
	
	
	
	


	
}