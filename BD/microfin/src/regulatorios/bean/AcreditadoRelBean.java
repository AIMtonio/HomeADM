package regulatorios.bean;

import general.bean.BaseBean;
import java.util.List;

public class AcreditadoRelBean extends BaseBean {
	private String consecutivo;
	private String clienteID;
	private String empleadoID;
	private String nombre;
	private String puesto;
	
	private String claveRelacionID;	
	private List lisClienteID;
	private List lisEmpleadoID;
	private List lisClaveRelacionID;
	
	public String getConsecutivo() {
		return consecutivo;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getEmpleadoID() {
		return empleadoID;
	}
	public String getNombre() {
		return nombre;
	}
	public String getPuesto() {
		return puesto;
	}
	public String getClaveRelacionID() {
		return claveRelacionID;
	}
	public List getLisClienteID() {
		return lisClienteID;
	}
	public List getLisEmpleadoID() {
		return lisEmpleadoID;
	}
	public List getLisClaveRelacionID() {
		return lisClaveRelacionID;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setEmpleadoID(String empleadoID) {
		this.empleadoID = empleadoID;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public void setPuesto(String puesto) {
		this.puesto = puesto;
	}
	public void setClaveRelacionID(String claveRelacionID) {
		this.claveRelacionID = claveRelacionID;
	}
	public void setLisClienteID(List lisClienteID) {
		this.lisClienteID = lisClienteID;
	}
	public void setLisEmpleadoID(List lisEmpleadoID) {
		this.lisEmpleadoID = lisEmpleadoID;
	}
	public void setLisClaveRelacionID(List lisClaveRelacionID) {
		this.lisClaveRelacionID = lisClaveRelacionID;
	}
}
