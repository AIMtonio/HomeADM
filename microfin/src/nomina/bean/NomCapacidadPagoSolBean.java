package nomina.bean;

import general.bean.BaseBean;

public class NomCapacidadPagoSolBean extends BaseBean{

	private String nomCapacidadPagoSolID;
	private String solicitudCreditoID;
	private String capacidadPago; 		
	private String montoCasasComer;		
	private String montoResguardo;		
	private String porcentajeCapacidad;
	
	private String[] clasifClavePresupID;
	private String[] descClasifClavePresup;
	private String[] clavePresupID;	
	private String[] clave;	
	private String[] descClavePresup;	
	private String[] monto;	
	
	private String listaClasifClavPresup;	
	private String casaComercialID;
	private String nombreCasaCom;
	private String montoCasaComercial;
	
	
	public String getNomCapacidadPagoSolID() {
		return nomCapacidadPagoSolID;
	}
	public void setNomCapacidadPagoSolID(String nomCapacidadPagoSolID) {
		this.nomCapacidadPagoSolID = nomCapacidadPagoSolID;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getCapacidadPago() {
		return capacidadPago;
	}
	public void setCapacidadPago(String capacidadPago) {
		this.capacidadPago = capacidadPago;
	}
	public String getMontoCasasComer() {
		return montoCasasComer;
	}
	public void setMontoCasasComer(String montoCasasComer) {
		this.montoCasasComer = montoCasasComer;
	}
	public String getMontoResguardo() {
		return montoResguardo;
	}
	public void setMontoResguardo(String montoResguardo) {
		this.montoResguardo = montoResguardo;
	}
	public String getPorcentajeCapacidad() {
		return porcentajeCapacidad;
	}
	public void setPorcentajeCapacidad(String porcentajeCapacidad) {
		this.porcentajeCapacidad = porcentajeCapacidad;
	}
	public String[] getClasifClavePresupID() {
		return clasifClavePresupID;
	}
	public void setClasifClavePresupID(String[] clasifClavePresupID) {
		this.clasifClavePresupID = clasifClavePresupID;
	}
	public String[] getDescClasifClavePresup() {
		return descClasifClavePresup;
	}
	public void setDescClasifClavePresup(String[] descClasifClavePresup) {
		this.descClasifClavePresup = descClasifClavePresup;
	}
	public String[] getClavePresupID() {
		return clavePresupID;
	}
	public void setClavePresupID(String[] clavePresupID) {
		this.clavePresupID = clavePresupID;
	}
	public String[] getClave() {
		return clave;
	}
	public void setClave(String[] clave) {
		this.clave = clave;
	}
	public String[] getDescClavePresup() {
		return descClavePresup;
	}
	public void setDescClavePresup(String[] descClavePresup) {
		this.descClavePresup = descClavePresup;
	}
	public String[] getMonto() {
		return monto;
	}
	public void setMonto(String[] monto) {
		this.monto = monto;
	}
	public String getListaClasifClavPresup() {
		return listaClasifClavPresup;
	}
	public void setListaClasifClavPresup(String listaClasifClavPresup) {
		this.listaClasifClavPresup = listaClasifClavPresup;
	}

	public String getCasaComercialID() {
		return casaComercialID;
	}
	public void setCasaComercialID(String casaComercialID) {
		this.casaComercialID = casaComercialID;
	}
	public String getNombreCasaCom() {
		return nombreCasaCom;
	}
	public void setNombreCasaCom(String nombreCasaCom) {
		this.nombreCasaCom = nombreCasaCom;
	}
	public String getMontoCasaComercial() {
		return montoCasaComercial;
	}
	public void setMontoCasaComercial(String montoCasaComercial) {
		this.montoCasaComercial = montoCasaComercial;
	}	
	
	
	
}
