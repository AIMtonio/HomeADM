package pld.bean;

import general.bean.BaseBean;

public class ReporteOpeRemesasBean extends BaseBean{
	
	// Parametros de entrada
	private String fechaInicial;
	private String fechaFinal;
	private String entidadTDE;
	private String tipoOperacion;
	private String estatus;
	private String umbral;
	private String nombreEnt;
	
	// Parametros para el reporte en Excel
	private String nombreEntidad;
	private String numIdentificacion;
	private String fechaOperacion;
	private String montoOperacion;
	private String moneda;
	private String clienteID;
	private String apellidoPatBene;
	private String apellidoMatBene;
	private String nombreBene;
	private String razonSocialBene;
	private String tipoPersonaBene;
	private String tipoLiquidacion;
	private String fechaLiquidacion;
	private String montoLiquidacion;
	private String conceptoPago;
	private String causaDevolucion;
	private String monedaLiquidacion;
	private String cuentaClabe;
	private String apellidoPatRemi;
	private String apellidoMatRemi;
	private String nombreRemi;
	private String razonSocialRemi;
	private String tipoPersonaRemi;
	private String estatusOperacion;
	
	// Parametros para la consulta de remesedoras
	 private String remesaID;
	 private String nombreRemesa;
	 
	
	public String getFechaInicial() {
		return fechaInicial;
	}
	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	public String getEntidadTDE() {
		return entidadTDE;
	}
	public void setEntidadTDE(String entidadTDE) {
		this.entidadTDE = entidadTDE;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getUmbral() {
		return umbral;
	}
	public void setUmbral(String umbral) {
		this.umbral = umbral;
	}
	public String getNombreEntidad() {
		return nombreEntidad;
	}
	public void setNombreEntidad(String nombreEntidad) {
		this.nombreEntidad = nombreEntidad;
	}
	public String getNombreEnt() {
		return nombreEnt;
	}
	public void setNombreEnt(String nombreEnt) {
		this.nombreEnt = nombreEnt;
	}
	public String getNumIdentificacion() {
		return numIdentificacion;
	}
	public void setNumIdentificacion(String numIdentificacion) {
		this.numIdentificacion = numIdentificacion;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getMontoOperacion() {
		return montoOperacion;
	}
	public void setMontoOperacion(String montoOperacion) {
		this.montoOperacion = montoOperacion;
	}
	public String getMoneda() {
		return moneda;
	}
	public void setMoneda(String moneda) {
		this.moneda = moneda;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getApellidoPatBene() {
		return apellidoPatBene;
	}
	public void setApellidoPatBene(String apellidoPatBene) {
		this.apellidoPatBene = apellidoPatBene;
	}
	public String getApellidoMatBene() {
		return apellidoMatBene;
	}
	public void setApellidoMatBene(String apellidoMatBene) {
		this.apellidoMatBene = apellidoMatBene;
	}
	public String getNombreBene() {
		return nombreBene;
	}
	public void setNombreBene(String nombreBene) {
		this.nombreBene = nombreBene;
	}
	public String getRazonSocialBene() {
		return razonSocialBene;
	}
	public void setRazonSocialBene(String razonSocialBene) {
		this.razonSocialBene = razonSocialBene;
	}
	public String getTipoPersonaBene() {
		return tipoPersonaBene;
	}
	public void setTipoPersonaBene(String tipoPersonaBene) {
		this.tipoPersonaBene = tipoPersonaBene;
	}
	public String getTipoLiquidacion() {
		return tipoLiquidacion;
	}
	public void setTipoLiquidacion(String tipoLiquidacion) {
		this.tipoLiquidacion = tipoLiquidacion;
	}
	public String getFechaLiquidacion() {
		return fechaLiquidacion;
	}
	public void setFechaLiquidacion(String fechaLiquidacion) {
		this.fechaLiquidacion = fechaLiquidacion;
	}
	public String getMontoLiquidacion() {
		return montoLiquidacion;
	}
	public void setMontoLiquidacion(String montoLiquidacion) {
		this.montoLiquidacion = montoLiquidacion;
	}
	public String getConceptoPago() {
		return conceptoPago;
	}
	public void setConceptoPago(String conceptoPago) {
		this.conceptoPago = conceptoPago;
	}
	public String getCausaDevolucion() {
		return causaDevolucion;
	}
	public void setCausaDevolucion(String causaDevolucion) {
		this.causaDevolucion = causaDevolucion;
	}
	public String getMonedaLiquidacion() {
		return monedaLiquidacion;
	}
	public void setMonedaLiquidacion(String monedaLiquidacion) {
		this.monedaLiquidacion = monedaLiquidacion;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getApellidoPatRemi() {
		return apellidoPatRemi;
	}
	public void setApellidoPatRemi(String apellidoPatRemi) {
		this.apellidoPatRemi = apellidoPatRemi;
	}
	public String getApellidoMatRemi() {
		return apellidoMatRemi;
	}
	public void setApellidoMatRemi(String apellidoMatRemi) {
		this.apellidoMatRemi = apellidoMatRemi;
	}
	public String getNombreRemi() {
		return nombreRemi;
	}
	public void setNombreRemi(String nombreRemi) {
		this.nombreRemi = nombreRemi;
	}
	public String getRazonSocialRemi() {
		return razonSocialRemi;
	}
	public void setRazonSocialRemi(String razonSocialRemi) {
		this.razonSocialRemi = razonSocialRemi;
	}
	public String getTipoPersonaRemi() {
		return tipoPersonaRemi;
	}
	public void setTipoPersonaRemi(String tipoPersonaRemi) {
		this.tipoPersonaRemi = tipoPersonaRemi;
	}
	public String getEstatusOperacion() {
		return estatusOperacion;
	}
	public void setEstatusOperacion(String estatusOperacion) {
		this.estatusOperacion = estatusOperacion;
	}
	public String getRemesaID() {
		return remesaID;
	}
	public void setRemesaID(String remesaID) {
		this.remesaID = remesaID;
	}
	public String getNombreRemesa() {
		return nombreRemesa;
	}
	public void setNombreRemesa(String nombreRemesa) {
		this.nombreRemesa = nombreRemesa;
	}
	
}
