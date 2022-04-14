package cliente.BeanWS.Response;

public class ConsultaClienteResponse {
	
	private String numero;
	private String nombreCompleto;
	private String rfc;


	private String calificaCredito;

	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}


	public String getCalificaCredito() {
		return calificaCredito;
	}
	public void setCalificaCredito(String calificaCredito) {
		this.calificaCredito = calificaCredito;
	}

	
}
