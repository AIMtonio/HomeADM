package operacionesVBC.beanWS.request;

import general.bean.BaseBeanWS;

public class VbcSimuladorCreditoRequest extends BaseBeanWS{
		
	private String Monto;
	private String Tasa;
	private String Frecuencia;
	private String Periodicidad;
	private String FechaInicio;
	private String NumeroCuotas;
	private String ProductoCreditoID;
	private String ClienteID;
	private String ComisionApertura;
	
	private String Usuario;
	private String Clave;
	
	public String getMonto() {
		return Monto;
	}
	public void setMonto(String monto) {
		Monto = monto;
	}
	public String getTasa() {
		return Tasa;
	}
	public void setTasa(String tasa) {
		Tasa = tasa;
	}
	public String getFrecuencia() {
		return Frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		Frecuencia = frecuencia;
	}
	public String getPeriodicidad() {
		return Periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		Periodicidad = periodicidad;
	}
	public String getFechaInicio() {
		return FechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		FechaInicio = fechaInicio;
	}
	public String getNumeroCuotas() {
		return NumeroCuotas;
	}
	public void setNumeroCuotas(String numeroCuotas) {
		NumeroCuotas = numeroCuotas;
	}
	public String getProductoCreditoID() {
		return ProductoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		ProductoCreditoID = productoCreditoID;
	}
	public String getClienteID() {
		return ClienteID;
	}
	public void setClienteID(String clienteID) {
		ClienteID = clienteID;
	}
	public String getComisionApertura() {
		return ComisionApertura;
	}
	public void setComisionApertura(String comisionApertura) {
		ComisionApertura = comisionApertura;
	}
	public String getUsuario() {
		return Usuario;
	}
	public void setUsuario(String usuario) {
		Usuario = usuario;
	}
	public String getClave() {
		return Clave;
	}
	public void setClave(String clave) {
		Clave = clave;
	}
}
