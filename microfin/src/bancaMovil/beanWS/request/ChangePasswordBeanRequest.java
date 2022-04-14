package bancaMovil.beanWS.request;

import general.bean.BaseBeanWS;

public class ChangePasswordBeanRequest extends BaseBeanWS {
	private String customerNumber;
	private String previousPassword;
	private String newPassword;

	public String getCustomerNumber() {
		return customerNumber;
	}

	public void setCustomerNumber(String customerNumber) {
		this.customerNumber = customerNumber;
	}

	public String getPreviousPassword() {
		return previousPassword;
	}

	public void setPreviousPassword(String previousPassword) {
		this.previousPassword = previousPassword;
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

}
