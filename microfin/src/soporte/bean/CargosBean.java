package soporte.bean;

import general.bean.BaseBean;

public class CargosBean extends BaseBean  {
	 
	private String cargoID;
    private String descripcionCargo;
    private String empresaID;
    private	String usuario;
    private	String sucursal;
    private	String fechaActual;
    private	String direccionIP;
    private	String programaID;
    private	String numTransaccion;
	
    public String getCargoID() {
 		return cargoID;
 	}
 	public void setCargoID(String cargoID) {
 		this.cargoID = cargoID;
 	}
 	public String getDescripcionCargo() {
 		return descripcionCargo;
 	}
 	public void setDescripcionCargo(String descripcionCargo) {
 		this.descripcionCargo = descripcionCargo;
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
