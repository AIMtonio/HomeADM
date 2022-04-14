package tesoreria.bean;

public class RequisicionTipoGastoListaBean {
	private String tipoGastoID;
	private String descripcionTG;
	private String noFactura;
	private String proveedor;
	
	public String getTipoGastoID() {
		return tipoGastoID;
	}
	public void setTipoGastoID(String tipoGastoID) {
		this.tipoGastoID = tipoGastoID;
	}
	public String getDescripcionTG() {
		return descripcionTG;
	}
	public void setDescripcionTG(String descripcionTG) {
		this.descripcionTG = descripcionTG;
	}
	public String getNoFactura() {
		return noFactura;
	}
	public void setNoFactura(String noFactura) {
		this.noFactura = noFactura;
	}
	public String getProveedor() {
		return proveedor;
	}
	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}
	
}
