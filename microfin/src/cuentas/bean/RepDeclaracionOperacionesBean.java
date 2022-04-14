package cuentas.bean;

import general.bean.BaseBean;

public class RepDeclaracionOperacionesBean extends BaseBean {

	private String cuentaAhoID;
	private String fecha;
	private String nombreInstitucion;
	private String usuario;

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getNombreInstitucion() {
		return nombreInstitucion;
	}

	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
}
