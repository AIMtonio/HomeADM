package tarjetas.bean;

import general.bean.BaseBean;

public class TarDebMovsGridBean extends BaseBean{
	// se utiliza para la conciliacion de Movimientos.
		
	//variables de la tabla TesoreriaMovs (Internos)
	private String tarDebMovID; 
	private String tipoOperacionID; 
	private String descOperacion;
	private String tarjetaDebID; 
	private String montoOperacion;
	private String fechaOperacion; 
	private String numReferencia;
	
	//variables de la tabla TesomovsConcilia (externos)
	private String conciliaID; 
	private String detalleID;
	private String numCuenta; 
	private String fechaConsumo; 
	private String fechaProceso; 
	private String tipoTransaccion;
	private String descTipoTransaccion;
	private String importeOrigenTrans;
	private String numAutorizacion;
	private String estatusConci;
	
	public String getTarDebMovID() {
		return tarDebMovID;
	}
	public void setTarDebMovID(String tarDebMovID) {
		this.tarDebMovID = tarDebMovID;
	}
	public String getTipoOperacionID() {
		return tipoOperacionID;
	}
	public void setTipoOperacionID(String tipoOperacionID) {
		this.tipoOperacionID = tipoOperacionID;
	}
	public String getDescOperacion() {
		return descOperacion;
	}
	public void setDescOperacion(String descOperacion) {
		this.descOperacion = descOperacion;
	}
	public String getTarjetaDebID() {
		return tarjetaDebID;
	}
	public void setTarjetaDebID(String tarjetaDebID) {
		this.tarjetaDebID = tarjetaDebID;
	}
	public String getMontoOperacion() {
		return montoOperacion;
	}
	public void setMontoOperacion(String montoOperacion) {
		this.montoOperacion = montoOperacion;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getNumReferencia() {
		return numReferencia;
	}
	public void setNumReferencia(String numReferencia) {
		this.numReferencia = numReferencia;
	}
	public String getConciliaID() {
		return conciliaID;
	}
	public void setConciliaID(String conciliaID) {
		this.conciliaID = conciliaID;
	}
	public String getDetalleID() {
		return detalleID;
	}
	public void setDetalleID(String detalleID) {
		this.detalleID = detalleID;
	}
	public String getNumCuenta() {
		return numCuenta;
	}
	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}
	public String getFechaConsumo() {
		return fechaConsumo;
	}
	public void setFechaConsumo(String fechaConsumo) {
		this.fechaConsumo = fechaConsumo;
	}
	public String getFechaProceso() {
		return fechaProceso;
	}
	public void setFechaProceso(String fechaProceso) {
		this.fechaProceso = fechaProceso;
	}
	public String getTipoTransaccion() {
		return tipoTransaccion;
	}
	public void setTipoTransaccion(String tipoTransaccion) {
		this.tipoTransaccion = tipoTransaccion;
	}
	public String getDescTipoTransaccion() {
		return descTipoTransaccion;
	}
	public void setDescTipoTransaccion(String descTipoTransaccion) {
		this.descTipoTransaccion = descTipoTransaccion;
	}
	public String getImporteOrigenTrans() {
		return importeOrigenTrans;
	}
	public void setImporteOrigenTrans(String importeOrigenTrans) {
		this.importeOrigenTrans = importeOrigenTrans;
	}
	public String getNumAutorizacion() {
		return numAutorizacion;
	}
	public void setNumAutorizacion(String numAutorizacion) {
		this.numAutorizacion = numAutorizacion;
	}
	public String getEstatusConci() {
		return estatusConci;
	}
	public void setEstatusConci(String estatusConci) {
		this.estatusConci = estatusConci;
	}
}