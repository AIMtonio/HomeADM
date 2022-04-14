package bancaMovil.beanWS.request;

import general.bean.BaseBeanWS;

public class ModificarParametrosSisRequest extends BaseBeanWS {

	private String companyNumber;
	private String shortNameInstitution;
	private String textCodeActSMS;
	private String vatPaySPEI;
	private String userShippingSPEI;
	private String pathfiles;
	private String subjectNotifNewUser;
	private String subjectNotifChangeOptions;
	private String paymentNotificationMatter;
	private String subjectNotificationSession;
	private String transferNotificationIssue;
	private String timeValidateSMS;
	private String bankSender;
	private String minCharactersPass;
	private String frejaUrl;
	private String transactionTitle;
	private String validityPeriod;
	private String maxWaitTime;
	private String provisionTime;

	public String getCompanyNumber() {
		return companyNumber;
	}

	public void setCompanyNumber(String companyNumber) {
		this.companyNumber = companyNumber;
	}

	public String getShortNameInstitution() {
		return shortNameInstitution;
	}

	public void setShortNameInstitution(String shortNameInstitution) {
		this.shortNameInstitution = shortNameInstitution;
	}

	public String getTextCodeActSMS() {
		return textCodeActSMS;
	}

	public void setTextCodeActSMS(String textCodeActSMS) {
		this.textCodeActSMS = textCodeActSMS;
	}

	public String getVatPaySPEI() {
		return vatPaySPEI;
	}

	public void setVatPaySPEI(String vatPaySPEI) {
		this.vatPaySPEI = vatPaySPEI;
	}

	public String getUserShippingSPEI() {
		return userShippingSPEI;
	}

	public void setUserShippingSPEI(String userShippingSPEI) {
		this.userShippingSPEI = userShippingSPEI;
	}

	public String getPathfiles() {
		return pathfiles;
	}

	public void setPathfiles(String pathfiles) {
		this.pathfiles = pathfiles;
	}

	public String getSubjectNotifNewUser() {
		return subjectNotifNewUser;
	}

	public void setSubjectNotifNewUser(String subjectNotifNewUser) {
		this.subjectNotifNewUser = subjectNotifNewUser;
	}

	public String getSubjectNotifChangeOptions() {
		return subjectNotifChangeOptions;
	}

	public void setSubjectNotifChangeOptions(String subjectNotifChangeOptions) {
		this.subjectNotifChangeOptions = subjectNotifChangeOptions;
	}

	public String getPaymentNotificationMatter() {
		return paymentNotificationMatter;
	}

	public void setPaymentNotificationMatter(String paymentNotificationMatter) {
		this.paymentNotificationMatter = paymentNotificationMatter;
	}

	public String getSubjectNotificationSession() {
		return subjectNotificationSession;
	}

	public void setSubjectNotificationSession(String subjectNotificationSession) {
		this.subjectNotificationSession = subjectNotificationSession;
	}

	public String getTransferNotificationIssue() {
		return transferNotificationIssue;
	}

	public void setTransferNotificationIssue(String transferNotificationIssue) {
		this.transferNotificationIssue = transferNotificationIssue;
	}

	public String getTimeValidateSMS() {
		return timeValidateSMS;
	}

	public void setTimeValidateSMS(String timeValidateSMS) {
		this.timeValidateSMS = timeValidateSMS;
	}

	public String getBankSender() {
		return bankSender;
	}

	public void setBankSender(String bankSender) {
		this.bankSender = bankSender;
	}

	public String getMinCharactersPass() {
		return minCharactersPass;
	}

	public void setMinCharactersPass(String minCharactersPass) {
		this.minCharactersPass = minCharactersPass;
	}

	public String getFrejaUrl() {
		return frejaUrl;
	}

	public void setFrejaUrl(String frejaUrl) {
		this.frejaUrl = frejaUrl;
	}

	public String getTransactionTitle() {
		return transactionTitle;
	}

	public void setTransactionTitle(String transactionTitle) {
		this.transactionTitle = transactionTitle;
	}

	public String getValidityPeriod() {
		return validityPeriod;
	}

	public void setValidityPeriod(String validityPeriod) {
		this.validityPeriod = validityPeriod;
	}

	public String getMaxWaitTime() {
		return maxWaitTime;
	}

	public void setMaxWaitTime(String maxWaitTime) {
		this.maxWaitTime = maxWaitTime;
	}

	public String getProvisionTime() {
		return provisionTime;
	}

	public void setProvisionTime(String provisionTime) {
		this.provisionTime = provisionTime;
	}

}
