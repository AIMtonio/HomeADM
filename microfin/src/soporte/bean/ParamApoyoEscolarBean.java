package soporte.bean;

import general.bean.BaseBean;

public class ParamApoyoEscolarBean extends BaseBean {

	/*Declaracion de atributos */
	private String paramApoyoEscID; 
	private String apoyoEscCicloID;
	private String descripcion;
	private String tipoCalculo;
	private String cantidad;
	private String promedioMinimo;
	private String mesesAhorroCons;

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;	
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	
	/* ============ SETTER's Y GETTER's =============== */
	
	
	public String getParamApoyoEscID() {
		return paramApoyoEscID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getTipoCalculo() {
		return tipoCalculo;
	}
	public String getCantidad() {
		return cantidad;
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
	public void setParamApoyoEscID(String paramApoyoEscID) {
		this.paramApoyoEscID = paramApoyoEscID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setTipoCalculo(String tipoCalculo) {
		this.tipoCalculo = tipoCalculo;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
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
	public String getPromedioMinimo() {
		return promedioMinimo;
	}
	public void setPromedioMinimo(String promedioMinimo) {
		this.promedioMinimo = promedioMinimo;
	}
	public String getApoyoEscCicloID() {
		return apoyoEscCicloID;
	}
	public void setApoyoEscCicloID(String apoyoEscCicloID) {
		this.apoyoEscCicloID = apoyoEscCicloID;
	}
	public String getMesesAhorroCons() {
		return mesesAhorroCons;
	}
	public void setMesesAhorroCons(String mesesAhorroCons) {
		this.mesesAhorroCons = mesesAhorroCons;
	}	
	

}