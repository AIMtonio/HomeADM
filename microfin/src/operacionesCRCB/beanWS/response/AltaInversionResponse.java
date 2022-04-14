package operacionesCRCB.beanWS.response;

public class AltaInversionResponse extends BaseResponseBean {

	private String inversionID;
	private String montoISR;
	private String interesGenerado;
	private String interesRecibir;
	private String montoTotal;
	private String fechaVencimiento;

	public String getInversionID() {
		return inversionID;
	}

	public void setInversionID(String inversionID) {
		this.inversionID = inversionID;
	}

	public String getMontoISR() {
		return montoISR;
	}

	public void setMontoISR(String montoISR) {
		this.montoISR = montoISR;
	}

	public String getInteresGenerado() {
		return interesGenerado;
	}

	public void setInteresGenerado(String interesGenerado) {
		this.interesGenerado = interesGenerado;
	}

	public String getInteresRecibir() {
		return interesRecibir;
	}

	public void setInteresRecibir(String interesRecibir) {
		this.interesRecibir = interesRecibir;
	}

	public String getMontoTotal() {
		return montoTotal;
	}

	public void setMontoTotal(String montoTotal) {
		this.montoTotal = montoTotal;
	}

	public String getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	
	
}
