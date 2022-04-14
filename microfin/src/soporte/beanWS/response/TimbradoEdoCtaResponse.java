package soporte.beanWS.response;

import operacionesCRCB.beanWS.response.BaseResponseBean;

public class TimbradoEdoCtaResponse extends BaseResponseBean{
	private String consecutivo;
	private String cfdi;
	private String cadenaOriginalSAT;
	private String noCertificadoSAT;
	private String noCertificadoCFDI;
	private String uuid;
	private String selloSAT;
	private String selloCFDI;
	private String fechaTimbrado;
	private String qrCode;
	

	public String getCfdi() {
		return cfdi;
	}
	public void setCfdi(String cfdi) {
		this.cfdi = cfdi;
	}
	public String getCadenaOriginalSAT() {
		return cadenaOriginalSAT;
	}
	public void setCadenaOriginalSAT(String cadenaOriginalSAT) {
		this.cadenaOriginalSAT = cadenaOriginalSAT;
	}
	public String getNoCertificadoSAT() {
		return noCertificadoSAT;
	}
	public void setNoCertificadoSAT(String noCertificadoSAT) {
		this.noCertificadoSAT = noCertificadoSAT;
	}
	public String getNoCertificadoCFDI() {
		return noCertificadoCFDI;
	}
	public void setNoCertificadoCFDI(String noCertificadoCFDI) {
		this.noCertificadoCFDI = noCertificadoCFDI;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getSelloSAT() {
		return selloSAT;
	}
	public void setSelloSAT(String selloSAT) {
		this.selloSAT = selloSAT;
	}
	public String getSelloCFDI() {
		return selloCFDI;
	}
	public void setSelloCFDI(String selloCFDI) {
		this.selloCFDI = selloCFDI;
	}
	public String getFechaTimbrado() {
		return fechaTimbrado;
	}
	public void setFechaTimbrado(String fechaTimbrado) {
		this.fechaTimbrado = fechaTimbrado;
	}
	public String getQrCode() {
		return qrCode;
	}
	public void setQrCode(String qrCode) {
		this.qrCode = qrCode;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	
	
	
}
