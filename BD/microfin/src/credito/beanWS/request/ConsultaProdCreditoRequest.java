package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaProdCreditoRequest extends BaseBeanWS {
	private String producCreditoID;
	private String perfilID;

	public String getProducCreditoID() {
		return producCreditoID;
	}

	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}

	public String getPerfilID() {
		return perfilID;
	}

	public void setPerfilID(String perfilID) {
		this.perfilID = perfilID;
	}

	
}
