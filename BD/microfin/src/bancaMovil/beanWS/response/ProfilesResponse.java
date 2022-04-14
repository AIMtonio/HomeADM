package bancaMovil.beanWS.response;

import java.util.List;

import general.bean.BaseBeanWS;

public class ProfilesResponse extends BaseBeanWS {

	private List<Perfil> listProfiles;
	private String responseCode;
	private String responseMessage;

	public List<Perfil> getListProfiles() {
		return listProfiles;
	}

	public void setListProfiles(List<Perfil> listProfiles) {
		this.listProfiles = listProfiles;
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
