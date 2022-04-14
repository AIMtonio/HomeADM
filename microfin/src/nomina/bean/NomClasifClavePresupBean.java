package nomina.bean;

import general.bean.BaseBean;

public class NomClasifClavePresupBean  extends BaseBean{
	
	private String nomClasifClavPresupID;	
	private String descripcion;				
	private String estatus;					
	private String prioridad;				
	private String nomClavePresupID;
	
	private String institNominaID;
	private String convenioNominaID;
	private String clave;
	private String descClasifClavPresup;
	
	public String getNomClasifClavPresupID() {
		return nomClasifClavPresupID;
	}
	public void setNomClasifClavPresupID(String nomClasifClavPresupID) {
		this.nomClasifClavPresupID = nomClasifClavPresupID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getPrioridad() {
		return prioridad;
	}
	public void setPrioridad(String prioridad) {
		this.prioridad = prioridad;
	}
	public String getNomClavePresupID() {
		return nomClavePresupID;
	}
	public void setNomClavePresupID(String nomClavePresupID) {
		this.nomClavePresupID = nomClavePresupID;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getDescClasifClavPresup() {
		return descClasifClavPresup;
	}
	public void setDescClasifClavPresup(String descClasifClavPresup) {
		this.descClasifClavPresup = descClasifClavPresup;
	}
	
}
