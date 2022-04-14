package originacion.bean;

import general.bean.BaseBean;

public class TiposNotasCargoBean extends BaseBean {

	private String tipoNotaCargoID;
	private String nombreCorto;
	private String descripcion;
	private String estatus;
	private String cobraIVA;

	public String getTipoNotaCargoID() {
		return tipoNotaCargoID;
	}
	public void setTipoNotaCargoID(String tipoNotaCargoID) {
		this.tipoNotaCargoID = tipoNotaCargoID;
	}
	public String getNombreCorto() {
		return nombreCorto;
	}
	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCobraIVA() {
		return cobraIVA;
	}
	public void setCobraIVA(String cobraIVA) {
		this.cobraIVA = cobraIVA;
	}
}
