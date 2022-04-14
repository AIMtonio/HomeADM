package cliente.BeanWS.Request;

public class ConsultaNomClienteBERequest {
	private String clienteID;
	private String institNominaID;
	private String negocioAfiliadoID;
	private String numCon;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getNegocioAfiliadoID() {
		return negocioAfiliadoID;
	}
	public void setNegocioAfiliadoID(String negocioAfiliadoID) {
		this.negocioAfiliadoID = negocioAfiliadoID;
	}
	public String getNumCon() {
		return numCon;
	}
	public void setNumCon(String numCon) {
		this.numCon = numCon;
	}
	
	
}
