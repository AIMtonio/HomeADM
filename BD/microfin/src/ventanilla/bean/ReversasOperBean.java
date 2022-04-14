package ventanilla.bean;

import general.bean.BaseBean;

public class ReversasOperBean extends BaseBean{
	
	private String transaccionID;
	private String motivo	;
	private String descripcionOper;
	private String tipoOperacion;
	private String referencia;
	private String monto;
	private String cajaID;
	private String sucursalID;
	private String fecha;
	private String usuarioAutID;
	private String claveUsuarioAut;
	private String contraseniaAut;
	private String cambio;
	private String efectivo;

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	/*Datos para los tickets de reversas*/
	private String clave;
	private String fechaOpera;
	private String usuarioID;
	private String hora;
	
	public String getTransaccionID() {
		return transaccionID;
	}
	public void setTransaccionID(String transaccionID) {
		this.transaccionID = transaccionID;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public String getDescripcionOper() {
		return descripcionOper;
	}
	public void setDescripcionOper(String descripcionOper) {
		this.descripcionOper = descripcionOper;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
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
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getUsuarioAutID() {
		return usuarioAutID;
	}
	public void setUsuarioAutID(String usuarioAutID) {
		this.usuarioAutID = usuarioAutID;
	}
	public String getClaveUsuarioAut() {
		return claveUsuarioAut;
	}
	public void setClaveUsuarioAut(String claveUsuarioAut) {
		this.claveUsuarioAut = claveUsuarioAut;
	}
	public String getContraseniaAut() {
		return contraseniaAut;
	}
	public void setContraseniaAut(String contraseniaAut) {
		this.contraseniaAut = contraseniaAut;
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
	
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getFechaOpera() {
		return fechaOpera;
	}
	public void setFechaOpera(String fechaOpera) {
		this.fechaOpera = fechaOpera;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getCambio() {
		return cambio;
	}
	public void setCambio(String cambio) {
		this.cambio = cambio;
	}
	public String getEfectivo() {
		return efectivo;
	}
	public void setEfectivo(String efectivo) {
		this.efectivo = efectivo;
	}
	
}
