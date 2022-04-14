package bancaMovil.bean;

import general.bean.BaseBean;

public class BAMUsuariosBean extends BaseBean {

	private String clienteID;
	private String telefono;
	private String email;
	private String NIP;
	private String fechaUltimoAcceso;
	private String estatus;
	private String fechaCancelacion;
	private String fechaBloqueo;
	private String motivoBloqueo;
	private String motivoCancelacion;
	private String fechaCreacion;
	private String respuestaPregSecreta;
	private String fraseBienvenida;
	private String perfilID;
	private String preguntaSecretaID;
	private String imagenAntiPshPerson;
	private String tokenID;
	private String folioToken;
	private String imagenLoginID;

	private String imagenPhishingID; // OPCIONAL
	private String tokenMON;
	private String tokenMOF;
	private String nombreCompleto;

	// parametros agregados

	private String clave;
	private String contrasenia;

	private String estatusSesion;
	private String loginsFallidos;
	private String servicioBancaMov;
	private String servicioBancaWeb;
	private String imgCliente;

	private String usuarioID;
	private String imei;
	private String fechaCancel;
	private String motivoCancel;
	private String primerNombre;
	private String segundoNombre;
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String newPassword;
	private String contraseniaAnterior;
	private String estatusFinal;

	public String getEmail() {
		return email;
	}

	public void setEmail(String claveAcceso) {
		this.email = claveAcceso;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getFechaUltimoAcceso() {
		return fechaUltimoAcceso;
	}

	public void setFechaUltimoAcceso(String fechaUltimoAcceso) {
		this.fechaUltimoAcceso = fechaUltimoAcceso;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getFechaCancelacion() {
		return fechaCancelacion;
	}

	public void setFechaCancelacion(String fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}

	public String getFechaBloqueo() {
		return fechaBloqueo;
	}

	public void setFechaBloqueo(String fechaBloqueo) {
		this.fechaBloqueo = fechaBloqueo;
	}

	public String getMotivoBloqueo() {
		return motivoBloqueo;
	}

	public void setMotivoBloqueo(String motivoBloqueo) {
		this.motivoBloqueo = motivoBloqueo;
	}

	public String getMotivoCancelacion() {
		return motivoCancelacion;
	}

	public void setMotivoCancelacion(String motivoCancelacion) {
		this.motivoCancelacion = motivoCancelacion;
	}

	public String getFechaCreacion() {
		return fechaCreacion;
	}

	public void setFechaCreacion(String fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}

	public String getRespuestaPregSecreta() {
		return respuestaPregSecreta;
	}

	public void setRespuestaPregSecreta(String respuestaPregSecreta) {
		this.respuestaPregSecreta = respuestaPregSecreta;
	}

	public String getPerfilID() {
		return perfilID;
	}

	public void setPerfilID(String perfilID) {
		this.perfilID = perfilID;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getPreguntaSecretaID() {
		return preguntaSecretaID;
	}

	public void setPreguntaSecretaID(String preguntaSecretaID) {
		this.preguntaSecretaID = preguntaSecretaID;
	}

	public String getTokenID() {
		return tokenID;
	}

	public void setTokenID(String tokenID) {
		this.tokenID = tokenID;
	}

	public String getImagenLoginID() {
		return imagenLoginID;
	}

	public void setImagenLoginID(String imagenLoginID) {
		this.imagenLoginID = imagenLoginID;
	}

	public String getFraseBienvenida() {
		return fraseBienvenida;
	}

	public void setFraseBienvenida(String fraseBienvenida) {
		this.fraseBienvenida = fraseBienvenida;
	}

	public String getImagenAntiPshPerson() {
		return imagenAntiPshPerson;
	}

	public void setImagenAntiPshPerson(String imagenAntiPshPerson) {
		this.imagenAntiPshPerson = imagenAntiPshPerson;
	}

	public String getNIP() {
		return NIP;
	}

	public void setNIP(String nIP) {
		NIP = nIP;
	}

	public String getImagenPhishingID() {
		return imagenPhishingID;
	}

	public void setImagenPhishingID(String imagenPhishingID) {
		this.imagenPhishingID = imagenPhishingID;
	}

	public String getFolioToken() {
		return folioToken;
	}

	public void setFolioToken(String folioToken) {
		this.folioToken = folioToken;
	}

	public String getTokenMON() {
		return tokenMON;
	}

	public void setTokenMON(String tokenMON) {
		this.tokenMON = tokenMON;
	}

	public String getTokenMOF() {
		return tokenMOF;
	}

	public void setTokenMOF(String tokenMOF) {
		this.tokenMOF = tokenMOF;
	}

	public String getNombreCompleto() {
		return nombreCompleto;
	}

	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	public String getClave() {
		return clave;
	}

	public void setClave(String clave) {
		this.clave = clave;
	}

	public String getContrasenia() {
		return contrasenia;
	}

	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}

	public String getEstatusSesion() {
		return estatusSesion;
	}

	public void setEstatusSesion(String estatusSesion) {
		this.estatusSesion = estatusSesion;
	}

	public String getLoginsFallidos() {
		return loginsFallidos;
	}

	public void setLoginsFallidos(String loginsFallidos) {
		this.loginsFallidos = loginsFallidos;
	}

	public String getServicioBancaMov() {
		return servicioBancaMov;
	}

	public void setServicioBancaMov(String servicioBancaMov) {
		this.servicioBancaMov = servicioBancaMov;
	}

	public String getServicioBancaWeb() {
		return servicioBancaWeb;
	}

	public void setServicioBancaWeb(String servicioBancaWeb) {
		this.servicioBancaWeb = servicioBancaWeb;
	}

	public String getImgCliente() {
		return imgCliente;
	}

	public void setImgCliente(String imgCliente) {
		this.imgCliente = imgCliente;
	}

	public String getUsuarioID() {
		return usuarioID;
	}

	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}

	public String getImei() {
		return imei;
	}

	public void setImei(String imei) {
		this.imei = imei;
	}

	public String getFechaCancel() {
		return fechaCancel;
	}

	public void setFechaCancel(String fechaCancel) {
		this.fechaCancel = fechaCancel;
	}

	public String getMotivoCancel() {
		return motivoCancel;
	}

	public void setMotivoCancel(String motivoCancel) {
		this.motivoCancel = motivoCancel;
	}

	public String getPrimerNombre() {
		return primerNombre;
	}

	public void setPrimerNombre(String primerNombre) {
		this.primerNombre = primerNombre;
	}

	public String getSegundoNombre() {
		return segundoNombre;
	}

	public void setSegundoNombre(String segundoNombre) {
		this.segundoNombre = segundoNombre;
	}

	public String getApellidoPaterno() {
		return apellidoPaterno;
	}

	public void setApellidoPaterno(String apellidoPaterno) {
		this.apellidoPaterno = apellidoPaterno;
	}

	public String getApellidoMaterno() {
		return apellidoMaterno;
	}

	public void setApellidoMaterno(String apellidoMaterno) {
		this.apellidoMaterno = apellidoMaterno;
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

	public String getContraseniaAnterior() {
		return contraseniaAnterior;
	}

	public void setContraseniaAnterior(String contraseniaAnterior) {
		this.contraseniaAnterior = contraseniaAnterior;
	}

	public String getEstatusFinal() {
		return estatusFinal;
	}

	public void setEstatusFinal(String estatusFinal) {
		this.estatusFinal = estatusFinal;
	}

}
