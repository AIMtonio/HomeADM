package soporte.beanWS.request;

import psl.rest.BaseBeanRequest;

public class TimbradoEdoCtaRequest extends BaseBeanRequest {

	private String cadenaTimbrado;
	private String identificadorBus;
	private String usuario;
	private String ipUsuario;
	private String sucursal;
	public String getCadenaTimbrado() {
		return cadenaTimbrado;
	}
	public void setCadenaTimbrado(String cadenaTimbrado) {
		this.cadenaTimbrado = cadenaTimbrado;
	}
	public String getIdentificadorBus() {
		return identificadorBus;
	}
	public void setIdentificadorBus(String identificadorBus) {
		this.identificadorBus = identificadorBus;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getIpUsuario() {
		return ipUsuario;
	}
	public void setIpUsuario(String ipUsuario) {
		this.ipUsuario = ipUsuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}

	
}
