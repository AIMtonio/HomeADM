package cliente.BeanWS.Request;

import general.bean.BaseBeanWS;

public class ModificaIdentificacionRequest extends BaseBeanWS{
	public String  numEmpleado;
	private String IdentificID;
	private String tipoIdentID;
	private String oficial;
	private String folio;
	private String fechaExpIden;
	private String fechaVenIden;
		

	public String getNumEmpleado() {
		return numEmpleado;
	}

	public void setNumEmpleado(String numEmpleado) {
		this.numEmpleado = numEmpleado;
	}

	public String getFolio() {
		return folio;
	}

	public String getFechaExpIden() {
		return fechaExpIden;
	}

	public String getFechaVenIden() {
		return fechaVenIden;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public void setFechaExpIden(String fechaExpIden) {
		this.fechaExpIden = fechaExpIden;
	}

	public void setFechaVenIden(String fechaVenIden) {
		this.fechaVenIden = fechaVenIden;
	}

	public String getIdentificID() {
		return IdentificID;
	}

	public String getTipoIdentID() {
		return tipoIdentID;
	}

	public String getOficial() {
		return oficial;
	}

	public void setIdentificID(String identificID) {
		IdentificID = identificID;
	}

	public void setTipoIdentID(String tipoIdentID) {
		this.tipoIdentID = tipoIdentID;
	}

	public void setOficial(String oficial) {
		this.oficial = oficial;
	}


	
	

}
