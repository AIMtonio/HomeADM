package tarjetas.bean;

import general.bean.BaseBean;

import java.util.List;

public class TarDebGirosNegocioBean extends BaseBean{
	
	private String tipoTarjetaDebID;
	private String nombreTarjeta;
	private String tipo;
	private String giroID;
	private String descripcion;
	
	private 	List lgiroID;
	private 	List ldescripcion;
	
	public static int LONGITUD_ID = 10;
	private String  identificacionSocio;

	
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
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	
}