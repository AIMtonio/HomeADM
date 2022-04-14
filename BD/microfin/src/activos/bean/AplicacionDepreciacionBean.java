package activos.bean;

import general.bean.BaseBean;

public class AplicacionDepreciacionBean extends BaseBean{
	public static String concepContaDeprecia = "1000"; //Concepto Contable depreciacion y amortizacion (CONCEPTOSCONTA)
	public static String descripConcepContaDeprecia	= "DEPRECIACION Y AMORTIZACION DE ACTIVOS";	//Descripcion Concepto Contable
		
	private String anio;
	private String mes;
	private String fechaSistema;
	private String nombreInstitucion;
	private String claveUsuario;
	private String numTransaccion;
	
	private String descCentroCosto;
	private String descTipoActivo;
	private String descClasificacion;
	
	private String activoID;
	private String descActivo;
	private String fechaAdquisicion;
	private String numFactura;
	private String poliza;
	private String centroCostoID;
	private String moi;
	private String depreciacionAnual;
	private String tiempoAmortiMeses;
	private String depreciaContaAnual;
	private String enero;
	private String febrero;
	private String marzo;
	private String abril;
	private String mayo;
	private String junio;
	private String julio;
	private String agosto;
	private String septiembre;
	private String octubre;
	private String noviembre;
	private String diciembre;
	private String depreciadoAcumulado;
	private String saldoPorDepreciar;
	
	private String usuarioID;
	private String sucursalID;
	private String descMes;
	private String polizaID;

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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
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
	public String getActivoID() {
		return activoID;
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
	public String getPoliza() {
		return poliza;
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
	public String getDepreciaContaAnual() {
		return depreciaContaAnual;
	}
	public String getEnero() {
		return enero;
	}
	public String getFebrero() {
		return febrero;
	}
	public String getMarzo() {
		return marzo;
	}
	public String getAbril() {
		return abril;
	}
	public String getMayo() {
		return mayo;
	}
	public String getJunio() {
		return junio;
	}
	public String getJulio() {
		return julio;
	}
	public String getAgosto() {
		return agosto;
	}
	public String getSeptiembre() {
		return septiembre;
	}
	public String getOctubre() {
		return octubre;
	}
	public String getNoviembre() {
		return noviembre;
	}
	public String getDiciembre() {
		return diciembre;
	}
	public String getDepreciadoAcumulado() {
		return depreciadoAcumulado;
	}
	public String getSaldoPorDepreciar() {
		return saldoPorDepreciar;
	}
	public void setActivoID(String activoID) {
		this.activoID = activoID;
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
	public void setPoliza(String poliza) {
		this.poliza = poliza;
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
	public void setDepreciaContaAnual(String depreciaContaAnual) {
		this.depreciaContaAnual = depreciaContaAnual;
	}
	public void setEnero(String enero) {
		this.enero = enero;
	}
	public void setFebrero(String febrero) {
		this.febrero = febrero;
	}
	public void setMarzo(String marzo) {
		this.marzo = marzo;
	}
	public void setAbril(String abril) {
		this.abril = abril;
	}
	public void setMayo(String mayo) {
		this.mayo = mayo;
	}
	public void setJunio(String junio) {
		this.junio = junio;
	}
	public void setJulio(String julio) {
		this.julio = julio;
	}
	public void setAgosto(String agosto) {
		this.agosto = agosto;
	}
	public void setSeptiembre(String septiembre) {
		this.septiembre = septiembre;
	}
	public void setOctubre(String octubre) {
		this.octubre = octubre;
	}
	public void setNoviembre(String noviembre) {
		this.noviembre = noviembre;
	}
	public void setDiciembre(String diciembre) {
		this.diciembre = diciembre;
	}
	public void setDepreciadoAcumulado(String depreciadoAcumulado) {
		this.depreciadoAcumulado = depreciadoAcumulado;
	}
	public void setSaldoPorDepreciar(String saldoPorDepreciar) {
		this.saldoPorDepreciar = saldoPorDepreciar;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getDescMes() {
		return descMes;
	}
	public void setDescMes(String descMes) {
		this.descMes = descMes;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	
}
