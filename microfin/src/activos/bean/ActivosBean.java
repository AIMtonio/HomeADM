package activos.bean;

import general.bean.BaseBean;

public class ActivosBean extends BaseBean{

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

	public String getActivoID() {
		return activoID;
	}
	public String getTipoActivoID() {
		return tipoActivoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getFechaAdquisicion() {
		return fechaAdquisicion;
	}
	public String getProveedorID() {
		return proveedorID;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public String getNumFactura() {
		return numFactura;
	}
	public String getNumSerie() {
		return numSerie;
	}
	public String getMoi() {
		return moi;
	}
	public String getDepreciadoAcumulado() {
		return depreciadoAcumulado;
	}
	public String getTotalDepreciar() {
		return totalDepreciar;
	}
	public String getMesesUso() {
		return mesesUso;
	}
	public String getPolizaFactura() {
		return polizaFactura;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public String getDescripcionCenCos() {
		return descripcionCenCos;
	}
	public String getCtaContable() {
		return ctaContable;
	}
	public String getDescripcionCtaCon() {
		return descripcionCtaCon;
	}
	public String getEstatus() {
		return estatus;
	}
	public String getAnio() {
		return anio;
	}
	public String getMes() {
		return mes;
	}
	public void setActivoID(String activoID) {
		this.activoID = activoID;
	}
	public void setTipoActivoID(String tipoActivoID) {
		this.tipoActivoID = tipoActivoID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setFechaAdquisicion(String fechaAdquisicion) {
		this.fechaAdquisicion = fechaAdquisicion;
	}
	public void setProveedorID(String proveedorID) {
		this.proveedorID = proveedorID;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public void setNumFactura(String numFactura) {
		this.numFactura = numFactura;
	}
	public void setNumSerie(String numSerie) {
		this.numSerie = numSerie;
	}
	public void setMoi(String moi) {
		this.moi = moi;
	}
	public void setDepreciadoAcumulado(String depreciadoAcumulado) {
		this.depreciadoAcumulado = depreciadoAcumulado;
	}
	public void setTotalDepreciar(String totalDepreciar) {
		this.totalDepreciar = totalDepreciar;
	}
	public void setMesesUso(String mesesUso) {
		this.mesesUso = mesesUso;
	}
	public void setPolizaFactura(String polizaFactura) {
		this.polizaFactura = polizaFactura;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public void setDescripcionCenCos(String descripcionCenCos) {
		this.descripcionCenCos = descripcionCenCos;
	}
	public void setCtaContable(String ctaContable) {
		this.ctaContable = ctaContable;
	}
	public void setDescripcionCtaCon(String descripcionCtaCon) {
		this.descripcionCtaCon = descripcionCtaCon;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getTipoRegistro() {
		return tipoRegistro;
	}
	public void setTipoRegistro(String tipoRegistro) {
		this.tipoRegistro = tipoRegistro;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getEsEditable() {
		return esEditable;
	}
	public void setEsEditable(String esEditable) {
		this.esEditable = esEditable;
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
}
