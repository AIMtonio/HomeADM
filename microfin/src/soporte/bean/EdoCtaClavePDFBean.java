package soporte.bean;

import general.bean.BaseBean;

public class EdoCtaClavePDFBean extends BaseBean {
	private String clienteID;
	private String contrasenia;
	private String correoEnvio;
	private String fechaActualiza;
	private String clavePDF;
	
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getContrasenia() {
		return contrasenia;
	}
	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}
	public String getCorreoEnvio() {
		return correoEnvio;
	}
	public void setCorreoEnvio(String correoEnvio) {
		this.correoEnvio = correoEnvio;
	}
	public String getFechaActualiza() {
		return fechaActualiza;
	}
	public void setFechaActualiza(String fechaActualiza) {
		this.fechaActualiza = fechaActualiza;
	}
	public String getClavePDF() {
		return clavePDF;
	}
	public void setClavePDF(String clavePDF) {
		this.clavePDF = clavePDF;
	}
}
