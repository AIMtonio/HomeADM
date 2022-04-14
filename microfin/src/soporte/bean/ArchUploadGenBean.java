package soporte.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class ArchUploadGenBean extends BaseBean {
	private String tipo;
	private String archivo;
	private String fecha;
	private MultipartFile file;
	private String recurso;
	private String rutaLocal;
	private String rutaCSV;
	private String rutaFinal;
	private String nombreArchivo;
	public String getArchivo() {
		return archivo;
	}
	public void setArchivo(String archivo) {
		this.archivo = archivo;
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
	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	public String getRutaCSV() {
		return rutaCSV;
	}
	public void setRutaCSV(String rutaCSV) {
		this.rutaCSV = rutaCSV;
	}
	public String getRutaFinal() {
		return rutaFinal;
	}
	public void setRutaFinal(String rutaFinal) {
		this.rutaFinal = rutaFinal;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public String getRutaLocal() {
		return rutaLocal;
	}
	public void setRutaLocal(String rutaLocal) {
		this.rutaLocal = rutaLocal;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
}
