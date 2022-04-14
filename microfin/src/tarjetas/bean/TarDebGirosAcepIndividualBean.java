package tarjetas.bean;

import java.util.List;

import general.bean.BaseBean;

public class TarDebGirosAcepIndividualBean extends BaseBean{
	
	private String tarjetaDebID;
	private String tarjetaID;
	private int    tipoTarjeta;
	private String tipoTarjetaID;
	private String estatus;
	private String clienteID;
	private String nombreCompleto;
	private String coorporativo;
	private String nombreCoorp;
	private String cuentaAho;
	private String nombreTipoCuenta;
	private String tipoTarjetaDebID;
	private String nombreTarjeta;
	private String identificacionSocio;
	
	private String giroID;
	private String descripcion;
	
	private 	List lgiroID;
	private 	List ldescripcion;
	
	public static int LONGITUD_ID = 10;
	
	public String getTarjetaDebID() {
		return tarjetaDebID;
	}
	public void setTarjetaDebID(String tarjetaDebID) {
		this.tarjetaDebID = tarjetaDebID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
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
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getCoorporativo() {
		return coorporativo;
	}
	public void setCoorporativo(String coorporativo) {
		this.coorporativo = coorporativo;
	}
	public String getNombreCoorp() {
		return nombreCoorp;
	}
	public void setNombreCoorp(String nombreCoorp) {
		this.nombreCoorp = nombreCoorp;
	}
	public String getCuentaAho() {
		return cuentaAho;
	}
	public void setCuentaAho(String cuentaAho) {
		this.cuentaAho = cuentaAho;
	}
	public String getNombreTipoCuenta() {
		return nombreTipoCuenta;
	}
	public void setNombreTipoCuenta(String nombreTipoCuenta) {
		this.nombreTipoCuenta = nombreTipoCuenta;
	}
	public String getTipoTarjetaDebID() {
		return tipoTarjetaDebID;
	}
	public void setTipoTarjetaDebID(String tipoTarjetaDebID) {
		this.tipoTarjetaDebID = tipoTarjetaDebID;
	}
	public String getNombreTarjeta() {
		return nombreTarjeta;
	}
	public void setNombreTarjeta(String nombreTarjeta) {
		this.nombreTarjeta = nombreTarjeta;
	}
	public String getGiroID() {
		return giroID;
	}
	public void setGiroID(String giroID) {
		this.giroID = giroID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public List getLgiroID() {
		return lgiroID;
	}
	public void setLgiroID(List lgiroID) {
		this.lgiroID = lgiroID;
	}
	public List getLdescripcion() {
		return ldescripcion;
	}
	public void setLdescripcion(List ldescripcion) {
		this.ldescripcion = ldescripcion;
	}
	public String getIdentificacionSocio() {
		return identificacionSocio;
	}
	public void setIdentificacionSocio(String identificacionSocio) {
		this.identificacionSocio = identificacionSocio;
	}
	public String getTarjetaID() {
		return tarjetaID;
	}
	public void setTarjetaID(String tarjetaID) {
		this.tarjetaID = tarjetaID;
	}
	public int getTipoTarjeta() {
		return tipoTarjeta;
	}
	public void setTipoTarjeta(int tipoTarjeta) {
		this.tipoTarjeta = tipoTarjeta;
	}
	public String getTipoTarjetaID() {
		return tipoTarjetaID;
	}
	public void setTipoTarjetaID(String tipoTarjetaID) {
		this.tipoTarjetaID = tipoTarjetaID;
	}
	

}
