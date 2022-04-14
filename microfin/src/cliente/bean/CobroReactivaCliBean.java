package cliente.bean;

public class CobroReactivaCliBean {
	private String numero; // Numero del cliente que se reactivara 
	private String montoReactiva; // Monto que pago por la reactivacion del cliente
	private String estatus; // Estatus del pago pr reactivacion 
	private String motivoInactivaID; // Numero de motivo por el cual esta inactivado el cliente

	
	
	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getMontoReactiva() {
		return montoReactiva;
	}
	public void setMontoReactiva(String montoReactiva) {
		this.montoReactiva = montoReactiva;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getMotivoInactivaID() {
		return motivoInactivaID;
	}
	public void setMotivoInactivaID(String motivoInactivaID) {
		this.motivoInactivaID = motivoInactivaID;
	}
	
	
}
