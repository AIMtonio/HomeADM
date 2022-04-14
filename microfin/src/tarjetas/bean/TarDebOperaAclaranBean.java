package tarjetas.bean;

import general.bean.BaseBean;

public class TarDebOperaAclaranBean extends BaseBean{
	//Declaracion de Constantes
	
	private String tipoAclaracionID;
	private String operacion;
	private String descripcion;
	private String comercio;
	private String cajero;
	
	public String getComercio() {
		return comercio;
	}

	public void setComercio(String comercio) {
		this.comercio = comercio;
	}

	public String getCajero() {
		return cajero;
	}

	public void setCajero(String cajero) {
		this.cajero = cajero;
	}

	public String getTipoAclaracionID() {
		return tipoAclaracionID;
	}

	public void setTipoAclaracionID(String tipoAclaracionID) {
		this.tipoAclaracionID = tipoAclaracionID;
	}
	public String getOperacion() {
		return operacion;
	}

	public void setOperacion(String operacion) {
		this.operacion = operacion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
