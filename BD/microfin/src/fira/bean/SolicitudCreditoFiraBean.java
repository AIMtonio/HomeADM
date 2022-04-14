package fira.bean;

import java.util.List;
import general.bean.BaseBean;

public class SolicitudCreditoFiraBean extends BaseBean{
	// constantes
	public static int Act_Calendario = 1;
	// atributos
	private String 	solicitudCreditoID;
	private String  prospectoID;
	private String	clienteID;
	private String	fechaRegistro;
	private String	fechaAutoriza;
	private String	montoSolici;
	private String	montoAutorizado;
	private String	monedaID;
	private String	productoCreditoID;
	private String	tasaActiva;
	private String	plazoID;
	private String	estatus;
	private String  estatusSol;
	private String	tipoDispersion;
	private String	cuentaCLABE;
	private String 	sucursalID;
	private String	forCobroComAper;
	private String	montoComApert;
	private String	ivaComApert;
	private String  destinoCreID;
	private String 	promotorID;

	private String	calcInteresID;
	private String	tasaFija;
	private String	tasaBase;
	private String	sobreTasa;
	private String	pisoTasa;
	private String	techoTasa;
	private String	factorMora;
	private String	fechInhabil;
	private String	ajusFecExiVen;
	private String	ajFecUlAmoVen;
	private String	frecuenciaInt;
	private String	frecuenciaCap;
	private String	PeriodicidadCap;
	private String	periodicidadInt;
	private String	tipoPagoCapital;
	private String	numAmortizacion;
	private String	calendIrregular;
	private String	diaPagoInteres;
	private String	diaPagoCapital;
	private String	diaMesInteres;
	private String	diaMesCapital;
	private String	numTransacSim;
	private String	CAT;

	private String	aporteCliente;
	private String	usuarioAutoriza;
	private String	fechaRechazo;
	private String	usuarioRechazo;
	private String	comentarioRech;
	private String	motivoRechazo;
	private String	tipoCredito	;
	private String 	numCreditos;
	private String	relacionado;
	private String 	proyecto;
	private String 	tipoFondeo;
	private String 	institutFondID;
	private String 	lineaFondeoID;

	private String	tipoCalInteres;
	private String	creditoID;
	private String	numAmortInteres;
	private String	montoCuota;
	private String	fechaVencimiento;
	private String	comentarioEjecutivo;
	private String	comentarioMesaControl;
	private String	fechaInicio;
	private String	clasifiDestinCred;
	private String  ReqConsultaSIC;

	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	private String nombreSucursal;
	private String nombreUsuario;
	private String nomUsuario;
	private String fechaFin;
	private String montoSeguroCuota;				//Monto que especifica cuanto se le debe de cobrar al cliente por el seguro de cuota
	private String iVASeguroCuota;					//Monto de seguro por cuota
	private String cobraSeguroCuota;
	private String cobraIVASeguroCuota;
	// Cobro de comision por apertura
	private String fechaCobroComision;
	private String capacidadPago;
	
	// motivos sobre la canselacio o devoluciones de solicitudes de credito
	private String motivoRechazoID;
	private String descripcionMotivo;
	private String motivoDevolucionID;


	// Auxiliar para consulta de circulo de credito
	private String tipoContratoCCID;

	// Bean Auxiliar para ver solicitudes Asignadas
	private String asignaSol;

	//Bean Auxiliar para ver solicitudes Asignadas a Obligados Solidarios
	private String asignaOblSol;

	// Auxiliares del Bean para pantalla cheklist
	private String grupoID;
	private String nombreGrupo;
	private String fechaRegistroGr;
	private String cicloActual;
	private String tipoIntegrante;
	private String sucursalPromotor;
	private String promAtiendeSuc;

	private String  nombreCompletoCliente;
	private String  nombreCompletoProspecto;
	private String  fechaFormalizacion;
	private String  montoFondeado;
	private String  porcentajeFonde;
	private String  numeroFondeos;

	//Variables para el Seguro de Vida
	private String formaComApertura;
	private String montoSeguroVida;
	private String tipoPagoSeguro;
	private String beneficiario;
	private String direccionBen;
	private String parentescoID; // tipoRelacionID
	private String factorRiesgoSeguro;
	private String porcGarLiq;
	private String montoGarLiq;
	private String forCobroSegVida;
	private String montoPolSegVida;
	private String reqSeguroVida;
	private String seguroVidaID;

	//variables para tomar el ciclo grupal o el del cliente para el calculo de la tasa fija
	private String esGrupal;
	private String tasaPonderaGru;
	//variables para Banca en Linea
	private String institucionNominaID;
	private String negocioAfiliadoID;
	private String descripcionProducto;
	private String folioCtrl;
	private String horarioVeri;

	/* Auxiliares para pantalla cambios condidiones grupal */
	private List lSolicitudCre;
	private List lMontoOriginal;
	private List lEstatusSolici;
	private List lDescuentoSeguro;
	private List lMontoSegOriginal;
	private List lMontoSol;

	/* Auxiliares Para Reporte */
	private String nombreInstitucion;

	private String fechaInicioAmor;
	private String diaPagoProd;

	private String formCobroSegVida;
	private String descuentoSeguro;
	private String montoSegOriginal;

	private String clienteNombre;
	private String prospectoNombre;
	private String estatusDesc;

	/* Auxiliares para pantalla cambio de tasa*/
	private String cobraMora;
	private String tipCobComMorato;
	private String desPlazo;
	private String montoPorComAper;
	private String tipoComXapert;

