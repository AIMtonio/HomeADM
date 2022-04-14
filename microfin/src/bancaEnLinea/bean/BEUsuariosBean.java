package bancaEnLinea.bean;

import general.bean.BaseBean;

public class BEUsuariosBean extends BaseBean{
	private String clave;
	private String estatus;
	private String costoMensual;
	private String esUsuarioNomina;
	private String iDClienteNomina;
	private String clienteID;
	private String perfil;
	private String negocioAfiliadoID;
	
	private String nombreCompleto;
	private String RFCOficial;
	private String numErr;
	private String errMen;
	
	
	//========Auxiliares
	
	private String tipoTransaccion;
	
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCostoMensual() {
		return costoMensual;
	}
	public void setCostoMensual(String costoMensual) {
		this.costoMensual = costoMensual;
	}
	public String getEsUsuarioNomina() {
		return esUsuarioNomina;
	}
	public void setEsUsuarioNomina(String esUsuarioNomina) {
		this.esUsuarioNomina = esUsuarioNomina;
	}
	public String getiDClienteNomina() {
		return iDClienteNomina;
	}
	public void setiDClienteNomina(String iDClienteNomina) {
		this.iDClienteNomina = iDClienteNomina;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	
	public String getRFCOficial() {
		return RFCOficial;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	
	public void setRFCOficial(String rFCOficial) {
		RFCOficial = rFCOficial;
	}
	public String getNumErr() {
		return numErr;
	}
	public String getErrMen() {
		return errMen;
	}
	public void setNumErr(String numErr) {
		this.numErr = numErr;
	}
	public void setErrMen(String errMen) {
		this.errMen = errMen;
	}
	public String getPerfil() {
		return perfil;
	}
	public void setPerfil(String perfil) {
		this.perfil = perfil;
	}
	public String getNegocioAfiliadoID() {
		return negocioAfiliadoID;
	}
	public void setNegocioAfiliadoID(String negocioAfiliadoID) {
		this.negocioAfiliadoID = negocioAfiliadoID;
	}
	public String getTipoTransaccion() {
		return tipoTransaccion;
	}
	public void setTipoTransaccion(String tipoTransaccion) {
		this.tipoTransaccion = tipoTransaccion;
	}
	

}
