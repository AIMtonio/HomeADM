package credito.bean;

import general.bean.BaseBean;

import java.util.List;
public class CreditosBean extends BaseBean{
	public static int LONGITUD_ID = 10;
	public static int  ReporPantalla= 1 ;
	public static int  ReporPDF= 2 ;
	public static int  ReporExcel= 3 ;
	public static String  Efectivo = "E";	
	public static String  CargoaCuenta = "C";
	public static String  creditoNuevo = "N";

	private String creditoID;
	private String lineaCreditoID;
	private String clienteID;

	private String descripcion;

	private String cuentaID;
	private String monedaID;
	private String producCreditoID;
	private String destinoCreID;
	private String montoCredito;
	private String TipoCredito;
	private String relacionado;
	private String solicitudCreditoID;
	private String tipoFondeo;
	private String institFondeoID;
	private String lineaFondeo;
	private String fechaInicio;
	private String fechaVencimien;
	private String calcInteresID;
	private String tasaBase;
	private String tasaFija;
	private String sobreTasa;
	private String pisoTasa;
	private String techoTasa;
	private String factorMora;
	private String frecuenciaCap;
	private String periodicidadCap;
	private String frecuenciaInt;
	private String periodicidadInt;
	private String tipoPagoCapital;
	private String numAmortizacion;
	private String montoCuota;
	private String fechTraspasVenc;
	private String fechTerminacion;
	private String IVAInteres;
	private String IVAComisiones;
	private String estatus;
	private String fechaAutoriza;
	private String usuarioAutoriza;
	private String saldoCapVigent;
	private String saldoCapAtrasad;
	private String saldoCapVencido;
	private String saldCapVenNoExi;
	private String saldoInterOrdin;
	private String saldoInterAtras;
	private String saldoInterVenc;
	private String saldoInterProvi;
	private String saldoIntNoConta;
	private String saldoIVAInteres;
	private String saldoMoratorios;
	private String saldoIVAMorator;
	private String saldoComFaltPago;
	private String salIVAComFalPag;
	private String saldoOtrasComis;
	private String saldoIVAComisi;
	private String saldNotasCargo;
	private String adeudoTotal;///<Totales>
	private String pagoExigible;
	private String totalCapital;
	private String totalInteres;
	private String totalComisi;
	private String totalIVACom;//</Totales>
	private String pagareImpreso;
	private String fechaInhabil;
	private String calendIrregular;
	private String diaPagoInteres;
	private String diaPagoCapital;
	private String ajusFecUlVenAmo;
	private String diaMesInteres;
	private String diaMesCapital;
	private String ajusFecExiVen;
	private String numTransacSim;
	private String fechaMinistrado;
	private String accesorios;
	private String interesAccesorios;
	private String ivaInteresAccesorios;
	private String refPayCash;
	
	public String getAccesorios() {
		return accesorios;
	}

	public void setAccesorios(String accesorios) {
		this.accesorios = accesorios;
	}

	public String getInteresAccesorios() {
		return interesAccesorios;
	}

	public void setInteresAccesorios(String interesAccesorios) {
		this.interesAccesorios = interesAccesorios;
	}

	public String getIvaInteresAccesorios() {
		return ivaInteresAccesorios;
	}

	public void setIvaInteresAccesorios(String ivaInteresAccesorios) {
		this.ivaInteresAccesorios = ivaInteresAccesorios;
	}

	private String valorCat;
	private String descripcionCredito;
	private String saldoInteresVig;
	private String saldoIVAAtrasa;
	private String saldoIVAMorato;
	private String saldoIVAComFaltaP;
	
	private String fechaPago;          
	private String montoExigible;     
	private String totalAdeudoSinIva;
	private String numTransaccion;
	
	private String montoPagar; // Para la pantalla de pago de credito
	private String diasFaltaPago; // Para la pantalla de pago de credito y consulta de informacion de credito
	// para reporte de pantalla saldos de cartera
	private String promotorID;
	private String sexo;
	private String estadoID;
	private String municipioID;
	private String nombreCliente;
	private String aporteCliente;
	private String capVigenteExi;
	private String montoTotalExi;
	private String montoGLAho;
	private String montoGLInv;
	

	// atributos para tabla SALDOSCREDITOS utilizados en el reporte en excel  de saldos totales
	private String pasoCapAtraDia;
	private String pasoCapVenDia;
	private String pasoCapVNEDia;
	private String pasoIntAtraDia;
	private String pasoIntVenDia;
	private String capRegularizado;
	private String intOrdDevengado;
	private String intMorDevengado;
	private String comisiDevengado;
	private String pagoCapVigDia;
	private String pagoCapAtrDia;
	private String pagoCapVenDia;
	private String pagoCapVenNexDia;
	private String pagoIntOrdDia;
	private String pagoIntVenDia;
	private String pagoIntAtrDia;
	private String pagoIntCalNoCon;
	private String pagoComisiDia;
	private String pagoMoratorios;
	private String pagoIvaDia;
	private String intCondonadoDia;
	private String morCondonadoDia;
	private String intDevCtaOrden;
	private String capCondonadoDia;
	private String comAdmonPagDia;
	private String comCondonadoDia;
	private String desembolsosDia;
	private String montoComision;
	private String IVAComApertura;
	private String cat; 
	private String plazoID;
	private String tipoDispersion;
	private String tipoCalInteres;
	private String fechaCorte;

	private String sucursalID;

	private String grupoID;

	private String montoPorDesemb;
	private String montoDesemb;

	private String folioDispersion;

	private String numAmortInteres;
	private String ComAperPagado;
	private String clasiDestinCred;
	private String cicloGrupo;
	private String tipCobComMorato;
	// fin atributos

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;		

	private String  nombreSucursal ;
	private String  nombreMoneda ;
	private String  nombreProducto ;
	private String  nombreUsuario; 
	private String  nombrePromotor;
	private String  nombreGenero ;
	private String  nombreEstado;
	private String  nombreMunicipi;	
	private String  nombreInstitucion ; 
	private String  nivelDetalle;// Agrupado o Analitico
	private String 	seguroVidaPagado;
	private String 	montoSeguroVida;
	private String nombreGrupo;

	//auxiliar del bean
	private String creditoProductoMonto;
	private String forCobroComAper;
	private String totalComAper;
	private String totalDesembolso;
	private String montoRetDes;
	private String montoGLDepositado;
	private String montoPorcGL;
	private String montoGLSugerido;
	
	private String saldoAdmonComis;
	private String saldoIVAAdmonComisi;
	private String permiteFiniquito;
	private String clasificacion;
	
	// auxiliar
	private String diasAtraso;		// para los dias de atraso del credito
	private String atrasoInicial;		// para los dias de atraso del credito
	private String atrasoFinal;		// para los dias de atraso del credito
	//  auxiliar en pago de credito
	private String finiquito;
	private String prepago;
	private String formaPago;  //  E: Efectivo, C: Cargo a Cuenta	
	private String criterio;
	private String parFechaEmision;
	private String fechaProxPago; 
	//Auxiliar para mostrar comentarios en la Pantalla mesa de control Individual
	private String comentarioMesaControl;
	private String creditoProducto; // muestra concatenado el credito y el producto de credito
	private String totalAdeudo; // muestra el valor del total del adeudo del credito
	private String totalExigible; // muestra el valor del total exigible del credito
	
	// atributos para el seguro de vida
	private String formaComApertura;
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

	//variables para tomar el ciclo grupal o el del cliente para el calculo de la tasa fija
	private String esGrupal;
	private String tasaPonderaGru;
	private double totalExigibleDia;
	private double totalCuotaAdelantada;
	
	// variables para los requerimientos de cobranza
	private String telefonoInst;
	private String RFCInstit;
	private String requerimientoID;
	private String direccionInstit;
	private String gerenteSucursal;
	private String nombreCortoInst;
	
	// variables para complemetar el reporte analitico de cartera
	private String  fechaVencimiento; 
	private String  fechaUltAbonoCre;
	private String  saldoDispon;
	private String  saldoBloq;
	private String  fechaUltDepCta;

	// auxiliares en reporte de excel de pagorealizado
	private String nombrePromotorI;
	private String presentacion;
	private String nombreMuni;
	
	// atributo para el tipo de Dispersion por Spei
	private String cuentaCLABE;
	private String calificaCliente; // Se ocupa para la tasa tambien
	private String fechaSistema;
	private String adeudoTotalSinIVA;
	
	private String 		hora;
	private String 		fecha;
	private String 	proyeInt;
	private String credito_Descripcion_Monto;
	
	private String tipoPrepago;
	private List	lcreditos;
	private List	ltipoPrepago;
	private String moraVencido;
	private String moraCarVen;

	// Auxiliares en la consulta
	private String cuotasAtraso;
	private String ultCuotaPagada;
	private String fechaUltCuota;
	private String totalPrimerCuota;
	private String polizaID;
	
	private String fechaInicioAmor;
	private String diaPagoProd;
	
	private String conceptoID;
	private String concepto;
	private String altaEnPoliza;

	private String descuentoSeguro;
	private String montoSegOriginal;
	private String modalidadPagoID;
	private String proyecto;
	private String desDestinoCredito;
	private String fechaDeteccion;
	// Auxiliar para el reporte de Buro de Credito
	private String tiempoReporte;
	private String numRenovaciones;
	private String numReestructuras;
	private String horaVeri;
	private String institucionNominaID;
	private String nombreInstit; //Nombre de Institucion de Nomina
	private String folioCtrl;
	private String estatusSolici;
	private String origen;
	
	// Auxiliares Cinta Buro Credito 
	private String cinta;
	private String nombreArchivoRepCinta;
	
	public static String desembolsoCredito	= "50";				//Concepto Contable de Desembolso de Credito (CONCEPTOSCONTA)
	public static String desDesembolsoCredito 	= "DESEMBOLSO DE CREDITO";
	public static String pagoCredito	= "54";				//Concepto Contable Pago de Credito (CONCEPTOSCONTA)
	public static String desPagoCredito = "PAGO DE CREDITO";
	public static String cambioFondeo	= "908";				//Concepto Contable de Desembolso de Credito (CONCEPTOSCONTA)
	public static String desCambioFondeo = "CAMBIO FUENTE DE FONDEO";
	// Auxiliares reportes
	private String formula;
	private String calcInteres;
	private String leyendaTasaVariable;
	
	//Cinta Buro de Credito
	private String tipoPersona;
	//Campos de la tabla para lo de seguros por cuota
	private String montoSeguroCuota;
	private String iVASeguroCuota;
	private String cobraSeguroCuota;	
	private String cobraIVASeguroCuota;
	private String saldoSeguroCuota;
	private String saldoIVASeguroCuota;
	private String totalSeguroCuota;
	private String totalCreditos;
	
	private String empresaNomina;
	
	// Comentario que emite la Mesa de Control
	private String comentarioCond;
	private String estCondicionado;
	
	// Comentario que se emiten por la Cancelación del Crédito
	private String comentarioCred;
	
	// Almacena si ya existe el registro de comentarios en la tabla
	private String numRegistros;
	
