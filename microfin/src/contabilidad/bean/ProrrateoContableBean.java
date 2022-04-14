package contabilidad.bean;

import general.bean.BaseBean;

public class ProrrateoContableBean extends BaseBean{
	private String prorrateoID;
	private String nombreProrrateo;
	private String estatus;
	private String descripcion;
		
	// variables de ayuda para el grid de prorrateo
	private String listaCentros;
	private String porcentajes;
	
	private String centroCostoID;
	private String porcentaje;
	// fin de las variables de ayuda
	

	public String getProrrateoID() {
		return prorrateoID;
	}
	public void setProrrateoID(String prorrateoID) {
		this.prorrateoID = prorrateoID;
	}
	public String getNombreProrrateo() {
		return nombreProrrateo;
	}
	public void setNombreProrrateo(String nombreProrrateo) {
		this.nombreProrrateo = nombreProrrateo;
	}
	public String getEstatus(){
		return estatus;
	}
	public void setEstatus(String estatus){
		this.estatus = estatus;
	}
	public String getDescripcion(){
		return descripcion;
	}
	public void setDescripcion(String descripcion){
		this.descripcion = descripcion;
	}
	public String getListaCentros() {
		return listaCentros;
	}
	public void setListaCentros(String listaCentros) {
		this.listaCentros = listaCentros;
	}
	public String getPorcentajes() {
		return porcentajes;
	}
	public void setPorcentajes(String porcentajes) {
		this.porcentajes = porcentajes;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public String getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}

}
