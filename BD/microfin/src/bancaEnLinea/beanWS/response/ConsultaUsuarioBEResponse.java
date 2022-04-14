package bancaEnLinea.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaUsuarioBEResponse extends BaseBeanWS {
	
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String clienteID;
	private String nombreCompleto;
	private String RFC;
	private String usuarioBE;
	
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public String getRFC() {
		return RFC;
	}
	public String getUsuarioBE() {
		return usuarioBE;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public void setUsuarioBE(String usuarioBE) {
		this.usuarioBE = usuarioBE;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}


}
