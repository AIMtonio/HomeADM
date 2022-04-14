package originacion.bean;

import general.bean.BaseBean;
import herramientas.Utileria;

public class InconsistenciasBean extends BaseBean{
	
	private String clienteID;
	private String nombreCliente;
	private String prospectoID;
	private String nombreProspecto;
	private String avalID;
	private String nombreAval;
	private String garanteID;
	private String nombreGarante;
	private String nombreCompleto;
	private String comentarios;
	
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getNombreProspecto() {
		return nombreProspecto;
	}
	public void setNombreProspecto(String nombreProspecto) {
		this.nombreProspecto = nombreProspecto;
	}
	public String getAvalID() {
		return avalID;
	}
	public void setAvalID(String avalID) {
		this.avalID = avalID;
	}
	public String getNombreAval() {
		return nombreAval;
	}
	public void setNombreAval(String nombreAval) {
		this.nombreAval = nombreAval;
	}
	public String getGaranteID() {
		return garanteID;
	}
	public void setGaranteID(String garanteID) {
		this.garanteID = garanteID;
	}
	public String getNombreGarante() {
		return nombreGarante;
	}
	public void setNombreGarante(String nombreGarante) {
		this.nombreGarante = nombreGarante;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getComentarios() {
		return comentarios;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	
	
	
	
}
