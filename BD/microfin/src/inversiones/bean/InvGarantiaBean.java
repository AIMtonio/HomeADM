package inversiones.bean;

import java.util.List;

import general.bean.BaseBean;

public class InvGarantiaBean extends BaseBean {
	/* atributos */
	private String creditoInvGarID;
	private String creditoID;
	private String inversionID;
	private String montoEnGar;
	private String fechaAsignaGar;
		
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	/*Auxiliares para grid*/
	private List listaCreditoInvGarID;
	private List listaCheckLiberar;
	
	/* Auxiliares */
	private String creditosRelacionados;
	private String estCreAltInvGar;
	private String checkLiberar;
	private String polizaID;
	private String fechaOperacion;
	private String totalGarCredInv;
	private String totalGarInv;
	private String montoInversion;
	private String clienteID;
	private String estatusDes;
	private String nombreCliente;
	private String tasa;
	private String fechaInicio;
	private String fechaVencimiento;
	private String interesRecibir;
	private String montoGarLiq; // auxiliar a la consulta de monto d egarantia liquida
	private String etiqueta;
	private String montoCredito;
	private String diasAtraso;
	private String porcGarLiq;
	private String estatus;
	private String productoCreditoDes;
	public static String inversionGarantia	= "17";				//Concepto Contable de Reclasificacion de Inversion CONCEPTOSCONTA
	public static String desInversionGarantia = "CAPITAL";     //Descripcion Concepto Contable de Inversion: Capital 
	public static String desLiberacionGarantia = "LIBERACION ANTICIPADA INVERSION EN GARANTIA";  //Descripcion liberacion inversion garantia    
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getInversionID() {
		return inversionID;
	}
	public void setInversionID(String inversionID) {
		this.inversionID = inversionID;
	}
	public String getMontoEnGar() {
		return montoEnGar;
	}
	public void setMontoEnGar(String montoEnGar) {
		this.montoEnGar = montoEnGar;
	}
	public String getFechaAsignaGar() {
		return fechaAsignaGar;
	}
	public void setFechaAsignaGar(String fechaAsignaGar) {
		this.fechaAsignaGar = fechaAsignaGar;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
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
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getInteresRecibir() {
		return interesRecibir;
	}
	public void setInteresRecibir(String interesRecibir) {
		this.interesRecibir = interesRecibir;
	}
	public String getMontoGarLiq() {
		return montoGarLiq;
	}
	public void setMontoGarLiq(String montoGarLiq) {
		this.montoGarLiq = montoGarLiq;
	}
	public String getMontoInversion() {
		return montoInversion;
	}
	public void setMontoInversion(String montoInversion) {
		this.montoInversion = montoInversion;
	}
	public String getEtiqueta() {
		return etiqueta;
	}
	public void setEtiqueta(String etiqueta) {
		this.etiqueta = etiqueta;
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
	public String getTotalGarCredInv() {
		return totalGarCredInv;
	}
	public void setTotalGarCredInv(String totalGarCredInv) {
		this.totalGarCredInv = totalGarCredInv;
	}
	public String getTotalGarInv() {
		return totalGarInv;
	}
	public void setTotalGarInv(String totalGarInv) {
		this.totalGarInv = totalGarInv;
	}
	public String getCreditoInvGarID() {
		return creditoInvGarID;
	}
	public void setCreditoInvGarID(String creditoInvGarID) {
		this.creditoInvGarID = creditoInvGarID;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public String getPorcGarLiq() {
		return porcGarLiq;
	}
	public void setPorcGarLiq(String porcGarLiq) {
		this.porcGarLiq = porcGarLiq;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public List getListaCreditoInvGarID() {
		return listaCreditoInvGarID;
	}
	public void setListaCreditoInvGarID(List listaCreditoInvGarID) {
		this.listaCreditoInvGarID = listaCreditoInvGarID;
	}
	public String getProductoCreditoDes() {
		return productoCreditoDes;
	}
	public void setProductoCreditoDes(String productoCreditoDes) {
		this.productoCreditoDes = productoCreditoDes;
	}
	public String getEstatusDes() {
		return estatusDes;
	}
	public void setEstatusDes(String estatusDes) {
		this.estatusDes = estatusDes;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public List getListaCheckLiberar() {
		return listaCheckLiberar;
	}
	public void setListaCheckLiberar(List listaCheckLiberar) {
		this.listaCheckLiberar = listaCheckLiberar;
	}
	public String getCheckLiberar() {
		return checkLiberar;
	}
	public void setCheckLiberar(String checkLiberar) {
		this.checkLiberar = checkLiberar;
	}
	public String getEstCreAltInvGar() {
		return estCreAltInvGar;
	}
	public void setEstCreAltInvGar(String estCreAltInvGar) {
		this.estCreAltInvGar = estCreAltInvGar;
	}
	public String getCreditosRelacionados() {
		return creditosRelacionados;
	}
	public void setCreditosRelacionados(String creditosRelacionados) {
		this.creditosRelacionados = creditosRelacionados;
	}
	
}