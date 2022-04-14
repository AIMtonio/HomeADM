package cliente.BeanWS.Response;

import general.bean.BaseBeanWS;

public class ConsultaPromotorBEResponse extends BaseBeanWS{
	private String promotorID;
	private String nombrePromotor;
	private String telefono;
	
	
	public String getPromotorID() {
		return promotorID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	

}
