package cliente.BeanWS.Request;

import general.bean.BaseBeanWS;

public class ConsultaEstatusEmpRequest extends BaseBeanWS {
	private String institNominaID;
	private String clienteID;
	
	public String getInstitNominaID() {
		return institNominaID;
	}

	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	

}
