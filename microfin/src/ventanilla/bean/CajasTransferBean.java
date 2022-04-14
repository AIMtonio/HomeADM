package ventanilla.bean;

import general.bean.BaseBean;

public class CajasTransferBean extends BaseBean{

	private String cajasTransferID;
	private String sucursalOrigen;
	private String sucursalDestino;
	private String fecha;
	private String denominacionID;
	private String cantidad;
	private String cajaOrigen;
	private String cajaDestino;
	private String estatus;
	private String monedaID;
	private String polizaID;
	//Variable para el combo de folios
	private String detalleFolios;
	private String referencia;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private String denominaciones;
	
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getCajasTransferID() {
		return cajasTransferID;
	}
	public void setCajasTransferID(String cajasTransferID) {
		this.cajasTransferID = cajasTransferID;
	}
	public String getSucursalOrigen() {
		return sucursalOrigen;
	}
	public void setSucursalOrigen(String sucursalOrigen) {
		this.sucursalOrigen = sucursalOrigen;
	}
	public String getSucursalDestino() {
		return sucursalDestino;
	}
	public void setSucursalDestino(String sucursalDestino) {
		this.sucursalDestino = sucursalDestino;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getDenominacionID() {
		return denominacionID;
	}
	public void setDenominacionID(String denominacionID) {
		this.denominacionID = denominacionID;
	}
	public String getCantidad() {
		return cantidad;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public String getCajaOrigen() {
		return cajaOrigen;
	}
	public void setCajaOrigen(String cajaOrigen) {
		this.cajaOrigen = cajaOrigen;
	}
	public String getCajaDestino() {
		return cajaDestino;
	}
	public void setCajaDestino(String cajaDestino) {
		this.cajaDestino = cajaDestino;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getDetalleFolios() {
		return detalleFolios;
	}
	public void setDetalleFolios(String detalleFolios) {
		this.detalleFolios = detalleFolios;
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
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getDenominaciones() {
		return denominaciones;
	}
	public void setDenominaciones(String denominaciones) {
		this.denominaciones = denominaciones;
	}
}
