package bancaMovil.beanWS.response;

import java.util.List;

import general.bean.BaseBeanWS;

public class TiposOperacionesResponse extends BaseBeanWS {

	private List<TiposOperaciones> listOperationsTypes;
	private String responseCode;
	private String responseMessage;

	public List<TiposOperaciones> getListOperationsTypes() {
		return listOperationsTypes;
	}

	public void setListOperationsTypes(List<TiposOperaciones> listOperationsTypes) {
		this.listOperationsTypes = listOperationsTypes;
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
