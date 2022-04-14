package cuentas.bean;

import general.bean.BaseBean;

public class DesbloqueoMasCtaBean extends BaseBean {
	public static String desbloqueo = "D";
	private String cuentaDesbloq;
	private String saldoDesbloq;
	
	public String getCuentaDesbloq() {
		return cuentaDesbloq;
	}
	public void setCuentaDesbloq(String cuentaDesbloq) {
		this.cuentaDesbloq = cuentaDesbloq;
	}
	public String getSaldoDesbloq() {
		return saldoDesbloq;
	}
	public void setSaldoDesbloq(String saldoDesbloq) {
		this.saldoDesbloq = saldoDesbloq;
	}

}
