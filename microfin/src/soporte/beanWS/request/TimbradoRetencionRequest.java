package soporte.beanWS.request;

public class TimbradoRetencionRequest {
	private String cadenaTimbrado;
	private String tokenAutentificacion;
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
	public String getTokenAutentificacion() {
		return tokenAutentificacion;
	}
	public void setTokenAutentificacion(String tokenAutentificacion) {
		this.tokenAutentificacion = tokenAutentificacion;
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