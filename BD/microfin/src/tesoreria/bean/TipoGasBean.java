package tesoreria.bean;

import general.bean.BaseBean;

public class TipoGasBean extends BaseBean{
	private String tipoGastoID;
	private String descripcion;
	private String cuentaCompleta;
    private String cajaChica;
    
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	private String representaActivo;
	private String tipoActivoID;
	private String estatus;
	
	
	public String getTipoGastoID() {
		return tipoGastoID;
	}
	public void setTipoGastoID(String tipoGastoID) {
		this.tipoGastoID = tipoGastoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
	public String getCuentaCompleta() {
		return cuentaCompleta;
	}
	public void setCuentaCompleta(String cuentaCompleta) {
		this.cuentaCompleta = cuentaCompleta;
	}
	public String getCajaChica() {
		return cajaChica;
	}
	public void setCajaChica(String cajaChica) {
		this.cajaChica = cajaChica;
	}
	public String getRepresentaActivo() {
		return representaActivo;
	}
	public String getTipoActivoID() {
		return tipoActivoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setRepresentaActivo(String representaActivo) {
		this.representaActivo = representaActivo;
	}
	public void setTipoActivoID(String tipoActivoID) {
		this.tipoActivoID = tipoActivoID;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
 
	
}