package regulatorios.bean;

import general.bean.BaseBean;

public class DesagregadoCarteraC0451Bean extends BaseBean {

	//Variables o Atributos
	private String fecha;
	private String nombreCompleto;
	private String numeroCliente;
	private String numeroCredito;
	private String tipoPersona;
	private String rfc;
	private String clasifContable;
	private String montoOtorgado;
	private String saldoTotal;
	private String fechaDisposicion;
	private String fechaVencimiento;
	private String formaAmortizacion;
	private String tasaInteres;
	private String interesNoCobrado;
	private String interesVencido;
	private String interesCapitalizado;
	private String situacionCredito;
	private String numeroReestructuras;
	private String califCubierta;
	private String califExpuesta;
	private String estimacionCubierta;
	private String estimacionExpuesta;
	private String estimacionTotal;
	private String porcentajeGarAval;
	private String valorGarantia;
	private String fechaValuaGarantia;
	private String prelacionGarantia;
	private String clienteRelacionado;
	private String claveRelacionado;
	private String diasAtraso;
	private String reciprocidad;
	private String valor;
	
	// Nuevos campos para reporte version 2015
	private String Var_Periodo;
	private String Var_ClaveEntidad;
	private String For_0451;
	private String MunicipioClave;
	private String EstadoClave;
	private String ClienteID;
	private String TipoPersona;
	private String Denominacion;
	private String ApellidoPat;
	private String ApellidoMat;
	private String RFC;
	private String CURP;
	private String Genero;
	private String CreditoID;
	private String ClaveSucursal;
	private String ClasifConta;
	private String ProductoCredito;
	private String FechaDisp;
	private String FechaVencim;
	private String TipoAmorti;
	private String MontoCredito;
	private String PeriodicidadCap;
	private String PeriodicidadInt;
	private String TasaInteres;
	private String FecUltPagoCap;
	private String MonUltPagoCap;
	private String FecUltPagoInt;
	private String MonUltPagoInt;
	private String FecPrimAtraso;
	private String MontoCondona;
	private String FecUltCondona;
	private String NumDiasAtraso;
	private String TipoCredito;
	private String SituacContable;
	private String SalCapital;
	private String SalIntOrdin;
	private String SalIntMora;
	private String SalIntCtaOrden;
	private String SalMoraCtaOrden;
	private String IntereRefinan;
	private String SaldoInsoluto;
	private String TipoRelacion;
	private String TipCarCalifi;
	private String CalifiIndiv;
	private String CalifCubierta;
	private String CalifExpuesta;
	private String ReservaCubierta;
	private String ReservaExpuesta;
	private String EPRCAdiCarVen;
	private String EPRCAdiSIC;
	private String EPRCAdiCNVB;
	private String FecConsultaSIC;
	private String ClaveSIC;
	private String TotGtiaLiquida;
	private String GtiaHipotecaria;
	
	private String formula;
	
	
	/*
	 * Para el Regulatorio SOFIPOS - Alta de Créditos
	 */
	private String periodo;
	private String claveEntidad;

