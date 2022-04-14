package aportaciones.bean;

import general.bean.BaseBean;

public class AportacionesBean extends BaseBean {

	private String aportacionID;
	private String clienteID;
	private String cuentaAhoID;
	private String tipoAportacionID;
	private String fechaInicio;
	private String fechaVencimiento;
	private String pisoTasa;
	private String techoTasa;
	private String monto;
	private String monedaID;
	private String plazo;
	private String plazoOriginal;
	private String tasa;
	private String tasaBruta;
	private String tasaISR;
	private String tasaNeta;
	private String interesGenerado;
	private String interesRecibir;
	private String interesRetener;
	private String fechaVenAnt;
	private String nombreCliente;
	private String estatus;
	private String usuarioID;
	private String estatusImpresion;
	private String etiqueta;
	private String valorGat; // para nuevo campo en la pantalla donde se calcula
								// el Gasto Anual Total para pantalla
								// aperturaInversion.jsp
	private String valorGatReal;
	private String nombreCompleto;
	private String reinvertir;
	private String desReinvertir;
	private String cajaRetiro;

	private String sucursalID;
	private String nombreUsuario;
	private String nombreInstitucion;
	private String descripcionTipoInv;
	private String nombreMoneda;
	private String nombreSucursal;
	private String fechaActual;

	private String usuarioAutorizaID;
	private String contraseniaUsuarioAutoriza;
	private String diasTrans;
	private String saldoProvision;
	private String tipoInversion;
	private String descripcion;
	private String fechaFin;
	private String tasaFija;
	private String tasaBase;
	private String sobreTasa;
	private String tipoPagoInt;
	private String diasPeriodo;
	private String pagoIntCal;

	private String totalCapital;
	private String totalInteres;
	private String totalISR;
	private String totalFinal;
	private String numAportaciones;

	private String tasaBaseID;
	private String segmentacion;
	private String relaciones;
	private String productoSAFI;

	// Autorización de Aportaciones
	private String direccion;
	private String telefono;
	private String saldoCuenta;
	private String totalRecibir;
	private String calculoInteres;

	private String direccionInstit;
	private String desCalculoInteres;

	/* Simulador */
	private String numTran;
	private String consecutivo;
	private String fecha;
	private String fechaPago;
	private String capital;
	private String interes;
	private String isr;
	private String total;

	// Auxiliares para reporte
	private String promotorID;
	private String fechaEmision;
	private String fechaApertura;
	private String finalDate;
	private String estatusAportacion;

	private String reinversion;
	private String montosAnclados;
	private String interesesAnclados;
	private String aportacionMadreID;
	private String polizaID;
	private String nuevaTasa;
	private String nombrePromotor;
	private String desEstatus;
	private String desTasaBase;
	private String desTipoAportacion;
	private String formulaInteres;
	private String cuentaDestinoUNO;
	private String cuentaDestinoDOS;
	private String cuentaDestinoTRES;
	private String institucionUNO;
	private String institucionDOS;
	private String institucionTRES;
	

	// CalculoPatrimonial
	private String contrato;
	private String constancia;
	private String tipoPersona;
	private String inicioPeriodo;
	private String finPeriodo;

	private String interesesPeriodo;
	private String porcentajeISR;
	private String isrPeriodo;
	private String promedio;

	private String intAcuPeriodoAnt;
	private String intTotalesAcu;
	private String isrTotalAcu;
	private String diasPlazo;
	private String clientesAct;

	private String montoInverCierre;
	private String interesesDeven;
	private String inteMontoInver;
	private String interesesPagados;
	private String inteDevenxPag;

	private String tipoReporte;
	private String iniPerReporte;
	private String finPerReporte;
	private String estatusISR;
	private String comentarios;
	private String desComentarios;
	private String maxPuntos;
	private String minPuntos;
	private String perfilAutoriza;
	private String aportRenovada;
	private String montoGlobal;
	private String tasaMontoGlobal;
	private String incluyeGpoFam;
	private String diasPagoInt;
	private String capitaliza;
	private String opcionAport;
	private String descOpcionaport;
	private String cantidadReno;
	private String invRenovar;
	private String notas;
	private String saldoCapital;
	private String aperturaAport;
	private String motivoCancela;
	
	// CONDICIONES VENCIMIENTO
	private String isrRetener;
	private String reinversionAutom;
	private String montoRenovNuevaAport;
	private String montoNuevaAport;
	private String tipoPagoNuevaAport;
	private String diaPagoNuevaAport;
	private String plazoNuevaAport;
	private String plazoOriginalNuevaAport;
	private String fechaInicioNuevaAport;
	private String fechaVencimNuevaAport;
	private String tasaISRNuevaAport;
	private String tasaNetaNuevaAport;
	private String gatNominalNuevaAport;
	private String gatRealNuevaAport;
	
