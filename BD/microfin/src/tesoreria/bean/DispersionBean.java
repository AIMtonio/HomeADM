package tesoreria.bean;

import java.util.List;

import general.bean.BaseBean;

public class DispersionBean extends BaseBean{

	private String folioOperacion;
	private String fechaOperacion;
	private String institucionID;
	private String cuentaAhorro;
	private String numCtaInstit;
	private String nombreCuentaInst;
	private String nombreCte;
	private String sobregirarSaldo;
	private String fechaConsulta;
	private String contDispOrdpag;
	private String contDispTrans;
	
	private List cuentaAhoID;
	private List descripcion;
	private List referencia;
	private List tipoMov;
	private List monto;
	private List cuentaClabe;
	private List rfc;
	private List estatus;
	private List claveDispMov;
	private List fechaEnvio;
	private List nombreBenefi;
	private List formaPago;
	private List cuentaCompletaID;
	private List claveDispMovi;
	private List stipoChequera;
	private List sConceptoDisp;
	
	private String folioIntitucion;

	/* SECCION DE ATRIBUTOS PARA GRID DE AUTORIZACION*/
	private List cuentaAhoIDA;
	private List descripcionA;
	private List referenciaA;
	private List tipoMovA;
	private List montoA;
	private List cuentaClabeA;
	private List rfcA;
	private List estatusA;
	private List claveDispMovA;
	private List fechaEnvioA;
	private List nombreBenefiA;
	private List formaPagoA;
	private List cuentaCompletaIDA;
	private List clienteIDA;
	private List claveDispMoviA;
	private List tipoChequeraA;
	private List conceptoDispA;
	
	// reporte
	private String fechaInicio;
	private String fechaFin;
	private String estatusEnc;
	private String estatusDet;
	private String sucursal;
	private String nomEstatusMov;
	private String nomEstatus;
	private String nomSucursal;
	private String nomInstitucion;
	private String nomInstitucionID;
	private String nomUsuario;
	private String fechaEmision;
	private String nombreCuentAho;
	private String formaPagoID;
	private String nomFormaPago;
	
	//reporte orden pago
	private String referenciaDisp;
	private String montoDisp;
	private String cuentaClabeDisp;
	private String fechaEnvioDisp;
	
	//proteccion orden de pago bancomer
	private String protecOrdenPago;
	
	
	
	private String fechaVen;
	private String complemento;
	private String tipoRef;
	private String claveDisp;
	private String permiteVer;

	private String solicitudCreditoID;
	private String creditoID;
	private String cuentaDestino;
	private String dispersionID;
	private String nombreCompleto;
	private String claveDispMovID;
	private String estatusDisp;
	
	public List getCuentaAhoIDA() {
		return cuentaAhoIDA;
	}

	public void setCuentaAhoIDA(List cuentaAhoIDA) {
		this.cuentaAhoIDA = cuentaAhoIDA;
	}

	public List getDescripcionA() {
		return descripcionA;
	}

	public void setDescripcionA(List descripcionA) {
		this.descripcionA = descripcionA;
	}

	public List getReferenciaA() {
		return referenciaA;
	}

	public void setReferenciaA(List referenciaA) {
		this.referenciaA = referenciaA;
	}

	public List getTipoMovA() {
		return tipoMovA;
	}

	public void setTipoMovA(List tipoMovA) {
		this.tipoMovA = tipoMovA;
	}

	public List getMontoA() {
		return montoA;
	}

	public void setMontoA(List montoA) {
		this.montoA = montoA;
	}

	public List getCuentaClabeA() {
		return cuentaClabeA;
	}

	public void setCuentaClabeA(List cuentaClabeA) {
		this.cuentaClabeA = cuentaClabeA;
	}

	public List getRfcA() {
		return rfcA;
	}

	public void setRfcA(List rfcA) {
		this.rfcA = rfcA;
	}

	public List getEstatusA() {
		return estatusA;
	}

	public void setEstatusA(List estatusA) {
		this.estatusA = estatusA;
	}

	public List getClaveDispMovA() {
		return claveDispMovA;
	}

	public void setClaveDispMovA(List claveDispMovA) {
		this.claveDispMovA = claveDispMovA;
	}

	public List getFechaEnvioA() {
		return fechaEnvioA;
	}

	public void setFechaEnvioA(List fechaEnvioA) {
		this.fechaEnvioA = fechaEnvioA;
	}

	public List getNombreBenefiA() {
		return nombreBenefiA;
	}

	public void setNombreBenefiA(List nombreBenefiA) {
		this.nombreBenefiA = nombreBenefiA;
	}

	public List getFormaPagoA() {
		return formaPagoA;
	}

	public void setFormaPagoA(List formaPagoA) {
		this.formaPagoA = formaPagoA;
	}

	public List getCuentaCompletaIDA() {
		return cuentaCompletaIDA;
	}

	public void setCuentaCompletaIDA(List cuentaCompletaIDA) {
		this.cuentaCompletaIDA = cuentaCompletaIDA;
	}

	public List getClienteIDA() {
		return clienteIDA;
	}

