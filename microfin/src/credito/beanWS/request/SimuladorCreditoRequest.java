package credito.beanWS.request;

public class SimuladorCreditoRequest {
	private String monto;				
	private String tasa;			
	private String frecuencia;
	private String periodicidad;				
	private String fechaInicio;	
	private String numeroCuotas;	
	private String productoCreditoID;		
	private String clienteID;		
	private String comisionApertura;
	
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getNumeroCuotas() {
		return numeroCuotas;
	}
	public void setNumeroCuotas(String numeroCuotas) {
		this.numeroCuotas = numeroCuotas;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getComisionApertura() {
		return comisionApertura;
	}
	public void setComisionApertura(String comisionApertura) {
		this.comisionApertura = comisionApertura;
	}
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}			

}
