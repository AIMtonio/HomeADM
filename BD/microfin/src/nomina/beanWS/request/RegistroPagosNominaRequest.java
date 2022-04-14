package nomina.beanWS.request;

import general.bean.BaseBeanWS;

public class RegistroPagosNominaRequest extends BaseBeanWS{
	private String folioCargaID;
	private String folioCargaIDBE;
	private String empresaNominaID;
	private String creditoID;
	private String clienteID;
	private String montoPagos;
	
	public String getEmpresaNominaID() {
		return empresaNominaID;
	}
	public void setEmpresaNominaID(String empresaNominaID) {
		this.empresaNominaID = empresaNominaID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getMontoPagos() {
		return montoPagos;
	}
	public void setMontoPagos(String montoPagos) {
		this.montoPagos = montoPagos;
	}
	public String getFolioCargaIDBE() {
		return folioCargaIDBE;
	}
	public void setFolioCargaIDBE(String folioCargaIDBE) {
		this.folioCargaIDBE = folioCargaIDBE;
	}
	public String getFolioCargaID() {
		return folioCargaID;
	}
	public void setFolioCargaID(String folioCargaID) {
		this.folioCargaID = folioCargaID;
	}	
	
}
