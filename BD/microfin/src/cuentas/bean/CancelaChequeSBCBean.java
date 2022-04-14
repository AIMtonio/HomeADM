package cuentas.bean;

import general.bean.BaseBean;
import herramientas.Utileria;

public class CancelaChequeSBCBean extends BaseBean {

	private String chequeSBCID;// Par_ChequeSBCID
	private String cuentaAhoID;// Par_CuentaAhoID
	private String clienteID; // Par_ClienteID
	private String comFalsoCobro;// Par_MontoComision
	private String bancoEmisor;// Par_BancoEmisor
	private String cuentaEmisor;// Par_CuentaEmisor
	private String nombreEmisor;// Par_NombreEmisor
	private String tipoCuenta;//
	private String saldDispo;//
	private String saldoSBC;//
	private String comision;//
	private String montoCheque;// Par_MontoCheque
	private String fechaRec;//
	private String montoIva;// Par_MontoIVAComision
	// auiliares
	private String numCheque;
	private String polizaID;
	private String descCheque;
	private String montos;
	private String descripcion;
	private String tipoCuentaID;
	private String descbancoEmisor;

	
	// °°°°°°°°°°°°°°°°°°°°°°°°|GETTER AND
	// SETTER|°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
	public String getChequeSBCID() {
		return chequeSBCID;
	}

	public void setChequeSBCID(String chequeSBCID) {
		this.chequeSBCID = chequeSBCID;
	}

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}


	public String getBancoEmisor() {
		return bancoEmisor;
	}

	public void setBancoEmisor(String bancoEmisor) {
		this.bancoEmisor = bancoEmisor;
	}

	public String getCuentaEmisor() {
		return cuentaEmisor;
	}

	public void setCuentaEmisor(String cuentaEmisor) {
		this.cuentaEmisor = cuentaEmisor;
	}

	public String getNombreEmisor() {
		return nombreEmisor;
	}

	public void setNombreEmisor(String nombreEmisor) {
		this.nombreEmisor = nombreEmisor;
	}

	public String getTipoCuenta() {
		return tipoCuenta;
	}

	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getSaldDispo() {
		return saldDispo;
	}

	public void setSaldDispo(String saldDispo) {
		this.saldDispo = saldDispo;
	}

	public String getSaldoSBC() {
		return saldoSBC;
	}

	public void setSaldoSBC(String saldoSBC) {
		this.saldoSBC = saldoSBC;
	}

	public String getComision() {
		return comision;
	}

	public void setComision(String comision) {
		this.comision = comision;
	}

	public String getFechaRec() {
		return fechaRec;
	}

	public void setFechaRec(String fechaRec) {
		this.fechaRec = fechaRec;
	}

	public String getPolizaID() {
		return polizaID;
	}

	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}

	public String getDescCheque() {
		return descCheque;
	}

	public void setDescCheque(String descCheque) {
		this.descCheque = descCheque;
	}

	public String getMontos() {
		return montos;
	}

	public void setMontos(String montos) {
		this.montos = montos;
	}

	public String getNumCheque() {
		return numCheque;
	}

	public void setNumCheque(String numCheque) {
		this.numCheque = numCheque;
	}

	public String getMontoIva() {
		return montoIva;
	}

	public void setMontoIva(String montoIva) {
		this.montoIva = montoIva;
	}

	public String getMontoCheque() {
		return montoCheque;
	}

	public void setMontoCheque(String montoCheque) {
		this.montoCheque = montoCheque;
	}
	public String getComFalsoCobro() {
		return comFalsoCobro;
	}

	public void setComFalsoCobro(String comFalsoCobro) {
		this.comFalsoCobro = comFalsoCobro;
	}

	public String getTipoCuentaID() {
		return tipoCuentaID;
	}

	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}
	public String getDescbancoEmisor() {
		return descbancoEmisor;
	}

	public void setDescbancoEmisor(String descbancoEmisor) {
		this.descbancoEmisor = descbancoEmisor;
	}

}
