package aportaciones.bean;

import general.bean.BaseBean;

public class AportBeneficiariosBean extends BaseBean {

	private String aportacionID;
	private String amortizacionID;
	private String cuentaTranID;
	private String institucionID;
	private String tipoCuentaSpei;
	private String clabe;
	private String beneficiario;
	private String esPrincipal;
	private String montoDispersion;

	public String getAportacionID() {
		return aportacionID;
	}

	public void setAportacionID(String aportacionID) {
		this.aportacionID = aportacionID;
	}

	public String getAmortizacionID() {
		return amortizacionID;
	}

	public void setAmortizacionID(String amortizacionID) {
		this.amortizacionID = amortizacionID;
	}

	public String getCuentaTranID() {
		return cuentaTranID;
	}

	public void setCuentaTranID(String cuentaTranID) {
		this.cuentaTranID = cuentaTranID;
	}

	public String getInstitucionID() {
		return institucionID;
	}

	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}

	public String getTipoCuentaSpei() {
		return tipoCuentaSpei;
	}

	public void setTipoCuentaSpei(String tipoCuentaSpei) {
		this.tipoCuentaSpei = tipoCuentaSpei;
	}

	public String getClabe() {
		return clabe;
	}

	public void setClabe(String clabe) {
		this.clabe = clabe;
	}

	public String getBeneficiario() {
		return beneficiario;
	}

	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}

	public String getEsPrincipal() {
		return esPrincipal;
	}

	public void setEsPrincipal(String esPrincipal) {
		this.esPrincipal = esPrincipal;
	}

	public String getMontoDispersion() {
		return montoDispersion;
	}

	public void setMontoDispersion(String montoDispersion) {
		this.montoDispersion = montoDispersion;
	}

}