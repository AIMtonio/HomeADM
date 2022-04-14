package bancaMovil.beanWS.response;

import general.bean.BaseBeanWS;

public class RegisterSecretQuestionResponse extends BaseBeanWS {

	private String responseCode;
	private String responseMessage;
	private String numberSecretQuestion;

	public String getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(String responseCode) {
		this.responseCode = responseCode;
	}

	public String getResponseMessage() {
		return responseMessage;
	}

	public void setResponseMessage(String responseMessage) {
		this.responseMessage = responseMessage;
	}

	public String getNumberSecretQuestion() {
		return numberSecretQuestion;
	}

	public void setNumberSecretQuestion(String numberSecretQuestion) {
		this.numberSecretQuestion = numberSecretQuestion;
	}

}
