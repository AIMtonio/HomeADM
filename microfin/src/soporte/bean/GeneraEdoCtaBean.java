package soporte.bean;

import general.bean.BaseBean;

public class GeneraEdoCtaBean extends BaseBean{
	public  String TimbraEdoCtaSI = "S";
	private String fechaProceso;
	private String rutaEjecucion;
	private String sucursalID;
	private String clienteID;
	private String cadenaCFDI;
	private String sucursalInicio;
	private String sucursalFin;
	private String rutaCBB;
	private String rutaXML;
	private String version;
	private String noCertificadoSAT;
	private String UUID;
	private String FechaTimbrado;
	private String selloCFD;
	private String selloSAT;	
	private String cadenaOriginal;
	private String fechaCertificacion;
	private String noCertEmisor;
	private String lugarExpedicion;
	private String rfcEmisor;
	private String usuarioWS;
	private String passwordWS;
	private String urlWSDLFactElec;
	private String urlWSSmarterWeb;
	private String rutaEdoCtaPDF;
	private String timbraEdoCta;
	private String rutaReporte;
	private String serie;
    private String subTotal;
    private String descuento;
    private String total;
    private String clienteInicio;
    private String clienteFin;
    private String origenDatos;
	// Auxiliares
    private String numRegistros; 
    private String totalTimbrados;
    private int		estatus;
    private String anioGeneracion;
    private String mesInicioGen;
    private String mesFinGen;
    private String tipoGeneracion;
    
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	// Auxiliares Tipo Timbrado Egreso
	private String cadenaCFDIRet;
	private int	estatusRet;
	private String tipoTimbrado;
	private String rutaCBBRet;
	private String rutaXMLRet;
	private String proveedorTimbrado;
	private String identificadorBus;
	
	//Prefijo de la Empresa
	private String prefijoEmpresa;
	private String rutasSHs;			// Utiliza el valor de RutaExpPDF de la tabla EDOCTAPARAMS para la ubicación de los 2 SH necesarios para el EdoCta.
	private String rutaPDI;
	
	public String getSucursalInicio() {
		return sucursalInicio;
	}

	public void setSucursalInicio(String sucursalInicio) {
		this.sucursalInicio = sucursalInicio;
	}

	public String getSucursalFin() {
		return sucursalFin;
	}

	public void setSucursalFin(String sucursalFin) {
		this.sucursalFin = sucursalFin;
	}

	public String getFechaProceso() {
		return fechaProceso;
	}
	
	public String getRutaEjecucion() {
		return rutaEjecucion;
	}

	public void setRutaEjecucion(String rutaEjecucion) {
		this.rutaEjecucion = rutaEjecucion;
	}

	public void setFechaProceso(String fechaProceso) {
		this.fechaProceso = fechaProceso;
	}

	public String getSucursalID() {
		return sucursalID;
	}

	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getCadenaCFDI() {
		return cadenaCFDI;
	}

