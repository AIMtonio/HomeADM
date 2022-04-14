package credito.bean;

import general.bean.BaseBean;

public class RespaldoPagoCreditoBean extends BaseBean{
	
	private String tranRespaldo;
	private String CuentaAhoID;
	private String CreditoID;
	private String MontoPagado;
	private String fechaPago;
	
	private String nombreCliente;	
	private String estatus;
	private String nombreProducto;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	public String getTranRespaldo() {
		return tranRespaldo;
	}
	public void setTranRespaldo(String tranRespaldo) {
		this.tranRespaldo = tranRespaldo;
	}
	public String getCuentaAhoID() {
		return CuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		CuentaAhoID = cuentaAhoID;
	}
	public String getCreditoID() {
		return CreditoID;
	}
	public void setCreditoID(String creditoID) {
		CreditoID = creditoID;
	}
	public String getMontoPagado() {
		return MontoPagado;
	}
	public void setMontoPagado(String montoPagado) {
		MontoPagado = montoPagado;
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
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getNombreProducto() {
		return nombreProducto;
	}
	public void setNombreProducto(String nombreProducto) {
		this.nombreProducto = nombreProducto;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}

	
	

}