	private String comentario; // Comentario Alta de Solicitud de Crédito
	private String tipoLiquidacion;
	private String cantidadPagar;

	//tipo de consulta SIC
	private String tipoConsultaSICBuro;
	private String tipoConsultaSICCirculo;
	private String tipoConsultaSIC;
	private String folioConsultaBC;
	private String folioConsultaCC;
	/*CREDITOS AGROPECUARIOS*/
	private String detalleMinistraAgro;
	private String esAgropecuario;
	private String esConsolidadoAgro;
	private String deudorOriginalID;
	private String cadenaProductivaID;
	private String ramaFIRAID;
	private String subramaFIRAID;
	private String actividadFIRAID;
	private String tipoGarantiaFIRAID;
	private String progEspecialFIRAID;
	private String tasaPasiva;
	private String creditoIDFIRA;
	private String acreditadoIDFIRA;
	/*FIN CREDITOS AGROPECUARIOS*/

	/* CRÉDITOS AUTOMÁTICOS */
	private String inversionID;
	private String cuentaAhoID;
	private String montoMaximo;
	private String esAutomatico;
	private String tipoAutomatico;

	/* FIN CRÉDITOS AUTOMÁTICOS */

	private String cobraAccesorios;

	// Garantias FOGA Y FOGAFI
	private String modalidadFOGAFI;
	private String porcentajeFOGAFI;
	private String montoFOGAFI;

	// Seguro de Vida CONSOL
	private String cobertura;
	private String prima;
	private String vigencia;

	private String numDiasVenPrimAmor;
	private String diasReqPrimerAmor;
	private String valorParametro;

	private String tasaNivel;

	private String convenioNominaID;
	private String descripcionConvenio;
	private String nombreInstit;
	private String noEmpleado;
	private String tipoEmpleado;
	private String manejaCapPago;
	private String porcentajeCapacidad;
	private String resguardo;
	
	private String folioSolici;
	private String quinquenioID;
	private String clabeDomiciliacion;
	private String fechaIniCre;
	private String fechaVenCre;
	
	//Servicios adicionales
	private String serviciosAdicionales;
	private List listaServiciosAdicionales;
	private String aplicaDescServicio;

	private String tipoCtaSantander;
	private String ctaSantander;
	private String ctaClabeDisp;
	private String tipoPersona;
	
	// Validacion de consolidacion
	private String identificacion;
	private String direccion;
	private String cuentaAhorro;

	// Lineas de Crédito Agro
	private String lineaCreditoID;
	private String manejaComAdmon;
	private String forPagComAdmon;
	private String porcentajeComAdmon;
	private String manejaComGarantia;
	private String montoPagComAdmon;
	private String montoCobComAdmon;
	
	private String forPagComGarantia;
	private String porcentajeComGarantia;
	private String comAdmonLinPrevLiq;
	private String comGarLinPrevLiq;
	private String montoPagComGarantia;
	private String montoCobComGarantia;

	public String getReqConsultaSIC() {
		return ReqConsultaSIC;
	}
	public void setReqConsultaSIC(String reqConsultaSIC) {
		ReqConsultaSIC = reqConsultaSIC;
	}
	private String esReacreditado;

