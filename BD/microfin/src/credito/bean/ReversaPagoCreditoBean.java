package credito.bean;

import general.bean.BaseBean;

public class ReversaPagoCreditoBean extends BaseBean {
	
	private String creditoID;
	private String grupoID;
	private String motivoReversa;
	private String usuarioAutorizaID;
	private String contraseniaUsuarioAutoriza;
	private String cicloID;
	private String tranRespaldo;
	private String formaPago;
	
	// *****Auxiliares para ticket******//
	private String clienteID;
	private String pagCre;
	private String totalRev;
	private String garantiaAd;
	private String folio;
	private String nombreUsuario;
	private String nombreInstitucion;
	private String fechaEmision;
	
	
	//************Auditoria************//
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
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
	public String getTranRespaldo() {
		return tranRespaldo;
	}
	public void setTranRespaldo(String tranRespaldo) {
		this.tranRespaldo = tranRespaldo;
	}
	public String getFormaPago() {
		return formaPago;
	}
	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getPagCre() {
		return pagCre;
	}
	public void setPagCre(String pagCre) {
		this.pagCre = pagCre;
	}
	public String getTotalRev() {
		return totalRev;
	}
	public void setTotalRev(String totalRev) {
		this.totalRev = totalRev;
	}
	public String getGarantiaAd() {
		return garantiaAd;
	}
	public void setGarantiaAd(String garantiaAd) {
		this.garantiaAd = garantiaAd;
	}
	public String getFolio() {
		return folio;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	
	
}
