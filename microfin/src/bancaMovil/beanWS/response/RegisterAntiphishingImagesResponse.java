package bancaMovil.beanWS.response;

import general.bean.BaseBeanWS;

public class RegisterAntiphishingImagesResponse extends BaseBeanWS {
	private String consecutive;
	private String responseCode;
	private String responseMessage;

	public String getConsecutive() {
		return consecutive;
	}

	public void setConsecutive(String consecutive) {
		this.consecutive = consecutive;
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
