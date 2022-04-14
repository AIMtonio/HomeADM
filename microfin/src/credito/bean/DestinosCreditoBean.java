package credito.bean;

public class DestinosCreditoBean {

	private String destinoCreID;
	private String descripcion;
	private String destinCredFRID;
	private String destinCredFOMURID;
	private String clasificacion;
	private String subClasifID;
	private String desClasificacion;
	
	
	private String producCreditoID;
	
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	
	/*---auxiliares para mostrar la descripcion de los catalogos
	 de Destinos Creditos FR y Destinos Creditos FOMUR    */
	
	private String desCredFR;
	private String desCredFOMUR;
	
	public String getDesClasificacion() {
		return desClasificacion;
	}
	public void setDesClasificacion(String desClasificacion) {
		this.desClasificacion = desClasificacion;
	}
	
	public String getDestinoCreID() {
		return destinoCreID;
	}
	public void setDestinoCreID(String destinoCreID) {
		this.destinoCreID = destinoCreID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
	public String getDestinCredFRID() {
		return destinCredFRID;
	}
	public void setDestinCredFRID(String destinCredFRID) {
		this.destinCredFRID = destinCredFRID;
	}
	public String getDestinCredFOMURID() {
		return destinCredFOMURID;
	}
	public void setDestinCredFOMURID(String destinCredFOMURID) {
		this.destinCredFOMURID = destinCredFOMURID;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public String getDesCredFR() {
		return desCredFR;
	}
	public void setDesCredFR(String desCredFR) {
		this.desCredFR = desCredFR;
	}
	public String getDesCredFOMUR() {
		return desCredFOMUR;
	}
	public void setDesCredFOMUR(String desCredFOMUR) {
		this.desCredFOMUR = desCredFOMUR;
	}
	public String getSubClasifID() {
		return subClasifID;
	}
	public void setSubClasifID(String subClasifID) {
		this.subClasifID = subClasifID;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	
}
