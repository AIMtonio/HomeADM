package operacionesPDM.beanWS.response;

public class SP_PDM_Ahorros_OrdenPagoSpeiResponse {
	
	private String EsValido;
	private int codigoRespuesta;
	private String mensajeRespuesta;	
	private String autFecha;
	private String folioAut;
	private String folioSpei;
	private String claveRastreo;
	private String fechaOperacion;
	
	public String getEsValido() {
		return EsValido;
	}
	public void setEsValido(String esValido) {
		EsValido = esValido;
	}
	public int getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(int codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	public String getAutFecha() {
		return autFecha;
	}
	public void setAutFecha(String autFecha) {
		this.autFecha = autFecha;
	}
	public String getFolioAut() {
		return folioAut;
	}
	public void setFolioAut(String folioAut) {
		this.folioAut = folioAut;
	}
	public String getFolioSpei() {
		return folioSpei;
	}
	public void setFolioSpei(String folioSpei) {
		this.folioSpei = folioSpei;
	}
	public String getClaveRastreo() {
		return claveRastreo;
	}
	public void setClaveRastreo(String claveRastreo) {
		this.claveRastreo = claveRastreo;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
}
