package soporte.bean;

import java.util.List;

import general.bean.BaseBean;

public class ControlClaveBean extends BaseBean{

	private String clienteID;
	private String anio;
	private String mes;
	private String claveKey;
	private String activo;
	
	//Aux
	private String anioMes;
	private String validaClaveKey;
	private String descMes;
	private List lisMes;
	private List lisClaveKey;
	private String origenDatos;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getClaveKey() {
		return claveKey;
	}
	public void setClaveKey(String claveKey) {
		this.claveKey = claveKey;
	}
	public String getAnioMes() {
		return anioMes;
	}
	public void setAnioMes(String anioMes) {
		this.anioMes = anioMes;
	}
	public String getActivo() {
		return activo;
	}
	public void setActivo(String activo) {
		this.activo = activo;
	}
	public String getValidaClaveKey() {
		return validaClaveKey;
	}
	public void setValidaClaveKey(String validaClaveKey) {
		this.validaClaveKey = validaClaveKey;
	}
	public String getDescMes() {
		return descMes;
	}
	public void setDescMes(String descMes) {
		this.descMes = descMes;
	}
	public List getLisMes() {
		return lisMes;
	}
	public void setLisMes(List lisMes) {
		this.lisMes = lisMes;
	}
	public List getLisClaveKey() {
		return lisClaveKey;
	}
	public void setLisClaveKey(List lisClaveKey) {
		this.lisClaveKey = lisClaveKey;
	}
	public String getOrigenDatos() {
		return origenDatos;
	}
	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
	}
	
}