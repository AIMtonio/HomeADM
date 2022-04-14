package operacionesCRCB.bean;

public class ConsultaCedesBean {

	private String CEDEID;
	private String amortizacionID;
	private String fechaInicio;
	private String fechaVencimiento;
	private String fechaPago;
	private String capital;
	private String interes;
	private String interesRetener;
	private String estatus;
	
	
	public String getCEDEID() {
		return CEDEID;
	}
	public void setCEDEID(String cEDEID) {
		CEDEID = cEDEID;
	}
	public String getAmortizacionID() {
		return amortizacionID;
	}
	public void setAmortizacionID(String amortizacionID) {
		this.amortizacionID = amortizacionID;
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
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getInteres() {
		return interes;
	}
	public void setInteres(String interes) {
		this.interes = interes;
	}
	public String getInteresRetener() {
		return interesRetener;
	}
	public void setInteresRetener(String interesRetener) {
		this.interesRetener = interesRetener;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
	
	

}
