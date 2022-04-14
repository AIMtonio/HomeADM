package bancaEnLinea.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaSaldoBloqueoBERequest extends BaseBeanWS{
	
	private String cuentaAhoID;
	private String mes;
	private String anio;
	private String tipoLis;
	

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}

	public String getMes() {
		return mes;
	}

	public void setMes(String mes) {
		this.mes = mes;
	}

	public String getAnio() {
		return anio;
	}

	public void setAnio(String anio) {
		this.anio = anio;
	}

	public String getTipoLis() {
		return tipoLis;
	}

	public void setTipoLis(String tipoLis) {
		this.tipoLis = tipoLis;
	}
	
	

}
