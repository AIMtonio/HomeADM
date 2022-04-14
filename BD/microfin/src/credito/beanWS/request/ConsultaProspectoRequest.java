package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaProspectoRequest extends BaseBeanWS {
	private String prospectoID;
	private String institNominaID;

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

}
