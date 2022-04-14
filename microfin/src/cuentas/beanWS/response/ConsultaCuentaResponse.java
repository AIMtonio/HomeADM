package cuentas.beanWS.response;

import general.bean.BaseBeanWS;

public class ConsultaCuentaResponse extends BaseBeanWS {
	
	private String clienteID;
	private String nombreCompleto;
	private String descripcion;
	private String tipoCta;

	

	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public String getDescripcion() {
		return descripcion;
	}
	
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTipoCta() {
		return tipoCta;
	}
	public void setTipoCta(String tipoCta) {
		this.tipoCta = tipoCta;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	
}
