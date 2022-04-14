package fondeador.bean;

import general.bean.BaseBean;

public class TiposLineaFondeaBean extends BaseBean {
	
	private String tipoLinFondeaID;
	private String descripcion;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String institutFondID;

	private long numTransaccion;
	
	public String getTipoLinFondeaID() {
		return tipoLinFondeaID;
	}
	public void setTipoLinFondeaID(String tipoLinFondeaID) {
		this.tipoLinFondeaID = tipoLinFondeaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public long getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(long numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	
	public String getInstitutFondID() {
		return institutFondID;
	}
	public void setInstitutFondID(String institutFondID) {
		this.institutFondID = institutFondID;
	}

}

