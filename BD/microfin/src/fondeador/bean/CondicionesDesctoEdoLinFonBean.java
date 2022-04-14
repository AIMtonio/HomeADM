package fondeador.bean;

import java.util.List;

import general.bean.BaseBean;

public class CondicionesDesctoEdoLinFonBean extends BaseBean { 
	// tabla LINFONCONDEDO
	
	private String lineaFondeoIDEdo;
	private String estadoID; 
	private String municipioID; 
	private String localidadID; 
	private String numHabitantesInf;
	private String numHabitantesSup;
	
	private List listaEstadoID;
	private List listaMunicipioID;
	private List listaLocalidadID; 


	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private long numTransaccion;
	
	public String getLineaFondeoIDEdo() {
		return lineaFondeoIDEdo;
	}
	public void setLineaFondeoIDEdo(String lineaFondeoIDEdo) {
		this.lineaFondeoIDEdo = lineaFondeoIDEdo;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getLocalidadID() {
		return localidadID;
	}
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public long getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(long numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public List getListaEstadoID() {
		return listaEstadoID;
	}
	public void setListaEstadoID(List listaEstadoID) {
		this.listaEstadoID = listaEstadoID;
	}
	public List getListaMunicipioID() {
		return listaMunicipioID;
	}
	public void setListaMunicipioID(List listaMunicipioID) {
		this.listaMunicipioID = listaMunicipioID;
	}
	public List getListaLocalidadID() {
		return listaLocalidadID;
	}
	public void setListaLocalidadID(List listaLocalidadID) {
		this.listaLocalidadID = listaLocalidadID;
	}
	public String getNumHabitantesInf() {
		return numHabitantesInf;
	}
	public String getNumHabitantesSup() {
		return numHabitantesSup;
	}
	public void setNumHabitantesInf(String numHabitantesInf) {
		this.numHabitantesInf = numHabitantesInf;
	}
	public void setNumHabitantesSup(String numHabitantesSup) {
		this.numHabitantesSup = numHabitantesSup;
	}

}
