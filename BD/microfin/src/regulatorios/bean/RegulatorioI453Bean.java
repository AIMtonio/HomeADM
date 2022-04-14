package regulatorios.bean;

import java.util.List;

import general.bean.BaseBean;

public class RegulatorioI453Bean extends BaseBean{
	
	//Bean Para realizar los Bloqueos o Desbloqueos
	 
	private String anio; 
	private String mes;
	private String periodo;
	private String claveEntidad;
	private String formulario;
	private String clienteID;
	private String tipoPersona;
	private String denominacion;
	private String apellidoPat;
	private String apellidoMat;
	private String rfc;	
	private String curp;
	private String genero;
	private String creditoID;
	private String claveSucursal;
	private String clasifConta;	
	private String productoCredito;
	private String fechaDisp;
	private String fechaVencim;
	private String tipoAmorti;
	private String montoCredito;
	private String fecUltPagoCap;
	private String monUltPagoCap;
	private String fecUltPagoInt;
	private String monUltPagoInt;
	private String fecPrimAtraso;
	private String numDiasAtraso;
	private String tipoCredito;
	private String salCapital;
	private String salIntOrdin;
	private String salIntMora;
	private String intereRefinan;
	private String saldoInsoluto;
	private String montoCastigo;
	private String montoCondona;
	private String montoBonifi;
	private String fechaCastigo;
	private String tipoRelacion;
	private String ePRCTotal;
	private String claveSIC;
	private String fecConsultaSIC;
	private String tipoCobranza;
	private String totGtiaLiquida;
	private String gtiaHipotecaria;
	private String valor;
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
	public String getFormulario() {
		return formulario;
	}
	public void setFormulario(String formulario) {
		this.formulario = formulario;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getDenominacion() {
		return denominacion;
	}
	public void setDenominacion(String denominacion) {
		this.denominacion = denominacion;
	}
	public String getApellidoPat() {
		return apellidoPat;
	}
	public void setApellidoPat(String apellidoPat) {
		this.apellidoPat = apellidoPat;
	}
	public String getApellidoMat() {
		return apellidoMat;
	}
	public void setApellidoMat(String apellidoMat) {
		this.apellidoMat = apellidoMat;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public String getCurp() {
		return curp;
	}
	public void setCurp(String curp) {
		this.curp = curp;
	}
	public String getGenero() {
		return genero;
	}
	public void setGenero(String genero) {
		this.genero = genero;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getClaveSucursal() {
		return claveSucursal;
	}
	public void setClaveSucursal(String claveSucursal) {
		this.claveSucursal = claveSucursal;
	}
	public String getClasifConta() {
		return clasifConta;
	}
	public void setClasifConta(String clasifConta) {
		this.clasifConta = clasifConta;
	}
	public String getProductoCredito() {
		return productoCredito;
	}
	public void setProductoCredito(String productoCredito) {
		this.productoCredito = productoCredito;
	}
	public String getFechaDisp() {
		return fechaDisp;
	}
	public void setFechaDisp(String fechaDisp) {
		this.fechaDisp = fechaDisp;
	}
	public String getFechaVencim() {
		return fechaVencim;
	}
	public void setFechaVencim(String fechaVencim) {
		this.fechaVencim = fechaVencim;
	}
	public String getTipoAmorti() {
		return tipoAmorti;
	}
	public void setTipoAmorti(String tipoAmorti) {
		this.tipoAmorti = tipoAmorti;
	}
	public String getFecUltPagoCap() {
		return fecUltPagoCap;
	}
	public void setFecUltPagoCap(String fecUltPagoCap) {
		this.fecUltPagoCap = fecUltPagoCap;
	}
	public String getMonUltPagoCap() {
		return monUltPagoCap;
	}
	public void setMonUltPagoCap(String monUltPagoCap) {
		this.monUltPagoCap = monUltPagoCap;
	}
	public String getFecUltPagoInt() {
		return fecUltPagoInt;
	}
	public void setFecUltPagoInt(String fecUltPagoInt) {
		this.fecUltPagoInt = fecUltPagoInt;
	}
	public String getMonUltPagoInt() {
		return monUltPagoInt;
	}
	public void setMonUltPagoInt(String monUltPagoInt) {
		this.monUltPagoInt = monUltPagoInt;
	}
	public String getFecPrimAtraso() {
		return fecPrimAtraso;
	}
	public void setFecPrimAtraso(String fecPrimAtraso) {
		this.fecPrimAtraso = fecPrimAtraso;
	}
	public String getNumDiasAtraso() {
		return numDiasAtraso;
	}
	public void setNumDiasAtraso(String numDiasAtraso) {
		this.numDiasAtraso = numDiasAtraso;
	}
	public String getTipoCredito() {
		return tipoCredito;
	}
	public void setTipoCredito(String tipoCredito) {
		this.tipoCredito = tipoCredito;
	}
	public String getSalCapital() {
		return salCapital;
	}
	public void setSalCapital(String salCapital) {
		this.salCapital = salCapital;
	}
	public String getSalIntOrdin() {
		return salIntOrdin;
	}
	public void setSalIntOrdin(String salIntOrdin) {
		this.salIntOrdin = salIntOrdin;
	}
	public String getSalIntMora() {
		return salIntMora;
	}
	public void setSalIntMora(String salIntMora) {
		this.salIntMora = salIntMora;
	}
	public String getIntereRefinan() {
		return intereRefinan;
	}
	public void setIntereRefinan(String intereRefinan) {
		this.intereRefinan = intereRefinan;
	}
	public String getSaldoInsoluto() {
		return saldoInsoluto;
	}
	public void setSaldoInsoluto(String saldoInsoluto) {
		this.saldoInsoluto = saldoInsoluto;
	}
	public String getMontoCastigo() {
		return montoCastigo;
	}
	public void setMontoCastigo(String montoCastigo) {
		this.montoCastigo = montoCastigo;
	}
	public String getMontoCondona() {
		return montoCondona;
	}
	public void setMontoCondona(String montoCondona) {
		this.montoCondona = montoCondona;
	}
	public String getMontoBonifi() {
		return montoBonifi;
	}
	public void setMontoBonifi(String montoBonifi) {
		this.montoBonifi = montoBonifi;
	}
	public String getFechaCastigo() {
		return fechaCastigo;
	}
	public void setFechaCastigo(String fechaCastigo) {
		this.fechaCastigo = fechaCastigo;
	}
	public String getTipoRelacion() {
		return tipoRelacion;
	}
	public void setTipoRelacion(String tipoRelacion) {
		this.tipoRelacion = tipoRelacion;
	}
	public String getePRCTotal() {
		return ePRCTotal;
	}
	public void setePRCTotal(String ePRCTotal) {
		this.ePRCTotal = ePRCTotal;
	}
	public String getClaveSIC() {
		return claveSIC;
	}
	public void setClaveSIC(String claveSIC) {
		this.claveSIC = claveSIC;
	}
	public String getFecConsultaSIC() {
		return fecConsultaSIC;
	}
	public void setFecConsultaSIC(String fecConsultaSIC) {
		this.fecConsultaSIC = fecConsultaSIC;
	}
	public String getTipoCobranza() {
		return tipoCobranza;
	}
	public void setTipoCobranza(String tipoCobranza) {
		this.tipoCobranza = tipoCobranza;
	}
	public String getTotGtiaLiquida() {
		return totGtiaLiquida;
	}
	public void setTotGtiaLiquida(String totGtiaLiquida) {
		this.totGtiaLiquida = totGtiaLiquida;
	}
	public String getGtiaHipotecaria() {
		return gtiaHipotecaria;
	}
	public void setGtiaHipotecaria(String gtiaHipotecaria) {
		this.gtiaHipotecaria = gtiaHipotecaria;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	

	

	
	
}
