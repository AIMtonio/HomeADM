package tarjetas.bean;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

import general.bean.BaseBean;
public class BitacoraLoteDebBean extends BaseBean{
	
	private String bitCargaID;
	private String consecutivoBit;
	private String tipoTarjetaDebID; // insertar archivo
	private String fechaRegistro; // sistema
	private String usuarioID;
	private String rutaArchivo;
	private String numRegistro;
	private String numTarjeta;
	private String fechaVencimiento;
	private String nip;
	private String nombreTarjeta;
	private String estatus;
	private String motivoFallo;
	
	private CommonsMultipartFile file = null;
	private String descripcionMov;
	private int fallo;
	private int exito;
	public CommonsMultipartFile getFile() {
		return file;
	}
	public void setFile(CommonsMultipartFile file) {
		this.file = file;
	}
	public String getBitCargaID() {
		return bitCargaID;
	}
	public void setBitCargaID(String bitCargaID) {
		this.bitCargaID = bitCargaID;
	}
	public String getTipoTarjetaDebID() {
		return tipoTarjetaDebID;
	}
	public void setTipoTarjetaDebID(String tipoTarjetaDebID) {
		this.tipoTarjetaDebID = tipoTarjetaDebID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getRutaArchivo() {
		return rutaArchivo;
	}
	public void setRutaArchivo(String rutaArchivo) {
		this.rutaArchivo = rutaArchivo;
	}
	public String getNumRegistro() {
		return numRegistro;
	}
	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}
	public String getNumTarjeta() {
		return numTarjeta;
	}
	public void setNumTarjeta(String numTarjeta) {
		this.numTarjeta = numTarjeta;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getNip() {
		return nip;
	}
	public void setNip(String nip) {
		this.nip = nip;
	}
	public String getNombreTarjeta() {
		return nombreTarjeta;
	}
	public void setNombreTarjeta(String nombreTarjeta) {
		this.nombreTarjeta = nombreTarjeta;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getMotivoFallo() {
		return motivoFallo;
	}
	public void setMotivoFallo(String motivoFallo) {
		this.motivoFallo = motivoFallo;
	}
	public String getConsecutivoBit() {
		return consecutivoBit;
	}
	public void setConsecutivoBit(String consecutivoBit) {
		this.consecutivoBit = consecutivoBit;
	}
	public String getDescripcionMov() {
		return descripcionMov;
	}
	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
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
	
	
	
	

	
}