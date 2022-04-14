package credito.bean;
import general.bean.BaseBean;

public class CastigosCarteraBean extends BaseBean {
	private String creditoID;
	private String motivoCastigoID;
	private String descricpion;
	
	private String fecha;
	private String capitalCastigado;
	private String interesCastigado;
	private String totalCastigo;	
	private String monRecuperado;
	private String estatusCredito;
	private String observaciones;
	private String saldoMoratorios;
	private String saldoAccesorios;
	private String accesorioCastigado;
	private String intMoraCastigado;
	private String IVA;
	private String porRecuperar;
	private String tipoCastigo;
	private String polizaID;
	private String tipoCobranza;
	
	public static String castigoCartera	= "59";				// Concepto Contable: Castigo de Cartera
	public static String desCastigoCartera = "CASTIGO DE CARTERA";     //Descripcion Concepto Contable de Inversion: Capital 
	
	
	public String getPorRecuperar() {
		return porRecuperar;
	}
	public void setPorRecuperar(String porRecuperar) {
		this.porRecuperar = porRecuperar;
	}
	public String getIVA() {
		return IVA;
	}
	public void setIVA(String iVA) {
		IVA = iVA;
	}
	
	public String getCreditoID() {
		return creditoID;
	}
	public String getMotivoCastigoID() {
		return motivoCastigoID;
	}
	public String getDescricpion() {
		return descricpion;
	}
	public String getFecha() {
		return fecha;
	}
	public String getCapitalCastigado() {
		return capitalCastigado;
	}
	public String getInteresCastigado() {
		return interesCastigado;
	}
	public String getTotalCastigo() {
		return totalCastigo;
	}
	public String getMonRecuperado() {
		return monRecuperado;
	}
	public String getEstatusCredito() {
		return estatusCredito;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public void setMotivoCastigoID(String motivoCastigoID) {
		this.motivoCastigoID = motivoCastigoID;
	}
	public void setDescricpion(String descricpion) {
		this.descricpion = descricpion;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public void setCapitalCastigado(String capitalCastigado) {
		this.capitalCastigado = capitalCastigado;
	}
	public void setInteresCastigado(String interesCastigado) {
		this.interesCastigado = interesCastigado;
	}
	public void setTotalCastigo(String totalCastigo) {
		this.totalCastigo = totalCastigo;
	}
	public void setMonRecuperado(String monRecuperado) {
		this.monRecuperado = monRecuperado;
	}
	public void setEstatusCredito(String estatusCredito) {
		this.estatusCredito = estatusCredito;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public String getSaldoAccesorios() {
		return saldoAccesorios;
	}
	public void setSaldoAccesorios(String saldoAccesorios) {
		this.saldoAccesorios = saldoAccesorios;
	}
	public String getAccesorioCastigado() {
		return accesorioCastigado;
	}
	public void setAccesorioCastigado(String accesorioCastigado) {
		this.accesorioCastigado = accesorioCastigado;
	}
	public String getIntMoraCastigado() {
		return intMoraCastigado;
	}
	public void setIntMoraCastigado(String intMoraCastigado) {
		this.intMoraCastigado = intMoraCastigado;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getTipoCastigo() {
		return tipoCastigo;
	}
	public void setTipoCastigo(String tipoCastigo) {
		this.tipoCastigo = tipoCastigo;
	}
	public String getTipoCobranza() {
		return tipoCobranza;
	}
	public void setTipoCobranza(String tipoCobranza) {
		this.tipoCobranza = tipoCobranza;
	}	
	
	
}
