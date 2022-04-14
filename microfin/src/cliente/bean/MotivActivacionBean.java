package cliente.bean;

import general.bean.BaseBean;

public class MotivActivacionBean extends BaseBean{
	
	private String motivoActivaID;
	private String tipoMovimiento;
	private String descripcion;
	private String permiteReactivacion; // atributo para saber si permite la reactivacion deun cliente
	private String requiereCobro; // atributo para saber si requiere cobro la reactivacion  del cliente
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programa;
	private String sucursal;
	private String numTransaccion;
	public String getMotivoActivaID() {
		return motivoActivaID;
	}
	public void setMotivoActivaID(String motivoActivaID) {
		this.motivoActivaID = motivoActivaID;
	}
	public String getTipoMovimiento() {
		return tipoMovimiento;
	}
	public void setTipoMovimiento(String tipoMovimiento) {
		this.tipoMovimiento = tipoMovimiento;
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
	public String getPrograma() {
		return programa;
	}
	public void setPrograma(String programa) {
		this.programa = programa;
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
	public String getPermiteReactivacion() {
		return permiteReactivacion;
	}
	public void setPermiteReactivacion(String permiteReactivacion) {
		this.permiteReactivacion = permiteReactivacion;
	}
	public String getRequiereCobro() {
		return requiereCobro;
	}
	public void setRequiereCobro(String requiereCobro) {
		this.requiereCobro = requiereCobro;
	}
	
}
