package cuentas.bean;

import general.bean.BaseBean;

public class FoliosPlanAhorroBean extends BaseBean {

	private String folioID;
	private String clienteID;
	private String planID;
	private String serie;
	private String monto;
	private String fecha;
	private String estatus;
	private String fechaCancela;
	private String usuarioCancela;
	
	private String nombreCliente;
	private String cuentaID;
	private String descCuenta;
	private String fechaMeta;
	private String saldoActual;
	private String nombrePlan;
	private String montoDep;
	
	private String sucursal;
	private String numTrans;
	
	public String getFolioID() {
		return folioID;
	}
	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getPlanID() {
		return planID;
	}
	public void setPlanID(String planID) {
		this.planID = planID;
	}
	public String getSerie() {
		return serie;
	}
	public void setSerie(String serie) {
		this.serie = serie;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getFechaCancela() {
		return fechaCancela;
	}
	public void setFechaCancela(String fechaCancela) {
		this.fechaCancela = fechaCancela;
	}
	public String getUsuarioCancela() {
		return usuarioCancela;
	}
	public void setUsuarioCancela(String usuarioCancela) {
		this.usuarioCancela = usuarioCancela;
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
	public void setCuentaID(String cuenta) {
		this.cuentaID = cuenta;
	}
	public String getDescCuenta() {
		return descCuenta;
	}
	public void setDescCuenta(String descCuenta) {
		this.descCuenta = descCuenta;
	}
	public String getFechaMeta() {
		return fechaMeta;
	}
	public void setFechaMeta(String fechaMeta) {
		this.fechaMeta = fechaMeta;
	}
	public String getSaldoActual() {
		return saldoActual;
	}
	public void setSaldoActual(String saldoActual) {
		this.saldoActual = saldoActual;
	}
	public String getNombrePlan() {
		return nombrePlan;
	}
	public void setNombrePlan(String nombrePlan) {
		this.nombrePlan = nombrePlan;
	}
	public String getMontoDep() {
		return montoDep;
	}
	public void setMontoDep(String montoDep) {
		this.montoDep = montoDep;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTrans() {
		return numTrans;
	}
	public void setNumTrans(String numTrans) {
		this.numTrans = numTrans;
	}
}
