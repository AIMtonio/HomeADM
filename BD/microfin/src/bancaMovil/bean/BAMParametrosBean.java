package bancaMovil.bean;

import java.util.List;

import general.bean.BaseBean;

public class BAMParametrosBean extends BaseBean {

	private String empresaID;
	private String mensajeCodigoActSMS;
	private String passwordCorreoBancaMovil;
	private String puertoCorreoBancaMovil;
	private String rutaArchivos;
	private String rutaCorreosBancaMovil;
	private String servidorCorreoBancaMovil;
	private String subjectAltaBancaMovil;
	private String subjectCambiosBancaMovil;
	private String subjectPagosBancaMovil;
	private String subjectSessionBancaMovil;
	private String subjectTransferBancaMovil;
	private String tiempoValidezSMS;
	private String usuarioCorreoBancaMovil;
	private String remitenteCorreo;
	private String nombreInstitucion;

	// nuevos parametros agregados

	private String nombreCortoInsitucion;
	private String textoActivacionSMS;
	private String ivaPagarSpei;
	private String usuarioSpei;
	private String textoNotifNuevoUsuario;
	private String textoNotifiCambioSeg;
	private String textoNotifPagos;
	private String textoNotifSesion;
	private String textoNotifTransferencias;
	private String tiempoValidoSMS;
	private String remitente;
	private String minimoCaracteresPin;
	private String urlFreja;
	private String tituloTransaccion;
	private String periodoValidacion;
	private String tiempoMaxEspera;
	private String tiempoAprovisionamiento;
	private List<?> lisProducCredito;
	private List<?> lisDestinoCredito;
	private List<?> lisClasificacion;
	private List<?> lisTiposCta;
	private String perfil;

	public String getNombreCortoInsitucion() {
		return nombreCortoInsitucion;
	}

	public void setNombreCortoInsitucion(String nombreCortoInsitucion) {
		this.nombreCortoInsitucion = nombreCortoInsitucion;
	}

	public String getTextoActivacionSMS() {
		return textoActivacionSMS;
	}

	public void setTextoActivacionSMS(String textoActivacionSMS) {
		this.textoActivacionSMS = textoActivacionSMS;
	}

	public String getIvaPagarSpei() {
		return ivaPagarSpei;
	}

	public void setIvaPagarSpei(String ivaPagarSpei) {
		this.ivaPagarSpei = ivaPagarSpei;
	}

	public String getUsuarioSpei() {
		return usuarioSpei;
	}

	public void setUsuarioSpei(String usuarioSpei) {
		this.usuarioSpei = usuarioSpei;
	}

	public String getTextoNotifNuevoUsuario() {
		return textoNotifNuevoUsuario;
	}

	public void setTextoNotifNuevoUsuario(String textoNotifNuevoUsuario) {
		this.textoNotifNuevoUsuario = textoNotifNuevoUsuario;
	}

	public String getTextoNotifiCambioSeg() {
		return textoNotifiCambioSeg;
	}

	public void setTextoNotifiCambioSeg(String textoNotifiCambioSeg) {
		this.textoNotifiCambioSeg = textoNotifiCambioSeg;
	}

	public String getTextoNotifPagos() {
		return textoNotifPagos;
	}

	public void setTextoNotifPagos(String textoNotifPagos) {
		this.textoNotifPagos = textoNotifPagos;
	}

	public String getTextoNotifSesion() {
		return textoNotifSesion;
	}

	public void setTextoNotifSesion(String textoNotifSesion) {
		this.textoNotifSesion = textoNotifSesion;
	}

	public String getTextoNotifTransferencias() {
		return textoNotifTransferencias;
	}

	public void setTextoNotifTransferencias(String textoNotifTransferencias) {
		this.textoNotifTransferencias = textoNotifTransferencias;
	}

	public String getTiempoValidoSMS() {
		return tiempoValidoSMS;
	}

	public void setTiempoValidoSMS(String tiempoValidoSMS) {
		this.tiempoValidoSMS = tiempoValidoSMS;
	}

	public String getRemitente() {
		return remitente;
	}

	public void setRemitente(String remitente) {
		this.remitente = remitente;
	}

	public String getMinimoCaracteresPin() {
		return minimoCaracteresPin;
	}

	public void setMinimoCaracteresPin(String minimoCaracteresPin) {
		this.minimoCaracteresPin = minimoCaracteresPin;
	}

	public String getUrlFreja() {
		return urlFreja;
	}

	public void setUrlFreja(String urlFreja) {
		this.urlFreja = urlFreja;
	}

	public String getTituloTransaccion() {
		return tituloTransaccion;
	}

	public void setTituloTransaccion(String tituloTransaccion) {
		this.tituloTransaccion = tituloTransaccion;
	}

	public String getPeriodoValidacion() {
		return periodoValidacion;
	}

	public void setPeriodoValidacion(String periodoValidacion) {
		this.periodoValidacion = periodoValidacion;
	}

	public String getTiempoMaxEspera() {
		return tiempoMaxEspera;
	}

	public void setTiempoMaxEspera(String tiempoMaxEspera) {
		this.tiempoMaxEspera = tiempoMaxEspera;
	}

