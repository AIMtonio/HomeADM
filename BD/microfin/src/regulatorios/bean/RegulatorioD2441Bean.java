package regulatorios.bean;

import general.bean.BaseBean;
 
public class RegulatorioD2441Bean extends BaseBean{
	  
	private String periodo;
	private String claveEntidad;
	private String subreporte;
	private String tipoCuentaTrans;
	private String canalTransaccion;
	private String tipoOperacion;
	private String montoOperacion;
	private String numeroOperaciones;
	private String numeroClientes;
	private String valor;
	private String anio;

	 
	/*PARAMETROS DE AUDITORIA */
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	public String getClaveEntidad() {
		return claveEntidad;
	}
	public void setClaveEntidad(String claveEntidad) {
		this.claveEntidad = claveEntidad;
	}
	public String getSubreporte() {
		return subreporte;
	}
	public void setSubreporte(String subreporte) {
		this.subreporte = subreporte;
	}
	public String getTipoCuentaTrans() {
		return tipoCuentaTrans;
	}
	public void setTipoCuentaTrans(String tipoCuentaTrans) {
		this.tipoCuentaTrans = tipoCuentaTrans;
	}
	public String getCanalTransaccion() {
		return canalTransaccion;
	}
	public void setCanalTransaccion(String canalTransaccion) {
		this.canalTransaccion = canalTransaccion;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getMontoOperacion() {
		return montoOperacion;
	}
	public void setMontoOperacion(String montoOperacion) {
		this.montoOperacion = montoOperacion;
	}
	public String getNumeroOperaciones() {
		return numeroOperaciones;
	}
	public void setNumeroOperaciones(String numeroOperaciones) {
		this.numeroOperaciones = numeroOperaciones;
	}
	public String getNumeroClientes() {
		return numeroClientes;
	}
	public void setNumeroClientes(String numeroClientes) {
		this.numeroClientes = numeroClientes;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
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
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	
	
	
	
	
}
