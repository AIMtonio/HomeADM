package bancaMovil.beanWS.response;

import java.util.List;

import general.bean.BaseBeanWS;

public class SecretQuestionsResponse extends BaseBeanWS {

	private List<SecretQuestion> listSecretQuestions;
	private String responseCode;
	private String responseMessage;

	public List<SecretQuestion> getListSecretQuestions() {
		return listSecretQuestions;
	}

	public void setListSecretQuestions(List<SecretQuestion> listSecretQuestions) {
		this.listSecretQuestions = listSecretQuestions;
	}

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

}
