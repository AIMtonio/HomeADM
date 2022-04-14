package bancaMovil.beanWS.response;

import soporte.consumo.rest.BaseBeanResponse;

public class ModifyProfileResponse extends BaseBeanResponse {

	private String profileNumber;
	private String responseCode;
	private String responseMessage;

	public String getProfileNumber() {
		return profileNumber;
	}

	public void setProfileNumber(String profileNumber) {
		this.profileNumber = profileNumber;
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
