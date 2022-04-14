package cobranza.bean;

import general.bean.BaseBean;
import java.util.List;

public class TipoAccionCobBean extends BaseBean{
	private String accionID;
	private String descripcion;
	private String estatus;

	private List lisAccionID;
	private List lisDescripcion;
	private List lisEstatus;
	
	public String getAccionID() {
		return accionID;
	}
	public void setAccionID(String accionID) {
		this.accionID = accionID;
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
	public List getLisAccionID() {
		return lisAccionID;
	}
	public void setLisAccionID(List lisAccionID) {
		this.lisAccionID = lisAccionID;
	}
	public List getLisDescripcion() {
		return lisDescripcion;
	}
	public void setLisDescripcion(List lisDescripcion) {
		this.lisDescripcion = lisDescripcion;
	}
	public List getLisEstatus() {
		return lisEstatus;
	}
	public void setLisEstatus(List lisEstatus) {
		this.lisEstatus = lisEstatus;
	}
	

}
