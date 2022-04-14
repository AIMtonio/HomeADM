package bancaMovil.beanWS.request;

import soporte.consumo.rest.BaseBeanRequest;

public class RegisterProfileRequest extends BaseBeanRequest {

	private String description;
	private String rolName;

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getRolName() {
		return rolName;
	}

	public void setRolName(String rolName) {
		this.rolName = rolName;
	}

}
