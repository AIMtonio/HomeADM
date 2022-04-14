package bancaMovil.bean;

import general.bean.BaseBean;

public class TipoCuentaBean extends BaseBean {

	private String tipoCuentaID;
	private String descripcion;

	public String getTipoCuentaID() {
		return tipoCuentaID;
	}

	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

}
