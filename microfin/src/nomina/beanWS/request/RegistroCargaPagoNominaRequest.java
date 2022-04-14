package nomina.beanWS.request;

import general.bean.BaseBeanWS;

public class RegistroCargaPagoNominaRequest extends BaseBeanWS {
	
	private String folioCargaIDBE;
	private String empresaNominaID;
	private String claveUsuarioBE;
	private String numTotalPagos;
	private String numPagosExito;
	private String numPagosError;
	private String montoPagos;
	private String rutaArchivoPagoNom;
	
	public String getClaveUsuarioBE() {
		return claveUsuarioBE;
	}
	public void setClaveUsuarioBE(String claveUsuarioBE) {
		this.claveUsuarioBE = claveUsuarioBE;
	}
	public String getNumTotalPagos() {
		return numTotalPagos;
	}
	public void setNumTotalPagos(String numTotalPagos) {
		this.numTotalPagos = numTotalPagos;
	}
	public String getNumPagosExito() {
		return numPagosExito;
	}
	public void setNumPagosExito(String numPagosExito) {
		this.numPagosExito = numPagosExito;
	}
	public String getNumPagosError() {
		return numPagosError;
	}
	public void setNumPagosError(String numPagosError) {
		this.numPagosError = numPagosError;
	}
	public String getMontoPagos() {
		return montoPagos;
	}
	public void setMontoPagos(String montoPagos) {
		this.montoPagos = montoPagos;
	}
	public String getRutaArchivoPagoNom() {
		return rutaArchivoPagoNom;
	}
	public void setRutaArchivoPagoNom(String rutaArchivoPagoNom) {
		this.rutaArchivoPagoNom = rutaArchivoPagoNom;
	}
	public String getEmpresaNominaID() {
		return empresaNominaID;
	}
	public void setEmpresaNominaID(String empresaNominaID) {
		this.empresaNominaID = empresaNominaID;
	}
	public String getFolioCargaIDBE() {
		return folioCargaIDBE;
	}
	public void setFolioCargaIDBE(String folioCargaIDBE) {
		this.folioCargaIDBE = folioCargaIDBE;
	}
	
}