	private String comentarioAlt;	// Comentario que se emite en el Alta de Credito
	private String estatusCred;
	private String idenCreditoCNBV;
	private String folioFondeo;	// Folio del Fondeador
	private String saldoComAnual; //Comision de anualidad de crédito
	private String saldoComAnualIVA;//IVA Comision de anualidad de crédito
	
	private String tipoCobro;	// Cobro Com. Cargo a Cta. I:Individual , M:Masivo
	private String montoComApertura;
	private String otrasComAnt; // Otras Comisiones Anticipadas
	private String otrasComAntIVA; // IVA Otras Comisiones Anticipadas

	private String IVAComisionApert;
	private String tipoComision;	//Tipo de Comisión Individual
	private String tipoComisionM;	// Tipo de Comisión Masivo
	
	private String comFaltaPago;
	private String comSeguroCuota;
	private String comAperturaCred;
	private String comAnual;
	private String comAnualLin;

	private String nomCuenta;
	private String totalComAp;

	private List lcuentas;
	private List lcomFaltaPago;
	private List lcomSeguroCuota;
	private List lcomAperturaCred;
	
	//tipo de consulta SIC
	private String tipoConsultaSICBuro;
	private String tipoConsultaSICCirculo;
	private String tipoConsultaSIC;
	private String folioConsultaBC;
	private String folioConsultaCC;
	
	private String tipoGarantiaFIRA;
	
	private String prospectoID;
	/*CREDITOS AGROPECUARIOS*/
	private String detalleMinistraAgro;
	private String esAgropecuario;
	private String cadenaProductivaID;
	private String ramaFIRAID;
	private String subramaFIRAID;
	private String actividadFIRAID;
	private String tipoGarantiaFIRAID;
	private String progEspecialFIRAID;
	private String tipoCancelacion;
	private String fuenteFondeo;
	private String tipoDesbloqueo;
	private String contrasenia;
	private String usuarioID;
	private String institFondeoIDN;
	private String lineaFondeoN;
	private String tasaPasiva;
	private String montoMinisPen; 
	private String creditoR;
	private String creditoRC;
	private String saldoCapContingente;
	private String saldoIntContingente;
	private String tipoOperacionFIRA;
	private String estatusGarantiaFIRA;
	private String creditoIDFIRA;
	private String acreditadoIDFIRA;
	/*FIN CREDITOS AGROPECUARIOS*/

	// Cobro de comision por apertura
	private String fechaCobroComision;
	
	/* CREDITOS AUTOMATICOS*/
	 private String esAutomatico; 
	 private String tipoAutomatico;
	 private String inversionID;
	 private String cuentaAhoID;
	 private String cobranzaCierre;
	 
	/*FIN CREDITOS AUTOMATICOS */

	 /*REPORTE ANALITICO DE CARTERA AGRO*/
	 private String destinoCredID;
	 private String desDestino;
	 private String creditoFondeoID;
	 private String tipoGarantia;
	 private String claseCredito;
	 private String cveRamaFIRA;
	 private String descripcionRamaFIRA;
	 private String fechaOtorgamiento;
	 private String fechaProxVenc;
	 private String montoProxVenc;
	 private String actividadDes;
	 private String cveCadena;
	 private String nomCadenaProdSCIAN;
	 private String subPrograma;
	 private String porcComision;
	 private String conceptoInv;
	 private String numeroUnidades;
	 private String unidadesMedida;
	 private String saldoCapVigentePas;
	 private String saldoCapAtrasadPas;
	 private String saldoInteresProPas;
	 private String saldoInteresAtraPas;
	 /**/

	 
	 /* RIESGO COMUN */
	 private String saldoInsolutoCartera;
	 private String sumatoriaCreditos; 
	  
	  /*FIN RIESGO COMUN*/
	 
	 private String esReacreditado;
	/*Cancelacion de creditos*/
	public static String	CANCELACION_CREDITO				= "67";						// Concepto Contable de Desembolso de Credito (CONCEPTOSCONTA)
	public static String	DESCRIPCION_CANCELACION_CRED	= "CANCELACION DE CREDITO";	// Concepto Contable de Desembolso de Credito (CONCEPTOSCONTA)
	private String			detalleCancelaCred;
	private String			fechaFinal;
	private String			fechaCancel;
	private String			motivoCancel;
	private String			numProducCre;
	/* Condonacion masiva */
	private String			fechaCondona;
	private String			rutaArchivoFinal;
	/* Castigo masivo */
	private String 			motivoCastigoID;
	/* REPORTES CNBV */
	private String nombreCompleto;
	private String CURP;
	private String fechaUltPagoCap;
	private String montoUltPagoCap;
	private String fechaUltPagoInt;
	private String montoUltPagoInt;
	private String fechaPrimerAmortCub;
	private String interesVencido;
	private String interesMoratorio;
	private String interesRefinanciado;
	private String tipoAcreditadoRel;
	private String montoEPRC;
	private String fechaConsultaSIC;
	private String tipoCobranza;
	private String renglon;
	private String montoCastigo;
	private String montoCondonacion;
	private String fechaCastigo;
	private String fechaInicioRep;
	private String fechaFinRep;
	
	private String anio;
	private String mes;
	private String referenciaPago;
	private String saldoReferencia;
	private String saldoPago;
	private String totalMoratorios;
	private String totalIVA;
	private String totalPago;
	
	private String cobraAccesorios;
	private String cobraAccesoriosGen;
	private String tipoOpera;
	private String accesorioID;
	private String cicloCliente;
	
	private String modalidadFOGAFI;
	private String porcentajeFOGAFI;
	private String montoFOGAFI;
	private String simulado;
	private String montoModificado;
	
	private String PasivoID;
	private String AdeudoPasivo;
	private String convenioNominaID;
	private String estatusNomina;
	private String desConvenio;
	
	/*Num de lista a ejecutar en el sp*/
	private String numLista;
	
	private String folioSolici;
	private String quinquenioID;
	private String esNomina;
	private String capacidadPago;
	private String clabeDomiciliacion;
	private String manejaConvenio;
	private String esproducNomina;
	private String desClasificacion;
	private String desGenero;
	
	//Reporte de Operaciones Basica de Unidad
	private String fechaFin;
	private String totalClientes;
	private String totalCtesNuevos;
	private String totalCtesRenovacion;
	private String totalCtesCorte;
	private String totalCtesPagos;
	private String totalCtesNoPagos;
	private String totalCtesPrepagos;
	private String saldoInicialCaja;
	private String saldoEsperadoCartera;
	private String saldoCartera;
	private String saldoRecaudoPrepago;
	private String porcentajeRecaudo;
	private String porcentajePretendido;
	private String saldoTotalCreditos;
	private String saldoGastosDia;
	private String coordinadorID;
	private String nombreCoordinador;
	private String tipoUsuario;
	private String totalCteCreditos;

	//Ajustes Cinta de Buro INTL
	private String tipoFormatoCinta;
	private String headerINTL;

	private String nombreInstitFon;
	private String descripLinea;
	private String folioPasivo;
	
	//Auxiliares para Servicios adicionales
	private String serviciosAdicionales;
	private String aplicaDescServicio;
	
	
	private String origenPago;
	
	private String fechaNacimiento;
	private String digVerificador;
	/* FIN REPORTES CNBV */
	
	// Proyeccion Cuotas Completas
	private String cuotasProyectadas;
	private String esConsolidacionAgro;
	
	private String saldoNotasCargos;

	// Inicio Notas Cargo
	private String domiciliacionPagos;
	private String notasCargo;
	private String ivaNotasCargo;
	// Fin Notas Cargo
	//Notas de Cargo
	private String saldoNotasCargo;
	
	//FlujoOrigen
	private String flujoOrigen;
		
	private String institucionBanorte;
	private String institucionTelecom;
	private String referenciaBanorte;
	private String referenciaTelecom;
	
	// Lineas de Crédito Agro
	private String manejaComAdmon;
	private String comAdmonLinPrevLiq;
	private String forCobComAdmon;
	private String forPagComAdmon;
	private String porcentajeComAdmon;
	private String montoPagComAdmon;
	private String montoCobComAdmon;
	
	private String manejaComGarantia;
	private String forCobComGarantia;
	private String forPagComGarantia;
	private String porcentajeComGarantia;
	private String comGarLinPrevLiq;
	private String montoPagComGarantia;
	private String montoCobComGarantia;

	private String montoPagComGarantiaSim;
	private String ministracionID;
	private String transaccionID;

	public String getFlujoOrigen() {
		return flujoOrigen;
	}

	public void setFlujoOrigen(String flujoOrigen) {
		this.flujoOrigen = flujoOrigen;
	}

	public String getTipoGarantiaFIRA() {
		return tipoGarantiaFIRA;
	}
	
