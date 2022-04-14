package bancaMovil.beanWS.response;

import general.bean.BaseBeanWS;

import java.util.List;

public class UserListResponse extends BaseBeanWS {

	private List<BanUsuarioRes> usersList;
	private String responseCode;
	private String responseMessage;

	public List<BanUsuarioRes> getUsersList() {
		return usersList;
	}

	public void setUsersList(List<BanUsuarioRes> usersList) {
		this.usersList = usersList;
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
