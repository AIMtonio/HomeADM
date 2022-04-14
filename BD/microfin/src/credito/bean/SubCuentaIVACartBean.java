package credito.bean;

import general.bean.BaseBean;

public class SubCuentaIVACartBean extends BaseBean{
	private String conceptoCartID;
	private String porcentaje;
	private String subCuenta;
	
	public String getConceptoCartID() {
		return conceptoCartID;
	}
	public void setConceptoCartID(String conceptoCartID) {
		this.conceptoCartID = conceptoCartID;
	}
	public String getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}
	public String getSubCuenta() {
		return subCuenta;
	}
	public void setSubCuenta(String subCuenta) {
		this.subCuenta = subCuenta;
	}
}