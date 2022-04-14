package credito.beanWS.response;

public class ConsultaActividadCreditoResponse {
	private String activosTotal;
	private String totalPrestado;
	private String saldoActual;
	private String pesosenMora;
	private String moraMayor;
	private String quebrantos; // 7 años
	private String pagosPuntuales;
	private String pagosRealizados;
	private String moraMenorTreintaDias;
	private String moraMayorTreintaDias;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	public String getActivosTotal() {
		return activosTotal;
	}
	public void setActivosTotal(String activosTotal) {
		this.activosTotal = activosTotal;
	}
	public String getTotalPrestado() {
		return totalPrestado;
	}
	public void setTotalPrestado(String totalPrestado) {
		this.totalPrestado = totalPrestado;
	}
	public String getSaldoActual() {
		return saldoActual;
	}
	public void setSaldoActual(String saldoActual) {
		this.saldoActual = saldoActual;
	}
	public String getPesosenMora() {
		return pesosenMora;
	}
	public void setPesosenMora(String pesosenMora) {
		this.pesosenMora = pesosenMora;
	}
	public String getMoraMayor() {
		return moraMayor;
	}
	public void setMoraMayor(String moraMayor) {
		this.moraMayor = moraMayor;
	}
	public String getQuebrantos() {
		return quebrantos;
	}
	public void setQuebrantos(String quebrantos) {
		this.quebrantos = quebrantos;
	}
	public String getPagosPuntuales() {
		return pagosPuntuales;
	}
	public void setPagosPuntuales(String pagosPuntuales) {
		this.pagosPuntuales = pagosPuntuales;
	}
	public String getPagosRealizados() {
		return pagosRealizados;
	}
	public void setPagosRealizados(String pagosRealizados) {
		this.pagosRealizados = pagosRealizados;
	}
	public String getMoraMenorTreintaDias() {
		return moraMenorTreintaDias;
	}
	public void setMoraMenorTreintaDias(String moraMenorTreintaDias) {
		this.moraMenorTreintaDias = moraMenorTreintaDias;
	}
	public String getMoraMayorTreintaDias() {
		return moraMayorTreintaDias;
	}
	public void setMoraMayorTreintaDias(String moraMayorTreintaDias) {
		this.moraMayorTreintaDias = moraMayorTreintaDias;
	}
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
}
