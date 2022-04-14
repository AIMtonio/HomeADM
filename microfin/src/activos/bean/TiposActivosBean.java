package activos.bean;

import general.bean.BaseBean;

public class TiposActivosBean extends BaseBean{
	private String tipoActivoID;
	private String descripcion;
	private String descripcionCorta;
	private String depreciacionAnual;
	private String clasificaActivoID;

	private String tiempoAmortiMeses;
	private String estatus;
	private String claveTipoActivo;
	private String consecutivo;

	public String getTipoActivoID() {
		return tipoActivoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getDescripcionCorta() {
		return descripcionCorta;
	}
	public String getDepreciacionAnual() {
		return depreciacionAnual;
	}
	public String getClasificaActivoID() {
		return clasificaActivoID;
	}
	public String getTiempoAmortiMeses() {
		return tiempoAmortiMeses;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setTipoActivoID(String tipoActivoID) {
		this.tipoActivoID = tipoActivoID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setDescripcionCorta(String descripcionCorta) {
		this.descripcionCorta = descripcionCorta;
	}
	public void setDepreciacionAnual(String depreciacionAnual) {
		this.depreciacionAnual = depreciacionAnual;
	}
	public void setClasificaActivoID(String clasificaActivoID) {
		this.clasificaActivoID = clasificaActivoID;
	}
	public void setTiempoAmortiMeses(String tiempoAmortiMeses) {
		this.tiempoAmortiMeses = tiempoAmortiMeses;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getClaveTipoActivo() {
		return claveTipoActivo;
	}
	public void setClaveTipoActivo(String claveTipoActivo) {
		this.claveTipoActivo = claveTipoActivo;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
}
