package inversiones.bean;

import general.dao.BaseDAO;


public class HistoricoTasasInvBean extends BaseDAO {

	private String fecha;
	private String tipoInversionID;
	private String descripcionTipoInversion;
	private float tasa;
	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getDescripcionTipoInversion() {
		return descripcionTipoInversion;
	}
	public void setDescripcionTipoInversion(String descripcionTipoInversion) {
		this.descripcionTipoInversion = descripcionTipoInversion;
	}
	public float getTasa() {
		return tasa;
	}
	public void setTasa(float tasa) {
		this.tasa = tasa;
	}
	public String getTipoInversionID() {
		return tipoInversionID;
	}
	public void setTipoInversionID(String tipoInversionID) {
		this.tipoInversionID = tipoInversionID;
	}
	
	
	
}
