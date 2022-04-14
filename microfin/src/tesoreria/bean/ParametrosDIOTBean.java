package tesoreria.bean;

import general.bean.BaseBean;

public class ParametrosDIOTBean extends BaseBean{
	
	private String iva;
	private String descripIVA;
	private String retIVA;
	private String descripRetIVA;
	
	
	public String getIva() {
		return iva;
	}
	public void setIva(String iva) {
		this.iva = iva;
	}
	public String getDescripIVA() {
		return descripIVA;
	}
	public void setDescripIVA(String descripIVA) {
		this.descripIVA = descripIVA;
	}
	public String getRetIVA() {
		return retIVA;
	}
	public void setRetIVA(String retIVA) {
		this.retIVA = retIVA;
	}
	public String getDescripRetIVA() {
		return descripRetIVA;
	}
	public void setDescripRetIVA(String descripRetIVA) {
		this.descripRetIVA = descripRetIVA;
	}
		
}