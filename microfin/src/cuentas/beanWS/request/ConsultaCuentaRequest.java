package cuentas.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaCuentaRequest extends BaseBeanWS {
	private String cuentaAhoID;

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}

}
