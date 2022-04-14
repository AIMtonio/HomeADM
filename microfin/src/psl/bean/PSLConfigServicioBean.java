package psl.bean;

import java.util.List;

import general.bean.BaseBean;

public class PSLConfigServicioBean extends BaseBean {
	private String servicioID;
	private String servicio;
	private String clasificacionServ;
	private String nomClasificacion;
	private String cContaServicio;
	private String cContaComision; 	
	private String cContaIVAComisi;
	private String nomenclaturaCC;
	private String ventanillaAct;
	private String cobComVentanilla;
	private String mtoCteVentanilla;
	private String mtoUsuVentanilla;
	private String bancaLineaAct;
	private String cobComBancaLinea;
	private String mtoCteBancaLinea;
	private String bancaMovilAct;
	private String cobComBancaMovil;
	private String mtoCteBancaMovil;
	private String estatus;		
	private String descCContaServicio;
	private String descCContaComision;
	private String descCContaIVAComisi;

	private List<String> serviciosID;
	private List<String> servicios;
	private List<String> clasificacionesServicio;
	
	private List<String> productosID;
	private List<String> productos;
	private List<String> habilitados;
	
	
	
	public String getServicioID() {
		return servicioID;
	}
	public void setServicioID(String servicioID) {
		this.servicioID = servicioID;
	}
	public String getServicio() {
		return servicio;
	}
	public void setServicio(String servicio) {
		this.servicio = servicio;
	}
	public String getClasificacionServ() {
		return clasificacionServ;
	}
	public void setClasificacionServ(String clasificacionServ) {
		this.clasificacionServ = clasificacionServ;
	}
	public String getNomClasificacion() {
		return nomClasificacion;
	}
	public void setNomClasificacion(String nomClasificacion) {
		this.nomClasificacion = nomClasificacion;
	}
	public String getCContaServicio() {
		return cContaServicio;
	}
	public void setCContaServicio(String cContaServicio) {
		this.cContaServicio = cContaServicio;
	}
	public String getCContaComision() {
		return cContaComision;
	}
	public void setCContaComision(String cContaComision) {
		this.cContaComision = cContaComision;
	}
	public String getCContaIVAComisi() {
		return cContaIVAComisi;
	}
	public void setCContaIVAComisi(String cContaIVAComisi) {
		this.cContaIVAComisi = cContaIVAComisi;
	}
	public String getNomenclaturaCC() {
		return nomenclaturaCC;
	}
	public void setNomenclaturaCC(String nomenclaturaCC) {
		this.nomenclaturaCC = nomenclaturaCC;
	}
	public String getVentanillaAct() {
		return ventanillaAct;
	}
	public void setVentanillaAct(String ventanillaAct) {
		this.ventanillaAct = ventanillaAct;
	}
	public String getCobComVentanilla() {
		return cobComVentanilla;
	}
	public void setCobComVentanilla(String cobComVentanilla) {
		this.cobComVentanilla = cobComVentanilla;
	}
	public String getMtoCteVentanilla() {
		return mtoCteVentanilla;
	}
	public void setMtoCteVentanilla(String mtoCteVentanilla) {
		this.mtoCteVentanilla = mtoCteVentanilla;
	}
	public String getMtoUsuVentanilla() {
		return mtoUsuVentanilla;
	}
	public void setMtoUsuVentanilla(String mtoUsuVentanilla) {
		this.mtoUsuVentanilla = mtoUsuVentanilla;
	}
	public String getBancaLineaAct() {
		return bancaLineaAct;
	}
	public void setBancaLineaAct(String bancaLineaAct) {
		this.bancaLineaAct = bancaLineaAct;
	}
	public String getCobComBancaLinea() {
		return cobComBancaLinea;
	}
	public void setCobComBancaLinea(String cobComBancaLinea) {
		this.cobComBancaLinea = cobComBancaLinea;
	}
	public String getMtoCteBancaLinea() {
		return mtoCteBancaLinea;
	}
	public void setMtoCteBancaLinea(String mtoCteBancaLinea) {
		this.mtoCteBancaLinea = mtoCteBancaLinea;
	}
	public String getBancaMovilAct() {
		return bancaMovilAct;
	}
	public void setBancaMovilAct(String bancaMovilAct) {
		this.bancaMovilAct = bancaMovilAct;
	}
	public String getCobComBancaMovil() {
		return cobComBancaMovil;
	}
	public void setCobComBancaMovil(String cobComBancaMovil) {
		this.cobComBancaMovil = cobComBancaMovil;
	}
	public String getMtoCteBancaMovil() {
		return mtoCteBancaMovil;
	}
	public void setMtoCteBancaMovil(String mtoCteBancaMovil) {
		this.mtoCteBancaMovil = mtoCteBancaMovil;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public List<String> getServiciosID() {
		return serviciosID;
	}
	public void setServiciosID(List<String> serviciosID) {
		this.serviciosID = serviciosID;
	}
	public List<String> getServicios() {
		return servicios;
	}
	public void setServicios(List<String> servicios) {
		this.servicios = servicios;
	}
	public List<String> getClasificacionesServicio() {
		return clasificacionesServicio;
	}
	public void setClasificacionesServicio(List<String> clasificacionesServicio) {
		this.clasificacionesServicio = clasificacionesServicio;
	}
	public List<String> getProductosID() {
		return productosID;
	}
	public void setProductosID(List<String> productosID) {
		this.productosID = productosID;
	}
	public List<String> getProductos() {
		return productos;
	}
	public void setProductos(List<String> productos) {
		this.productos = productos;
	}
	public List<String> getHabilitados() {
		return habilitados;
	}
	public void setHabilitados(List<String> habilitados) {
		this.habilitados = habilitados;
	}
	public String getDescCContaServicio() {
		return descCContaServicio;
	}
	public void setDescCContaServicio(String descCContaServicio) {
		this.descCContaServicio = descCContaServicio;
	}
	public String getDescCContaComision() {
		return descCContaComision;
	}
	public void setDescCContaComision(String descCContaComision) {
		this.descCContaComision = descCContaComision;
	}
	public String getDescCContaIVAComisi() {
		return descCContaIVAComisi;
	}
	public void setDescCContaIVAComisi(String descCContaIVAComisi) {
		this.descCContaIVAComisi = descCContaIVAComisi;
	}
}
