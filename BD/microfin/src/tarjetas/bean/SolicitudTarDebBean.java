package tarjetas.bean;

import general.bean.BaseBean;
public class SolicitudTarDebBean extends BaseBean{
	public static int LONGITUD_ID = 10;
	private String tipoTransaccion;
	private String clienteID;
	private String cuentaAhoID;
	private String nombreTarjeta;
	private String costo;
	private String folio;
	private String tarjetaTipo;
	private String cuenta;
	private String corpRelacionado;
	private String tarjetaID;
	private String numero;
	private String nombreCompleto;
	private String clienteCorp;
	private String clienteCorpID;
	private String folioSolicitudID;
	
	private String tarjetaDebAntID;
	private String estatus;
	private String descripcion;
	private String relacion;
	private String corpRelacionadoID;
	
	
	
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTarjetaDebAntID() {
		return tarjetaDebAntID;
	}
	public void setTarjetaDebAntID(String tarjetaDebAntID) {
		this.tarjetaDebAntID = tarjetaDebAntID;
	}
	
	public String getFolioSolicitudID() {
		return folioSolicitudID;
	}
	public void setFolioSolicitudID(String folioSolicitudID) {
		this.folioSolicitudID = folioSolicitudID;
	}
	public String getClienteCorp() {
		return clienteCorp;
	}
	public void setClienteCorp(String clienteCorp) {
		this.clienteCorp = clienteCorp;
	}
	public String getClienteCorpID() {
		return clienteCorpID;
	}
	public void setClienteCorpID(String clienteCorpID) {
		this.clienteCorpID = clienteCorpID;
	}
	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getCorpRelacionado() {
		return corpRelacionado;
	}
	public void setCorpRelacionado(String corpRelacionado) {
		this.corpRelacionado = corpRelacionado;
	}
	public String getTarjetaID() {
		return tarjetaID;
	}
	public void setTarjetaID(String tarjetaID) {
		this.tarjetaID = tarjetaID;
	}
	public String getTarjetaTipo() {
		return tarjetaTipo;
	}
	public void setTarjetaTipo(String tarjetaTipo) {
		this.tarjetaTipo = tarjetaTipo;
	}
	public String getCuenta() {
		return cuenta;
	}
	public void setCuenta(String cuenta) {
		this.cuenta = cuenta;
	}
	public String getFolio() {
		return folio;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}
	public String getTipoTransaccion() {
		return tipoTransaccion;
	}
	public void setTipoTransaccion(String tipoTransaccion) {
		this.tipoTransaccion = tipoTransaccion;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getNombreTarjeta() {
		return nombreTarjeta;
	}
	public void setNombreTarjeta(String nombreTarjeta) {
		this.nombreTarjeta = nombreTarjeta;
	}
	public String getCosto() {
		return costo;
	}
	public void setCosto(String costo) {
		this.costo = costo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	public String getRelacion() {
		return relacion;
	}
	public void setRelacion(String relacion) {
		this.relacion = relacion;
	}
	public String getCorpRelacionadoID() {
		return corpRelacionadoID;
	}
	public void setCorpRelacionadoID(String corpRelacionadoID) {
		this.corpRelacionadoID = corpRelacionadoID;
	}
}