	private String capitalizaNuevaAport;
	private String interesGenNuevaAport;
	private String isrRetenerNuevaAport;
	private String intRecibirNuevaAport;
	private String notasNuevaAport;
	private String especificacionesNuevaAport;
	private String montoGlobalNuevaAport;
	private String totRecibirNuevaAport;
	private String tasaBrutaNuevaAport;
	private String fechaAlta; 
	private String consolidarSaldos;
	private String aportConsolID;
	private String reinvertirC;
	private String reinvertirCI;
	private String detalle;

	//AUX CONDICIONES VENCIMIENTO
	private String existe;
	
	// REPORTE RENOVACION
	private String fechaInicial;
	private String fechaFinal;
	private String descEstatus;
	private String claveUsuario;
	private String fechaSistema;
	private String motivo;
	
	// NUEVAS VARIABLES
	private String fechaPrevencimiento;
	private String plazoReal;
	private String montoLiqAporAnterior;
	private String interesesProvIncremRenov;
	private String dineroNuevo;
	private String intPagadosPeriodo;
	private String intDevNoPagadoPeriodo;
	private String intDevPeriodo;
	private String intDevMes;
	private String montoRenovado;
	private String especificaciones;
	
	private int numReporte;
	
	
	private String tipoDocumento;
	private String cantidad;
	private String tipoDocReno;
	private String totalReno;
	private String tipoInteres;
	private String condiciones;
	
	private String tipoRenovacion;
	
	public final String conceptoAperturaAPORT 		= "601"; //APERTURA DE APORTACIÓN TABLA DE TIPOSMOVSAHO
	public final String conceptoMovAPORT 			= "900";
	public final String descripcionMovAPORT 		= "APERTURA DE APORTACION";
	public final String concAhorroAportacionCap		= "1";

	public final String conceptoCancelaAPORT 		= "608"; //CANCELACION DE APORT DE TIPOSMOVSAHO
	public final String conceptoMovCanAPORT 		= "910";
	public final String descripcionMovCanAPORT 		= "CANCELACION DE APORTACION";
	public final String concAhorroCanAportacionCapi	= "1";
	
	public final String concVenAntAportacion 		= "911";  // CANCELACION APORT
	public final String descVenAntAportacion 		= "VENCIMIENTO ANTICIPADO APORTACION";
	
	

