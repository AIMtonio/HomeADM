package bancaMovil.beanWS.request;

import soporte.consumo.rest.BaseBeanRequest;

public class ModifySecretQuestionRequest extends BaseBeanRequest {
	private String secretQuestionNumber;
	private String drafting;

	public String getSecretQuestionNumber() {
		return secretQuestionNumber;
	}

	public void setSecretQuestionNumber(String secretQuestionNumber) {
		this.secretQuestionNumber = secretQuestionNumber;
	}

	public String getDrafting() {
		return drafting;
	}

	public void setDrafting(String drafting) {
		this.drafting = drafting;
	}

}
