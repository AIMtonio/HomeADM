package cliente.BeanWS.Request;

import general.bean.BaseBeanWS;

public class ConsultaPromotorBERequest extends BaseBeanWS{

	private String institNominaID;
	private String negocioAfiliadoID;

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
	
}
