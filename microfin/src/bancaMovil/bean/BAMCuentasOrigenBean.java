package bancaMovil.bean;

import general.bean.BaseBean;

public class BAMCuentasOrigenBean extends BaseBean {

	private String clienteID;
	private String cuentaAhoID;
	private String estatus;
	/* Auxiliares */
	private String tipoCuentaID;
	private String fechaApertura;
	private String sucursalID;
	private String descripcion;
	private String nombreSucursal;
	private String saldoDispon;

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getTipoCuentaID() {
		return tipoCuentaID;
	}

	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}

	public String getFechaApertura() {
		return fechaApertura;
	}

	public void setFechaApertura(String fechaApertura) {
		this.fechaApertura = fechaApertura;
	}

	public String getSucursalID() {
		return sucursalID;
	}

	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getNombreSucursal() {
		return nombreSucursal;
	}

	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}

	public String getSaldoDispon() {
		return saldoDispon;
	}

	public void setSaldoDispon(String saldoDispon) {
		this.saldoDispon = saldoDispon;
	}

}
