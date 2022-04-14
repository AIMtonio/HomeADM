package cobranza.bean;

import java.util.List;

import general.bean.BaseBean;

public class TipoRespuestaCobBean extends BaseBean{
	private String accionID;
	private String respuestaID;
	private String descripcion;
	private String estatus;

	private List lisRespuestaID;
	private List lisDescripcion;
	private List lisEstatus;
	
	public String getAccionID() {
		return accionID;
	}
	public void setAccionID(String accionID) {
		this.accionID = accionID;
	}
	public String getRespuestaID() {
		return respuestaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setRespuestaID(String respuestaID) {
		this.respuestaID = respuestaID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public List getLisRespuestaID() {
		return lisRespuestaID;
	}
	public List getLisDescripcion() {
		return lisDescripcion;
	}
	public List getLisEstatus() {
		return lisEstatus;
	}
	public void setLisRespuestaID(List lisRespuestaID) {
		this.lisRespuestaID = lisRespuestaID;
	}
	public void setLisDescripcion(List lisDescripcion) {
		this.lisDescripcion = lisDescripcion;
	}
	public void setLisEstatus(List lisEstatus) {
		this.lisEstatus = lisEstatus;
	}
	
	
}
