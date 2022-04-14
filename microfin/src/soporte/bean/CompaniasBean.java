package soporte.bean;

import general.bean.BaseBean;

public class CompaniasBean extends BaseBean {
	
	private int 	companiaID;
	private String 	razonSocial;
	private String 	direccionCompleta;
	private String 	origenDatos;
	private String 	prefijo;
	private String 	mostrarPrefijo;
	private String desplegado;
	private String subdominio;
	
	
	public int getCompaniaID() {
		return companiaID;
	}
	public void setCompaniaID(int companiaID) {
		this.companiaID = companiaID;
	}
	public String getRazonSocial() {
		return razonSocial; 
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getDireccionCompleta() {
		return direccionCompleta;
	}
	public void setDireccionCompleta(String direccionCompleta) {
		this.direccionCompleta = direccionCompleta;
	}
	public String getOrigenDatos() {
		return origenDatos;
	}
	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
	}
	public String getPrefijo() {
		return prefijo;
	}
	public void setPrefijo(String prefijo) {
		this.prefijo = prefijo;
	}
	public String getMostrarPrefijo() {
		return mostrarPrefijo;
	}
	public void setMostrarPrefijo(String mostrarPrefijo) {
		this.mostrarPrefijo = mostrarPrefijo;
	}
	public String getDesplegado() {
		return desplegado;
	}
	public void setDesplegado(String desplegado) {
		this.desplegado = desplegado;
	}
	public String getSubdominio() {
		return subdominio;
	}
	public void setSubdominio(String subdominio) {
		this.subdominio = subdominio;
	}

	
	
	
}
