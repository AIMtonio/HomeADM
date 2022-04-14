package fondeador.bean;

import general.bean.BaseBean;

public class AjusteMovimientosBean extends BaseBean {
	// DECLARACION DE CONSTANTES 
	public String conceptoCondonaCrePas ="25"; //tabla CONCEPTOSCONTA
	public String desConceptoConCarteraPas ="CONDONACION CARTERA PASIVA"; //tabla CONCEPTOSCONTA
	public String automatico = "A"; // indica que se trata de una poliza automatica
	
	
	//Atributos o Variables
	private String institutFondID;
	private String lineaFondeoID;
	private String creditoFondeoID;
	private String creditoID;
	private String consecutivo;
	private String usuarioID;
	private String puestoID;
	private String fechaRegistro;
	private String montoComisiones;
	private String porceComisiones;
	private String montoMoratorios;
	private String porceMoratorios;
	private String montoInteres;
	private String porceInteres;
	private String montoCapital;
	private String porceCapital;
	
	private String saldoCapital;
	private String saldoInteres;
	private String saldoMoratorios;
	private String saldoAccesorios;
	
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	//beans para Reporte
	private String fechaInicio;
	private String fechaFin;
	private String parFechaEmision;
	private String producCreditoID;
	private String nombreSucursal;
	private String nombreProducto;
	private String nombreUsuario;
	private String nombreInstitucion;
	private String nomCliente;
	private String nomCredito;
	
	
	//setters y getters para Reporte
	public String getNomCliente() {
		return nomCliente;
	}
	public void setNomCliente(String nomCliente) {
		this.nomCliente = nomCliente;
	}
	public String getNomCredito() {
		return nomCredito;
	}
	public void setNomCredito(String nomCredito) {
		this.nomCredito = nomCredito;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getParFechaEmision() {
		return parFechaEmision;
	}
	public void setParFechaEmision(String parFechaEmision) {
		this.parFechaEmision = parFechaEmision;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombreProducto() {
		return nombreProducto;
	}
	public void setNombreProducto(String nombreProducto) {
		this.nombreProducto = nombreProducto;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	
	
	// Auxiliares del Bean
	private String numQuitasCredito; // indica el numero de quitas por credito
	private String polizaID;
	
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getPuestoID() {
		return puestoID;
	}
	public void setPuestoID(String puestoID) {
		this.puestoID = puestoID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getMontoComisiones() {
		return montoComisiones;
	}
	public void setMontoComisiones(String montoComisiones) {
		this.montoComisiones = montoComisiones;
	}
	public String getPorceComisiones() {
		return porceComisiones;
	}
	public void setPorceComisiones(String porceComisiones) {
		this.porceComisiones = porceComisiones;
	}
	public String getMontoMoratorios() {
		return montoMoratorios;
	}
	public void setMontoMoratorios(String montoMoratorios) {
		this.montoMoratorios = montoMoratorios;
	}
	public String getPorceMoratorios() {
		return porceMoratorios;
	}
	public void setPorceMoratorios(String porceMoratorios) {
		this.porceMoratorios = porceMoratorios;
	}
	public String getMontoInteres() {
		return montoInteres;
	}
	public void setMontoInteres(String montoInteres) {
		this.montoInteres = montoInteres;
	}
	public String getPorceInteres() {
		return porceInteres;
	}
	public void setPorceInteres(String porceInteres) {
		this.porceInteres = porceInteres;
	}
	public String getMontoCapital() {
		return montoCapital;
	}
	public void setMontoCapital(String montoCapital) {
		this.montoCapital = montoCapital;
	}
	public String getPorceCapital() {
		return porceCapital;
	}
	public void setPorceCapital(String porceCapital) {
		this.porceCapital = porceCapital;
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
	public String getSaldoCapital() {
		return saldoCapital;
	}
	public void setSaldoCapital(String saldoCapital) {
		this.saldoCapital = saldoCapital;
	}
	public String getSaldoInteres() {
		return saldoInteres;
	}
	public void setSaldoInteres(String saldoInteres) {
		this.saldoInteres = saldoInteres;
	}
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public String getSaldoAccesorios() {
		return saldoAccesorios;
	}
	public void setSaldoAccesorios(String saldoAccesorios) {
		this.saldoAccesorios = saldoAccesorios;
	}
	public String getNumQuitasCredito() {
		return numQuitasCredito;
	}
	public void setNumQuitasCredito(String numQuitasCredito) {
		this.numQuitasCredito = numQuitasCredito;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getInstitutFondID() {
		return institutFondID;
	}
	public String getLineaFondeoID() {
		return lineaFondeoID;
	}
	public String getCreditoFondeoID() {
		return creditoFondeoID;
	}
	public void setInstitutFondID(String institutFondID) {
		this.institutFondID = institutFondID;
	}
	public void setLineaFondeoID(String lineaFondeoID) {
		this.lineaFondeoID = lineaFondeoID;
	}
	public void setCreditoFondeoID(String creditoFondeoID) {
		this.creditoFondeoID = creditoFondeoID;
	}

}
