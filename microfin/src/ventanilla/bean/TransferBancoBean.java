package ventanilla.bean;

import general.bean.BaseBean;

public class TransferBancoBean extends BaseBean{
	private String transferBancoID;
	private String institucionID;
	private String numCtaInstit;
	private String sucursalID;
	private String cajaID;
	private String cantidad;
	private String estatus;
	private String fecha;
	private String monedaID;
	private String denominacionID;
	private String referencia;
	private String polizaID;
	private String cCostos;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private String denominaciones;
	
	public String getTransferBancoID() {
		return transferBancoID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public String getCajaID() {
		return cajaID;
	}
	public String getCantidad() {
		return cantidad;
	}
	public String getEstatus() {
		return estatus;
	}	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
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
	public void setTransferBancoID(String transferBancoID) {
		this.transferBancoID = transferBancoID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
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
	public String getMonedaID() {
		return monedaID;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getDenominacionID() {
		return denominacionID;
	}
	public void setDenominacionID(String denominacionID) {
		this.denominacionID = denominacionID;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getcCostos() {
		return cCostos;
	}
	public void setcCostos(String cCostos) {
		this.cCostos = cCostos;
	}
	public String getDenominaciones() {
		return denominaciones;
	}
	public void setDenominaciones(String denominaciones) {
		this.denominaciones = denominaciones;
	}
	
	
	
}
