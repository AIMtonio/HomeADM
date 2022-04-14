package fondeador.bean;

import java.util.List;

import general.bean.BaseBean;

public class CondicionesDesctoDestLinFonBean extends BaseBean { 
	// tabla LINFONCONDDEST
	
	private String lineaFondeoIDDest;
	private String destinoCreID;
	
	private List listaDestinoCreID;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private long numTransaccion;
	
	
	public String getLineaFondeoIDDest() {
		return lineaFondeoIDDest;
	}
	public void setLineaFondeoIDDest(String lineaFondeoIDDest) {
		this.lineaFondeoIDDest = lineaFondeoIDDest;
	}
	public String getDestinoCreID() {
		return destinoCreID;
	}
	public void setDestinoCreID(String destinoCreID) {
		this.destinoCreID = destinoCreID;
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
	public List getListaDestinoCreID() {
		return listaDestinoCreID;
	}
	public void setListaDestinoCreID(List listaDestinoCreID) {
		this.listaDestinoCreID = listaDestinoCreID;
	}
}
