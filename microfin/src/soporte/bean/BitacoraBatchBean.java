package soporte.bean;

import general.bean.BaseBean;

public class BitacoraBatchBean extends BaseBean {

	private String procesoBatchID;
	private String nombreProcesoBatch;
	private String fecha;
	private String tiempo;
	private String existeEjecucion;
	private String fechaInicio;
	private String fechaFin;

	public String getProcesoBatchID() {
		return procesoBatchID;
	}

	public void setProcesoBatchID(String procesoBatchID) {
		this.procesoBatchID = procesoBatchID;
	}

	public String getNombreProcesoBatch() {
		return nombreProcesoBatch;
	}

	public void setNombreProcesoBatch(String nombreProcesoBatch) {
		this.nombreProcesoBatch = nombreProcesoBatch;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getTiempo() {
		return tiempo;
	}

	public void setTiempo(String tiempo) {
		this.tiempo = tiempo;
	}

	public String getExisteEjecucion() {
		return existeEjecucion;
	}

	public void setExisteEjecucion(String existeEjecucion) {
		this.existeEjecucion = existeEjecucion;
	}

	public String getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public String getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}

}