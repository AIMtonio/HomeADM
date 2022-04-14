package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class CreaCreditoRequest extends BaseBeanWS{
	private String 	solicitudCreditoID;
	private String 	cuentaClabe;
	private String 	ajustarFecVen;

	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}

	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}

	public String getCuentaClabe() {
		return cuentaClabe;
	}

	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}

	public String getAjustarFecVen() {
		return ajustarFecVen;
	}

	public void setAjustarFecVen(String ajustarFecVen) {
		this.ajustarFecVen = ajustarFecVen;
	}
	
}