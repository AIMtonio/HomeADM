package tarjetas.bean;

import antlr.collections.List;
import general.bean.BaseBean;

public class TiposCuentaValidoTipoTarjetaBean extends BaseBean {
	private String tipoTarjetaDebID;
	private String tipoCuenta;
	private List ltipoCuenta;
	
	
	public String getTipoTarjetaDebID() {
		return tipoTarjetaDebID;
	}
	public void setTipoTarjetaDebID(String tipoTarjetaDebID) {
		this.tipoTarjetaDebID = tipoTarjetaDebID;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
	public List getLtipoCuenta() {
		return ltipoCuenta;
	}
	public void setLtipoCuenta(List ltipoCuenta) {
		this.ltipoCuenta = ltipoCuenta;
	}

}
