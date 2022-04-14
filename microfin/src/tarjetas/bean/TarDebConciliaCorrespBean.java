package tarjetas.bean;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class TarDebConciliaCorrespBean extends BaseBean {
	// variables de la tabla TesomovsConcilia (externos)
	private String	numAutorizacion;
	private String	conciliaID;
	private String	detalleID;
	private String	fechaConsumo;
	private String	fechaProceso;
	private String	tipoOperacion;
	private String	descTipoOperacion;
	private String	numCuenta;
	private String	monto;
	private String	estatusConci;
	
	private List	lisNumAutorizacion;
	private List	lisConciliaID;
	private List	lisDetalleID;
	private List	lisFechaConsumo;
	private List	lisFechaProceso;
	private List	lisTipoOperacion;
	private List	lisDescTipoOperacion;
	private List	lisNumCuenta;
	private List	lisMonto;
	private List	lisEstatusConci;
	
	public String getNumAutorizacion() {
		return numAutorizacion;
	}
	public void setNumAutorizacion(String numAutorizacion) {
		this.numAutorizacion = numAutorizacion;
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
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getDescTipoOperacion() {
		return descTipoOperacion;
	}
	public void setDescTipoOperacion(String descTipoOperacion) {
		this.descTipoOperacion = descTipoOperacion;
	}
	public String getNumCuenta() {
		return numCuenta;
	}
	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getEstatusConci() {
		return estatusConci;
	}
	public void setEstatusConci(String estatusConci) {
		this.estatusConci = estatusConci;
	}
	public List getLisNumAutorizacion() {
		return lisNumAutorizacion;
	}
	public void setLisNumAutorizacion(List lisNumAutorizacion) {
		this.lisNumAutorizacion = lisNumAutorizacion;
	}
	public List getLisConciliaID() {
		return lisConciliaID;
	}
	public void setLisConciliaID(List lisConciliaID) {
		this.lisConciliaID = lisConciliaID;
	}
	public List getLisDetalleID() {
		return lisDetalleID;
	}
	public void setLisDetalleID(List lisDetalleID) {
		this.lisDetalleID = lisDetalleID;
	}
	public List getLisFechaConsumo() {
		return lisFechaConsumo;
	}
	public void setLisFechaConsumo(List lisFechaConsumo) {
		this.lisFechaConsumo = lisFechaConsumo;
	}
	public List getLisFechaProceso() {
		return lisFechaProceso;
	}
	public void setLisFechaProceso(List lisFechaProceso) {
		this.lisFechaProceso = lisFechaProceso;
	}
	public List getLisTipoOperacion() {
		return lisTipoOperacion;
	}
	public void setLisTipoOperacion(List lisTipoOperacion) {
		this.lisTipoOperacion = lisTipoOperacion;
	}
	public List getLisDescTipoOperacion() {
		return lisDescTipoOperacion;
	}
	public void setLisDescTipoOperacion(List lisDescTipoOperacion) {
		this.lisDescTipoOperacion = lisDescTipoOperacion;
	}
	public List getLisNumCuenta() {
		return lisNumCuenta;
	}
	public void setLisNumCuenta(List lisNumCuenta) {
		this.lisNumCuenta = lisNumCuenta;
	}
	public List getLisMonto() {
		return lisMonto;
	}
	public void setLisMonto(List lisMonto) {
		this.lisMonto = lisMonto;
	}
	public List getLisEstatusConci() {
		return lisEstatusConci;
	}
	public void setLisEstatusConci(List lisEstatusConci) {
		this.lisEstatusConci = lisEstatusConci;
	}
	
}