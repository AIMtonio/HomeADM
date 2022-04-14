package psl.bean;

import general.bean.BaseBean;

public class PSLConfigProductoBean extends BaseBean {
	private String productoID;
	private String servicioID;
	private String clasificacionServ;
	private String producto;
	private String digVerificador;
	private String precio;
    private String habilitado;
    private String descProducto;
    private String tipoReferencia;
    private String tipoFront;
    
    private String mtoCteVentanilla;
    private String ivaMtoCteVentanilla;
    private String mtoUsuVentanilla;
    private String ivaMtoUsuVentanilla;
    private String mtoProveedor;
    private String cobComVentanilla;
    
    
	public String getProductoID() {
		return productoID;
	}
	public void setProductoID(String productoID) {
		this.productoID = productoID;
	}
	public String getServicioID() {
		return servicioID;
	}
	public void setServicioID(String servicioID) {
		this.servicioID = servicioID;
	}
	public String getClasificacionServ() {
		return clasificacionServ;
	}
	public void setClasificacionServ(String clasificacionServ) {
		this.clasificacionServ = clasificacionServ;
	}
	public String getProducto() {
		return producto;
	}
	public void setProducto(String producto) {
		this.producto = producto;
	}
	public String getDigVerificador() {
		return digVerificador;
	}
	public void setDigVerificador(String digVerificador) {
		this.digVerificador = digVerificador;
	}
	public String getPrecio() {
		return precio;
	}
	public void setPrecio(String precio) {
		this.precio = precio;
	}
	public String getHabilitado() {
		return habilitado;
	}
	public void setHabilitado(String habilitado) {
		this.habilitado = habilitado;
	}
	public String getDescProducto() {
		return descProducto;
	}
	public void setDescProducto(String descProducto) {
		this.descProducto = descProducto;
	}
	public String getTipoReferencia() {
		return tipoReferencia;
	}
	public void setTipoReferencia(String tipoReferencia) {
		this.tipoReferencia = tipoReferencia;
	}
	public String getTipoFront() {
		return tipoFront;
	}
	public void setTipoFront(String tipoFront) {
		this.tipoFront = tipoFront;
	}
	public String getMtoCteVentanilla() {
		return mtoCteVentanilla;
	}
	public void setMtoCteVentanilla(String mtoCteVentanilla) {
		this.mtoCteVentanilla = mtoCteVentanilla;
	}
	public String getIvaMtoCteVentanilla() {
		return ivaMtoCteVentanilla;
	}
	public void setIvaMtoCteVentanilla(String ivaMtoCteVentanilla) {
		this.ivaMtoCteVentanilla = ivaMtoCteVentanilla;
	}
	public String getMtoUsuVentanilla() {
		return mtoUsuVentanilla;
	}
	public void setMtoUsuVentanilla(String mtoUsuVentanilla) {
		this.mtoUsuVentanilla = mtoUsuVentanilla;
	}
	public String getIvaMtoUsuVentanilla() {
		return ivaMtoUsuVentanilla;
	}
	public void setIvaMtoUsuVentanilla(String ivaMtoUsuVentanilla) {
		this.ivaMtoUsuVentanilla = ivaMtoUsuVentanilla;
	}
	public String getMtoProveedor() {
		return mtoProveedor;
	}
	public void setMtoProveedor(String mtoProveedor) {
		this.mtoProveedor = mtoProveedor;
	}
	public String getCobComVentanilla() {
		return cobComVentanilla;
	}
	public void setCobComVentanilla(String cobComVentanilla) {
		this.cobComVentanilla = cobComVentanilla;
	}
}