	private String tipoCliente;
	private String nombre;
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String persoJuridica;
	private String grupoRiesgo;
	private String actividadEco;
	private String nacionalidad;
	private String fechaNacimiento;
	private String calle;
	private String numeroExt;
	private String colonia;
	private String codigoPostal;
	private String localidad;
	private String estado;
	private String municipio;
	private String pais;
	private String tipoRelacionado;
	private String numConsultaSIC;
	private String ingresosMes;
	private String tamanioAcred;
	private String idenCreditoCNBV;
	private String idenGrupalCNBV;
	private String fechaOtorga;
	private String tipoAlta;
	private String tipoCartera;
	private String tipoProducto;
	private String destinoCred;
	private String numeroCuenta;
	private String numContrato;
	private String nombreFacto;
	private String rFCFactorado;
	private String montoLineaPes;
	private String montoLineaOri;
	private String fechaMaxima;
	private String fechaVencimien;
	private String formaDisposi;
	private String tasaReferencia;
	private String diferencial;
	private String opeDirencial;
	private String tipoMoneda;
	private String periodoFactura;
	private String comisionAper;
	private String montoComAper;
	private String comisionDispo;
	private String montoComDispo;
	private String valorVivienda;
	private String valoAvaluo;
	private String numeroAvaluo;
	private String LTV;
	private String localidadCred;
	private String municipioCred;
	private String estadoCred;
	private String actividadEcoCred;

	
	
	
	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getNumeroCliente() {
		return numeroCliente;
	}
	public void setNumeroCliente(String numeroCliente) {
		this.numeroCliente = numeroCliente;
	}
	public String getNumeroCredito() {
		return numeroCredito;
	}
	public void setNumeroCredito(String numeroCredito) {
		this.numeroCredito = numeroCredito;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public String getClasifContable() {
		return clasifContable;
	}
	public void setClasifContable(String clasifContable) {
		this.clasifContable = clasifContable;
	}
	public String getMontoOtorgado() {
		return montoOtorgado;
	}
	public void setMontoOtorgado(String montoOtorgado) {
		this.montoOtorgado = montoOtorgado;
	}
	public String getSaldoTotal() {
		return saldoTotal;
	}
	public void setSaldoTotal(String saldoTotal) {
		this.saldoTotal = saldoTotal;
	}
	public String getFechaDisposicion() {
		return fechaDisposicion;
	}
	public void setFechaDisposicion(String fechaDisposicion) {
		this.fechaDisposicion = fechaDisposicion;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getFormaAmortizacion() {
		return formaAmortizacion;
	}
	public void setFormaAmortizacion(String formaAmortizacion) {
		this.formaAmortizacion = formaAmortizacion;
	}
	public String getTasaInteres() {
		return tasaInteres;
	}
	public void setTasaInteres(String tasaInteres) {
		this.tasaInteres = tasaInteres;
	}
	public String getInteresNoCobrado() {
		return interesNoCobrado;
	}
	public void setInteresNoCobrado(String interesNoCobrado) {
		this.interesNoCobrado = interesNoCobrado;
	}
	public String getInteresVencido() {
		return interesVencido;
	}
	public void setInteresVencido(String interesVencido) {
		this.interesVencido = interesVencido;
	}
	public String getInteresCapitalizado() {
		return interesCapitalizado;
	}
	public void setInteresCapitalizado(String interesCapitalizado) {
		this.interesCapitalizado = interesCapitalizado;
	}
	public String getSituacionCredito() {
		return situacionCredito;
	}
	public void setSituacionCredito(String situacionCredito) {
		this.situacionCredito = situacionCredito;
	}
	public String getNumeroReestructuras() {
		return numeroReestructuras;
	}
	public void setNumeroReestructuras(String numeroReestructuras) {
		this.numeroReestructuras = numeroReestructuras;
	}
	public String getCalifCubierta() {
		return califCubierta;
	}
	public void setCalifCubierta(String califCubierta) {
		this.califCubierta = califCubierta;
	}
	public String getCalifExpuesta() {
		return califExpuesta;
	}
	public void setCalifExpuesta(String califExpuesta) {
		this.califExpuesta = califExpuesta;
	}
	public String getEstimacionCubierta() {
		return estimacionCubierta;
	}
	public void setEstimacionCubierta(String estimacionCubierta) {
		this.estimacionCubierta = estimacionCubierta;
	}
	public String getEstimacionExpuesta() {
		return estimacionExpuesta;
	}
	public void setEstimacionExpuesta(String estimacionExpuesta) {
		this.estimacionExpuesta = estimacionExpuesta;
	}
	public String getEstimacionTotal() {
		return estimacionTotal;
	}
	public void setEstimacionTotal(String estimacionTotal) {
		this.estimacionTotal = estimacionTotal;
	}
	public String getPorcentajeGarAval() {
		return porcentajeGarAval;
	}
	public void setPorcentajeGarAval(String porcentajeGarAval) {
		this.porcentajeGarAval = porcentajeGarAval;
	}
	public String getValorGarantia() {
		return valorGarantia;
	}
	public void setValorGarantia(String valorGarantia) {
		this.valorGarantia = valorGarantia;
	}
	public String getFechaValuaGarantia() {
		return fechaValuaGarantia;
	}
	public void setFechaValuaGarantia(String fechaValuaGarantia) {
		this.fechaValuaGarantia = fechaValuaGarantia;
	}
	public String getPrelacionGarantia() {
		return prelacionGarantia;
	}
	public void setPrelacionGarantia(String prelacionGarantia) {
		this.prelacionGarantia = prelacionGarantia;
	}
	public String getClienteRelacionado() {
		return clienteRelacionado;
	}
	public void setClienteRelacionado(String clienteRelacionado) {
		this.clienteRelacionado = clienteRelacionado;
	}
	public String getClaveRelacionado() {
		return claveRelacionado;
	}
	public void setClaveRelacionado(String claveRelacionado) {
		this.claveRelacionado = claveRelacionado;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public String getReciprocidad() {
		return reciprocidad;
	}
	public void setReciprocidad(String reciprocidad) {
		this.reciprocidad = reciprocidad;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	public String getVar_Periodo() {
		return Var_Periodo;
	}
	public void setVar_Periodo(String var_Periodo) {
		Var_Periodo = var_Periodo;
	}
	public String getVar_ClaveEntidad() {
		return Var_ClaveEntidad;
	}
	public void setVar_ClaveEntidad(String var_ClaveEntidad) {
		Var_ClaveEntidad = var_ClaveEntidad;
	}
	public String getFor_0451() {
		return For_0451;
	}
	public void setFor_0451(String for_0451) {
		For_0451 = for_0451;
	}
	public String getMunicipioClave() {
		return MunicipioClave;
	}
	public void setMunicipioClave(String municipioClave) {
		MunicipioClave = municipioClave;
	}
	public String getEstadoClave() {
		return EstadoClave;
	}
	public void setEstadoClave(String estadoClave) {
		EstadoClave = estadoClave;
	}
	public String getClienteID() {
		return ClienteID;
	}
	public void setClienteID(String clienteID) {
		ClienteID = clienteID;
	}
	public String getDenominacion() {
		return Denominacion;
	}
	public void setDenominacion(String denominacion) {
		Denominacion = denominacion;
	}
	public String getApellidoPat() {
		return ApellidoPat;
	}
	public void setApellidoPat(String apellidoPat) {
		ApellidoPat = apellidoPat;
	}
	public String getApellidoMat() {
		return ApellidoMat;
	}
	public void setApellidoMat(String apellidoMat) {
		ApellidoMat = apellidoMat;
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
	public String getGenero() {
		return Genero;
	}
	public void setGenero(String genero) {
		Genero = genero;
	}
	public String getCreditoID() {
		return CreditoID;
	}
	public void setCreditoID(String creditoID) {
		CreditoID = creditoID;
	}
	public String getClaveSucursal() {
		return ClaveSucursal;
	}
	public void setClaveSucursal(String claveSucursal) {
		ClaveSucursal = claveSucursal;
	}
	public String getClasifConta() {
		return ClasifConta;
	}
	public void setClasifConta(String clasifConta) {
		ClasifConta = clasifConta;
	}
	public String getProductoCredito() {
		return ProductoCredito;
	}
	public void setProductoCredito(String productoCredito) {
		ProductoCredito = productoCredito;
	}
	public String getFechaDisp() {
		return FechaDisp;
	}
	public void setFechaDisp(String fechaDisp) {
		FechaDisp = fechaDisp;
	}
	public String getFechaVencim() {
		return FechaVencim;
	}
	public void setFechaVencim(String fechaVencim) {
		FechaVencim = fechaVencim;
	}
	public String getTipoAmorti() {
		return TipoAmorti;
	}
	public void setTipoAmorti(String tipoAmorti) {
		TipoAmorti = tipoAmorti;
	}
	public String getMontoCredito() {
		return MontoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		MontoCredito = montoCredito;
	}
	public String getPeriodicidadCap() {
		return PeriodicidadCap;
	}
	public void setPeriodicidadCap(String periodicidadCap) {
		PeriodicidadCap = periodicidadCap;
	}
	public String getPeriodicidadInt() {
		return PeriodicidadInt;
	}
	public void setPeriodicidadInt(String periodicidadInt) {
		PeriodicidadInt = periodicidadInt;
	}
	public String getFecUltPagoCap() {
		return FecUltPagoCap;
	}
	public void setFecUltPagoCap(String fecUltPagoCap) {
		FecUltPagoCap = fecUltPagoCap;
	}
	public String getMonUltPagoCap() {
		return MonUltPagoCap;
	}
	public void setMonUltPagoCap(String monUltPagoCap) {
		MonUltPagoCap = monUltPagoCap;
	}
	public String getFecUltPagoInt() {
		return FecUltPagoInt;
	}
	public void setFecUltPagoInt(String fecUltPagoInt) {
		FecUltPagoInt = fecUltPagoInt;
	}
	public String getMonUltPagoInt() {
		return MonUltPagoInt;
	}
	public void setMonUltPagoInt(String monUltPagoInt) {
		MonUltPagoInt = monUltPagoInt;
	}
	public String getFecPrimAtraso() {
		return FecPrimAtraso;
	}
	public void setFecPrimAtraso(String fecPrimAtraso) {
		FecPrimAtraso = fecPrimAtraso;
	}
	public String getMontoCondona() {
		return MontoCondona;
	}
	public void setMontoCondona(String montoCondona) {
		MontoCondona = montoCondona;
	}
	public String getFecUltCondona() {
		return FecUltCondona;
	}
	public void setFecUltCondona(String fecUltCondona) {
		FecUltCondona = fecUltCondona;
	}
	public String getNumDiasAtraso() {
		return NumDiasAtraso;
	}
	public void setNumDiasAtraso(String numDiasAtraso) {
		NumDiasAtraso = numDiasAtraso;
	}
	public String getTipoCredito() {
		return TipoCredito;
	}
	public void setTipoCredito(String tipoCredito) {
		TipoCredito = tipoCredito;
	}
	public String getSituacContable() {
		return SituacContable;
	}
	public void setSituacContable(String situacContable) {
		SituacContable = situacContable;
	}
	public String getSalCapital() {
		return SalCapital;
	}
	public void setSalCapital(String salCapital) {
		SalCapital = salCapital;
	}
	public String getSalIntOrdin() {
		return SalIntOrdin;
	}
	public void setSalIntOrdin(String salIntOrdin) {
		SalIntOrdin = salIntOrdin;
	}
	public String getSalIntMora() {
		return SalIntMora;
	}
	public void setSalIntMora(String salIntMora) {
		SalIntMora = salIntMora;
	}
	public String getSalIntCtaOrden() {
		return SalIntCtaOrden;
	}
	public void setSalIntCtaOrden(String salIntCtaOrden) {
		SalIntCtaOrden = salIntCtaOrden;
	}
	public String getSalMoraCtaOrden() {
		return SalMoraCtaOrden;
	}
	public void setSalMoraCtaOrden(String salMoraCtaOrden) {
		SalMoraCtaOrden = salMoraCtaOrden;
	}
	public String getIntereRefinan() {
		return IntereRefinan;
	}
	public void setIntereRefinan(String intereRefinan) {
		IntereRefinan = intereRefinan;
	}
	public String getSaldoInsoluto() {
		return SaldoInsoluto;
	}
	public void setSaldoInsoluto(String saldoInsoluto) {
		SaldoInsoluto = saldoInsoluto;
	}
	public String getTipoRelacion() {
		return TipoRelacion;
	}
	public void setTipoRelacion(String tipoRelacion) {
		TipoRelacion = tipoRelacion;
	}
	public String getTipCarCalifi() {
		return TipCarCalifi;
	}
	public void setTipCarCalifi(String tipCarCalifi) {
		TipCarCalifi = tipCarCalifi;
	}
	public String getCalifiIndiv() {
		return CalifiIndiv;
	}
	public void setCalifiIndiv(String califiIndiv) {
		CalifiIndiv = califiIndiv;
	}
	public String getReservaCubierta() {
		return ReservaCubierta;
	}
	public void setReservaCubierta(String reservaCubierta) {
		ReservaCubierta = reservaCubierta;
	}
	public String getReservaExpuesta() {
		return ReservaExpuesta;
	}
	public void setReservaExpuesta(String reservaExpuesta) {
		ReservaExpuesta = reservaExpuesta;
	}
	public String getEPRCAdiCarVen() {
		return EPRCAdiCarVen;
	}
	public void setEPRCAdiCarVen(String ePRCAdiCarVen) {
		EPRCAdiCarVen = ePRCAdiCarVen;
	}
	public String getEPRCAdiSIC() {
		return EPRCAdiSIC;
	}
	public void setEPRCAdiSIC(String ePRCAdiSIC) {
		EPRCAdiSIC = ePRCAdiSIC;
	}
	public String getEPRCAdiCNVB() {
		return EPRCAdiCNVB;
	}
	public void setEPRCAdiCNVB(String ePRCAdiCNVB) {
		EPRCAdiCNVB = ePRCAdiCNVB;
	}
	public String getFecConsultaSIC() {
		return FecConsultaSIC;
	}
	public void setFecConsultaSIC(String fecConsultaSIC) {
		FecConsultaSIC = fecConsultaSIC;
	}
	public String getClaveSIC() {
		return ClaveSIC;
	}
	public void setClaveSIC(String claveSIC) {
		ClaveSIC = claveSIC;
	}
	public String getTotGtiaLiquida() {
		return TotGtiaLiquida;
	}
	public void setTotGtiaLiquida(String totGtiaLiquida) {
		TotGtiaLiquida = totGtiaLiquida;
	}
	public String getGtiaHipotecaria() {
		return GtiaHipotecaria;
	}
	public void setGtiaHipotecaria(String gtiaHipotecaria) {
		GtiaHipotecaria = gtiaHipotecaria;
	}
	public String getFormula() {
		return formula;
	}
	public void setFormula(String formula) {
		this.formula = formula;
	}
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	
	public String getTipoCliente() {
		return tipoCliente;
	}
	public void setTipoCliente(String tipoCliente) {
		this.tipoCliente = tipoCliente;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellidoPaterno() {
		return apellidoPaterno;
	}
	public void setApellidoPaterno(String apellidoPaterno) {
		this.apellidoPaterno = apellidoPaterno;
	}
	public String getApellidoMaterno() {
		return apellidoMaterno;
	}
	public void setApellidoMaterno(String apellidoMaterno) {
		this.apellidoMaterno = apellidoMaterno;
	}
	public String getPersoJuridica() {
		return persoJuridica;
	}
	public void setPersoJuridica(String persoJuridica) {
		this.persoJuridica = persoJuridica;
	}
	public String getGrupoRiesgo() {
		return grupoRiesgo;
	}
	public void setGrupoRiesgo(String grupoRiesgo) {
		this.grupoRiesgo = grupoRiesgo;
	}
	public String getActividadEco() {
		return actividadEco;
	}
	public void setActividadEco(String actividadEco) {
		this.actividadEco = actividadEco;
	}
	public String getNacionalidad() {
		return nacionalidad;
	}
	public void setNacionalidad(String nacionalidad) {
		this.nacionalidad = nacionalidad;
	}
	public String getFechaNacimiento() {
		return fechaNacimiento;
	}
	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public String getCalle() {
		return calle;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public String getNumeroExt() {
		return numeroExt;
	}
	public void setNumeroExt(String numeroExt) {
		this.numeroExt = numeroExt;
	}
	public String getColonia() {
		return colonia;
	}
	public void setColonia(String colonia) {
		this.colonia = colonia;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getLocalidad() {
		return localidad;
	}
	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getMunicipio() {
		return municipio;
	}
	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}
	public String getPais() {
		return pais;
	}
	public void setPais(String pais) {
		this.pais = pais;
	}
	public String getTipoRelacionado() {
		return tipoRelacionado;
	}
	public void setTipoRelacionado(String tipoRelacionado) {
		this.tipoRelacionado = tipoRelacionado;
	}
	public String getNumConsultaSIC() {
		return numConsultaSIC;
	}
	public void setNumConsultaSIC(String numConsultaSIC) {
		this.numConsultaSIC = numConsultaSIC;
	}
	public String getIngresosMes() {
		return ingresosMes;
	}
	public void setIngresosMes(String ingresosMes) {
		this.ingresosMes = ingresosMes;
	}
	public String getTamanioAcred() {
		return tamanioAcred;
	}
	public void setTamanioAcred(String tamanioAcred) {
		this.tamanioAcred = tamanioAcred;
	}
	public String getIdenCreditoCNBV() {
		return idenCreditoCNBV;
	}
	public void setIdenCreditoCNBV(String idenCreditoCNBV) {
		this.idenCreditoCNBV = idenCreditoCNBV;
	}
	public String getIdenGrupalCNBV() {
		return idenGrupalCNBV;
	}
	public void setIdenGrupalCNBV(String idenGrupalCNBV) {
		this.idenGrupalCNBV = idenGrupalCNBV;
	}
	
	public String getTipoAlta() {
		return tipoAlta;
	}
	public void setTipoAlta(String tipoAlta) {
		this.tipoAlta = tipoAlta;
	}
	public String getTipoCartera() {
		return tipoCartera;
	}
	public void setTipoCartera(String tipoCartera) {
		this.tipoCartera = tipoCartera;
	}
	public String getTipoProducto() {
		return tipoProducto;
	}
	public void setTipoProducto(String tipoProducto) {
		this.tipoProducto = tipoProducto;
	}
	public String getDestinoCred() {
		return destinoCred;
	}
	public void setDestinoCred(String destinoCred) {
		this.destinoCred = destinoCred;
	}
	public String getNumeroCuenta() {
		return numeroCuenta;
	}
	public void setNumeroCuenta(String numeroCuenta) {
		this.numeroCuenta = numeroCuenta;
	}
	public String getNumContrato() {
		return numContrato;
	}
	public void setNumContrato(String numContrato) {
		this.numContrato = numContrato;
	}
	public String getNombreFacto() {
		return nombreFacto;
	}
	public void setNombreFacto(String nombreFacto) {
		this.nombreFacto = nombreFacto;
	}
	public String getrFCFactorado() {
		return rFCFactorado;
	}
	public void setrFCFactorado(String rFCFactorado) {
		this.rFCFactorado = rFCFactorado;
	}
	public String getMontoLineaPes() {
		return montoLineaPes;
	}
	public void setMontoLineaPes(String montoLineaPes) {
		this.montoLineaPes = montoLineaPes;
	}
	public String getMontoLineaOri() {
		return montoLineaOri;
	}
	public void setMontoLineaOri(String montoLineaOri) {
		this.montoLineaOri = montoLineaOri;
	}
	public String getFechaMaxima() {
		return fechaMaxima;
	}
	public void setFechaMaxima(String fechaMaxima) {
		this.fechaMaxima = fechaMaxima;
	}
	public String getFechaVencimien() {
		return fechaVencimien;
	}
	public void setFechaVencimien(String fechaVencimien) {
		this.fechaVencimien = fechaVencimien;
	}
	public String getFormaDisposi() {
		return formaDisposi;
	}
	public void setFormaDisposi(String formaDisposi) {
		this.formaDisposi = formaDisposi;
	}
	public String getTasaReferencia() {
		return tasaReferencia;
	}
	public void setTasaReferencia(String tasaReferencia) {
		this.tasaReferencia = tasaReferencia;
	}
	public String getDiferencial() {
		return diferencial;
	}
	public void setDiferencial(String diferencial) {
		this.diferencial = diferencial;
	}
	public String getOpeDirencial() {
		return opeDirencial;
	}
	public void setOpeDirencial(String opeDirencial) {
		this.opeDirencial = opeDirencial;
	}
	public String getTipoMoneda() {
		return tipoMoneda;
	}
	public void setTipoMoneda(String tipoMoneda) {
		this.tipoMoneda = tipoMoneda;
	}
	public String getPeriodoFactura() {
		return periodoFactura;
	}
	public void setPeriodoFactura(String periodoFactura) {
		this.periodoFactura = periodoFactura;
	}
	public String getComisionAper() {
		return comisionAper;
	}
	public void setComisionAper(String comisionAper) {
		this.comisionAper = comisionAper;
	}
	public String getMontoComAper() {
		return montoComAper;
	}
	public void setMontoComAper(String montoComAper) {
		this.montoComAper = montoComAper;
	}
	public String getComisionDispo() {
		return comisionDispo;
	}
	public void setComisionDispo(String comisionDispo) {
		this.comisionDispo = comisionDispo;
	}
	public String getMontoComDispo() {
		return montoComDispo;
	}
	public void setMontoComDispo(String montoComDispo) {
		this.montoComDispo = montoComDispo;
	}
	public String getValorVivienda() {
		return valorVivienda;
	}
	public void setValorVivienda(String valorVivienda) {
		this.valorVivienda = valorVivienda;
	}
	public String getValoAvaluo() {
		return valoAvaluo;
	}
	public void setValoAvaluo(String valoAvaluo) {
		this.valoAvaluo = valoAvaluo;
	}
	public String getNumeroAvaluo() {
		return numeroAvaluo;
	}
	public void setNumeroAvaluo(String numeroAvaluo) {
		this.numeroAvaluo = numeroAvaluo;
	}
	public String getLTV() {
		return LTV;
	}
	public void setLTV(String lTV) {
		LTV = lTV;
	}
	public String getLocalidadCred() {
		return localidadCred;
	}
	public void setLocalidadCred(String localidadCred) {
		this.localidadCred = localidadCred;
	}
	public String getMunicipioCred() {
		return municipioCred;
	}
	public void setMunicipioCred(String municipioCred) {
		this.municipioCred = municipioCred;
	}
	public String getEstadoCred() {
		return estadoCred;
	}
	public void setEstadoCred(String estadoCred) {
		this.estadoCred = estadoCred;
	}
	public String getActividadEcoCred() {
		return actividadEcoCred;
	}
	public void setActividadEcoCred(String actividadEcoCred) {
		this.actividadEcoCred = actividadEcoCred;
	}
	public String getClaveEntidad() {
		return claveEntidad;
	}
	public void setClaveEntidad(String claveEntidad) {
		this.claveEntidad = claveEntidad;
	}
	public String getFechaOtorga() {
		return fechaOtorga;
	}
	public void setFechaOtorga(String fechaOtorga) {
		this.fechaOtorga = fechaOtorga;
	}
	
	
	
	
}
