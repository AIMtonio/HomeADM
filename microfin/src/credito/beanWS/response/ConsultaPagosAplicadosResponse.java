package credito.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaPagosAplicadosResponse extends BaseBeanWS{
	private String listaPagosAplicados;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	
	public String getListaPagosAplicados() {
		return listaPagosAplicados;
	}
	public void setListaPagosAplicados(String listaPagosAplicados) {
		this.listaPagosAplicados = listaPagosAplicados;
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
}
