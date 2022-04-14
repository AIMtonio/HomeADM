package bancaMovil.beanWS.request;

import psl.rest.BaseBeanRequest;

public class RegisterUserRequest extends BaseBeanRequest {

	private String customerNumber;
	private String phone;
	private String email;
	private String secretQuestionAnswer;
	private String profileNumber;
	private String secretQuestionNumber;
	private String welcomePhrase;
	private String keyUser;
	private String password;
	private String firstName;
	private String secondName;
	private String surname;
	private String secondSurname;
	private String fullName;
	private String imagenAntiphi;
	private String imei;
	private String origin;
	private String webBankingServ;
	private String mobileBankingServ;

	public String getCustomerNumber() {
		return customerNumber;
	}

	public void setCustomerNumber(String customerNumber) {
		this.customerNumber = customerNumber;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getSecretQuestionAnswer() {
		return secretQuestionAnswer;
	}

	public void setSecretQuestionAnswer(String secretQuestionAnswer) {
		this.secretQuestionAnswer = secretQuestionAnswer;
	}

	public String getProfileNumber() {
		return profileNumber;
	}

	public void setProfileNumber(String profileNumber) {
		this.profileNumber = profileNumber;
	}

	public String getSecretQuestionNumber() {
		return secretQuestionNumber;
	}

	public void setSecretQuestionNumber(String secretQuestionNumber) {
		this.secretQuestionNumber = secretQuestionNumber;
	}

	public String getWelcomePhrase() {
		return welcomePhrase;
	}

	public void setWelcomePhrase(String welcomePhrase) {
		this.welcomePhrase = welcomePhrase;
	}

	public String getKeyUser() {
		return keyUser;
	}

	public void setKeyUser(String keyUser) {
		this.keyUser = keyUser;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getSecondName() {
		return secondName;
	}

	public void setSecondName(String secondName) {
		this.secondName = secondName;
	}

	public String getSurname() {
		return surname;
	}

	public void setSurname(String surname) {
		this.surname = surname;
	}

	public String getSecondSurname() {
		return secondSurname;
	}

	public void setSecondSurname(String secondSurname) {
		this.secondSurname = secondSurname;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getImagenAntiphi() {
		return imagenAntiphi;
	}

	public void setImagenAntiphi(String imagenAntiphi) {
		this.imagenAntiphi = imagenAntiphi;
	}

	public String getImei() {
		return imei;
	}

	public void setImei(String imei) {
		this.imei = imei;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getWebBankingServ() {
		return webBankingServ;
	}

	public void setWebBankingServ(String webBankingServ) {
		this.webBankingServ = webBankingServ;
	}

	public String getMobileBankingServ() {
		return mobileBankingServ;
	}

	public void setMobileBankingServ(String mobileBankingServ) {
		this.mobileBankingServ = mobileBankingServ;
	}

}
