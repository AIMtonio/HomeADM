package soporte.bean;

import general.bean.BaseBean;

public class GeneraConstanciaRetencionBean extends BaseBean{
	
	public  String TimbraConstanciaSI = "S";
	public  int ActualizaCFDI = 1;
	public  int ActualizaEstatus = 2;

	private String anioProceso;
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
	private String rutaConstanciaPDF;
	private String timbraConsRet;
	private String rutaReporte;
	private String serie;
    private String subTotal;
    private String descuento;
    private String total;
    private String clienteInicio;
    private String clienteFin;
    private String rutaLogo;
	private String rutaCedula;
	private String rutaETL;
    
	// Auxiliares
    private String numRegistros; 
    private String totalTimbrados;
    private int		estatus;
    
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	private String OrigenDatos;
	private String nombrePDF;
	private String numRegistrosAnio;
	private String numRegistrosINPC;
	private String nombreCompleto;
	
	private String calcCierreIntReal;
	private String generaConsRetPDF;
	
	//Declaracion de Constantes
	public static int LONGITUD_ID = 10;

	private String constanciaRetID;
	private String tipo;
	private String cteRelacionadoID;
	private String cliente;

	//parametros proveedor ws timbrado
	private String tipoProveedorWS;
	private String usuarioWS;
	private String contraseniaWS;
	private String urlWSDL;
	private String tokenAcceso;
	private String rutaArchivosCertificado;
	private String nombreCertificado;
	private String nombreLlavePriv;
	private String rutaArchivosXSLT;
	private String passCertificado;
	private String rfcReceptor;
	private String identificadorBus;
	/* ============ SETTER's Y GETTER's =============== */

	public String getRfcReceptor() {
		return rfcReceptor;
	}
	public void setRfcReceptor(String rfcReceptor) {
		this.rfcReceptor = rfcReceptor;
	}
	public String getTimbraConstanciaSI() {
		return TimbraConstanciaSI;
	}
	public void setTimbraConstanciaSI(String timbraConstanciaSI) {
		TimbraConstanciaSI = timbraConstanciaSI;
	}
	public String getAnioProceso() {
		return anioProceso;
	}
	public void setAnioProceso(String anioProceso) {
		this.anioProceso = anioProceso;
	}
	public String getRutaEjecucion() {
		return rutaEjecucion;
	}
	public void setRutaEjecucion(String rutaEjecucion) {
		this.rutaEjecucion = rutaEjecucion;
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
	public String getRutaConstanciaPDF() {
		return rutaConstanciaPDF;
	}
	public void setRutaConstanciaPDF(String rutaConstanciaPDF) {
		this.rutaConstanciaPDF = rutaConstanciaPDF;
	}
	public String getTimbraConsRet() {
		return timbraConsRet;
	}
	public void setTimbraConsRet(String timbraConsRet) {
		this.timbraConsRet = timbraConsRet;
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
	public String getOrigenDatos() {
		return OrigenDatos;
	}

	public void setOrigenDatos(String origenDatos) {
		OrigenDatos = origenDatos;
	}
	public String getNombrePDF() {
		return nombrePDF;
	}
	public void setNombrePDF(String nombrePDF) {
		this.nombrePDF = nombrePDF;
	}
	public String getRutaLogo() {
		return rutaLogo;
	}
	public void setRutaLogo(String rutaLogo) {
		this.rutaLogo = rutaLogo;
	}
	public String getRutaCedula() {
		return rutaCedula;
	}
	public void setRutaCedula(String rutaCedula) {
		this.rutaCedula = rutaCedula;
	}
	public String getNumRegistrosAnio() {
		return numRegistrosAnio;
	}
	public void setNumRegistrosAnio(String numRegistrosAnio) {
		this.numRegistrosAnio = numRegistrosAnio;
	}
	public String getNumRegistrosINPC() {
		return numRegistrosINPC;
	}
	public void setNumRegistrosINPC(String numRegistrosINPC) {
		this.numRegistrosINPC = numRegistrosINPC;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getConstanciaRetID() {
		return constanciaRetID;
	}
	public void setConstanciaRetID(String constanciaRetID) {
		this.constanciaRetID = constanciaRetID;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getCteRelacionadoID() {
		return cteRelacionadoID;
	}
	public void setCteRelacionadoID(String cteRelacionadoID) {
		this.cteRelacionadoID = cteRelacionadoID;
	}
	public String getCliente() {
		return cliente;
	}
	public void setCliente(String cliente) {
		this.cliente = cliente;
	}
	public String getRutaETL() {
		return rutaETL;
	}
	public void setRutaETL(String rutaETL) {
		this.rutaETL = rutaETL;
	}
	public String getCalcCierreIntReal() {
		return calcCierreIntReal;
	}
	public void setCalcCierreIntReal(String calcCierreIntReal) {
		this.calcCierreIntReal = calcCierreIntReal;
	}
	public String getGeneraConsRetPDF() {
		return generaConsRetPDF;
	}
	public void setGeneraConsRetPDF(String generaConsRetPDF) {
		this.generaConsRetPDF = generaConsRetPDF;
	}
	public String getTipoProveedorWS() {
		return tipoProveedorWS;
	}
	public void setTipoProveedorWS(String tipoProveedorWS) {
		this.tipoProveedorWS = tipoProveedorWS;
	}
	public String getContraseniaWS() {
		return contraseniaWS;
	}
	public void setContraseniaWS(String contraseniaWS) {
		this.contraseniaWS = contraseniaWS;
	}
	public String getUrlWSDL() {
		return urlWSDL;
	}
	public void setUrlWSDL(String urlWSDL) {
		this.urlWSDL = urlWSDL;
	}
	public String getTokenAcceso() {
		return tokenAcceso;
	}
	public void setTokenAcceso(String tokenAcceso) {
		this.tokenAcceso = tokenAcceso;
	}
	public String getRutaArchivosCertificado() {
		return rutaArchivosCertificado;
	}
	public void setRutaArchivosCertificado(String rutaArchivosCertificado) {
		this.rutaArchivosCertificado = rutaArchivosCertificado;
	}
	public String getNombreCertificado() {
		return nombreCertificado;
	}
	public void setNombreCertificado(String nombreCertificado) {
		this.nombreCertificado = nombreCertificado;
	}
	public String getNombreLlavePriv() {
		return nombreLlavePriv;
	}
	public void setNombreLlavePriv(String nombreLlavePriv) {
		this.nombreLlavePriv = nombreLlavePriv;
	}
	public String getRutaArchivosXSLT() {
		return rutaArchivosXSLT;
	}
	public void setRutaArchivosXSLT(String rutaArchivosXSLT) {
		this.rutaArchivosXSLT = rutaArchivosXSLT;
	}
	public String getPassCertificado() {
		return passCertificado;
	}
	public void setPassCertificado(String passCertificado) {
		this.passCertificado = passCertificado;
	}
	public String getIdentificadorBus() {
		return identificadorBus;
	}
	public void setIdentificadorBus(String identificadorBus) {
		this.identificadorBus = identificadorBus;
	}
	
}
