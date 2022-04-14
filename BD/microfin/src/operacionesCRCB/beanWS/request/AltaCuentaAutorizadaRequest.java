package operacionesCRCB.beanWS.request;

public class AltaCuentaAutorizadaRequest extends BaseRequestBean {
	
	private String sucursalID;
	private String clienteID;
	private String tipoCuentaID;
	private String esPrincipal;
	private String fechaContratacion;
	private String tasaPactada;
	
	
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getTipoCuentaID() {
		return tipoCuentaID;
	}
	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}
	public String getEsPrincipal() {
		return esPrincipal;
	}
	public void setEsPrincipal(String esPrincipal) {
		this.esPrincipal = esPrincipal;
	}
	public String getFechaContratacion() {
		return fechaContratacion;
	}
	public void setFechaContratacion(String fechaContratacion) {
		this.fechaContratacion = fechaContratacion;
	}
	public String getTasaPactada() {
		return tasaPactada;
	}
	public void setTasaPactada(String tasaPactada) {
		this.tasaPactada = tasaPactada;
	}


	
	
	
}
