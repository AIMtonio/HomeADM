package tesoreria.bean;

import general.bean.BaseBean;

public class TipoPagoProvBean extends BaseBean{
	private String tipoPagoProvID;
	private String descripcion;
	private String cuentaContable;
	
	

	public String getTipoPagoProvID() {
		return tipoPagoProvID;
	}
	public void setTipoPagoProvID(String tipoPagoProvID) {
		this.tipoPagoProvID = tipoPagoProvID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getCuentaContable() {
		return cuentaContable;
	}
	public void setCuentaContable(String cuentaContable) {
		this.cuentaContable = cuentaContable;
	}
}
