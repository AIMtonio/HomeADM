package operacionesPDA.beanWS.request;

import general.bean.BaseBeanWS;

public class SP_PDA_Ahorros_AbonoRequest extends BaseBeanWS{
	
	private String Num_Socio;
	private String Num_Cta;
	private String Monto;
	private String Fecha_Mov;
	private String Folio_Pda;
	private String Id_Usuario;
	private String Clave;
	private String Dispositivo;
	
	public String getNum_Socio() {
		return Num_Socio;
	}
	public void setNum_Socio(String num_Socio) {
		Num_Socio = num_Socio;
	}
	public String getNum_Cta() {
		return Num_Cta;
	}
	public void setNum_Cta(String num_Cta) {
		Num_Cta = num_Cta;
	}
	public String getMonto() {
		return Monto;
	}
	public void setMonto(String monto) {
		Monto = monto;
	}
	public String getFecha_Mov() {
		return Fecha_Mov;
	}
	public void setFecha_Mov(String fecha_Mov) {
		Fecha_Mov = fecha_Mov;
	}
	public String getFolio_Pda() {
		return Folio_Pda;
	}
	public void setFolio_Pda(String folio_Pda) {
		Folio_Pda = folio_Pda;
	}
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
	public String getDispositivo() {
		return Dispositivo;
	}
	public void setDispositivo(String dispositivo) {
		Dispositivo = dispositivo;
	}
}