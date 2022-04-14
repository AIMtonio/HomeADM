package cuentas.bean;

import general.bean.BaseBean;

public class MonedasBean extends BaseBean{
	//Declaracion de Constantes
	public static final int LONGITUD_ID = 3;
	public static final int MONEDA_BASE_LOCAL = 1;
	public static final int MONEDA_BASE_EXTRANJERA = 2;
	
	private String monedaID;
	private String empresaID; 
	private String descripcion; 
	private String descriCorta; 
	private String simbolo;
	
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescriCorta() {
		return descriCorta;
	}
	public void setDescriCorta(String descriCorta) {
		this.descriCorta = descriCorta;
	}
	public String getSimbolo() {
		return simbolo;
	}
	public void setSimbolo(String simbolo) {
		this.simbolo = simbolo;
	}
	
	
}
