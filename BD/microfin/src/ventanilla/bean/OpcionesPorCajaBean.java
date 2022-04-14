package ventanilla.bean;

import general.bean.BaseBean;
import java.util.List;
public class OpcionesPorCajaBean extends BaseBean{

	private String cajaID;
	private String tipoCaja;
	private String opcionCajaID;
	private String descripcion;
	private String reqAutentificacion;
	private String esReversa;
	private String sujetoPLDEscala;
	private String sujetoPLDIdenti;
	private String listaOpcionesPLD;
	private List listaOpciones;	
	
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getCajaID() {
		return cajaID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public String getTipoCaja() {
		return tipoCaja;
	}
	public void setTipoCaja(String tipoCaja) {
		this.tipoCaja = tipoCaja;
	}
	public String getOpcionCajaID() {
		return opcionCajaID;
	}
	public void setOpcionCajaID(String opcionCajaID) {
		this.opcionCajaID = opcionCajaID;
	}
	public String getReqAutentificacion() {
		return reqAutentificacion;
	}
	public void setReqAutentificacion(String reqAutentificacion) {
		this.reqAutentificacion = reqAutentificacion;
	}
	public String getEsReversa() {
		return esReversa;
	}
	public void setEsReversa(String esReversa) {
		this.esReversa = esReversa;
	}
	public List getListaOpciones() {
		return listaOpciones;
	}
	public void setListaOpciones(List listaOpciones) {
		this.listaOpciones = listaOpciones;
	}
	public String getSujetoPLDEscala() {
		return sujetoPLDEscala;
	}
	public void setSujetoPLDEscala(String sujetoPLDEscala) {
		this.sujetoPLDEscala = sujetoPLDEscala;
	}
	public String getSujetoPLDIdenti() {
		return sujetoPLDIdenti;
	}
	public void setSujetoPLDIdenti(String sujetoPLDIdenti) {
		this.sujetoPLDIdenti = sujetoPLDIdenti;
	}
	public String getListaOpcionesPLD() {
		return listaOpcionesPLD;
	}
	public void setListaOpcionesPLD(String listaOpcionesPLD) {
		this.listaOpcionesPLD = listaOpcionesPLD;
	}	
}
