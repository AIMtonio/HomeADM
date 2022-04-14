package cliente.bean;

import general.bean.BaseBean;

public class ClientesPROFUNBean extends BaseBean {
	
			
	//Campos de la tabla
	private String clienteID;
	private String cuentaAhoID;
	private String fechaRegistro;
	private String sucursalReg;
	private String sucursalCan;
	private String usuarioReg;
	private String usuarioCan;
	private String fechaCancela;
	private String estatus;		
	private String numClientesProfun;
	
	//Parámetros de auditoria
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	// Auxiliares
	private String montoPendiente;
	
	
	public String getMontoPendiente() {
		return montoPendiente;
	}
	public void setMontoPendiente(String montoPendiente) {
		this.montoPendiente = montoPendiente;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getSucursalReg() {
		return sucursalReg;
	}
	public void setSucursalReg(String sucursalReg) {
		this.sucursalReg = sucursalReg;
	}
	public String getSucursalCan() {
		return sucursalCan;
	}
	public void setSucursalCan(String sucursalCan) {
		this.sucursalCan = sucursalCan;
	}
	public String getUsuarioReg() {
		return usuarioReg;
	}
	public void setUsuarioReg(String usuarioReg) {
		this.usuarioReg = usuarioReg;
	}
	public String getUsuarioCan() {
		return usuarioCan;
	}
	public void setUsuarioCan(String usuarioCan) {
		this.usuarioCan = usuarioCan;
	}
	public String getFechaCancela() {
		return fechaCancela;
	}
	public void setFechaCancela(String fechaCancela) {
		this.fechaCancela = fechaCancela;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getNumClientesProfun() {
		return numClientesProfun;
	}
	public void setNumClientesProfun(String numClientesProfun) {
		this.numClientesProfun = numClientesProfun;
	}
	
	
	
}