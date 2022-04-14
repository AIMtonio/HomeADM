package pld.bean;

import general.bean.BaseBean;

public class NivelesRiesgoBean extends BaseBean{
	private String nivelRiesgoID;
	private String descripcion;
	private String minimo;
	private String maximo;
	private String seEscala;
	private String estatus;
	private String listaNivelesPLD;
	private String tipoPersona;
	private String tipoConsulta;
	
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getListaNivelesPLD() {
		return listaNivelesPLD;
	}
	public void setListaNivelesPLD(String listaNivelesPLD) {
		this.listaNivelesPLD = listaNivelesPLD;
	}
	public String getNivelRiesgoID() {
		return nivelRiesgoID;
	}
	public void setNivelRiesgoID(String nivelRiesgoID) {
		this.nivelRiesgoID = nivelRiesgoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getMinimo() {
		return minimo;
	}
	public void setMinimo(String minimo) {
		this.minimo = minimo;
	}
	public String getMaximo() {
		return maximo;
	}
	public void setMaximo(String maximo) {
		this.maximo = maximo;
	}
	public String getSeEscala() {
		return seEscala;
	}
	public void setSeEscala(String seEscala) {
		this.seEscala = seEscala;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getTipoConsulta() {
		return tipoConsulta;
	}
	public void setTipoConsulta(String tipoConsulta) {
		this.tipoConsulta = tipoConsulta;
	}
}
