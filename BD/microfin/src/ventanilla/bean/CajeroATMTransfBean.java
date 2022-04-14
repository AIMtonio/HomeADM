package ventanilla.bean;

import general.bean.BaseBean;

public class CajeroATMTransfBean extends BaseBean{
	
	public static String desTransACajeroATM		= "TRANS. EFECTIVO A CAJERO ATM";
	
	private String cajeroTransferID;
	private String cajeroOrigenID;
	private String cajeroDestinoID;
	private String fecha;
	private String cantidad;
	private String estatus;
	private String monedaID;
	
	private String denominacionID;
	private String cantidadDenom;
	private String sucursalID;
	private String referencia;
	private String polizaID;
	private String descripcionTransfer;
	private String usuarioID;
	private String claveUsuario;
	private String denominaciones;
	public String getCajeroTransferID() {
		return cajeroTransferID;
	}
	public String getCajeroOrigenID() {
		return cajeroOrigenID;
	}
	public String getCajeroDestinoID() {
		return cajeroDestinoID;
	}
	public String getFecha() {
		return fecha;
	}
	public String getCantidad() {
		return cantidad;
	}
	public String getEstatus() {
		return estatus;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setCajeroTransferID(String cajeroTransferID) {
		this.cajeroTransferID = cajeroTransferID;
	}
	public void setCajeroOrigenID(String cajeroOrigenID) {
		this.cajeroOrigenID = cajeroOrigenID;
	}
	public void setCajeroDestinoID(String cajeroDestinoID) {
		this.cajeroDestinoID = cajeroDestinoID;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getDenominacionID() {
		return denominacionID;
	}
	public String getCantidadDenom() {
		return cantidadDenom;
	}
	public void setDenominacionID(String denominacionID) {
		this.denominacionID = denominacionID;
	}
	public void setCantidadDenom(String cantidadDenom) {
		this.cantidadDenom = cantidadDenom;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getDescripcionTransfer() {
		return descripcionTransfer;
	}
	public void setDescripcionTransfer(String descripcionTransfer) {
		this.descripcionTransfer = descripcionTransfer;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getDenominaciones() {
		return denominaciones;
	}
	public void setDenominaciones(String denominaciones) {
		this.denominaciones = denominaciones;
	}
	
	

}
