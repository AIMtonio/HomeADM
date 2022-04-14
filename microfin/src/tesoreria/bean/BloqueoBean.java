package tesoreria.bean;

import general.bean.BaseBean;

public class BloqueoBean extends BaseBean{
	
	//Bean Para realizar los Bloqueos o Desbloqueos
	
	private String bloqueoID;
	private String cuentaAhoID;
	private String descripcionCta;//descripcion de la cuentaAho
	//el dato auxMonto no se encuentra en la tabla es solo un auxiliar//
	private String auxMonto;
	private String natMovimiento;
	private String fechaMov;
	private String montoBloq;
	private String fechaDesbloq;
	private String tiposBloqID;
	private String descripcion;
	private String referencia;
	
	// auxiliares del bean 
	private String mes;
	private String anio;
	private String saldoActual;
	private String saldoDispon;
	private String saldoSBC;
	
	public String getBloqueoID() {
		return bloqueoID;
	}
	public void setBloqueoID(String bloqueoID) {
		this.bloqueoID = bloqueoID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	/*get y set de la descripcion de la cuentaAho*/
	public String getDescripcionCta() {
		return descripcionCta;
	}
	public void setDescripcionCta(String descripcionCta) {
		this.descripcionCta = descripcionCta;
	}
	/*fin de get y set de descripcion de la cuentaAho*/
	public String getAuxMonto() {
		return auxMonto;
	}
	public void setAuxMonto(String auxMonto) {
		this.auxMonto = auxMonto;
	}
	public String getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public String getFechaMov() {
		return fechaMov;
	}
	public void setFechaMov(String fechaMov) {
		this.fechaMov = fechaMov;
	}
	public String getMontoBloq() {
		return montoBloq;
	}
	public void setMontoBloq(String montoBloq) {
		this.montoBloq = montoBloq;
	}
	public String getFechaDesbloq() {
		return fechaDesbloq;
	}
	public void setFechaDesbloq(String fechaDesbloq) {
		this.fechaDesbloq = fechaDesbloq;
	}
	public String getTiposBloqID() {
		return tiposBloqID;
	}
	public void setTiposBloqID(String tiposBloqID) {
		this.tiposBloqID = tiposBloqID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getSaldoActual() {
		return saldoActual;
	}
	public void setSaldoActual(String saldoActual) {
		this.saldoActual = saldoActual;
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
	
}
