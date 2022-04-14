package cliente.bean;

import general.bean.BaseBean;

import java.util.List;

public class ConvencionSeccionalBean extends BaseBean{
	
	private String sucursalID;
	private String nombreSucurs;
	private String fecha;
	private String cantSocio;
	private String esGral;

	private List lsucursalID;
	private List lnombreSucurs;
	private List lfecha;
	private List lcantSocio;
	private List lesGral;
	
	
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	
	public String getNombreSucurs() {
		return nombreSucurs;
	}
	public void setNombreSucurs(String nombreSucurs) {
		this.nombreSucurs = nombreSucurs;
	}
	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	
	public String getCantSocio() {
		return cantSocio;
	}
	public void setCantSocio(String cantSocio) {
		this.cantSocio = cantSocio;
	}
	
	public String getEsGral() {
		return esGral;
	}
	public void setEsGral(String esGral) {
		this.esGral = esGral;
	}
	
	public List getLsucursalID() {
		return lsucursalID;
	}
	public void setLsucursalID(List lsucursalID) {
		this.lsucursalID = lsucursalID;
	}
	public List getLnombreSucurs() {
		return lnombreSucurs;
	}
	public void setLnombreSucurs(List lnombreSucurs) {
		this.lnombreSucurs = lnombreSucurs;
	}
	public List getLfecha() {
		return lfecha;
	}
	public void setLfecha(List lfecha) {
		this.lfecha = lfecha;
	}
	public List getLcantSocio() {
		return lcantSocio;
	}
	public void setLcantSocio(List lcantSocio) {
		this.lcantSocio = lcantSocio;
	}
	public List getLesGral() {
		return lesGral;
	}
	public void setLesGral(List lesGral) {
		this.lesGral = lesGral;
	}

	
	
	
}
