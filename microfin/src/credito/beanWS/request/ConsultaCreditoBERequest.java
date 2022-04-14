package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaCreditoBERequest extends BaseBeanWS{
	private String creditoID;

	public String getCreditoID() {
		return creditoID;
	}

	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}

}
