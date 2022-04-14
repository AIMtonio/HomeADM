package operacionesPDA.beanWS.request;

import general.bean.BaseBeanWS;

public class SP_SMSAP_Usuario_ValidarRequest extends BaseBeanWS{
		
	private String Id_Usuario;
	private String Clave;
	public String getId_Usuario() {
		return Id_Usuario;
	}
	public void setId_Usuario(String id_Usuario) {
		Id_Usuario = id_Usuario;
	}
	public String getClave() {
		return Clave;
	}
	public void setClave(String clave) {
		Clave = clave;
	}
	
}
