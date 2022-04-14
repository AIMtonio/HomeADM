package bancaMovil.beanWS.request;

import general.bean.BaseBean;

public class ModifyProfileRequest extends BaseBean {

	private String profileNumber;
	private String description;
	private String rolName;

	public String getProfileNumber() {
		return profileNumber;
	}

	public void setProfileNumber(String profileNumber) {
		this.profileNumber = profileNumber;
	}

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
