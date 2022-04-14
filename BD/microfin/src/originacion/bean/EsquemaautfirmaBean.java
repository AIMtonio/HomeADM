package originacion.bean;

import general.bean.BaseBean;


public class EsquemaautfirmaBean extends BaseBean {
	
	private String solicitudCreditoID;
	private String esquemaID;
	private String numFirma;
	private String organoID;
	private String usuarioFirma;
	private String fechaFirma;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	// auxiliares alta de esquema de firmas
	private String montoAutor;
	private String aportCliente;
	private String comentarioMesaControl;
	private	String descripcionOrgano;
	private	String grupoID;
	private	String solicitudes;
	
	
	
	
	public String getDescripcionOrgano() {
		return descripcionOrgano;
	}
	public void setDescripcionOrgano(String descripcionOrgano) {
		this.descripcionOrgano = descripcionOrgano;
	}
	public String getComentarioMesaControl() {
		return comentarioMesaControl;
	}
	public void setComentarioMesaControl(String comentarioMesaControl) {
		this.comentarioMesaControl = comentarioMesaControl;
	}
	public String getMontoAutor() {
		return montoAutor;
	}
	public void setMontoAutor(String montoAutor) {
		this.montoAutor = montoAutor;
	}
	public String getAportCliente() {
		return aportCliente;
	}
	public void setAportCliente(String aportCliente) {
		this.aportCliente = aportCliente;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getEsquemaID() {
		return esquemaID;
	}
	public void setEsquemaID(String esquemaID) {
		this.esquemaID = esquemaID;
	}
	public String getNumFirma() {
		return numFirma;
	}
	public void setNumFirma(String numFirma) {
		this.numFirma = numFirma;
	}
	public String getOrganoID() {
		return organoID;
	}
	public void setOrganoID(String organoID) {
		this.organoID = organoID;
	}
	public String getUsuarioFirma() {
		return usuarioFirma;
	}
	public void setUsuarioFirma(String usuarioFirma) {
		this.usuarioFirma = usuarioFirma;
	}
	public String getFechaFirma() {
		return fechaFirma;
	}
	public void setFechaFirma(String fechaFirma) {
		this.fechaFirma = fechaFirma;
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
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getSolicitudes() {
		return solicitudes;
	}
	public void setSolicitudes(String solicitudes) {
		this.solicitudes = solicitudes;
	}

}
