package fondeador.bean;

import general.bean.BaseBean;

public class CuentasMayorCreditoPasBean extends BaseBean{
	private String conceptoFondID;
	private String tipoFondeador;
	private String conceptoFonID;	
	private String empresaID; 	  
	private String cuenta;
	private String nomenclatura;
	private String nomenclaturaCR;

  
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
	public String getConceptoFonID() {
		return conceptoFonID;
	}
	public void setConceptoFonID(String conceptoFonID) {
		this.conceptoFonID = conceptoFonID;
	}
	public String getConceptoFondID() {
		return conceptoFondID;
	}
	public void setConceptoFondID(String conceptoFondID) {
		this.conceptoFondID = conceptoFondID;
	}
	public String getTipoFondeador() {
		return tipoFondeador;
	}
	public void setTipoFondeador(String tipoFondeador) {
		this.tipoFondeador = tipoFondeador;
	}

}
