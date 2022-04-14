package cuentas.bean;

import general.bean.BaseBean;

public class SubCtaTiPerAhoBean extends BaseBean {
	private String conceptoAhoID;
	private String empresaID;
	private String fisica;
	private String moral;
	
	public String getConceptoAhoID() {
		return conceptoAhoID;
	}
	public void setConceptoAhoID(String conceptoAhoID) {
		this.conceptoAhoID = conceptoAhoID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getFisica() {
		return fisica;
	}
	public void setFisica(String fisica) {
		this.fisica = fisica;
	}
	public String getMoral() {
		return moral;
	}
	public void setMoral(String moral) {
		this.moral = moral;
	}
}
