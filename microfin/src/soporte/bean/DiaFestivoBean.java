package soporte.bean;

import general.bean.BaseBean;

import java.util.Date;

public class DiaFestivoBean extends BaseBean{
	
	private Date fechaFestiva;
	private String descripcion;
	
	public Date getFechaFestiva() {
		return fechaFestiva;
	}
	public void setFechaFestiva(Date fechaFestiva) {
		this.fechaFestiva = fechaFestiva;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	
	
}
