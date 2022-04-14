package tesoreria.bean;

import general.bean.BaseBean;

public class RenovacionOrdenPagoBean extends BaseBean{
	private String clienteID;
	private String institucionID;
	private String numCtaInstit;
	private String numOrdenPago;
	private String monto;
	private String fecha;
	private String beneficiario;
	private String estatus;
	private String referencia;
	private String concepto;
	private String motivoRenov;
	
	
	private String institucionIDCan;	
	private String numCtaInstitCan;
	private String numOrdenPagoCan;
	private String beneficiarioCan;
	private String montoCan;
	private String conceptoCan;
	private String fechaCan;
	private String confimaNumOrdenPago;
	private String polizaID;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public String getNumOrdenPago() {
		return numOrdenPago;
	}
	public void setNumOrdenPago(String numOrdenPago) {
		this.numOrdenPago = numOrdenPago;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getBeneficiario() {
		return beneficiario;
	}
	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getMotivoRenov() {
		return motivoRenov;
	}
	public void setMotivoRenov(String motivoRenov) {
		this.motivoRenov = motivoRenov;
	}
	public String getInstitucionIDCan() {
		return institucionIDCan;
	}
	public void setInstitucionIDCan(String institucionIDCan) {
		this.institucionIDCan = institucionIDCan;
	}
	public String getNumCtaInstitCan() {
		return numCtaInstitCan;
	}
	public void setNumCtaInstitCan(String numCtaInstitCan) {
		this.numCtaInstitCan = numCtaInstitCan;
	}
	public String getNumOrdenPagoCan() {
		return numOrdenPagoCan;
	}
	public void setNumOrdenPagoCan(String numOrdenPagoCan) {
		this.numOrdenPagoCan = numOrdenPagoCan;
	}
	public String getBeneficiarioCan() {
		return beneficiarioCan;
	}
	public void setBeneficiarioCan(String beneficiarioCan) {
		this.beneficiarioCan = beneficiarioCan;
	}
	public String getMontoCan() {
		return montoCan;
	}
	public void setMontoCan(String montoCan) {
		this.montoCan = montoCan;
	}
	public String getConceptoCan() {
		return conceptoCan;
	}
	public void setConceptoCan(String conceptoCan) {
		this.conceptoCan = conceptoCan;
	}
	public String getFechaCan() {
		return fechaCan;
	}
	public void setFechaCan(String fechaCan) {
		this.fechaCan = fechaCan;
	}
	public String getConfimaNumOrdenPago() {
		return confimaNumOrdenPago;
	}
	public void setConfimaNumOrdenPago(String confimaNumOrdenPago) {
		this.confimaNumOrdenPago = confimaNumOrdenPago;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}

}
