package bancaEnLinea.beanWS.request;

import general.bean.BaseBeanWS;

public class AltaUsuarioBERequest extends BaseBeanWS{
	private String clave;
	private String perfil;
	private String clienteNominaID;
	private String negocioAfiliadoID;
	private String clienteID;
	private String costoMensual;
	private String tipoTransaccion;
	
	
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getPerfil() {
		return perfil;
	}
	public void setPerfil(String perfil) {
		this.perfil = perfil;
	}
	public String getClienteNominaID() {
		return clienteNominaID;
	}
	public void setClienteNominaID(String clienteNominaID) {
		this.clienteNominaID = clienteNominaID;
	}
	public String getNegocioAfiliadoID() {
		return negocioAfiliadoID;
	}
	public void setNegocioAfiliadoID(String negocioAfiliadoID) {
		this.negocioAfiliadoID = negocioAfiliadoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCostoMensual() {
		return costoMensual;
	}
	public void setCostoMensual(String costoMensual) {
		this.costoMensual = costoMensual;
	}
	public String getTipoTransaccion() {
		return tipoTransaccion;
	}
	public void setTipoTransaccion(String tipoTransaccion) {
		this.tipoTransaccion = tipoTransaccion;
	}
	
	
	
	
	
	
}
