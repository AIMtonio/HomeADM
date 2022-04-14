package tesoreria.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class FacturaprovBean extends BaseBean{
	
	private MultipartFile file;
	private String facturaProvID; 
	private String proveedorID;
	private String noFactura;
	private String fechaFactura;
	private String estatus;
	private String estatusReq;
	private String condicionesPago;
	private String fechaProgPago;
	private String fechaVencimiento;
	private String saldoFactura;
	private String totalGravable;	
	private String totalFactura;
	private String subTotal;
	private String totGravado;
	private String totRetenido;
	private String noPartidaID;
	private String impuestoID;
	private String importeImpuesto;
	private String rutaImagenFact;
	private String rutaXMLFact;
	private String motivoCancelacion;
	private String monto;
	private String fechaCancelacion;
	private String proveedorIDFact;
	private String numDisp;
	private String estatusPeriodo;
	private String numAnticipos;
	
	private String centroCostoManual;
	private String pagoAnticipado;
	private String prorrateaImp;
	private String cenCostoManualID;
	private String tipoPagoAnt;
	private String cenCostoAntID;
	private String noEmpleadoID;
	private String folioUUID;
	private String polizaID;
	
	
	private String empresaID; 
	private String descripcion; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP;
	private String programaID;
	private String sucursal; 
	private String numTransaccion;
	
	//Parametros para Reporte
	private String fechaInicio;
	private String fechaFin;	
	private String nombreInstitucion;
	private String nombreProveedor;
	private String parFechaEmision;
	private String horaEmision;
	private String nombreUsuario;
	private String nombreSucursal;
	private String nombreEstatus;
	
	//Parametros para Reporte Excel
	private String nombreProv;
	private String fechaEmision;
	private String fechaVencim;
	private String fechaPrefPago;
	private String sumIVASiNo;
	private String sumIVASiSi;
	private String sumIVANoNo;

	
	//Auxiliares para el reporte
	private String TotalIVASiSi;
	private String TotalIVASiNo;
	private String TotalIVANoNo;
	private String tipoProveedor;
	private String descTipoProveedor;
	private String RFC;
	private String CURP;
	private String usuarioAutoriza;
	private String razonSocial;
	private String tipoDispersion;
	private String importe16;
	private String importe0;
	private String importeExcento;
	private String Columnas;
	
	//validacion de cfdi
	private String rfcEmisor;
	private String rfcReceptor;
	private String montoTotal;
	private int numErrFacWS;
	private String mensajeSalidaWS;
	private String tipoCaptura;
	private String desTipoCaptura;
	private String folioCargaID;
	private String folioFacturaID;
	private String mesSubirFact;
	
	public String getFechaCancelacion() {
		return fechaCancelacion;
	}
	public void setFechaCancelacion(String fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}
	public String getMotivoCancelacion() {
		return motivoCancelacion;
	}
	public void setMotivoCancelacion(String motivoCancelacion) {
		this.motivoCancelacion = motivoCancelacion;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getNombreEstatus() {
		return nombreEstatus;
	}
	public void setNombreEstatus(String nombreEstatus) {
		this.nombreEstatus = nombreEstatus;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public String getParFechaEmision() {
		return parFechaEmision;
	}
	public void setParFechaEmision(String parFechaEmision) {
		this.parFechaEmision = parFechaEmision;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
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
 
	public String getRutaImagenFact() {
		return rutaImagenFact;
	}
	public void setRutaImagenFact(String rutaImagenFact) {
		this.rutaImagenFact = rutaImagenFact;
	}
	public String getRutaXMLFact() {
		return rutaXMLFact;
	}
	public void setRutaXMLFact(String rutaXMLFact) {
		this.rutaXMLFact = rutaXMLFact;
	}
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public String getTotalGravable() {
		return totalGravable;
	}
	public void setTotalGravable(String totalGravable) {
		this.totalGravable = totalGravable;
	}
	public String getFacturaProvID() {
		return facturaProvID;
	}
	public void setFacturaProvID(String facturaProvID) {
		this.facturaProvID = facturaProvID;
	}
	public String getProveedorID() {
		return proveedorID;
	}
	public void setProveedorID(String proveedorID) {
		this.proveedorID = proveedorID;
	}
	public String getNoFactura() {
		return noFactura;
	}
	public void setNoFactura(String noFactura) {
		this.noFactura = noFactura;
	}
	public String getFechaFactura() {
		return fechaFactura;
	}
	public void setFechaFactura(String fechaFactura) {
		this.fechaFactura = fechaFactura;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getEstatusReq() {
		return estatusReq;
	}
	public void setEstatusReq(String estatusReq) {
		this.estatusReq = estatusReq;
	}
	public String getCondicionesPago() {
		return condicionesPago;
	}
	public void setCondicionesPago(String condicionesPago) {
		this.condicionesPago = condicionesPago;
	}
	public String getFechaProgPago() {
		return fechaProgPago;
	}
	public void setFechaProgPago(String fechaProgPago) {
		this.fechaProgPago = fechaProgPago;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getSaldoFactura() {
		return saldoFactura;
	}
	public void setSaldoFactura(String saldoFactura) {
		this.saldoFactura = saldoFactura;
	}
	public String getTotalFactura() {
		return totalFactura;
	}
	public void setTotalFactura(String totalFactura) {
		this.totalFactura = totalFactura;
	}
	public String getSubTotal() {
		return subTotal;
	}
	public void setSubTotal(String subTotal) {
		this.subTotal = subTotal;
	}
	public String getImpuestoID() {
		return impuestoID;
	}
	public void setImpuestoID(String impuestoID) {
		this.impuestoID = impuestoID;
	}
	public String getImporteImpuesto() {
		return importeImpuesto;
	}
	public void setImporteImpuesto(String importeImpuesto) {
		this.importeImpuesto = importeImpuesto;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
	public String getProveedorIDFact() {
		return proveedorIDFact;
	}
	public void setProveedorIDFact(String proveedorIDFact) {
		this.proveedorIDFact = proveedorIDFact;
	}
	public String getNumDisp() {
		return numDisp;
	}
	public void setNumDisp(String numDisp) {
		this.numDisp = numDisp;
	}
	public String getEstatusPeriodo() {
		return estatusPeriodo;
	}
	public String getNumAnticipos() {
		return numAnticipos;
	}
	public void setNumAnticipos(String numAnticipos) {
		this.numAnticipos = numAnticipos;
	}
	public void setEstatusPeriodo(String estatusPeriodo) {
		this.estatusPeriodo = estatusPeriodo;
	}
	public String getCentroCostoManual() {
		return centroCostoManual;
	}
	public void setCentroCostoManual(String centroCostoManual) {
		this.centroCostoManual = centroCostoManual;
	}
	public String getPagoAnticipado() {
		return pagoAnticipado;
	}
	public void setPagoAnticipado(String pagoAnticipado) {
		this.pagoAnticipado = pagoAnticipado;
	}
	public String getProrrateaImp() {
		return prorrateaImp;
	}
	public void setProrrateaImp(String prorrateaImp) {
		this.prorrateaImp = prorrateaImp;
	}
	public String getCenCostoManualID() {
		return cenCostoManualID;
	}
	public void setCenCostoManualID(String cenCostoManualID) {
		this.cenCostoManualID = cenCostoManualID;
	}
	public String getTipoPagoAnt() {
		return tipoPagoAnt;
	}
	public void setTipoPagoAnt(String tipoPagoAnt) {
		this.tipoPagoAnt = tipoPagoAnt;
	}
	public String getCenCostoAntID() {
		return cenCostoAntID;
	}
	public void setCenCostoAntID(String cenCostoAntID) {
		this.cenCostoAntID = cenCostoAntID;
	}
	public String getNoEmpleadoID() {
		return noEmpleadoID;
	}
	public void setNoEmpleadoID(String noEmpleadoID) {
		this.noEmpleadoID = noEmpleadoID;
	}
	public String getTotalIVASiSi() {
		return TotalIVASiSi;
	}
	public void setTotalIVASiSi(String totalIVASiSi) {
		TotalIVASiSi = totalIVASiSi;
	}
	public String getTotalIVASiNo() {
		return TotalIVASiNo;
	}
	public void setTotalIVASiNo(String totalIVASiNo) {
		TotalIVASiNo = totalIVASiNo;
	}
	public String getTotalIVANoNo() {
		return TotalIVANoNo;
	}
	public void setTotalIVANoNo(String totalIVANoNo) {
		TotalIVANoNo = totalIVANoNo;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getFolioUUID() {
		return folioUUID;
	}
	public void setFolioUUID(String folioUUID) {
		this.folioUUID = folioUUID;
	}

	public String getTipoProveedor() {
		return tipoProveedor;
	}
	public void setTipoProveedor(String tipoProveedor) {
		this.tipoProveedor = tipoProveedor;
	}
	public String getDescTipoProveedor() {
		return descTipoProveedor;
	}
	public void setDescTipoProveedor(String descTipoProveedor) {
		this.descTipoProveedor = descTipoProveedor;
	}
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getCURP() {
		return CURP;
	}
	public void setCURP(String cURP) {
		CURP = cURP;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getTipoDispersion() {
		return tipoDispersion;
	}
	public void setTipoDispersion(String tipoDispersion) {
		this.tipoDispersion = tipoDispersion;
	}
	public String getImporte16() {
		return importe16;
	}
	public void setImporte16(String importe16) {
		this.importe16 = importe16;
	}
	public String getImporte0() {
		return importe0;
	}
	public void setImporte0(String importe0) {
		this.importe0 = importe0;
	}
	public String getImporteExcento() {
		return importeExcento;
	}
	public void setImporteExcento(String importeExcento) {
		this.importeExcento = importeExcento;
	}

	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getNoPartidaID() {
		return noPartidaID;
	}
	public void setNoPartidaID(String noPartidaID) {
		this.noPartidaID = noPartidaID;
	}
	public String getTotGravado() {
		return totGravado;
	}
	public void setTotGravado(String totGravado) {
		this.totGravado = totGravado;
	}
	public String getTotRetenido() {
		return totRetenido;
	}
	public void setTotRetenido(String totRetenido) {
		this.totRetenido = totRetenido;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getFechaVencim() {
		return fechaVencim;
	}
	public void setFechaVencim(String fechaVencim) {
		this.fechaVencim = fechaVencim;
	}
	public String getFechaPrefPago() {
		return fechaPrefPago;
	}
	public void setFechaPrefPago(String fechaPrefPago) {
		this.fechaPrefPago = fechaPrefPago;
	}
	public String getSumIVASiNo() {
		return sumIVASiNo;
	}
	public void setSumIVASiNo(String sumIVASiNo) {
		this.sumIVASiNo = sumIVASiNo;
	}
	public String getSumIVASiSi() {
		return sumIVASiSi;
	}
	public void setSumIVASiSi(String sumIVASiSi) {
		this.sumIVASiSi = sumIVASiSi;
	}
	public String getSumIVANoNo() {
		return sumIVANoNo;
	}
	public void setSumIVANoNo(String sumIVANoNo) {
		this.sumIVANoNo = sumIVANoNo;
	}
	public String getNombreProv() {
		return nombreProv;
	}
	public void setNombreProv(String nombreProv) {
		this.nombreProv = nombreProv;
	}
	public String getColumnas() {
		return Columnas;
	}
	public void setColumnas(String columnas) {
		Columnas = columnas;
	}
	public String getRfcEmisor() {
		return rfcEmisor;
	}
	public void setRfcEmisor(String rfcEmisor) {
		this.rfcEmisor = rfcEmisor;
	}
	public String getRfcReceptor() {
		return rfcReceptor;
	}
	public void setRfcReceptor(String rfcReceptor) {
		this.rfcReceptor = rfcReceptor;
	}
	public String getMontoTotal() {
		return montoTotal;
	}
	public void setMontoTotal(String montoTotal) {
		this.montoTotal = montoTotal;
	}
	public int getNumErrFacWS() {
		return numErrFacWS;
	}
	public void setNumErrFacWS(int numErrFacWS) {
		this.numErrFacWS = numErrFacWS;
	}
	public String getMensajeSalidaWS() {
		return mensajeSalidaWS;
	}
	public void setMensajeSalidaWS(String mensajeSalidaWS) {
		this.mensajeSalidaWS = mensajeSalidaWS;
	}
	public String getTipoCaptura() {
		return tipoCaptura;
	}
	public void setTipoCaptura(String tipoCaptura) {
		this.tipoCaptura = tipoCaptura;
	}
	public String getDesTipoCaptura() {
		return desTipoCaptura;
	}
	public void setDesTipoCaptura(String desTipoCaptura) {
		this.desTipoCaptura = desTipoCaptura;
	}
	public String getFolioCargaID() {
		return folioCargaID;
	}
	public void setFolioCargaID(String folioCargaID) {
		this.folioCargaID = folioCargaID;
	}
	public String getFolioFacturaID() {
		return folioFacturaID;
	}
	public void setFolioFacturaID(String folioFacturaID) {
		this.folioFacturaID = folioFacturaID;
	}
	public String getMesSubirFact() {
		return mesSubirFact;
	}
	public void setMesSubirFact(String mesSubirFact) {
		this.mesSubirFact = mesSubirFact;
	}
	
	
	
	
	
}

