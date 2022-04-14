package operacionesPDA.beanWS.request;

import general.bean.BaseBeanWS;

public class SP_PDA_Usuario_ValidarRequest extends BaseBeanWS{
	private String Id_Usuario;
	private String Clave;
	private String Id_Sucursal;
	private String Dispositivo;
	
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
	public String getId_Sucursal() {
		return Id_Sucursal;
	}
	public void setId_Sucursal(String id_Sucursal) {
		Id_Sucursal = id_Sucursal;
	}
	public String getDispositivo() {
		return Dispositivo;
	}
	public void setDispositivo(String dispositivo) {
		Dispositivo = dispositivo;
	}
}