package activos.bean;

import general.bean.BaseBean;

public class RepCatalogoActivosBean extends BaseBean{
	
	private String fechaInicio;
	private String fechaFin;
	private String centroCosto;
	private String tipoActivo;
	private String clasificacion;

	private String estatus;	
	private String fechaSistema;
	private String nombreInstitucion;
	private String claveUsuario;
	
	private String descCentroCosto;
	private String descTipoActivo;
	private String descClasificacion;
	
	private String descActivo;
	private String fechaAdquisicion;
	private String numFactura;
	private String polizaFactura;
	private String centroCostoID;
	private String moi;
	private String depreciacionAnual;
	private String tiempoAmortiMeses;
	private String depreContaAnual;
	private String depreciadoAcumulado;
	private String totalDepreciar;

	private String clasificaActivoID;
	private String descEstatus;
	
	private String depreciacionAnualFiscal;
	private String tiempoAmortiMesesFiscal;
	private String depreFiscalAnual;
	private String depreciadoAcumuladoFiscal;
	private String saldoDepreciarFiscal;
	private String tipoRegistro;
	
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getCentroCosto() {
		return centroCosto;
	}
	public void setCentroCosto(String centroCosto) {
		this.centroCosto = centroCosto;
	}
	public String getTipoActivo() {
		return tipoActivo;
	}
	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getDescCentroCosto() {
		return descCentroCosto;
	}
	public void setDescCentroCosto(String descCentroCosto) {
		this.descCentroCosto = descCentroCosto;
	}
	public String getDescTipoActivo() {
		return descTipoActivo;
	}
	public void setDescTipoActivo(String descTipoActivo) {
		this.descTipoActivo = descTipoActivo;
	}
	public String getDescClasificacion() {
		return descClasificacion;
	}
	public void setDescClasificacion(String descClasificacion) {
		this.descClasificacion = descClasificacion;
	}
	public String getDescActivo() {
		return descActivo;
	}
	public String getFechaAdquisicion() {
		return fechaAdquisicion;
	}
	public String getNumFactura() {
		return numFactura;
	}
	public String getPolizaFactura() {
		return polizaFactura;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public String getMoi() {
		return moi;
	}
	public String getDepreciacionAnual() {
		return depreciacionAnual;
	}
	public String getTiempoAmortiMeses() {
		return tiempoAmortiMeses;
	}
	public String getDepreContaAnual() {
		return depreContaAnual;
	}
	public String getDepreciadoAcumulado() {
		return depreciadoAcumulado;
	}
	public String getTotalDepreciar() {
		return totalDepreciar;
	}
	public void setDescActivo(String descActivo) {
		this.descActivo = descActivo;
	}
	public void setFechaAdquisicion(String fechaAdquisicion) {
		this.fechaAdquisicion = fechaAdquisicion;
	}
	public void setNumFactura(String numFactura) {
		this.numFactura = numFactura;
	}
	public void setPolizaFactura(String polizaFactura) {
		this.polizaFactura = polizaFactura;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public void setMoi(String moi) {
		this.moi = moi;
	}
	public void setDepreciacionAnual(String depreciacionAnual) {
		this.depreciacionAnual = depreciacionAnual;
	}
	public void setTiempoAmortiMeses(String tiempoAmortiMeses) {
		this.tiempoAmortiMeses = tiempoAmortiMeses;
	}
	public void setDepreContaAnual(String depreContaAnual) {
		this.depreContaAnual = depreContaAnual;
	}
	public void setDepreciadoAcumulado(String depreciadoAcumulado) {
		this.depreciadoAcumulado = depreciadoAcumulado;
	}
	public void setTotalDepreciar(String totalDepreciar) {
		this.totalDepreciar = totalDepreciar;
	}
	public String getClasificaActivoID() {
		return clasificaActivoID;
	}
	public void setClasificaActivoID(String clasificaActivoID) {
		this.clasificaActivoID = clasificaActivoID;
	}
	public String getDescEstatus() {
		return descEstatus;
	}
	public void setDescEstatus(String descEstatus) {
		this.descEstatus = descEstatus;
	}
	public String getDepreciacionAnualFiscal() {
		return depreciacionAnualFiscal;
	}
	public void setDepreciacionAnualFiscal(String depreciacionAnualFiscal) {
		this.depreciacionAnualFiscal = depreciacionAnualFiscal;
	}
	public String getTiempoAmortiMesesFiscal() {
		return tiempoAmortiMesesFiscal;
	}
	public void setTiempoAmortiMesesFiscal(String tiempoAmortiMesesFiscal) {
		this.tiempoAmortiMesesFiscal = tiempoAmortiMesesFiscal;
	}
	public String getDepreFiscalAnual() {
		return depreFiscalAnual;
	}
	public void setDepreFiscalAnual(String depreFiscalAnual) {
		this.depreFiscalAnual = depreFiscalAnual;
	}
	public String getDepreciadoAcumuladoFiscal() {
		return depreciadoAcumuladoFiscal;
	}
	public void setDepreciadoAcumuladoFiscal(String depreciadoAcumuladoFiscal) {
		this.depreciadoAcumuladoFiscal = depreciadoAcumuladoFiscal;
	}
	public String getSaldoDepreciarFiscal() {
		return saldoDepreciarFiscal;
	}
	public void setSaldoDepreciarFiscal(String saldoDepreciarFiscal) {
		this.saldoDepreciarFiscal = saldoDepreciarFiscal;
	}
	public String getTipoRegistro() {
		return tipoRegistro;
	}
	public void setTipoRegistro(String tipoRegistro) {
		this.tipoRegistro = tipoRegistro;
	}
	
}
