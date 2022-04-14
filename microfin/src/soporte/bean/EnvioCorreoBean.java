package soporte.bean;

import general.bean.BaseBean;

public class EnvioCorreoBean extends BaseBean {
	
	private String	correoID;
	private String	remitente;
	private String	destinatario;
	private String	asunto;
	private String	mensaje;
	private String	fecha;
	private String	sevidorCorreo;
	private String	puerto;
	private String	usuarioCorreo;
	private String	contrasenia;
	private String	origen;
	private String	estatus;
	
	private String pendientesEnvio;
	
	public String getRemitente() {
		return remitente;
	}
	
	public void setRemitente(String remitente) {
		this.remitente = remitente;
	}
	
	public String getDestinatario() {
		return destinatario;
	}
	
	public void setDestinatario(String destinatario) {
		this.destinatario = destinatario;
	}
	
	public String getAsunto() {
		return asunto;
	}
	
	public void setAsunto(String asunto) {
		this.asunto = asunto;
	}
	
	public String getMensaje() {
		return mensaje;
	}
	
	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}
	
	public String getFecha() {
		return fecha;
	}
	
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	
	public String getSevidorCorreo() {
		return sevidorCorreo;
	}
	
	public void setSevidorCorreo(String sevidorCorreo) {
		this.sevidorCorreo = sevidorCorreo;
	}
	
	public String getPuerto() {
		return puerto;
	}
	
	public void setPuerto(String puerto) {
		this.puerto = puerto;
	}
	
	public String getUsuarioCorreo() {
		return usuarioCorreo;
	}
	
	public void setUsuarioCorreo(String usuarioCorreo) {
		this.usuarioCorreo = usuarioCorreo;
	}
	
	public String getContrasenia() {
		return contrasenia;
	}
	
	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}

	public String getCorreoID() {
		return correoID;
	}

	public void setCorreoID(String correoID) {
		this.correoID = correoID;
	}

	public String getOrigen() {
		return origen;
	}

	public void setOrigen(String origen) {
		this.origen = origen;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getPendientesEnvio() {
		return pendientesEnvio;
	}

	public void setPendientesEnvio(String pendientesEnvio) {
		this.pendientesEnvio = pendientesEnvio;
	}
	
}
