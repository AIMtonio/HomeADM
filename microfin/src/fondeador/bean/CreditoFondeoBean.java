package fondeador.bean;

import general.bean.BaseBean;

public class CreditoFondeoBean extends BaseBean {
	/* atributos tabla CREDITOFONDEO */
	private String creditoFondeoID;
	private String lineaFondeoID;
	private String institutFondID;
	private String folio;
	private String tipoCalInteres;
	private String calcInteresID;
	private String tasaBase;
	private String sobreTasa;
	private String tasaFija;
	private String pisoTasa;
	private String techoTasa;
	private String factorMora;
	private String monto;
	private String monedaID;
	private String fechaInicio;
	private String fechaVencimien;
	private String fechaTerminaci;
	private String estatus;
	private String saldoCapVigente;
	private String saldoCapAtrasad;
	private String saldoInteresAtra;
	private String saldoInteres;
	private String saldoMoratorio;
	private String saldoIVAMora;
	private String saldoComFaltPag;
	private String saldoIVAComFal;
	private String provisionAcum;
	private String tipoPagoCapital;
	private String frecuenciaCap;
	private String periodicidadCap;
	private String numAmortizacion;
	private String frecuenciaInt;
	private String periodicidadInt;
	private String numAmortInteres;
	private String montoCuota;
	private String fechaInhabil;
	private String calendIrregular;
	private String diaPagoInteres;
	private String diaPagoCapital;
	private String diaMesInteres;
	private String diaMesCapital;
	private String ajusFecUlVenAmo;
	private String ajusFecExiVen;
	private String numTransacSim;
	private String plazoID;
	private String institucionID;
	private String cuentaClabe;
	private String numCtaInstit;
	private String fechaContable;
	private String plazoContable; 
	private String tipoInstitID;
	private String nacionalidadIns;

	private String saldoIVAInteres;
	private String saldoOtrasComis;
	private String saldoIVAComisi;
	private String porcentanjeIVA;

	private String FechaEmision;
	private String nivelDetalle;
	private String nombreUsuario;
	private String nombreInstitucion;
	private String nombreLineaFon;
	private String nombreMoneda;
	private String ParFechaEmision;
	private String comDispos;
	private String ivaComDispos;
	private String saldoRetencion;
	private String fechaACP;
	private String polizaID;

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	// Auxiliares del bean

	private String margenPriCuota;
	private String cobraISR;
	private String tasaISR;
	
	private String pagaIva;
	private String iva;
	private String margenPagIguales;
	private String nombreInstitFon;

	private String saldoCredito;
	private String totalCapital;
	private String totalInteres;
	private String totalComisi;
	private String totalIVACom;
	private String adeudoTotal;
	private String pagoExigible;
	private String montoPagar;
	private String finiquito;	
	private String calculoInteres;
	private String capitalizaInteres;
	private String hora;
	private String pagosParciales;
	private String tipoFondeador;
	private String rutaImagen;
	private String tipoFondeadorCred;
	private String esAgropecuario;
	private String tipoCancelacion;
	private String refinancia;
	private String existeAtraso;
	private String creditoID;
	private String clienteID;
	private String nombreCliente;
	private String folioPagoActivo;
	private long numeroTransaccion;
	private String tipCamFixCom;
	private String tipCamFixVen;
	private String montoPagoMNX;
	private String fechaOperacion;
	private String descripcion;
	private String descripTipMov;
	private String natMovimientoDes;
	private String cantidad;
	private String institutFon;
	
	// Conceptos contables para la póliza
	public static String conceptoPagoCredito = "26"; // Concepto Contable de Cartera: Pago de Credito Pasivo - CONCEPTOSCONTA
	public static String descripcionPagoCredito = "PAGO DE CREDITO PASIVO";


