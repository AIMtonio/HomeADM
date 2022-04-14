package credito.bean;

import general.bean.BaseBean;

import org.springframework.web.multipart.MultipartFile;

public class CarCambioFondeoBitBean extends BaseBean{

	private String carCambioFondeoID;
	private String fechaCambio;
	private String creditoID;
	private String institutFondAntID;
	private String lineaFondeoAntID;
	private String creditoFondeoAntID;
	private String institutFondActID;
	private String lineaFondeoActID;
	private String creditoFondeoActID;
	
	private String urlArchivo;
	private MultipartFile file;
	private String numeroTransacion;
	private String nombreArchivo;
	
	private String carFondeoMavisoID;
	private String filaArchivo;
	private String cantError;
	private String cantAdvertencia;
	private String estatus;
	private String descripcionEstatus;
	
	public String getCarCambioFondeoID() {
		return carCambioFondeoID;
	}
	public void setCarCambioFondeoID(String carCambioFondeoID) {
		this.carCambioFondeoID = carCambioFondeoID;
	}
	public String getFechaCambio() {
		return fechaCambio;
	}
	public void setFechaCambio(String fechaCambio) {
		this.fechaCambio = fechaCambio;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getInstitutFondAntID() {
		return institutFondAntID;
	}
	public void setInstitutFondAntID(String institutFondAntID) {
		this.institutFondAntID = institutFondAntID;
	}
	public String getLineaFondeoAntID() {
		return lineaFondeoAntID;
	}
	public void setLineaFondeoAntID(String lineaFondeoAntID) {
		this.lineaFondeoAntID = lineaFondeoAntID;
	}
	public String getCreditoFondeoAntID() {
		return creditoFondeoAntID;
	}
	public void setCreditoFondeoAntID(String creditoFondeoAntID) {
		this.creditoFondeoAntID = creditoFondeoAntID;
	}
	public String getInstitutFondActID() {
		return institutFondActID;
	}
	public void setInstitutFondActID(String institutFondActID) {
		this.institutFondActID = institutFondActID;
	}
	public String getLineaFondeoActID() {
		return lineaFondeoActID;
	}
	public void setLineaFondeoActID(String lineaFondeoActID) {
		this.lineaFondeoActID = lineaFondeoActID;
	}
	public String getCreditoFondeoActID() {
		return creditoFondeoActID;
	}
	public void setCreditoFondeoActID(String creditoFondeoActID) {
		this.creditoFondeoActID = creditoFondeoActID;
	}

	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getUrlArchivo() {
		return urlArchivo;
	}
	public void setUrlArchivo(String urlArchivo) {
		this.urlArchivo = urlArchivo;
	}
	public String getNumeroTransacion() {
		return numeroTransacion;
	}
	public void setNumeroTransacion(String numeroTransacion) {
		this.numeroTransacion = numeroTransacion;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public String getCarFondeoMavisoID() {
		return carFondeoMavisoID;
	}
	public void setCarFondeoMavisoID(String carFondeoMavisoID) {
		this.carFondeoMavisoID = carFondeoMavisoID;
	}
	public String getFilaArchivo() {
		return filaArchivo;
	}
	public void setFilaArchivo(String filaArchivo) {
		this.filaArchivo = filaArchivo;
	}
	public String getCantError() {
		return cantError;
	}
	public void setCantError(String cantError) {
		this.cantError = cantError;
	}
	public String getCantAdvertencia() {
		return cantAdvertencia;
	}
	public void setCantAdvertencia(String cantAdvertencia) {
		this.cantAdvertencia = cantAdvertencia;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getDescripcionEstatus() {
		return descripcionEstatus;
	}
	public void setDescripcionEstatus(String descripcionEstatus) {
		this.descripcionEstatus = descripcionEstatus;
	}

	
}
