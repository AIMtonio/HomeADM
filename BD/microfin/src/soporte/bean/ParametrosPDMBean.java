package soporte.bean;

import general.bean.BaseBean;

public class ParametrosPDMBean extends BaseBean{
	
	private String empresaID; 
	private int timeOut;
	private String urlWSDLLogin;
	private String urlWSDLLogout;
	private String urlWSDLAlta; 
	private String urlWSDLBloqueo;
	private String urlWSDLDesBloqueo;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	private String nombreServicio;
	private String numeroPreguntas;
	private String numeroRespuestas;
	
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public int getTimeOut() {
		return timeOut;
	}
	public void setTimeOut(int timeOut) {
		this.timeOut = timeOut;
	}
	public String getUrlWSDLLogin() {
		return urlWSDLLogin;
	}
	public void setUrlWSDLLogin(String urlWSDLLogin) {
		this.urlWSDLLogin = urlWSDLLogin;
	}
	public String getUrlWSDLLogout() {
		return urlWSDLLogout;
	}
	public void setUrlWSDLLogout(String urlWSDLLogout) {
		this.urlWSDLLogout = urlWSDLLogout;
	}
	public String getUrlWSDLAlta() {
		return urlWSDLAlta;
	}
	public void setUrlWSDLAlta(String urlWSDLAlta) {
		this.urlWSDLAlta = urlWSDLAlta;
	}
	public String getUrlWSDLBloqueo() {
		return urlWSDLBloqueo;
	}
	public void setUrlWSDLBloqueo(String urlWSDLBloqueo) {
		this.urlWSDLBloqueo = urlWSDLBloqueo;
	}
	public String getUrlWSDLDesBloqueo() {
		return urlWSDLDesBloqueo;
	}
	public void setUrlWSDLDesBloqueo(String urlWSDLDesBloqueo) {
		this.urlWSDLDesBloqueo = urlWSDLDesBloqueo;
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
	public String getNombreServicio() {
		return nombreServicio;
	}
	public void setNombreServicio(String nombreServicio) {
		this.nombreServicio = nombreServicio;
	}
	public String getNumeroPreguntas() {
		return numeroPreguntas;
	}
	public void setNumeroPreguntas(String numeroPreguntas) {
		this.numeroPreguntas = numeroPreguntas;
	}
	public String getNumeroRespuestas() {
		return numeroRespuestas;
	}
	public void setNumeroRespuestas(String numeroRespuestas) {
		this.numeroRespuestas = numeroRespuestas;
	}	

}
