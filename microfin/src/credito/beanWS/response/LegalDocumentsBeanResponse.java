package credito.beanWS.response;

import general.bean.BaseBeanResponseWS;

public class LegalDocumentsBeanResponse extends BaseBeanResponseWS {

	private String document;
	private String responseCode;
	private String responseMessage;

	public String getDocument() {
		return document;
	}

	public void setDocument(String document) {
		this.document = document;
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
