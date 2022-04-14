package cuentas.bean;

import general.bean.BaseBean;

public class BloqueoCuentaBean extends BaseBean {
	public static String bloqueo = "B";
	private String ctaBloqueo;
	private String saldoBloqueo;

	public String getCtaBloqueo() {
		return ctaBloqueo;
	}

	public void setCtaBloqueo(String ctaBloqueo) {
		this.ctaBloqueo = ctaBloqueo;
	}

	public String getSaldoBloqueo() {
		return saldoBloqueo;
	}

	public void setSaldoBloqueo(String saldoBloqueo) {
		this.saldoBloqueo = saldoBloqueo;
	}

}
