package bancaMovil.beanWS.request;

import soporte.consumo.rest.BaseBeanRequest;

public class RegisterSecretQuestionRequest extends BaseBeanRequest {

	private String drafting;

	public String getDrafting() {
		return drafting;
	}

	public void setDrafting(String drafting) {
		this.drafting = drafting;
	}

}
