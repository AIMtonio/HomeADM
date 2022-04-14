package nomina.bean;

import general.bean.BaseBean;

public class CargaPagoErrorBean  extends BaseBean{
	  private String folioErrorID;
	  private String folioCargaID;
	  private String institNominaID;
	  private String descripcionError;
	  private String creditoID;
	  
	  
	public String getFolioErrorID() {
		return folioErrorID;
	}
	public void setFolioErrorID(String folioErrorID) {
		this.folioErrorID = folioErrorID;
	}
	public String getFolioCargaID() {
		return folioCargaID;
	}
	public void setFolioCargaID(String folioCargaID) {
		this.folioCargaID = folioCargaID;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getDescripcionError() {
		return descripcionError;
	}
	public void setDescripcionError(String descripcionError) {
		this.descripcionError = descripcionError;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	
	
}