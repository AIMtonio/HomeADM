package soporte.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class FirmaRepresentLegalBean extends BaseBean{
	 private MultipartFile file;
	 
	 private String representLegal;
	 private String rfcRepresentLegal;
	 private String razonSocial;
	 private String rfc;
	 private String recurso;
	 private String observacion;
	 private String consecutivo;
	 
	// auxiliares del bean
	private String extension;
	private String numeroDocumentos;
	private String fechaEmision;
	private String nombreUsuario;
	private String nombreInstitucion;
	
	 
	 
	public String getRepresentLegal() {
		return representLegal;
	}
	public void setRepresentLegal(String representLegal) {
		this.representLegal = representLegal;
	}
	public String getRfcRepresentLegal() {
		return rfcRepresentLegal;
	}
	public void setRfcRepresentLegal(String rfcRepresentLegal) {
		this.rfcRepresentLegal = rfcRepresentLegal;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getExtension() {
		return extension;
	}
	public void setExtension(String extension) {
		this.extension = extension;
	}
	public String getNumeroDocumentos() {
		return numeroDocumentos;
	}
	public void setNumeroDocumentos(String numeroDocumentos) {
		this.numeroDocumentos = numeroDocumentos;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	public String getObservacion() {
		return observacion;
	}
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
 
}
