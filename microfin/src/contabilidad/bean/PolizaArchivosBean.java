package contabilidad.bean;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class PolizaArchivosBean extends BaseBean {
	private MultipartFile file;
	
	private String polizaArchivosID;
	private String polizaID;
	private String archivoPolID;
	private String tipoDocumento;
	private String observacion;
	private String recurso;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private List<?> listaArchivos;
	private String cadenaArchivos;
		
	private String extension;
	
	public String getPolizaArchivosID() {
		return polizaArchivosID;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public String getArchivoPolID() {
		return archivoPolID;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public String getObservacion() {
		return observacion;
	}
	public String getRecurso() {
		return recurso;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setPolizaArchivosID(String polizaArchivosID) {
		this.polizaArchivosID = polizaArchivosID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public void setArchivoPolID(String archivoPolID) {
		this.archivoPolID = archivoPolID;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
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
	public List<?> getListaArchivos() {
		return listaArchivos;
	}
	public void setListaArchivos(List<?> listaArchivos) {
		this.listaArchivos = listaArchivos;
	}
	public String getCadenaArchivos() {
		return cadenaArchivos;
	}
	public void setCadenaArchivos(String cadenaArchivos) {
		this.cadenaArchivos = cadenaArchivos;
	}
}