	public String getCreditoFondeoID() {
		return creditoFondeoID;
	}
	public void setCreditoFondeoID(String creditoFondeoID) {
		this.creditoFondeoID = creditoFondeoID;
	}
	public String getLineaFondeoID() {
		return lineaFondeoID;
	}
	public void setLineaFondeoID(String lineaFondeoID) {
		this.lineaFondeoID = lineaFondeoID;
	}
	public String getInstitutFondID() {
		return institutFondID;
	}
	public void setInstitutFondID(String institutFondID) {
		this.institutFondID = institutFondID;
	}
	public String getFolio() {
		return folio;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}
	public String getTipoCalInteres() {
		return tipoCalInteres;
	}
	public void setTipoCalInteres(String tipoCalInteres) {
		this.tipoCalInteres = tipoCalInteres;
	}
	public String getCalcInteresID() {
		return calcInteresID;
	}
	public void setCalcInteresID(String calcInteresID) {
		this.calcInteresID = calcInteresID;
	}
	public String getTasaBase() {
		return tasaBase;
	}
	public void setTasaBase(String tasaBase) {
		this.tasaBase = tasaBase;
	}
	public String getSobreTasa() {
		return sobreTasa;
	}
	public void setSobreTasa(String sobreTasa) {
		this.sobreTasa = sobreTasa;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getPisoTasa() {
		return pisoTasa;
	}
	public void setPisoTasa(String pisoTasa) {
		this.pisoTasa = pisoTasa;
	}
	public String getTechoTasa() {
		return techoTasa;
	}
	public void setTechoTasa(String techoTasa) {
		this.techoTasa = techoTasa;
	}
	public String getFactorMora() {
		return factorMora;
	}
	public void setFactorMora(String factorMora) {
		this.factorMora = factorMora;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencimien() {
		return fechaVencimien;
	}
	public void setFechaVencimien(String fechaVencimien) {
		this.fechaVencimien = fechaVencimien;
	}
	public String getFechaTerminaci() {
		return fechaTerminaci;
	}
	public void setFechaTerminaci(String fechaTerminaci) {
		this.fechaTerminaci = fechaTerminaci;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getSaldoCapVigente() {
		return saldoCapVigente;
	}
	public void setSaldoCapVigente(String saldoCapVigente) {
		this.saldoCapVigente = saldoCapVigente;
	}
	public String getSaldoCapAtrasad() {
		return saldoCapAtrasad;
	}
	public void setSaldoCapAtrasad(String saldoCapAtrasad) {
		this.saldoCapAtrasad = saldoCapAtrasad;
	}
	public String getSaldoInteresAtra() {
		return saldoInteresAtra;
	}
	public void setSaldoInteresAtra(String saldoInteresAtra) {
		this.saldoInteresAtra = saldoInteresAtra;
	}
	public String getSaldoInteres() {
		return saldoInteres;
	}
	public void setSaldoInteres(String saldoInteres) {
		this.saldoInteres = saldoInteres;
	}
	public String getSaldoMoratorio() {
		return saldoMoratorio;
	}
	public void setSaldoMoratorio(String saldoMoratorio) {
		this.saldoMoratorio = saldoMoratorio;
	}
	public String getSaldoIVAMora() {
		return saldoIVAMora;
	}
	public void setSaldoIVAMora(String saldoIVAMora) {
		this.saldoIVAMora = saldoIVAMora;
	}
	public String getSaldoComFaltPag() {
		return saldoComFaltPag;
	}
	public void setSaldoComFaltPag(String saldoComFaltPag) {
		this.saldoComFaltPag = saldoComFaltPag;
	}
	public String getSaldoIVAComFal() {
		return saldoIVAComFal;
	}
	public void setSaldoIVAComFal(String saldoIVAComFal) {
		this.saldoIVAComFal = saldoIVAComFal;
	}
	public String getProvisionAcum() {
		return provisionAcum;
	}
	public void setProvisionAcum(String provisionAcum) {
		this.provisionAcum = provisionAcum;
	}
	public String getTipoPagoCapital() {
		return tipoPagoCapital;
	}
	public void setTipoPagoCapital(String tipoPagoCapital) {
		this.tipoPagoCapital = tipoPagoCapital;
	}
	public String getFrecuenciaCap() {
		return frecuenciaCap;
	}
	public void setFrecuenciaCap(String frecuenciaCap) {
		this.frecuenciaCap = frecuenciaCap;
	}
	public String getPeriodicidadCap() {
		return periodicidadCap;
	}
	public void setPeriodicidadCap(String periodicidadCap) {
		this.periodicidadCap = periodicidadCap;
	}
	public String getNumAmortizacion() {
		return numAmortizacion;
	}
	public void setNumAmortizacion(String numAmortizacion) {
		this.numAmortizacion = numAmortizacion;
	}
	public String getFrecuenciaInt() {
		return frecuenciaInt;
	}
	public void setFrecuenciaInt(String frecuenciaInt) {
		this.frecuenciaInt = frecuenciaInt;
	}
	public String getPeriodicidadInt() {
		return periodicidadInt;
	}
	public void setPeriodicidadInt(String periodicidadInt) {
		this.periodicidadInt = periodicidadInt;
	}
	public String getNumAmortInteres() {
		return numAmortInteres;
	}
	public void setNumAmortInteres(String numAmortInteres) {
		this.numAmortInteres = numAmortInteres;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public String getFechaInhabil() {
		return fechaInhabil;
	}
	public void setFechaInhabil(String fechaInhabil) {
		this.fechaInhabil = fechaInhabil;
	}
	public String getCalendIrregular() {
		return calendIrregular;
	}
	public void setCalendIrregular(String calendIrregular) {
		this.calendIrregular = calendIrregular;
	}
	public String getDiaPagoInteres() {
		return diaPagoInteres;
	}
	public void setDiaPagoInteres(String diaPagoInteres) {
		this.diaPagoInteres = diaPagoInteres;
	}
	public String getDiaPagoCapital() {
		return diaPagoCapital;
	}
	public void setDiaPagoCapital(String diaPagoCapital) {
		this.diaPagoCapital = diaPagoCapital;
	}
	public String getDiaMesInteres() {
		return diaMesInteres;
	}
	public void setDiaMesInteres(String diaMesInteres) {
		this.diaMesInteres = diaMesInteres;
	}
	public String getDiaMesCapital() {
		return diaMesCapital;
	}
	public void setDiaMesCapital(String diaMesCapital) {
		this.diaMesCapital = diaMesCapital;
	}
	public String getAjusFecUlVenAmo() {
		return ajusFecUlVenAmo;
	}
	public void setAjusFecUlVenAmo(String ajusFecUlVenAmo) {
		this.ajusFecUlVenAmo = ajusFecUlVenAmo;
	}
	public String getAjusFecExiVen() {
		return ajusFecExiVen;
	}
	public void setAjusFecExiVen(String ajusFecExiVen) {
		this.ajusFecExiVen = ajusFecExiVen;
	}
	public String getNumTransacSim() {
		return numTransacSim;
	}
	public void setNumTransacSim(String numTransacSim) {
		this.numTransacSim = numTransacSim;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public String getFechaContable() {
		return fechaContable;
	}
	public void setFechaContable(String fechaContable) {
		this.fechaContable = fechaContable;
	}
	public String getPlazoContable() {
		return plazoContable;
	}
	public void setPlazoContable(String plazoContable) {
		this.plazoContable = plazoContable;
	}
	public String getTipoInstitID() {
		return tipoInstitID;
	}
	public void setTipoInstitID(String tipoInstitID) {
		this.tipoInstitID = tipoInstitID;
	}
	public String getNacionalidadIns() {
		return nacionalidadIns;
	}
	public void setNacionalidadIns(String nacionalidadIns) {
		this.nacionalidadIns = nacionalidadIns;
	}
	public String getSaldoIVAInteres() {
		return saldoIVAInteres;
	}
	public void setSaldoIVAInteres(String saldoIVAInteres) {
		this.saldoIVAInteres = saldoIVAInteres;
	}
	public String getSaldoOtrasComis() {
		return saldoOtrasComis;
	}
	public void setSaldoOtrasComis(String saldoOtrasComis) {
		this.saldoOtrasComis = saldoOtrasComis;
	}
	public String getSaldoIVAComisi() {
		return saldoIVAComisi;
	}
	public void setSaldoIVAComisi(String saldoIVAComisi) {
		this.saldoIVAComisi = saldoIVAComisi;
	}
	public String getPorcentanjeIVA() {
		return porcentanjeIVA;
	}
	public void setPorcentanjeIVA(String porcentanjeIVA) {
		this.porcentanjeIVA = porcentanjeIVA;
	}
	public String getFechaEmision() {
		return FechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		FechaEmision = fechaEmision;
	}
	public String getNivelDetalle() {
		return nivelDetalle;
	}
	public void setNivelDetalle(String nivelDetalle) {
		this.nivelDetalle = nivelDetalle;
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
	public String getNombreLineaFon() {
		return nombreLineaFon;
	}
	public void setNombreLineaFon(String nombreLineaFon) {
		this.nombreLineaFon = nombreLineaFon;
	}
	public String getNombreMoneda() {
		return nombreMoneda;
	}
	public void setNombreMoneda(String nombreMoneda) {
		this.nombreMoneda = nombreMoneda;
	}
	public String getParFechaEmision() {
		return ParFechaEmision;
	}
	public void setParFechaEmision(String parFechaEmision) {
		ParFechaEmision = parFechaEmision;
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
	public String getPagaIva() {
		return pagaIva;
	}
	public void setPagaIva(String pagaIva) {
		this.pagaIva = pagaIva;
	}
	public String getIva() {
		return iva;
	}
	public void setIva(String iva) {
		this.iva = iva;
	}
	public String getMargenPagIguales() {
		return margenPagIguales;
	}
	public void setMargenPagIguales(String margenPagIguales) {
		this.margenPagIguales = margenPagIguales;
	}
	public String getNombreInstitFon() {
		return nombreInstitFon;
	}
	public void setNombreInstitFon(String nombreInstitFon) {
		this.nombreInstitFon = nombreInstitFon;
	}
	public String getSaldoCredito() {
		return saldoCredito;
	}
	public void setSaldoCredito(String saldoCredito) {
		this.saldoCredito = saldoCredito;
	}
	public String getTotalCapital() {
		return totalCapital;
	}
	public void setTotalCapital(String totalCapital) {
		this.totalCapital = totalCapital;
	}
	public String getTotalInteres() {
		return totalInteres;
	}
	public void setTotalInteres(String totalInteres) {
		this.totalInteres = totalInteres;
	}
	public String getTotalComisi() {
		return totalComisi;
	}
	public void setTotalComisi(String totalComisi) {
		this.totalComisi = totalComisi;
	}
	public String getTotalIVACom() {
		return totalIVACom;
	}
	public void setTotalIVACom(String totalIVACom) {
		this.totalIVACom = totalIVACom;
	}
	public String getAdeudoTotal() {
		return adeudoTotal;
	}
	public void setAdeudoTotal(String adeudoTotal) {
		this.adeudoTotal = adeudoTotal;
	}
	public String getMontoPagar() {
		return montoPagar;
	}
	public void setMontoPagar(String montoPagar) {
		this.montoPagar = montoPagar;
	}
	public String getPagoExigible() {
		return pagoExigible;
	}
	public void setPagoExigible(String pagoExigible) {
		this.pagoExigible = pagoExigible;
	}
	public String getFiniquito() {
		return finiquito;
	}
	public void setFiniquito(String finiquito) {
		this.finiquito = finiquito;
	}
	public String getComDispos() {
		return comDispos;
	}
	public void setComDispos(String comDispos) {
		this.comDispos = comDispos;
	}
	public String getIvaComDispos() {
		return ivaComDispos;
	}
	public void setIvaComDispos(String ivaComDispos) {
		this.ivaComDispos = ivaComDispos;
	}
	public String getCobraISR() {
		return cobraISR;
	}
	public void setCobraISR(String cobraISR) {
		this.cobraISR = cobraISR;
	}
	public String getTasaISR() {
		return tasaISR;
	}
	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}
	public String getMargenPriCuota() {
		return margenPriCuota;
	}
	public void setMargenPriCuota(String margenPriCuota) {
		this.margenPriCuota = margenPriCuota;
	}
	public String getSaldoRetencion() {
		return saldoRetencion;
	}
	public void setSaldoRetencion(String saldoRetencion) {
		this.saldoRetencion = saldoRetencion;
	}	
	public String getCalculoInteres() {
		return calculoInteres;
	}
	public void setCalculoInteres(String calculoInteres) {
		this.calculoInteres = calculoInteres;
	}
	public String getFechaACP() {
		return fechaACP;
	}
	public void setFechaACP(String fechaACP) {
		this.fechaACP = fechaACP;
	}
	public String getCapitalizaInteres() {
		return capitalizaInteres;
	}
	public void setCapitalizaInteres(String capitalizaInteres) {
		this.capitalizaInteres = capitalizaInteres;
	}
	public String getPagosParciales() {
		return pagosParciales;
	}
	public void setPagosParciales(String pagosParciales) {
		this.pagosParciales = pagosParciales;
	}
	public String getTipoFondeador() {
		return tipoFondeador;
	}
	public void setTipoFondeador(String tipoFondeador) {
		this.tipoFondeador = tipoFondeador;
	}
	public String getRutaImagen() {
		return rutaImagen;
	}
	public void setRutaImagen(String rutaImagen) {
		this.rutaImagen = rutaImagen;
	}
	public String getTipoFondeadorCred() {
		return tipoFondeadorCred;
	}
	public void setTipoFondeadorCred(String tipoFondeadorCred) {
		this.tipoFondeadorCred = tipoFondeadorCred;
	}
	public String getEsAgropecuario() {
		return esAgropecuario;
	}
	public void setEsAgropecuario(String esAgropecuario) {
		this.esAgropecuario = esAgropecuario;
	}
	public String getTipoCancelacion() {
		return tipoCancelacion;
	}
	public void setTipoCancelacion(String tipoCancelacion) {
		this.tipoCancelacion = tipoCancelacion;
	}
	public String getRefinancia() {
		return refinancia;
	}
	public void setRefinancia(String refinancia) {
		this.refinancia = refinancia;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getExisteAtraso() {
		return existeAtraso;
	}
	public void setExisteAtraso(String existeAtraso) {
		this.existeAtraso = existeAtraso;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
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
	public String getFolioPagoActivo() {
		return folioPagoActivo;
	}
	public void setFolioPagoActivo(String folioPagoActivo) {
		this.folioPagoActivo = folioPagoActivo;
	}
	public long getNumeroTransaccion() {
		return numeroTransaccion;
	}
	public void setNumeroTransaccion(long numeroTransaccion) {
		this.numeroTransaccion = numeroTransaccion;
	}
	public String getTipCamFixCom() {
		return tipCamFixCom;
	}
	public void setTipCamFixCom(String tipCamFixCom) {
		this.tipCamFixCom = tipCamFixCom;
	}
	public String getTipCamFixVen() {
		return tipCamFixVen;
	}
	public void setTipCamFixVen(String tipCamFixVen) {
		this.tipCamFixVen = tipCamFixVen;
	}
	public String getMontoPagoMNX() {
		return montoPagoMNX;
	}
	public void setMontoPagoMNX(String montoPagoMNX) {
		this.montoPagoMNX = montoPagoMNX;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescripTipMov() {
		return descripTipMov;
	}
	public void setDescripTipMov(String descripTipMov) {
		this.descripTipMov = descripTipMov;
	}
	public String getNatMovimientoDes() {
		return natMovimientoDes;
	}
	public void setNatMovimientoDes(String natMovimientoDes) {
		this.natMovimientoDes = natMovimientoDes;
	}
	public String getCantidad() {
		return cantidad;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public String getInstitutFon() {
		return institutFon;
	}
	public void setInstitutFon(String institutFon) {
		this.institutFon = institutFon;
	}
	
}