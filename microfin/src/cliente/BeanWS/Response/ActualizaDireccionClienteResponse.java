package cliente.BeanWS.Response;

import general.bean.BaseBeanWS;

public class ActualizaDireccionClienteResponse extends BaseBeanWS{
	private String direccionID;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	
	public String getDireccionID() {
		return direccionID;
	}

	public void setDireccionID(String direccionID) {
		this.direccionID = direccionID;
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
	
}
