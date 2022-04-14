package credito.bean;

import general.bean.BaseBean;

public class BitacoraCobAutoBean extends BaseBean{
	
	//Declaracion de Constantes 
	public static final String PAGO_APLICADO = "A"; 
	public static final String PAGO_FALLIDO = "F";
	
	//Declaracion de Variables o Atributos
	private String fechaProceso;
	private String estatus;
	private String creditoID;
	private String clienteID;	
	private String cuentaID;
	private double disponibleCuenta;
	private double montoExigible;
	private double montoAplicado;
	private double tiempoProceso;	
	private int numeroPagosPorFecha;
	private String grupoID;
	
	private String empresaID;
	public String getFechaProceso() {
		return fechaProceso;
	}
	public void setFechaProceso(String fechaProceso) {
		this.fechaProceso = fechaProceso;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
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
	public double getDisponibleCuenta() {
		return disponibleCuenta;
	}
	public void setDisponibleCuenta(double disponibleCuenta) {
		this.disponibleCuenta = disponibleCuenta;
	}
	public double getMontoExigible() {
		return montoExigible;
	}
	public void setMontoExigible(double montoExigible) {
		this.montoExigible = montoExigible;
	}
	public double getMontoAplicado() {
		return montoAplicado;
	}
	public void setMontoAplicado(double montoAplicado) {
		this.montoAplicado = montoAplicado;
	}
	public double getTiempoProceso() {
		return tiempoProceso;
	}
	public void setTiempoProceso(double tiempoProceso) {
		this.tiempoProceso = tiempoProceso;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public int getNumeroPagosPorFecha() {
		return numeroPagosPorFecha;
	}
	public void setNumeroPagosPorFecha(int numeroPagosPorFecha) {
		this.numeroPagosPorFecha = numeroPagosPorFecha;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}


	

}