	public void setClienteIDA(List clienteIDA) {
		this.clienteIDA = clienteIDA;
	}

	public List getClaveDispMoviA() {
		return claveDispMoviA;
	}

	public void setClaveDispMoviA(List claveDispMoviA) {
		this.claveDispMoviA = claveDispMoviA;
	}
		
	public List getCuentaCompletaID() {
		return cuentaCompletaID;
	}

	public void setCuentaCompletaID(List cuentaCompletaID) {
		this.cuentaCompletaID = cuentaCompletaID;
	}

	public String getNombreCuentAho() {
		return nombreCuentAho;
	}

	public void setNombreCuentAho(String nombreCuentAho) {
		this.nombreCuentAho = nombreCuentAho;
	}

	public String getNomInstitucionID() {
		return nomInstitucionID;
	}

	public void setNomInstitucionID(String nomInstitucionID) {
		this.nomInstitucionID = nomInstitucionID;
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

	public String getEstatusEnc() {
		return estatusEnc;
	}

	public void setEstatusEnc(String estatusEnc) {
		this.estatusEnc = estatusEnc;
	}

	public String getEstatusDet() {
		return estatusDet;
	}

	public void setEstatusDet(String estatusDet) {
		this.estatusDet = estatusDet;
	}

	public String getSucursal() {
		return sucursal;
	}

	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}

	public String getNomEstatusMov() {
		return nomEstatusMov;
	}

	public void setNomEstatusMov(String nomEstatusMov) {
		this.nomEstatusMov = nomEstatusMov;
	}

	public String getNomEstatus() {
		return nomEstatus;
	}

	public void setNomEstatus(String nomEstatus) {
		this.nomEstatus = nomEstatus;
	}

	public String getNomSucursal() {
		return nomSucursal;
	}

	public void setNomSucursal(String nomSucursal) {
		this.nomSucursal = nomSucursal;
	}

	public String getNomInstitucion() {
		return nomInstitucion;
	}

	public void setNomInstitucion(String nomInstitucion) {
		this.nomInstitucion = nomInstitucion;
	}

	public String getNomUsuario() {
		return nomUsuario;
	}

	public void setNomUsuario(String nomUsuario) {
		this.nomUsuario = nomUsuario;
	}

	public String getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	//Campo utilizado para obtener el saldo invBancaria
	private String saldoCuenta;
	private String tipoMoneda;
	
	//Auxiliares del Bean para la lista
	private String nombreCorto;

	public String getFolioOperacion() {
		return folioOperacion;
	}

	public void setFolioOperacion(String folioOperacion) {
		this.folioOperacion = folioOperacion;
	}

