package credito.beanWS.response;

import general.bean.BaseBeanWS;

public class SimuladorCreditoResponse extends BaseBeanWS {

	private String listaSimuladorCredito;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getListaSimuladorCredito() {
		return listaSimuladorCredito;
	}
	public void setListaSimuladorCredito(String listaSimuladorCredito) {
		this.listaSimuladorCredito = listaSimuladorCredito;
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
