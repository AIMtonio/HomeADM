package bancaMovil.beanWS.request;

import psl.rest.BaseBeanRequest;

public class UpdateAntiphishingImagesRequest extends BaseBeanRequest {
	private String origin;
	private String antiphishingImageNumber;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getAntiphishingImageNumber() {
		return antiphishingImageNumber;
	}

	public void setAntiphishingImageNumber(String antiphishingImageNumber) {
		this.antiphishingImageNumber = antiphishingImageNumber;
	}
}
