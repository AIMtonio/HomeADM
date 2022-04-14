package operacionesPDA.beanWS.response;

import general.bean.BaseBeanWS;

public class AltaSolicitudGrupalResponse extends BaseBeanWS {

	private String solicitudCreditoID;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String clienteID;

	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}

	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}

	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}

	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}

	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}

	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

}
