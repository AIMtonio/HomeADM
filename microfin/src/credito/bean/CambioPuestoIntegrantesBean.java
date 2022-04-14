package credito.bean;

import java.util.List;

import general.bean.BaseBean;

public class CambioPuestoIntegrantesBean extends BaseBean{
	private String grupoID;
	private String ciclo;
	private String fechaRegistro;
	private String producCreditoID;
	private String estatus;
	
	private String solicitudCreditoID;
	private String productoCreditoID;
	private String prospectoID;
	private String clienteID;
	private String nombre;
	private String montoSol;
	private String montoAutoriza;
	private String fechaInicio;
	private String fechaVencimiento;
	private String estatusSol;
	private String credito;
	private String estatusCredito;
	private String cargo;
	private String pagareImpreso;
	private String montoCredito;

	
	private List lcargo;
	private List lsolicitudCreditoID;
	
	
	/* Getter y Setter */
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getCiclo() {
		return ciclo;
	}
	public void setCiclo(String ciclo) {
		this.ciclo = ciclo;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}

	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getMontoSol() {
		return montoSol;
	}
	public void setMontoSol(String montoSol) {
		this.montoSol = montoSol;
	}
	public String getMontoAutoriza() {
		return montoAutoriza;
	}
	public void setMontoAutoriza(String montoAutoriza) {
		this.montoAutoriza = montoAutoriza;
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
	public String getEstatusSol() {
		return estatusSol;
	}
	public void setEstatusSol(String estatusSol) {
		this.estatusSol = estatusSol;
	}
	public String getCredito() {
		return credito;
	}
	public void setCredito(String credito) {
		this.credito = credito;
	}
	public String getEstatusCredito() {
		return estatusCredito;
	}
	public void setEstatusCredito(String estatusCredito) {
		this.estatusCredito = estatusCredito;
	}
	public String getCargo() {
		return cargo;
	}
	public void setCargo(String cargo) {
		this.cargo = cargo;
	}
	public List getLcargo() {
		return lcargo;
	}
	public void setLcargo(List lcargo) {
		this.lcargo = lcargo;
	}
	public List getLsolicitudCreditoID() {
		return lsolicitudCreditoID;
	}
	public void setLsolicitudCreditoID(List lsolicitudCreditoID) {
		this.lsolicitudCreditoID = lsolicitudCreditoID;
	}
	public String getPagareImpreso() {
		return pagareImpreso;
	}
	public void setPagareImpreso(String pagareImpreso) {
		this.pagareImpreso = pagareImpreso;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	
}
