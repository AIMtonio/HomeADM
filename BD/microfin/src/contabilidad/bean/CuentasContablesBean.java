package contabilidad.bean;

import general.bean.BaseBean;

public class CuentasContablesBean extends BaseBean{
	private String empresaID; 
	private String cuentaCompleta; 
	private String cuentaMayor; 
	private String descripcion; 
	private String descriCorta; 
	private String naturaleza; 
	private String grupo; 
	private String tipoCuenta;
	private String monedaID; 
	private String restringida; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP;
	private String programaID;
	private String sucursal; 
	private String numTransaccion;
	
	// variables auxiliares para el reporte
	private String nombreInstitucion;
	private String fechaEmision;
	private String conceptoCta;
	private String descripcionMoneda;

	// Atributos para la Contabilidad Electronica
	private String codigoAgrupador;  
	private String nivel;
	private String fechaCreacionCta;
	private String numCtas;
	private String rfc;
	private String debe;
	private String haber;
	private String periodo;
	private String clienteID;
	private String nombreCliente;
	private String UUID;
	private String RFCEmisor;
	private String RFCReceptor;
	private String totalTimbrado;
    private String producto;
    private String productoCreditoID;
    private String estatus;

	
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getCuentaCompleta() {
		return cuentaCompleta;
	}
	public void setCuentaCompleta(String cuentaCompleta) {
		this.cuentaCompleta = cuentaCompleta;
	}
	public String getCuentaMayor() {
		return cuentaMayor;
	}
	public void setCuentaMayor(String cuentaMayor) {
		this.cuentaMayor = cuentaMayor;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescriCorta() {
		return descriCorta;
	}
	public void setDescriCorta(String descriCorta) {
		this.descriCorta = descriCorta;
	}
	public String getNaturaleza() {
		return naturaleza;
	}
	public void setNaturaleza(String naturaleza) {
		this.naturaleza = naturaleza;
	}
	public String getGrupo() {
		return grupo;
	}
	public void setGrupo(String grupo) {
		this.grupo = grupo;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getRestringida() {
		return restringida;
	}
	public void setRestringida(String restringida) {
		this.restringida = restringida;
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
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getConceptoCta() {
		return conceptoCta;
	}
	public void setConceptoCta(String conceptoCta) {
		this.conceptoCta = conceptoCta;
	}
	public String getDescripcionMoneda() {
		return descripcionMoneda;
	}
	public void setDescripcionMoneda(String descripcionMoneda) {
		this.descripcionMoneda = descripcionMoneda;
	}

	public String getNivel() {
		return nivel;
	}
	public void setNivel(String nivel) {
		this.nivel = nivel;
	}
	public String getFechaCreacionCta() {
		return fechaCreacionCta;
	}
	public void setFechaCreacionCta(String fechaCreacionCta) {
		this.fechaCreacionCta = fechaCreacionCta;
	}
	public String getNumCtas() {
		return numCtas;
	}
	public void setNumCtas(String numCtas) {
		this.numCtas = numCtas;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public String getDebe() {
		return debe;
	}
	public void setDebe(String debe) {
		this.debe = debe;
	}
	public String getHaber() {
		return haber;
	}
	public void setHaber(String haber) {
		this.haber = haber;
	}
	public String getCodigoAgrupador() {
		return codigoAgrupador;
	}
	public void setCodigoAgrupador(String codigoAgrupador) {
		this.codigoAgrupador = codigoAgrupador;
	}
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
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
	public String getUUID() {
		return UUID;
	}
	public void setUUID(String uUID) {
		UUID = uUID;
	}
	public String getRFCEmisor() {
		return RFCEmisor;
	}
	public void setRFCEmisor(String rFCEmisor) {
		RFCEmisor = rFCEmisor;
	}
	public String getRFCReceptor() {
		return RFCReceptor;
	}
	public void setRFCReceptor(String rFCReceptor) {
		RFCReceptor = rFCReceptor;
	}
	public String getTotalTimbrado() {
		return totalTimbrado;
	}
	public void setTotalTimbrado(String totalTimbrado) {
		this.totalTimbrado = totalTimbrado;
	}
	public String getProducto() {
		return producto;
	}
	public void setProducto(String producto) {
		this.producto = producto;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	
	
	
}
