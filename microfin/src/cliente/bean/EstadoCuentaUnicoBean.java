package cliente.bean;

import general.bean.BaseBean;

public class EstadoCuentaUnicoBean extends BaseBean{

	private String clienteID;
	private String Periodo;
	private String sucursalOrigen;
	private String rutapdf;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getPeriodo() {
		return Periodo;
	}
	public void setPeriodo(String periodo) {
		Periodo = periodo;
	}
	public String getSucursalOrigen() {
		return sucursalOrigen;
	}
	public void setSucursalOrigen(String sucursalOrigen) {
		this.sucursalOrigen = sucursalOrigen;
	}
	public String getRutapdf() {
		return rutapdf;
	}
	public void setRutapdf(String rutapdf) {
		this.rutapdf = rutapdf;
	}	
	
	
}
