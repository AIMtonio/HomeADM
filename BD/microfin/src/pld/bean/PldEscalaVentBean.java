package pld.bean;

import general.bean.BaseBean;

public class PldEscalaVentBean  extends BaseBean {
	private String folioEscala;
	private String opcionCajaID;
	private String proceso;
	private String clienteID;
	private String usuarioServicioID;
	private String cuentaAhoID;
	private String monedaID;
	private String monto;
	private String fechaOperacion;
	private String tipoResultEscID;
	public static String ProcesoAlta = "1";
	public static String EnSeguimiento = "S";
	public String getFolioEscala() {
		return folioEscala;
	}
	public void setFolioEscala(String folioEscala) {
		this.folioEscala = folioEscala;
	}
	public String getOpcionCajaID() {
		return opcionCajaID;
	}
	public void setOpcionCajaID(String opcionCajaID) {
		this.opcionCajaID = opcionCajaID;
	}
	public String getProceso() {
		return proceso;
	}
	public void setProceso(String proceso) {
		this.proceso = proceso;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getUsuarioServicioID() {
		return usuarioServicioID;
	}
	public void setUsuarioServicioID(String usuarioServicioID) {
		this.usuarioServicioID = usuarioServicioID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getTipoResultEscID() {
		return tipoResultEscID;
	}
	public void setTipoResultEscID(String tipoResultEscID) {
		this.tipoResultEscID = tipoResultEscID;
	}

}
