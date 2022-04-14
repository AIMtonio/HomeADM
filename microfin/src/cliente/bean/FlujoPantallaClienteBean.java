package cliente.bean;

import general.bean.BaseBean;

public class FlujoPantallaClienteBean extends BaseBean{
	private String tipoFlujoID;
	private String tipoPersonaID;
	private int orden;
	private String recurso;
	private String desplegado;
	// variables para la lista
	private String identificador;
	//auxiliar para SAFILOCALE
	private String nomCortoInstitucion;
	public String getTipoFlujoID() {
		return tipoFlujoID;
	}
	public void setTipoFlujoID(String tipoFlujoID) {
		this.tipoFlujoID = tipoFlujoID;
	}
	public String getTipoPersonaID() {
		return tipoPersonaID;
	}
	public void setTipoPersonaID(String tipoPersonaID) {
		this.tipoPersonaID = tipoPersonaID;
	}

	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	public String getDesplegado() {
		return desplegado;
	}
	public void setDesplegado(String desplegado) {
		this.desplegado = desplegado;
	}
	public String getIdentificador() {
		return identificador;
	}
	public void setIdentificador(String identificador) {
		this.identificador = identificador;
	}
	public int getOrden() {
		return orden;
	}
	public void setOrden(int orden) {
		this.orden = orden;
	}
	public String getNomCortoInstitucion() {
		return nomCortoInstitucion;
	}
	public void setNomCortoInstitucion(String nomCortoInstitucion) {
		this.nomCortoInstitucion = nomCortoInstitucion;
	}	 
}