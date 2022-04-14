package credito.bean;

import general.bean.BaseBean;

public class ServiciosSolCredBean extends BaseBean {

	// variables 
	private String servicioSolID;
	private String servicioID;
	private String descripcion;
	private String solicitudCreditoID;
	private String creditoID;
	
	// auxiliares sp 
	private String numLis;

	public String getServicioSolID() {
		return servicioSolID;
	}

	public void setServicioSolID(String servicioSolID) {
		this.servicioSolID = servicioSolID;
	}

	public String getServicioID() {
		return servicioID;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public void setServicioID(String servicioID) {
		this.servicioID = servicioID;
	}

	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}

	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}

	public String getCreditoID() {
		return creditoID;
	}

	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}

	public String getNumLis() {
		return numLis;
	}

	public void setNumLis(String numLis) {
		this.numLis = numLis;
	}
	
	
	
}
