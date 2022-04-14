package credito.bean;

import general.bean.BaseBean;

public class IntegraGruposBean extends BaseBean {

	private String grupoID;
	private String solicitudCreditoID;
	private String clienteID;
	private String prospectoID;
	private String estatus;
	private String prorrateaPago;
	private String fechaRegistro;
	private String ciclo;	
	private String cargo;
	
	private String cicloPromedioGrupal;		//Utilizado en el Alta de los Integrantes del Grupo
	private String productoCreditoID;
	
	//Atributos o Campos Auxiliares
	private String cuentaAhoID;			//Utilizado en la Cobranza Automatica
	private String creditoID;
	private String nombreCompleto;
	private String saldoExigible;
	private String adeudoTotal;
	//Parametros de Auditoria
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
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
	public String getProrrateaPago() {
		return prorrateaPago;
	}
	public void setProrrateaPago(String prorrateaPago) {
		this.prorrateaPago = prorrateaPago;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getCiclo() {
		return ciclo;
	}
	public void setCiclo(String ciclo) {
		this.ciclo = ciclo;
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
	public String getCargo() {
		return cargo;
	}
	public void setCargo(String cargo) {
		this.cargo = cargo;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getCicloPromedioGrupal() {
		return cicloPromedioGrupal;
	}
	public void setCicloPromedioGrupal(String cicloPromedioGrupal) {
		this.cicloPromedioGrupal = cicloPromedioGrupal;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getSaldoExigible() {
		return saldoExigible;
	}
	public void setSaldoExigible(String saldoExigible) {
		this.saldoExigible = saldoExigible;
	}
	public String getAdeudoTotal() {
		return adeudoTotal;
	}
	public void setAdeudoTotal(String adeudoTotal) {
		this.adeudoTotal = adeudoTotal;
	}

}
