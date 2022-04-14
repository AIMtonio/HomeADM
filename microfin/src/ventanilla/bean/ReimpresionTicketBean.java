package ventanilla.bean;

import general.bean.BaseBean;

public class ReimpresionTicketBean extends BaseBean{
	
	private String tipoOpera;
	private String numTransaccion;
	
	//Lista
	private String transaccionID;
	private String referencia;
	private String montoOperacion;
	private String nombrePersona;
	
	//Grid
	private String sucursalID;
	private String cajaID;
	private String usuarioID;
	private String fecha;
	private String hora;
	private String opcionCajaID;
	private String descripcion;	
	private String efectivo;
	private String cambio;
	private String clienteID;
	private String cuentaIDRetiro;
	private String cuentaIDDeposito;
	private String desTipoCuenta;
	private String saldoActualCta;
	private String formaPagoCobro;
	private String creditoID;
	private String producCreditoID;
	private String montoCredito;
	private String montoPorDesem;
	private String grupoID;
	private String cicloActual;
	private String montoProximoPago;
	private String fechaProximoPago;
	private String totalAdeudo;
	private String capital;
	private String interes;
	private String moratorios;
	private String comision;
	private String comisionAdmon;
	private String iVA;
	private String garantiaAdicional;
	private String institucionID;
	private String numCtaInstit;
	private String numCheque;
	private String polizaID;
	private String telefono;
	private String identificacion;
	private String folioIdentificacion;
	private String folioPago;
	private String catalogoServID;
	private String montoServicio;
	private String iVAServicio;
	private String montoComision;
	private String totalCastigado;
	private String totalRecuperado;
	private String monto_PorRecuperar;
	private String nombreInstitucion;
	private String nombreCatalServ;
	private String prospectoID;
	private String chequeSBCID;
	private String OrigenServicio;
	private String tipoServServifun;
	private String nombreBeneficiario;
	private String empleadoID;
	private String nombreEmpleado;
	private String etiquetaCtaRetiro;
	private String etiquetaCtaDepo;
	private String desTipoCtaDepo;
	private String nombreProdCred;
	private String nombreGrupo;
	private String montoDesemb;
	private String nombreCajero;
	private String nombreSucursal;
	private String clave;
	private String fechaOpera;
	private String empresaID;
	private String nombreMun;
	private String nombreEdo;
	private String plaza;
	private String moneda;
	
	private String montoSeguroCuota;
	private String iVASeguroCuota;
	private String cobraSeguroCuota;
	
	//COMISION ANUAL
	private String montoComAnual;//Comision de anualidad de crédito
	private String montoComAnualIVA;//IVA Comision de anualidad de crédito

	private String arrendaID;
	private String prodArrendaID;
	private String nomProdArrendaID; 
	private String seguroVida;
	private String seguro;
	private String iVASeguroVida;
	private String iVASeguro;
	private String iVACapital;
	private String iVAInteres;
	private String iVAMora;
	private String iVAOtrasComi;
	private String iVAComFaltaPag;	
	private String tipoCuenta;
	private String saldoInicial;
	
	private String accesorioID;
	
