package cliente.bean;

import general.bean.BaseBean;

public class IntegraGrupoNosolBean extends BaseBean{
	private String grupoID;
	private String clienteID;
	private String tipoIntegrante;
	private String nombreCompleto;
	private String esMenorEdad;
	private String estatus;
	
	//Auxiliares para el Grid
	private String exigibleDia;
	private String totalDia;
	private String Ahorro;
	private String numIntegrantes;
	
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getTipoIntegrante() {
		return tipoIntegrante;
	}
	public void setTipoIntegrante(String tipoIntegrante) {
		this.tipoIntegrante = tipoIntegrante;
	}
	public String getExigibleDia() {
		return exigibleDia;
	}
	public void setExigibleDia(String exigibleDia) {
		this.exigibleDia = exigibleDia;
	}
	public String getTotalDia() {
		return totalDia;
	}
	public void setTotalDia(String totalDia) {
		this.totalDia = totalDia;
	}
	public String getAhorro() {
		return Ahorro;
	}
	public void setAhorro(String ahorro) {
		Ahorro = ahorro;
	}
	public String getNumIntegrantes() {
		return numIntegrantes;
	}
	public void setNumIntegrantes(String numIntegrantes) {
		this.numIntegrantes = numIntegrantes;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	
	public String getEsMenorEdad() {
		return esMenorEdad;
	}
	public void setEsMenorEdad(String esMenorEdad) {
		this.esMenorEdad = esMenorEdad;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
	
	

}
