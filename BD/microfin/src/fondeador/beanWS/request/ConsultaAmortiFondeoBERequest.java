package fondeador.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaAmortiFondeoBERequest extends BaseBeanWS{
	
	private String creditoFondeoID;

	public String getCreditoFondeoID() {
		return creditoFondeoID;
	}

	public void setCreditoFondeoID(String creditoFondeoID) {
		this.creditoFondeoID = creditoFondeoID;
	}
	
	

}
