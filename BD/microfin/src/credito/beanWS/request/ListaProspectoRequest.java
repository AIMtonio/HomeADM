package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ListaProspectoRequest extends BaseBeanWS {
	private String nombreCompleto;
	private String institNominaID;
	private String negocioAfiliadoID;
	private String tipoLis;
	
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getNegocioAfiliadoID() {
		return negocioAfiliadoID;
	}
	public void setNegocioAfiliadoID(String negocioAfiliadoID) {
		this.negocioAfiliadoID = negocioAfiliadoID;
	}
	public String getTipoLis() {
		return tipoLis;
	}
	public void setTipoLis(String tipoLis) {
		this.tipoLis = tipoLis;
	}
	
	
}


