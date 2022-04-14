package credito.bean;

import general.bean.BaseBean;

public class CreQuitasBean extends BaseBean {	
	//Atributos o Variables
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
	private String grupoID;
	private String nombreGrupo;
	private String clienteID;
	private String productoID;
	private String montoCredito;
	private String totalCondonado;
	
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
	private String claveUsuario;
	private String nombreInstitucion;
	private String nomCliente;
	private String nomCredito;
	private String hora;
	private String fecha;
	private String institucionNominaID;
	private String convenioNominaID;
	public static String conceptoCondonaCartera ="57"; //tabla CONCEPTOSCONTA
	public static String desConceptoCondonaCartera ="CONDONACION DE CARTERA"; //tabla CONCEPTOSCONTA
	private String nombreInstit;
	private String desConvenio;
	private String esproducNomina;
	private String manejaConvenio;
	private String montoNotasCargo;
	private String porceNotasCargos;
	//setters y getters para Reporte
	
	public String getNomCliente() {
		return nomCliente;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
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
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getProductoID() {
		return productoID;
	}
	public void setProductoID(String productoID) {
		this.productoID = productoID;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public String getTotalCondonado() {
		return totalCondonado;
	}
	public void setTotalCondonado(String totalCondonado) {
		this.totalCondonado = totalCondonado;
	}
	public String getInstitucionNominaID() {
		return institucionNominaID;
	}
	public void setInstitucionNominaID(String institucionNominaID) {
		this.institucionNominaID = institucionNominaID;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getNombreInstit() {
		return nombreInstit;
	}
	public void setNombreInstit(String nombreInstit) {
		this.nombreInstit = nombreInstit;
	}
	public String getDesConvenio() {
		return desConvenio;
	}
	public void setDesConvenio(String desConvenio) {
		this.desConvenio = desConvenio;
	}
	public String getEsproducNomina() {
		return esproducNomina;
	}
	public void setEsproducNomina(String esproducNomina) {
		this.esproducNomina = esproducNomina;
	}
	public String getManejaConvenio() {
		return manejaConvenio;
	}
	public void setManejaConvenio(String manejaConvenio) {
		this.manejaConvenio = manejaConvenio;
	}
	public String getMontoNotasCargo() {
		return montoNotasCargo;
	}
	public void setMontoNotasCargo(String montoNotasCargo) {
		this.montoNotasCargo = montoNotasCargo;
	}
	public String getPorceNotasCargos() {
		return porceNotasCargos;
	}
	public void setPorceNotasCargos(String porceNotasCargos) {
		this.porceNotasCargos = porceNotasCargos;
	}
	
	
	
}
