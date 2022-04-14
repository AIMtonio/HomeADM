package soporte.bean;

import general.bean.BaseBean;

public class PlazasBean extends BaseBean  {
	
    private String plazaID;
    private String empresaID;
    private String nombre;
    private	String plazaCLABE;
    private	String usuario;
    private	String sucursal;
    private	String fechaActual;
    private	String direccionIP;
    private	String programaID;
    private	String numTransaccion;
	
	public String getPlazaID() {
		return plazaID;
	}
	public void setPlazaID(String plazaID) {
		this.plazaID = plazaID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getPlazaCLABE() {
		return plazaCLABE;
	}
	public void setPlazaCLABE(String plazaCLABE) {
		this.plazaCLABE = plazaCLABE;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}

}
