package cobranza.bean;

import general.bean.BaseBean;

public class FormatoNotificaBean extends BaseBean{
	private String formatoID;
	private String descripcion;
	private String reporte;
	private String tipo;
	
	public String getFormatoID() {
		return formatoID;
	}
	public void setFormatoID(String formatoID) {
		this.formatoID = formatoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getReporte() {
		return reporte;
	}
	public void setReporte(String reporte) {
		this.reporte = reporte;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}		
}
