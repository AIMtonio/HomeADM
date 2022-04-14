package seguimiento.bean;

import general.bean.BaseBean;

import org.springframework.web.multipart.MultipartFile;

public class SegtoArchivoBean extends BaseBean {	
	private MultipartFile file;
	private String segtoPrograID;
	private String numSecuencia;
	private String folioID;
	private String fecha;
	private String rutaArchivo;
	private String nombreArchivo;
	private String tipoDocumentoID;
	private String comentaAdjunto;
	private String consecutivoID;
	
	private String descTipoDocumento;
	private String nombreUsuario;
	private String nombreInstitucion;
	/*private String numero;
	private String cargaID;
	private String nombreArchivo;
	private String fechaEmision;
	*/
	
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getSegtoPrograID() {
		return segtoPrograID;
	}
	public void setSegtoPrograID(String segtoPrograID) {
		this.segtoPrograID = segtoPrograID;
	}
	public String getConsecutivoID() {
		return consecutivoID;
	}
	public void setConsecutivoID(String consecutivoID) {
		this.consecutivoID = consecutivoID;
	}
	public String getFolioID() {
		return folioID;
	}
	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getRutaArchivo() {
		return rutaArchivo;
	}
	public void setRutaArchivo(String rutaArchivo) {
		this.rutaArchivo = rutaArchivo;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public String getTipoDocumentoID() {
		return tipoDocumentoID;
	}
	public void setTipoDocumentoID(String tipoDocumentoID) {
		this.tipoDocumentoID = tipoDocumentoID;
	}
	public String getComentaAdjunto() {
		return comentaAdjunto;
	}
	public void setComentaAdjunto(String comentaAdjunto) {
		this.comentaAdjunto = comentaAdjunto;
	}
	public String getNumSecuencia() {
		return numSecuencia;
	}
	public void setNumSecuencia(String numSecuencia) {
		this.numSecuencia = numSecuencia;
	}
	public String getDescTipoDocumento() {
		return descTipoDocumento;
	}
	public void setDescTipoDocumento(String descTipoDocumento) {
		this.descTipoDocumento = descTipoDocumento;
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
}
