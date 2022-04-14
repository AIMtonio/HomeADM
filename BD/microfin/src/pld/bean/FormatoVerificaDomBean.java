package pld.bean;
import general.bean.BaseBean;

public class FormatoVerificaDomBean extends BaseBean{
	private String clienteID;
	private String nombreCliente;
	private String estatusCliente;
	private String sucursalID;
	private String nombreSucursal;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getEstatusCliente() {
		return estatusCliente;
	}
	public void setEstatusCliente(String estatusCliente) {
		this.estatusCliente = estatusCliente;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}

}
