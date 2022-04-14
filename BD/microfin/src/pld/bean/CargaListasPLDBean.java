package pld.bean;

import org.springframework.web.multipart.MultipartFile;

public class CargaListasPLDBean {

	private String cargaListasID;
	private String socioID;
	private String nombres;
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String curp;
	private String rfc;
	private String fechaNacimiento;
	private String qeqID;
	private String fechaCarga;
	private String tipoTransaccion;
	private String rutaArchivos;
	private MultipartFile file;
	private String rutaArchivoSubido;
	private boolean exito;
	private String tipoLista;
	private String estatus;
	private String incluyeEncabezado;
	private String masivo;

	public String getCargaListasID() {
		return cargaListasID;
	}

	public void setCargaListasID(String cargaListasID) {
		this.cargaListasID = cargaListasID;
	}

	public String getSocioID() {
		return socioID;
	}

	public void setSocioID(String socioID) {
		this.socioID = socioID;
	}

	public String getNombres() {
		return nombres;
	}

	public void setNombres(String nombres) {
		this.nombres = nombres;
	}

	public String getApellidoPaterno() {
		return apellidoPaterno;
	}

	public void setApellidoPaterno(String apellidoPaterno) {
		this.apellidoPaterno = apellidoPaterno;
	}

	public String getApellidoMaterno() {
		return apellidoMaterno;
	}

	public void setApellidoMaterno(String apellidoMaterno) {
		this.apellidoMaterno = apellidoMaterno;
	}

	public String getCurp() {
		return curp;
	}

	public void setCurp(String curp) {
		this.curp = curp;
	}

	public String getRfc() {
		return rfc;
	}

	public void setRfc(String rfc) {
		this.rfc = rfc;
	}

	public String getFechaNacimiento() {
		return fechaNacimiento;
	}

	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}

	public String getQeqID() {
		return qeqID;
	}

	public void setQeqID(String qeqID) {
		this.qeqID = qeqID;
	}

	public String getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(String fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public String getTipoTransaccion() {
		return tipoTransaccion;
	}

	public void setTipoTransaccion(String tipoTransaccion) {
		this.tipoTransaccion = tipoTransaccion;
	}

	public String getRutaArchivos() {
		return rutaArchivos;
	}

	public void setRutaArchivos(String rutaArchivos) {
		this.rutaArchivos = rutaArchivos;
	}

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public String getRutaArchivoSubido() {
		return rutaArchivoSubido;
	}

	public void setRutaArchivoSubido(String rutaArchivoSubido) {
		this.rutaArchivoSubido = rutaArchivoSubido;
	}

	public boolean isExito() {
		return exito;
	}

	public void setExito(boolean exito) {
		this.exito = exito;
	}

	public String getTipoLista() {
		return tipoLista;
	}

	public void setTipoLista(String tipoLista) {
		this.tipoLista = tipoLista;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getIncluyeEncabezado() {
		return incluyeEncabezado;
	}

	public void setIncluyeEncabezado(String incluyeEncabezado) {
		this.incluyeEncabezado = incluyeEncabezado;
	}

	public String getMasivo() {
		return masivo;
	}

	public void setMasivo(String masivo) {
		this.masivo = masivo;
	}

}