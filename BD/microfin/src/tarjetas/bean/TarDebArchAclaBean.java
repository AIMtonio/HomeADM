package tarjetas.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class TarDebArchAclaBean extends BaseBean{
	//Declaracion de Constantes
	
	private MultipartFile file;
	private String folioID;
	private String reporteID;
	private String tipoArchivo;
	private String ruta;
	private String fechaRegistro;
	private String numero;
	private String cargaID;
	private String consecutivo;
	private String nombreArchivo;
	private String fechaEmision;
	private String nombreUsuario;
	private String nombreInstitucion;

	private int fallo;
	private int exito;
	
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public String getFolioID() {
		return folioID;
	}
	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}
	public String getReporteID() {
		return reporteID;
	}
	public void setReporteID(String reporteID) {
		this.reporteID = reporteID;
	}
	public String getTipoArchivo() {
		return tipoArchivo;
	}
	public void setTipoArchivo(String tipoArchivo) {
		this.tipoArchivo = tipoArchivo;
	}
	public String getRuta() {
		return ruta;
	}
	public void setRuta(String ruta) {
		this.ruta = ruta;
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
	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getCargaID() {
		return cargaID;
	}
	public void setCargaID(String cargaID) {
		this.cargaID = cargaID;
	}
	public int getFallo() {
		return fallo;
	}
	public void setFallo(int fallo) {
		this.fallo = fallo;
	}
	public int getExito() {
		return exito;
	}
	public void setExito(int exito) {
		this.exito = exito;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
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

}
