package credito.bean;

import general.bean.BaseBean;

public class AutorizaObliSolidDetalleBean extends BaseBean{
	
	private String obligadoID;
	private String clienteID;
	private String prospectoID;
	private String nombre;
	private String estatusSolicitud;
	private String parentescoID;
	private String nombreParentesco;
	private String tiempoConocido;
	private String estatus;
	private String solicitudCreditoID;
	private String numOblAsign;
	
	public String getObligadoID() {
		return obligadoID;
	}
	public void setObligadoID(String avalID) {
		this.obligadoID = avalID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getEstatusSolicitud() {
		return estatusSolicitud;
	}
	public void setEstatusSolicitud(String estatusSolicitud) {
		this.estatusSolicitud = estatusSolicitud;
	}
	public String getParentescoID() {
		return parentescoID;
	}
	public void setParentescoID(String parentescoID) {
		this.parentescoID = parentescoID;
	}
	public String getNombreParentesco() {
		return nombreParentesco;
	}
	public void setNombreParentesco(String nombreParentesco) {
		this.nombreParentesco = nombreParentesco;
	}
	public String getTiempoConocido() {
		return tiempoConocido;
	}
	public void setTiempoConocido(String tiempoConocido) {
		this.tiempoConocido = tiempoConocido;
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
	public String getNumOblAsign() {
		return numOblAsign;
	}
	public void setNumOblAsign(String numOblAsign) {
		this.numOblAsign = numOblAsign;
	}

}
