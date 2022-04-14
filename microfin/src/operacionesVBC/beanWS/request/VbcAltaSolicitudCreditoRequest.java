package operacionesVBC.beanWS.request;

import general.bean.BaseBeanWS;

public class VbcAltaSolicitudCreditoRequest extends BaseBeanWS{
	private String operacionID; 
	private String clienteID; 
	private String solicitudCreditoID; 
	private String productoCreditoID; 
	private String fechaRegistro; 
	private String institucionNominaID; 
	private String folioCtrl; 
	private String montoSolici; 
	private String tasaActiva; 
	private String periodicidad; 
	private String plazoID; 
	
	private String usuario;
	private String clave;
	public String getOperacionID() {
		return operacionID;
	}
	public void setOperacionID(String operacionID) {
		this.operacionID = operacionID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getInstitucionNominaID() {
		return institucionNominaID;
	}
	public void setInstitucionNominaID(String institucionNominaID) {
		this.institucionNominaID = institucionNominaID;
	}
	public String getFolioCtrl() {
		return folioCtrl;
	}
	public void setFolioCtrl(String folioCtrl) {
		this.folioCtrl = folioCtrl;
	}
	public String getMontoSolici() {
		return montoSolici;
	}
	public void setMontoSolici(String montoSolici) {
		this.montoSolici = montoSolici;
	}
	public String getTasaActiva() {
		return tasaActiva;
	}
	public void setTasaActiva(String tasaActiva) {
		this.tasaActiva = tasaActiva;
	}
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	
}
