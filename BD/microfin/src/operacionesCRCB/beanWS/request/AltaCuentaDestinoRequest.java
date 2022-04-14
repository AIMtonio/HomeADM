package operacionesCRCB.beanWS.request;

public class AltaCuentaDestinoRequest extends BaseRequestBean {
	
	private String clienteID;
	private String banco;
	private String tipoCuentaSpei;
	private String cuenta;
	private String beneficiario;
	private String alias;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getBanco() {
		return banco;
	}
	public void setBanco(String banco) {
		this.banco = banco;
	}
	public String getTipoCuentaSpei() {
		return tipoCuentaSpei;
	}
	public void setTipoCuentaSpei(String tipoCuentaSpei) {
		this.tipoCuentaSpei = tipoCuentaSpei;
	}
	public String getCuenta() {
		return cuenta;
	}
	public void setCuenta(String cuenta) {
		this.cuenta = cuenta;
	}
	public String getBeneficiario() {
		return beneficiario;
	}
	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}
	public String getAlias() {
		return alias;
	}
	public void setAlias(String alias) {
		this.alias = alias;
	}

	
}
