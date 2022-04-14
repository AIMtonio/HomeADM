package pld.bean;

import java.util.List;

public class PaisesGAFIPLDBean {

	private String paisID;
	private String nombre;
	private String tipoPais;
	private String hisPaisID;
	private String tipoLista;
	private String detalleMejora;
	private String detalleNoCoop;
	private List listaPaises;
	//Campos para la detección de la operacion inusual
	private String clavePersonaInv;
	private String primerNombre;
	private String segundoNombre;
	private String tercerNombre;
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String tipoPersona;
	private String razonSocial;
	private String tipoPersSAFI;
	
	private String estaEnCatalogo;

	public String getPaisID() {
		return paisID;
	}

	public void setPaisID(String paisID) {
		this.paisID = paisID;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getTipoPais() {
		return tipoPais;
	}

	public void setTipoPais(String tipoPais) {
		this.tipoPais = tipoPais;
	}

	public String getHisPaisID() {
		return hisPaisID;
	}

	public void setHisPaisID(String hisPaisID) {
		this.hisPaisID = hisPaisID;
	}

	public String getTipoLista() {
		return tipoLista;
	}

	public void setTipoLista(String tipoLista) {
		this.tipoLista = tipoLista;
	}

	public String getDetalleMejora() {
		return detalleMejora;
	}

	public void setDetalleMejora(String detalleMejora) {
		this.detalleMejora = detalleMejora;
	}

	public String getDetalleNoCoop() {
		return detalleNoCoop;
	}

	public void setDetalleNoCoop(String detalleNoCoop) {
		this.detalleNoCoop = detalleNoCoop;
	}

	public List getListaPaises() {
		return listaPaises;
	}

	public void setListaPaises(List listaPaises) {
		this.listaPaises = listaPaises;
	}

	public String getClavePersonaInv() {
		return clavePersonaInv;
	}

	public void setClavePersonaInv(String clavePersonaInv) {
		this.clavePersonaInv = clavePersonaInv;
	}

	public String getPrimerNombre() {
		return primerNombre;
	}

	public void setPrimerNombre(String primerNombre) {
		this.primerNombre = primerNombre;
	}

	public String getSegundoNombre() {
		return segundoNombre;
	}

	public void setSegundoNombre(String segundoNombre) {
		this.segundoNombre = segundoNombre;
	}

	public String getTercerNombre() {
		return tercerNombre;
	}

	public void setTercerNombre(String tercerNombre) {
		this.tercerNombre = tercerNombre;
	}

	public String getApellidoPaterno() {
		return apellidoPaterno;
	}

	public void setApellidoPaterno(String apellidoPaterno) {
		this.apellidoPaterno = apellidoPaterno;
	}

	public String getApellidoMaterno() {
		return apellidoMaterno;
	}

	public void setApellidoMaterno(String apellidoMaterno) {
		this.apellidoMaterno = apellidoMaterno;
	}

	public String getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public String getRazonSocial() {
		return razonSocial;
	}

	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}

	public String getTipoPersSAFI() {
		return tipoPersSAFI;
	}

	public void setTipoPersSAFI(String tipoPersSAFI) {
		this.tipoPersSAFI = tipoPersSAFI;
	}

	public String getEstaEnCatalogo() {
		return estaEnCatalogo;
	}

	public void setEstaEnCatalogo(String estaEnCatalogo) {
		this.estaEnCatalogo = estaEnCatalogo;
	}



}