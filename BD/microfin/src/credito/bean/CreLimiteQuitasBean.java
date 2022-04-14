package credito.bean;

import java.util.List;

import general.bean.BaseBean;

public class CreLimiteQuitasBean extends BaseBean {	
	//Atributos o Variables
	private String producCreditoID;
	private String clavePuestoID;
	private String limMontoCap;
	private String limPorcenCap;
	private String limMontoIntere;
	private String limPorcenIntere;
	private String limMontoMorato;
	private String limPorcenMorato;
	private String limMontoAccesorios;
	private String limPorcenAccesorios;
	private String productosAplica;
	private String numMaxCondona;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	
	private List  clavePuestoIDLis;
	private List  limMontoCapLis;
	private List  limPorcenCapLis;
	private List  limMontoIntereLis;
	private List  limPorcenIntereLis;
	private List  limMontoMoratoLis;
	private List  limPorcenMoratoLis;
	private List  limMontoAccesoriosLis;
	private List  limPorcenAccesoriosLis;
	private List  numMaxCondonaLis;
	
	private String limPorcenNotasCargos;
	private String limMontoNotasCargos;
	private List  limPorcenNotasCargosLis;
	private List  limMontoNotasCargosLis;
	
	public String getProductosAplica() {
		return productosAplica;
	}
	public void setProductosAplica(String productosAplica) {
		this.productosAplica = productosAplica;
	}
	public List getClavePuestoIDLis() {
		return clavePuestoIDLis;
	}
	public void setClavePuestoIDLis(List clavePuestoIDLis) {
		this.clavePuestoIDLis = clavePuestoIDLis;
	}
	public List getLimMontoCapLis() {
		return limMontoCapLis;
	}
	public void setLimMontoCapLis(List limMontoCapLis) {
		this.limMontoCapLis = limMontoCapLis;
	}
	public List getLimPorcenCapLis() {
		return limPorcenCapLis;
	}
	public void setLimPorcenCapLis(List limPorcenCapLis) {
		this.limPorcenCapLis = limPorcenCapLis;
	}
	public List getLimMontoIntereLis() {
		return limMontoIntereLis;
	}
	public void setLimMontoIntereLis(List limMontoIntereLis) {
		this.limMontoIntereLis = limMontoIntereLis;
	}
	public List getLimPorcenIntereLis() {
		return limPorcenIntereLis;
	}
	public void setLimPorcenIntereLis(List limPorcenIntereLis) {
		this.limPorcenIntereLis = limPorcenIntereLis;
	}
	public List getLimMontoMoratoLis() {
		return limMontoMoratoLis;
	}
	public void setLimMontoMoratoLis(List limMontoMoratoLis) {
		this.limMontoMoratoLis = limMontoMoratoLis;
	}
	public List getLimPorcenMoratoLis() {
		return limPorcenMoratoLis;
	}
	public void setLimPorcenMoratoLis(List limPorcenMoratoLis) {
		this.limPorcenMoratoLis = limPorcenMoratoLis;
	}
	public List getLimMontoAccesoriosLis() {
		return limMontoAccesoriosLis;
	}
	public void setLimMontoAccesoriosLis(List limMontoAccesoriosLis) {
		this.limMontoAccesoriosLis = limMontoAccesoriosLis;
	}
	public List getLimPorcenAccesoriosLis() {
		return limPorcenAccesoriosLis;
	}
	public void setLimPorcenAccesoriosLis(List limPorcenAccesoriosLis) {
		this.limPorcenAccesoriosLis = limPorcenAccesoriosLis;
	}
	public List getNumMaxCondonaLis() {
		return numMaxCondonaLis;
	}
	public void setNumMaxCondonaLis(List numMaxCondonaLis) {
		this.numMaxCondonaLis = numMaxCondonaLis;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getClavePuestoID() {
		return clavePuestoID;
	}
	public void setClavePuestoID(String clavePuestoID) {
		this.clavePuestoID = clavePuestoID;
	}
	public String getLimMontoCap() {
		return limMontoCap;
	}
	public void setLimMontoCap(String limMontoCap) {
		this.limMontoCap = limMontoCap;
	}
	public String getLimPorcenCap() {
		return limPorcenCap;
	}
	public void setLimPorcenCap(String limPorcenCap) {
		this.limPorcenCap = limPorcenCap;
	}
	public String getLimMontoIntere() {
		return limMontoIntere;
	}
	public void setLimMontoIntere(String limMontoIntere) {
		this.limMontoIntere = limMontoIntere;
	}
	public String getLimPorcenIntere() {
		return limPorcenIntere;
	}
	public void setLimPorcenIntere(String limPorcenIntere) {
		this.limPorcenIntere = limPorcenIntere;
	}
	public String getLimMontoMorato() {
		return limMontoMorato;
	}
	public void setLimMontoMorato(String limMontoMorato) {
		this.limMontoMorato = limMontoMorato;
	}
	public String getLimPorcenMorato() {
		return limPorcenMorato;
	}
	public void setLimPorcenMorato(String limPorcenMorato) {
		this.limPorcenMorato = limPorcenMorato;
	}
	public String getLimMontoAccesorios() {
		return limMontoAccesorios;
	}
	public void setLimMontoAccesorios(String limMontoAccesorios) {
		this.limMontoAccesorios = limMontoAccesorios;
	}
	public String getLimPorcenAccesorios() {
		return limPorcenAccesorios;
	}
	public void setLimPorcenAccesorios(String limPorcenAccesorios) {
		this.limPorcenAccesorios = limPorcenAccesorios;
	}
	public String getNumMaxCondona() {
		return numMaxCondona;
	}
	public void setNumMaxCondona(String numMaxCondona) {
		this.numMaxCondona = numMaxCondona;
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
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getLimPorcenNotasCargos() {
		return limPorcenNotasCargos;
	}
	public void setLimPorcenNotasCargos(String limPorcenNotasCargos) {
		this.limPorcenNotasCargos = limPorcenNotasCargos;
	}
	public String getLimMontoNotasCargos() {
		return limMontoNotasCargos;
	}
	public void setLimMontoNotasCargos(String limMontoNotasCargos) {
		this.limMontoNotasCargos = limMontoNotasCargos;
	}
	public List getLimPorcenNotasCargosLis() {
		return limPorcenNotasCargosLis;
	}
	public void setLimPorcenNotasCargosLis(List limPorcenNotasCargosLis) {
		this.limPorcenNotasCargosLis = limPorcenNotasCargosLis;
	}
	public List getLimMontoNotasCargosLis() {
		return limMontoNotasCargosLis;
	}
	public void setLimMontoNotasCargosLis(List limMontoNotasCargosLis) {
		this.limMontoNotasCargosLis = limMontoNotasCargosLis;
	}

}