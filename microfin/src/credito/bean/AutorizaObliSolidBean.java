package credito.bean;

import general.bean.BaseBean;

public class AutorizaObliSolidBean extends BaseBean {
	
	// Declaracion de Constantes
	public static final String ESTATUS_AUTORIZADO = "U";
	public static final String ESTATUS_ALTA = "A";
	public static final int OTRO_PARENTESCO = 45;
	public static final double MES_CONOCIDO = 0.1;
	
	// Declaracion de Variables o Atributos	
	private String solicitudCreditoID;
	private String obligadoID;
	private String clienteID;
	private String prospectoID;
	private String estatus;
	private String fechaRegistro;
	private String tiempoConocido;
	private String parentescoID;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;

	// Bean Auxilar
	private String productoCreditoID;

	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}

	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}

	public String getObligadoID() {
		return obligadoID;
	}

	public void setObligadoID(String avalID) {
		this.obligadoID = avalID;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getProspectoID() {
		return prospectoID;
	}

	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getFechaRegistro() {
		return fechaRegistro;
	}

	public String getTiempoConocido() {
		return tiempoConocido;
	}

	public void setTiempoConocido(String tiempoConocido) {
		this.tiempoConocido = tiempoConocido;
	}

	public String getParentescoID() {
		return parentescoID;
	}

	public void setParentescoID(String parentescoID) {
		this.parentescoID = parentescoID;
	}

	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
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

	public String getSucursal() {
		return sucursal;
	}

	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}

	public String getNumTransaccion() {
		return numTransaccion;
	}

	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}

	public String getProductoCreditoID() {
		return productoCreditoID;
	}

	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	
	
}
