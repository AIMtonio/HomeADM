package credito.bean;

import general.bean.BaseBean;

public class SeguroVidaBean extends BaseBean {
	//Constantes
	public static String Estatus_Inactivo = "I";
	public static String Estatus_Vigente = "V";
	public static String Estatus_Cobrado = "C";
	public static String Requiere_Seguro_SI = "S";
	
	//Variables o Atributos
	String seguroVidaID;
	String clienteID;
	String cuentaAhoID;
	String creditoID;
	String solicitudCreditoID;
	String fechaInicio;
	String fechaVencimiento;
	String estatus;
	String beneficiario;
	String direccionBeneficiario;
	String relacionBeneficiario;
	String descriRelacionBeneficiario;
	String montoPoliza;
	String forCobroSegVida;
	
	String monedaID;
	String productoCreditoID;
	public String getSeguroVidaID() {
		return seguroVidaID;
	}
	public void setSeguroVidaID(String seguroVidaID) {
		this.seguroVidaID = seguroVidaID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}	
	
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getBeneficiario() {
		return beneficiario;
	}
	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}
	public String getDireccionBeneficiario() {
		return direccionBeneficiario;
	}
	public void setDireccionBeneficiario(String direccionBeneficiario) {
		this.direccionBeneficiario = direccionBeneficiario;
	}
	public String getRelacionBeneficiario() {
		return relacionBeneficiario;
	}
	public void setRelacionBeneficiario(String relacionBeneficiario) {
		this.relacionBeneficiario = relacionBeneficiario;
	}
	public String getDescriRelacionBeneficiario() {
		return descriRelacionBeneficiario;
	}
	public void setDescriRelacionBeneficiario(String descriRelacionBeneficiario) {
		this.descriRelacionBeneficiario = descriRelacionBeneficiario;
	}
	public String getMontoPoliza() {
		return montoPoliza;
	}
	public void setMontoPoliza(String montoPoliza) {
		this.montoPoliza = montoPoliza;
	}
	public String getForCobroSegVida() {
		return forCobroSegVida;
	}
	public void setForCobroSegVida(String forCobroSegVida) {
		this.forCobroSegVida = forCobroSegVida;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	
	
	
}
