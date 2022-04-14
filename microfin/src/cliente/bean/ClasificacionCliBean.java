package cliente.bean;

import java.util.List;

import general.bean.BaseBean;

public class ClasificacionCliBean extends BaseBean{
	
	/*ATRIBUTOS DE LA TABLA */
	private String clasificaCliID;
	private String clasificacion;
	private String rangoInferior;
	private String rangoSuperior;

	
	/*PARAMETROS DE AUDITORIA */
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	private List lClasificaCliID;
	private List lClasificacion;
	private List lRangoInferior;
	private List lRangoSuperior;
	
	
	/*============= GET's && SET's ===============*/	

	public String getClasificaCliID() {
		return clasificaCliID;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public String getRangoInferior() {
		return rangoInferior;
	}
	public String getRangoSuperior() {
		return rangoSuperior;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public List getlClasificaCliID() {
		return lClasificaCliID;
	}
	public List getlClasificacion() {
		return lClasificacion;
	}
	public List getlRangoInferior() {
		return lRangoInferior;
	}
	public List getlRangoSuperior() {
		return lRangoSuperior;
	}
	public void setClasificaCliID(String clasificaCliID) {
		this.clasificaCliID = clasificaCliID;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public void setRangoInferior(String rangoInferior) {
		this.rangoInferior = rangoInferior;
	}
	public void setRangoSuperior(String rangoSuperior) {
		this.rangoSuperior = rangoSuperior;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public void setlClasificaCliID(List lClasificaCliID) {
		this.lClasificaCliID = lClasificaCliID;
	}
	public void setlClasificacion(List lClasificacion) {
		this.lClasificacion = lClasificacion;
	}
	public void setlRangoInferior(List lRangoInferior) {
		this.lRangoInferior = lRangoInferior;
	}
	public void setlRangoSuperior(List lRangoSuperior) {
		this.lRangoSuperior = lRangoSuperior;
	}

}
