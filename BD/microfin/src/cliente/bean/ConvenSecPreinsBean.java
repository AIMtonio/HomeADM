package cliente.bean;

import general.bean.BaseBean;

public class ConvenSecPreinsBean extends BaseBean{
	private String noTarjeta;
	private String noSocio;
	private String nombreCompleto;
	private String fecha;
	private String tipoRegistro;
	private String sucursalID;
	private String cantPreins;
	private String cantIns;
	
	
	
	public String getNoTarjeta() {
		return noTarjeta;
	}
	
	public void setNoTarjeta(String noTarjeta) {
		this.noTarjeta = noTarjeta;
	}
	
	public String getNoSocio() {
		return noSocio;
	}
	
	public void setNoSocio(String noSocio) {
		this.noSocio = noSocio;
	}
	
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	
	public String getFecha() {
		return fecha;
	}
	
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	
	public String getTipoRegistro() {
		return tipoRegistro;
	}
	
	public void setTipoRegistro(String tipoRegistro) {
		this.tipoRegistro = tipoRegistro;
	}

	public String getSucursalID() {
		return sucursalID;
	}

	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}

	public String getCantPreins() {
		return cantPreins;
	}

	public void setCantPreins(String cantPreins) {
		this.cantPreins = cantPreins;
	}

	public String getCantIns() {
		return cantIns;
	}

	public void setCantIns(String cantIns) {
		this.cantIns = cantIns;
	}
	

}