	public String getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public String getCantidad() {
		return cantidad;
	}

	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}

	public String getTipoDocReno() {
		return tipoDocReno;
	}

	public void setTipoDocReno(String tipoDocReno) {
		this.tipoDocReno = tipoDocReno;
	}

	public String getTotalReno() {
		return totalReno;
	}

	public void setTotalReno(String totalReno) {
		this.totalReno = totalReno;
	}

	public String getTipoInteres() {
		return tipoInteres;
	}

	public void setTipoInteres(String tipoInteres) {
		this.tipoInteres = tipoInteres;
	}

	public String getCondiciones() {
		return condiciones;
	}

	public void setCondiciones(String condiciones) {
		this.condiciones = condiciones;
	}

	public String getFechaPrevencimiento() {
		return fechaPrevencimiento;
	}

	public void setFechaPrevencimiento(String fechaPrevencimiento) {
		this.fechaPrevencimiento = fechaPrevencimiento;
	}

	public String getPlazoReal() {
		return plazoReal;
	}

	public void setPlazoReal(String plazoReal) {
		this.plazoReal = plazoReal;
	}

	public String getMontoLiqAporAnterior() {
		return montoLiqAporAnterior;
	}

	public void setMontoLiqAporAnterior(String montoLiqAporAnterior) {
		this.montoLiqAporAnterior = montoLiqAporAnterior;
	}

	public String getInteresesProvIncremRenov() {
		return interesesProvIncremRenov;
	}

	public void setInteresesProvIncremRenov(String interesesProvIncremRenov) {
		this.interesesProvIncremRenov = interesesProvIncremRenov;
	}

	public String getDineroNuevo() {
		return dineroNuevo;
	}

	public void setDineroNuevo(String dineroNuevo) {
		this.dineroNuevo = dineroNuevo;
	}

	public String getIntPagadosPeriodo() {
		return intPagadosPeriodo;
	}

	public void setIntPagadosPeriodo(String intPagadosPeriodo) {
		this.intPagadosPeriodo = intPagadosPeriodo;
	}

	public String getIntDevNoPagadoPeriodo() {
		return intDevNoPagadoPeriodo;
	}

	public void setIntDevNoPagadoPeriodo(String intDevNoPagadoPeriodo) {
		this.intDevNoPagadoPeriodo = intDevNoPagadoPeriodo;
	}

	public String getIntDevPeriodo() {
		return intDevPeriodo;
	}

	public void setIntDevPeriodo(String intDevPeriodo) {
		this.intDevPeriodo = intDevPeriodo;
	}

	public String getIntDevMes() {
		return intDevMes;
	}

	public void setIntDevMes(String intDevMes) {
		this.intDevMes = intDevMes;
	}

	public String getMontoRenovado() {
		return montoRenovado;
	}

	public void setMontoRenovado(String montoRenovado) {
		this.montoRenovado = montoRenovado;
	}

	public String getEspecificaciones() {
		return especificaciones;
	}

	public void setEspecificaciones(String especificaciones) {
		this.especificaciones = especificaciones;
	}

	public String getAportacionID() {
		return aportacionID;
	}

	public void setAportacionID(String aportacionID) {
		this.aportacionID = aportacionID;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}

	public String getTipoAportacionID() {
		return tipoAportacionID;
	}

	public void setTipoAportacionID(String tipoAportacionID) {
		this.tipoAportacionID = tipoAportacionID;
	}

	public String getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public String getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
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

	public String getPlazo() {
		return plazo;
	}

	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}

	public String getPlazoOriginal() {
		return plazoOriginal;
	}

	public void setPlazoOriginal(String plazoOriginal) {
		this.plazoOriginal = plazoOriginal;
	}

	public String getTasa() {
		return tasa;
	}

	public void setTasa(String tasa) {
		this.tasa = tasa;
	}

	public String getTasaBruta() {
		return tasaBruta;
	}

	public void setTasaBruta(String tasaBruta) {
		this.tasaBruta = tasaBruta;
	}

	public String getTasaISR() {
		return tasaISR;
	}

	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}

	public String getTasaNeta() {
		return tasaNeta;
	}

	public void setTasaNeta(String tasaNeta) {
		this.tasaNeta = tasaNeta;
	}

	public String getInteresGenerado() {
		return interesGenerado;
	}

	public void setInteresGenerado(String interesGenerado) {
		this.interesGenerado = interesGenerado;
	}

	public String getInteresRecibir() {
		return interesRecibir;
	}

	public void setInteresRecibir(String interesRecibir) {
		this.interesRecibir = interesRecibir;
	}

	public String getInteresRetener() {
		return interesRetener;
	}

	public void setInteresRetener(String interesRetener) {
		this.interesRetener = interesRetener;
	}

	public String getFechaVenAnt() {
		return fechaVenAnt;
	}

	public void setFechaVenAnt(String fechaVenAnt) {
		this.fechaVenAnt = fechaVenAnt;
	}

	public String getNombreCliente() {
		return nombreCliente;
	}

	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getUsuarioID() {
		return usuarioID;
	}

	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}

	public String getEstatusImpresion() {
		return estatusImpresion;
	}

	public void setEstatusImpresion(String estatusImpresion) {
		this.estatusImpresion = estatusImpresion;
	}

	public String getEtiqueta() {
		return etiqueta;
	}

	public void setEtiqueta(String etiqueta) {
		this.etiqueta = etiqueta;
	}

	public String getValorGat() {
		return valorGat;
	}

	public void setValorGat(String valorGat) {
		this.valorGat = valorGat;
	}

	public String getValorGatReal() {
		return valorGatReal;
	}

	public void setValorGatReal(String valorGatReal) {
		this.valorGatReal = valorGatReal;
	}

	public String getNombreCompleto() {
		return nombreCompleto;
	}

	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	public String getReinvertir() {
		return reinvertir;
	}

	public void setReinvertir(String reinvertir) {
		this.reinvertir = reinvertir;
	}

	public String getDesReinvertir() {
		return desReinvertir;
	}

	public void setDesReinvertir(String desReinvertir) {
		this.desReinvertir = desReinvertir;
	}

	public String getCajaRetiro() {
		return cajaRetiro;
	}

	public void setCajaRetiro(String cajaRetiro) {
		this.cajaRetiro = cajaRetiro;
	}

	public String getSucursalID() {
		return sucursalID;
	}

	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
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

	public String getDescripcionTipoInv() {
		return descripcionTipoInv;
	}

	public void setDescripcionTipoInv(String descripcionTipoInv) {
		this.descripcionTipoInv = descripcionTipoInv;
	}

	public String getNombreMoneda() {
		return nombreMoneda;
	}

	public void setNombreMoneda(String nombreMoneda) {
		this.nombreMoneda = nombreMoneda;
	}

	public String getNombreSucursal() {
		return nombreSucursal;
	}

	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}

	public String getFechaActual() {
		return fechaActual;
	}

	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}

	public String getUsuarioAutorizaID() {
		return usuarioAutorizaID;
	}

	public void setUsuarioAutorizaID(String usuarioAutorizaID) {
		this.usuarioAutorizaID = usuarioAutorizaID;
	}

	public String getContraseniaUsuarioAutoriza() {
		return contraseniaUsuarioAutoriza;
	}

	public void setContraseniaUsuarioAutoriza(String contraseniaUsuarioAutoriza) {
		this.contraseniaUsuarioAutoriza = contraseniaUsuarioAutoriza;
	}

	public String getDiasTrans() {
		return diasTrans;
	}

	public void setDiasTrans(String diasTrans) {
		this.diasTrans = diasTrans;
	}

	public String getSaldoProvision() {
		return saldoProvision;
	}

	public void setSaldoProvision(String saldoProvision) {
		this.saldoProvision = saldoProvision;
	}

	public String getTipoInversion() {
		return tipoInversion;
	}

	public void setTipoInversion(String tipoInversion) {
		this.tipoInversion = tipoInversion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}

	public String getTasaFija() {
		return tasaFija;
	}

	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
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

	public String getTipoPagoInt() {
		return tipoPagoInt;
	}

	public void setTipoPagoInt(String tipoPagoInt) {
		this.tipoPagoInt = tipoPagoInt;
	}

	public String getDiasPeriodo() {
		return diasPeriodo;
	}

	public void setDiasPeriodo(String diasPeriodo) {
		this.diasPeriodo = diasPeriodo;
	}

	public String getPagoIntCal() {
		return pagoIntCal;
	}

	public void setPagoIntCal(String pagoIntCal) {
		this.pagoIntCal = pagoIntCal;
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

	public String getTotalISR() {
		return totalISR;
	}

	public void setTotalISR(String totalISR) {
		this.totalISR = totalISR;
	}

	public String getTotalFinal() {
		return totalFinal;
	}

	public void setTotalFinal(String totalFinal) {
		this.totalFinal = totalFinal;
	}

	public String getNumAportaciones() {
		return numAportaciones;
	}

	public void setNumAportaciones(String numAportaciones) {
		this.numAportaciones = numAportaciones;
	}

	public String getTasaBaseID() {
		return tasaBaseID;
	}

	public void setTasaBaseID(String tasaBaseID) {
		this.tasaBaseID = tasaBaseID;
	}

	public String getSegmentacion() {
		return segmentacion;
	}

	public void setSegmentacion(String segmentacion) {
		this.segmentacion = segmentacion;
	}

	public String getRelaciones() {
		return relaciones;
	}

	public void setRelaciones(String relaciones) {
		this.relaciones = relaciones;
	}

	public String getProductoSAFI() {
		return productoSAFI;
	}

	public void setProductoSAFI(String productoSAFI) {
		this.productoSAFI = productoSAFI;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getSaldoCuenta() {
		return saldoCuenta;
	}

	public void setSaldoCuenta(String saldoCuenta) {
		this.saldoCuenta = saldoCuenta;
	}

	public String getTotalRecibir() {
		return totalRecibir;
	}

	public void setTotalRecibir(String totalRecibir) {
		this.totalRecibir = totalRecibir;
	}

	public String getCalculoInteres() {
		return calculoInteres;
	}

	public void setCalculoInteres(String calculoInteres) {
		this.calculoInteres = calculoInteres;
	}

	public String getDireccionInstit() {
		return direccionInstit;
	}

	public void setDireccionInstit(String direccionInstit) {
		this.direccionInstit = direccionInstit;
	}

	public String getDesCalculoInteres() {
		return desCalculoInteres;
	}

	public void setDesCalculoInteres(String desCalculoInteres) {
		this.desCalculoInteres = desCalculoInteres;
	}

	public String getNumTran() {
		return numTran;
	}

	public void setNumTran(String numTran) {
		this.numTran = numTran;
	}

	public String getConsecutivo() {
		return consecutivo;
	}

	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getFechaPago() {
		return fechaPago;
	}

	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
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

	public String getIsr() {
		return isr;
	}

	public void setIsr(String isr) {
		this.isr = isr;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}

	public String getPromotorID() {
		return promotorID;
	}

	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}

	public String getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public String getFechaApertura() {
		return fechaApertura;
	}

	public void setFechaApertura(String fechaApertura) {
		this.fechaApertura = fechaApertura;
	}

	public String getReinversion() {
		return reinversion;
	}

	public void setReinversion(String reinversion) {
		this.reinversion = reinversion;
	}

	public String getMontosAnclados() {
		return montosAnclados;
	}

	public void setMontosAnclados(String montosAnclados) {
		this.montosAnclados = montosAnclados;
	}

	public String getInteresesAnclados() {
		return interesesAnclados;
	}

	public void setInteresesAnclados(String interesesAnclados) {
		this.interesesAnclados = interesesAnclados;
	}

	public String getAportacionMadreID() {
		return aportacionMadreID;
	}

	public void setAportacionMadreID(String aportacionMadreID) {
		this.aportacionMadreID = aportacionMadreID;
	}

	public String getPolizaID() {
		return polizaID;
	}

	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}

	public String getNuevaTasa() {
		return nuevaTasa;
	}

	public void setNuevaTasa(String nuevaTasa) {
		this.nuevaTasa = nuevaTasa;
	}

	public String getNombrePromotor() {
		return nombrePromotor;
	}

	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}

	public String getDesEstatus() {
		return desEstatus;
	}

	public void setDesEstatus(String desEstatus) {
		this.desEstatus = desEstatus;
	}

	public String getDesTasaBase() {
		return desTasaBase;
	}

	public void setDesTasaBase(String desTasaBase) {
		this.desTasaBase = desTasaBase;
	}

	public String getDesTipoAportacion() {
		return desTipoAportacion;
	}

	public void setDesTipoAportacion(String desTipoAportacion) {
		this.desTipoAportacion = desTipoAportacion;
	}

	public String getFormulaInteres() {
		return formulaInteres;
	}

	public void setFormulaInteres(String formulaInteres) {
		this.formulaInteres = formulaInteres;
	}

	public String getContrato() {
		return contrato;
	}

	public void setContrato(String contrato) {
		this.contrato = contrato;
	}

	public String getConstancia() {
		return constancia;
	}

	public void setConstancia(String constancia) {
		this.constancia = constancia;
	}

	public String getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public String getInicioPeriodo() {
		return inicioPeriodo;
	}

	public void setInicioPeriodo(String inicioPeriodo) {
		this.inicioPeriodo = inicioPeriodo;
	}

	public String getFinPeriodo() {
		return finPeriodo;
	}

	public void setFinPeriodo(String finPeriodo) {
		this.finPeriodo = finPeriodo;
	}

	public String getInteresesPeriodo() {
		return interesesPeriodo;
	}

	public void setInteresesPeriodo(String interesesPeriodo) {
		this.interesesPeriodo = interesesPeriodo;
	}

	public String getPorcentajeISR() {
		return porcentajeISR;
	}

	public void setPorcentajeISR(String porcentajeISR) {
		this.porcentajeISR = porcentajeISR;
	}

	public String getIsrPeriodo() {
		return isrPeriodo;
	}

	public void setIsrPeriodo(String isrPeriodo) {
		this.isrPeriodo = isrPeriodo;
	}

	public String getPromedio() {
		return promedio;
	}

	public void setPromedio(String promedio) {
		this.promedio = promedio;
	}

	public String getIntAcuPeriodoAnt() {
		return intAcuPeriodoAnt;
	}

	public void setIntAcuPeriodoAnt(String intAcuPeriodoAnt) {
		this.intAcuPeriodoAnt = intAcuPeriodoAnt;
	}

	public String getIntTotalesAcu() {
		return intTotalesAcu;
	}

	public void setIntTotalesAcu(String intTotalesAcu) {
		this.intTotalesAcu = intTotalesAcu;
	}

	public String getIsrTotalAcu() {
		return isrTotalAcu;
	}

	public void setIsrTotalAcu(String isrTotalAcu) {
		this.isrTotalAcu = isrTotalAcu;
	}

	public String getDiasPlazo() {
		return diasPlazo;
	}

	public void setDiasPlazo(String diasPlazo) {
		this.diasPlazo = diasPlazo;
	}

	public String getClientesAct() {
		return clientesAct;
	}

	public void setClientesAct(String clientesAct) {
		this.clientesAct = clientesAct;
	}

	public String getMontoInverCierre() {
		return montoInverCierre;
	}

	public void setMontoInverCierre(String montoInverCierre) {
		this.montoInverCierre = montoInverCierre;
	}

	public String getInteresesDeven() {
		return interesesDeven;
	}

	public void setInteresesDeven(String interesesDeven) {
		this.interesesDeven = interesesDeven;
	}

	public String getInteMontoInver() {
		return inteMontoInver;
	}

	public void setInteMontoInver(String inteMontoInver) {
		this.inteMontoInver = inteMontoInver;
	}

	public String getInteresesPagados() {
		return interesesPagados;
	}

	public void setInteresesPagados(String interesesPagados) {
		this.interesesPagados = interesesPagados;
	}

	public String getInteDevenxPag() {
		return inteDevenxPag;
	}

	public void setInteDevenxPag(String inteDevenxPag) {
		this.inteDevenxPag = inteDevenxPag;
	}

	public String getTipoReporte() {
		return tipoReporte;
	}

	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}

	public String getIniPerReporte() {
		return iniPerReporte;
	}

	public void setIniPerReporte(String iniPerReporte) {
		this.iniPerReporte = iniPerReporte;
	}

	public String getFinPerReporte() {
		return finPerReporte;
	}

	public void setFinPerReporte(String finPerReporte) {
		this.finPerReporte = finPerReporte;
	}

	public String getEstatusISR() {
		return estatusISR;
	}

	public void setEstatusISR(String estatusISR) {
		this.estatusISR = estatusISR;
	}

	public String getComentarios() {
		return comentarios;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}

	public String getDesComentarios() {
		return desComentarios;
	}

	public void setDesComentarios(String desComentarios) {
		this.desComentarios = desComentarios;
	}

	public String getMaxPuntos() {
		return maxPuntos;
	}

	public void setMaxPuntos(String maxPuntos) {
		this.maxPuntos = maxPuntos;
	}

	public String getMinPuntos() {
		return minPuntos;
	}

	public void setMinPuntos(String minPuntos) {
		this.minPuntos = minPuntos;
	}

	public String getPerfilAutoriza() {
		return perfilAutoriza;
	}

	public void setPerfilAutoriza(String perfilAutoriza) {
		this.perfilAutoriza = perfilAutoriza;
	}

	public String getAportRenovada() {
		return aportRenovada;
	}

	public void setAportRenovada(String aportRenovada) {
		this.aportRenovada = aportRenovada;
	}

	public String getMontoGlobal() {
		return montoGlobal;
	}

	public void setMontoGlobal(String montoGlobal) {
		this.montoGlobal = montoGlobal;
	}

	public String getTasaMontoGlobal() {
		return tasaMontoGlobal;
	}

	public void setTasaMontoGlobal(String tasaMontoGlobal) {
		this.tasaMontoGlobal = tasaMontoGlobal;
	}

	public String getIncluyeGpoFam() {
		return incluyeGpoFam;
	}

	public void setIncluyeGpoFam(String incluyeGpoFam) {
		this.incluyeGpoFam = incluyeGpoFam;
	}
	
	public String getDiasPagoInt() {
		return diasPagoInt;
	}

	public void setDiasPagoInt(String diasPagoInt) {
		this.diasPagoInt = diasPagoInt;
	}

	public String getCapitaliza() {
		return capitaliza;
	}

	public void setCapitaliza(String capitaliza) {
		this.capitaliza = capitaliza;
	}

	public String getOpcionAport() {
		return opcionAport;
	}

	public void setOpcionAport(String opcionAport) {
		this.opcionAport = opcionAport;
	}

	public String getCantidadReno() {
		return cantidadReno;
	}

	public void setCantidadReno(String cantidadReno) {
		this.cantidadReno = cantidadReno;
	}

	public String getInvRenovar() {
		return invRenovar;
	}

	public void setInvRenovar(String invRenovar) {
		this.invRenovar = invRenovar;
	}

	public String getNotas() {
		return notas;
	}

	public void setNotas(String notas) {
		this.notas = notas;
	}

	public String getSaldoCapital() {
		return saldoCapital;
	}

	public void setSaldoCapital(String saldoCapital) {
		this.saldoCapital = saldoCapital;
	}

	public String getAperturaAport() {
		return aperturaAport;
	}

	public void setAperturaAport(String aperturaAport) {
		this.aperturaAport = aperturaAport;
	}

	public String getMotivoCancela() {
		return motivoCancela;
	}

	public void setMotivoCancela(String motivoCancela) {
		this.motivoCancela = motivoCancela;
	}

	public String getDescOpcionaport() {
		return descOpcionaport;
	}

	public void setDescOpcionaport(String descOpcionaport) {
		this.descOpcionaport = descOpcionaport;
	}	
	
	public String getIsrRetener() {
		return isrRetener;
	}

	public void setIsrRetener(String isrRetener) {
		this.isrRetener = isrRetener;
	}

	public String getReinversionAutom() {
		return reinversionAutom;
	}

	public void setReinversionAutom(String reinversionAutom) {
		this.reinversionAutom = reinversionAutom;
	}

	public String getMontoRenovNuevaAport() {
		return montoRenovNuevaAport;
	}

	public void setMontoRenovNuevaAport(String montoRenovNuevaAport) {
		this.montoRenovNuevaAport = montoRenovNuevaAport;
	}

	public String getMontoNuevaAport() {
		return montoNuevaAport;
	}

	public void setMontoNuevaAport(String montoNuevaAport) {
		this.montoNuevaAport = montoNuevaAport;
	}

	public String getTipoPagoNuevaAport() {
		return tipoPagoNuevaAport;
	}

	public void setTipoPagoNuevaAport(String tipoPagoNuevaAport) {
		this.tipoPagoNuevaAport = tipoPagoNuevaAport;
	}

	public String getDiaPagoNuevaAport() {
		return diaPagoNuevaAport;
	}

	public void setDiaPagoNuevaAport(String diaPagoNuevaAport) {
		this.diaPagoNuevaAport = diaPagoNuevaAport;
	}

	public String getPlazoNuevaAport() {
		return plazoNuevaAport;
	}

	public void setPlazoNuevaAport(String plazoNuevaAport) {
		this.plazoNuevaAport = plazoNuevaAport;
	}	

	public String getPlazoOriginalNuevaAport() {
		return plazoOriginalNuevaAport;
	}

	public void setPlazoOriginalNuevaAport(String plazoOriginalNuevaAport) {
		this.plazoOriginalNuevaAport = plazoOriginalNuevaAport;
	}

	public String getFechaInicioNuevaAport() {
		return fechaInicioNuevaAport;
	}

	public void setFechaInicioNuevaAport(String fechaInicioNuevaAport) {
		this.fechaInicioNuevaAport = fechaInicioNuevaAport;
	}

	public String getFechaVencimNuevaAport() {
		return fechaVencimNuevaAport;
	}

	public void setFechaVencimNuevaAport(String fechaVencimNuevaAport) {
		this.fechaVencimNuevaAport = fechaVencimNuevaAport;
	}

	public String getTasaISRNuevaAport() {
		return tasaISRNuevaAport;
	}

	public void setTasaISRNuevaAport(String tasaISRNuevaAport) {
		this.tasaISRNuevaAport = tasaISRNuevaAport;
	}
	
	public String getTasaNetaNuevaAport() {
		return tasaNetaNuevaAport;
	}

	public void setTasaNetaNuevaAport(String tasaNetaNuevaAport) {
		this.tasaNetaNuevaAport = tasaNetaNuevaAport;
	}

	public String getGatNominalNuevaAport() {
		return gatNominalNuevaAport;
	}

	public void setGatNominalNuevaAport(String gatNominalNuevaAport) {
		this.gatNominalNuevaAport = gatNominalNuevaAport;
	}

	public String getGatRealNuevaAport() {
		return gatRealNuevaAport;
	}

	public void setGatRealNuevaAport(String gatRealNuevaAport) {
		this.gatRealNuevaAport = gatRealNuevaAport;
	}

	public String getCapitalizaNuevaAport() {
		return capitalizaNuevaAport;
	}

	public void setCapitalizaNuevaAport(String capitalizaNuevaAport) {
		this.capitalizaNuevaAport = capitalizaNuevaAport;
	}

	public String getInteresGenNuevaAport() {
		return interesGenNuevaAport;
	}

	public void setInteresGenNuevaAport(String interesGenNuevaAport) {
		this.interesGenNuevaAport = interesGenNuevaAport;
	}

	public String getIsrRetenerNuevaAport() {
		return isrRetenerNuevaAport;
	}

	public void setIsrRetenerNuevaAport(String isrRetenerNuevaAport) {
		this.isrRetenerNuevaAport = isrRetenerNuevaAport;
	}

	public String getIntRecibirNuevaAport() {
		return intRecibirNuevaAport;
	}

	public void setIntRecibirNuevaAport(String intRecibirNuevaAport) {
		this.intRecibirNuevaAport = intRecibirNuevaAport;
	}

	public String getNotasNuevaAport() {
		return notasNuevaAport;
	}

	public void setNotasNuevaAport(String notasNuevaAport) {
		this.notasNuevaAport = notasNuevaAport;
	}

	public String getEspecificacionesNuevaAport() {
		return especificacionesNuevaAport;
	}

	public void setEspecificacionesNuevaAport(String especificacionesNuevaAport) {
		this.especificacionesNuevaAport = especificacionesNuevaAport;
	}

	public String getExiste() {
		return existe;
	}

	public void setExiste(String existe) {
		this.existe = existe;
	}

	public String getCuentaDestinoUNO() {
		return cuentaDestinoUNO;
	}

	public void setCuentaDestinoUNO(String cuentaDestinoUNO) {
		this.cuentaDestinoUNO = cuentaDestinoUNO;
	}

	public String getCuentaDestinoDOS() {
		return cuentaDestinoDOS;
	}

	public void setCuentaDestinoDOS(String cuentaDestinoDOS) {
		this.cuentaDestinoDOS = cuentaDestinoDOS;
	}

	public String getCuentaDestinoTRES() {
		return cuentaDestinoTRES;
	}

	public void setCuentaDestinoTRES(String cuentaDestinoTRES) {
		this.cuentaDestinoTRES = cuentaDestinoTRES;
	}

	public String getInstitucionUNO() {
		return institucionUNO;
	}

	public void setInstitucionUNO(String institucionUNO) {
		this.institucionUNO = institucionUNO;
	}

	public String getInstitucionDOS() {
		return institucionDOS;
	}

	public void setInstitucionDOS(String institucionDOS) {
		this.institucionDOS = institucionDOS;
	}

	public String getInstitucionTRES() {
		return institucionTRES;
	}

	public void setInstitucionTRES(String institucionTRES) {
		this.institucionTRES = institucionTRES;
	}

	public String getFechaInicial() {
		return fechaInicial;
	}

	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}

	public String getFechaFinal() {
		return fechaFinal;
	}

	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}

	public String getDescEstatus() {
		return descEstatus;
	}

	public void setDescEstatus(String descEstatus) {
		this.descEstatus = descEstatus;
	}
	
	public String getClaveUsuario() {
		return claveUsuario;
	}

	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}

	public String getFechaSistema() {
		return fechaSistema;
	}

	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public String getMontoGlobalNuevaAport() {
		return montoGlobalNuevaAport;
	}

	public void setMontoGlobalNuevaAport(String montoGlobalNuevaAport) {
		this.montoGlobalNuevaAport = montoGlobalNuevaAport;
	}

	public String getTotRecibirNuevaAport() {
		return totRecibirNuevaAport;
	}

	public void setTotRecibirNuevaAport(String totRecibirNuevaAport) {
		this.totRecibirNuevaAport = totRecibirNuevaAport;
	}

	public String getTasaBrutaNuevaAport() {
		return tasaBrutaNuevaAport;
	}

	public void setTasaBrutaNuevaAport(String tasaBrutaNuevaAport) {
		this.tasaBrutaNuevaAport = tasaBrutaNuevaAport;
	}

	public String getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public String getConsolidarSaldos() {
		return consolidarSaldos;
	}

	public void setConsolidarSaldos(String consolidarSaldos) {
		this.consolidarSaldos = consolidarSaldos;
	}

	public String getAportConsolID() {
		return aportConsolID;
	}

	public void setAportConsolID(String aportConsolID) {
		this.aportConsolID = aportConsolID;
	}

	public String getReinvertirC() {
		return reinvertirC;
	}

	public void setReinvertirC(String reinvertirC) {
		this.reinvertirC = reinvertirC;
	}

	public String getReinvertirCI() {
		return reinvertirCI;
	}

	public void setReinvertirCI(String reinvertirCI) {
		this.reinvertirCI = reinvertirCI;
	}

	public String getDetalle() {
		return detalle;
	}

	public void setDetalle(String detalle) {
		this.detalle = detalle;
	}

	public String getFinalDate() {
		return finalDate;
	}

	public void setFinalDate(String finalDate) {
		this.finalDate = finalDate;
	}

	public String getEstatusAportacion() {
		return estatusAportacion;
	}

	public void setEstatusAportacion(String estatusAportacion) {
		this.estatusAportacion = estatusAportacion;
	}

	public int getNumReporte() {
		return numReporte;
	}

	public void setNumReporte(int numReporte) {
		this.numReporte = numReporte;
	}

	public String getTipoRenovacion() {
		return tipoRenovacion;
	}

	public void setTipoRenovacion(String tipoRenovacion) {
		this.tipoRenovacion = tipoRenovacion;
	}
}