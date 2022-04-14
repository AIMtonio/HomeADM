package nomina.bean;

import general.bean.BaseBean;

public class NomClavesConvenioBean extends BaseBean{

	private String nomClaveConvenioID;
	private String institNominaID;
	private String convenioID;
	private String nomClavePresupID;
	private String descripcion;
	private String clavesPresupuestales;
	
	private String nomClasifClavPresupID;
	private String prioridad;
	
	public String getNomClaveConvenioID() {
		return nomClaveConvenioID;
	}
	public void setNomClaveConvenioID(String nomClaveConvenioID) {
		this.nomClaveConvenioID = nomClaveConvenioID;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getConvenioID() {
		return convenioID;
	}
	public void setConvenioID(String convenioID) {
		this.convenioID = convenioID;
	}
	public String getNomClavePresupID() {
		return nomClavePresupID;
	}
	public void setNomClavePresupID(String nomClavePresupID) {
		this.nomClavePresupID = nomClavePresupID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getClavesPresupuestales() {
		return clavesPresupuestales;
	}
	public void setClavesPresupuestales(String clavesPresupuestales) {
		this.clavesPresupuestales = clavesPresupuestales;
	}
	public String getNomClasifClavPresupID() {
		return nomClasifClavPresupID;
	}
	public void setNomClasifClavPresupID(String nomClasifClavPresupID) {
		this.nomClasifClavPresupID = nomClasifClavPresupID;
	}
	public String getPrioridad() {
		return prioridad;
	}
	public void setPrioridad(String prioridad) {
		this.prioridad = prioridad;
	}
	
	
	
}
