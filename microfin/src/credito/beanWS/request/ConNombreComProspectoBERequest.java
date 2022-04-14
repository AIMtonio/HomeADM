package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ConNombreComProspectoBERequest extends BaseBeanWS{
	
	private String prospectoID;
	private String institNominaID;
	private String negocioAfiliadoID;
	private String numCon;

	public String getProspectoID() {
		return prospectoID;
	}

	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
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

	public String getNumCon() {
		return numCon;
	}

	public void setNumCon(String numCon) {
		this.numCon = numCon;
	}

	
	
	

}
