package cliente.bean;

import general.bean.BaseBean;

public class ServiFunEntregadoBean  extends BaseBean{
	private String serviFunEntregadoID;
	private String 	serviFunFolioID;
	private String 	clienteID;
	private String 	nombreCompleto;
	private String  estatus;
	private String  cantidadEntregado;
	private String  nombreRecibePago;
	private String  tipoIdentiID;
	private String  folioIdentific;
	private String  fechaEntrega;
	private String  cajaID;
	private String  sucursalID;
	public String getServiFunEntregadoID() {
		return serviFunEntregadoID;
	}
	public void setServiFunEntregadoID(String serviFunEntregadoID) {
		this.serviFunEntregadoID = serviFunEntregadoID;
	}
	public String getServiFunFolioID() {
		return serviFunFolioID;
	}
	public void setServiFunFolioID(String serviFunFolioID) {
		this.serviFunFolioID = serviFunFolioID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCantidadEntregado() {
		return cantidadEntregado;
	}
	public void setCantidadEntregado(String cantidadEntregado) {
		this.cantidadEntregado = cantidadEntregado;
	}
	public String getNombreRecibePago() {
		return nombreRecibePago;
	}
	public void setNombreRecibePago(String nombreRecibePago) {
		this.nombreRecibePago = nombreRecibePago;
	}
	public String getTipoIdentiID() {
		return tipoIdentiID;
	}
	public void setTipoIdentiID(String tipoIdentiID) {
		this.tipoIdentiID = tipoIdentiID;
	}
	public String getFolioIdentific() {
		return folioIdentific;
	}
	public void setFolioIdentific(String folioIdentific) {
		this.folioIdentific = folioIdentific;
	}
	public String getFechaEntrega() {
		return fechaEntrega;
	}
	public void setFechaEntrega(String fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}
	public String getCajaID() {
		return cajaID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	
}