	public String getFechaOperacion() {
		return fechaOperacion;
	}

	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}

	public String getInstitucionID() {
		return institucionID;
	}

	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}

	public String getCuentaAhorro() {
		return cuentaAhorro;
	}

	public void setCuentaAhorro(String cuentaAhorro) {
		this.cuentaAhorro = cuentaAhorro;
	}

	public String getNumCtaInstit() {
		return numCtaInstit;
	}

	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}

	public String getNombreCuentaInst() {
		return nombreCuentaInst;
	}

	public void setNombreCuentaInst(String nombreCuentaInst) {
		this.nombreCuentaInst = nombreCuentaInst;
	}

	public String getNombreCte() {
		return nombreCte;
	}

	public void setNombreCte(String nombreCte) {
		this.nombreCte = nombreCte;
	}

	public List getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(List cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}

	public List getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(List descripcion) {
		this.descripcion = descripcion;
	}

	public List getReferencia() {
		return referencia;
	}

	public void setReferencia(List referencia) {
		this.referencia = referencia;
	}

	public List getTipoMov() {
		return tipoMov;
	}

	public void setTipoMov(List tipoMov) {
		this.tipoMov = tipoMov;
	}

	public List getMonto() {
		return monto;
	}

	public void setMonto(List monto) {
		this.monto = monto;
	}

	public List getCuentaClabe() {
		return cuentaClabe;
	}

	public void setCuentaClabe(List cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}

	public List getRfc() {
		return rfc;
	}

	public void setRfc(List rfc) {
		this.rfc = rfc;
	}

	public List getEstatus() {
		return estatus;
	}

	public void setEstatus(List estatus) {
		this.estatus = estatus;
	}

	public List getClaveDispMov() {
		return claveDispMov;
	}

	public void setClaveDispMov(List claveDispMov) {
		this.claveDispMov = claveDispMov;
	}

	public List getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(List fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public List getNombreBenefi() {
		return nombreBenefi;
	}

	public void setNombreBenefi(List nombreBenefi) {
		this.nombreBenefi = nombreBenefi;
	}

	public List getFormaPago() {
		return formaPago;
	}

	public void setFormaPago(List formaPago) {
		this.formaPago = formaPago;
	}

	public String getFolioIntitucion() {
		return folioIntitucion;
	}

	public void setFolioIntitucion(String folioIntitucion) {
		this.folioIntitucion = folioIntitucion;
	}

	public String getSaldoCuenta() {
		return saldoCuenta;
	}

	public void setSaldoCuenta(String saldoCuenta) {
		this.saldoCuenta = saldoCuenta;
	}

	public String getTipoMoneda() {
		return tipoMoneda;
	}

	public void setTipoMoneda(String tipoMoneda) {
		this.tipoMoneda = tipoMoneda;
	}

	public String getNombreCorto() {
		return nombreCorto;
	}

	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
	}


	public List getClaveDispMovi() {
		return claveDispMovi;
	}

	public void setClaveDispMovi(List claveDispMovi) {
		this.claveDispMovi = claveDispMovi;
	}


	public String getSobregirarSaldo() {
		return sobregirarSaldo;
	}

	public void setSobregirarSaldo(String sobregirarSaldo) {
		this.sobregirarSaldo = sobregirarSaldo;
	}

	public List getTipoChequeraA() {
		return tipoChequeraA;
	}

	public void setTipoChequeraA(List tipoChequeraA) {
		this.tipoChequeraA = tipoChequeraA;
	}

	public List getStipoChequera() {
		return stipoChequera;
	}

	public List getConceptoDispA() {
		return conceptoDispA;
	}

	public void setConceptoDispA(List conceptoDispA) {
		this.conceptoDispA = conceptoDispA;
	}

	public void setStipoChequera(List stipoChequera) {
		this.stipoChequera = stipoChequera;
	}

	public List getsConceptoDisp() {
		return sConceptoDisp;
	}

	public void setsConceptoDisp(List sConceptoDisp) {
		this.sConceptoDisp = sConceptoDisp;
	}

	public String getFechaConsulta() {
		return fechaConsulta;
	}

	public void setFechaConsulta(String fechaConsulta) {
		this.fechaConsulta = fechaConsulta;
	}

	public String getReferenciaDisp() {
		return referenciaDisp;
	}

	public void setReferenciaDisp(String referenciaDisp) {
		this.referenciaDisp = referenciaDisp;
	}

	public String getMontoDisp() {
		return montoDisp;
	}

	public void setMontoDisp(String montoDisp) {
		this.montoDisp = montoDisp;
	}

	public String getCuentaClabeDisp() {
		return cuentaClabeDisp;
	}

	public void setCuentaClabeDisp(String cuentaClabeDisp) {
		this.cuentaClabeDisp = cuentaClabeDisp;
	}

	public String getFechaEnvioDisp() {
		return fechaEnvioDisp;
	}

	public void setFechaEnvioDisp(String fechaEnvioDisp) {
		this.fechaEnvioDisp = fechaEnvioDisp;
	}

	public String getProtecOrdenPago() {
		return protecOrdenPago;
	}

	public void setProtecOrdenPago(String protecOrdenPago) {
		this.protecOrdenPago = protecOrdenPago;
	}

	public String getContDispOrdpag() {
		return contDispOrdpag;
	}

	public void setContDispOrdpag(String contDispOrdpag) {
		this.contDispOrdpag = contDispOrdpag;
	}

	public String getContDispTrans() {
		return contDispTrans;
	}

	public void setContDispTrans(String contDispTrans) {
		this.contDispTrans = contDispTrans;
	}
	
	public String getFechaVen() {
		return fechaVen;
	}

	public void setFechaVen(String fechaVen) {
		this.fechaVen = fechaVen;
	}

	public String getComplemento() {
		return complemento;
	}

	public void setComplemento(String complemento) {
		this.complemento = complemento;
	}

	public String getTipoRef() {
		return tipoRef;
	}

	public void setTipoRef(String tipoRef) {
		this.tipoRef = tipoRef;
	}

	public String getClaveDisp() {
		return claveDisp;
	}

	public void setClaveDisp(String claveDisp) {
		this.claveDisp = claveDisp;
	}

	public String getFormaPagoID() {
		return formaPagoID;
	}

	public void setFormaPagoID(String formaPagoID) {
		this.formaPagoID = formaPagoID;
	}

	public String getNomFormaPago() {
		return nomFormaPago;
	}

	public void setNomFormaPago(String nomFormaPago) {
		this.nomFormaPago = nomFormaPago;
	}

	public String getPermiteVer() {
		return permiteVer;
	}

	public void setPermiteVer(String permiteVer) {
		this.permiteVer = permiteVer;
	}

	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}

	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}

	public String getCreditoID() {
		return creditoID;
	}

	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}

	public String getCuentaDestino() {
		return cuentaDestino;
	}

	public void setCuentaDestino(String cuentaDestino) {
		this.cuentaDestino = cuentaDestino;
	}

	public String getDispersionID() {
		return dispersionID;
	}

	public void setDispersionID(String dispersionID) {
		this.dispersionID = dispersionID;
	}

	public String getNombreCompleto() {
		return nombreCompleto;
	}

	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	public String getClaveDispMovID() {
		return claveDispMovID;
	}

	public void setClaveDispMovID(String claveDispMovID) {
		this.claveDispMovID = claveDispMovID;
	}

	public String getEstatusDisp() {
		return estatusDisp;
	}

	public void setEstatusDisp(String estatusDisp) {
		this.estatusDisp = estatusDisp;
	}
	
	
}

