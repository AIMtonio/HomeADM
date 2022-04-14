package tesoreria.bean;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class CargaMasivaFacturasBean extends BaseBean{

	private String fechaInicio;
	private String consecutivo;
	private String folioFacturaID;
	private String folioCargaID;
	private String fechaCarga;
	private String mesSubirFact;
	private String UUID;
	private String estatus;
	private String esCancelable;
	private String estatusCancelacion;
	private String tipo;
	private String anio;
	private String mes;
	private String dia;
	private String fechaEmision;
	private String fechaTimbrado;
	private String serie;
	private String folio;
	private String lugarExpedicion;
	private String confirmacion;
	private String cfdiRelacionados;
	private String formaPago;
	private String metodoPago;
	private String condicionesPago;
	private String tipoCambio;
	private String moneda;
	private String subTotal;
	private String descuento;
	private String total;
	private String iSRRetenido;
	private String iVARetenidoGlobal;
	private String iVARetenido6;
	private String iVATrasladado16;
	private String iVATrasladado8;
	private String iVAExento;
	private String baseIVAExento;
	private String iVATasaCero;
	private String baseIVATasaCero;
	private String iEPSRetenidoTasa;
	private String iEPSTrasladadoTasa;
	private String iEPSRetenidoCuota;
	private String iEPSTrasladadoCuota;
	private String totalImpuestosRetenidos;
	private String totalImpuestosTrasladados;
	private String totalRetencionesLocales;
	private String totalTrasladosLocales;
	private String impuestoLocalRetenido;
	private String tasadeRetencionLocal;
	private String importedeRetencionLocal;
	private String impuestoLocalTrasladado;
	private String tasadeTrasladoLocal;
	private String importedeTrasladoLocal;
	private String rfcEmisor;
	private String nombreEmisor;
	private String regimenFiscalEmisor;
	private String rfcReceptor;
	private String nombreReceptor;
	private String usoCFDIReceptor;
	private String residenciaFiscal;
	private String numRegIdTrib;
	private String listaNegra;
	private String conceptos;
	private String pACCertifico;
	private String rutadelXML;
	private String estatusPro;
	private String esExitoso;
	private String tipoError;
	private String descripcionError;
	private String usuario;
	private String totalFacturas;
	private String numFacturasExito;
	private String numFacturasError;
	private String descripcion;
	
	private MultipartFile  file;
	private String rutaArchivo;
	private String seleccionadoCheck;
	private String centroCostoID;
	private String tipoGastoID;
	private String descripcionEstatus;
	private String mesNoCorresponde;
	private String mesCorresponde;
	private String provNoExiste;
	private String provExiste;
	private String totalProvedores;
	private String safiID;
	
	private List lfolioCargaID;
	private List lrfc;
	private List lnombre;
	private List ltotalFactura;
	private List lfechaEmision;
	private List luuid;
	private List lestatus;
	
	public String getMes() {
		return mes;
	}

	public void setMes(String mes) {
		this.mes = mes;
	}

	public String getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(String fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public String getRutaArchivo() {
		return rutaArchivo;
	}

	public void setRutaArchivo(String rutaArchivo) {
		this.rutaArchivo = rutaArchivo;
	}

	public String getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	
	public String getConsecutivo() {
		return consecutivo;
	}

	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
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

	public String getUUID() {
		return UUID;
	}

	public void setUUID(String uUID) {
		UUID = uUID;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getEsCancelable() {
		return esCancelable;
	}

	public void setEsCancelable(String esCancelable) {
		this.esCancelable = esCancelable;
	}

	public String getEstatusCancelacion() {
		return estatusCancelacion;
	}

	public void setEstatusCancelacion(String estatusCancelacion) {
		this.estatusCancelacion = estatusCancelacion;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getAnio() {
		return anio;
	}

	public void setAnio(String anio) {
		this.anio = anio;
	}

	public String getDia() {
		return dia;
	}

	public void setDia(String dia) {
		this.dia = dia;
	}

	public String getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public String getFechaTimbrado() {
		return fechaTimbrado;
	}

	public void setFechaTimbrado(String fechaTimbrado) {
		this.fechaTimbrado = fechaTimbrado;
	}

	public String getSerie() {
		return serie;
	}

	public void setSerie(String serie) {
		this.serie = serie;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getLugarExpedicion() {
		return lugarExpedicion;
	}

	public void setLugarExpedicion(String lugarExpedicion) {
		this.lugarExpedicion = lugarExpedicion;
	}

	public String getConfirmacion() {
		return confirmacion;
	}

	public void setConfirmacion(String confirmacion) {
		this.confirmacion = confirmacion;
	}

	public String getCfdiRelacionados() {
		return cfdiRelacionados;
	}

	public void setCfdiRelacionados(String cfdiRelacionados) {
		this.cfdiRelacionados = cfdiRelacionados;
	}

	public String getFormaPago() {
		return formaPago;
	}

	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}

	public String getMetodoPago() {
		return metodoPago;
	}

	public void setMetodoPago(String metodoPago) {
		this.metodoPago = metodoPago;
	}

	public String getCondicionesPago() {
		return condicionesPago;
	}

	public void setCondicionesPago(String condicionesPago) {
		this.condicionesPago = condicionesPago;
	}

	public String getTipoCambio() {
		return tipoCambio;
	}

	public void setTipoCambio(String tipoCambio) {
		this.tipoCambio = tipoCambio;
	}

	public String getMoneda() {
		return moneda;
	}

	public void setMoneda(String moneda) {
		this.moneda = moneda;
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

	public String getiSRRetenido() {
		return iSRRetenido;
	}

	public void setiSRRetenido(String iSRRetenido) {
		this.iSRRetenido = iSRRetenido;
	}

	public String getiVARetenidoGlobal() {
		return iVARetenidoGlobal;
	}

	public void setiVARetenidoGlobal(String iVARetenidoGlobal) {
		this.iVARetenidoGlobal = iVARetenidoGlobal;
	}

	public String getiVARetenido6() {
		return iVARetenido6;
	}

	public void setiVARetenido6(String iVARetenido6) {
		this.iVARetenido6 = iVARetenido6;
	}

	public String getiVATrasladado16() {
		return iVATrasladado16;
	}

	public void setiVATrasladado16(String iVATrasladado16) {
		this.iVATrasladado16 = iVATrasladado16;
	}

	public String getiVATrasladado8() {
		return iVATrasladado8;
	}

	public void setiVATrasladado8(String iVATrasladado8) {
		this.iVATrasladado8 = iVATrasladado8;
	}

	public String getiVAExento() {
		return iVAExento;
	}

	public void setiVAExento(String iVAExento) {
		this.iVAExento = iVAExento;
	}

	public String getBaseIVAExento() {
		return baseIVAExento;
	}

	public void setBaseIVAExento(String baseIVAExento) {
		this.baseIVAExento = baseIVAExento;
	}

	public String getiVATasaCero() {
		return iVATasaCero;
	}

	public void setiVATasaCero(String iVATasaCero) {
		this.iVATasaCero = iVATasaCero;
	}

	public String getBaseIVATasaCero() {
		return baseIVATasaCero;
	}

	public void setBaseIVATasaCero(String baseIVATasaCero) {
		this.baseIVATasaCero = baseIVATasaCero;
	}

	public String getiEPSRetenidoTasa() {
		return iEPSRetenidoTasa;
	}

	public void setiEPSRetenidoTasa(String iEPSRetenidoTasa) {
		this.iEPSRetenidoTasa = iEPSRetenidoTasa;
	}

	public String getiEPSTrasladadoTasa() {
		return iEPSTrasladadoTasa;
	}

	public void setiEPSTrasladadoTasa(String iEPSTrasladadoTasa) {
		this.iEPSTrasladadoTasa = iEPSTrasladadoTasa;
	}

	public String getiEPSRetenidoCuota() {
		return iEPSRetenidoCuota;
	}

	public void setiEPSRetenidoCuota(String iEPSRetenidoCuota) {
		this.iEPSRetenidoCuota = iEPSRetenidoCuota;
	}

	public String getiEPSTrasladadoCuota() {
		return iEPSTrasladadoCuota;
	}

	public void setiEPSTrasladadoCuota(String iEPSTrasladadoCuota) {
		this.iEPSTrasladadoCuota = iEPSTrasladadoCuota;
	}

	public String getTotalImpuestosRetenidos() {
		return totalImpuestosRetenidos;
	}

	public void setTotalImpuestosRetenidos(String totalImpuestosRetenidos) {
		this.totalImpuestosRetenidos = totalImpuestosRetenidos;
	}

	public String getTotalImpuestosTrasladados() {
		return totalImpuestosTrasladados;
	}

	public void setTotalImpuestosTrasladados(String totalImpuestosTrasladados) {
		this.totalImpuestosTrasladados = totalImpuestosTrasladados;
	}

	public String getTotalRetencionesLocales() {
		return totalRetencionesLocales;
	}

	public void setTotalRetencionesLocales(String totalRetencionesLocales) {
		this.totalRetencionesLocales = totalRetencionesLocales;
	}

	public String getTotalTrasladosLocales() {
		return totalTrasladosLocales;
	}

	public void setTotalTrasladosLocales(String totalTrasladosLocales) {
		this.totalTrasladosLocales = totalTrasladosLocales;
	}

	public String getImpuestoLocalRetenido() {
		return impuestoLocalRetenido;
	}

	public void setImpuestoLocalRetenido(String impuestoLocalRetenido) {
		this.impuestoLocalRetenido = impuestoLocalRetenido;
	}

	public String getTasadeRetencionLocal() {
		return tasadeRetencionLocal;
	}

	public void setTasadeRetencionLocal(String tasadeRetencionLocal) {
		this.tasadeRetencionLocal = tasadeRetencionLocal;
	}

	public String getImportedeRetencionLocal() {
		return importedeRetencionLocal;
	}

	public void setImportedeRetencionLocal(String importedeRetencionLocal) {
		this.importedeRetencionLocal = importedeRetencionLocal;
	}

	public String getImpuestoLocalTrasladado() {
		return impuestoLocalTrasladado;
	}

	public void setImpuestoLocalTrasladado(String impuestoLocalTrasladado) {
		this.impuestoLocalTrasladado = impuestoLocalTrasladado;
	}

	public String getTasadeTrasladoLocal() {
		return tasadeTrasladoLocal;
	}

	public void setTasadeTrasladoLocal(String tasadeTrasladoLocal) {
		this.tasadeTrasladoLocal = tasadeTrasladoLocal;
	}

	public String getImportedeTrasladoLocal() {
		return importedeTrasladoLocal;
	}

	public void setImportedeTrasladoLocal(String importedeTrasladoLocal) {
		this.importedeTrasladoLocal = importedeTrasladoLocal;
	}

	public String getRfcEmisor() {
		return rfcEmisor;
	}

	public void setRfcEmisor(String rfcEmisor) {
		this.rfcEmisor = rfcEmisor;
	}

	public String getNombreEmisor() {
		return nombreEmisor;
	}

	public void setNombreEmisor(String nombreEmisor) {
		this.nombreEmisor = nombreEmisor;
	}

	public String getRegimenFiscalEmisor() {
		return regimenFiscalEmisor;
	}

	public void setRegimenFiscalEmisor(String regimenFiscalEmisor) {
		this.regimenFiscalEmisor = regimenFiscalEmisor;
	}

	public String getRfcReceptor() {
		return rfcReceptor;
	}

	public void setRfcReceptor(String rfcReceptor) {
		this.rfcReceptor = rfcReceptor;
	}

	public String getNombreReceptor() {
		return nombreReceptor;
	}

	public void setNombreReceptor(String nombreReceptor) {
		this.nombreReceptor = nombreReceptor;
	}

	public String getUsoCFDIReceptor() {
		return usoCFDIReceptor;
	}

	public void setUsoCFDIReceptor(String usoCFDIReceptor) {
		this.usoCFDIReceptor = usoCFDIReceptor;
	}

	public String getResidenciaFiscal() {
		return residenciaFiscal;
	}

	public void setResidenciaFiscal(String residenciaFiscal) {
		this.residenciaFiscal = residenciaFiscal;
	}

	public String getNumRegIdTrib() {
		return numRegIdTrib;
	}

	public void setNumRegIdTrib(String numRegIdTrib) {
		this.numRegIdTrib = numRegIdTrib;
	}

	public String getListaNegra() {
		return listaNegra;
	}

	public void setListaNegra(String listaNegra) {
		this.listaNegra = listaNegra;
	}

	public String getConceptos() {
		return conceptos;
	}

	public void setConceptos(String conceptos) {
		this.conceptos = conceptos;
	}

	public String getpACCertifico() {
		return pACCertifico;
	}

	public void setpACCertifico(String pACCertifico) {
		this.pACCertifico = pACCertifico;
	}

	public String getRutadelXML() {
		return rutadelXML;
	}

	public void setRutadelXML(String rutadelXML) {
		this.rutadelXML = rutadelXML;
	}

	public String getEstatusPro() {
		return estatusPro;
	}

	public void setEstatusPro(String estatusPro) {
		this.estatusPro = estatusPro;
	}

	public String getEsExitoso() {
		return esExitoso;
	}

	public void setEsExitoso(String esExitoso) {
		this.esExitoso = esExitoso;
	}

	public String getTipoError() {
		return tipoError;
	}

	public void setTipoError(String tipoError) {
		this.tipoError = tipoError;
	}

	public String getDescripcionError() {
		return descripcionError;
	}

	public void setDescripcionError(String descripcionError) {
		this.descripcionError = descripcionError;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getTotalFacturas() {
		return totalFacturas;
	}

	public void setTotalFacturas(String totalFacturas) {
		this.totalFacturas = totalFacturas;
	}

	public String getNumFacturasExito() {
		return numFacturasExito;
	}

	public void setNumFacturasExito(String numFacturasExito) {
		this.numFacturasExito = numFacturasExito;
	}

	public String getNumFacturasError() {
		return numFacturasError;
	}

	public void setNumFacturasError(String numFacturasError) {
		this.numFacturasError = numFacturasError;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public List getLfolioCargaID() {
		return lfolioCargaID;
	}

	public void setLfolioCargaID(List lfolioCargaID) {
		this.lfolioCargaID = lfolioCargaID;
	}

	public List getLrfc() {
		return lrfc;
	}

	public void setLrfc(List lrfc) {
		this.lrfc = lrfc;
	}

	public List getLnombre() {
		return lnombre;
	}

	public void setLnombre(List lnombre) {
		this.lnombre = lnombre;
	}

	public List getLtotalFactura() {
		return ltotalFactura;
	}

	public void setLtotalFactura(List ltotalFactura) {
		this.ltotalFactura = ltotalFactura;
	}

	public List getLfechaEmision() {
		return lfechaEmision;
	}

	public void setLfechaEmision(List lfechaEmision) {
		this.lfechaEmision = lfechaEmision;
	}

	public List getLuuid() {
		return luuid;
	}

	public void setLuuid(List luuid) {
		this.luuid = luuid;
	}

	public List getLestatus() {
		return lestatus;
	}

	public void setLestatus(List lestatus) {
		this.lestatus = lestatus;
	}

	public String getSeleccionadoCheck() {
		return seleccionadoCheck;
	}

	public void setSeleccionadoCheck(String seleccionadoCheck) {
		this.seleccionadoCheck = seleccionadoCheck;
	}

	public String getCentroCostoID() {
		return centroCostoID;
	}

	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}

	public String getTipoGastoID() {
		return tipoGastoID;
	}

	public void setTipoGastoID(String tipoGastoID) {
		this.tipoGastoID = tipoGastoID;
	}

	public String getDescripcionEstatus() {
		return descripcionEstatus;
	}

	public void setDescripcionEstatus(String descripcionEstatus) {
		this.descripcionEstatus = descripcionEstatus;
	}

	public String getMesNoCorresponde() {
		return mesNoCorresponde;
	}

	public void setMesNoCorresponde(String mesNoCorresponde) {
		this.mesNoCorresponde = mesNoCorresponde;
	}

	public String getMesCorresponde() {
		return mesCorresponde;
	}

	public void setMesCorresponde(String mesCorresponde) {
		this.mesCorresponde = mesCorresponde;
	}

	public String getProvNoExiste() {
		return provNoExiste;
	}

	public void setProvNoExiste(String provNoExiste) {
		this.provNoExiste = provNoExiste;
	}

	public String getProvExiste() {
		return provExiste;
	}

	public void setProvExiste(String provExiste) {
		this.provExiste = provExiste;
	}

	public String getTotalProvedores() {
		return totalProvedores;
	}

	public void setTotalProvedores(String totalProvedores) {
		this.totalProvedores = totalProvedores;
	}

	public String getSafiID() {
		return safiID;
	}

	public void setSafiID(String safiID) {
		this.safiID = safiID;
	}
	
	
	 
}
