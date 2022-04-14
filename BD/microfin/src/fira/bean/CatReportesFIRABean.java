package fira.bean;


import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class CatReportesFIRABean extends BaseBean {

	private String tipoReporteID;
	private String nombre;
	private String nombreReporte;
	private String fechaReporte;
	private String reporte;
	
	private String recurso;
	private String fecha;
	private MultipartFile calCartFira;
	private String rutaFinalCalCartFira;
	private MultipartFile archivoRes;
	private String rutaFinalArchivoRes;
	private MultipartFile file;
	private String rutaLocal;
	
	private String tipoArchivo;
	private String anio;
	
	
	public String getTipoReporteID() {
		return tipoReporteID;
	}

	public void setTipoReporteID(String tipoReporteID) {
		this.tipoReporteID = tipoReporteID;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getFechaReporte() {
		return fechaReporte;
	}

	public void setFechaReporte(String fechaReporte) {
		this.fechaReporte = fechaReporte;
	}

	public String getReporte() {
		return reporte;
	}

	public void setReporte(String reporte) {
		this.reporte = reporte;
	}

	public String getRecurso() {
		return recurso;
	}

	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public String getRutaLocal() {
		return rutaLocal;
	}

	public void setRutaLocal(String rutaLocal) {
		this.rutaLocal = rutaLocal;
	}

	public MultipartFile getCalCartFira() {
		return calCartFira;
	}

	public void setCalCartFira(MultipartFile calCartFira) {
		this.calCartFira = calCartFira;
	}

	public MultipartFile getArchivoRes() {
		return archivoRes;
	}

	public void setArchivoRes(MultipartFile archivoRes) {
		this.archivoRes = archivoRes;
	}

	public String getTipoArchivo() {
		return tipoArchivo;
	}

	public void setTipoArchivo(String tipoArchivo) {
		this.tipoArchivo = tipoArchivo;
	}

	public String getRutaFinalCalCartFira() {
		return rutaFinalCalCartFira;
	}

	public void setRutaFinalCalCartFira(String rutaFinalCalCartFira) {
		this.rutaFinalCalCartFira = rutaFinalCalCartFira;
	}

	public String getRutaFinalArchivoRes() {
		return rutaFinalArchivoRes;
	}

	public void setRutaFinalArchivoRes(String rutaFinalArchivoRes) {
		this.rutaFinalArchivoRes = rutaFinalArchivoRes;
	}

	public String getAnio() {
		return anio;
	}

	public void setAnio(String anio) {
		this.anio = anio;
	}
	
		

}