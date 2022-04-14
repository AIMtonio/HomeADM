package soporte.bean;

import general.bean.BaseBean;

public class NotariaBean extends BaseBean{
	
	private String estadoID;
	private String municipioID;
	private String notariaID;
	private String empresaID;
	private String titular;
	private String direccion;
	private String telefono;
	private String correo;
	private String extTelefonoPart;
	private	String usuario;
	private	String sucursal;
	private	String fechaActual;
	private	String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getNotariaID() {
		return notariaID;
	}
	public void setNotariaID(String notariaID) {
		this.notariaID = notariaID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getTitular() {
		return titular;
	}
	public void setTitular(String titular) {
		this.titular = titular;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getCorreo() {
		return correo;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public String getExtTelefonoPart() {
		return extTelefonoPart;
	}
	public void setExtTelefonoPart(String extTelefonoPart) {
		this.extTelefonoPart = extTelefonoPart;
	}
	
	
	
}
