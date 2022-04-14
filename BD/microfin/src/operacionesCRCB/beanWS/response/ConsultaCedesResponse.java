package operacionesCRCB.beanWS.response;

public class ConsultaCedesResponse extends BaseResponseBean{

	private String CEDEID;
	private String capital;
	private String fechaInicio;
	private String fechaVencimiento;
	private String fechaPago;
	private String interes;
	private String interesRetener;
	private String tasa;
	private String tasaISR;
	private String GATReal;
	private String plazo;
	private String estatus;
	
	
	public String getCEDEID() {
		return CEDEID;
	}
	public void setCEDEID(String cEDEID) {
		CEDEID = cEDEID;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
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
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	public String getTasaISR() {
		return tasaISR;
	}
	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}
	
	public String getGATReal() {
		return GATReal;
	}
	public void setGATReal(String gATReal) {
		GATReal = gATReal;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
	
	

}
