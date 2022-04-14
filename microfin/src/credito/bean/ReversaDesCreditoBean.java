package credito.bean;

import general.bean.BaseBean;

public class ReversaDesCreditoBean extends BaseBean {
	private String creditoID;
	private String grupoID;
	private String motivoReversa;
	private String usuarioAutorizaID;
	private String contraseniaUsuarioAutoriza;
	private String cicloID;
	private String producCreditoID;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	private String polizaID;
	public static String reversaDesembolso	= "58";				//Concepto Contable Reserva Desembolso (CONCEPTOSCONTA)
	public static String desReversaDesembolso = "REVERSA DESEMBOLSO DE CREDITO"; 
	
	public String getCreditoID() {
		return creditoID;
	}
	public String getUsuarioAutorizaID() {
		return usuarioAutorizaID;
	}
	public String getContraseniaUsuarioAutoriza() {
		return contraseniaUsuarioAutoriza;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public void setUsuarioAutorizaID(String usuarioAutorizaID) {
		this.usuarioAutorizaID = usuarioAutorizaID;
	}
	public void setContraseniaUsuarioAutoriza(String contraseniaUsuarioAutoriza) {
		this.contraseniaUsuarioAutoriza = contraseniaUsuarioAutoriza;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public String getMotivoReversa() {
		return motivoReversa;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public void setMotivoReversa(String motivoReversa) {
		this.motivoReversa = motivoReversa;
	}
	public String getCicloID() {
		return cicloID;
	}
	public void setCicloID(String cicloID) {
		this.cicloID = cicloID;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
}
