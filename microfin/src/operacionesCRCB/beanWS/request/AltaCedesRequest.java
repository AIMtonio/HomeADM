package operacionesCRCB.beanWS.request;

public class AltaCedesRequest extends BaseRequestBean{

	private String clienteID;
	private String cuentaAhoID;
	private String tipoCedeID;
	private String tipoPago;
	private String diasPeriodo;
	private String monto;
	private String plazo;
	private String tasa;
	private String reinvertir;
	private String tipoReinversion;

	
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
	public String getTipoCedeID() {
		return tipoCedeID;
	}
	public void setTipoCedeID(String tipoCedeID) {
		this.tipoCedeID = tipoCedeID;
	}
	public String getTipoPago() {
		return tipoPago;
	}
	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}
	public String getDiasPeriodo() {
		return diasPeriodo;
	}
	public void setDiasPeriodo(String diasPeriodo) {
		this.diasPeriodo = diasPeriodo;
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
	public String getReinvertir() {
		return reinvertir;
	}
	public void setReinvertir(String reinvertir) {
		this.reinvertir = reinvertir;
	}
	public String getTipoReinversion() {
		return tipoReinversion;
	}
	public void setTipoReinversion(String tipoReinversion) {
		this.tipoReinversion = tipoReinversion;
	}

	
	
}
