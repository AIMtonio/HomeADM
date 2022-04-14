package contabilidad.bean;


import java.util.List;

import general.bean.BaseBean;

public class FrecTimbradoProducBean extends BaseBean{
	
	private String frecuenciaID;
	private String producCreditoID;
	private String descripcion;
	private List lproducCreditoID;
	
	public String getFrecuenciaID() {
		return frecuenciaID;
	}
	public void setFrecuenciaID(String frecuenciaID) {
		this.frecuenciaID = frecuenciaID;
	}
	
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public List getLproducCreditoID() {
		return lproducCreditoID;
	}
	public void setLproducCreditoID(List lproducCreditoID) {
		this.lproducCreditoID = lproducCreditoID;
	}
	
  

}
