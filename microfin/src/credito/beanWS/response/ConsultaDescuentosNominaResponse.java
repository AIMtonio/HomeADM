package credito.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaDescuentosNominaResponse extends BaseBeanWS {
	private String listaDescuentosNomina;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	
	public String getListaDescuentosNomina() {
		return listaDescuentosNomina;
	}
	public void setListaDescuentosNomina(String listaDescuentosNomina) {
		this.listaDescuentosNomina = listaDescuentosNomina;
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
