package cliente.BeanWS.Response;

import general.bean.BaseBeanWS;

public class ModificaIdentificacionResponse extends BaseBeanWS{
	
	private String tipoIdentiID;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	
	public String getTipoIdentiID() {
		return tipoIdentiID;
	}
	
	public void setTipoIdentiID(String tipoIdentiID) {
		this.tipoIdentiID = tipoIdentiID;
	}

	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}

	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}

	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}

	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	
	
	
}
