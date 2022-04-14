package cuentas.beanWS.request;

import general.bean.BaseBeanWS;

public class TransCuentasRequest extends BaseBeanWS {
	private String cuentaOrigen;
	private String cuentaDestino;
	private String monto;
	private String referencia;
	
	public String getCuentaOrigen() {
		return cuentaOrigen;
	}
	public String getCuentaDestino() {
		return cuentaDestino;
	}
	public String getMonto() {
		return monto;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setCuentaOrigen(String cuentaOrigen) {
		this.cuentaOrigen = cuentaOrigen;
	}
	public void setCuentaDestino(String cuentaDestino) {
		this.cuentaDestino = cuentaDestino;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}

	
}
