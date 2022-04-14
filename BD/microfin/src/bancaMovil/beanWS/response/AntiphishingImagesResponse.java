package bancaMovil.beanWS.response;

import java.util.List;

import general.bean.BaseBeanWS;

public class AntiphishingImagesResponse extends BaseBeanWS {

	private List<AntiphishingImage> listAntiphishingImage;
	private String responseCode;
	private String responseMessage;

	public List<AntiphishingImage> getListAntiphishingImage() {
		return listAntiphishingImage;
	}

	public void setListAntiphishingImage(List<AntiphishingImage> listAntiphishingImage) {
		this.listAntiphishingImage = listAntiphishingImage;
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
