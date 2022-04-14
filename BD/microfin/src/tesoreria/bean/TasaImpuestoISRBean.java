package tesoreria.bean;

import general.bean.BaseBean;

public class TasaImpuestoISRBean extends BaseBean {

	private String tasaImpuestoID;
	private String nombre;
	private String descripcion;
	private String valor;
	private String fechaValor;
	private String valorAnt;
	private String fechaAnt;
	private String tipoTasa;
	private String paisID;

	public String getTasaImpuestoID() {
		return tasaImpuestoID;
	}

	public void setTasaImpuestoID(String tasaImpuestoID) {
		this.tasaImpuestoID = tasaImpuestoID;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}

	public String getFechaValor() {
		return fechaValor;
	}

	public void setFechaValor(String fechaValor) {
		this.fechaValor = fechaValor;
	}

	public String getValorAnt() {
		return valorAnt;
	}

	public void setValorAnt(String valorAnt) {
		this.valorAnt = valorAnt;
	}

	public String getFechaAnt() {
		return fechaAnt;
	}

	public void setFechaAnt(String fechaAnt) {
		this.fechaAnt = fechaAnt;
	}

	public String getTipoTasa() {
		return tipoTasa;
	}

	public void setTipoTasa(String tipoTasa) {
		this.tipoTasa = tipoTasa;
	}

	public String getPaisID() {
		return paisID;
	}

	public void setPaisID(String paisID) {
		this.paisID = paisID;
	}

}