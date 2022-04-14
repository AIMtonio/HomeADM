package tarjetas.bean;

import java.util.List;

import general.bean.BaseBean;

public class ConfigFTPProsaBean extends BaseBean {
	private String configFTPProsaID;
	private String servidor;
	private String usuario;
	private String contrasenia;
	private String puerto;
	private String ruta;
	private String horaInicio;
	private String horaFin;
	private String intervaloMin;
	private String numIntentos;
	private String mensajeCorreo;
	private String usuarioRemitente;
	private String correoRemitente;
	private List<String> usuarioDest; //nameInput
	private List<String> listaCorreoSalida;//nameInput
	
	public String getConfigFTPProsaID() {
		return configFTPProsaID;
	}
	public void setConfigFTPProsaID(String configFTPProsaID) {
		this.configFTPProsaID = configFTPProsaID;
	}
	public String getServidor() {
		return servidor;
	}
	public void setServidor(String servidor) {
		this.servidor = servidor;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getContrasenia() {
		return contrasenia;
	}
	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}
	public String getPuerto() {
		return puerto;
	}
	public void setPuerto(String puerto) {
		this.puerto = puerto;
	}
	public String getRuta() {
		return ruta;
	}
	public void setRuta(String ruta) {
		this.ruta = ruta;
	}
	public String getHoraInicio() {
		return horaInicio;
	}
	public void setHoraInicio(String horaInicio) {
		this.horaInicio = horaInicio;
	}
	public String getHoraFin() {
		return horaFin;
	}
	public void setHoraFin(String horaFin) {
		this.horaFin = horaFin;
	}
	public String getNumIntentos() {
		return numIntentos;
	}
	public void setNumIntentos(String numIntentos) {
		this.numIntentos = numIntentos;
	}
	
	public String getMensajeCorreo() {
		return mensajeCorreo;
	}
	public void setMensajeCorreo(String mensajeCorreo) {
		this.mensajeCorreo = mensajeCorreo;
	}
	public String getIntervaloMin() {
		return intervaloMin;
	}
	public void setIntervaloMin(String intervaloMin) {
		this.intervaloMin = intervaloMin;
	}
	
	public String getUsuarioRemitente() {
		return usuarioRemitente;
	}
	public void setUsuarioRemitente(String usuarioRemitente) {
		this.usuarioRemitente = usuarioRemitente;
	}
	public List<String> getUsuarioDest() {
		return usuarioDest;
	}
	public void setUsuarioDest(List<String> usuarioDest) {
		this.usuarioDest = usuarioDest;
	}
	public List<String> getListaCorreoSalida() {
		return listaCorreoSalida;
	}
	public void setListaCorreoSalida(List<String> listaCorreoSalida) {
		this.listaCorreoSalida = listaCorreoSalida;
	}
	public String getCorreoRemitente() {
		return correoRemitente;
	}
	public void setCorreoRemitente(String correoRemitente) {
		this.correoRemitente = correoRemitente;
	}
	
	
	
	
}
