package credito.bean;

import general.bean.BaseBean;

public class CreditoDocEntBean extends BaseBean{
	private String 	creditoID;	

	private String	productoCreditoID;
	
	private String clasificaTipDocID;		
	private String clasificaDesc;//comprobante de domicicio
	private String docAceptado; // si el documento ya fue recibido
	private String tipoDocumentoID;
	private String descripcion;// Recibo de luz
	private String comentarios;		
	
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
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public String getClasificaTipDocID() {
		return clasificaTipDocID;
	}
	public String getClasificaDesc() {
		return clasificaDesc;
	}
	
	public String getTipoDocumentoID() {
		return tipoDocumentoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getComentarios() {
		return comentarios;
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
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public void setClasificaTipDocID(String clasificaTipDocID) {
		this.clasificaTipDocID = clasificaTipDocID;
	}
	public void setClasificaDesc(String clasificaDesc) {
		this.clasificaDesc = clasificaDesc;
	}
	
	public void setTipoDocumentoID(String tipoDocumentoID) {
		this.tipoDocumentoID = tipoDocumentoID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
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
	
	
	public String getDocAceptado() {
		return docAceptado;
	}
	public void setDocAceptado(String docAceptado) {
		this.docAceptado = docAceptado;
	}
	
	
	
	

}
