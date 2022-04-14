package credito.bean;

import general.bean.BaseBean;

public class ParamsCalificaBean extends BaseBean {

	private String capitalNeto;
	private String tipoInstitucion;
	private String limiteExpuesto;
	private String limiteCubierto;
	public String getCapitalNeto() {
		return capitalNeto;
	}
	public void setCapitalNeto(String capitalNeto) {
		this.capitalNeto = capitalNeto;
	}
	public String getTipoInstitucion() {
		return tipoInstitucion;
	}
	public void setTipoInstitucion(String tipoInstitucion) {
		this.tipoInstitucion = tipoInstitucion;
	}
	public String getLimiteExpuesto() {
		return limiteExpuesto;
	}
	public void setLimiteExpuesto(String limiteExpuesto) {
		this.limiteExpuesto = limiteExpuesto;
	}
	public String getLimiteCubierto() {
		return limiteCubierto;
	}
	public void setLimiteCubierto(String limiteCubierto) {
		this.limiteCubierto = limiteCubierto;
	}

	

}
