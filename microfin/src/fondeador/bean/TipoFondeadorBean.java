package fondeador.bean;

import general.bean.BaseBean;

public class TipoFondeadorBean extends BaseBean {
	private String catFondeadorID;
	private String tipoFondeador;
	private String desTipoFondeador;
	private String estatus;
	

	public String getCatFondeadorID() {
		return catFondeadorID;
	}
	public void setCatFondeadorID(String catFondeadorID) {
		this.catFondeadorID = catFondeadorID;
	}
	public String getTipoFondeador() {
		return tipoFondeador;
	}
	public void setTipoFondeador(String tipoFondeador) {
		this.tipoFondeador = tipoFondeador;
	}
	public String getDesTipoFondeador() {
		return desTipoFondeador;
	}
	public void setDesTipoFondeador(String desTipoFondeador) {
		this.desTipoFondeador = desTipoFondeador;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}	
	
}
