package soporte.bean;

import general.bean.BaseBean;

import org.springframework.web.multipart.MultipartFile;

public class ClienteArchivosBean extends BaseBean{

	private MultipartFile file;
	private String clienteID;
	private String archivoClientID;
	private String tipoDocumento;
	private String consecutivo;
	private String observacion;
	private String recurso;
	private String empresaID;

	public MultipartFile getFile() {
	return file;
	}
	public void setFile(MultipartFile file) {
	this.file = file;
	}
	public String getClienteID() {
	return clienteID;
	}
	public void setClienteID(String clienteID) {
	this.clienteID = clienteID;
	}
	public String getArchivoClientID() {
	return archivoClientID;
	}
	public void setArchivoClientID(String archivoClientID) {
	this.archivoClientID = archivoClientID;
	}
	public String getTipoDocumento() {
	return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
	this.tipoDocumento = tipoDocumento;
	}
	public String getConsecutivo() {
	return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
	this.consecutivo = consecutivo;
	}
	public String getObservacion() {
	return observacion;
	}
	public void setObservacion(String observacion) {
	this.observacion = observacion;
	}
	public String getRecurso() {
	return recurso;
	}
	public void setRecurso(String recurso) {
	this.recurso = recurso;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}

}
