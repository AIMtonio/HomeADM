package cuentas.bean;

import general.bean.BaseBean;

public class SubCtaRendiAhoBean extends BaseBean{
	private String conceptoAhoID;
	private String empresaID;
	private String paga;
	private String noPaga;
	
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
	public String getPaga() {
		return paga;
	}
	public void setPaga(String paga) {
		this.paga = paga;
	}
	public String getNoPaga() {
		return noPaga;
	}
	public void setNoPaga(String noPaga) {
		this.noPaga = noPaga;
	}
}