	public void setTipoGarantiaFIRA(String tipoGarantiaFIRA) {
		this.tipoGarantiaFIRA = tipoGarantiaFIRA;
	}
	public String getEstatusSolici() {
		return estatusSolici;
	}
	public void setEstatusSolici(String estatusSolici) {
		this.estatusSolici = estatusSolici;
	}
	public String getFolioCtrl() {
		return folioCtrl;
	}
	public void setFolioCtrl(String folioCtrl) {
		this.folioCtrl = folioCtrl;
	}
	public String getInstitucionNominaID() {
		return institucionNominaID;
	}
	public void setInstitucionNominaID(String institucionNominaID) {
		this.institucionNominaID = institucionNominaID;
	}
	public String getHoraVeri() {
		return horaVeri;
	}
	public void setHoraVeri(String horaVeri) {
		this.horaVeri = horaVeri;
	}
	public String getNumRenovaciones() {
		return numRenovaciones;
	}
	public void setNumRenovaciones(String numRenovaciones) {
		this.numRenovaciones = numRenovaciones;
	}
	public String getTipoCredito() {
		return TipoCredito;
	}
	public void setTipoCredito(String tipoCredito) {
		TipoCredito = tipoCredito;
	}
	public String getFechaInicioAmor() {
		return fechaInicioAmor;
	}
	public void setFechaInicioAmor(String fechaInicioAmor) {
		this.fechaInicioAmor = fechaInicioAmor;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}


	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}

	public static int getReporPantalla() {
		return ReporPantalla;
	}
	public static void setReporPantalla(int reporPantalla) {
		ReporPantalla = reporPantalla;
	}
	public static int getReporPDF() {
		return ReporPDF;
	}
	public static void setReporPDF(int reporPDF) {
		ReporPDF = reporPDF;
	}
	public static int getReporExcel() {
		return ReporExcel;
	}
	public static void setReporExcel(int reporExcel) {
		ReporExcel = reporExcel;
	}
	public static String getEfectivo() {
		return Efectivo;
	}
	public static void setEfectivo(String efectivo) {
		Efectivo = efectivo;
	}
	public static String getCargoaCuenta() {
		return CargoaCuenta;
	}
	public static void setCargoaCuenta(String cargoaCuenta) {
		CargoaCuenta = cargoaCuenta;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getLineaCreditoID() {
		return lineaCreditoID;
	}
	public void setLineaCreditoID(String lineaCreditoID) {
		this.lineaCreditoID = lineaCreditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaID() {
		return cuentaID;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getDestinoCreID() {
		return destinoCreID;
	}
	public void setDestinoCreID(String destinoCreID) {
		this.destinoCreID = destinoCreID;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public String getRelacionado() {
		return relacionado;
	}
	public void setRelacionado(String relacionado) {
		this.relacionado = relacionado;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getTipoFondeo() {
		return tipoFondeo;
	}
	public void setTipoFondeo(String tipoFondeo) {
		this.tipoFondeo = tipoFondeo;
	}
	public String getInstitFondeoID() {
		return institFondeoID;
	}
	public void setInstitFondeoID(String institFondeoID) {
		this.institFondeoID = institFondeoID;
	}
	public String getLineaFondeo() {
		return lineaFondeo;
	}
	public void setLineaFondeo(String lineaFondeo) {
		this.lineaFondeo = lineaFondeo;
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
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getSobreTasa() {
		return sobreTasa;
	}
	public void setSobreTasa(String sobreTasa) {
		this.sobreTasa = sobreTasa;
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
	public String getTipoPagoCapital() {
		return tipoPagoCapital;
	}
	public void setTipoPagoCapital(String tipoPagoCapital) {
		this.tipoPagoCapital = tipoPagoCapital;
	}
	public String getNumAmortizacion() {
		return numAmortizacion;
	}
	public void setNumAmortizacion(String numAmortizacion) {
		this.numAmortizacion = numAmortizacion;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public String getFechTraspasVenc() {
		return fechTraspasVenc;
	}
	public void setFechTraspasVenc(String fechTraspasVenc) {
		this.fechTraspasVenc = fechTraspasVenc;
	}
	public String getFechTerminacion() {
		return fechTerminacion;
	}
	public void setFechTerminacion(String fechTerminacion) {
		this.fechTerminacion = fechTerminacion;
	}
	public String getIVAInteres() {
		return IVAInteres;
	}
	public void setIVAInteres(String iVAInteres) {
		IVAInteres = iVAInteres;
	}
	public String getIVAComisiones() {
		return IVAComisiones;
	}
	public void setIVAComisiones(String iVAComisiones) {
		IVAComisiones = iVAComisiones;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getSaldoCapVigent() {
		return saldoCapVigent;
	}
	public void setSaldoCapVigent(String saldoCapVigent) {
		this.saldoCapVigent = saldoCapVigent;
	}
	public String getSaldoCapAtrasad() {
		return saldoCapAtrasad;
	}
	public void setSaldoCapAtrasad(String saldoCapAtrasad) {
		this.saldoCapAtrasad = saldoCapAtrasad;
	}
	public String getSaldoCapVencido() {
		return saldoCapVencido;
	}
	public void setSaldoCapVencido(String saldoCapVencido) {
		this.saldoCapVencido = saldoCapVencido;
	}
	public String getSaldCapVenNoExi() {
		return saldCapVenNoExi;
	}
	public void setSaldCapVenNoExi(String saldCapVenNoExi) {
		this.saldCapVenNoExi = saldCapVenNoExi;
	}
	public String getSaldoInterOrdin() {
		return saldoInterOrdin;
	}
	public void setSaldoInterOrdin(String saldoInterOrdin) {
		this.saldoInterOrdin = saldoInterOrdin;
	}
	public String getSaldoInterAtras() {
		return saldoInterAtras;
	}
	public void setSaldoInterAtras(String saldoInterAtras) {
		this.saldoInterAtras = saldoInterAtras;
	}
	public String getSaldoInterVenc() {
		return saldoInterVenc;
	}
	public void setSaldoInterVenc(String saldoInterVenc) {
		this.saldoInterVenc = saldoInterVenc;
	}
	public String getSaldoInterProvi() {
		return saldoInterProvi;
	}
	public void setSaldoInterProvi(String saldoInterProvi) {
		this.saldoInterProvi = saldoInterProvi;
	}
	public String getSaldoIntNoConta() {
		return saldoIntNoConta;
	}
	public void setSaldoIntNoConta(String saldoIntNoConta) {
		this.saldoIntNoConta = saldoIntNoConta;
	}
	public String getSaldoIVAInteres() {
		return saldoIVAInteres;
	}
	public void setSaldoIVAInteres(String saldoIVAInteres) {
		this.saldoIVAInteres = saldoIVAInteres;
	}
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public String getSaldoIVAMorator() {
		return saldoIVAMorator;
	}
	public void setSaldoIVAMorator(String saldoIVAMorator) {
		this.saldoIVAMorator = saldoIVAMorator;
	}
	public String getSaldoComFaltPago() {
		return saldoComFaltPago;
	}
	public void setSaldoComFaltPago(String saldoComFaltPago) {
		this.saldoComFaltPago = saldoComFaltPago;
	}
	public String getSalIVAComFalPag() {
		return salIVAComFalPag;
	}
	public void setSalIVAComFalPag(String salIVAComFalPag) {
		this.salIVAComFalPag = salIVAComFalPag;
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
	public String getAdeudoTotal() {
		return adeudoTotal;
	}
	public void setAdeudoTotal(String adeudoTotal) {
		this.adeudoTotal = adeudoTotal;
	}
	public String getPagoExigible() {
		return pagoExigible;
	}
	public void setPagoExigible(String pagoExigible) {
		this.pagoExigible = pagoExigible;
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
	public String getPagareImpreso() {
		return pagareImpreso;
	}
	public void setPagareImpreso(String pagareImpreso) {
		this.pagareImpreso = pagareImpreso;
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
	public String getAjusFecUlVenAmo() {
		return ajusFecUlVenAmo;
	}
	public void setAjusFecUlVenAmo(String ajusFecUlVenAmo) {
		this.ajusFecUlVenAmo = ajusFecUlVenAmo;
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
	public String getFechaMinistrado() {
		return fechaMinistrado;
	}
	public void setFechaMinistrado(String fechaMinistrado) {
		this.fechaMinistrado = fechaMinistrado;
	}
	public String getMontoPagar() {
		return montoPagar;
	}
	public void setMontoPagar(String montoPagar) {
		this.montoPagar = montoPagar;
	}
	public String getDiasFaltaPago() {
		return diasFaltaPago;
	}
	public void setDiasFaltaPago(String diasFaltaPago) {
		this.diasFaltaPago = diasFaltaPago;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getAporteCliente() {
		return aporteCliente;
	}
	public void setAporteCliente(String aporteCliente) {
		this.aporteCliente = aporteCliente;
	}
	public String getPasoCapAtraDia() {
		return pasoCapAtraDia;
	}
	public void setPasoCapAtraDia(String pasoCapAtraDia) {
		this.pasoCapAtraDia = pasoCapAtraDia;
	}
	public String getPasoCapVenDia() {
		return pasoCapVenDia;
	}
	public void setPasoCapVenDia(String pasoCapVenDia) {
		this.pasoCapVenDia = pasoCapVenDia;
	}
	public String getPasoCapVNEDia() {
		return pasoCapVNEDia;
	}
	public void setPasoCapVNEDia(String pasoCapVNEDia) {
		this.pasoCapVNEDia = pasoCapVNEDia;
	}
	public String getPasoIntAtraDia() {
		return pasoIntAtraDia;
	}
	public void setPasoIntAtraDia(String pasoIntAtraDia) {
		this.pasoIntAtraDia = pasoIntAtraDia;
	}
	public String getPasoIntVenDia() {
		return pasoIntVenDia;
	}
	public void setPasoIntVenDia(String pasoIntVenDia) {
		this.pasoIntVenDia = pasoIntVenDia;
	}
	public String getCapRegularizado() {
		return capRegularizado;
	}
	public void setCapRegularizado(String capRegularizado) {
		this.capRegularizado = capRegularizado;
	}
	public String getIntOrdDevengado() {
		return intOrdDevengado;
	}
	public void setIntOrdDevengado(String intOrdDevengado) {
		this.intOrdDevengado = intOrdDevengado;
	}
	public String getIntMorDevengado() {
		return intMorDevengado;
	}
	public void setIntMorDevengado(String intMorDevengado) {
		this.intMorDevengado = intMorDevengado;
	}
	public String getComisiDevengado() {
		return comisiDevengado;
	}
	public void setComisiDevengado(String comisiDevengado) {
		this.comisiDevengado = comisiDevengado;
	}
	public String getPagoCapVigDia() {
		return pagoCapVigDia;
	}
	public void setPagoCapVigDia(String pagoCapVigDia) {
		this.pagoCapVigDia = pagoCapVigDia;
	}
	public String getPagoCapAtrDia() {
		return pagoCapAtrDia;
	}
	public void setPagoCapAtrDia(String pagoCapAtrDia) {
		this.pagoCapAtrDia = pagoCapAtrDia;
	}
	public String getPagoCapVenDia() {
		return pagoCapVenDia;
	}
	public void setPagoCapVenDia(String pagoCapVenDia) {
		this.pagoCapVenDia = pagoCapVenDia;
	}
	public String getPagoCapVenNexDia() {
		return pagoCapVenNexDia;
	}
	public void setPagoCapVenNexDia(String pagoCapVenNexDia) {
		this.pagoCapVenNexDia = pagoCapVenNexDia;
	}
	public String getPagoIntOrdDia() {
		return pagoIntOrdDia;
	}
	public void setPagoIntOrdDia(String pagoIntOrdDia) {
		this.pagoIntOrdDia = pagoIntOrdDia;
	}
	public String getPagoIntVenDia() {
		return pagoIntVenDia;
	}
	public void setPagoIntVenDia(String pagoIntVenDia) {
		this.pagoIntVenDia = pagoIntVenDia;
	}
	public String getPagoIntAtrDia() {
		return pagoIntAtrDia;
	}
	public void setPagoIntAtrDia(String pagoIntAtrDia) {
		this.pagoIntAtrDia = pagoIntAtrDia;
	}
	public String getPagoIntCalNoCon() {
		return pagoIntCalNoCon;
	}
	public void setPagoIntCalNoCon(String pagoIntCalNoCon) {
		this.pagoIntCalNoCon = pagoIntCalNoCon;
	}
	public String getPagoComisiDia() {
		return pagoComisiDia;
	}
	public void setPagoComisiDia(String pagoComisiDia) {
		this.pagoComisiDia = pagoComisiDia;
	}
	public String getPagoMoratorios() {
		return pagoMoratorios;
	}
	public void setPagoMoratorios(String pagoMoratorios) {
		this.pagoMoratorios = pagoMoratorios;
	}
	public String getPagoIvaDia() {
		return pagoIvaDia;
	}
	public void setPagoIvaDia(String pagoIvaDia) {
		this.pagoIvaDia = pagoIvaDia;
	}
	public String getIntCondonadoDia() {
		return intCondonadoDia;
	}
	public void setIntCondonadoDia(String intCondonadoDia) {
		this.intCondonadoDia = intCondonadoDia;
	}
	public String getMorCondonadoDia() {
		return morCondonadoDia;
	}
	public void setMorCondonadoDia(String morCondonadoDia) {
		this.morCondonadoDia = morCondonadoDia;
	}
	public String getMontoComision() {
		return montoComision;
	}
	public void setMontoComision(String montoComision) {
		this.montoComision = montoComision;
	}
	public String getIVAComApertura() {
		return IVAComApertura;
	}
	public void setIVAComApertura(String iVAComApertura) {
		IVAComApertura = iVAComApertura;
	}
	public String getCat() {
		return cat;
	}
	public void setCat(String cat) {
		this.cat = cat;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getTipoDispersion() {
		return tipoDispersion;
	}
	public void setTipoDispersion(String tipoDispersion) {
		this.tipoDispersion = tipoDispersion;
	}
	public String getTipoCalInteres() {
		return tipoCalInteres;
	}
	public void setTipoCalInteres(String tipoCalInteres) {
		this.tipoCalInteres = tipoCalInteres;
	}
	public String getFechaCorte() {
		return fechaCorte;
	}
	public void setFechaCorte(String fechaCorte) {
		this.fechaCorte = fechaCorte;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getMontoPorDesemb() {
		return montoPorDesemb;
	}
	public void setMontoPorDesemb(String montoPorDesemb) {
		this.montoPorDesemb = montoPorDesemb;
	}
	public String getMontoDesemb() {
		return montoDesemb;
	}
	public void setMontoDesemb(String montoDesemb) {
		this.montoDesemb = montoDesemb;
	}
	public String getFolioDispersion() {
		return folioDispersion;
	}
	public void setFolioDispersion(String folioDispersion) {
		this.folioDispersion = folioDispersion;
	}
	public String getNumAmortInteres() {
		return numAmortInteres;
	}
	public void setNumAmortInteres(String numAmortInteres) {
		this.numAmortInteres = numAmortInteres;
	}
	public String getComAperPagado() {
		return ComAperPagado;
	}
	public void setComAperPagado(String comAperPagado) {
		ComAperPagado = comAperPagado;
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
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombreMoneda() {
		return nombreMoneda;
	}
	public void setNombreMoneda(String nombreMoneda) {
		this.nombreMoneda = nombreMoneda;
	}
	public String getNombreProducto() {
		return nombreProducto;
	}
	public void setNombreProducto(String nombreProducto) {
		this.nombreProducto = nombreProducto;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public String getNombreGenero() {
		return nombreGenero;
	}
	public void setNombreGenero(String nombreGenero) {
		this.nombreGenero = nombreGenero;
	}
	public String getNombreEstado() {
		return nombreEstado;
	}
	public void setNombreEstado(String nombreEstado) {
		this.nombreEstado = nombreEstado;
	}
	public String getNombreMunicipi() {
		return nombreMunicipi;
	}
	public void setNombreMunicipi(String nombreMunicipi) {
		this.nombreMunicipi = nombreMunicipi;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNivelDetalle() {
		return nivelDetalle;
	}
	public void setNivelDetalle(String nivelDetalle) {
		this.nivelDetalle = nivelDetalle;
	}
	public String getSeguroVidaPagado() {
		return seguroVidaPagado;
	}
	public void setSeguroVidaPagado(String seguroVidaPagado) {
		this.seguroVidaPagado = seguroVidaPagado;
	}
	public String getMontoSeguroVida() {
		return montoSeguroVida;
	}
	public void setMontoSeguroVida(String montoSeguroVida) {
		this.montoSeguroVida = montoSeguroVida;
	}
	public String getCreditoProductoMonto() {
		return creditoProductoMonto;
	}
	public void setCreditoProductoMonto(String creditoProductoMonto) {
		this.creditoProductoMonto = creditoProductoMonto;
	}
	public String getForCobroComAper() {
		return forCobroComAper;
	}
	public void setForCobroComAper(String forCobroComAper) {
		this.forCobroComAper = forCobroComAper;
	}
	public String getTotalComAper() {
		return totalComAper;
	}
	public void setTotalComAper(String totalComAper) {
		this.totalComAper = totalComAper;
	}
	public String getTotalDesembolso() {
		return totalDesembolso;
	}
	public void setTotalDesembolso(String totalDesembolso) {
		this.totalDesembolso = totalDesembolso;
	}
	public String getMontoRetDes() {
		return montoRetDes;
	}
	public void setMontoRetDes(String montoRetDes) {
		this.montoRetDes = montoRetDes;
	}
	public String getMontoGLDepositado() {
		return montoGLDepositado;
	}
	public void setMontoGLDepositado(String montoGLDepositado) {
		this.montoGLDepositado = montoGLDepositado;
	}
	public String getMontoPorcGL() {
		return montoPorcGL;
	}
	public void setMontoPorcGL(String montoPorcGL) {
		this.montoPorcGL = montoPorcGL;
	}
	public String getMontoGLSugerido() {
		return montoGLSugerido;
	}
	public void setMontoGLSugerido(String montoGLSugerido) {
		this.montoGLSugerido = montoGLSugerido;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public String getFiniquito() {
		return finiquito;
	}
	public void setFiniquito(String finiquito) {
		this.finiquito = finiquito;
	}
	public String getPrepago() {
		return prepago;
	}
	public void setPrepago(String prepago) {
		this.prepago = prepago;
	}
	public String getFormaPago() {
		return formaPago;
	}
	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}
	public String getCriterio() {
		return criterio;
	}
	public void setCriterio(String criterio) {
		this.criterio = criterio;
	}
	public String getParFechaEmision() {
		return parFechaEmision;
	}
	public void setParFechaEmision(String parFechaEmision) {
		this.parFechaEmision = parFechaEmision;
	}
	public String getComentarioMesaControl() {
		return comentarioMesaControl;
	}
	public void setComentarioMesaControl(String comentarioMesaControl) {
		this.comentarioMesaControl = comentarioMesaControl;
	}
	public String getCreditoProducto() {
		return creditoProducto;
	}
	public void setCreditoProducto(String creditoProducto) {
		this.creditoProducto = creditoProducto;
	}
	public String getTotalAdeudo() {
		return totalAdeudo;
	}
	public void setTotalAdeudo(String totalAdeudo) {
		this.totalAdeudo = totalAdeudo;
	}
	public String getTotalExigible() {
		return totalExigible;
	}
	public void setTotalExigible(String totalExigible) {
		this.totalExigible = totalExigible;
	}
	public String getFormaComApertura() {
		return formaComApertura;
	}
	public void setFormaComApertura(String formaComApertura) {
		this.formaComApertura = formaComApertura;
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
	public String getClasiDestinCred() {
		return clasiDestinCred;
	}
	public void setClasiDestinCred(String clasiDestinCred) {
		this.clasiDestinCred = clasiDestinCred;
	}
	public String getFechaProxPago() {
		return fechaProxPago;
	}
	public void setFechaProxPago(String fechaProxPago) {
		this.fechaProxPago = fechaProxPago;
	}
	public String getSaldoAdmonComis() {
		return saldoAdmonComis;
	}
	public void setSaldoAdmonComis(String saldoAdmonComis) {
		this.saldoAdmonComis = saldoAdmonComis;
	}
	public String getSaldoIVAAdmonComisi() {
		return saldoIVAAdmonComisi;
	}
	public void setSaldoIVAAdmonComisi(String saldoIVAAdmonComisi) {
		this.saldoIVAAdmonComisi = saldoIVAAdmonComisi;
	}
	public String getPermiteFiniquito() {
		return permiteFiniquito;
	}
	public void setPermiteFiniquito(String permiteFiniquito) {
		this.permiteFiniquito = permiteFiniquito;
	}
	public String getCicloGrupo() {
		return cicloGrupo;
	}
	public void setCicloGrupo(String cicloGrupo) {
		this.cicloGrupo = cicloGrupo;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public String getIntDevCtaOrden() {
		return intDevCtaOrden;
	}
	public void setIntDevCtaOrden(String intDevCtaOrden) {
		this.intDevCtaOrden = intDevCtaOrden;
	}
	public String getCapCondonadoDia() {
		return capCondonadoDia;
	}
	public void setCapCondonadoDia(String capCondonadoDia) {
		this.capCondonadoDia = capCondonadoDia;
	}
	public String getComAdmonPagDia() {
		return comAdmonPagDia;
	}
	public void setComAdmonPagDia(String comAdmonPagDia) {
		this.comAdmonPagDia = comAdmonPagDia;
	}
	public String getComCondonadoDia() {
		return comCondonadoDia;
	}
	public void setComCondonadoDia(String comCondonadoDia) {
		this.comCondonadoDia = comCondonadoDia;
	}
	public String getDesembolsosDia() {
		return desembolsosDia;
	}
	public void setDesembolsosDia(String desembolsosDia) {
		this.desembolsosDia = desembolsosDia;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	public double getTotalExigibleDia() {
		return totalExigibleDia;
	}
	public void setTotalExigibleDia(double totalExigibleDia) {
		this.totalExigibleDia = totalExigibleDia;
	}
	public double getTotalCuotaAdelantada() {
		return totalCuotaAdelantada;
	}
	public void setTotalCuotaAdelantada(double totalCuotaAdelantada) {
		this.totalCuotaAdelantada = totalCuotaAdelantada;
	}
	public String getTelefonoInst() {
		return telefonoInst;
	}
	public String getRFCInstit() {
		return RFCInstit;
	}
	public String getRequerimientoID() {
		return requerimientoID;
	}
	public String getDireccionInstit() {
		return direccionInstit;
	}
	public void setTelefonoInst(String telefonoInst) {
		this.telefonoInst = telefonoInst;
	}
	public void setRFCInstit(String rFCInstit) {
		RFCInstit = rFCInstit;
	}
	public void setRequerimientoID(String requerimientoID) {
		this.requerimientoID = requerimientoID;
	}
	public void setDireccionInstit(String direccionInstit) {
		this.direccionInstit = direccionInstit;
	}
	public String getGerenteSucursal() {
		return gerenteSucursal;
	}
	public void setGerenteSucursal(String gerenteSucursal) {
		this.gerenteSucursal = gerenteSucursal;
	}
	public String getNombreCortoInst() {
		return nombreCortoInst;
	}
	public void setNombreCortoInst(String nombreCortoInst) {
		this.nombreCortoInst = nombreCortoInst;
	}
	public String getAtrasoInicial() {
		return atrasoInicial;
	}
	public void setAtrasoInicial(String atrasoInicial) {
		this.atrasoInicial = atrasoInicial;
	}
	public String getAtrasoFinal() {
		return atrasoFinal;
	}
	public void setAtrasoFinal(String atrasoFinal) {
		this.atrasoFinal = atrasoFinal;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getFechaUltAbonoCre() {
		return fechaUltAbonoCre;
	}
	public void setFechaUltAbonoCre(String fechaUltAbonoCre) {
		this.fechaUltAbonoCre = fechaUltAbonoCre;
	}
	public String getSaldoDispon() {
		return saldoDispon;
	}
	public void setSaldoDispon(String saldoDispon) {
		this.saldoDispon = saldoDispon;
	}
	public String getSaldoBloq() {
		return saldoBloq;
	}
	public void setSaldoBloq(String saldoBloq) {
		this.saldoBloq = saldoBloq;
	}
	public String getFechaUltDepCta() {
		return fechaUltDepCta;
	}
	public void setFechaUltDepCta(String fechaUltDepCta) {
		this.fechaUltDepCta = fechaUltDepCta;
	}
	public String getNombrePromotorI() {
		return nombrePromotorI;
	}
	public void setNombrePromotorI(String nombrePromotorI) {
		this.nombrePromotorI = nombrePromotorI;
	}
	public String getPresentacion() {
		return presentacion;
	}
	public void setPresentacion(String presentacion) {
		this.presentacion = presentacion;
	}
	public String getNombreMuni() {
		return nombreMuni;
	}
	public void setNombreMuni(String nombreMuni) {
		this.nombreMuni = nombreMuni;
	}
	public String getCuentaCLABE() {
		return cuentaCLABE;
	}
	public void setCuentaCLABE(String cuentaCLABE) {
		this.cuentaCLABE = cuentaCLABE;
	}
	public String getCalificaCliente() {
		return calificaCliente;
	}
	public void setCalificaCliente(String calificaCliente) {
		this.calificaCliente = calificaCliente;
	}


	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	

	public String getAdeudoTotalSinIVA() {
		return adeudoTotalSinIVA;
	}
	public void setAdeudoTotalSinIVA(String adeudoTotalSinIVA) {
		this.adeudoTotalSinIVA = adeudoTotalSinIVA;
	}
	public String getProyeInt() {
		return proyeInt;
	}
	public void setProyeInt(String proyeInt) {
		this.proyeInt = proyeInt;
	}
	public String getCredito_Descripcion_Monto() {
		return credito_Descripcion_Monto;
	}
	public void setCredito_Descripcion_Monto(String credito_Descripcion_Monto) {
		this.credito_Descripcion_Monto = credito_Descripcion_Monto;
	}
	
	public String getCapVigenteExi() {
		return capVigenteExi;
	}
	public String getMontoTotalExi() {
		return montoTotalExi;
	}
	
	public void setCapVigenteExi(String capVigenteExi) {
		this.capVigenteExi = capVigenteExi;
	}
	public void setMontoTotalExi(String montoTotalExi) {
		this.montoTotalExi = montoTotalExi;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getMontoExigible() {
		return montoExigible;
	}
	public void setMontoExigible(String montoExigible) {
		this.montoExigible = montoExigible;
	}
	public String getValorCat() {
		return valorCat;
	}
	public void setValorCat(String valorCat) {
		this.valorCat = valorCat;
	}
	public String getDescripcionCredito() {
		return descripcionCredito;
	}
	public void setDescripcionCredito(String descripcionCredito) {
		this.descripcionCredito = descripcionCredito;
	}
	public String getSaldoInteresVig() {
		return saldoInteresVig;
	}
	public void setSaldoInteresVig(String saldoInteresVig) {
		this.saldoInteresVig = saldoInteresVig;
	}
	public String getSaldoIVAAtrasa() {
		return saldoIVAAtrasa;
	}
	public void setSaldoIVAAtrasa(String saldoIVAAtrasa) {
		this.saldoIVAAtrasa = saldoIVAAtrasa;
	}
	public String getSaldoIVAMorato() {
		return saldoIVAMorato;
	}
	public void setSaldoIVAMorato(String saldoIVAMorato) {
		this.saldoIVAMorato = saldoIVAMorato;
	}
	public String getSaldoIVAComFaltaP() {
		return saldoIVAComFaltaP;
	}
	public void setSaldoIVAComFaltaP(String saldoIVAComFaltaP) {
		this.saldoIVAComFaltaP = saldoIVAComFaltaP;
	}
	public String getTipoPrepago() {
		return tipoPrepago;
	}
	public void setTipoPrepago(String tipoPrepago) {
		this.tipoPrepago = tipoPrepago;
	}
	public List getLcreditos() {
		return lcreditos;
	}
	public void setLcreditos(List lcreditos) {
		this.lcreditos = lcreditos;
	}
	public List getLtipoPrepago() {
		return ltipoPrepago;
	}
	public void setLtipoPrepago(List ltipoPrepago) {
		this.ltipoPrepago = ltipoPrepago;
	}
	public String getTotalAdeudoSinIva() {
		return totalAdeudoSinIva;
	}
	public void setTotalAdeudoSinIva(String totalAdeudoSinIva) {
		this.totalAdeudoSinIva = totalAdeudoSinIva;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getMontoGLAho() {
		return montoGLAho;
	}
	public void setMontoGLAho(String montoGLAho) {
		this.montoGLAho = montoGLAho;
	}
	public String getMontoGLInv() {
		return montoGLInv;
	}
	public void setMontoGLInv(String montoGLInv) {
		this.montoGLInv = montoGLInv;
	}
	public String getMoraVencido() {
		return moraVencido;
	}
	public void setMoraVencido(String moraVencido) {
		this.moraVencido = moraVencido;
	}
	public String getMoraCarVen() {
		return moraCarVen;
	}
	public void setMoraCarVen(String moraCarVen) {
		this.moraCarVen = moraCarVen;
	}
	public String getCuotasAtraso() {
		return cuotasAtraso;
	}
	public void setCuotasAtraso(String cuotasAtraso) {
		this.cuotasAtraso = cuotasAtraso;
	}
	public String getUltCuotaPagada() {
		return ultCuotaPagada;
	}
	public void setUltCuotaPagada(String ultCuotaPagada) {
		this.ultCuotaPagada = ultCuotaPagada;
	}
	public String getFechaUltCuota() {
		return fechaUltCuota;
	}
	public void setFechaUltCuota(String fechaUltCuota) {
		this.fechaUltCuota = fechaUltCuota;
	}
	public String getTotalPrimerCuota() {
		return totalPrimerCuota;
	}
	public void setTotalPrimerCuota(String totalPrimerCuota) {
		this.totalPrimerCuota = totalPrimerCuota;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public static int getLONGITUD_ID() {
		return LONGITUD_ID;
	}
	public static void setLONGITUD_ID(int lONGITUD_ID) {
		LONGITUD_ID = lONGITUD_ID;
	}
	public String getConceptoID() {
		return conceptoID;
	}
	public void setConceptoID(String conceptoID) {
		this.conceptoID = conceptoID;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getAltaEnPoliza() {
		return altaEnPoliza;
	}
	public void setAltaEnPoliza(String altaEnPoliza) {
		this.altaEnPoliza = altaEnPoliza;
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
	public String getTiempoReporte() {
		return tiempoReporte;
	}
	public void setTiempoReporte(String tiempoReporte) {
		this.tiempoReporte = tiempoReporte;
	}
	public String getDiaPagoProd() {
		return diaPagoProd;
	}
	public void setDiaPagoProd(String diaPagoProd) {
		this.diaPagoProd = diaPagoProd;
	}
	public String getProyecto() {
		return proyecto;
	}
	public void setProyecto(String proyecto) {
		this.proyecto = proyecto;
	}
	public String getDesDestinoCredito() {
		return desDestinoCredito;
	}
	public void setDesDestinoCredito(String desDestinoCredito) {
		this.desDestinoCredito = desDestinoCredito;
	}
	public String getFechaDeteccion() {
		return fechaDeteccion;
	}
	public void setFechaDeteccion(String fechaDeteccion) {
		this.fechaDeteccion = fechaDeteccion;
	}
	public String getModalidadPagoID() {
		return modalidadPagoID;
	}
	public void setModalidadPagoID(String modalidadPagoID) {
		this.modalidadPagoID = modalidadPagoID;
	}
	public String getNumReestructuras() {
		return numReestructuras;
	}
	public void setNumReestructuras(String numReestructuras) {
		this.numReestructuras = numReestructuras;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String origen) {
		this.origen = origen;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getFormula() {
		return formula;
	}
	public void setFormula(String formula) {
		this.formula = formula;
	}
	public String getCalcInteres() {
		return calcInteres;
	}
	public void setCalcInteres(String calcInteres) {
		this.calcInteres = calcInteres;
	}
	public String getLeyendaTasaVariable() {
		return leyendaTasaVariable;
	}
	public void setLeyendaTasaVariable(String leyendaTasaVariable) {
		this.leyendaTasaVariable = leyendaTasaVariable;
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
	public String getSaldoSeguroCuota() {
		return saldoSeguroCuota;
	}
	public void setSaldoSeguroCuota(String saldoSeguroCuota) {
		this.saldoSeguroCuota = saldoSeguroCuota;
	}
	public String getSaldoIVASeguroCuota() {
		return saldoIVASeguroCuota;
	}
	public void setSaldoIVASeguroCuota(String saldoIVASeguroCuota) {
		this.saldoIVASeguroCuota = saldoIVASeguroCuota;
	}
	public String getTotalSeguroCuota() {
		return totalSeguroCuota;
	}
	public void setTotalSeguroCuota(String totalSeguroCuota) {
		this.totalSeguroCuota = totalSeguroCuota;
	}
	public String getCinta() {
		return cinta;
	}
	public void setCinta(String cinta) {
		this.cinta = cinta;
	}
	public String getNombreArchivoRepCinta() {
		return nombreArchivoRepCinta;
	}
	public void setNombreArchivoRepCinta(String nombreArchivoRepCinta) {
		this.nombreArchivoRepCinta = nombreArchivoRepCinta;
	}
	public String getTipCobComMorato() {
		return tipCobComMorato;
	}
	public void setTipCobComMorato(String tipCobComMorato) {
		this.tipCobComMorato = tipCobComMorato;
	}
	public String getTotalCreditos() {
		return totalCreditos;
	}
	public void setTotalCreditos(String totalCreditos) {
		this.totalCreditos = totalCreditos;
	}
	public String getEmpresaNomina() {
		return empresaNomina;
	}
	public void setEmpresaNomina(String empresaNomina) {
		this.empresaNomina = empresaNomina;
	}
	public String getNumRegistros() {
		return numRegistros;
	}
	public void setNumRegistros(String numRegistros) {
		this.numRegistros = numRegistros;
	}	
	public String getComentarioCred() {
		return comentarioCred;
	}
	public void setComentarioCred(String comentarioCred) {
		this.comentarioCred = comentarioCred;
	}
	public String getEstCondicionado() {
		return estCondicionado;
	}
	public void setEstCondicionado(String estCondicionado) {
		this.estCondicionado = estCondicionado;
	}
	public String getComentarioCond() {
		return comentarioCond;
	}
	public void setComentarioCond(String comentarioCond) {
		this.comentarioCond = comentarioCond;
	}
	public String getComentarioAlt() {
		return comentarioAlt;
	}
	public void setComentarioAlt(String comentarioAlt) {
		this.comentarioAlt = comentarioAlt;
	}
	public String getEstatusCred() {
		return estatusCred;
	}
	public void setEstatusCred(String estatusCred) {
		this.estatusCred = estatusCred;
	}
	public String getIdenCreditoCNBV() {
		return idenCreditoCNBV;
	}
	public void setIdenCreditoCNBV(String idenCreditoCNBV) {
		this.idenCreditoCNBV = idenCreditoCNBV;
	}
	
	

	public String getFolioFondeo() {
		return folioFondeo;
	}
	public void setFolioFondeo(String folioFondeo) {
		this.folioFondeo = folioFondeo;
	}
	public String getTipoCobro() {
		return tipoCobro;
	}
	public void setTipoCobro(String tipoCobro) {
		this.tipoCobro = tipoCobro;
	}
	public String getMontoComApertura() {
		return montoComApertura;
	}
	public void setMontoComApertura(String montoComApertura) {
		this.montoComApertura = montoComApertura;
	}
	public String getIVAComisionApert() {
		return IVAComisionApert;
	}
	public void setIVAComisionApert(String iVAComisionApert) {
		IVAComisionApert = iVAComisionApert;
	}
	public String getTipoComision() {
		return tipoComision;
	}
	public void setTipoComision(String tipoComision) {
		this.tipoComision = tipoComision;
	}
	public String getComFaltaPago() {
		return comFaltaPago;
	}
	public void setComFaltaPago(String comFaltaPago) {
		this.comFaltaPago = comFaltaPago;
	}
	public String getComSeguroCuota() {
		return comSeguroCuota;
	}
	public void setComSeguroCuota(String comSeguroCuota) {
		this.comSeguroCuota = comSeguroCuota;
	}
	public String getComAperturaCred() {
		return comAperturaCred;
	}
	public void setComAperturaCred(String comAperturaCred) {
		this.comAperturaCred = comAperturaCred;
	}
	public List getLcuentas() {
		return lcuentas;
	}
	public void setLcuentas(List lcuentas) {
		this.lcuentas = lcuentas;
	}
	public List getLcomFaltaPago() {
		return lcomFaltaPago;
	}
	public void setLcomFaltaPago(List lcomFaltaPago) {
		this.lcomFaltaPago = lcomFaltaPago;
	}
	public List getLcomSeguroCuota() {
		return lcomSeguroCuota;
	}
	public void setLcomSeguroCuota(List lcomSeguroCuota) {
		this.lcomSeguroCuota = lcomSeguroCuota;
	}
	public List getLcomAperturaCred() {
		return lcomAperturaCred;
	}
	public void setLcomAperturaCred(List lcomAperturaCred) {
		this.lcomAperturaCred = lcomAperturaCred;
	}
	public String getTipoComisionM() {
		return tipoComisionM;
	}
	public void setTipoComisionM(String tipoComisionM) {
		this.tipoComisionM = tipoComisionM;
	}
	public String getOtrasComAnt() {
		return otrasComAnt;
	}
	public void setOtrasComAnt(String otrasComAnt) {
		this.otrasComAnt = otrasComAnt;
	}
	public String getOtrasComAntIVA() {
		return otrasComAntIVA;
	}
	public void setOtrasComAntIVA(String otrasComAntIVA) {
		this.otrasComAntIVA = otrasComAntIVA;
	}	
	public String getNomCuenta() {
		return nomCuenta;
	}
	public void setNomCuenta(String nomCuenta) {
		this.nomCuenta = nomCuenta;
	}
	public String getTotalComAp() {
		return totalComAp;
	}
	public void setTotalComAp(String totalComAp) {
		this.totalComAp = totalComAp;
	}
	public String getSaldoComAnual() {
		return saldoComAnual;
	}
	public void setSaldoComAnual(String saldoComAnual) {
		this.saldoComAnual = saldoComAnual;
	}
	public String getSaldoComAnualIVA() {
		return saldoComAnualIVA;
	}
	public void setSaldoComAnualIVA(String saldoComAnualIVA) {
		this.saldoComAnualIVA = saldoComAnualIVA;
	}
	public String getComAnual() {
		return comAnual;
	}
	public void setComAnual(String comAnual) {
		this.comAnual = comAnual;
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
	/**
	 * @return the prospectoID
	 */
	public String getProspectoID() {
		return prospectoID;
	}
	/**
	 * @param prospectoID the prospectoID to set
	 */
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
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
	public String getTipoCancelacion() {
		return tipoCancelacion;
	}
	public void setTipoCancelacion(String tipoCancelacion) {
		this.tipoCancelacion = tipoCancelacion;
	}

	public String getFuenteFondeo() {
		return fuenteFondeo;
	}

	public void setFuenteFondeo(String fuenteFondeo) {
		this.fuenteFondeo = fuenteFondeo;
	}

	public String getTipoDesbloqueo() {
		return tipoDesbloqueo;
	}

	public void setTipoDesbloqueo(String tipoDesbloqueo) {
		this.tipoDesbloqueo = tipoDesbloqueo;
	}

	public String getContrasenia() {
		return contrasenia;
	}

	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}

	public static String getCambioFondeo() {
		return cambioFondeo;
	}

	public static void setCambioFondeo(String cambioFondeo) {
		CreditosBean.cambioFondeo = cambioFondeo;
	}

	public String getUsuarioID() {
		return usuarioID;
	}

	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}

	public String getInstitFondeoIDN() {
		return institFondeoIDN;
	}

	public void setInstitFondeoIDN(String institFondeoIDN) {
		this.institFondeoIDN = institFondeoIDN;
	}

	public String getLineaFondeoN() {
		return lineaFondeoN;
	}

	public void setLineaFondeoN(String lineaFondeoN) {
		this.lineaFondeoN = lineaFondeoN;
	}
	
	public String getMontoMinisPen() {
		return montoMinisPen;
	}

	public void setMontoMinisPen(String montoMinisPen) {
		this.montoMinisPen = montoMinisPen;
	}

	public String getFechaCobroComision() {
		return fechaCobroComision;
	}

	
	public String getTipoOperacionFIRA() {
		return tipoOperacionFIRA;
	}

	public void setTipoOperacionFIRA(String tipoOperacionFIRA) {
		this.tipoOperacionFIRA = tipoOperacionFIRA;
	}

	public void setFechaCobroComision(String fechaCobroComision) {
		this.fechaCobroComision = fechaCobroComision;
	}

	public String getCreditoR() {
		return creditoR;
	}

	public void setCreditoR(String creditoR) {
		this.creditoR = creditoR;
	}

	public String getCreditoRC() {
		return creditoRC;
	}

	public void setCreditoRC(String creditoRC) {
		this.creditoRC = creditoRC;
	}

	public String getSaldoCapContingente() {
		return saldoCapContingente;
	}

	public void setSaldoCapContingente(String saldoCapContingente) {
		this.saldoCapContingente = saldoCapContingente;
	}

	public String getSaldoIntContingente() {
		return saldoIntContingente;
	}

	public void setSaldoIntContingente(String saldoIntContingente) {
		this.saldoIntContingente = saldoIntContingente;
	}

	public String getEstatusGarantiaFIRA() {
		return estatusGarantiaFIRA;
	}

	public void setEstatusGarantiaFIRA(String estatusGarantiaFIRA) {
		this.estatusGarantiaFIRA = estatusGarantiaFIRA;
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

	public String getCobranzaCierre() {
		return cobranzaCierre;
	}

	public void setCobranzaCierre(String cobranzaCierre) {
		this.cobranzaCierre = cobranzaCierre;
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

	public String getDestinoCredID() {
		return destinoCredID;
	}

	public void setDestinoCredID(String destinoCredID) {
		this.destinoCredID = destinoCredID;
	}

	public String getDesDestino() {
		return desDestino;
	}

	public void setDesDestino(String desDestino) {
		this.desDestino = desDestino;
	}

	public String getCreditoFondeoID() {
		return creditoFondeoID;
	}

	public void setCreditoFondeoID(String creditoFondeoID) {
		this.creditoFondeoID = creditoFondeoID;
	}

	public String getTipoGarantia() {
		return tipoGarantia;
	}

	public void setTipoGarantia(String tipoGarantia) {
		this.tipoGarantia = tipoGarantia;
	}

	public String getClaseCredito() {
		return claseCredito;
	}

	public void setClaseCredito(String claseCredito) {
		this.claseCredito = claseCredito;
	}

	public String getCveRamaFIRA() {
		return cveRamaFIRA;
	}

	public void setCveRamaFIRA(String cveRamaFIRA) {
		this.cveRamaFIRA = cveRamaFIRA;
	}

	public String getDescripcionRamaFIRA() {
		return descripcionRamaFIRA;
	}

	public void setDescripcionRamaFIRA(String descripcionRamaFIRA) {
		this.descripcionRamaFIRA = descripcionRamaFIRA;
	}

	public String getFechaOtorgamiento() {
		return fechaOtorgamiento;
	}

	public void setFechaOtorgamiento(String fechaOtorgamiento) {
		this.fechaOtorgamiento = fechaOtorgamiento;
	}

	public String getFechaProxVenc() {
		return fechaProxVenc;
	}

	public void setFechaProxVenc(String fechaProxVenc) {
		this.fechaProxVenc = fechaProxVenc;
	}

	public String getMontoProxVenc() {
		return montoProxVenc;
	}

	public void setMontoProxVenc(String montoProxVenc) {
		this.montoProxVenc = montoProxVenc;
	}

	public String getActividadDes() {
		return actividadDes;
	}

	public void setActividadDes(String actividadDes) {
		this.actividadDes = actividadDes;
	}

	public String getCveCadena() {
		return cveCadena;
	}

	public void setCveCadena(String cveCadena) {
		this.cveCadena = cveCadena;
	}

	public String getNomCadenaProdSCIAN() {
		return nomCadenaProdSCIAN;
	}

	public void setNomCadenaProdSCIAN(String nomCadenaProdSCIAN) {
		this.nomCadenaProdSCIAN = nomCadenaProdSCIAN;
	}

	public String getSubPrograma() {
		return subPrograma;
	}

	public void setSubPrograma(String subPrograma) {
		this.subPrograma = subPrograma;
	}

	public String getPorcComision() {
		return porcComision;
	}

	public void setPorcComision(String porcComision) {
		this.porcComision = porcComision;
	}

	public String getConceptoInv() {
		return conceptoInv;
	}

	public void setConceptoInv(String conceptoInv) {
		this.conceptoInv = conceptoInv;
	}

	public String getNumeroUnidades() {
		return numeroUnidades;
	}

	public void setNumeroUnidades(String numeroUnidades) {
		this.numeroUnidades = numeroUnidades;
	}

	public String getUnidadesMedida() {
		return unidadesMedida;
	}

	public void setUnidadesMedida(String unidadesMedida) {
		this.unidadesMedida = unidadesMedida;
	}

	public String getSaldoCapVigentePas() {
		return saldoCapVigentePas;
	}

	public void setSaldoCapVigentePas(String saldoCapVigentePas) {
		this.saldoCapVigentePas = saldoCapVigentePas;
	}

	public String getSaldoCapAtrasadPas() {
		return saldoCapAtrasadPas;
	}

	public void setSaldoCapAtrasadPas(String saldoCapAtrasadPas) {
		this.saldoCapAtrasadPas = saldoCapAtrasadPas;
	}

	public String getSaldoInteresProPas() {
		return saldoInteresProPas;
	}

	public void setSaldoInteresProPas(String saldoInteresProPas) {
		this.saldoInteresProPas = saldoInteresProPas;
	}

	public String getSaldoInteresAtraPas() {
		return saldoInteresAtraPas;
	}

	public void setSaldoInteresAtraPas(String saldoInteresAtraPas) {
		this.saldoInteresAtraPas = saldoInteresAtraPas;
	}
	public String getSaldoInsolutoCartera() {
		return saldoInsolutoCartera;
	}

	public void setSaldoInsolutoCartera(String saldoInsolutoCartera) {
		this.saldoInsolutoCartera = saldoInsolutoCartera;
	}

	public String getSumatoriaCreditos() {
		return sumatoriaCreditos;
	}

	public void setSumatoriaCreditos(String sumatoriaCreditos) {
		this.sumatoriaCreditos = sumatoriaCreditos;
	}

	public String getEsReacreditado() {
		return esReacreditado;
	}

	public void setEsReacreditado(String esReacreditado) {
		this.esReacreditado = esReacreditado;
	}

	public String getNumProducCre() {
		return numProducCre;
	}

	public void setNumProducCre(String numProducCre) {
		this.numProducCre = numProducCre;
	}

	public String getDetalleCancelaCred() {
		return detalleCancelaCred;
	}

	public void setDetalleCancelaCred(String detalleCancelaCred) {
		this.detalleCancelaCred = detalleCancelaCred;
	}

	public String getFechaFinal() {
		return fechaFinal;
	}

	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}

	public String getFechaCancel() {
		return fechaCancel;
	}

	public void setFechaCancel(String fechaCancel) {
		this.fechaCancel = fechaCancel;
	}

	public String getMotivoCancel() {
		return motivoCancel;
	}

	public void setMotivoCancel(String motivoCancel) {
		this.motivoCancel = motivoCancel;
	}

	public String getFechaCondona() {
		return fechaCondona;
	}

	public void setFechaCondona(String fechaCondona) {
		this.fechaCondona = fechaCondona;
	}

	public String getRutaArchivoFinal() {
		return rutaArchivoFinal;
	}

	public void setRutaArchivoFinal(String rutaArchivoFinal) {
		this.rutaArchivoFinal = rutaArchivoFinal;
	}

	public String getNombreCompleto() {
		return nombreCompleto;
	}

	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	public String getCURP() {
		return CURP;
	}

	public void setCURP(String cURP) {
		CURP = cURP;
	}

	public String getFechaUltPagoCap() {
		return fechaUltPagoCap;
	}

	public void setFechaUltPagoCap(String fechaUltPagoCap) {
		this.fechaUltPagoCap = fechaUltPagoCap;
	}

	public String getMontoUltPagoCap() {
		return montoUltPagoCap;
	}

	public void setMontoUltPagoCap(String montoUltPagoCap) {
		this.montoUltPagoCap = montoUltPagoCap;
	}

	public String getFechaUltPagoInt() {
		return fechaUltPagoInt;
	}

	public void setFechaUltPagoInt(String fechaUltPagoInt) {
		this.fechaUltPagoInt = fechaUltPagoInt;
	}

	public String getMontoUltPagoInt() {
		return montoUltPagoInt;
	}

	public void setMontoUltPagoInt(String montoUltPagoInt) {
		this.montoUltPagoInt = montoUltPagoInt;
	}

	public String getInteresVencido() {
		return interesVencido;
	}

	public void setInteresVencido(String interesVencido) {
		this.interesVencido = interesVencido;
	}

	public String getInteresMoratorio() {
		return interesMoratorio;
	}

	public void setInteresMoratorio(String interesMoratorio) {
		this.interesMoratorio = interesMoratorio;
	}

	public String getInteresRefinanciado() {
		return interesRefinanciado;
	}

	public void setInteresRefinanciado(String interesRefinanciado) {
		this.interesRefinanciado = interesRefinanciado;
	}

	public String getTipoAcreditadoRel() {
		return tipoAcreditadoRel;
	}

	public void setTipoAcreditadoRel(String tipoAcreditadoRel) {
		this.tipoAcreditadoRel = tipoAcreditadoRel;
	}

	public String getMontoEPRC() {
		return montoEPRC;
	}

	public void setMontoEPRC(String montoEPRC) {
		this.montoEPRC = montoEPRC;
	}

	public String getFechaConsultaSIC() {
		return fechaConsultaSIC;
	}

	public void setFechaConsultaSIC(String fechaConsultaSIC) {
		this.fechaConsultaSIC = fechaConsultaSIC;
	}

	public String getTipoCobranza() {
		return tipoCobranza;
	}

	public void setTipoCobranza(String tipoCobranza) {
		this.tipoCobranza = tipoCobranza;
	}

	public String getFechaPrimerAmortCub() {
		return fechaPrimerAmortCub;
	}

	public void setFechaPrimerAmortCub(String fechaPrimerAmortCub) {
		this.fechaPrimerAmortCub = fechaPrimerAmortCub;
	}

	public String getRenglon() {
		return renglon;
	}

	public void setRenglon(String renglon) {
		this.renglon = renglon;
	}

	public String getMontoCastigo() {
		return montoCastigo;
	}

	public void setMontoCastigo(String montoCastigo) {
		this.montoCastigo = montoCastigo;
	}

	public String getMontoCondonacion() {
		return montoCondonacion;
	}

	public void setMontoCondonacion(String montoCondonacion) {
		this.montoCondonacion = montoCondonacion;
	}

	public String getFechaCastigo() {
		return fechaCastigo;
	}

	public void setFechaCastigo(String fechaCastigo) {
		this.fechaCastigo = fechaCastigo;
	}

	public String getFechaInicioRep() {
		return fechaInicioRep;
	}

	public void setFechaInicioRep(String fechaInicioRep) {
		this.fechaInicioRep = fechaInicioRep;
	}

	public String getFechaFinRep() {
		return fechaFinRep;
	}

	public void setFechaFinRep(String fechaFinRep) {
		this.fechaFinRep = fechaFinRep;
	}

	public String getAnio() {
		return anio;
	}

	public void setAnio(String anio) {
		this.anio = anio;
	}

	public String getMes() {
		return mes;
	}

	public void setMes(String mes) {
		this.mes = mes;
	}

	public String getMotivoCastigoID() {
		return motivoCastigoID;
	}

	public void setMotivoCastigoID(String motivoCastigoID) {
		this.motivoCastigoID = motivoCastigoID;
	}


	public String getReferenciaPago() {
		return referenciaPago;
	}

	public void setReferenciaPago(String referenciaPago) {
		this.referenciaPago = referenciaPago;
	}

	public String getSaldoReferencia() {
		return saldoReferencia;
	}

	public void setSaldoReferencia(String saldoReferencia) {
		this.saldoReferencia = saldoReferencia;
	}

	public String getSaldoPago() {
		return saldoPago;
	}

	public void setSaldoPago(String saldoPago) {
		this.saldoPago = saldoPago;
	}
	public String gettotalIVA() {
		return totalIVA;
	}

	public void settotalIVA(String totalIVA) {
		totalIVA = totalIVA;
	}

	public String getTotalPago() {
		return totalPago;
	}

	public void setTotalPago(String totalPago) {
		this.totalPago = totalPago;
	}
	public String getTotalMoratorios() {
		return totalMoratorios;
	}

	public void setTotalMoratorios(String totalMoratorios) {
		this.totalMoratorios = totalMoratorios;
	}

	public String getCobraAccesorios() {
		return cobraAccesorios;
	}

	public void setCobraAccesorios(String cobraAccesorios) {
		this.cobraAccesorios = cobraAccesorios;
	}
	

	public String getCobraAccesoriosGen() {
		return cobraAccesoriosGen;
	}

	public void setCobraAccesoriosGen(String cobraAccesoriosGen) {
		this.cobraAccesoriosGen = cobraAccesoriosGen;
	}
	

	public String getTipoOpera() {
		return tipoOpera;
	}

	public void setTipoOpera(String tipoOpera) {
		this.tipoOpera = tipoOpera;
	}

	public String getAccesorioID() {
		return accesorioID;
	}

	public void setAccesorioID(String accesorioID) {
		this.accesorioID = accesorioID;
	}

	public String getCicloCliente() {
		return cicloCliente;
	}

	public void setCicloCliente(String cicloCliente) {
		this.cicloCliente = cicloCliente;
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
	
	public String getComAnualLin() {
		return comAnualLin;
	}	

	public void setComAnualLin(String comAnualLin) {
		this.comAnualLin = comAnualLin;
	}

	public String getSimulado() {
		return simulado;
	}

	public void setSimulado(String simulado) {
		this.simulado = simulado;
	}

	public String getMontoModificado() {
		return montoModificado;
	}

	public void setMontoModificado(String montoModificado) {
		this.montoModificado = montoModificado;
	}

	public String getPasivoID() {
		return PasivoID;
	}

	public void setPasivoID(String pasivoID) {
		PasivoID = pasivoID;
	}

	public String getAdeudoPasivo() {
		return AdeudoPasivo;
	}

	public void setAdeudoPasivo(String adeudoPasivo) {
		AdeudoPasivo = adeudoPasivo;
	}

	public String getConvenioNominaID() {
		return convenioNominaID;
	}

	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	
	public String getNumLista(){
		return numLista;
	}
	public void setNumLista(String numLista){
		this.numLista=numLista;
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
	public String getNombreInstit() {
		return nombreInstit;
	}
	
	public void setNombreInstit(String nombreInstit) {
		this.nombreInstit = nombreInstit;
	}
	public String getDesConvenio() {
		return desConvenio;
	}
	
	public void setDesConvenio(String desConvenio) {
		this.desConvenio = desConvenio;
	}
	public String getEsNomina() {
		return esNomina;
	}

	public void setEsNomina(String esNomina) {
		this.esNomina = esNomina;
	}
	public String getCapacidadPago() {
		return capacidadPago;
	}

	public void setCapacidadPago(String capacidadPago) {
		this.capacidadPago = capacidadPago;
	}

	public String getClabeDomiciliacion() {
		return clabeDomiciliacion;
	}

	public void setClabeDomiciliacion(String clabeDomiciliacion) {
		this.clabeDomiciliacion = clabeDomiciliacion;
	}
	public String getManejaConvenio() {
		return manejaConvenio;
	}

	public void setManejaConvenio(String manejaConvenio) {
		this.manejaConvenio = manejaConvenio;
	}

	public String getEsproducNomina() {
		return esproducNomina;
	}

	public void setEsproducNomina(String esproducNomina) {
		this.esproducNomina = esproducNomina;
	}

	public String getDesClasificacion() {
		return desClasificacion;
	}

	public void setDesClasificacion(String desClasificacion) {
		this.desClasificacion = desClasificacion;
	}

	public String getDesGenero() {
		return desGenero;
	}

	public void setDesGenero(String desGenero) {
		this.desGenero = desGenero;
	}

	public String getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}

	public String getTotalClientes() {
		return totalClientes;
	}

	public void setTotalClientes(String totalClientes) {
		this.totalClientes = totalClientes;
	}

	public String getTotalCtesNuevos() {
		return totalCtesNuevos;
	}

	public void setTotalCtesNuevos(String totalCtesNuevos) {
		this.totalCtesNuevos = totalCtesNuevos;
	}

	public String getTotalCtesRenovacion() {
		return totalCtesRenovacion;
	}

	public void setTotalCtesRenovacion(String totalCtesRenovacion) {
		this.totalCtesRenovacion = totalCtesRenovacion;
	}

	public String getTotalCtesCorte() {
		return totalCtesCorte;
	}

	public void setTotalCtesCorte(String totalCtesCorte) {
		this.totalCtesCorte = totalCtesCorte;
	}

	public String getTotalCtesPagos() {
		return totalCtesPagos;
	}

	public void setTotalCtesPagos(String totalCtesPagos) {
		this.totalCtesPagos = totalCtesPagos;
	}

	public String getTotalCtesNoPagos() {
		return totalCtesNoPagos;
	}

	public void setTotalCtesNoPagos(String totalCtesNoPagos) {
		this.totalCtesNoPagos = totalCtesNoPagos;
	}

	public String getTotalCtesPrepagos() {
		return totalCtesPrepagos;
	}

	public void setTotalCtesPrepagos(String totalCtesPrepagos) {
		this.totalCtesPrepagos = totalCtesPrepagos;
	}

	public String getSaldoInicialCaja() {
		return saldoInicialCaja;
	}

	public void setSaldoInicialCaja(String saldoInicialCaja) {
		this.saldoInicialCaja = saldoInicialCaja;
	}

	public String getSaldoEsperadoCartera() {
		return saldoEsperadoCartera;
	}

	public void setSaldoEsperadoCartera(String saldoEsperadoCartera) {
		this.saldoEsperadoCartera = saldoEsperadoCartera;
	}

	public String getSaldoCartera() {
		return saldoCartera;
	}

	public void setSaldoCartera(String saldoCartera) {
		this.saldoCartera = saldoCartera;
	}

	public String getSaldoRecaudoPrepago() {
		return saldoRecaudoPrepago;
	}

	public void setSaldoRecaudoPrepago(String saldoRecaudoPrepago) {
		this.saldoRecaudoPrepago = saldoRecaudoPrepago;
	}

	public String getPorcentajeRecaudo() {
		return porcentajeRecaudo;
	}

	public void setPorcentajeRecaudo(String porcentajeRecaudo) {
		this.porcentajeRecaudo = porcentajeRecaudo;
	}

	public String getPorcentajePretendido() {
		return porcentajePretendido;
	}

	public void setPorcentajePretendido(String porcentajePretendido) {
		this.porcentajePretendido = porcentajePretendido;
	}

	public String getSaldoTotalCreditos() {
		return saldoTotalCreditos;
	}

	public void setSaldoTotalCreditos(String saldoTotalCreditos) {
		this.saldoTotalCreditos = saldoTotalCreditos;
	}

	public String getSaldoGastosDia() {
		return saldoGastosDia;
	}

	public void setSaldoGastosDia(String saldoGastosDia) {
		this.saldoGastosDia = saldoGastosDia;
	}

	public String getCoordinadorID() {
		return coordinadorID;
	}

	public void setCoordinadorID(String coordinadorID) {
		this.coordinadorID = coordinadorID;
	}

	public String getNombreCoordinador() {
		return nombreCoordinador;
	}

	public void setNombreCoordinador(String nombreCoordinador) {
		this.nombreCoordinador = nombreCoordinador;
	}

	public String getTipoUsuario() {
		return tipoUsuario;
	}

	public void setTipoUsuario(String tipoUsuario) {
		this.tipoUsuario = tipoUsuario;
	}

	public String getTotalCteCreditos() {
		return totalCteCreditos;
	}

	public void setTotalCteCreditos(String totalCteCreditos) {
		this.totalCteCreditos = totalCteCreditos;
	}
	
	public String getTipoFormatoCinta() {
		return tipoFormatoCinta;
	}

	public void setTipoFormatoCinta(String tipoFormatoCinta) {
		this.tipoFormatoCinta = tipoFormatoCinta;
	}

	public String getHeaderINTL() {
		return headerINTL;
	}

	public void setHeaderINTL(String headerINTL) {
		this.headerINTL = headerINTL;
	}
	
	public String getServiciosAdicionales() {
		return serviciosAdicionales;
	}

	public void setServiciosAdicionales(String serviciosAdicionales) {
		this.serviciosAdicionales = serviciosAdicionales;
	}

	public String getAplicaDescServicio() {
		return aplicaDescServicio;
	}

	public void setAplicaDescServicio(String aplicaDescServicio) {
		this.aplicaDescServicio = aplicaDescServicio;
	}

	public String getCuotasProyectadas() {
		return cuotasProyectadas;
	}

	public void setCuotasProyectadas(String cuotasProyectadas) {
		this.cuotasProyectadas = cuotasProyectadas;
	}
	
	public String getNombreInstitFon() {
		return nombreInstitFon;
	}

	public void setNombreInstitFon(String nombreInstitFon) {
		this.nombreInstitFon = nombreInstitFon;
	}

	public String getDescripLinea() {
		return descripLinea;
	}

	public void setDescripLinea(String descripLinea) {
		this.descripLinea = descripLinea;
	}

	public String getFolioPasivo() {
		return folioPasivo;
	}

	public void setFolioPasivo(String folioPasivo) {
		this.folioPasivo = folioPasivo;
	}
	public String getOrigenPago() {
		return origenPago;
	}

	public void setOrigenPago(String origenPago) {
		this.origenPago = origenPago;
	}

	public String getFechaNacimiento() {
		return fechaNacimiento;
	}

	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}

	public String getDigVerificador() {
		return digVerificador;
	}

	public void setDigVerificador(String digVerificador) {
		this.digVerificador = digVerificador;
	}

	public String getEsConsolidacionAgro() {
		return esConsolidacionAgro;
	}

	public void setEsConsolidacionAgro(String esConsolidacionAgro) {
		this.esConsolidacionAgro = esConsolidacionAgro;
	}

	public static String getCreditoNuevo() {
		return creditoNuevo;
	}

	public static void setCreditoNuevo(String creditoNuevo) {
		CreditosBean.creditoNuevo = creditoNuevo;
	}

	public static String getDesembolsoCredito() {
		return desembolsoCredito;
	}

	public static void setDesembolsoCredito(String desembolsoCredito) {
		CreditosBean.desembolsoCredito = desembolsoCredito;
	}

	public static String getDesDesembolsoCredito() {
		return desDesembolsoCredito;
	}

	public static void setDesDesembolsoCredito(String desDesembolsoCredito) {
		CreditosBean.desDesembolsoCredito = desDesembolsoCredito;
	}

	public static String getPagoCredito() {
		return pagoCredito;
	}

	public static void setPagoCredito(String pagoCredito) {
		CreditosBean.pagoCredito = pagoCredito;
	}

	public static String getDesPagoCredito() {
		return desPagoCredito;
	}

	public static void setDesPagoCredito(String desPagoCredito) {
		CreditosBean.desPagoCredito = desPagoCredito;
	}

	public static String getDesCambioFondeo() {
		return desCambioFondeo;
	}

	public static void setDesCambioFondeo(String desCambioFondeo) {
		CreditosBean.desCambioFondeo = desCambioFondeo;
	}

	public static String getCANCELACION_CREDITO() {
		return CANCELACION_CREDITO;
	}

	public static void setCANCELACION_CREDITO(String cANCELACION_CREDITO) {
		CANCELACION_CREDITO = cANCELACION_CREDITO;
	}

	public static String getDESCRIPCION_CANCELACION_CRED() {
		return DESCRIPCION_CANCELACION_CRED;
	}

	public static void setDESCRIPCION_CANCELACION_CRED(
			String dESCRIPCION_CANCELACION_CRED) {
		DESCRIPCION_CANCELACION_CRED = dESCRIPCION_CANCELACION_CRED;
	}

	public String getTotalIVA() {
		return totalIVA;
	}

	public void setTotalIVA(String totalIVA) {
		this.totalIVA = totalIVA;
	}

	public String getDomiciliacionPagos() {
		return domiciliacionPagos;
	}

	public void setDomiciliacionPagos(String domiciliacionPagos) {
		this.domiciliacionPagos = domiciliacionPagos;
	}

	public String getNotasCargo() {
		return notasCargo;
	}

	public void setNotasCargo(String notasCargo) {
		this.notasCargo = notasCargo;
	}

	public String getIvaNotasCargo() {
		return ivaNotasCargo;
	}

	public void setIvaNotasCargo(String ivaNotasCargo) {
		this.ivaNotasCargo = ivaNotasCargo;
	}
	public String getSaldoNotasCargos() {
		return saldoNotasCargos;
	}

	public void setSaldoNotasCargos(String saldoNotasCargos) {
		this.saldoNotasCargos = saldoNotasCargos;
	}
	public String getSaldoNotasCargo() {
		return saldoNotasCargo;
	}

	public void setSaldoNotasCargo(String saldoNotasCargo) {
		this.saldoNotasCargo = saldoNotasCargo;
	}

	public String getSaldNotasCargo() {
		return saldNotasCargo;
	}

	public void setSaldNotasCargo(String saldNotasCargo) {
		this.saldNotasCargo = saldNotasCargo;
	}

	public String getInstitucionBanorte() {
		return institucionBanorte;
	}

	public void setInstitucionBanorte(String institucionBanorte) {
		this.institucionBanorte = institucionBanorte;
	}

	public String getInstitucionTelecom() {
		return institucionTelecom;
	}

	public void setInstitucionTelecom(String institucionTelecom) {
		this.institucionTelecom = institucionTelecom;
	}

	public String getReferenciaBanorte() {
		return referenciaBanorte;
	}

	public void setReferenciaBanorte(String referenciaBanorte) {
		this.referenciaBanorte = referenciaBanorte;
	}

	public String getReferenciaTelecom() {
		return referenciaTelecom;
	}

	public void setReferenciaTelecom(String referenciaTelecom) {
		this.referenciaTelecom = referenciaTelecom;
	}
	public String getEstatusNomina() {
		return estatusNomina;
	}

	public void setEstatusNomina(String estatusNomina) {
		this.estatusNomina = estatusNomina;
	}

	public String getManejaComAdmon() {
		return manejaComAdmon;
	}

	public void setManejaComAdmon(String manejaComAdmon) {
		this.manejaComAdmon = manejaComAdmon;
	}

	public String getComAdmonLinPrevLiq() {
		return comAdmonLinPrevLiq;
	}

	public void setComAdmonLinPrevLiq(String comAdmonLinPrevLiq) {
		this.comAdmonLinPrevLiq = comAdmonLinPrevLiq;
	}

	public String getForCobComAdmon() {
		return forCobComAdmon;
	}

	public void setForCobComAdmon(String forCobComAdmon) {
		this.forCobComAdmon = forCobComAdmon;
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

	public String getForCobComGarantia() {
		return forCobComGarantia;
	}

	public void setForCobComGarantia(String forCobComGarantia) {
		this.forCobComGarantia = forCobComGarantia;
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

	public String getMinistracionID() {
		return ministracionID;
	}

	public void setMinistracionID(String ministracionID) {
		this.ministracionID = ministracionID;
	}

	public String getTransaccionID() {
		return transaccionID;
	}

	public void setTransaccionID(String transaccionID) {
		this.transaccionID = transaccionID;
	}

	public String getMontoPagComGarantiaSim() {
		return montoPagComGarantiaSim;
	}

	public void setMontoPagComGarantiaSim(String montoPagComGarantiaSim) {
		this.montoPagComGarantiaSim = montoPagComGarantiaSim;
	}

	public String getRefPayCash() {
		return refPayCash;
	}

	public void setRefPayCash(String refPayCash) {
		this.refPayCash = refPayCash;
	}
	
}
