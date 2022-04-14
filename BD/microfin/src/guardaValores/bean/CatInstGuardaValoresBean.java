package guardaValores.bean;

import general.bean.BaseBean;

public class CatInstGuardaValoresBean extends BaseBean {

	private String catInsGrdValoresID;
	private String nombreInstrumento;
	private String descripcion;
	private String estatus;
	private String manejaCheckList;
	private String manejaDigitalizacion;
	
	public String getCatInsGrdValoresID() {
		return catInsGrdValoresID;
	}
	public void setCatInsGrdValoresID(String catInsGrdValoresID) {
		this.catInsGrdValoresID = catInsGrdValoresID;
	}
	public String getNombreInstrumento() {
		return nombreInstrumento;
	}
	public void setNombreInstrumento(String nombreInstrumento) {
		this.nombreInstrumento = nombreInstrumento;
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
	public String getManejaCheckList() {
		return manejaCheckList;
	}
	public void setManejaCheckList(String manejaCheckList) {
		this.manejaCheckList = manejaCheckList;
	}
	public String getManejaDigitalizacion() {
		return manejaDigitalizacion;
	}
	public void setManejaDigitalizacion(String manejaDigitalizacion) {
		this.manejaDigitalizacion = manejaDigitalizacion;
	}
}