	public String getTipoOpera() {
		return tipoOpera;
	}
	public void setTipoOpera(String tipoOpera) {
		this.tipoOpera = tipoOpera;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getTransaccionID() {
		return transaccionID;
	}
	public void setTransaccionID(String transaccionID) {
		this.transaccionID = transaccionID;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getMontoOperacion() {
		return montoOperacion;
	}
	public void setMontoOperacion(String montoOperacion) {
		this.montoOperacion = montoOperacion;
	}
	public String getNombrePersona() {
		return nombrePersona;
	}
	public void setNombrePersona(String nombrePersona) {
		this.nombrePersona = nombrePersona;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getCajaID() {
		return cajaID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getOpcionCajaID() {
		return opcionCajaID;
	}
	public void setOpcionCajaID(String opcionCajaID) {
		this.opcionCajaID = opcionCajaID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEfectivo() {
		return efectivo;
	}
	public void setEfectivo(String efectivo) {
		this.efectivo = efectivo;
	}
	public String getCambio() {
		return cambio;
	}
	public void setCambio(String cambio) {
		this.cambio = cambio;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaIDRetiro() {
		return cuentaIDRetiro;
	}
	public void setCuentaIDRetiro(String cuentaIDRetiro) {
		this.cuentaIDRetiro = cuentaIDRetiro;
	}
	public String getCuentaIDDeposito() {
		return cuentaIDDeposito;
	}
	public void setCuentaIDDeposito(String cuentaIDDeposito) {
		this.cuentaIDDeposito = cuentaIDDeposito;
	}
	public String getDesTipoCuenta() {
		return desTipoCuenta;
	}
	public void setDesTipoCuenta(String desTipoCuenta) {
		this.desTipoCuenta = desTipoCuenta;
	}
	public String getSaldoActualCta() {
		return saldoActualCta;
	}
	public void setSaldoActualCta(String saldoActualCta) {
		this.saldoActualCta = saldoActualCta;
	}
	public String getFormaPagoCobro() {
		return formaPagoCobro;
	}
	public void setFormaPagoCobro(String formaPagoCobro) {
		this.formaPagoCobro = formaPagoCobro;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getCicloActual() {
		return cicloActual;
	}
	public void setCicloActual(String cicloActual) {
		this.cicloActual = cicloActual;
	}
	public String getMontoProximoPago() {
		return montoProximoPago;
	}
	public void setMontoProximoPago(String montoProximoPago) {
		this.montoProximoPago = montoProximoPago;
	}
	public String getFechaProximoPago() {
		return fechaProximoPago;
	}
	public void setFechaProximoPago(String fechaProximoPago) {
		this.fechaProximoPago = fechaProximoPago;
	}
	public String getTotalAdeudo() {
		return totalAdeudo;
	}
	public void setTotalAdeudo(String totalAdeudo) {
		this.totalAdeudo = totalAdeudo;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getInteres() {
		return interes;
	}
	public void setInteres(String interes) {
		this.interes = interes;
	}
	public String getMoratorios() {
		return moratorios;
	}
	public void setMoratorios(String moratorios) {
		this.moratorios = moratorios;
	}
	public String getComision() {
		return comision;
	}
	public void setComision(String comision) {
		this.comision = comision;
	}
	public String getComisionAdmon() {
		return comisionAdmon;
	}
	public void setComisionAdmon(String comisionAdmon) {
		this.comisionAdmon = comisionAdmon;
	}
	public String getiVA() {
		return iVA;
	}
	public void setiVA(String iVA) {
		this.iVA = iVA;
	}
	public String getGarantiaAdicional() {
		return garantiaAdicional;
	}
	public void setGarantiaAdicional(String garantiaAdicional) {
		this.garantiaAdicional = garantiaAdicional;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public String getNumCheque() {
		return numCheque;
	}
	public void setNumCheque(String numCheque) {
		this.numCheque = numCheque;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getIdentificacion() {
		return identificacion;
	}
	public void setIdentificacion(String identificacion) {
		this.identificacion = identificacion;
	}
	public String getFolioIdentificacion() {
		return folioIdentificacion;
	}
	public void setFolioIdentificacion(String folioIdentificacion) {
		this.folioIdentificacion = folioIdentificacion;
	}
	public String getFolioPago() {
		return folioPago;
	}
	public void setFolioPago(String folioPago) {
		this.folioPago = folioPago;
	}
	public String getCatalogoServID() {
		return catalogoServID;
	}
	public void setCatalogoServID(String catalogoServID) {
		this.catalogoServID = catalogoServID;
	}
	public String getMontoServicio() {
		return montoServicio;
	}
	public void setMontoServicio(String montoServicio) {
		this.montoServicio = montoServicio;
	}
	public String getiVAServicio() {
		return iVAServicio;
	}
	public void setiVAServicio(String iVAServicio) {
		this.iVAServicio = iVAServicio;
	}
	public String getMontoComision() {
		return montoComision;
	}
	public void setMontoComision(String montoComision) {
		this.montoComision = montoComision;
	}
	public String getTotalCastigado() {
		return totalCastigado;
	}
	public void setTotalCastigado(String totalCastigado) {
		this.totalCastigado = totalCastigado;
	}
	public String getTotalRecuperado() {
		return totalRecuperado;
	}
	public void setTotalRecuperado(String totalRecuperado) {
		this.totalRecuperado = totalRecuperado;
	}
	public String getMonto_PorRecuperar() {
		return monto_PorRecuperar;
	}
	public void setMonto_PorRecuperar(String monto_PorRecuperar) {
		this.monto_PorRecuperar = monto_PorRecuperar;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNombreCatalServ() {
		return nombreCatalServ;
	}
	public void setNombreCatalServ(String nombreCatalServ) {
		this.nombreCatalServ = nombreCatalServ;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getChequeSBCID() {
		return chequeSBCID;
	}
	public void setChequeSBCID(String chequeSBCID) {
		this.chequeSBCID = chequeSBCID;
	}
	public String getOrigenServicio() {
		return OrigenServicio;
	}
	public void setOrigenServicio(String origenServicio) {
		OrigenServicio = origenServicio;
	}
	public String getTipoServServifun() {
		return tipoServServifun;
	}
	public void setTipoServServifun(String tipoServServifun) {
		this.tipoServServifun = tipoServServifun;
	}
	public String getNombreBeneficiario() {
		return nombreBeneficiario;
	}
	public void setNombreBeneficiario(String nombreBeneficiario) {
		this.nombreBeneficiario = nombreBeneficiario;
	}
	public String getEmpleadoID() {
		return empleadoID;
	}
	public void setEmpleadoID(String empleadoID) {
		this.empleadoID = empleadoID;
	}
	public String getNombreEmpleado() {
		return nombreEmpleado;
	}
	public void setNombreEmpleado(String nombreEmpleado) {
		this.nombreEmpleado = nombreEmpleado;
	}
	public String getEtiquetaCtaRetiro() {
		return etiquetaCtaRetiro;
	}
	public void setEtiquetaCtaRetiro(String etiquetaCtaRetiro) {
		this.etiquetaCtaRetiro = etiquetaCtaRetiro;
	}
	public String getEtiquetaCtaDepo() {
		return etiquetaCtaDepo;
	}
	public void setEtiquetaCtaDepo(String etiquetaCtaDepo) {
		this.etiquetaCtaDepo = etiquetaCtaDepo;
	}
	public String getDesTipoCtaDepo() {
		return desTipoCtaDepo;
	}
	public void setDesTipoCtaDepo(String desTipoCtaDepo) {
		this.desTipoCtaDepo = desTipoCtaDepo;
	}
	public String getNombreProdCred() {
		return nombreProdCred;
	}
	public void setNombreProdCred(String nombreProdCred) {
		this.nombreProdCred = nombreProdCred;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public String getMontoPorDesem() {
		return montoPorDesem;
	}
	public void setMontoPorDesem(String montoPorDesem) {
		this.montoPorDesem = montoPorDesem;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	public String getMontoDesemb() {
		return montoDesemb;
	}
	public void setMontoDesemb(String montoDesemb) {
		this.montoDesemb = montoDesemb;
	}
	public String getNombreCajero() {
		return nombreCajero;
	}
	public void setNombreCajero(String nombreCajero) {
		this.nombreCajero = nombreCajero;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getFechaOpera() {
		return fechaOpera;
	}
	public void setFechaOpera(String fechaOpera) {
		this.fechaOpera = fechaOpera;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getNombreMun() {
		return nombreMun;
	}
	public void setNombreMun(String nombreMun) {
		this.nombreMun = nombreMun;
	}
	public String getNombreEdo() {
		return nombreEdo;
	}
	public void setNombreEdo(String nombreEdo) {
		this.nombreEdo = nombreEdo;
	}
	public String getPlaza() {
		return plaza;
	}
	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}
	public String getMoneda() {
		return moneda;
	}
	public void setMoneda(String moneda) {
		this.moneda = moneda;
	}
	public String getMontoSeguroCuota() {
		return montoSeguroCuota;
	}
	public void setMontoSeguroCuota(String montoSeguroCuota) {
		this.montoSeguroCuota = montoSeguroCuota;
	}
	public String getCobraSeguroCuota() {
		return cobraSeguroCuota;
	}
	public void setCobraSeguroCuota(String cobraSeguroCuota) {
		this.cobraSeguroCuota = cobraSeguroCuota;
	}
	public String getiVASeguroCuota() {
		return iVASeguroCuota;
	}
	public void setiVASeguroCuota(String iVASeguroCuota) {
		this.iVASeguroCuota = iVASeguroCuota;
	}
	public String getMontoComAnual() {
		return montoComAnual;
	}
	public void setMontoComAnual(String montoComAnual) {
		this.montoComAnual = montoComAnual;
	}
	public String getMontoComAnualIVA() {
		return montoComAnualIVA;
	}
	public void setMontoComAnualIVA(String montoComAnualIVA) {
		this.montoComAnualIVA = montoComAnualIVA;
	}

	public String getArrendaID() {
		return arrendaID;
	}
	public void setArrendaID(String arrendaID) {
		this.arrendaID = arrendaID;
	}
	public String getProdArrendaID() {
		return prodArrendaID;
	}
	public void setProdArrendaID(String prodArrendaID) {
		this.prodArrendaID = prodArrendaID;
	}
	public String getNomProdArrendaID() {
		return nomProdArrendaID;
	}
	public void setNomProdArrendaID(String nomProdArrendaID) {
		this.nomProdArrendaID = nomProdArrendaID;
	}
	public String getSeguroVida() {
		return seguroVida;
	}
	public void setSeguroVida(String seguroVida) {
		this.seguroVida = seguroVida;
	}
	public String getSeguro() {
		return seguro;
	}
	public void setSeguro(String seguro) {
		this.seguro = seguro;
	}
	public String getiVASeguroVida() {
		return iVASeguroVida;
	}
	public void setiVASeguroVida(String iVASeguroVida) {
		this.iVASeguroVida = iVASeguroVida;
	}
	public String getiVASeguro() {
		return iVASeguro;
	}
	public void setiVASeguro(String iVASeguro) {
		this.iVASeguro = iVASeguro;
	}
	public String getiVACapital() {
		return iVACapital;
	}
	public void setiVACapital(String iVACapital) {
		this.iVACapital = iVACapital;
	}
	public String getiVAInteres() {
		return iVAInteres;
	}
	public void setiVAInteres(String iVAInteres) {
		this.iVAInteres = iVAInteres;
	}
	public String getiVAMora() {
		return iVAMora;
	}
	public void setiVAMora(String iVAMora) {
		this.iVAMora = iVAMora;
	}
	public String getiVAOtrasComi() {
		return iVAOtrasComi;
	}
	public void setiVAOtrasComi(String iVAOtrasComi) {
		this.iVAOtrasComi = iVAOtrasComi;
	}
	public String getiVAComFaltaPag() {
		return iVAComFaltaPag;
	}
	public void setiVAComFaltaPag(String iVAComFaltaPag) {
		this.iVAComFaltaPag = iVAComFaltaPag;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
	public String getSaldoInicial() {
		return saldoInicial;
	}
	public void setSaldoInicial(String saldoInicial) {
		this.saldoInicial = saldoInicial;
	}
	public String getAccesorioID() {
		return accesorioID;
	}
	public void setAccesorioID(String accesorioID) {
		this.accesorioID = accesorioID;
	}
}
