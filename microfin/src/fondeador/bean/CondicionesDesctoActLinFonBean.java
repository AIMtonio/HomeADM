package fondeador.bean;

import java.util.List;

import general.bean.BaseBean;

public class CondicionesDesctoActLinFonBean extends BaseBean { 
	// tabla LINFONCONDACT
	
	private String lineaFondeoIDAct;
	private String actividadBMXID;
	
	private List listaActividadBMXID;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private long numTransaccion;
	
	
	public String getLineaFondeoIDAct() {
		return lineaFondeoIDAct;
	}
	public void setLineaFondeoIDAct(String lineaFondeoIDAct) {
		this.lineaFondeoIDAct = lineaFondeoIDAct;
	}
	public String getActividadBMXID() {
		return actividadBMXID;
	}
	public void setActividadBMXID(String actividadBMXID) {
		this.actividadBMXID = actividadBMXID;
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
	public List getListaActividadBMXID() {
		return listaActividadBMXID;
	}
	public void setListaActividadBMXID(List listaActividadBMXID) {
		this.listaActividadBMXID = listaActividadBMXID;
	}
}
