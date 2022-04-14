package sms.beanWS.request;

import general.bean.BaseBean;


public class EnviaSMSCampaniaRequest extends BaseBean{

	private String telefonoDestino;
	private String mensajeDestino;
	private String campaniaID;
	private String datosCliente;
	private String sistemaID;
	public String getTelefonoDestino() {
		return telefonoDestino;
	}
	public void setTelefonoDestino(String telefonoDestino) {
		this.telefonoDestino = telefonoDestino;
	}
	public String getMensajeDestino() {
		return mensajeDestino;
	}
	public void setMensajeDestino(String mensajeDestino) {
		this.mensajeDestino = mensajeDestino;
	}
	public String getCampaniaID() {
		return campaniaID;
	}
	public void setCampaniaID(String campaniaID) {
		this.campaniaID = campaniaID;
	}
	public String getDatosCliente() {
		return datosCliente;
	}
	public void setDatosCliente(String datosCliente) {
		this.datosCliente = datosCliente;
	}
	public String getSistemaID() {
		return sistemaID;
	}
	public void setSistemaID(String sistemaID) {
		this.sistemaID = sistemaID;
	}
	
	
}

