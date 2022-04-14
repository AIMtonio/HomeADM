package WSVSNATGAS.request;

public class CreacionCredBeanRequest {
	private String placa;
	private String numero_credito;
	private double recaudo;
	private double plazo;
	private String vin;
	
	public String getPlaca() {
		return placa;
	}
	public void setPlaca(String placa) {
		this.placa = placa;
	}
	public String getNumero_credito() {
		return numero_credito;
	}
	public void setNumero_credito(String numero_credito) {
		this.numero_credito = numero_credito;
	}
	public double getRecaudo() {
		return recaudo;
	}
	public void setRecaudo(double recaudo) {
		this.recaudo = recaudo;
	}
	public double getPlazo() {
		return plazo;
	}
	public void setPlazo(double plazo) {
		this.plazo = plazo;
	}
	public String getVin() {
		return vin;
	}
	public void setVin(String vin) {
		this.vin = vin;
	}
}
