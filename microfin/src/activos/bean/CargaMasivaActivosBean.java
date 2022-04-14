package activos.bean;

import general.bean.BaseBean;
import org.springframework.web.multipart.MultipartFile;

public class CargaMasivaActivosBean extends BaseBean {

	private String activoID;
	private String tipoActivoID;
	private String descripcion;
	private String fechaAdquisicion;
	private String proveedorID;

	private String nombreProveedor;
	private String numFactura;
	private String numSerie;
	private String moi;
	private String depreciadoAcumulado;

	private String totalDepreciar;
	private String mesesUso;
	private String polizaFactura;
	private String centroCostoID;
	private String descripcionCenCos;

	private String ctaContable;
	private String descripcionCtaCon;
	private String estatus;
	private String tipoRegistro;
	private String anio;

	private String mes;
	private String esEditable;
	private String fechaRegistro;
	private String sucursalID;

	// Narrativa 0063 Complemento al módulo de activo
	private String numeroConsecutivo;
	private String porDepFiscal;
	private String depFiscalSaldoInicio;
	private String depFiscalSaldoFin;
	private String ctaContableRegistro;

	private String numeroError;
	private String mensajeError;
	private String registroID;
	private String transaccionID;
	
	private String rutaArchivos;
	private String nombreArchivo;;
	private MultipartFile file;

	public String getActivoID() {
		return activoID;
	}
	public void setActivoID(String activoID) {
		this.activoID = activoID;
	}
	public String getTipoActivoID() {
		return tipoActivoID;
	}
	public void setTipoActivoID(String tipoActivoID) {
		this.tipoActivoID = tipoActivoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getFechaAdquisicion() {
		return fechaAdquisicion;
	}
	public void setFechaAdquisicion(String fechaAdquisicion) {
		this.fechaAdquisicion = fechaAdquisicion;
	}
	public String getProveedorID() {
		return proveedorID;
	}
	public void setProveedorID(String proveedorID) {
		this.proveedorID = proveedorID;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public String getNumFactura() {
		return numFactura;
	}
	public void setNumFactura(String numFactura) {
		this.numFactura = numFactura;
	}
	public String getNumSerie() {
		return numSerie;
	}
	public void setNumSerie(String numSerie) {
		this.numSerie = numSerie;
	}
	public String getMoi() {
		return moi;
	}
	public void setMoi(String moi) {
		this.moi = moi;
	}
	public String getDepreciadoAcumulado() {
		return depreciadoAcumulado;
	}
	public void setDepreciadoAcumulado(String depreciadoAcumulado) {
		this.depreciadoAcumulado = depreciadoAcumulado;
	}
	public String getTotalDepreciar() {
		return totalDepreciar;
	}
	public void setTotalDepreciar(String totalDepreciar) {
		this.totalDepreciar = totalDepreciar;
	}
	public String getMesesUso() {
		return mesesUso;
	}
	public void setMesesUso(String mesesUso) {
		this.mesesUso = mesesUso;
	}
	public String getPolizaFactura() {
		return polizaFactura;
	}
	public void setPolizaFactura(String polizaFactura) {
		this.polizaFactura = polizaFactura;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public String getDescripcionCenCos() {
		return descripcionCenCos;
	}
	public void setDescripcionCenCos(String descripcionCenCos) {
		this.descripcionCenCos = descripcionCenCos;
	}
	public String getCtaContable() {
		return ctaContable;
	}
	public void setCtaContable(String ctaContable) {
		this.ctaContable = ctaContable;
	}
	public String getDescripcionCtaCon() {
		return descripcionCtaCon;
	}
	public void setDescripcionCtaCon(String descripcionCtaCon) {
		this.descripcionCtaCon = descripcionCtaCon;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTipoRegistro() {
		return tipoRegistro;
	}
	public void setTipoRegistro(String tipoRegistro) {
		this.tipoRegistro = tipoRegistro;
	}
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getEsEditable() {
		return esEditable;
	}
	public void setEsEditable(String esEditable) {
		this.esEditable = esEditable;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNumeroConsecutivo() {
		return numeroConsecutivo;
	}
	public void setNumeroConsecutivo(String numeroConsecutivo) {
		this.numeroConsecutivo = numeroConsecutivo;
	}
	public String getPorDepFiscal() {
		return porDepFiscal;
	}
	public void setPorDepFiscal(String porDepFiscal) {
		this.porDepFiscal = porDepFiscal;
	}
	public String getDepFiscalSaldoInicio() {
		return depFiscalSaldoInicio;
	}
	public void setDepFiscalSaldoInicio(String depFiscalSaldoInicio) {
		this.depFiscalSaldoInicio = depFiscalSaldoInicio;
	}
	public String getDepFiscalSaldoFin() {
		return depFiscalSaldoFin;
	}
	public void setDepFiscalSaldoFin(String depFiscalSaldoFin) {
		this.depFiscalSaldoFin = depFiscalSaldoFin;
	}
	public String getCtaContableRegistro() {
		return ctaContableRegistro;
	}
	public void setCtaContableRegistro(String ctaContableRegistro) {
		this.ctaContableRegistro = ctaContableRegistro;
	}
	public String getNumeroError() {
		return numeroError;
	}
	public void setNumeroError(String numeroError) {
		this.numeroError = numeroError;
	}
	public String getMensajeError() {
		return mensajeError;
	}
	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}
	public String getRegistroID() {
		return registroID;
	}
	public void setRegistroID(String registroID) {
		this.registroID = registroID;
	}
	public String getTransaccionID() {
		return transaccionID;
	}
	public void setTransaccionID(String transaccionID) {
		this.transaccionID = transaccionID;
	}
	public String getRutaArchivos() {
		return rutaArchivos;
	}
	public void setRutaArchivos(String rutaArchivos) {
		this.rutaArchivos = rutaArchivos;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
}
