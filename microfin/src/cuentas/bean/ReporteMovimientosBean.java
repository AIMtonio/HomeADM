package cuentas.bean;

import general.bean.BaseBean;

public class ReporteMovimientosBean extends BaseBean {
	private String cuentaAhoID;
	private String fecha;
	private String natMovimiento;		
	private String cantidadMov;	
	private String descripcionMov;
	private String referenciaMov;
	private String saldo;
	
	private String clienteID;
	private String nombreCompleto;
	private String tipoCuentaID;
	private String descripcionTC;
	private String monedaID;
	private String descripcionMo;		
	private String saldoIniMes;
	private String cargosMes;			
	private String abonosMes;
	private String saldoIniDia;
	private String cargosDia;			
	private String abonosDia;
	
	private String anio;			
	private String mes;
	private String saldoDispon;
	private String saldoSBC;
	private String saldoBloq;
	private String fechaSistemaMov;
	private String saldoProm;
	private String saldoCargosPend;
	private String gat;
	private String gatReal;
	
	public String getGat() {
		return gat;
	}
	public void setGat(String gat) {
		this.gat = gat;
	}
	private String usuario;
	private String nombreInstitucion;
	private String fechaSistema;
	
	
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public String getCantidadMov() {
		return cantidadMov;
	}
	public void setCantidadMov(String cantidadMov) {
		this.cantidadMov = cantidadMov;
	}
	public String getDescripcionMov() {
		return descripcionMov;
	}
	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
	}
	public String getReferenciaMov() {
		return referenciaMov;
	}
	public void setReferenciaMov(String referenciaMov) {
		this.referenciaMov = referenciaMov;
	}
	public String getSaldo() {
		return saldo;
	}
	public void setSaldo(String saldo) {
		this.saldo = saldo;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getTipoCuentaID() {
		return tipoCuentaID;
	}
	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}
	public String getDescripcionTC() {
		return descripcionTC;
	}
	public void setDescripcionTC(String descripcionTC) {
		this.descripcionTC = descripcionTC;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getDescripcionMo() {
		return descripcionMo;
	}
	public void setDescripcionMo(String descripcionMo) {
		this.descripcionMo = descripcionMo;
	}
	public String getSaldoIniMes() {
		return saldoIniMes;
	}
	public void setSaldoIniMes(String saldoIniMes) {
		this.saldoIniMes = saldoIniMes;
	}
	public String getCargosMes() {
		return cargosMes;
	}
	public void setCargosMes(String cargosMes) {
		this.cargosMes = cargosMes;
	}
	public String getAbonosMes() {
		return abonosMes;
	}
	public void setAbonosMes(String abonosMes) {
		this.abonosMes = abonosMes;
	}
	public String getSaldoIniDia() {
		return saldoIniDia;
	}
	public void setSaldoIniDia(String saldoIniDia) {
		this.saldoIniDia = saldoIniDia;
	}
	public String getCargosDia() {
		return cargosDia;
	}
	public void setCargosDia(String cargosDia) {
		this.cargosDia = cargosDia;
	}
	public String getAbonosDia() {
		return abonosDia;
	}
	public void setAbonosDia(String abonosDia) {
		this.abonosDia = abonosDia;
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
	public String getSaldoDispon() {
		return saldoDispon;
	}
	public void setSaldoDispon(String saldoDispon) {
		this.saldoDispon = saldoDispon;
	}
	public String getSaldoSBC() {
		return saldoSBC;
	}
	public void setSaldoSBC(String saldoSBC) {
		this.saldoSBC = saldoSBC;
	}
	public String getSaldoBloq() {
		return saldoBloq;
	}
	public void setSaldoBloq(String saldoBloq) {
		this.saldoBloq = saldoBloq;
	}
	public String getFechaSistemaMov() {
		return fechaSistemaMov;
	}
	public void setFechaSistemaMov(String fechaSistemaMov) {
		this.fechaSistemaMov = fechaSistemaMov;
	}
	public String getSaldoProm() {
		return saldoProm;
	}
	public void setSaldoProm(String saldoProm) {
		this.saldoProm = saldoProm;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getSaldoCargosPend() {
		return saldoCargosPend;
	}
	public void setSaldoCargosPend(String saldoCargosPend) {
		this.saldoCargosPend = saldoCargosPend;
	}
	public String getGatReal() {
		return gatReal;
	}
	public void setGatReal(String gatReal) {
		this.gatReal = gatReal;
	}	    
}
