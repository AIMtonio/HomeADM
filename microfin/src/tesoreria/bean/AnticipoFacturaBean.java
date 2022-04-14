package tesoreria.bean;

import java.util.List;

import general.bean.BaseBean;

public class AnticipoFacturaBean extends BaseBean {
	private String anticipoFactID;
	private String proveedorID;
	private String noFactura;
	private String claveDispMov;
	private String fechaAnticipo;
	private String estatusAnticipo;
	private String formaPago;
	private String montoAnticipo;
	private String totalFactura;
	private String saldoFactura;
	private String fechaCancela;
	private String saldoAnticipo;
	
	private List listaAnticipo;


	public List getListaAnticipo() {
		return listaAnticipo;
	}
	public void setListaAnticipo(List listaAnticipo) {
		this.listaAnticipo = listaAnticipo;
	}
	public String getSaldoAnticipo() {
		return saldoAnticipo;
	}
	public void setSaldoAnticipo(String saldoAnticipo) {
		this.saldoAnticipo = saldoAnticipo;
	}
	public String getAnticipoFactID() {
		return anticipoFactID;
	}
	public void setAnticipoFactID(String anticipoFactID) {
		this.anticipoFactID = anticipoFactID;
	}
	public String getProveedorID() {
		return proveedorID;
	}
	public void setProveedorID(String proveedorID) {
		this.proveedorID = proveedorID;
	}
	public String getNoFactura() {
		return noFactura;
	}
	public void setNoFactura(String noFactura) {
		this.noFactura = noFactura;
	}
	public String getClaveDispMov() {
		return claveDispMov;
	}
	public void setClaveDispMov(String claveDispMov) {
		this.claveDispMov = claveDispMov;
	}
	public String getFechaAnticipo() {
		return fechaAnticipo;
	}
	public void setFechaAnticipo(String fechaAnticipo) {
		this.fechaAnticipo = fechaAnticipo;
	}
	public String getEstatusAnticipo() {
		return estatusAnticipo;
	}
	public void setEstatusAnticipo(String estatusAnticipo) {
		this.estatusAnticipo = estatusAnticipo;
	}
	public String getFormaPago() {
		return formaPago;
	}
	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}
	public String getMontoAnticipo() {
		return montoAnticipo;
	}
	public void setMontoAnticipo(String montoAnticipo) {
		this.montoAnticipo = montoAnticipo;
	}
	public String getTotalFactura() {
		return totalFactura;
	}
	public void setTotalFactura(String totalFactura) {
		this.totalFactura = totalFactura;
	}
	public String getSaldoFactura() {
		return saldoFactura;
	}
	public void setSaldoFactura(String saldoFactura) {
		this.saldoFactura = saldoFactura;
	}
	public String getFechaCancela() {
		return fechaCancela;
	}
	public void setFechaCancela(String fechaCancela) {
		this.fechaCancela = fechaCancela;
	}
	
}
