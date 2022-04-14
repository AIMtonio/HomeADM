package pld.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class ArchAdjuntosPLDBean extends BaseBean{
	private String adjuntoID;
	private String tipoProceso;
	private String opeInusualID;
	private String opeInterPreoID;
	private String tipoDocumento;
	private String consecutivo;
	private String observacion;
	private String recurso;
	private String fechaRegistro;
	private String rutaCarpetaOpera;
	private MultipartFile file;
	public String getAdjuntoID() {
		return adjuntoID;
	}
	public void setAdjuntoID(String adjuntoID) {
		this.adjuntoID = adjuntoID;
	}
	public String getTipoProceso() {
		return tipoProceso;
	}
	public void setTipoProceso(String tipoProceso) {
		this.tipoProceso = tipoProceso;
	}
	public String getOpeInusualID() {
		return opeInusualID;
	}
	public void setOpeInusualID(String opeInusualID) {
		this.opeInusualID = opeInusualID;
	}
	public String getOpeInterPreoID() {
		return opeInterPreoID;
	}
	public void setOpeInterPreoID(String opeInterPreoID) {
		this.opeInterPreoID = opeInterPreoID;
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
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getRutaCarpetaOpera() {
		return rutaCarpetaOpera;
	}
	public void setRutaCarpetaOpera(String rutaCarpetaOpera) {
		this.rutaCarpetaOpera = rutaCarpetaOpera;
	}
}
