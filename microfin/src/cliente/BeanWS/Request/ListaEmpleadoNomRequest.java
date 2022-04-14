package cliente.BeanWS.Request;

import general.bean.BaseBeanWS;

public class ListaEmpleadoNomRequest extends BaseBeanWS {
 private String nombreCompleto;
 private String institNominaID;

 public String getInstitNominaID() {
	return institNominaID;
}
public void setInstitNominaID(String institNominaID) {
	this.institNominaID = institNominaID;
}

public String getNombreCompleto() {
	return nombreCompleto;
}
public void setNombreCompleto(String nombreCompleto) {
	this.nombreCompleto = nombreCompleto;
}
 
	
}