	public String getTiempoAprovisionamiento() {
		return tiempoAprovisionamiento;
	}

	public void setTiempoAprovisionamiento(String tiempoAprovisionamiento) {
		this.tiempoAprovisionamiento = tiempoAprovisionamiento;
	}

	public List<?> getLisProducCredito() {
		return lisProducCredito;
	}

	public void setLisProducCredito(List<?> lisProducCredito) {
		this.lisProducCredito = lisProducCredito;
	}

	public List<?> getLisDestinoCredito() {
		return lisDestinoCredito;
	}

	public void setLisDestinoCredito(List<?> lisDestinoCredito) {
		this.lisDestinoCredito = lisDestinoCredito;
	}

	public List<?> getLisClasificacion() {
		return lisClasificacion;
	}

	public void setLisClasificacion(List<?> lisClasificacion) {
		this.lisClasificacion = lisClasificacion;
	}

	public List<?> getLisTiposCta() {
		return lisTiposCta;
	}

	public void setLisTiposCta(List<?> lisTiposCta) {
		this.lisTiposCta = lisTiposCta;
	}

	public String getPerfil() {
		return perfil;
	}

	public void setPerfil(String perfil) {
		this.perfil = perfil;
	}

	public String getEmpresaID() {
		return empresaID;
	}

	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}

	public String getMensajeCodigoActSMS() {
		return mensajeCodigoActSMS;
	}

	public void setMensajeCodigoActSMS(String mensajeCodigoActSMS) {
		this.mensajeCodigoActSMS = mensajeCodigoActSMS;
	}

	public String getPuertoCorreoBancaMovil() {
		return puertoCorreoBancaMovil;
	}

	public void setPuertoCorreoBancaMovil(String puertoCorreoBancaMovil) {
		this.puertoCorreoBancaMovil = puertoCorreoBancaMovil;
	}

	public String getRutaArchivos() {
		return rutaArchivos;
	}

	public void setRutaArchivos(String rutaArchivos) {
		this.rutaArchivos = rutaArchivos;
	}

	public String getRutaCorreosBancaMovil() {
		return rutaCorreosBancaMovil;
	}

	public void setRutaCorreosBancaMovil(String rutaCorreosBancaMovil) {
		this.rutaCorreosBancaMovil = rutaCorreosBancaMovil;
	}

	public String getServidorCorreoBancaMovil() {
		return servidorCorreoBancaMovil;
	}

	public void setServidorCorreoBancaMovil(String servidorCorreoBancaMovil) {
		this.servidorCorreoBancaMovil = servidorCorreoBancaMovil;
	}

	public String getSubjectAltaBancaMovil() {
		return subjectAltaBancaMovil;
	}

	public void setSubjectAltaBancaMovil(String subjectAltaBancaMovil) {
		this.subjectAltaBancaMovil = subjectAltaBancaMovil;
	}

	public String getSubjectCambiosBancaMovil() {
		return subjectCambiosBancaMovil;
	}

	public void setSubjectCambiosBancaMovil(String subjectCambiosBancaMovil) {
		this.subjectCambiosBancaMovil = subjectCambiosBancaMovil;
	}

	public String getSubjectPagosBancaMovil() {
		return subjectPagosBancaMovil;
	}

	public void setSubjectPagosBancaMovil(String subjectPagosBancaMovil) {
		this.subjectPagosBancaMovil = subjectPagosBancaMovil;
	}

	public String getSubjectSessionBancaMovil() {
		return subjectSessionBancaMovil;
	}

	public void setSubjectSessionBancaMovil(String subjectSessionBancaMovil) {
		this.subjectSessionBancaMovil = subjectSessionBancaMovil;
	}

	public String getSubjectTransferBancaMovil() {
		return subjectTransferBancaMovil;
	}

	public void setSubjectTransferBancaMovil(String subjectTransferBancaMovil) {
		this.subjectTransferBancaMovil = subjectTransferBancaMovil;
	}

	public String getTiempoValidezSMS() {
		return tiempoValidezSMS;
	}

	public void setTiempoValidezSMS(String tiempoValidezSMS) {
		this.tiempoValidezSMS = tiempoValidezSMS;
	}

	public String getUsuarioCorreoBancaMovil() {
		return usuarioCorreoBancaMovil;
	}

	public void setUsuarioCorreoBancaMovil(String usuarioCorreoBancaMovil) {
		this.usuarioCorreoBancaMovil = usuarioCorreoBancaMovil;
	}

	public String getPasswordCorreoBancaMovil() {
		return passwordCorreoBancaMovil;
	}

	public void setPasswordCorreoBancaMovil(String passwordCorreoBancaMovil) {
		this.passwordCorreoBancaMovil = passwordCorreoBancaMovil;
	}

	public String getRemitenteCorreo() {
		return remitenteCorreo;
	}

	public void setRemitenteCorreo(String remitenteCorreo) {
		this.remitenteCorreo = remitenteCorreo;
	}

	public String getNombreInstitucion() {
		return nombreInstitucion;
	}

	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}

}
