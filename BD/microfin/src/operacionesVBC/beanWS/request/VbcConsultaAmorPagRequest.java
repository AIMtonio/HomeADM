package operacionesVBC.beanWS.request;

import general.bean.BaseBeanWS;

public class VbcConsultaAmorPagRequest extends BaseBeanWS{

	private String CreditoID;
	private String Usuario;
	private String Clave;
	
	public String getCreditoID() {
		return CreditoID;
	}
	public void setCreditoID(String creditoID) {
		CreditoID = creditoID;
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
