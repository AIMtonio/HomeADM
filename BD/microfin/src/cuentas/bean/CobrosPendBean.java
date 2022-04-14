package cuentas.bean;

import general.bean.BaseBean;

public class CobrosPendBean extends BaseBean{
	/*atributos tabla COBROSPEND*/
	private String clienteID;
	private String cuentaAhoID;
	private String fecha;
	private String cantPenOri;
	private String cantPenAct;
	private String estatus;
	private String tipoMovAhoID;
	private String fechaPago;
	private String descripcion;
	private String transaccion;
	private String sumCanPenOri;
	private String sumCanPenAct;
	private String mes;
	private String anio;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private String fechaEmision;
	private String HoraEmision;
	private String nombreInstitucion;
	
	//reporte Cobros Pendientes
	private String sucursalOrigen;
	private String nombSucursalCli;
	private String nombreCompleto;
	private String etiquetaCuenta;
	private String fechaInicial;
	private String fechaFinal;
	
	
	
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
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getCantPenOri() {
		return cantPenOri;
	}
	public void setCantPenOri(String cantPenOri) {
		this.cantPenOri = cantPenOri;
	}
	public String getCantPenAct() {
		return cantPenAct;
	}
	public void setCantPenAct(String cantPenAct) {
		this.cantPenAct = cantPenAct;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTipoMovAhoID() {
		return tipoMovAhoID;
	}
	public void setTipoMovAhoID(String tipoMovAhoID) {
		this.tipoMovAhoID = tipoMovAhoID;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTransaccion() {
		return transaccion;
	}
	public void setTransaccion(String transaccion) {
		this.transaccion = transaccion;
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
	public String getSumCanPenOri() {
		return sumCanPenOri;
	}
	public void setSumCanPenOri(String sumCanPenOri) {
		this.sumCanPenOri = sumCanPenOri;
	}
	public String getSumCanPenAct() {
		return sumCanPenAct;
	}
	public void setSumCanPenAct(String sumCanPenAct) {
		this.sumCanPenAct = sumCanPenAct;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getHoraEmision() {
		return HoraEmision;
	}
	public void setHoraEmision(String horaEmision) {
		HoraEmision = horaEmision;
	}
	public String getSucursalOrigen() {
		return sucursalOrigen;
	}
	public String getNombSucursalCli() {
		return nombSucursalCli;
	}
	public void setSucursalOrigen(String sucursalOrigen) {
		this.sucursalOrigen = sucursalOrigen;
	}
	public void setNombSucursalCli(String nombSucursalCli) {
		this.nombSucursalCli = nombSucursalCli;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getEtiquetaCuenta() {
		return etiquetaCuenta;
	}
	public void setEtiquetaCuenta(String etiquetaCuenta) {
		this.etiquetaCuenta = etiquetaCuenta;
	}
	public String getFechaInicial() {
		return fechaInicial;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombInstitucion) {
		this.nombreInstitucion = nombInstitucion;
	}
}