	public void setCadenaCFDI(String cadenaCFDI) {
		this.cadenaCFDI = cadenaCFDI;
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

	public String getRutaCBB() {
		return rutaCBB;
	}

	public void setRutaCBB(String rutaCBB) {
		this.rutaCBB = rutaCBB;
	}

	public String getRutaXML() {
		return rutaXML;
	}
	public void setRutaXML(String rutaXML) {
		this.rutaXML = rutaXML;
	}
	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getNoCertificadoSAT() {
		return noCertificadoSAT;
	}

	public void setNoCertificadoSAT(String noCertificadoSAT) {
		this.noCertificadoSAT = noCertificadoSAT;
	}

	public String getUUID() {
		return UUID;
	}

	public void setUUID(String uUID) {
		UUID = uUID;
	}

	public String getFechaTimbrado() {
		return FechaTimbrado;
	}

	public void setFechaTimbrado(String fechaTimbrado) {
		FechaTimbrado = fechaTimbrado;
	}

	public String getSelloCFD() {
		return selloCFD;
	}

	public void setSelloCFD(String selloCFD) {
		this.selloCFD = selloCFD;
	}

	public String getSelloSAT() {
		return selloSAT;
	}

	public void setSelloSAT(String selloSAT) {
		this.selloSAT = selloSAT;
	}

	public String getCadenaOriginal() {
		return cadenaOriginal;
	}

	public void setCadenaOriginal(String cadenaOriginal) {
		this.cadenaOriginal = cadenaOriginal;
	}

	public String getFechaCertificacion() {
		return fechaCertificacion;
	}

	public void setFechaCertificacion(String fechaCertificacion) {
		this.fechaCertificacion = fechaCertificacion;
	}

	public String getNoCertEmisor() {
		return noCertEmisor;
	}

	public void setNoCertEmisor(String noCertEmisor) {
		this.noCertEmisor = noCertEmisor;
	}

	public String getLugarExpedicion() {
		return lugarExpedicion;
	}

	public void setLugarExpedicion(String lugarExpedicion) {
		this.lugarExpedicion = lugarExpedicion;
	}

	public String getRfcEmisor() {
		return rfcEmisor;
	}

	public void setRfcEmisor(String rfcEmisor) {
		this.rfcEmisor = rfcEmisor;
	}

	public String getUsuarioWS() {
		return usuarioWS;
	}

	public void setUsuarioWS(String usuarioWS) {
		this.usuarioWS = usuarioWS;
	}

	public String getPasswordWS() {
		return passwordWS;
	}

	public void setPasswordWS(String passwordWS) {
		this.passwordWS = passwordWS;
	}

	public String getRutaEdoCtaPDF() {
		return rutaEdoCtaPDF;
	}

	public void setRutaEdoCtaPDF(String rutaEdoCtaPDF) {
		this.rutaEdoCtaPDF = rutaEdoCtaPDF;
	}

	public String getTimbraEdoCta() {
		return timbraEdoCta;
	}

	public void setTimbraEdoCta(String timbraEdoCta) {
		this.timbraEdoCta = timbraEdoCta;
	}

	public String getRutaReporte() {
		return rutaReporte;
	}

	public void setRutaReporte(String rutaReporte) {
		this.rutaReporte = rutaReporte;
	}

	public String getSerie() {
		return serie;
	}

	public void setSerie(String serie) {
		this.serie = serie;
	}

	public String getSubTotal() {
		return subTotal;
	}

	public void setSubTotal(String subTotal) {
		this.subTotal = subTotal;
	}

	public String getDescuento() {
		return descuento;
	}

	public void setDescuento(String descuento) {
		this.descuento = descuento;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}

	public String getClienteInicio() {
		return clienteInicio;
	}

	public void setClienteInicio(String clienteInicio) {
		this.clienteInicio = clienteInicio;
	}

	public String getClienteFin() {
		return clienteFin;
	}

	public void setClienteFin(String clienteFin) {
		this.clienteFin = clienteFin;
	}

	public String getNumRegistros() {
		return numRegistros;
	}

	public void setNumRegistros(String numRegistros) {
		this.numRegistros = numRegistros;
	}

	public String getUrlWSDLFactElec() {
		return urlWSDLFactElec;
	}

	public void setUrlWSDLFactElec(String urlWSDLFactElec) {
		this.urlWSDLFactElec = urlWSDLFactElec;
	}

	public String getUrlWSSmarterWeb() {
		return urlWSSmarterWeb;
	}

	public void setUrlWSSmarterWeb(String urlWSSmarterWeb) {
		this.urlWSSmarterWeb = urlWSSmarterWeb;
	}

	public String getTimbraEdoCtaSI() {
		return TimbraEdoCtaSI;
	}

	public void setTimbraEdoCtaSI(String timbraEdoCtaSI) {
		TimbraEdoCtaSI = timbraEdoCtaSI;
	}

	public String getTotalTimbrados() {
		return totalTimbrados;
	}

	public void setTotalTimbrados(String totalTimbrados) {
		this.totalTimbrados = totalTimbrados;
	}

	public int getEstatus() {
		return estatus;
	}

	public void setEstatus(int estatus) {
		this.estatus = estatus;
	}

	public String getAnioGeneracion() {
		return anioGeneracion;
	}

	public void setAnioGeneracion(String anioGeneracion) {
		this.anioGeneracion = anioGeneracion;
	}

	public String getMesInicioGen() {
		return mesInicioGen;
	}

	public void setMesInicioGen(String mesInicioGen) {
		this.mesInicioGen = mesInicioGen;
	}

	public String getMesFinGen() {
		return mesFinGen;
	}

	public void setMesFinGen(String mesFinGen) {
		this.mesFinGen = mesFinGen;
	}

	public String getTipoGeneracion() {
		return tipoGeneracion;
	}

	public void setTipoGeneracion(String tipoGeneracion) {
		this.tipoGeneracion = tipoGeneracion;
	}

	public String getCadenaCFDIRet() {
		return cadenaCFDIRet;
	}

	public void setCadenaCFDIRet(String cadenaCFDIRet) {
		this.cadenaCFDIRet = cadenaCFDIRet;
	}

	public int getEstatusRet() {
		return estatusRet;
	}

	public void setEstatusRet(int estatusRet) {
		this.estatusRet = estatusRet;
	}

	public String getTipoTimbrado() {
		return tipoTimbrado;
	}

	public void setTipoTimbrado(String tipoTimbrado) {
		this.tipoTimbrado = tipoTimbrado;
	}

	public String getRutaCBBRet() {
		return rutaCBBRet;
	}

	public void setRutaCBBRet(String rutaCBBRet) {
		this.rutaCBBRet = rutaCBBRet;
	}

	public String getRutaXMLRet() {
		return rutaXMLRet;
	}

	public void setRutaXMLRet(String rutaXMLRet) {
		this.rutaXMLRet = rutaXMLRet;
	}

	public String getProveedorTimbrado() {
		return proveedorTimbrado;
	}

	public void setProveedorTimbrado(String proveedorTimbrado) {
		this.proveedorTimbrado = proveedorTimbrado;
	}

	public String getIdentificadorBus() {
		return identificadorBus;
	}
	public void setIdentificadorBus(String identificadorBus) {
		this.identificadorBus = identificadorBus;
	}

	public String getOrigenDatos() {
		return origenDatos;
	}

	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
	}

	public String getPrefijoEmpresa() {
		return prefijoEmpresa;
	}

	public void setPrefijoEmpresa(String prefijoEmpresa) {
		this.prefijoEmpresa = prefijoEmpresa;
	}

	public String getRutasSHs() {
		return rutasSHs;
	}

	public void setRutasSHs(String rutasSHs) {
		this.rutasSHs = rutasSHs;
	}

	public String getRutaPDI() {
		return rutaPDI;
	}

	public void setRutaPDI(String rutaPDI) {
		this.rutaPDI = rutaPDI;
	}
}