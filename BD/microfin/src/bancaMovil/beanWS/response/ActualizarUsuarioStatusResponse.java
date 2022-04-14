package bancaMovil.beanWS.response;

import general.bean.BaseBeanWS;

public class ActualizarUsuarioStatusResponse extends BaseBeanWS {

	private String responseCode;
	private String responseMessage;
	private String customerNumber;

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

	public String getCustomerNumber() {
		return customerNumber;
	}

	public void setCustomerNumber(String customerNumber) {
		this.customerNumber = customerNumber;
	}

}
