package cuentas.bean;

import general.bean.BaseBean;

public class CuentasMayorAhoBean extends BaseBean{
	private String conceptoAhoID;			
	private String empresaID; 	  
	private String cuenta;
	private String nomenclatura;
	private String nomenclaturaCR;

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
	public String getCuenta() {
		return cuenta;
	}
	public void setCuenta(String cuenta) {
		this.cuenta = cuenta;
	}
	public String getNomenclatura() {
		return nomenclatura;
	}
	public void setNomenclatura(String nomenclatura) {
		this.nomenclatura = nomenclatura;
	}
	public String getNomenclaturaCR() {
		return nomenclaturaCR;
	}
	public void setNomenclaturaCR(String nomenclaturaCR) {
		this.nomenclaturaCR = nomenclaturaCR;
	}
}
