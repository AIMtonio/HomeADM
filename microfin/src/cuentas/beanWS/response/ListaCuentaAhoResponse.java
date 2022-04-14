package cuentas.beanWS.response;

import general.bean.BaseBeanWS;

public class ListaCuentaAhoResponse extends BaseBeanWS{
	private String listaCuenta;

	public String getListaCuenta() {
		return listaCuenta;
	}

	public void setListaCuenta(String listaCuenta) {
		this.listaCuenta = listaCuenta;
	}
}
