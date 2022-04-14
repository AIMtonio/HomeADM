package cliente.bean;

public class LimiteOperClienteBean {

	private String limiteOperID;
	private String clienteID;
	private String bancaMovil;
	private String monMaxBcaMovil;
	
	//Auxiliar para la la lista de los clientes Registrados
	private String nombreCompleto;
	
	public String getLimiteOperID() {
		return limiteOperID;
	}
	public void setLimiteOperID(String limiteOperID) {
		this.limiteOperID = limiteOperID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getBancaMovil() {
		return bancaMovil;
	}
	public void setBancaMovil(String bancaMovil) {
		this.bancaMovil = bancaMovil;
	}
	public String getMonMaxBcaMovil() {
		return monMaxBcaMovil;
	}
	public void setMonMaxBcaMovil(String monMaxBcaMovil) {
		this.monMaxBcaMovil = monMaxBcaMovil;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}	
	
}
