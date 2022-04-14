package operacionesCRCB.beanWS.request;

public class AltaInversionRequest extends BaseRequestBean {

	private String clienteID;
	private String cuentaAhoID;
	private String tipoInversionID;
	private String monto;
	private String plazo;
	private String tasa;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getTipoInversionID() {
		return tipoInversionID;
	}
	public void setTipoInversionID(String tipoInversionID) {
		this.tipoInversionID = tipoInversionID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}

	
}
