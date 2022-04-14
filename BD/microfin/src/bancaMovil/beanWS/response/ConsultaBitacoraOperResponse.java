package bancaMovil.beanWS.response;

import general.bean.BaseBeanWS;

import java.util.List;

public class ConsultaBitacoraOperResponse extends BaseBeanWS {

	private List<BanBitacoraOper> listOperationsLog;
	private String responseCode;
	private String responseMessage;

	public List<BanBitacoraOper> getListOperationsLog() {
		return listOperationsLog;
	}

	public void setListOperationsLog(List<BanBitacoraOper> listOperationsLog) {
		this.listOperationsLog = listOperationsLog;
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
