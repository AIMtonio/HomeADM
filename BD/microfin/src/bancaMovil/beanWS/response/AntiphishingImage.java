package bancaMovil.beanWS.response;

public class AntiphishingImage {

	private String antiphishingImageNumber;
	private String binaryImage;
	private String description;
	private String status;

	public String getAntiphishingImageNumber() {
		return antiphishingImageNumber;
	}

	public void setAntiphishingImageNumber(String antiphishingImageNumber) {
		this.antiphishingImageNumber = antiphishingImageNumber;
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