	public String getDiaPagoProd() {
		return diaPagoProd;
	}
	public void setDiaPagoProd(String diaPagoProd) {
		this.diaPagoProd = diaPagoProd;
	}
	public String getFechaInicioAmor() {
		return fechaInicioAmor;
	}
	public void setFechaInicioAmor(String fechaInicioAmor) {
		this.fechaInicioAmor = fechaInicioAmor;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getSucursalPromotor() {
		return sucursalPromotor;
	}
	public void setSucursalPromotor(String sucursalPromotor) {
		this.sucursalPromotor = sucursalPromotor;
	}
	public String getPromAtiendeSuc() {
		return promAtiendeSuc;
	}
	public void setPromAtiendeSuc(String promAtiendeSuc) {
		this.promAtiendeSuc = promAtiendeSuc;
	}
	public String getComentarioEjecutivo() {
		return comentarioEjecutivo;
	}
	public void setComentarioEjecutivo(String comentarioEjecutivo) {
		this.comentarioEjecutivo = comentarioEjecutivo;
	}
	public String getComentarioMesaControl() {
		return comentarioMesaControl;
	}
	public void setComentarioMesaControl(String comentarioMesaControl) {
		this.comentarioMesaControl = comentarioMesaControl;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public String getMontoSolici() {
		return montoSolici;
	}
	public String getMontoAutorizado() {
		return montoAutorizado;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public String getTasaActiva() {
		return tasaActiva;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public String getTipoDispersion() {
		return tipoDispersion;
	}
	public String getCuentaCLABE() {
		return cuentaCLABE;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public String getForCobroComAper() {
		return forCobroComAper;
	}
	public String getMontoComApert() {
		return montoComApert;
	}
	public String getIvaComApert() {
		return ivaComApert;
	}
	public String getDestinoCreID() {
		return destinoCreID;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public String getCalcInteresID() {
		return calcInteresID;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public String getTasaBase() {
		return tasaBase;
	}
	public String getSobreTasa() {
		return sobreTasa;
	}
	public String getPisoTasa() {
		return pisoTasa;
	}
	public String getTechoTasa() {
		return techoTasa;
	}
	public String getFactorMora() {
		return factorMora;
	}
	public String getFechInhabil() {
		return fechInhabil;
	}
	public String getAjusFecExiVen() {
		return ajusFecExiVen;
	}
	public String getAjFecUlAmoVen() {
		return ajFecUlAmoVen;
	}
	public String getFrecuenciaInt() {
		return frecuenciaInt;
	}
	public String getFrecuenciaCap() {
		return frecuenciaCap;
	}
	public String getPeriodicidadCap() {
		return PeriodicidadCap;
	}
	public String getPeriodicidadInt() {
		return periodicidadInt;
	}
	public String getTipoPagoCapital() {
		return tipoPagoCapital;
	}
	public String getNumAmortizacion() {
		return numAmortizacion;
	}
	public String getCalendIrregular() {
		return calendIrregular;
	}
	public String getDiaPagoInteres() {
		return diaPagoInteres;
	}
	public String getDiaPagoCapital() {
		return diaPagoCapital;
	}
	public String getDiaMesInteres() {
		return diaMesInteres;
	}
	public String getDiaMesCapital() {
		return diaMesCapital;
	}
	public String getNumTransacSim() {
		return numTransacSim;
	}
	public String getCAT() {
		return CAT;
	}
	public String getAporteCliente() {
		return aporteCliente;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public String getFechaRechazo() {
		return fechaRechazo;
	}
	public String getUsuarioRechazo() {
		return usuarioRechazo;
	}
	public String getComentarioRech() {
		return comentarioRech;
	}
	public String getMotivoRechazo() {
		return motivoRechazo;
	}
	public String getTipoCredito() {
		return tipoCredito;
	}
	public String getNumCreditos() {
		return numCreditos;
	}
	public String getRelacionado() {
		return relacionado;
	}
	public String getProyecto() {
		return proyecto;
	}
	public String getTipoFondeo() {
		return tipoFondeo;
	}
	public String getInstitutFondID() {
		return institutFondID;
	}
	public String getLineaFondeoID() {
		return lineaFondeoID;
	}
	public String getTipoCalInteres() {
		return tipoCalInteres;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public String getNumAmortInteres() {
		return numAmortInteres;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public String getAsignaSol() {
		return asignaSol;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public String getFechaRegistroGr() {
		return fechaRegistroGr;
	}
	public String getCicloActual() {
		return cicloActual;
	}
	public String getTipoIntegrante() {
		return tipoIntegrante;
	}
	public String getNombreCompletoCliente() {
		return nombreCompletoCliente;
	}
	public String getNombreCompletoProspecto() {
		return nombreCompletoProspecto;
	}
	public String getFechaFormalizacion() {
		return fechaFormalizacion;
	}
	public String getMontoFondeado() {
		return montoFondeado;
	}
	public String getPorcentajeFonde() {
		return porcentajeFonde;
	}
	public String getNumeroFondeos() {
		return numeroFondeos;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public void setMontoSolici(String montoSolici) {
		this.montoSolici = montoSolici;
	}
	public void setMontoAutorizado(String montoAutorizado) {
		this.montoAutorizado = montoAutorizado;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public void setTasaActiva(String tasaActiva) {
		this.tasaActiva = tasaActiva;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public void setTipoDispersion(String tipoDispersion) {
		this.tipoDispersion = tipoDispersion;
	}
	public void setCuentaCLABE(String cuentaCLABE) {
		this.cuentaCLABE = cuentaCLABE;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public void setForCobroComAper(String forCobroComAper) {
		this.forCobroComAper = forCobroComAper;
	}
	public void setMontoComApert(String montoComApert) {
		this.montoComApert = montoComApert;
	}
	public void setIvaComApert(String ivaComApert) {
		this.ivaComApert = ivaComApert;
	}
	public void setDestinoCreID(String destinoCreID) {
		this.destinoCreID = destinoCreID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public void setCalcInteresID(String calcInteresID) {
		this.calcInteresID = calcInteresID;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public void setTasaBase(String tasaBase) {
		this.tasaBase = tasaBase;
	}
	public void setSobreTasa(String sobreTasa) {
		this.sobreTasa = sobreTasa;
	}
	public void setPisoTasa(String pisoTasa) {
		this.pisoTasa = pisoTasa;
	}
	public void setTechoTasa(String techoTasa) {
		this.techoTasa = techoTasa;
	}
	public void setFactorMora(String factorMora) {
		this.factorMora = factorMora;
	}
	public void setFechInhabil(String fechInhabil) {
		this.fechInhabil = fechInhabil;
	}
	public void setAjusFecExiVen(String ajusFecExiVen) {
		this.ajusFecExiVen = ajusFecExiVen;
	}
	public void setAjFecUlAmoVen(String ajFecUlAmoVen) {
		this.ajFecUlAmoVen = ajFecUlAmoVen;
	}
	public void setFrecuenciaInt(String frecuenciaInt) {
		this.frecuenciaInt = frecuenciaInt;
	}
	public void setFrecuenciaCap(String frecuenciaCap) {
		this.frecuenciaCap = frecuenciaCap;
	}
	public void setPeriodicidadCap(String periodicidadCap) {
		PeriodicidadCap = periodicidadCap;
	}
	public void setPeriodicidadInt(String periodicidadInt) {
		this.periodicidadInt = periodicidadInt;
	}
	public void setTipoPagoCapital(String tipoPagoCapital) {
		this.tipoPagoCapital = tipoPagoCapital;
	}
	public void setNumAmortizacion(String numAmortizacion) {
		this.numAmortizacion = numAmortizacion;
	}
	public void setCalendIrregular(String calendIrregular) {
		this.calendIrregular = calendIrregular;
	}
	public void setDiaPagoInteres(String diaPagoInteres) {
		this.diaPagoInteres = diaPagoInteres;
	}
	public void setDiaPagoCapital(String diaPagoCapital) {
		this.diaPagoCapital = diaPagoCapital;
	}
	public void setDiaMesInteres(String diaMesInteres) {
		this.diaMesInteres = diaMesInteres;
	}
	public void setDiaMesCapital(String diaMesCapital) {
		this.diaMesCapital = diaMesCapital;
	}
	public void setNumTransacSim(String numTransacSim) {
		this.numTransacSim = numTransacSim;
	}
	public void setCAT(String cAT) {
		CAT = cAT;
	}
	public void setAporteCliente(String aporteCliente) {
		this.aporteCliente = aporteCliente;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public void setFechaRechazo(String fechaRechazo) {
		this.fechaRechazo = fechaRechazo;
	}
	public void setUsuarioRechazo(String usuarioRechazo) {
		this.usuarioRechazo = usuarioRechazo;
	}
	public void setComentarioRech(String comentarioRech) {
		this.comentarioRech = comentarioRech;
	}
	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	public void setTipoCredito(String tipoCredito) {
		this.tipoCredito = tipoCredito;
	}
	public void setNumCreditos(String numCreditos) {
		this.numCreditos = numCreditos;
	}
	public void setRelacionado(String relacionado) {
		this.relacionado = relacionado;
	}
	public void setProyecto(String proyecto) {
		this.proyecto = proyecto;
	}
	public void setTipoFondeo(String tipoFondeo) {
		this.tipoFondeo = tipoFondeo;
	}
	public void setInstitutFondID(String institutFondID) {
		this.institutFondID = institutFondID;
	}
	public void setLineaFondeoID(String lineaFondeoID) {
		this.lineaFondeoID = lineaFondeoID;
	}
	public void setTipoCalInteres(String tipoCalInteres) {
		this.tipoCalInteres = tipoCalInteres;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public void setNumAmortInteres(String numAmortInteres) {
		this.numAmortInteres = numAmortInteres;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public void setAsignaSol(String asignaSol) {
		this.asignaSol = asignaSol;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	public void setFechaRegistroGr(String fechaRegistroGr) {
		this.fechaRegistroGr = fechaRegistroGr;
	}
	public void setCicloActual(String cicloActual) {
		this.cicloActual = cicloActual;
	}
	public void setTipoIntegrante(String tipoIntegrante) {
		this.tipoIntegrante = tipoIntegrante;
	}
	public void setNombreCompletoCliente(String nombreCompletoCliente) {
		this.nombreCompletoCliente = nombreCompletoCliente;
	}
	public void setNombreCompletoProspecto(String nombreCompletoProspecto) {
		this.nombreCompletoProspecto = nombreCompletoProspecto;
	}
	public void setFechaFormalizacion(String fechaFormalizacion) {
		this.fechaFormalizacion = fechaFormalizacion;
	}
	public void setMontoFondeado(String montoFondeado) {
		this.montoFondeado = montoFondeado;
	}
	public void setPorcentajeFonde(String porcentajeFonde) {
		this.porcentajeFonde = porcentajeFonde;
	}
	public void setNumeroFondeos(String numeroFondeos) {
		this.numeroFondeos = numeroFondeos;
	}
	public String getMontoSeguroVida() {
		return montoSeguroVida;
	}
	public void setMontoSeguroVida(String montoSeguroVida) {
		this.montoSeguroVida = montoSeguroVida;
	}
	public String getTipoPagoSeguro() {
		return tipoPagoSeguro;
	}
	public void setTipoPagoSeguro(String tipoPagoSeguro) {
		this.tipoPagoSeguro = tipoPagoSeguro;
	}
	public String getBeneficiario() {
		return beneficiario;
	}
	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}
	public String getDireccionBen() {
		return direccionBen;
	}
	public void setDireccionBen(String direccionBen) {
		this.direccionBen = direccionBen;
	}
	public String getParentescoID() {
		return parentescoID;
	}
	public void setParentescoID(String parentescoID) {
		this.parentescoID = parentescoID;
	}
	public String getFactorRiesgoSeguro() {
		return factorRiesgoSeguro;
	}
	public void setFactorRiesgoSeguro(String factorRiesgoSeguro) {
		this.factorRiesgoSeguro = factorRiesgoSeguro;
	}
	public String getPorcGarLiq() {
		return porcGarLiq;
	}
	public void setPorcGarLiq(String porcGarLiq) {
		this.porcGarLiq = porcGarLiq;
	}
	public String getMontoGarLiq() {
		return montoGarLiq;
	}
	public void setMontoGarLiq(String montoGarLiq) {
		this.montoGarLiq = montoGarLiq;
	}
	public String getForCobroSegVida() {
		return forCobroSegVida;
	}
	public void setForCobroSegVida(String forCobroSegVida) {
		this.forCobroSegVida = forCobroSegVida;
	}
	public String getMontoPolSegVida() {
		return montoPolSegVida;
	}
	public void setMontoPolSegVida(String montoPolSegVida) {
		this.montoPolSegVida = montoPolSegVida;
	}
	public String getReqSeguroVida() {
		return reqSeguroVida;
	}
	public void setReqSeguroVida(String reqSeguroVida) {
		this.reqSeguroVida = reqSeguroVida;
	}
	public String getFormaComApertura() {
		return formaComApertura;
	}
	public void setFormaComApertura(String formaComApertura) {
		this.formaComApertura = formaComApertura;
	}
	public String getEsGrupal() {
		return esGrupal;
	}
	public void setEsGrupal(String esGrupal) {
		this.esGrupal = esGrupal;
	}
	public String getTasaPonderaGru() {
		return tasaPonderaGru;
	}
	public void setTasaPonderaGru(String tasaPonderaGru) {
		this.tasaPonderaGru = tasaPonderaGru;
	}
	public String getClasifiDestinCred() {
		return clasifiDestinCred;
	}
	public void setClasifiDestinCred(String clasifiDestinCred) {
		this.clasifiDestinCred = clasifiDestinCred;
	}
	public String getSeguroVidaID() {
		return seguroVidaID;
	}
	public void setSeguroVidaID(String seguroVidaID) {
		this.seguroVidaID = seguroVidaID;
	}
	public String getInstitucionNominaID() {
		return institucionNominaID;
	}
	public void setInstitucionNominaID(String institucionNominaID) {
		this.institucionNominaID = institucionNominaID;
	}
	public String getNegocioAfiliadoID() {
		return negocioAfiliadoID;
	}
	public void setNegocioAfiliadoID(String negocioAfiliadoID) {
		this.negocioAfiliadoID = negocioAfiliadoID;
	}
	public String getDescripcionProducto() {
		return descripcionProducto;
	}
	public void setDescripcionProducto(String descripcionProducto) {
		this.descripcionProducto = descripcionProducto;
	}
	public String getFolioCtrl() {
		return folioCtrl;
	}
	public void setFolioCtrl(String folioCtrl) {
		this.folioCtrl = folioCtrl;
	}
	public String getHorarioVeri() {
		return horarioVeri;
	}
	public void setHorarioVeri(String horarioVeri) {
		this.horarioVeri = horarioVeri;
	}
	public List getlSolicitudCre() {
		return lSolicitudCre;
	}
	public List getlMontoOriginal() {
		return lMontoOriginal;
	}
	public List getlEstatusSolici() {
		return lEstatusSolici;
	}
	public void setlSolicitudCre(List lSolicitudCre) {
		this.lSolicitudCre = lSolicitudCre;
	}
	public void setlMontoOriginal(List lMontoOriginal) {
		this.lMontoOriginal = lMontoOriginal;
	}
	public void setlEstatusSolici(List lEstatusSolici) {
		this.lEstatusSolici = lEstatusSolici;
	}
	public String getTipoContratoCCID() {
		return tipoContratoCCID;
	}
	public void setTipoContratoCCID(String tipoContratoCCID) {
		this.tipoContratoCCID = tipoContratoCCID;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNomUsuario() {
		return nomUsuario;
	}
	public void setNomUsuario(String nomUsuario) {
		this.nomUsuario = nomUsuario;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}

	public String getFormCobroSegVida() {
		return formCobroSegVida;
	}
	public void setFormCobroSegVida(String formCobroSegVida) {
		this.formCobroSegVida = formCobroSegVida;
	}
	public List getlDescuentoSeguro() {
		return lDescuentoSeguro;
	}
	public void setlDescuentoSeguro(List lDescuentoSeguro) {
		this.lDescuentoSeguro = lDescuentoSeguro;
	}
	public List getlMontoSegOriginal() {
		return lMontoSegOriginal;
	}
	public void setlMontoSegOriginal(List lMontoSegOriginal) {
		this.lMontoSegOriginal = lMontoSegOriginal;
	}
	public String getDescuentoSeguro() {
		return descuentoSeguro;
	}
	public void setDescuentoSeguro(String descuentoSeguro) {
		this.descuentoSeguro = descuentoSeguro;
	}
	public String getMontoSegOriginal() {
		return montoSegOriginal;
	}
	public void setMontoSegOriginal(String montoSegOriginal) {
		this.montoSegOriginal = montoSegOriginal;
	}
	public List getlMontoSol() {
		return lMontoSol;
	}
	public void setlMontoSol(List lMontoSol) {
		this.lMontoSol = lMontoSol;
	}
	public String getEstatusSol() {
		return estatusSol;
	}
	public void setEstatusSol(String estatusSol) {
		this.estatusSol = estatusSol;
	}
	public String getCobraMora() {
		return cobraMora;
	}
	public void setCobraMora(String cobraMora) {
		this.cobraMora = cobraMora;
	}
	public String getTipCobComMorato() {
		return tipCobComMorato;
	}
	public void setTipCobComMorato(String tipCobComMorato) {
		this.tipCobComMorato = tipCobComMorato;
	}
	public String getDesPlazo() {
		return desPlazo;
	}
	public void setDesPlazo(String desPlazo) {
		this.desPlazo = desPlazo;
	}
	public String getMontoPorComAper() {
		return montoPorComAper;
	}
	public void setMontoPorComAper(String montoPorComAper) {
		this.montoPorComAper = montoPorComAper;
	}
	public String getTipoComXapert() {
		return tipoComXapert;
	}
	public void setTipoComXapert(String tipoComXapert) {
		this.tipoComXapert = tipoComXapert;
	}

	public String getClienteNombre() {
		return clienteNombre;
	}
	public void setClienteNombre(String clienteNombre) {
		this.clienteNombre = clienteNombre;
	}
	public String getProspectoNombre() {
		return prospectoNombre;
	}
	public void setProspectoNombre(String prospectoNombre) {
		this.prospectoNombre = prospectoNombre;
	}
	public String getEstatusDesc() {
		return estatusDesc;
	}
	public void setEstatusDesc(String estatusDesc) {
		this.estatusDesc = estatusDesc;
	}
	public String getMontoSeguroCuota() {
		return montoSeguroCuota;
	}
	public void setMontoSeguroCuota(String montoSeguroCuota) {
		this.montoSeguroCuota = montoSeguroCuota;
	}
	public String getiVASeguroCuota() {
		return iVASeguroCuota;
	}
	public void setiVASeguroCuota(String iVASeguroCuota) {
		this.iVASeguroCuota = iVASeguroCuota;
	}
	public String getCobraSeguroCuota() {
		return cobraSeguroCuota;
	}
	public void setCobraSeguroCuota(String cobraSeguroCuota) {
		this.cobraSeguroCuota = cobraSeguroCuota;
	}
	public String getCobraIVASeguroCuota() {
		return cobraIVASeguroCuota;
	}
	public void setCobraIVASeguroCuota(String cobraIVASeguroCuota) {
		this.cobraIVASeguroCuota = cobraIVASeguroCuota;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getTipoLiquidacion() {
		return tipoLiquidacion;
	}
	public void setTipoLiquidacion(String tipoLiquidacion) {
		this.tipoLiquidacion = tipoLiquidacion;
	}
	public String getCantidadPagar() {
		return cantidadPagar;
	}
	public void setCantidadPagar(String cantidadPagar) {
		this.cantidadPagar = cantidadPagar;
	}
	public static int getAct_Calendario() {
		return Act_Calendario;
	}
	public static void setAct_Calendario(int act_Calendario) {
		Act_Calendario = act_Calendario;
	}
	public String getTipoConsultaSICBuro() {
		return tipoConsultaSICBuro;
	}
	public void setTipoConsultaSICBuro(String tipoConsultaSICBuro) {
		this.tipoConsultaSICBuro = tipoConsultaSICBuro;
	}
	public String getTipoConsultaSICCirculo() {
		return tipoConsultaSICCirculo;
	}
	public void setTipoConsultaSICCirculo(String tipoConsultaSICCirculo) {
		this.tipoConsultaSICCirculo = tipoConsultaSICCirculo;
	}
	public String getTipoConsultaSIC() {
		return tipoConsultaSIC;
	}
	public void setTipoConsultaSIC(String tipoConsultaSIC) {
		this.tipoConsultaSIC = tipoConsultaSIC;
	}
	public String getFolioConsultaBC() {
		return folioConsultaBC;
	}
	public void setFolioConsultaBC(String folioConsultaBC) {
		this.folioConsultaBC = folioConsultaBC;
	}
	public String getFolioConsultaCC() {
		return folioConsultaCC;
	}
	public void setFolioConsultaCC(String folioConsultaCC) {
		this.folioConsultaCC = folioConsultaCC;
	}
	public String getDetalleMinistraAgro() {
		return detalleMinistraAgro;
	}
	public void setDetalleMinistraAgro(String detalleMinistraAgro) {
		this.detalleMinistraAgro = detalleMinistraAgro;
	}
	public String getEsAgropecuario() {
		return esAgropecuario;
	}
	public void setEsAgropecuario(String esAgropecuario) {
		this.esAgropecuario = esAgropecuario;
	}
	public String getCadenaProductivaID() {
		return cadenaProductivaID;
	}
	public void setCadenaProductivaID(String cadenaProductivaID) {
		this.cadenaProductivaID = cadenaProductivaID;
	}
	public String getRamaFIRAID() {
		return ramaFIRAID;
	}
	public void setRamaFIRAID(String ramaFIRAID) {
		this.ramaFIRAID = ramaFIRAID;
	}
	public String getSubramaFIRAID() {
		return subramaFIRAID;
	}
	public void setSubramaFIRAID(String subramaFIRAID) {
		this.subramaFIRAID = subramaFIRAID;
	}
	public String getActividadFIRAID() {
		return actividadFIRAID;
	}
	public void setActividadFIRAID(String actividadFIRAID) {
		this.actividadFIRAID = actividadFIRAID;
	}
	public String getTipoGarantiaFIRAID() {
		return tipoGarantiaFIRAID;
	}
	public void setTipoGarantiaFIRAID(String tipoGarantiaFIRAID) {
		this.tipoGarantiaFIRAID = tipoGarantiaFIRAID;
	}
	public String getProgEspecialFIRAID() {
		return progEspecialFIRAID;
	}
	public void setProgEspecialFIRAID(String progEspecialFIRAID) {
		this.progEspecialFIRAID = progEspecialFIRAID;
	}
	public String getFechaCobroComision() {
		return fechaCobroComision;
	}
	public void setFechaCobroComision(String fechaCobroComision) {
		this.fechaCobroComision = fechaCobroComision;
	}
	public String getTasaNivel() {
		return tasaNivel;
	}
	public void setTasaNivel(String tasaNivel) {
		this.tasaNivel = tasaNivel;
	}
	public String getInversionID() {
		return inversionID;
	}
	public void setInversionID(String inversionID) {
		this.inversionID = inversionID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getMontoMaximo() {
		return montoMaximo;
	}
	public void setMontoMaximo(String montoMaximo) {
		this.montoMaximo = montoMaximo;
	}
	public String getEsAutomatico() {
		return esAutomatico;
	}
	public void setEsAutomatico(String esAutomatico) {
		this.esAutomatico = esAutomatico;
	}
	public String getTipoAutomatico() {
		return tipoAutomatico;
	}
	public void setTipoAutomatico(String tipoAutomatico) {
		this.tipoAutomatico = tipoAutomatico;
	}

	public String getTasaPasiva() {
		return tasaPasiva;
	}
	public void setTasaPasiva(String tasaPasiva) {
		this.tasaPasiva = tasaPasiva;
	}
	public String getCreditoIDFIRA() {
		return creditoIDFIRA;
	}
	public void setCreditoIDFIRA(String creditoIDFIRA) {
		this.creditoIDFIRA = creditoIDFIRA;
	}
	public String getAcreditadoIDFIRA() {
		return acreditadoIDFIRA;
	}
	public void setAcreditadoIDFIRA(String acreditadoIDFIRA) {
		this.acreditadoIDFIRA = acreditadoIDFIRA;
	}
	public String getEsReacreditado() {
		return esReacreditado;
	}
	public void setEsReacreditado(String esReacreditado) {
		this.esReacreditado = esReacreditado;
	}
	public String getAsignaOblSol() {
		return asignaOblSol;
	}
	public void setAsignaOblSol(String asignaOblSol) {
		this.asignaOblSol = asignaOblSol;
	}
	public String getCobraAccesorios() {
		return cobraAccesorios;
	}
	public void setCobraAccesorios(String cobraAccesorios) {
		this.cobraAccesorios = cobraAccesorios;
	}
	public String getModalidadFOGAFI() {
		return modalidadFOGAFI;
	}
	public void setModalidadFOGAFI(String modalidadFOGAFI) {
		this.modalidadFOGAFI = modalidadFOGAFI;
	}
	public String getPorcentajeFOGAFI() {
		return porcentajeFOGAFI;
	}
	public void setPorcentajeFOGAFI(String porcentajeFOGAFI) {
		this.porcentajeFOGAFI = porcentajeFOGAFI;
	}
	public String getMontoFOGAFI() {
		return montoFOGAFI;
	}
	public void setMontoFOGAFI(String montoFOGAFI) {
		this.montoFOGAFI = montoFOGAFI;
	}
	public String getCobertura() {
		return cobertura;
	}
	public void setCobertura(String cobertura) {
		this.cobertura = cobertura;
	}
	public String getPrima() {
		return prima;
	}
	public void setPrima(String prima) {
		this.prima = prima;
	}
	public String getVigencia() {
		return vigencia;
	}
	public void setVigencia(String vigencia) {
		this.vigencia = vigencia;
	}
	public String getNumDiasVenPrimAmor() {
		return numDiasVenPrimAmor;
	}
	public void setNumDiasVenPrimAmor(String numDiasVenPrimAmor) {
		this.numDiasVenPrimAmor = numDiasVenPrimAmor;
	}
	public String getDiasReqPrimerAmor() {
		return diasReqPrimerAmor;
	}
	public void setDiasReqPrimerAmor(String diasReqPrimerAmor) {
		this.diasReqPrimerAmor = diasReqPrimerAmor;
	}
	public String getValorParametro() {
		return valorParametro;
	}
	public void setValorParametro(String valorParametro) {
		this.valorParametro = valorParametro;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getFolioSolici() {
		return folioSolici;
	}
	public void setFolioSolici(String folioSolici) {
		this.folioSolici = folioSolici;
	}
	public String getQuinquenioID() {
		return quinquenioID;
	}
	public void setQuinquenioID(String quinquenioID) {
		this.quinquenioID = quinquenioID;
	}

	public String getDescripcionConvenio() {
		return descripcionConvenio;
	}
	public void setDescripcionConvenio(String descripcionConvenio) {
		this.descripcionConvenio = descripcionConvenio;
	}
	public String getNombreInstit() {
		return nombreInstit;
	}
	public void setNombreInstit(String nombreInstit) {
		this.nombreInstit = nombreInstit;
	}
	public String getNoEmpleado() {
		return noEmpleado;
	}
	public void setNoEmpleado(String noEmpleado) {
		this.noEmpleado = noEmpleado;
	}
	public String getTipoEmpleado() {
		return tipoEmpleado;
	}
	public void setTipoEmpleado(String tipoEmpleado) {
		this.tipoEmpleado = tipoEmpleado;
	}
	public String getCapacidadPago() {
		return capacidadPago;
	}
	public void setCapacidadPago(String capacidadPago) {
		this.capacidadPago = capacidadPago;
	}
	public String getManejaCapPago() {
		return manejaCapPago;
	}
	public void setManejaCapPago(String manejaCapPago) {
		this.manejaCapPago = manejaCapPago;
	}
	public String getPorcentajeCapacidad() {
		return porcentajeCapacidad;
	}
	public void setPorcentajeCapacidad(String porcentajeCapacidad) {
		this.porcentajeCapacidad = porcentajeCapacidad;
	}
	public String getResguardo() {
		return resguardo;
	}
	public void setResguardo(String resguardo) {
		this.resguardo = resguardo;
	}
	public String getClabeDomiciliacion() {
		return clabeDomiciliacion;
	}
	public void setClabeDomiciliacion(String clabeDomiciliacion) {
		this.clabeDomiciliacion = clabeDomiciliacion;
	}
	public String getMotivoRechazoID() {
		return motivoRechazoID;
	}
	public void setMotivoRechazoID(String motivoRechazoID) {
		this.motivoRechazoID = motivoRechazoID;
	}
	public String getDescripcionMotivo() {
		return descripcionMotivo;
	}
	public void setDescripcionMotivo(String descripcionMotivo) {
		this.descripcionMotivo = descripcionMotivo;
	}
	public String getMotivoDevolucionID() {
		return motivoDevolucionID;
	}
	public void setMotivoDevolucionID(String motivoDevolucionID) {
		this.motivoDevolucionID = motivoDevolucionID;
	}
	public String getFechaIniCre() {
		return fechaIniCre;
	}
	public void setFechaIniCre(String fechaIniCre) {
		this.fechaIniCre = fechaIniCre;
	}
	public String getFechaVenCre() {
		return fechaVenCre;
	}
	public void setFechaVenCre(String fechaVenCre) {
		this.fechaVenCre = fechaVenCre;
	}
	public String getServiciosAdicionales() {
		return serviciosAdicionales;
	}
	public void setServiciosAdicionales(String serviciosAdicionales) {
		this.serviciosAdicionales = serviciosAdicionales;
	}
	public List getListaServiciosAdicionales() {
		return listaServiciosAdicionales;
	}
	public void setListaServiciosAdicionales(List listaServiciosAdicionales) {
		this.listaServiciosAdicionales = listaServiciosAdicionales;
	}
	public String getAplicaDescServicio() {
		return aplicaDescServicio;
	}
	public void setAplicaDescServicio(String aplicaDescServicio) {
		this.aplicaDescServicio = aplicaDescServicio;
	}
	public String getTipoCtaSantander() {
		return tipoCtaSantander;
	}
	public void setTipoCtaSantander(String tipoCtaSantander) {
		this.tipoCtaSantander = tipoCtaSantander;
	}
	public String getCtaSantander() {
		return ctaSantander;
	}
	public void setCtaSantander(String ctaSantander) {
		this.ctaSantander = ctaSantander;
	}
	public String getCtaClabeDisp() {
		return ctaClabeDisp;
	}
	public void setCtaClabeDisp(String ctaClabeDisp) {
		this.ctaClabeDisp = ctaClabeDisp;
	}

	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getEsConsolidadoAgro() {
		return esConsolidadoAgro;
	}
	public void setEsConsolidadoAgro(String esConsolidadoAgro) {
		this.esConsolidadoAgro = esConsolidadoAgro;
	}
	public String getDeudorOriginalID() {
		return deudorOriginalID;
	}
	public void setDeudorOriginalID(String deudorOriginalID) {
		this.deudorOriginalID = deudorOriginalID;
	}
	public String getIdentificacion() {
		return identificacion;
	}
	public void setIdentificacion(String identificacion) {
		this.identificacion = identificacion;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getCuentaAhorro() {
		return cuentaAhorro;
	}
	public void setCuentaAhorro(String cuentaAhorro) {
		this.cuentaAhorro = cuentaAhorro;
	}
	public String getLineaCreditoID() {
		return lineaCreditoID;
	}
	public void setLineaCreditoID(String lineaCreditoID) {
		this.lineaCreditoID = lineaCreditoID;
	}
	public String getManejaComAdmon() {
		return manejaComAdmon;
	}
	public void setManejaComAdmon(String manejaComAdmon) {
		this.manejaComAdmon = manejaComAdmon;
	}
	public String getForPagComAdmon() {
		return forPagComAdmon;
	}
	public void setForPagComAdmon(String forPagComAdmon) {
		this.forPagComAdmon = forPagComAdmon;
	}
	public String getPorcentajeComAdmon() {
		return porcentajeComAdmon;
	}
	public void setPorcentajeComAdmon(String porcentajeComAdmon) {
		this.porcentajeComAdmon = porcentajeComAdmon;
	}
	public String getManejaComGarantia() {
		return manejaComGarantia;
	}
	public void setManejaComGarantia(String manejaComGarantia) {
		this.manejaComGarantia = manejaComGarantia;
	}
	public String getForPagComGarantia() {
		return forPagComGarantia;
	}
	public void setForPagComGarantia(String forPagComGarantia) {
		this.forPagComGarantia = forPagComGarantia;
	}
	public String getPorcentajeComGarantia() {
		return porcentajeComGarantia;
	}
	public void setPorcentajeComGarantia(String porcentajeComGarantia) {
		this.porcentajeComGarantia = porcentajeComGarantia;
	}
	public String getComAdmonLinPrevLiq() {
		return comAdmonLinPrevLiq;
	}
	public void setComAdmonLinPrevLiq(String comAdmonLinPrevLiq) {
		this.comAdmonLinPrevLiq = comAdmonLinPrevLiq;
	}
	public String getComGarLinPrevLiq() {
		return comGarLinPrevLiq;
	}
	public void setComGarLinPrevLiq(String comGarLinPrevLiq) {
		this.comGarLinPrevLiq = comGarLinPrevLiq;
	}
	public String getMontoPagComAdmon() {
		return montoPagComAdmon;
	}
	public void setMontoPagComAdmon(String montoPagComAdmon) {
		this.montoPagComAdmon = montoPagComAdmon;
	}
	public String getMontoCobComAdmon() {
		return montoCobComAdmon;
	}
	public void setMontoCobComAdmon(String montoCobComAdmon) {
		this.montoCobComAdmon = montoCobComAdmon;
	}
	public String getMontoPagComGarantia() {
		return montoPagComGarantia;
	}
	public void setMontoPagComGarantia(String montoPagComGarantia) {
		this.montoPagComGarantia = montoPagComGarantia;
	}
	public String getMontoCobComGarantia() {
		return montoCobComGarantia;
	}
	public void setMontoCobComGarantia(String montoCobComGarantia) {
		this.montoCobComGarantia = montoCobComGarantia;
	}
}