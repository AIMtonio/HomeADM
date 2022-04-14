package bancaMovil.beanWS.request;

import soporte.consumo.rest.BaseBeanRequest;

public class RegisterAntiphishingImagesRequest extends BaseBeanRequest {
	private String origin;
	private String binaryImage;
	private String description;
	private String status;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getBinaryImage() {
		return binaryImage;
	}

	public void setBinaryImage(String binaryImage) {
		this.binaryImage = binaryImage;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}
