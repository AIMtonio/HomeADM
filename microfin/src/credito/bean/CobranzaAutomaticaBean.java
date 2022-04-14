package credito.bean;

import general.bean.BaseBean;

public class CobranzaAutomaticaBean extends BaseBean{
	
	//Declaracion de Constantes 
	
	//Declaracion de Variables o Atributos
	private String creditoID;
	private String clienteID;
	private String cuentaID;
	private String monedaID;
	
	private double porcentajeIVA; 
	private String pagaIVA;
	private double saldoCapital;
	private double saldoInteres;
	private double saldoMoratorios;
	private double saldoComisiones;
	private double montoExigible;
	private double saldoIVAs;
	private double disponibleCuenta;
	private String grupoCreditoID;
	private int cicloGrupo;
	private String prorratea;
	private String esAutomatico;
	private String cobraGarFOGA;
	private String cobraGarFOGAFI;
	
	
	
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaID() {
		return cuentaID;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
	}
	public double getPorcentajeIVA() {
		return porcentajeIVA;
	}
	public void setPorcentajeIVA(double porcentajeIVA) {
		this.porcentajeIVA = porcentajeIVA;
	}
	public String getPagaIVA() {
		return pagaIVA;
	}
	public void setPagaIVA(String pagaIVA) {
		this.pagaIVA = pagaIVA;
	}
	public double getSaldoCapital() {
		return saldoCapital;
	}
	public void setSaldoCapital(double saldoCapital) {
		this.saldoCapital = saldoCapital;
	}
	public double getSaldoInteres() {
		return saldoInteres;
	}
	public void setSaldoInteres(double saldoInteres) {
		this.saldoInteres = saldoInteres;
	}
	public double getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public void setSaldoMoratorios(double saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public double getSaldoComisiones() {
		return saldoComisiones;
	}
	public void setSaldoComisiones(double saldoComisiones) {
		this.saldoComisiones = saldoComisiones;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public double getDisponibleCuenta() {
		return disponibleCuenta;
	}
	public void setDisponibleCuenta(double disponibleCuenta) {
		this.disponibleCuenta = disponibleCuenta;
	}
	public double getSaldoIVAs() {
		return saldoIVAs;
	}
	public void setSaldoIVAs(double saldoIVAs) {
		this.saldoIVAs = saldoIVAs;
	}
	public String getGrupoCreditoID() {
		return grupoCreditoID;
	}
	public void setGrupoCreditoID(String grupoCreditoID) {
		this.grupoCreditoID = grupoCreditoID;
	}
	public double getMontoExigible() {
		return montoExigible;
	}
	public void setMontoExigible(double montoExigible) {
		this.montoExigible = montoExigible;
	}
	public int getCicloGrupo() {
		return cicloGrupo;
	}
	public void setCicloGrupo(int cicloGrupo) {
		this.cicloGrupo = cicloGrupo;
	}
	public String getProrratea() {
		return prorratea;
	}
	public void setProrratea(String prorratea) {
		this.prorratea = prorratea;
	}
	public String getEsAutomatico() {
		return esAutomatico;
	}
	public void setEsAutomatico(String esAutomatico) {
		this.esAutomatico = esAutomatico;
	}
	public String getCobraGarFOGA() {
		return cobraGarFOGA;
	}
	public void setCobraGarFOGA(String cobraGarFOGA) {
		this.cobraGarFOGA = cobraGarFOGA;
	}
	public String getCobraGarFOGAFI() {
		return cobraGarFOGAFI;
	}
	public void setCobraGarFOGAFI(String cobraGarFOGAFI) {
		this.cobraGarFOGAFI = cobraGarFOGAFI;
	}
	
	
}
