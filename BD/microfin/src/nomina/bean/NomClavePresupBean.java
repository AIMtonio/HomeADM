package nomina.bean;

import general.bean.BaseBean;

public class NomClavePresupBean extends BaseBean{

	private String nomClavePresupID;
	private String tipoClavePresupID;
	private String clave;				
	private String descripcion;
	private String nomClasifClavPresupID;

	private String descripClasifClave;
	private String estatus;
	private String nomClavesPresupID;
	private String prioridad;
	
	private String[] clavesPresupID;
	private String[] tiposClavePresupID;
	private String[] desClavePresup;
	private String[] clavePresup;
	
	private String[] nomClavePresupBajID;
	private String[] nomClavePresupModID;

	public String getNomClavePresupID() {
		return nomClavePresupID;
	}
	public void setNomClavePresupID(String nomClavePresupID) {
		this.nomClavePresupID = nomClavePresupID;
	}
	public String getTipoClavePresupID() {
		return tipoClavePresupID;
	}
	public void setTipoClavePresupID(String tipoClavePresupID) {
		this.tipoClavePresupID = tipoClavePresupID;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getNomClasifClavPresupID() {
		return nomClasifClavPresupID;
	}
	public void setNomClasifClavPresupID(String nomClasifClavPresupID) {
		this.nomClasifClavPresupID = nomClasifClavPresupID;
	}
	public String getDescripClasifClave() {
		return descripClasifClave;
	}
	public void setDescripClasifClave(String descripClasifClave) {
		this.descripClasifClave = descripClasifClave;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getNomClavesPresupID() {
		return nomClavesPresupID;
	}
	public void setNomClavesPresupID(String nomClavesPresupID) {
		this.nomClavesPresupID = nomClavesPresupID;
	}
	public String getPrioridad() {
		return prioridad;
	}
	public void setPrioridad(String prioridad) {
		this.prioridad = prioridad;
	}
	public String[] getClavesPresupID() {
		return clavesPresupID;
	}
	public void setClavesPresupID(String[] clavesPresupID) {
		this.clavesPresupID = clavesPresupID;
	}
	public String[] getTiposClavePresupID() {
		return tiposClavePresupID;
	}
	public void setTiposClavePresupID(String[] tiposClavePresupID) {
		this.tiposClavePresupID = tiposClavePresupID;
	}
	public String[] getDesClavePresup() {
		return desClavePresup;
	}
	public void setDesClavePresup(String[] desClavePresup) {
		this.desClavePresup = desClavePresup;
	}
	public String[] getClavePresup() {
		return clavePresup;
	}
	public void setClavePresup(String[] clavePresup) {
		this.clavePresup = clavePresup;
	}
	public String[] getNomClavePresupBajID() {
		return nomClavePresupBajID;
	}
	public void setNomClavePresupBajID(String[] nomClavePresupBajID) {
		this.nomClavePresupBajID = nomClavePresupBajID;
	}
	public String[] getNomClavePresupModID() {
		return nomClavePresupModID;
	}
	public void setNomClavePresupModID(String[] nomClavePresupModID) {
		this.nomClavePresupModID = nomClavePresupModID;
	}
}
