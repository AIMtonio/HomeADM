package originacion.bean;

import general.bean.BaseBean;

public class OrganoAutorizaBean extends BaseBean {

	//Atributos o Variables
	private String productoCreditoID;
	private String esquemaID;
	private String numeroFirma;	
	private String organoID;	
	

	
	//se ocupan para comparación en el store de modificación
	private String esquemas;
	private String numeroFirmas;	
	private String organosID;	
	//Datos del Organo de Decision
	private String descripcionOrgano;

	//Auxiliar en grid de firmas para autorizar 
	private String solicitudCreditoID;
	
	//Parametros Auditoria
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
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
	public String getNumeroFirma() {
		return numeroFirma;
	}
	public void setNumeroFirma(String numeroFirma) {
		this.numeroFirma = numeroFirma;
	}
	public String getOrganoID() {
		return organoID;
	}
	public void setOrganoID(String organoID) {
		this.organoID = organoID;
	}
	
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	
	public String getDescripcionOrgano() {
		return descripcionOrgano;
	}
	public void setDescripcionOrgano(String descripcionOrgano) {
		this.descripcionOrgano = descripcionOrgano;
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
	public String getEsquemas() {
		return esquemas;
	}
	public void setEsquemas(String esquemas) {
		this.esquemas = esquemas;
	}
	public String getNumeroFirmas() {
		return numeroFirmas;
	}
	public void setNumeroFirmas(String numeroFirmas) {
		this.numeroFirmas = numeroFirmas;
	}
	public String getOrganosID() {
		return organosID;
	}
	public void setOrganosID(String organosID) {
		this.organosID = organosID;
	}
}
