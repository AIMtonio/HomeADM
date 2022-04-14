package cliente.BeanWS.Request;

import general.bean.BaseBeanWS;

public class ListaClientesBERequest extends BaseBeanWS {
	
	private String nombre;
	private String institNominaID;
	private String negocioAfiliadoID;
	private String numLis;
	
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
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
	public String getNumLis() {
		return numLis;
	}
	public void setNumLis(String numLis) {
		this.numLis = numLis;
	}
	
	

}
