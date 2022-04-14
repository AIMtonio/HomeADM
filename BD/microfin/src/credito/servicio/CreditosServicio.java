package credito.servicio;

import fira.bean.MinistracionCredAgroBean;
import fira.dao.CambioFondeadorAgroDAO;
import fira.dao.MinistraCredAgroDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.GenerateBarCode;
import herramientas.Utileria;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.oned.Code128Writer;
import com.google.zxing.oned.EAN13Writer;

import net.sourceforge.barbecue.Barcode;
import net.sourceforge.barbecue.BarcodeFactory;
import net.sourceforge.barbecue.BarcodeImageHandler;

import com.google.gson.Gson;

import originacion.servicio.SolicitudCreditoServicio.Enum_Act_SolAgro;
import pld.bean.OpeEscalamientoInternoBean;
import pld.servicio.OpeEscalamientoInternoServicio;
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ParamGeneralesBean;
import soporte.bean.ParametrosSisBean;
import soporte.consumo.rest.ConsumidorRest;
import soporte.servicio.ParamGeneralesServicio;
import soporte.servicio.ParametrosSisServicio;
import spei.bean.ParametrosSpeiBean;
import spei.beanWS.response.SpeiEnvioBeanResponse;
import tesoreria.bean.ReferenciasPagosBean;
import tesoreria.dao.ReferenciasPagosDAO;
import ventanilla.bean.SpeiEnvioBean;
import cliente.bean.CicloCreditoBean;
import credito.bean.AmortizacionCreditoBean;
import credito.bean.BitacoraCobAutoBean;
import credito.bean.CartasFiniquitoBean;
import credito.bean.CobranzaAutomaticaBean;
import credito.bean.ContratoCredEncBean;
import credito.bean.CreditosBean;
import credito.bean.DetallePagoBean;
import credito.bean.DocumentoFirmaBean;
import credito.bean.IntegraGruposBean;
import credito.bean.PagosAnticipadosBean;
import credito.bean.PagosConciliadoBean;
import credito.bean.PagosxReferenciaBean;
import credito.bean.RazonesNoPagoBean;
import credito.bean.RepPlanPagosGrupalBean;
import credito.bean.RepPlanPagosIndividualBean;
import credito.bean.ServiciosSolCredBean;
import credito.bean.ReporteServiciosAdicionalesBean;
import credito.beanWS.request.ConsultaActividadCreditoRequest;
import credito.beanWS.request.ConsultaDescuentosNominaRequest;
import credito.beanWS.request.ConsultaPagosAplicadosRequest;
import credito.beanWS.request.LegalDocumentsBean;
import credito.beanWS.request.ListaCreditosBERequest;
import credito.beanWS.request.ListaSolicitudCreditoRequest;
import credito.beanWS.request.SimuladorCreditoRequest;
import credito.beanWS.response.ConsultaActividadCreditoResponse;
import credito.beanWS.response.ConsultaDescuentosNominaResponse;
import credito.beanWS.response.ConsultaPagosAplicadosResponse;
import credito.beanWS.response.LegalDocumentsBeanResponse;
import credito.beanWS.response.ListaCreditosBEResponse;
import credito.beanWS.response.ListaSolicitudCreditoResponse;
import credito.beanWS.response.SimuladorCreditoResponse;
import credito.dao.CreditosDAO;
import credito.dao.SeguroVidaDAO;
import credito.dao.ServiciosSolCredDAO;
import cuentas.bean.CuentasAhoBean;
import cuentas.bean.MonedasBean;
import cuentas.servicio.CuentasAhoServicio;
import cuentas.servicio.MonedasServicio;
import cuentas.servicio.MonedasServicio.Enum_Con_Monedas;

public class CreditosServicio extends BaseServicio {

	public String nomProcesoEsc = "CREDITO";
	public int numResp = 0; 	     // numero de respuesta de el proceso de escalamiento interno
	public int numTransaccionEscala = 1; // numero de respuesta de el proceso de escalamiento interno
	public String NumDocumento = "1/1";// numero de documento para el reporte de pagare Agro tipo tasa Fija
	//---------- Variables ------------------------------------------------------------------------
	ParametrosSesionBean parametrosSesionBean;
	CreditosDAO creditosDAO = null;
	MonedasServicio monedasServicio = null;
	IntegraGruposServicio integraGruposServicio;
	CuentasAhoServicio cuentasAhoServicio = null;
	OpeEscalamientoInternoServicio opeEscalamientoInternoServicio = null;
	SeguroVidaDAO seguroVidaDAO = null;
	String numcredito = "";  // guarda el numero del credito que se a dado de alta
	String mensajedes = ""; // mesaje del credito
	TransaccionDAO transaccionDAO = null;
	MinistraCredAgroDAO ministraCredAgroDAO = null;
	CambioFondeadorAgroDAO cambioFondeadorAgroDAO = null;
	ParametrosSisServicio parametrosSisServicio = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	//------------Constantes------------------
	public String cero="0"; // para enviar a el alta de solicitud de fondeo
	public String tipoFondeador="3";// para enviar a el alta de solicitud de fondeo
	String codigo= "";
	private Object generaNumeroTransaccion;
	private ServiciosSolCredDAO serviciosSolCredDAO;
	ReferenciasPagosDAO referenciasPagosDAO;
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Creditos {
		int principal				= 1;
		int foranea					= 2;
		int pagareImp				= 3;
		int fechaCorte				= 4;
		int ExigibleSinProy			= 5;
		int actTransacSim			= 6;
		int pago					= 7;	/* Para el detalle total de la deuda SCA*/
		int pagoExigible			= 8;	/* Con proyeccion*/
		int tasasCredito			= 9;
		int Con_ComDesVent			= 11;
		int Con_GLVent				= 12;
		int resumCliente			= 13;
		int credDiasAtraso			= 15;
		int exigibleCondona			= 16;
		int finiquitoLiq			= 17;
		int generalesCredito		= 18;
		int conCreditoWS    		= 19;  // Consulta de Creditos para carga de archivos de pagos de nomina
		int conCreditoBEWS   		= 20; //consulta saldos de credito para mostar en pantalla de BancaEnLinea
		int creditoRenovar   		= 22; //consulta los datos de credito a renovar
		int creditoReestructurar 	= 23; //consulta los datos de credito a reestructurar
		int creditoPagoVertical 	= 24; //consulta los datos de credito con pago vertical
		int Cond_Quitas     		= 25;
		int creditosConSeguroCuota 	= 26;
		int creditosCondicionados 	= 27;
		int genCobComCargCta		= 28;
		// Consultas Agro
		int creditoAgro				= 29;
		int cambioFondeo			= 30;
		int aplicaGarantiasAgro		= 31;
		int generalesCreditoAgro	= 32;
		int finiquitoLiqAgro		= 33;
		int pagoAgro				= 34;
		int pagoExigibleAgro		= 35;
		int aplicaGaranAgro			= 31;
		int riesgosSaldos			= 36;	// Saldos de Cartera para evaluacion de riesgos
		int creditosCont			= 37;	// Consulta de creditos contingentes
		int conAccesorioProd		= 38;   // Consulta para obtener accesorios por producto de crédito
		int conAccesorioProdPla		= 39;   // consulta para obtener accesorios por producto y plazo de crédito
		int conCobAccesorios		= 40;
		int conGarFOGAFI			= 41;	// Consulta para obtener el adeudo de Garantia FOGAFI
		int conSaldoFOGAFI 			= 42;	// Consulta para obtener el saldo FOGAFI para el pago de crédito.
		int conMontoAutoMod 		= 43;	// Consulta de Créditos con Montos Autorizados Modificados
		int PagoCredCont			= 44;	/* Consulta total de la deuda Contingente*/
		int PagCreExiCont			= 45;	/* Consulta Exigible Contingente*/
		int Cond_QuitasCont    		= 46;   /* Quitas Contingente */
		int creditoRenovarAgro 		= 47;	// Consulta los datos de credito a renovar
		int con_InfoCredSuspencion	= 48;	// Consulta de datos de Informacion  de credito a suspender
		int conCambioFuentFondCred  = 49;	// Consulta para pantalla de cambio fuente de fondeo del modulo de cartera para el cliente Mexi
		int conCartaLiquidacion		= 50;	// Consulta de datos para la carta de liquidación
		int conNotaCargo			= 51;	// Consulta para la pantalla de notas de cargo
		int conInstitucionConvenio  = 52;
		int informacionCredito		= 53;
	}

	public static interface Enum_Con_ContratosCred{
		int consultaEncabezado = 2;
	}
	public static interface Enum_Con_CreditosWS {
		int actividadCredito = 1;
	}

	public static interface Enum_Con_Cobranza {
		int actCobAutomaticaSI 		= 1;  // Se usa para actualizar el valor parametro: SI
		int actCobAutomaticaNO 		= 2;  // Se usa para actualizar el valor parametro: NO
		int actCobAutoRefereSI		= 7;
		int actCobAutoRefereNO		= 8;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Creditos {
		int principal 			= 1;
		int creditosCliente 	= 3; // para lista de creditos por cliente
		int creditosVigentes 	= 4; // para lista de creditos por cliente con estatus vigente
		int pagareNoImp 		= 5; // para lista de creditos que aun no se ha impreso su pagaré o que estan vigentes
		int creAutInac 			= 6; // para lista de creditos con estatus Autorizado o inactivo
		int resumCteCredito		= 7; // para lista de creditos para Resumen de Clientes
		int creditosInact		= 8; // para lista de creditos inactivos
		int creVigVenci 		= 9; // para lista de creditos con estatus Vigente o vencido
		int credAutoPagImp		=10; // para lista de creditos autorizados y con estatus de pagaré impreso
		int credIndividuales	=11; // para lista de creditos individuales (todos los estatus)
		int creditoInvGar		=12; // para lista de creditos (todos los estatus excepto pagado y cancelado)
		int todosCreditosCte	=13; // para lista de creditos (todos los de un cliente)
		int credVigPagados		=14; // para lista de creditos (Todos los creditos Vigentes y pagados)
		int credTipoBloq		=15; // arroja la lista de creditos que no han sido desembolsados
		int credCastigados		=16; // arroja la lista de creditos que no han sido desembolsados
		int proteccionCred		=17; // arroja la lista de creditos vigentes de un cliente, regresa adeudo Total del credito
		int credCliente			=18; // lista de creditos por cliente para la pantalla de banca en linea
		int credBloqSaldo		=19; // lista de de creditos que a los cuales se le congela saldo por garantia liquida
		int creAutVigVen		=20; /* lista creditos AUTORIZADOS, VIGENTES y VENCIDOS */
		int credCastigados2		=21; // creditos castigados parapantalla de operaciones ventanilla
		int creVigVenci2 		=22; // lista de creditos con estatus Vigente o vencido, para pantalla de operaciones ventanilla
		int crePagados			=23; // lista de creditos con estatus pagado, para pantalla de operaciones ventanilla
		int creInactivos		=24; // lista de creditos con estatus inactivo, para pantalla de operaciones ventanilla
		int creVigentes			=25; // lista de creditos con estatus vigentes, para pantalla de operaciones ventanilla
		int creAvalados			=27; // lista de creditos avalados por un cliente, para pantalla resumen de cliente
		int creInactivosVent	=28; // lista de creditos con estatus inactivo

		int creVigVenci2Suc		=29; // Lista 22 marcos
		int creVigentesSuc		=30; // Lista 25 marcos
		int creCobroComxAper	=31; // Lista 31 para cobro comision por apertura
		int creCobPolizaCobRies =32; // Lista 32 para Cobro poliza Cobertura de Riesgo
		int creAplipolizaCobRies=33; // lista 33 Aplica Cobro poliza Cobertura de Riesgo
		int creAval				=34; /* Lista 34 LISTA TODOS LOS CREDITOS QUE UN CLIENTE ESTE AVALANDO Y QUE ESTEN VENCIDOS, CASTIGADOS O QUE TENGAN DIAS DE ATRASO
										  SI EL CLIENTE FUE PROSPECTO Y QUE AVALO UN CREDITO TAMBIEN SE MUESTRA EL CREDITO SI SE ENCUENTRA EN LAS CONDICIONES
										  ANTERIORES*/
		int creReestructura		=35; // lista 35 Aplica a Creditos a Reestructurar
		int creVigentesVen		=36;// Lista de Creditos para ventanilla Botones
		int creVigVenci2Ven		=37;// Lista Con Botones para la Pantalla de Operaciones ventanilla
		int devoGaranLiq		=38;
		int crePerPrepago		=39;
		int rescredliqInus		=40; //Lista de los 5 ultimos creditos liquidados usado en pantalla de operaciones inusuales
		int creIndVigBVenci	    =41; //Lista los creditos individuales vigentes y vencidos
		int CreVigVenciCli		=42; // Lista los creditos vigentes y vencidos de un cliente
		int creMonitor			=43; // Lista los creditos que pasaron por el monitor de desembolso de credito
		int CreVigVencInac		=44; // Lista los creditos inactivos, vigentes y vencidos, usado en la pantalla Cobro de Comisiones con Cargo a Cuenta
		int CreComisiones		=45; // Lista de Creditos con sus Comisiones pendientes de pago
		int CredConGarSinFondeo	= 46;
		int principalAgro		= 47; // Lista de créditos agropecuarios.
		int credAutoPagImpAgro	= 48; // para lista de creditos autorizados y con estatus de pagaré impreso de créditos agropecuarios
		int creVigentesVenAgro	= 49; // Lista para creditos vigentes y vencido Agropecuarios
		int creFuenteFondeo     = 50; // Lista para creditos que pueden realizar cambio de fuente de fondeo
		int creReacreditado		= 51; // Lista de creditos que pueden ser reacreditados
		int creVigVenciNOAgro	= 52; // LIsta de Creditos Vigentes y vencidos, suspendidos no agro
		int creditosCont		= 53; // Lista de Creditos contingentes
		int creAccesorios		= 54; // Lista de Creditos que cobran Accesorios
		int creditosGarFOGAFI	= 55; // lista de de creditos que cobran garantia FOGAFI
		int listaPagoCreditos		= 62;
		int listaGuardaValores	= 56;
		int listCredSuspension	= 57; // Lista de Creditos a suspender
		int lisCambioFuentFondCred = 58; //  Lista de creditos para realizar cambio de fuente de fondeo para el cliente Mexi
		int listCredVigVen		= 59; // Lista créditos vigentes vencidos en Carta Liquidación
		int lisClienteCartas	= 60; // Lista créditos de cartas de liquidación por cliente
		int lisNotasCargo		= 61; // Lista de creditos a los que se les puede aplicar una nota de cargo
	}

	public static interface Enum_Lis_CredRep {
		int	principal				= 1;
		int	salTotalRepPan			= 2;
		int	salTotalRepEx			= 3;	// numero que le coresponde en el sp de saldos totales al reporte de excel
		int	salCapitRepEx			= 4;	// numero que le coresponde en el sp de saldos de capital al reporte de excel
		int	ministraRepEx			= 2;	// numero que le coresponde en el sp de ministracionesrep al reporte de excel
		int	pagosRealiRepEx			= 5;	// numero que le coresponde en el sp de pagos realizados al reporte de excel
		int	masivoFR_RepEx			= 6;
		int	envBuroCred				= 7;
		int	vencimientos			= 8;
		int	movimientosCred			= 9;	// numero para el reporte de movimientos de credito
		int	antiguDeSaldos			= 10;
		int	vencimiPasivos			= 11;
		int	estCredPrevRepEx		= 12;
		int	estCalifPorResRepEx		= 13;
		int	comPendPagoRepEX		= 14;
		int	movimientosCredsum		= 15;	// reporte para reporte de movimientos de credito sumarizado
		int	repSaldosCarAvaRef		= 16;	// reporte de saldos de cartera, avales y referencias para la gestion de cobranza
		int creditosCancelados		= 17;
		int repPagAccesorios		= 18;   //reporte de pago de Accesorios
		int repServiciosAdicionales	= 19;   //reporte de servicios Adicionales
	}


	//List de consulta de Creditos Descuento Nominas WS
	public static interface Enum_Lis_DescuentosWS {
		int listaDescuentoNominaWS 	= 1;
	}
	// lista de los creditos de un grupo no solidario
	public static interface Enum_Lis_CreditosGNSWS {
		int descargaCreditosWS 	= 1;
	}

	//List de consulta de Solicitud de Creditos WS
	public static interface Enum_Lis_SolCredWS {
		int listaSolCreditosWS 	= 1;
	}

	// Tipo de consulta para Cobranza Automatica
	public static interface Enum_Con_CobAutomatica {
		int CreditosPorPagar = 1;
		int CreditosGrupales = 2;
		int CreditosPorPagarCom =3;
	}

	// Tipo de consulta para Bitacora de la Cobranza Automatica
	public static interface Enum_Con_BitacoraCobranzaAuto{
		int CobrosPorFecha = 1;
	}

	//---------- Tipo de Transacciones ----------------------------------------------------------------
	public static interface Enum_Tra_Creditos {
		int alta						= 1;
		int modificacion				= 2;
		int actualizaAut				= 3;
		int desembolso					= 4;
		int actuaCredi					= 6;
		int bajaNumTraSim				= 7;
		int actImpPag					= 8;
		int grabaSolFondeo				= 11; //transaccion para grabar en solicitud fondeo
		int pagoCredito					= 12; //Para el pago de credito
		int altaGrupal					= 13; //Para alta de credito Grupal
		int autorizaGrupal				= 14; //Para autorizacion de credito Grupal
		int pagareGrupal				= 15; //Para pagare de credito Grupal
		int desembolsoGrupal			= 16; //Para desembolso de credito Grupal
		int condicionesDesem			= 17; //Para Cambiar Condiciones de Desembolso (Tipo de Dispersion)
		int pagoCreditoGrupalCarCta		= 18; //Para el pago de credito Grupal
		int reestructura				= 19; //alta de reestructura
		int modificaReestructura		= 20; //Modifica  de reestructura
		int prepagoCredito				= 21; //prepago de credito
		int prepagoCreditoGrupal		= 22; //prepago de credito
		int pagoIntereCreditoCCta		= 23;
		int pagoCredVerticalCCta		= 24; //pago de crédito vertical
		int condicionaCred				= 25;// Condiciona el crédito
		int pagComCCtaIndiv				= 26; // Pago de Comisiones Individual
		int pagComCCtaMasivo			= 27; // pago de Comisiones Masivo
		int desembolsoAgro				= 28;
		int cancelacionAgro				= 29;
		int altaCreditoAgro				= 30;
		int modificacionCreditoAgro		= 31;
		int pagareCredAgro				= 32;
		int cambioFondeador				= 33;
		int actuaCreditoAgro			= 34;
		int altacredGrupalAgro			= 35;
		int pagareGrupalAgro			= 36;
		int autorizaGrupalAgro			= 37;
		int desembolsoGrupalAgro		= 38;
		int pagoCreditoAgro				= 39;
		int cancelacionCred				= 40;
		int cresimpagcomsergarantia		= 41;
	}

	public static interface Enum_Act_Creditos {
		int	autoriza				= 1;
		int	autorizaImp				= 2;
		int	actNumTransacSim		= 3;	/*actualiza numero de transaccion del simulador  */
		int	actualizaCred			= 4;	/*genera amortizaciones pagare */
		int	actTmpPagAmor			= 5;
		int	actMontosDesembolsados	= 6;
		int	actCondicionesDesem		= 7;	//para condicionesDesem
		int	actMontosDesemReversa	= 8;	// Reversa del Monto Desembolsado en Ventanilla
		int	actTipoPrepago			= 9;	// actualiza le tipo de prepago por credito(CreditosGrupales)
		int	actPagareGrupal			= 10;
		int	autorizaAgro			= 12;
		int	actCuentaClabe			= 17;
		int	actualizaCredAmor		= 30;	/*genera amortizaciones pagare simulando de nuevo*/
		int	condicionaCredito		= 31;	// Condiciona el credito
		int	actCredAgroGenAmort		= 32;
		int	actCredAgroGen			= 33;
		int	actualizaCredAgro		= 34;	/*genera amortizaciones pagare de credito agropecuarios*/
	}

	//---------- Tipo de Simulador ----------------------------------------------------------------
	public static interface Enum_Sim_PagAmortizaciones {
		int pagosCrecientes 		= 1;
		int pagosIguales 			= 2;
		int pagosLibresTasaFija 	= 3;
		int pagosTasaVar 			= 4;
		int pagosLibresTasaVar 		= 5;
		int tmpPagAmort				= 6;
		int pagLibFecCapTasaFija	= 7;// para simular pagos libres que incluyan fecha y capital
		int pagLibFecCapTasaVar		= 8;
		int actPagLib				= 9;  // para indicar que tipod e actualizacion se trata en el simulador
		int actPagLibFecCap			= 10; // para indicar que tipod e actualizacion se trata en el simulador
		int salgosGlobales 			= 11;
		int sugeridoReestructura 	= 12; // lista el calendario sugerido para reestructurar credito
		int amortGrupOpeFormalAgro	= 13; // Lista de amortiaciones de la primera solicitud grupal no formal
		int amortGrupoOpeAlta		= 14; // Lista de amortizaciones de una solicitud grupal no formal que ya fue dada de alta
		int pagLibFecCapTasaFijaReest	= 15;// para simular pagos libres que incluyan fecha y capital
	}

	//-------- Tipos de reportes de Covid para creditos diferidos---------------
	public static interface Enum_Lista_ReporteCovid{
		int reporteCSV				= 1;
		int reporteTxt				= 2;
	}

	public static interface Enum_Lista_RazonesNoPago{
		int combo = 1;
	}
	//-------- Tipos de reportes de OPERACIONES BASICA DE UNIDAD ---------------
	public static interface Enum_Lista_Reporte_OBU{
		int reporteExcel = 1;
	}

	// Tipo fr treporte Razon No Pago
	public static interface Enum_Lista_Reporte_RazonNoPago{
		int reporteExcel = 1;
	}

	public static interface Enum_Llave {
		int llaveURLWS = 50;
		int llaveHeaderWS = 51;
	}

	public CreditosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	//-------------------------------------------------------------------------------------------------
	// -------------------- TRANSACCIONES (ALTAS MODIFICACIONES, ACTUALIZACIONES)
	//-------------------------------------------------------------------------------------------------
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, CreditosBean creditosBean, HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaCreditosGrid(creditosBean);
		loggerSAFI.debug("Servicio-Tasa Base: " + creditosBean.getTasaBase());
		switch (tipoTransaccion) {
			case Enum_Tra_Creditos.alta:
				mensaje = altaCredito(creditosBean, request);
				break;
			case Enum_Tra_Creditos.modificacion:
				mensaje = modificaCredito(creditosBean, request);
				break;
			case Enum_Tra_Creditos.actualizaAut:
				mensaje = actualizaCredito(creditosBean, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.desembolso:
				mensaje = desembolsaCredito(creditosBean);
				break;

			case Enum_Tra_Creditos.actImpPag:
				mensaje = actualizaCredito(creditosBean, tipoActualizacion);
				break;

			case Enum_Tra_Creditos.actuaCredi:
				mensaje = actualizaCredito(creditosBean, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.bajaNumTraSim:
				mensaje = actualizaCredito(creditosBean, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.pagoCredito:
				mensaje = pagaCredito(creditosBean, tipoTransaccion);
				break;
			case Enum_Tra_Creditos.altaGrupal:
				mensaje = altaCreditoGrupal(creditosBean, tipoTransaccion);
				break;
			case Enum_Tra_Creditos.autorizaGrupal:
				mensaje = autorizaCreditoGrupal(creditosBean, tipoTransaccion, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.pagareGrupal:
				mensaje = pagareCreditoGrupal(creditosBean, tipoTransaccion);
				break;
			case Enum_Tra_Creditos.desembolsoGrupal:
				mensaje = desembolsoCreditoGrupal(creditosBean, tipoTransaccion, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.condicionesDesem:
				mensaje = actualizaCredito(creditosBean, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.pagoCreditoGrupalCarCta:
				creditosBean.setFormaPago(CreditosBean.CargoaCuenta);
				mensaje = creditosDAO.pagoGrupalCreditoCargoCuenta(creditosBean);
				break;
			case Enum_Tra_Creditos.reestructura:
				mensaje = creditosDAO.altaReestructura(creditosBean);
				break;
			case Enum_Tra_Creditos.modificaReestructura:
				mensaje = creditosDAO.modificaReestructura(creditosBean);
				break;
			case Enum_Tra_Creditos.prepagoCredito:
				mensaje = creditosDAO.prepagoCredito(creditosBean);
				break;
			case Enum_Tra_Creditos.prepagoCreditoGrupal:
				mensaje = creditosDAO.prepagoCreditoGrupal(creditosBean);
				break;
			case Enum_Tra_Creditos.pagoIntereCreditoCCta:
				mensaje = pagaInteresesCredito(creditosBean);
				break;
			case Enum_Tra_Creditos.pagoCredVerticalCCta:
				mensaje = pagoVerticalCredito(creditosBean);
				break;
			case Enum_Tra_Creditos.condicionaCred:
				mensaje = actualizaCredito(creditosBean, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.pagComCCtaIndiv:
				mensaje = pagaComisionCredito(creditosBean);
				break;
			case Enum_Tra_Creditos.pagComCCtaMasivo:
				mensaje = creditosDAO.pagoComisionMasivo(creditosBean, listaBean);
				break;
			case Enum_Tra_Creditos.altacredGrupalAgro:
				mensaje = altaCreditoGrupal(creditosBean, tipoTransaccion);
				break;
			case Enum_Tra_Creditos.autorizaGrupalAgro:
				mensaje = autorizaCreditoGrupal(creditosBean, tipoTransaccion, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.cancelacionCred:
				mensaje=creditosDAO.cancelacionCreditos(creditosBean);
				break;
		}
		return mensaje;

	}
	/**
	 * Graba Transacción para Créditos Agro.
	 * @param tipoTransaccion : Número de Transacción.
	 * @param tipoActualizacion : Número de actualización.
	 * @param creditosBean : Clase bean con los valores de entrada al SP de Ministración.
	 * @param ministracionesBean : Clase bean con los valores de entrada al SP-MINISTRACREDAGROACT.
	 * @param request : Request HTTP Servlet.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
public MensajeTransaccionBean grabaTransaccionAgro(int tipoTransaccion, int tipoActualizacion, CreditosBean creditosBean,
 MinistracionCredAgroBean ministracionesBean, HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Creditos.desembolsoAgro:
				mensaje = desembolsoCreditoAgro(creditosBean, ministracionesBean, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.cancelacionAgro:
				mensaje = cancelacionAgro(creditosBean, ministracionesBean, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.altaCreditoAgro:
				mensaje = altaCreditoAgro(creditosBean, request);
				break;
			case Enum_Tra_Creditos.modificacionCreditoAgro:
				mensaje = modificaCreditoAgro(creditosBean, request);
				break;
			case Enum_Tra_Creditos.pagareCredAgro:
			case Enum_Tra_Creditos.actuaCreditoAgro:
				mensaje = actualizaCredito(creditosBean, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.cambioFondeador:
				mensaje = cambiaFondeoAgro(creditosBean,request);
				break;
			case Enum_Tra_Creditos.pagareGrupalAgro:
				mensaje = operaCreditoGrupalAgro(creditosBean, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.desembolsoGrupalAgro:
				mensaje = desembolsoCreditoGrupal(creditosBean,tipoTransaccion, tipoActualizacion);
				break;
			case Enum_Tra_Creditos.pagoCreditoAgro:
				mensaje = creditosDAO.pagoAgroCargoCuenta(creditosBean);
				break;
			case Enum_Tra_Creditos.cresimpagcomsergarantia:
				mensaje=creditosDAO.simulacionPagoGarantiasAgro(creditosBean);
			break;

		}
		return mensaje;
	}

	public MensajeTransaccionBean altaCredito(CreditosBean creditosBean, HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeComentario = null;
		MensajeTransaccionBean mensajeAltaCredito = null;
		CreditosBean registros = null;
		String estatus = "CI";
		Integer solicitudCreditoID = Utileria.convierteEntero(creditosBean.getSolicitudCreditoID());
		String requiereSeguroVida = request.getParameter("reqSeguroVida");
		mensaje = creditosDAO.altaCredito(creditosBean, requiereSeguroVida);
		creditosBean.setCreditoID(mensaje.getConsecutivoString());
		creditosBean.setEstatusCred(estatus);
		String creditoID = mensaje.getConsecutivoString();



		if(mensaje.getNumero() == 0 || mensaje.getNumero() == 000){
			if(solicitudCreditoID == 0){
				mensajeAltaCredito = creditosDAO.altaCreditoSolCero(creditosBean, creditoID);
			}
			mensajeComentario = creditosDAO.altaComentarioAltCred(creditosBean);

			if(creditosBean.getServiciosAdicionales() != null && !creditosBean.getServiciosAdicionales().isEmpty()) {
				List listaAltaServiciosAdicionales = obtenerListaServiciosAdicionales(creditosBean);
				serviciosSolCredDAO.altaListaServiciosAdicionales(creditosBean, listaAltaServiciosAdicionales);
			}

		}

		return mensaje;
	}
	/**
	 * Método para dar de alta los Créditos Agropecuarios
	 * @param creditosBean : {@link CreditosBean} Bean con la información del crédito a dar de alta
	 * @param request : {@link HttpServletRequest} Objeto con la información enviada por la pantalla de Creditos Agro
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean altaCreditoAgro(CreditosBean creditosBean, HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		try {
			String requiereSeguroVida = request.getParameter("reqSeguroVida");
			//En este método se da de alta el credito y se actualizan las ministraciones
			//para que se actualize el credito
			mensaje = creditosDAO.altaCreditoAgropecuario(creditosBean, requiereSeguroVida, Enum_Act_SolAgro.actualizacionCreditoAgro);
			return mensaje;
		} catch (Exception ex) {
			ex.printStackTrace();
			if(mensaje!=null){
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion(ex.getMessage());
			}
		}
		return mensaje;
	}

	public MensajeTransaccionBean modificaCredito(CreditosBean creditosBean, HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		mensaje = creditosDAO.modificaCredito(creditosBean, request);
		if(mensaje.getNumero() == 0 || mensaje.getNumero() == 000){
			if(creditosBean.getServiciosAdicionales() != null && !creditosBean.getServiciosAdicionales().isEmpty()) {
				List listaAltaServiciosAdicionales = obtenerListaServiciosAdicionales(creditosBean);
				serviciosSolCredDAO.altaListaServiciosAdicionales(creditosBean, listaAltaServiciosAdicionales);
			}
		}
		return mensaje;
	}

	public MensajeTransaccionBean modificaCreditoAgro(CreditosBean creditosBean, HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		try {
			//En este método se modifica el credito y se actualizan las ministraciones
			//para que se actualize el credito
			mensaje = creditosDAO.modificaCreditoAgro(creditosBean, request,Enum_Act_SolAgro.actualizacionCreditoAgro);
			return mensaje;
		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje != null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion(ex.getMessage());
			}
		}
		return mensaje;
	}
	/**
	 * Desembolso de credito individual
	 * @param creditosBean Bean de CreditosBean
	 * @return
	 */
	public MensajeTransaccionBean desembolsaCredito(CreditosBean creditosBean){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeComentario = null;
		CreditosBean registros = null;
		String estatus = "CD";

		mensaje = creditosDAO.desembolsaCredito(creditosBean);
		creditosBean.setCreditoID(mensaje.getConsecutivoString());
		creditosBean.setEstatusCred(estatus);
		if(mensaje.getNumero() == 0 || mensaje.getNumero() == 000){

			mensajeComentario = creditosDAO.altaComentarioDesCred(creditosBean);

		}
		return mensaje;
	}
	/**
	 * Método de desembolso de créditos Agro. Se obtiene la fecha y el monto delcapital de la ministración
	 * elegida desde el calendario de ministraciones para realizar el desembolso.
	 * @param creditosBean : Clase bean con los valores de entrada al SP de Ministraciones.
	 * @param ministacionesBean : Clase bean con los valores de entrada al SP-MINISTRACREDAGROACT.
	 * @param numActualizacion : Número de actualización.
	 * @return MensajeTransaccionBean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean desembolsoCreditoAgro(CreditosBean creditosBean, MinistracionCredAgroBean ministacionesBean, int numActualizacion) {
		MensajeTransaccionBean mensaje = null;
		boolean validaUsuario = (ministacionesBean.getUsuarioAutoriza().equalsIgnoreCase("")? false : true);
		mensaje = creditosDAO.desembolsaCreditoAgro(creditosBean, ministacionesBean, validaUsuario);

		return mensaje;
	}
	/**
	 * Realiza la cancelación de ministraciones.
	 * @param creditosBean : Clase bean {@link CreditosBean}.
	 * @param ministacionesBean : Clase bean con los valores necesarios para realizar la cancelación.
	 * @param numActualizacion : Número para actualizar el estatus de la ministración a cancelar.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean cancelacionAgro(CreditosBean creditosBean, MinistracionCredAgroBean ministacionesBean,
			int numActualizacion){
		MensajeTransaccionBean mensaje = null;
		long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
		mensaje = ministraCredAgroDAO.cancelacionMinistracion(ministacionesBean, numeroTransaccion, numActualizacion);
		return mensaje;
	}

	//cambio de instituto de fndeo para el credito
	public MensajeTransaccionBean cambiaFondeoAgro(CreditosBean creditosBean, HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;

		mensaje= cambioFondeadorAgroDAO.validaUsuario(creditosBean);
		if(mensaje.getNumero() == 0){
			//cambio de fondeador
			mensaje = cambioFondeadorAgroDAO.cambioFuenteFondeo(creditosBean);
		}
		return mensaje;
	}


	public MensajeTransaccionBean pagaCredito(CreditosBean creditosBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		mensaje = creditosDAO.PagoCreditoCargoCuenta(creditosBean);
		return mensaje;
	}

	public MensajeTransaccionBean altaCreditoGrupal(CreditosBean creditosBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		mensaje = creditosDAO.altaCreditoGrupalPro(creditosBean, tipoTransaccion);
		return mensaje;
	}

	public MensajeTransaccionBean autorizaCreditoGrupal(CreditosBean creditosBean, int tipoTransaccion, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeEscala = null;
		OpeEscalamientoInternoBean opeEscalamientoInt = new OpeEscalamientoInternoBean();
		opeEscalamientoInt.setFolioOperacionID(creditosBean.getCreditoID());
		opeEscalamientoInt.setResultadoRevision(creditosBean.getGrupoID()); // PARA GRUPAL (NUM GRUPO)
		opeEscalamientoInt.setNombreCliente(nomProcesoEsc);
		mensajeEscala =opeEscalamientoInternoServicio.grabaTransaccion(numTransaccionEscala, opeEscalamientoInt);
		numResp=mensajeEscala.getNumero();
		if(numResp == 502 && tipoTransaccion == Enum_Tra_Creditos.autorizaGrupal){
			mensaje = creditosDAO.autorizaCreditoGrupal(creditosBean, tipoTransaccion);
			return mensaje;
		}else if(numResp == 502 && tipoTransaccion == Enum_Tra_Creditos.autorizaGrupalAgro){
			mensaje = creditosDAO.creditosGrupalesAgro(creditosBean, tipoActualizacion);
			return mensaje;
		}
		else{

		return	mensajeEscala;
		}

	}
	public MensajeTransaccionBean pagareCreditoGrupal(CreditosBean creditosBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
			mensaje = creditosDAO.pagareCreditoGrupal(creditosBean, tipoTransaccion);
		return mensaje;
	}

	public MensajeTransaccionBean operaCreditoGrupalAgro(CreditosBean creditosBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
			mensaje = creditosDAO.creditosGrupalesAgro(creditosBean, tipoActualizacion);
		return mensaje;
	}

	/**
	 * Desembolso de credito tipo de transaccion 16
	 * @param creditosBean	Creditos Bean
	 * @param tipoTransaccion	tipo de transaccion para esta 16
	 * @return
	 */
	public MensajeTransaccionBean desembolsoCreditoGrupal(CreditosBean creditosBean, int tipoTransaccion, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = creditosDAO.desembolsoCreditoGrupal(creditosBean, tipoTransaccion, tipoActualizacion);
		return mensaje;
	}

	public MensajeTransaccionBean pagaInteresesCredito(CreditosBean creditosBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = creditosDAO.PagoInteresCreditoCargoCuenta(creditosBean);
		return mensaje;
	}

	public MensajeTransaccionBean pagoVerticalCredito(CreditosBean creditosBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = creditosDAO.PagoVerticalCreditoCargoCuenta(creditosBean);
		return mensaje;
	}

	public MensajeTransaccionBean pagaComisionCredito(CreditosBean creditosBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = creditosDAO.PagoComisionCreditoCargoCuenta(creditosBean);
		return mensaje;
	}


	public MensajeTransaccionBean actualizaCredito(CreditosBean creditosBean, int tipoActualizacion) {
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeBanorte = null;
		MensajeTransaccionBean mensajeTelecom = null;
		switch (tipoActualizacion) {
			case Enum_Act_Creditos.autoriza:
			case Enum_Act_Creditos.autorizaAgro:
				mensaje = autorizaCredito(creditosBean, tipoActualizacion);
				break;
			case Enum_Act_Creditos.autorizaImp:
				mensaje = creditosDAO.autorizaPagImp(creditosBean, tipoActualizacion,0);
				break;
			/*genera amortizaciones pagare*/
			case Enum_Act_Creditos.actualizaCred:
				mensaje = creditosDAO.generarAmortizaciones(creditosBean, tipoActualizacion);
				
				int tipoConsulta = 13;
				String numCteEspecifico = "";
				ParamGeneralesBean parameGeneralesBean = new ParamGeneralesBean();

				parameGeneralesBean = paramGeneralesServicio.consulta(tipoConsulta, parameGeneralesBean);
				numCteEspecifico = parameGeneralesBean.getValorParametro();
				
				if(numCteEspecifico.equalsIgnoreCase("43") && mensaje.getNumero() == 0) {
					ReferenciasPagosBean referenciasPagosBanorteBean = new ReferenciasPagosBean();
					ReferenciasPagosBean referenciasPagosTelecomBean = new ReferenciasPagosBean();

					referenciasPagosBanorteBean.setTipoCanalID("1");
					referenciasPagosBanorteBean.setInstrumentoID(creditosBean.getCreditoID());
					referenciasPagosBanorteBean.setOrigen("1");
					referenciasPagosBanorteBean.setInstitucionID(creditosBean.getInstitucionBanorte());
					referenciasPagosBanorteBean.setReferencia(creditosBean.getReferenciaBanorte());
					referenciasPagosBanorteBean.setTipoReferencia("A");
					
					try{
						mensajeBanorte = referenciasPagosDAO.bajaInstitucion(referenciasPagosBanorteBean);
						if (mensajeBanorte.getNumero() != 0) {
							throw new Exception(mensajeBanorte.getDescripcion());
						}
						
						mensajeBanorte = referenciasPagosDAO.alta(referenciasPagosBanorteBean, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBanorte.getNumero() != 0) {
								throw new Exception(mensajeBanorte.getDescripcion());
						}
						
						try{
							if(mensajeBanorte.getNumero() == 0) {
								referenciasPagosTelecomBean.setTipoCanalID("1");
								referenciasPagosTelecomBean.setInstrumentoID(creditosBean.getCreditoID());
								referenciasPagosTelecomBean.setOrigen("1");
								referenciasPagosTelecomBean.setInstitucionID(creditosBean.getInstitucionTelecom());
								referenciasPagosTelecomBean.setReferencia(creditosBean.getReferenciaTelecom());
								referenciasPagosTelecomBean.setTipoReferencia("A");
								mensajeTelecom = referenciasPagosDAO.bajaInstitucion(referenciasPagosTelecomBean);
								if (mensajeTelecom.getNumero() != 0) {
									throw new Exception(mensajeTelecom.getDescripcion());
								}

								mensajeTelecom = referenciasPagosDAO.alta(referenciasPagosTelecomBean, parametrosAuditoriaBean.getNumeroTransaccion());
								if (mensajeTelecom.getNumero() != 0) {
									throw new Exception(mensajeTelecom.getDescripcion());
							}
							}
						}catch (Exception e) {
							if (mensajeTelecom.getNumero() == 0) {
								mensajeTelecom.setNumero(999);
							}
							mensajeTelecom.setDescripcion(e.getMessage());
							mensajeTelecom.setNombreControl("grabar");
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al grabar las Referencias Banorte: ", e);
						}
						
						
						
						
					}catch (Exception e) {
						if (mensajeBanorte.getNumero() == 0) {
							mensajeBanorte.setNumero(999);
						}
						mensajeBanorte.setDescripcion(e.getMessage());
						mensajeBanorte.setNombreControl("grabar");
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"EError al grabar las Referencias Telecom: ", e);
					}
					
					
					
					
					
				}
				
				break;
			/*genera amortizaciones pagare simulando de nuevo*/
			case Enum_Act_Creditos.actualizaCredAmor:
				mensaje = creditosDAO.autorizaPagImp(creditosBean, Enum_Act_Creditos.actNumTransacSim,0);
				if (mensaje.getNumero() == 0) {
					mensaje = creditosDAO.generarAmortizaciones(creditosBean, tipoActualizacion);
				}
				break;
			case Enum_Act_Creditos.actTmpPagAmor:
				mensaje = creditosDAO.bajaTmpPagAmor(creditosBean);
				break;
			case Enum_Act_Creditos.actCondicionesDesem:
				mensaje = creditosDAO.actuaTipoDisper(creditosBean, tipoActualizacion);
				break;
			case Enum_Act_Creditos.actPagareGrupal:
				mensaje = creditosDAO.autorizaPagImp(creditosBean, tipoActualizacion,0);
				break;
			case Enum_Act_Creditos.condicionaCredito:
				mensaje = creditosDAO.condiciona(creditosBean);
				break;
			case Enum_Act_Creditos.actCredAgroGen:
			case Enum_Act_Creditos.actCredAgroGenAmort:
				mensaje = creditosDAO.actualizaCredPagareAgro(creditosBean, tipoActualizacion);
				break;
            case Enum_Act_Creditos.actCuentaClabe:
				mensaje = creditosDAO.actualizaCuentaClabe(creditosBean, tipoActualizacion);
				break;
		}
		return mensaje;
	}


	public MensajeTransaccionBean autorizaCredito(CreditosBean creditosBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeEscala = null;
		MensajeTransaccionBean mensajeComentario = null;
		OpeEscalamientoInternoBean opeEscalamientoInt = new OpeEscalamientoInternoBean();
		CreditosBean registros = null;
		String estatus = "CA";
		opeEscalamientoInt.setFolioOperacionID(creditosBean.getCreditoID());
		opeEscalamientoInt.setNombreCliente(nomProcesoEsc);
		opeEscalamientoInt.setResultadoRevision("0"); // PARA GRUPAL NO
		// Proceso de escalamiento interno
		mensajeEscala =opeEscalamientoInternoServicio.grabaTransaccion(numTransaccionEscala, opeEscalamientoInt);
		numResp=mensajeEscala.getNumero();
		if(numResp == 502 ){

			mensaje = creditosDAO.autoriza(creditosBean, tipoActualizacion);
			creditosBean.setCreditoID(mensaje.getConsecutivoString());
			creditosBean.setEstatusCred(estatus);

		if(mensaje.getNumero() == 0 || mensaje.getNumero() == 000){
			mensajeComentario = creditosDAO.altaComentarioAutCred(creditosBean);

		}

			return mensaje;

		}else{
			return mensajeEscala;
		}
	}





	//Recalculo de Saldos para pagos libres con tasa fija
	public List grabaListaSimPagLib(CreditosBean creditosBean, String montosCapital){
		List listaCreditos = null;
		List listaCreditosMensaje = (List)new ArrayList();
		MensajeTransaccionBean mensaje = null;
		ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLib(montosCapital);

		int tipoConsulta = 24;
		String cobraAccesoriosGen = "N";
		ParamGeneralesBean parameGeneralesBean = new ParamGeneralesBean();

		parameGeneralesBean = paramGeneralesServicio.consulta(tipoConsulta, parameGeneralesBean);
		cobraAccesoriosGen = parameGeneralesBean.getValorParametro();

		creditosBean.setCobraAccesoriosGen(cobraAccesoriosGen);


		String diaHabil= creditosBean.getFechaInhabil();
		mensaje= creditosDAO.grabaListaSimPagLib(creditosBean, listaSimPagLib,Enum_Sim_PagAmortizaciones.actPagLib, diaHabil);
		listaCreditos = creditosDAO.recalculoSimPagLibresFecCap(creditosBean);

		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;
	}

	//Recalculo de Saldos para pagos libres con tasa variable
	public List grabaListaSimPagLibTasaVar(CreditosBean creditosBean, String montosCapital){
		List listaCreditos = null;
		List listaCreditosMensaje = (List)new ArrayList();
		MensajeTransaccionBean mensaje = null;
		ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLib(montosCapital);
		String diaHabil= creditosBean.getFechaInhabil();
		mensaje= creditosDAO.grabaListaSimPagLib(creditosBean, listaSimPagLib,Enum_Sim_PagAmortizaciones.actPagLib, diaHabil);
		listaCreditos = simuladorAmortizaciones(Enum_Sim_PagAmortizaciones.tmpPagAmort,creditosBean);
		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;
	}

	//calculo de fecha exigible y saldos  para pagos libres con tasa fija
	public List grabaListaSimPagLibFecCap(CreditosBean creditosBean, String montosCapital){
		List listaCreditos = null;
		List listaCreditosMensaje = (List)new ArrayList();
		MensajeTransaccionBean mensaje = null;


		int tipoConsulta = 24;
		String cobraAccesoriosGen = "N";
		ParamGeneralesBean parameGeneralesBean = new ParamGeneralesBean();

		parameGeneralesBean = paramGeneralesServicio.consulta(tipoConsulta, parameGeneralesBean);
		cobraAccesoriosGen = parameGeneralesBean.getValorParametro();

		creditosBean.setCobraAccesoriosGen(cobraAccesoriosGen);

		String diaHabil="";
		ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLibFecCap(montosCapital);
		diaHabil= creditosBean.getFechaInhabil();
		mensaje= creditosDAO.grabaListaSimPagLib(creditosBean, listaSimPagLib,Enum_Sim_PagAmortizaciones.actPagLibFecCap, diaHabil);
		listaCreditos = creditosDAO.recalculoSimPagLibresFecCap(creditosBean);

		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;
	}



	//calculo de fecha exigible y saldos  para pagos libres con tasa fija
	public List grabaListaSimPagLibFecCapTasVar(CreditosBean creditosBean, String montosCapital){
		List listaCreditos = null;
		List listaCreditosMensaje = (List)new ArrayList();
		MensajeTransaccionBean mensaje = null;

		String diaHabil="";

		ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLibFecCap(montosCapital);


		//creditosBean.setFechaInhabil("S");
		diaHabil= creditosBean.getFechaInhabil();
		mensaje= creditosDAO.grabaListaSimPagLib(creditosBean, listaSimPagLib,Enum_Sim_PagAmortizaciones.actPagLibFecCap, diaHabil);
		listaCreditos = simuladorAmortizaciones(Enum_Sim_PagAmortizaciones.tmpPagAmort,creditosBean);
		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;
	}

	// metodo para separas el String que contiene los montos ddel capital en un bean
	private List creaListaSimPagLib(String montosCapital){

		StringTokenizer tokensBean = new StringTokenizer(montosCapital, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaMontos = new ArrayList();
		AmortizacionCreditoBean amortizacionesBean;

		while(tokensBean.hasMoreTokens()){
			amortizacionesBean = new AmortizacionCreditoBean();

			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

			amortizacionesBean.setAmortizacionID(tokensCampos[0]);
			amortizacionesBean.setCapital(tokensCampos[1]);
			amortizacionesBean.setNumTransaccion(tokensCampos[2]);

			listaMontos.add(amortizacionesBean);
		}

		return listaMontos;
	}

	private List<AmortizacionCreditoBean> creaListaSimPagLibAgro(String montosCapital) throws Exception {
		ArrayList<AmortizacionCreditoBean> listaMontos = null;
		try {
			StringTokenizer tokensBean = new StringTokenizer(montosCapital, "[");
			String stringCampos;
			String tokensCampos[];
			listaMontos = new ArrayList<AmortizacionCreditoBean>();
			AmortizacionCreditoBean amortizacionesBean;

			while (tokensBean.hasMoreTokens()) {
				amortizacionesBean = new AmortizacionCreditoBean();

				stringCampos = tokensBean.nextToken();
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

				amortizacionesBean.setAmortizacionID(tokensCampos[0]);
				amortizacionesBean.setCapital(tokensCampos[1]);
				amortizacionesBean.setNumTransaccion(tokensCampos[2]);

				listaMontos.add(amortizacionesBean);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception("Error al Crear Lista de Amortizaciones.");
		}

		return listaMontos;
	}

	// metodo para separas el String que contiene: la fecha de inicio, de vencimiento y los montos del capital en un bean
	private List creaListaSimPagLibFecCap(String montosCapital){
		StringTokenizer tokensBean = new StringTokenizer(montosCapital, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaMontos = new ArrayList();
		AmortizacionCreditoBean amortizacionesBean;

		while(tokensBean.hasMoreTokens()){
			amortizacionesBean = new AmortizacionCreditoBean();

			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

			amortizacionesBean.setAmortizacionID(tokensCampos[0]);
			amortizacionesBean.setCapital(tokensCampos[1]);
			amortizacionesBean.setFechaInicio(tokensCampos[2]);
			amortizacionesBean.setFechaVencim(tokensCampos[3]);

			listaMontos.add(amortizacionesBean);
		}

		return listaMontos;
	}
	private List creaListaSimPagLibFecCapAgro(String montosCapital){
		StringTokenizer tokensBean = new StringTokenizer(montosCapital, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaMontos = new ArrayList();
		AmortizacionCreditoBean amortizacionesBean;

		while(tokensBean.hasMoreTokens()){
			amortizacionesBean = new AmortizacionCreditoBean();

			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

			amortizacionesBean.setAmortizacionID(tokensCampos[0]);
			amortizacionesBean.setCapital(tokensCampos[1]);
			amortizacionesBean.setFechaInicio(tokensCampos[2]);
			amortizacionesBean.setFechaVencim(tokensCampos[3]);

			listaMontos.add(amortizacionesBean);
		}

		return listaMontos;
	}

	//-------------------------------------------------------------------------------------------------
	// -------------------- CONSULTAS -----------------------------------------------------------------
	//-------------------------------------------------------------------------------------------------

	public CreditosBean consulta(int tipoConsulta, CreditosBean creditosBean) {
		CreditosBean creditos = null;
		switch (tipoConsulta) {
			case Enum_Con_Creditos.principal :
				creditos = creditosDAO.consultaPrincipal(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.creditoAgro :
				creditos = creditosDAO.consultaPrincipalAgro(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.foranea :
				creditos = creditosDAO.consultaForanea(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.pagareImp :
				creditos = creditosDAO.consultaPagareImp(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.ExigibleSinProy :
				creditos = creditosDAO.consultaExigibleSinProy(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.Cond_Quitas :
				creditos = creditosDAO.consultaExigibleSinProy(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.actTransacSim :
				creditos = creditosDAO.consultaNumTransaccion(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.pago :
				creditos = creditosDAO.consultaPagoCredito(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.pagoExigible:
			case Enum_Con_Creditos.informacionCredito:
				creditos = creditosDAO.consultaPagoCredExigible(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.tasasCredito :
				creditos = creditosDAO.consultaTasaCredito(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.Con_ComDesVent :
				creditos = creditosDAO.consultaComDesVent(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.fechaCorte :
				creditos = creditosDAO.consultaFechaCorte(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.Con_GLVent :
				creditos = creditosDAO.consultaGLVentanilla(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.resumCliente :
				creditos = creditosDAO.consultaResumenClienteCredito(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.credDiasAtraso :
				creditos = creditosDAO.consultaDiasAtraso(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.exigibleCondona :
				creditos = creditosDAO.consultaExigibleCondonacion(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.finiquitoLiq :
				creditos = creditosDAO.consultaFiniquitoLiqAnticipada(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.generalesCredito :
				creditos = creditosDAO.consultaGeneralesCredito(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.conCreditoWS :
				creditos = creditosDAO.consultaCreditoWS(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.conCreditoBEWS :
				creditos = creditosDAO.consultaCreditosBEWS(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.creditoRenovar :
				creditos = creditosDAO.consultaCreditoRenovar(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.creditoReestructurar :
				creditos = creditosDAO.consultaCreditoReestructurar(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.creditoPagoVertical :
				creditos = creditosDAO.consultaCreditoPagoVertical(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.creditosConSeguroCuota :
				creditos = creditosDAO.consultaCredConSeguro(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.creditosCondicionados :
				creditos = creditosDAO.consultaCredCond(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.genCobComCargCta :
				creditos = creditosDAO.consultaCobComApertCargoCta(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.cambioFondeo :
				creditos = creditosDAO.consultaCambioFondeo(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.aplicaGaranAgro :
				creditos = creditosDAO.consultaApliGarAgro(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.generalesCreditoAgro :
				creditos = creditosDAO.consultaGralesCreditoAgro(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.finiquitoLiqAgro :
				creditos = creditosDAO.consultaLiqAnticipadaAgro(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.pagoAgro :
				creditos = creditosDAO.consultaPagoCreditoAgro(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.pagoExigibleAgro :
				creditos = creditosDAO.consultaExigibleAgro(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.riesgosSaldos :
				creditos = creditosDAO.consultaSaldos(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.creditosCont :
				creditos = creditosDAO.consultaContingente(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.conAccesorioProd :
				creditos = creditosDAO.consultaAccesorios(creditosBean,tipoConsulta);
				break;
			case Enum_Con_Creditos.conAccesorioProdPla:
				creditos = creditosDAO.consultaAccesorios(creditosBean,tipoConsulta);
				break;
			case Enum_Con_Creditos.conCobAccesorios:
				creditos = creditosDAO.consultaComDesVent(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.conGarFOGAFI :
				creditos = creditosDAO.consultaGarFOGAFI(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.conSaldoFOGAFI :
				creditos = creditosDAO.consultaFOGAFI(creditosBean,tipoConsulta);
				break;
			case Enum_Con_Creditos.conMontoAutoMod :
				creditos = creditosDAO.consultaMontoAutoMod(creditosBean,tipoConsulta);
				break;
			case Enum_Con_Creditos.PagoCredCont :
				creditos = creditosDAO.consultaPagoCreditoCont(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.PagCreExiCont :
				creditos = creditosDAO.consultaPagoCredExigibleCont(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.Cond_QuitasCont :
				creditos = creditosDAO.consultaExigibleSinProyCont(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.creditoRenovarAgro :
				creditos = creditosDAO.consultaCreditoRenovarAgro(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.con_InfoCredSuspencion :
				creditos = creditosDAO.consultaInfoCredSuspencion(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.conCambioFuentFondCred :
				creditos = creditosDAO.conCambioFuentFondCred(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.conCartaLiquidacion :
				creditos = creditosDAO.consultaInfoCartaLiq(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.conNotaCargo :
				creditos = creditosDAO.creditoParaNotasCargo(creditosBean, tipoConsulta);
				break;
			case Enum_Con_Creditos.conInstitucionConvenio:
				creditos = creditosDAO.consultaInstitucionConvenio(creditosBean, tipoConsulta);
				break;
		}
		return creditos;
	}
	// consulta los detalles del pago  del credito
	public DetallePagoBean consultaDetallePago(int tipoConsulta, DetallePagoBean detallePagoBean){
		DetallePagoBean detallePago = null;
		switch (tipoConsulta) {
			case Enum_Con_Creditos.principal:
				detallePago = creditosDAO.consultaDetallePagoCredito(detallePagoBean, tipoConsulta);
				break;
		}
		return detallePago;
	}


	//Consultas de la Bitacora de la Cobranza Automatica
	public BitacoraCobAutoBean consultaBitacoraCobranzaAut(int tipoConsulta,
														   BitacoraCobAutoBean bitacoraCobAutoBean){
		BitacoraCobAutoBean bitacora = null;
		switch (tipoConsulta) {
			case Enum_Con_Creditos.principal:
				bitacora = creditosDAO.consultaCobranzaAutDelDia(bitacoraCobAutoBean, tipoConsulta);
				break;
		}
		return bitacora;
	}

	// Consulta para el cálculo de Esquema de Tasa
	public  CicloCreditoBean consultaTasa(int numCred, CreditosBean creditosBean){
		CicloCreditoBean cicloCreditoBean = new CicloCreditoBean();

		cicloCreditoBean.setSucursal(creditosBean.getSucursal());
		cicloCreditoBean.setProductoCreditoID(creditosBean.getProducCreditoID());
		cicloCreditoBean.setNumCreditos(numCred);
		cicloCreditoBean.setMontoCredito(creditosBean.getMontoCredito());
		cicloCreditoBean.setCalificaCliente(creditosBean.getCalificaCliente());
		cicloCreditoBean.setPlazoID(creditosBean.getPlazoID());
		cicloCreditoBean.setEmpresaNomina(creditosBean.getEmpresaNomina());
		cicloCreditoBean.setConvenioNominaID(creditosBean.getConvenioNominaID());
		cicloCreditoBean = creditosDAO.consultaTasaCredPrin(cicloCreditoBean);

			return cicloCreditoBean;
	}

	//-------------------------------------------------------------------------------------------------
	// -------------------- LISTAS --------------------------------------------------------------------
	//-------------------------------------------------------------------------------------------------

	public List lista(int tipoLista, CreditosBean creditosBean) {
		List listaCreditos = null;
		switch (tipoLista) {
			case Enum_Lis_Creditos.principal :
			case Enum_Lis_Creditos.creFuenteFondeo :
				listaCreditos = creditosDAO.listaPrincipal(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.pagareNoImp :
				listaCreditos = creditosDAO.listaPrincipal(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creditosVigentes :
				listaCreditos = creditosDAO.listaCreditosVigentes(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creAutInac :
				listaCreditos = creditosDAO.listaCreditosAutInac(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.resumCteCredito :
				listaCreditos = creditosDAO.listaCreditosResumCte(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creditosInact :
				listaCreditos = creditosDAO.listaCreditosInactivos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.credAutoPagImp :
				listaCreditos = creditosDAO.listaCreditosAutorizadosPagareImp(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.credIndividuales :
				listaCreditos = creditosDAO.listaCreditosIndividuales(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creVigVenci :
				listaCreditos = creditosDAO.listaCreditosVigentesOVencidos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creditoInvGar :
				listaCreditos = creditosDAO.listaCreditosAutInac(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.todosCreditosCte :
				listaCreditos = creditosDAO.listaTodosCreditoCte(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.credVigPagados :
				listaCreditos = creditosDAO.listaPrincipal(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.credTipoBloq :
				listaCreditos = creditosDAO.listaTipoBloq(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.credCastigados :
				listaCreditos = creditosDAO.listaPrincipal(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.proteccionCred :
				listaCreditos = creditosDAO.listaCreditosVigentesCte(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.credBloqSaldo :
				listaCreditos = creditosDAO.listaCreditoBloqueaSaldo(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creAutVigVen :
				listaCreditos = creditosDAO.listaCreditosAutInac(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.credCastigados2 :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creVigVenci2 :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.crePagados :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creInactivos :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creVigentes :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;

			case Enum_Lis_Creditos.creAvalados :
				listaCreditos = creditosDAO.listaCreditosAvalados(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creInactivosVent :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;

			case Enum_Lis_Creditos.creVigVenci2Suc :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista); //Marcos
				break;

			case Enum_Lis_Creditos.creVigentesSuc :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista); //Marcos
				break;

			case Enum_Lis_Creditos.creCobroComxAper :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;

			case Enum_Lis_Creditos.creCobPolizaCobRies :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creAplipolizaCobRies :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;

			case Enum_Lis_Creditos.creAval :
				listaCreditos = creditosDAO.listaCreditosAvaladosCte(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creReestructura :
				listaCreditos = creditosDAO.listaCreditosReestructura(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creVigVenci2Ven :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creVigentesVen :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.devoGaranLiq :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.crePerPrepago :
				listaCreditos = creditosDAO.listaCreditos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.rescredliqInus :
				listaCreditos = creditosDAO.listaCreditosLiq(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creIndVigBVenci :
				listaCreditos = creditosDAO.listaCreditosVigentesOVencidos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.CreVigVenciCli :
				listaCreditos = creditosDAO.listaCreditosVigentesOVencidosCli(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creMonitor :
				listaCreditos = creditosDAO.listaCreditosAutorizadosPagareImp(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.CreVigVencInac :
				listaCreditos = creditosDAO.listaCreditosCobCom(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.CredConGarSinFondeo :
				listaCreditos = creditosDAO.listaCredConGarSinFondeo(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.principalAgro :
				listaCreditos = creditosDAO.listaPrincipal(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.credAutoPagImpAgro :
				listaCreditos = creditosDAO.listaCreditosAutorizadosPagareImp(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creVigentesVenAgro :
				listaCreditos = creditosDAO.listaCreditosVigentesOVencidos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creReacreditado :
				listaCreditos = creditosDAO.listaCreditosVigentesOVencidos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creVigVenciNOAgro :
				listaCreditos = creditosDAO.listaCreditosVigentesOVencidos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creditosCont :
				listaCreditos = creditosDAO.listaPrincipal(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creAccesorios:
				listaCreditos = creditosDAO.listaPrincipal(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.creditosGarFOGAFI :
				listaCreditos = creditosDAO.listaCreditoBloqueaSaldo(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.listaPagoCreditos:
				listaCreditos = creditosDAO.listaPagoCreditos(creditosBean, tipoLista);
				break;
			case Enum_Lis_Creditos.listaGuardaValores :
				listaCreditos = creditosDAO.listaGuardaValores(creditosBean, tipoLista);
			break;
			case Enum_Lis_Creditos.listCredSuspension :
				listaCreditos = creditosDAO.listCredSuspension(creditosBean, tipoLista);
			break;
			case Enum_Lis_Creditos.lisCambioFuentFondCred :
				listaCreditos = creditosDAO.lisCambioFuentFondCred(creditosBean, tipoLista);
			break;
			case Enum_Lis_Creditos.listCredVigVen:
				listaCreditos = creditosDAO.listCartaLiquidacion(creditosBean, tipoLista);
			break;
			case Enum_Lis_Creditos.lisClienteCartas:
				listaCreditos = creditosDAO.listaCreditosVigentesOVencidos(creditosBean, tipoLista);
			break;
			case Enum_Lis_Creditos.lisNotasCargo:
				listaCreditos = creditosDAO.listaCreditosParaNotasCargo(tipoLista, creditosBean);
			break;
		}

		return listaCreditos;
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista, CreditosBean creditosBean) {
		List listaCreditos = null;
		switch(tipoLista){
			case Enum_Lis_Creditos.creditosCliente:
				listaCreditos = creditosDAO.listaCreditosCliente(creditosBean, tipoLista);
			break;
			case (Enum_Lis_Creditos.creVigVenci):
				listaCreditos =  creditosDAO.listaCreditosVigentesOVencidosCombo(creditosBean, tipoLista);
			break;
			case Enum_Lis_Creditos.credCliente:
				listaCreditos = creditosDAO.listaCreditosCliente(creditosBean, tipoLista);
			break;
			case Enum_Lis_Creditos.credBloqSaldo:
				listaCreditos = creditosDAO.listaCreditoBloqueaSaldo(creditosBean, tipoLista);
		}
		return listaCreditos.toArray();
	}

	//lista combo para razonesImpago
	public Object[] listComboImpago(int tipoLista, RazonesNoPagoBean razonesNoPagoBean){
		List listaRazones = null;
		switch(tipoLista){
			case Enum_Lista_RazonesNoPago.combo:
				listaRazones = creditosDAO.listaRazonesNoPago(tipoLista);
			break;
		}
		return listaRazones.toArray();
	}


	public List listaConsultaCreditos(int tipoLista, CreditosBean creditosBean){

		List listaCreditos = null;

		switch(tipoLista){
			case Enum_Lis_Creditos.principal:
				listaCreditos = creditosDAO.listaConsultaCreditos(creditosBean, tipoLista);
				break;

		}

		return listaCreditos;
	}


	/*case para listas de reportes de credito*/
	public List listaReportesCreditos(int tipoLista, CreditosBean creditosBean, HttpServletResponse response){

		 List listaCreditos=null;

		switch(tipoLista){

			case Enum_Lis_CredRep.salTotalRepEx:
				listaCreditos = creditosDAO.consultaSaldosTotalesExcel(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.salCapitRepEx:
				listaCreditos = creditosDAO.consultaSaldosCapitalExcel(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.ministraRepEx:
				listaCreditos = creditosDAO.consultaMinistracionesExcel(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.pagosRealiRepEx:
				listaCreditos = creditosDAO.consultaPagosRealizadosExcel(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.masivoFR_RepEx:
				listaCreditos = creditosDAO.consultaMasivoFR_Excel(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.envBuroCred:
				listaCreditos = creditosDAO.consultaReporteEnvioBuroCredito(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.vencimientos:
				listaCreditos = creditosDAO.consultaRepProxVencimientos(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.movimientosCred:
				listaCreditos = creditosDAO.consultaReporteMovimientosCredito(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.antiguDeSaldos:
				listaCreditos = creditosDAO.consultaRepAntDeSaldos(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.vencimiPasivos:
				listaCreditos = creditosDAO.consultaRepVencimientosPasivos(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.estCredPrevRepEx:
				listaCreditos = creditosDAO.consultaRepEstimacionesCredPrev(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.estCalifPorResRepEx:
				listaCreditos = creditosDAO.consultaRepCalificacionesPorcRes(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.comPendPagoRepEX:
				listaCreditos = creditosDAO.consultaRepComisiones(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.movimientosCredsum:
				listaCreditos = creditosDAO.consultaReporteMovimientosCreditoSum(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.repSaldosCarAvaRef:
				listaCreditos = creditosDAO.consultaSaldosCarteraAvaReferencias(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.creditosCancelados:
				listaCreditos = creditosDAO.consultaCancelacionCred(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.repPagAccesorios:
				listaCreditos = creditosDAO.consultaRepPagosdeAccesoriosExcel(creditosBean, tipoLista);
				break;
		}

		return listaCreditos;
	}

	public List listaReportesCreditosServiciosAdicionales(int tipoLista, ReporteServiciosAdicionalesBean creditosBean, HttpServletResponse response){

		 List listaCreditos=null;

		switch(tipoLista){

			case Enum_Lis_CredRep.repServiciosAdicionales:
				listaCreditos = creditosDAO.consultaRepServicosAdicioanlesExcel(creditosBean, tipoLista);
				break;
		}

		return listaCreditos;
	}


	public List simuladorAmortizaciones(int tipoLista, CreditosBean creditosBean){
		List listaCreditos = null;

		int tipoConsulta = 24;
		String cobraAccesoriosGen = "N";
		ParamGeneralesBean parameGeneralesBean = new ParamGeneralesBean();

		parameGeneralesBean = paramGeneralesServicio.consulta(tipoConsulta, parameGeneralesBean);
		cobraAccesoriosGen = parameGeneralesBean.getValorParametro();

		creditosBean.setCobraAccesoriosGen(cobraAccesoriosGen);

		switch (tipoLista) {
			case Enum_Sim_PagAmortizaciones.pagosCrecientes:
				listaCreditos = creditosDAO.SimPagCrecientes(creditosBean);
				break;
			case Enum_Sim_PagAmortizaciones.pagosIguales:
				listaCreditos = creditosDAO.SimPagIguales(creditosBean);
				break;
			case Enum_Sim_PagAmortizaciones.pagosLibresTasaFija:
				listaCreditos = creditosDAO.SimPagLibres(creditosBean);
				break;
			case Enum_Sim_PagAmortizaciones.pagosTasaVar:
				listaCreditos = creditosDAO.SimPagCrecientes(creditosBean);
				break;
			case Enum_Sim_PagAmortizaciones.pagosLibresTasaVar:
				listaCreditos = creditosDAO.SimPagLibres(creditosBean);
				break;
			case Enum_Sim_PagAmortizaciones.tmpPagAmort:
			case Enum_Sim_PagAmortizaciones.amortGrupoOpeAlta:
				listaCreditos = creditosDAO.consultaSimuladorPagosTemporal(creditosBean,tipoLista);
				break;
			case Enum_Sim_PagAmortizaciones.amortGrupOpeFormalAgro:
				listaCreditos = creditosDAO.consAmortPagosTemporalGrupFormales(creditosBean,tipoLista);
			case Enum_Sim_PagAmortizaciones.salgosGlobales:
		        listaCreditos = creditosDAO.SimSaldosGlobales(creditosBean);
		        break;
			case Enum_Sim_PagAmortizaciones.sugeridoReestructura:
		        listaCreditos = creditosDAO.calendarioSugeridoReestructura(creditosBean, Enum_Sim_PagAmortizaciones.sugeridoReestructura);
		        break;

		}
		return listaCreditos;
	}

	public List listaGrid(int tipoLista,CreditosBean creditosBean){

		List listaCred = null;
		switch(tipoLista){
		case Enum_Lis_Creditos.CreComisiones:
			listaCred = creditosDAO.listaCreditosCobCom(creditosBean, tipoLista);
			break;

			}

		return listaCred;
	}

	//lista de parametros del grid
	public List listaCreditosGrid(CreditosBean liscreditosBean){

		List<String> creditosLis  = liscreditosBean.getLcreditos();
		List<String> cuentasLis  = liscreditosBean.getLcuentas();
		List<String> comFaltaPagoLis = liscreditosBean.getLcomFaltaPago();
		List<String> comAperturaLis  = liscreditosBean.getLcomAperturaCred();
		List<String> comSeguroLis = liscreditosBean.getLcomSeguroCuota();

		String comFaltaPago = "";
		String comSeguroCuota = "";
		String comApertura = "";

		ArrayList listaDetalle = new ArrayList();
		CreditosBean creditosBean = null;
		if(creditosLis != null){
			try{
			int tamanio = creditosLis.size();
			int aux = 0;
				for(int i = 0; i < tamanio; i++){
					comFaltaPago = comFaltaPagoLis.get(i);
					comFaltaPago=comFaltaPago.replace(",", "");

					comSeguroCuota = comSeguroLis.get(i);
					comSeguroCuota=comSeguroCuota.replace(",", "");

					comApertura = comAperturaLis.get(i);
					comApertura	= comApertura.replace(",", "");

					creditosBean = new CreditosBean();
					creditosBean.setCreditoID(creditosLis.get(i));
					creditosBean.setCuentaID(cuentasLis.get(i));
					creditosBean.setComFaltaPago(comFaltaPago);
					creditosBean.setComAperturaCred(comApertura);
					creditosBean.setComSeguroCuota(comSeguroCuota);

					listaDetalle.add(aux,creditosBean);
					aux++;

				}
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Créditos", e);
			}
	}
	return listaDetalle;
	}

	/**
	 * Reporte de Pagos por Referencia
	 * @param tipoLista : Número de Lista
	 * @param creditosBean : {@link PagosxReferenciaBean} bean con la información para filtrar.
	 * @param response
	 * @return
	 */
	public List<PagosxReferenciaBean> pagosXReferenciaRep(int tipoLista, CreditosBean creditosBean, HttpServletResponse response) {
		List listaCreditos = null;
		listaCreditos = creditosDAO.pagosXReferenciaRep(creditosBean, tipoLista);
		return listaCreditos;
	}


	/**
	 * Reporte de Pagos por Anticipados
	 * @param tipoLista : Número de Lista
	 * @param creditosBean : bean con la información para filtrar.
	 * @param response
	 * @return
	 */

	public List<PagosAnticipadosBean> pagosAnticipadosRep(int tipoLista, CreditosBean creditosBean, HttpServletResponse response) {
		List listaCreditos = null;
		listaCreditos = creditosDAO.pagosAnticipadosRep(creditosBean, tipoLista);
		return listaCreditos;
	}

	//case para listas de reportes de credito covid
	public List listaReporteBCCovid(int tipoLista, CreditosBean creditosBean, HttpServletResponse response){

		 List listaCreditos = null;

		switch(tipoLista){

			case Enum_Lista_ReporteCovid.reporteCSV:
				listaCreditos = creditosDAO.listaRepCreditosDiferidos(creditosBean, tipoLista);
				break;
			case Enum_Lista_ReporteCovid.reporteTxt:
				listaCreditos = creditosDAO.listaRepCreditosDiferidos(creditosBean, tipoLista);
				break;
		}

		return listaCreditos;
	}

	//Lista de reporte de operaciones basica de unidad
	public List<CreditosBean> listaReporteOperaciones(int tipoLista, CreditosBean creditosBean, HttpServletResponse response){
		List<CreditosBean> listaCreditos = null;
		switch(tipoLista){
			case Enum_Lista_Reporte_OBU.reporteExcel:
				listaCreditos = creditosDAO.listaReporteOperaciones(creditosBean, tipoLista);
				break;
		}
		return listaCreditos;
	}

	//-------------------------------------------------------------------------------------------------
	// -------------------- REPORTES -----------------------------------------------------------------
	//-------------------------------------------------------------------------------------------------

	// Reporte Pagare Tasa Fija PDF
			public ByteArrayOutputStream reportePagareTF(CreditosBean creditosBean,
					String nombreReporte) throws Exception{
				MonedasBean monedaBean = null;
				monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
															creditosBean.getMonedaID());

					String montoLetra=Utileria.cantidadEnLetras(
							creditosBean.getMontoCredito(),
							Integer.parseInt(monedaBean.getMonedaID()),
							monedaBean.getSimbolo(),
							monedaBean.getDescripcion());
					ParametrosReporte parametrosReporte = new ParametrosReporte();
					parametrosReporte.agregaParametro("Par_credito",creditosBean.getCreditoID());
					parametrosReporte.agregaParametro("Par_MontoEnLetras",montoLetra);
					parametrosReporte.agregaParametro("Par_usuario",creditosBean.getUsuario());
					parametrosReporte.agregaParametro("Par_RECA",creditosBean.getProducCreditoID());
					parametrosReporte.agregaParametro("Par_NomInstitucion", creditosBean.getNombreInstitucion());

					parametrosReporte.agregaParametro("Par_SucursalID", creditosBean.getSucursalID());
					parametrosReporte.agregaParametro("Par_DirecInstit",creditosBean.getDireccionInstit());
					parametrosReporte.agregaParametro("Par_RFCInt",creditosBean.getRFCInstit());
					parametrosReporte.agregaParametro("Par_TelInst",creditosBean.getTelefonoInst());
					parametrosReporte.agregaParametro("Par_FechaEmision", creditosBean.getFechaSistema());
					parametrosReporte.agregaParametro("Par_GerenteGeneral", creditosBean.getGerenteSucursal());
					parametrosReporte.agregaParametro("Par_NumDoc",NumDocumento);// es solo para reporte de pagareAgro individual tasa fija/(variable)
					return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

		//Reporte de pagare tasa Fija individual sale en creditos grupales
		public ByteArrayOutputStream reportePagareTFInd(CreditosBean creditosBean,
				String nombreReporte) throws Exception{
			MonedasBean monedaBean = null;
			monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
														creditosBean.getMonedaID());

				String montoLetra=Utileria.cantidadEnLetras(
						creditosBean.getMontoCredito(),
						Integer.parseInt(monedaBean.getMonedaID()),
						monedaBean.getSimbolo(),
						monedaBean.getDescripcion());

				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_credito",creditosBean.getCreditoID());
				parametrosReporte.agregaParametro("Par_MontoEnLetras",montoLetra);
				parametrosReporte.agregaParametro("Par_usuario",creditosBean.getUsuario());
				parametrosReporte.agregaParametro("Par_RECA",creditosBean.getProducCreditoID());
				parametrosReporte.agregaParametro("Par_NomInstitucion", creditosBean.getNombreInstitucion());

				parametrosReporte.agregaParametro("Par_SucursalID", creditosBean.getSucursal());
				parametrosReporte.agregaParametro("Par_DirecInstit",creditosBean.getDireccionInstit());
				parametrosReporte.agregaParametro("Par_RFCInt",creditosBean.getRFCInstit());
				parametrosReporte.agregaParametro("Par_TelInst",creditosBean.getTelefonoInst());
				parametrosReporte.agregaParametro("Par_FechaEmision", creditosBean.getFechaSistema());
				parametrosReporte.agregaParametro("Par_GerenteGeneral", creditosBean.getGerenteSucursal());
				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ByteArrayOutputStream reportePagareTFPDF(CreditosBean creditosBean,
			String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaMinistrado",creditosBean.getFechaMinistrado());
		parametrosReporte.agregaParametro("Par_MontoCredito",Utileria.convierteDoble(creditosBean.getMontoCredito()));
		parametrosReporte.agregaParametro("Par_NombreProducto",creditosBean.getNombreProducto());
		parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
		parametrosReporte.agregaParametro("Par_ClienteID",creditosBean.getClienteID());
		parametrosReporte.agregaParametro("Par_NomInstitucion", creditosBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_LeyendaTasaVar", creditosBean.getLeyendaTasaVariable());
		parametrosReporte.agregaParametro("Par_CalcInteresID", creditosBean.getCalcInteres());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	// Reporte Pagare Tasa Variable PDF
	public ByteArrayOutputStream reportePagareTVPDF(CreditosBean creditosBean,
			String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_creditoID",creditosBean.getCreditoID());
			parametrosReporte.agregaParametro("Par_NomInstitucion", creditosBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_LeyendaTasaVar", creditosBean.getLeyendaTasaVariable());
			parametrosReporte.agregaParametro("Par_CalcInteresID", creditosBean.getCalcInteres());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

	// Reporte Pagare Tasa Variable prpt

	public String reportePagareTasaVar(CreditosBean creditosBean, String nombreReporte) throws Exception {
		String Credito=creditosBean.getCreditoID();
			ParametrosReporte parametrosReporte =  new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_creditoID",Credito);

			return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	// Reporte para la caratula del contrato Grupal
	public ByteArrayOutputStream reporteCaratulaContrato(CreditosBean creditosBean,

			String nombreReporte) throws Exception{

		MonedasBean monedaBean = null;
		ContratoCredEncBean contratoCredEncBean = null;

		monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,creditosBean.getMonedaID());
		contratoCredEncBean = creditosDAO.consultaEncContratoCred(new ContratoCredEncBean(), Enum_Con_ContratosCred.consultaEncabezado);

		String montoLetra=Utileria.cantidadEnLetras(
				creditosBean.getMontoCredito(),
				Integer.parseInt(monedaBean.getMonedaID()),
				monedaBean.getSimbolo(),
				monedaBean.getDescripcion());

			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_GrupoID",creditosBean.getGrupoID());
			parametrosReporte.agregaParametro("Par_MontoCreditoID",Utileria.convierteDoble(creditosBean.getMontoCredito()));
			parametrosReporte.agregaParametro("Par_MontoEnLetra",montoLetra);
			parametrosReporte.agregaParametro("Par_DireccionInstitucion", contratoCredEncBean.getDireccionInstitucion());
			parametrosReporte.agregaParametro("Par_RepresentanteLegal",contratoCredEncBean.getRepresentanteLegal() );
			parametrosReporte.agregaParametro("Par_DiaSistema", contratoCredEncBean.getDiaSistema());
			parametrosReporte.agregaParametro("Par_AnioSistema", contratoCredEncBean.getAnioSistema());
			parametrosReporte.agregaParametro("Par_MesSistema", contratoCredEncBean.getMesSistema());
			parametrosReporte.agregaParametro("Par_NomInstitucion",creditosBean.getNombreInstitucion().toUpperCase());
			parametrosReporte.agregaParametro("Par_NomCortoInstitucion",contratoCredEncBean.getNombreCortoInstit());

			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

	// Reporte para la caratula del contrato individual
		public ByteArrayOutputStream reporteCaratulaContratoInd(CreditosBean creditosBean, String nombreReporte) throws Exception{

			MonedasBean monedaBean = null;
			ContratoCredEncBean contratoCredIndEncBean = null;

			contratoCredIndEncBean = creditosDAO.consultaEncContratoCredInd(new ContratoCredEncBean(), Enum_Con_ContratosCred.consultaEncabezado);

				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
				parametrosReporte.agregaParametro("Par_SolicitudCreditoID", creditosBean.getSolicitudCreditoID());
				parametrosReporte.agregaParametro("Par_DireccionInstitucion", contratoCredIndEncBean.getDireccionInstitucion());
				parametrosReporte.agregaParametro("Par_RepresentanteLegal",contratoCredIndEncBean.getRepresentanteLegal() );
				parametrosReporte.agregaParametro("Par_DiaSistema", contratoCredIndEncBean.getDiaSistema());
				parametrosReporte.agregaParametro("Par_AnioSistema", contratoCredIndEncBean.getAnioSistema());
				parametrosReporte.agregaParametro("Par_MesSistema", contratoCredIndEncBean.getMesSistema());
				parametrosReporte.agregaParametro("Par_NomInstitucion",creditosBean.getNombreInstitucion().toUpperCase());
				parametrosReporte.agregaParametro("Par_NomCortoInstitucion",contratoCredIndEncBean.getNombreCortoInstit());
				parametrosReporte.agregaParametro("Par_SucursalID",creditosBean.getSucursal());
				parametrosReporte.agregaParametro("Par_UsuarioID",creditosBean.getUsuario());

				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}

		// Reporte para la caratula del contrato para el cliente Santa Fe
		public ByteArrayOutputStream reporteCaratulaContratoSantaFe(CreditosBean creditosBean, String nombreReporte, String referenciaPay) throws Exception{
				if(creditosBean.getGrupoID() == null){
					creditosBean.setGrupoID("0");
				}
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
				parametrosReporte.agregaParametro("Par_GrupoID",creditosBean.getGrupoID());
				parametrosReporte.agregaParametro("Par_NomInstitucion",creditosBean.getNombreInstitucion().toUpperCase());
				
				//Generamos el codigo de barras
				String strBase64 = null;
				//Solo se genera el codigo de barra, cuando la referencia sea diferente de vacio
				if(!referenciaPay.equals("")) {
					strBase64 = GenerateBarCode.generaCodigoBarraStr64(referenciaPay, 355, 150);
				}
				parametrosReporte.agregaParametro("Par_CodigoBarras", strBase64);

				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}

	// Reporte para la caratula del contrato Grupal
		public ByteArrayOutputStream reporteObligacionesCG(CreditosBean creditosBean,	String nombreReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_NombreInstitucion",creditosBean.getNombreInstitucion().toUpperCase());
				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}

	// Reporte para la clausulas del contrato Grupal
	public ByteArrayOutputStream reporteClausulasContrato(CreditosBean creditosBean,
			String nombreReporte) throws Exception{
		MonedasBean monedaBean = null;
		ContratoCredEncBean contratoCredEncBean = null;

		monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,	creditosBean.getMonedaID());
		contratoCredEncBean = creditosDAO.consultaEncContratoCred(new ContratoCredEncBean(), Enum_Con_ContratosCred.consultaEncabezado);
		String montoLetra=Utileria.cantidadEnLetras(
				creditosBean.getMontoCredito(),
				Integer.parseInt(monedaBean.getMonedaID()),
				monedaBean.getSimbolo(),
				monedaBean.getDescripcion());

		ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_GrupoID",creditosBean.getGrupoID());
			parametrosReporte.agregaParametro("Par_MontoCredito",Utileria.convierteDoble(creditosBean.getMontoCredito()));
			parametrosReporte.agregaParametro("Par_MontoEnLetra",montoLetra);
			parametrosReporte.agregaParametro("Par_MontoFormatoMoneda", Utileria.convierteFormatoMoneda(creditosBean.getMontoCredito()));
			parametrosReporte.agregaParametro("Par_NomInstitucion",creditosBean.getNombreInstitucion().toUpperCase());
			parametrosReporte.agregaParametro("Par_NomCortoInstitucion",contratoCredEncBean.getNombreCortoInstit());
			parametrosReporte.agregaParametro("Par_SexoRepteLegal", contratoCredEncBean.getGeneroRepresentante());
			parametrosReporte.agregaParametro("Par_RepresentanteLegal",contratoCredEncBean.getRepresentanteLegal() );
			parametrosReporte.agregaParametro("Par_RFCOficial",contratoCredEncBean.getRFCOficial() );
			parametrosReporte.agregaParametro("Par_TelInstitucion",contratoCredEncBean.getTelefonoInstitucion() );
			parametrosReporte.agregaParametro("Par_DirccionInstitucion", contratoCredEncBean.getDireccionInstitucion());
			parametrosReporte.agregaParametro("Par_NombreEstado",contratoCredEncBean.getEstadoinstitucion() );
			parametrosReporte.agregaParametro("Par_DiaSistema", contratoCredEncBean.getDiaSistema());
			parametrosReporte.agregaParametro("Par_AnioSistema", contratoCredEncBean.getAnioSistema());
			parametrosReporte.agregaParametro("Par_MesSistema", contratoCredEncBean.getMesSistema());
			parametrosReporte.agregaParametro("Par_MontoCreditoID",Utileria.convierteDoble(creditosBean.getMontoCredito()));
			parametrosReporte.agregaParametro("Par_FirmaRepresentante" , contratoCredEncBean.getFirmaRepresentante());
			parametrosReporte.agregaParametro("Par_RECA",creditosBean.getProducCreditoID());

			parametrosReporte.agregaParametro("Par_DirecInstitucion",creditosBean.getDireccionInstit());
			parametrosReporte.agregaParametro("Par_RFCInstitucion",creditosBean.getRFCInstit());
			parametrosReporte.agregaParametro("Par_TelInstitucion",creditosBean.getTelefonoInst());
			parametrosReporte.agregaParametro("Par_FechaEmision", creditosBean.getFechaSistema());

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}


	// Reporte pagare Tasa Fija prpt
	public String reportePagareTasaFija(CreditosBean creditosBean, String nombreReporte) throws Exception{
		MonedasBean monedaBean = null;
		monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
													creditosBean.getMonedaID());

			String montoLetra=Utileria.cantidadEnLetras(
					creditosBean.getMontoCredito(),
					Integer.parseInt(monedaBean.getMonedaID()),
					monedaBean.getSimbolo(),
					monedaBean.getDescripcion());

			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_credito",creditosBean.getCreditoID());
			parametrosReporte.agregaParametro("Par_MontoEnLetra",montoLetra);

			return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	// Reporte pagare Tasa Fija Grupal PDF
		public ByteArrayOutputStream reportePagareTasaFijaGrupal(CreditosBean creditosBean,
				String nombreReporte) throws Exception{

			MonedasBean monedaBean = null;
			monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,creditosBean.getMonedaID());

			String montoLetra=Utileria.cantidadEnLetras(
					creditosBean.getMontoCredito(),
					Utileria.convierteEntero(monedaBean.getMonedaID()),
					monedaBean.getSimbolo(),
					monedaBean.getDescripcion());

				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_GrupoID",creditosBean.getCreditoID());
				parametrosReporte.agregaParametro("Par_MontoEnLetra",montoLetra);
				parametrosReporte.agregaParametro("Par_RECA",creditosBean.getProducCreditoID());
				parametrosReporte.agregaParametro("Par_usuario",creditosBean.getUsuario());
				parametrosReporte.agregaParametro("Par_NomInstitucion", creditosBean.getNombreInstitucion());
				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}

		// Reporte Pagare
		public ByteArrayOutputStream reportePagare(CreditosBean creditosBean, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
			parametrosReporte.agregaParametro("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

	// Reporte  Movimientos Creditos

	public String reporteMovsCredito(CreditosBean creditosBean, String nombreReporte) throws Exception{

			ParametrosReporte parametrosReporte = new ParametrosReporte();

			MonedasBean monedaBean = null;
			monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
														creditosBean.getMonedaID());
			creditosBean.setMonedaID(monedaBean.getDescriCorta());

			Date FechaD = new Date();
			java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("H:mm");
			String hora = sdf.format(FechaD);
			creditosBean.setFechTerminacion(hora);

			parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
			parametrosReporte.agregaParametro("Par_FechaInicio",creditosBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin",creditosBean.getFechaVencimien());
			parametrosReporte.agregaParametro("Par_NomInstitucion",creditosBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_NomUsuario",creditosBean.getNombreUsuario());
			parametrosReporte.agregaParametro("Par_HoraReporte",creditosBean.getFechTerminacion()); // hora de reporte
			parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
			parametrosReporte.agregaParametro("Par_NombreCliente",creditosBean.getNombreCliente());
			parametrosReporte.agregaParametro("Par_MontoOtorgado",Utileria.convierteDoble(creditosBean.getMontoCredito()));
			parametrosReporte.agregaParametro("Par_ProductoID",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
			parametrosReporte.agregaParametro("Par_ProductoNombre",creditosBean.getNombreProducto());
			parametrosReporte.agregaParametro("Par_FechaDesembolso",creditosBean.getFechaMinistrado());
			parametrosReporte.agregaParametro("Par_SaldoTotal",Utileria.convierteDoble(creditosBean.getAdeudoTotal()));
			parametrosReporte.agregaParametro("Par_EstatusCred",creditosBean.getEstatus());
			parametrosReporte.agregaParametro("Par_Moneda",creditosBean.getMonedaID());
			parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());
			return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//Reporte Movimientos Creditos PDF
	public ByteArrayOutputStream reporMovsCreditoPDF(CreditosBean creditosBean,
			String nombreReporte) throws Exception{

			ParametrosReporte parametrosReporte = new ParametrosReporte();
			MonedasBean monedaBean = null;
			monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
														creditosBean.getMonedaID());
			creditosBean.setMonedaID(monedaBean.getDescriCorta());

			Date FechaD = new Date();
			java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("H:mm");
			String hora = sdf.format(FechaD);
			creditosBean.setFechTerminacion(hora);

			parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
			parametrosReporte.agregaParametro("Par_FechaInicio",creditosBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin",creditosBean.getFechaVencimien());
			parametrosReporte.agregaParametro("Par_NomInstitucion",creditosBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_NomUsuario",creditosBean.getNombreUsuario());
			parametrosReporte.agregaParametro("Par_HoraReporte",creditosBean.getFechTerminacion()); // hora de reporte
			parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
			parametrosReporte.agregaParametro("Par_NombreCliente",creditosBean.getNombreCliente());
			parametrosReporte.agregaParametro("Par_MontoOtorgado",Utileria.convierteDoble(creditosBean.getMontoCredito()));
			parametrosReporte.agregaParametro("Par_ProductoID",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
			parametrosReporte.agregaParametro("Par_ProductoNombre",creditosBean.getNombreProducto());
			parametrosReporte.agregaParametro("Par_FechaDesembolso",creditosBean.getFechaMinistrado());
			parametrosReporte.agregaParametro("Par_SaldoTotal",Utileria.convierteDoble(creditosBean.getAdeudoTotal()));
			parametrosReporte.agregaParametro("Par_EstatusCred",creditosBean.getEstatus());
			parametrosReporte.agregaParametro("Par_Moneda",creditosBean.getMonedaID());
			parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

	//Reporte Movimientos de pagos de Creditos Sumarizado PDF
		public ByteArrayOutputStream reporMovsCreditoSumPDF(CreditosBean creditosBean,
				String nombreReporte) throws Exception{

				ParametrosReporte parametrosReporte = new ParametrosReporte();
				MonedasBean monedaBean = null;
				monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
															creditosBean.getMonedaID());
				creditosBean.setMonedaID(monedaBean.getDescriCorta());

				Date FechaD = new Date();
				java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("H:mm");
				String hora = sdf.format(FechaD);
				creditosBean.setFechTerminacion(hora);

				parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
				parametrosReporte.agregaParametro("Par_FechaInicio",creditosBean.getFechaInicio());
				parametrosReporte.agregaParametro("Par_FechaFin",creditosBean.getFechaVencimien());
				parametrosReporte.agregaParametro("Par_NomInstitucion",creditosBean.getNombreInstitucion());
				parametrosReporte.agregaParametro("Par_NomUsuario",creditosBean.getNombreUsuario());
				parametrosReporte.agregaParametro("Par_HoraReporte",creditosBean.getFechTerminacion()); // hora de reporte
				parametrosReporte.agregaParametro("Par_ClienteID",creditosBean.getClienteID());
				parametrosReporte.agregaParametro("Par_NombreCliente",creditosBean.getNombreCliente());
				parametrosReporte.agregaParametro("Par_MontoOtorgado",Utileria.convierteDoble(creditosBean.getMontoCredito()));
				parametrosReporte.agregaParametro("Par_ProductoID",creditosBean.getProducCreditoID());
				parametrosReporte.agregaParametro("Par_ProductoNombre",creditosBean.getNombreProducto());
				parametrosReporte.agregaParametro("Par_FechaDesembolso",creditosBean.getFechaMinistrado());
				parametrosReporte.agregaParametro("Par_SaldoTotal",Utileria.convierteDoble(creditosBean.getAdeudoTotal()));
				parametrosReporte.agregaParametro("Par_EstatusCred",creditosBean.getEstatus());
				parametrosReporte.agregaParametro("Par_Moneda",creditosBean.getMonedaID());
				parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());
				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}



	// Reporte  de Ministraciones de Credito prpt

	public String reporteMinistracionesCredito(CreditosBean creditosBean, String nomReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_FechaInicio",creditosBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin",creditosBean.getFechaVencimien());
			parametrosReporte.agregaParametro("Par_Sucursal",creditosBean.getSucursal());
			parametrosReporte.agregaParametro("Par_MonedaID",creditosBean.getMonedaID());
			parametrosReporte.agregaParametro("Par_ProductoCre",creditosBean.getProducCreditoID());
			parametrosReporte.agregaParametro("Par_Usuario",creditosBean.getUsuario());

			return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//Reporte Acta Comite
	public ByteArrayOutputStream reporteActaComite(CreditosBean creditosBean, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();

			parametrosReporte.agregaParametro("Par_GrupoID",creditosBean.getGrupoID());
			parametrosReporte.agregaParametro("Par_SolicitudID",creditosBean.getSolicitudCreditoID());
			parametrosReporte.agregaParametro("Par_Usuario",creditosBean.getUsuario());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	// Reporte  de Ministraciones de Credito en pdf
	public ByteArrayOutputStream reporteMinistracionesCreditoPDF(CreditosBean creditosBean, String nomReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_FechaInicio",creditosBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin",creditosBean.getFechaVencimien());
			parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(creditosBean.getSucursal()));
			parametrosReporte.agregaParametro("Par_MonedaID",Utileria.convierteEntero(creditosBean.getMonedaID()));
			parametrosReporte.agregaParametro("Par_ProductoCre",Utileria.convierteEntero(creditosBean.getProducCreditoID()));

			parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(creditosBean.getPromotorID()));
			parametrosReporte.agregaParametro("Par_Genero",creditosBean.getSexo());
			parametrosReporte.agregaParametro("Par_Estado",Utileria.convierteEntero(creditosBean.getEstadoID()));
			parametrosReporte.agregaParametro("Par_Municipio",Utileria.convierteEntero(creditosBean.getMunicipioID()));
			parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());

			parametrosReporte.agregaParametro("Par_NomSucursal",(!creditosBean.getNombreSucursal().isEmpty())? creditosBean.getNombreSucursal():"TODOS");
			parametrosReporte.agregaParametro("Par_NomMoneda",(!creditosBean.getNombreMoneda().isEmpty())? creditosBean.getNombreMoneda() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomProductoCre",(!creditosBean.getNombreProducto().isEmpty())? creditosBean.getNombreProducto() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomPromotor",(!creditosBean.getNombrePromotor().isEmpty())? creditosBean.getNombrePromotor() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomGenero",(!creditosBean.getNombreGenero().isEmpty())? creditosBean.getNombreGenero() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomEstado",(!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomMunicipio",(!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi() : "TODOS");

			parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
			parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");
			parametrosReporte.agregaParametro("Par_NivelDetalle",(!creditosBean.getNivelDetalle().isEmpty())?creditosBean.getNivelDetalle(): "1");
			parametrosReporte.agregaParametro("Aud_Usuario",String.valueOf(parametrosAuditoriaBean.getUsuario()));
			parametrosReporte.agregaParametro("Par_EmpresaNomina",creditosBean.getInstitucionNominaID());
			parametrosReporte.agregaParametro("Par_Convenio",creditosBean.getConvenioNominaID());
			parametrosReporte.agregaParametro("Par_NombreEmpresa",creditosBean.getNombreInstit());
			parametrosReporte.agregaParametro("Par_NombreConvenio",creditosBean.getDesConvenio());
			parametrosReporte.agregaParametro("Par_EsProducNomina",creditosBean.getEsNomina());
			parametrosReporte.agregaParametro("Par_ManejaConvenio",creditosBean.getManejaConvenio());
			parametrosReporte.agregaParametro("Par_NumLista", creditosBean.getNumLista());



			return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//Reporte  de Saldos de Capital de Credito
	public String reporteSaldosCapitalCredito(CreditosBean creditosBean, String nomReporte) throws Exception{

			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_Fecha",creditosBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_Sucursal",creditosBean.getSucursal());
			parametrosReporte.agregaParametro("Par_MonedaID",creditosBean.getMonedaID());
			parametrosReporte.agregaParametro("Par_ProductoCre",creditosBean.getProducCreditoID());
			parametrosReporte.agregaParametro("Par_Usuario",creditosBean.getUsuario());

			parametrosReporte.agregaParametro("Par_AtrasoInicial",(!creditosBean.getAtrasoInicial().isEmpty())?creditosBean.getAtrasoInicial(): "0");
			parametrosReporte.agregaParametro("Par_AtrasoFinal",(!creditosBean.getAtrasoFinal().isEmpty())?creditosBean.getAtrasoFinal(): "99999");


			return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	// Reporte  de saldos de capital de Credito en PDF
		public ByteArrayOutputStream reporteSaldosCapitalCreditoPDF(CreditosBean creditosBean,
				String nombreReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_Fecha",creditosBean.getFechaInicio());
				parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(creditosBean.getSucursal()));
				parametrosReporte.agregaParametro("Par_MonedaID",Utileria.convierteEntero(creditosBean.getMonedaID()));
				parametrosReporte.agregaParametro("Par_ProductoCre",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
				parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(creditosBean.getPromotorID()));
				parametrosReporte.agregaParametro("Par_Genero",creditosBean.getSexo());
				parametrosReporte.agregaParametro("Par_Estado",Utileria.convierteEntero(creditosBean.getEstadoID()));
				parametrosReporte.agregaParametro("Par_Municipio",Utileria.convierteEntero(creditosBean.getMunicipioID()));
				parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());

				parametrosReporte.agregaParametro("Par_NomSucursal",(!creditosBean.getNombreSucursal().isEmpty())? creditosBean.getNombreSucursal():"TODOS");
				parametrosReporte.agregaParametro("Par_NomMoneda",(!creditosBean.getNombreMoneda().isEmpty())? creditosBean.getNombreMoneda() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomProductoCre",(!creditosBean.getNombreProducto().isEmpty())? creditosBean.getNombreProducto() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomPromotor",(!creditosBean.getNombrePromotor().isEmpty())? creditosBean.getNombrePromotor() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomGenero",(!creditosBean.getNombreGenero().isEmpty())? creditosBean.getNombreGenero() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomEstado",(!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomMunicipio",(!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi() : "TODOS");

				parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
				parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");
				parametrosReporte.agregaParametro("Par_NivelDetalle",(!creditosBean.getNivelDetalle().isEmpty())?creditosBean.getNivelDetalle(): "1");
				parametrosReporte.agregaParametro("Par_Criterio",(!creditosBean.getCriterio().isEmpty())?creditosBean.getCriterio(): "O");


				parametrosReporte.agregaParametro("Par_AtrasoInicial",(!creditosBean.getAtrasoInicial().isEmpty())?creditosBean.getAtrasoInicial(): "0");
				parametrosReporte.agregaParametro("Par_AtrasoFinal",(!creditosBean.getAtrasoFinal().isEmpty())?creditosBean.getAtrasoFinal(): "99999");
				parametrosReporte.agregaParametro("Aud_Usuario",String.valueOf(parametrosAuditoriaBean.getUsuario()));
				parametrosReporte.agregaParametro("Par_InstitucionID",(!creditosBean.getInstitucionNominaID().isEmpty())?creditosBean.getInstitucionNominaID(): "99999");
				parametrosReporte.agregaParametro("Par_ConvenioNominaID",(!creditosBean.getConvenioNominaID().isEmpty())?creditosBean.getConvenioNominaID(): "99999");

				parametrosReporte.agregaParametro("Par_NombreEmpresa",creditosBean.getNombreInstit());
				parametrosReporte.agregaParametro("Par_NombreConvenio",creditosBean.getDesConvenio());
				parametrosReporte.agregaParametro("Par_EsproducNomina",creditosBean.getEsproducNomina());
				parametrosReporte.agregaParametro("Par_ManejaConvenio",creditosBean.getManejaConvenio());

				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}

// Reporte  de estimaciones de credito preventivo
		public ByteArrayOutputStream creaRepEstimacionesCredPrevPDF(CreditosBean creditosBean,
				String nombreReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_Fecha",creditosBean.getFechaInicio());
				parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));

				parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(creditosBean.getSucursal()));
				parametrosReporte.agregaParametro("Par_MonedaID",Utileria.convierteEntero(creditosBean.getMonedaID()));
				parametrosReporte.agregaParametro("Par_ProdCredID",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
				parametrosReporte.agregaParametro("Par_PromotorID",Utileria.convierteEntero(creditosBean.getPromotorID()));

				parametrosReporte.agregaParametro("Par_Sexo",creditosBean.getSexo());
				parametrosReporte.agregaParametro("Par_EstadoID",Utileria.convierteEntero(creditosBean.getEstadoID()));
				parametrosReporte.agregaParametro("Par_MunicipioID",Utileria.convierteEntero(creditosBean.getMunicipioID()));
				parametrosReporte.agregaParametro("Par_GrupoID",Utileria.convierteEntero(creditosBean.getGrupoID()));
				parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());

				parametrosReporte.agregaParametro("Par_NomCliente",(!creditosBean.getNombreCliente().isEmpty())? creditosBean.getNombreCliente():"TODOS");
				parametrosReporte.agregaParametro("Par_NomGrupo",(!creditosBean.getNombreGrupo().isEmpty())? creditosBean.getNombreGrupo():"TODOS");
				parametrosReporte.agregaParametro("Par_NomSucursal",(!creditosBean.getNombreSucursal().isEmpty())? creditosBean.getNombreSucursal():"TODOS");
				parametrosReporte.agregaParametro("Par_NomMoneda",(!creditosBean.getNombreMoneda().isEmpty())? creditosBean.getNombreMoneda() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomProductoCre",(!creditosBean.getNombreProducto().isEmpty())? creditosBean.getNombreProducto() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomPromotor",(!creditosBean.getNombrePromotor().isEmpty())? creditosBean.getNombrePromotor() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomGenero",(!creditosBean.getNombreGenero().isEmpty())? creditosBean.getNombreGenero() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomEstado",(!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomMunicipio",(!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi() : "TODOS");

				parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
				parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");

				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}

		public ByteArrayOutputStream creaRepCalificaPorcentResPDF(CreditosBean creditosBean,
				String nombreReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_Fecha",creditosBean.getFechaInicio());
				parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));

				parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(creditosBean.getSucursal()));
				parametrosReporte.agregaParametro("Par_MonedaID",Utileria.convierteEntero(creditosBean.getMonedaID()));
				parametrosReporte.agregaParametro("Par_ProdCredID",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
				parametrosReporte.agregaParametro("Par_PromotorID",Utileria.convierteEntero(creditosBean.getPromotorID()));

				parametrosReporte.agregaParametro("Par_Sexo",creditosBean.getSexo());
				parametrosReporte.agregaParametro("Par_EstadoID",Utileria.convierteEntero(creditosBean.getEstadoID()));
				parametrosReporte.agregaParametro("Par_MunicipioID",Utileria.convierteEntero(creditosBean.getMunicipioID()));
				parametrosReporte.agregaParametro("Par_GrupoID",Utileria.convierteEntero(creditosBean.getGrupoID()));
				parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());

				parametrosReporte.agregaParametro("Par_NomCliente",(!creditosBean.getNombreCliente().isEmpty())? creditosBean.getNombreCliente():"TODOS");
				parametrosReporte.agregaParametro("Par_NomGrupo",(!creditosBean.getNombreGrupo().isEmpty())? creditosBean.getNombreGrupo():"TODOS");
				parametrosReporte.agregaParametro("Par_NomSucursal",(!creditosBean.getNombreSucursal().isEmpty())? creditosBean.getNombreSucursal():"TODOS");
				parametrosReporte.agregaParametro("Par_NomMoneda",(!creditosBean.getNombreMoneda().isEmpty())? creditosBean.getNombreMoneda() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomProductoCre",(!creditosBean.getNombreProducto().isEmpty())? creditosBean.getNombreProducto() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomPromotor",(!creditosBean.getNombrePromotor().isEmpty())? creditosBean.getNombrePromotor() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomGenero",(!creditosBean.getNombreGenero().isEmpty())? creditosBean.getNombreGenero() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomEstado",(!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomMunicipio",(!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi() : "TODOS");

				parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
				parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");

				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}
		// Reporte  de Pagos Realizados
				public ByteArrayOutputStream creaRepPagosRealizadosPDF(CreditosBean creditosBean,
						String nombreReporte) throws Exception{
						ParametrosReporte parametrosReporte = new ParametrosReporte();
						parametrosReporte.agregaParametro("Par_FechaInicio",creditosBean.getFechaInicio());
						parametrosReporte.agregaParametro("Par_FechaFin",creditosBean.getFechaVencimien());
						parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(creditosBean.getSucursal()));
						parametrosReporte.agregaParametro("Par_MonedaID",Utileria.convierteEntero(creditosBean.getMonedaID()));
						parametrosReporte.agregaParametro("Par_ProductoCre",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
						parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(creditosBean.getPromotorID()));
						parametrosReporte.agregaParametro("Par_Genero",creditosBean.getSexo());
						parametrosReporte.agregaParametro("Par_Estado",Utileria.convierteEntero(creditosBean.getEstadoID()));
						parametrosReporte.agregaParametro("Par_Municipio",Utileria.convierteEntero(creditosBean.getMunicipioID()));
						parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());

						parametrosReporte.agregaParametro("Par_NomSucursal",(!creditosBean.getNombreSucursal().isEmpty())? creditosBean.getNombreSucursal():"TODAS");
						parametrosReporte.agregaParametro("Par_NomMoneda",(!creditosBean.getNombreMoneda().isEmpty())? creditosBean.getNombreMoneda() : "TODAS");
						parametrosReporte.agregaParametro("Par_NomProductoCre",(!creditosBean.getNombreProducto().isEmpty())? creditosBean.getNombreProducto() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomPromotor",(!creditosBean.getNombrePromotor().isEmpty())? creditosBean.getNombrePromotor() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomGenero",(!creditosBean.getNombreGenero().isEmpty())? creditosBean.getNombreGenero() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomEstado",(!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomMunicipio",(!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi() : "TODOS");

						parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
						parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");
						parametrosReporte.agregaParametro("Par_NivelDetalle",(!creditosBean.getNivelDetalle().isEmpty())?creditosBean.getNivelDetalle(): "1");

						parametrosReporte.agregaParametro("Par_ModalidadPagoID",(!creditosBean.getModalidadPagoID().isEmpty())? creditosBean.getModalidadPagoID():"");
						parametrosReporte.agregaParametro("Aud_Usuario",String.valueOf(parametrosAuditoriaBean.getUsuario()));
						parametrosReporte.agregaParametro("Par_InstitucionID",creditosBean.getInstitucionNominaID());
						parametrosReporte.agregaParametro("Par_ConvenioNominaID",creditosBean.getConvenioNominaID());
						parametrosReporte.agregaParametro("Par_NombreEmpresa",creditosBean.getNombreInstit());
						parametrosReporte.agregaParametro("Par_NombreConvenio",creditosBean.getDesConvenio());
						parametrosReporte.agregaParametro("Par_EsproducNomina",creditosBean.getEsproducNomina());
						parametrosReporte.agregaParametro("Par_ManejaConvenio",creditosBean.getManejaConvenio());


						return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
					}

		// Reporte  de Vencimientos
	public ByteArrayOutputStream creaRepVencimientosPDF(CreditosBean creditosBean,
						String nombreReporte) throws Exception{
						ParametrosReporte parametrosReporte = new ParametrosReporte();

						parametrosReporte.agregaParametro("Par_FechaInicio",creditosBean.getFechaInicio());
						parametrosReporte.agregaParametro("Par_FechaFin",creditosBean.getFechaVencimien());
						parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(creditosBean.getSucursal()));
						parametrosReporte.agregaParametro("Par_MonedaID",Utileria.convierteEntero(creditosBean.getMonedaID()));
						parametrosReporte.agregaParametro("Par_ProductoCre",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
						parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(creditosBean.getPromotorID()));
						parametrosReporte.agregaParametro("Par_Genero",creditosBean.getSexo());
						parametrosReporte.agregaParametro("Par_Estado",Utileria.convierteEntero(creditosBean.getEstadoID()));
						parametrosReporte.agregaParametro("Par_Municipio",Utileria.convierteEntero(creditosBean.getMunicipioID()));
						parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());

						parametrosReporte.agregaParametro("Par_NomSucursal",(!creditosBean.getNombreSucursal().isEmpty())? creditosBean.getNombreSucursal():"TODOS");
						parametrosReporte.agregaParametro("Par_NomMoneda",(!creditosBean.getNombreMoneda().isEmpty())? creditosBean.getNombreMoneda() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomProductoCre",(!creditosBean.getNombreProducto().isEmpty())? creditosBean.getNombreProducto() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomPromotor",(!creditosBean.getNombrePromotor().isEmpty())? creditosBean.getNombrePromotor() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomGenero",(!creditosBean.getNombreGenero().isEmpty())? creditosBean.getNombreGenero() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomEstado",(!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomMunicipio",(!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi() : "TODOS");

						parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
						parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");
						parametrosReporte.agregaParametro("Par_NivelDetalle",(!creditosBean.getNivelDetalle().isEmpty())?creditosBean.getNivelDetalle(): "1");

						parametrosReporte.agregaParametro("Par_InstNominaID",creditosBean.getInstitucionNominaID());
						parametrosReporte.agregaParametro("Par_ConvenioID",creditosBean.getConvenioNominaID());


						parametrosReporte.agregaParametro("Par_AtrasoInicial",(!creditosBean.getAtrasoInicial().isEmpty())?creditosBean.getAtrasoInicial(): "0");
						parametrosReporte.agregaParametro("Par_AtrasoFinal",(!creditosBean.getAtrasoFinal().isEmpty())?creditosBean.getAtrasoFinal(): "99999");
						parametrosReporte.agregaParametro("Aud_Usuario",String.valueOf(parametrosAuditoriaBean.getUsuario()));

						parametrosReporte.agregaParametro("Par_NombreEmpresa",(!creditosBean.getNombreInstit().isEmpty())?creditosBean.getNombreInstit(): "TODOS");
						parametrosReporte.agregaParametro("Par_NombreConvenio",(!creditosBean.getDesConvenio().isEmpty())?creditosBean.getDesConvenio(): "TODOS");
						parametrosReporte.agregaParametro("Par_EsProducNomina",creditosBean.getEsNomina());

						parametrosReporte.agregaParametro("Par_ManejaConvenio",creditosBean.getManejaConvenio());



						return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
					}

	// Reporte  de Vencimientos pasivos
	public ByteArrayOutputStream creaRepVencimientosPasivPDF(CreditosBean creditosBean,
						String nombreReporte) throws Exception{
						ParametrosReporte parametrosReporte = new ParametrosReporte();
						parametrosReporte.agregaParametro("Par_FechaInicio",creditosBean.getFechaInicio());
						parametrosReporte.agregaParametro("Par_FechaFin",creditosBean.getFechaVencimien());
						parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(creditosBean.getSucursal()));
						parametrosReporte.agregaParametro("Par_MonedaID",Utileria.convierteEntero(creditosBean.getMonedaID()));
						parametrosReporte.agregaParametro("Par_ProductoCre",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
						parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(creditosBean.getPromotorID()));
						parametrosReporte.agregaParametro("Par_Genero",creditosBean.getSexo());
						parametrosReporte.agregaParametro("Par_Estado",Utileria.convierteEntero(creditosBean.getEstadoID()));
						parametrosReporte.agregaParametro("Par_Municipio",Utileria.convierteEntero(creditosBean.getMunicipioID()));
						parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());

						parametrosReporte.agregaParametro("Par_NomSucursal",(!creditosBean.getNombreSucursal().isEmpty())? creditosBean.getNombreSucursal():"TODOS");
						parametrosReporte.agregaParametro("Par_NomMoneda",(!creditosBean.getNombreMoneda().isEmpty())? creditosBean.getNombreMoneda() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomProductoCre",(!creditosBean.getNombreProducto().isEmpty())? creditosBean.getNombreProducto() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomPromotor",(!creditosBean.getNombrePromotor().isEmpty())? creditosBean.getNombrePromotor() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomGenero",(!creditosBean.getNombreGenero().isEmpty())? creditosBean.getNombreGenero() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomEstado",(!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado() : "TODOS");
						parametrosReporte.agregaParametro("Par_NomMunicipio",(!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi() : "TODOS");

						parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
						parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");
						parametrosReporte.agregaParametro("Par_NivelDetalle",(!creditosBean.getNivelDetalle().isEmpty())?creditosBean.getNivelDetalle(): "1");

						return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
					}

	public ByteArrayOutputStream creaRepAntigSaldosPDF(CreditosBean creditosBean,
			String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_Fecha",creditosBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(creditosBean.getSucursal()));
			parametrosReporte.agregaParametro("Par_MonedaID",Utileria.convierteEntero(creditosBean.getMonedaID()));
			parametrosReporte.agregaParametro("Par_ProductoCre",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
			parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(creditosBean.getPromotorID()));
			parametrosReporte.agregaParametro("Par_Genero",creditosBean.getSexo());
			parametrosReporte.agregaParametro("Par_Estado",Utileria.convierteEntero(creditosBean.getEstadoID()));
			parametrosReporte.agregaParametro("Par_Municipio",Utileria.convierteEntero(creditosBean.getMunicipioID()));
			parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());

			parametrosReporte.agregaParametro("Par_NomSucursal",(!creditosBean.getNombreSucursal().isEmpty())? creditosBean.getNombreSucursal():"TODOS");
			parametrosReporte.agregaParametro("Par_NomMoneda",(!creditosBean.getNombreMoneda().isEmpty())? creditosBean.getNombreMoneda() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomProductoCre",(!creditosBean.getNombreProducto().isEmpty())? creditosBean.getNombreProducto() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomPromotor",(!creditosBean.getNombrePromotor().isEmpty())? creditosBean.getNombrePromotor() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomGenero",(!creditosBean.getNombreGenero().isEmpty())? creditosBean.getNombreGenero() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomEstado",(!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomMunicipio",(!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi() : "TODOS");

			parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
			parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");
			parametrosReporte.agregaParametro("Par_NivelDetalle",(!creditosBean.getNivelDetalle().isEmpty())?creditosBean.getNivelDetalle(): "1");

			parametrosReporte.agregaParametro("Par_AtrasoInicial",(!creditosBean.getAtrasoInicial().isEmpty())?creditosBean.getAtrasoInicial(): "0");
			parametrosReporte.agregaParametro("Par_AtrasoFinal",(!creditosBean.getAtrasoFinal().isEmpty())?creditosBean.getAtrasoFinal(): "99999");


			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

// Reporte  de saldos totales de Credito
	public String reporteSaldosTotalesCredito(CreditosBean creditosBean, String nomReporte) throws Exception{

			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_Fecha",creditosBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_Sucursal",creditosBean.getSucursal());
			parametrosReporte.agregaParametro("Par_MonedaID",creditosBean.getMonedaID());
			parametrosReporte.agregaParametro("Par_ProductoCre",creditosBean.getProducCreditoID());
			parametrosReporte.agregaParametro("Par_Usuario",creditosBean.getUsuario());

			return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	// Reporte  de saldos totales de Credito en PDF
	public ByteArrayOutputStream reporteSaldosTotalesCreditoPDF(CreditosBean creditosBean,
			String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_Fecha",creditosBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_Sucursal",creditosBean.getSucursal());
			parametrosReporte.agregaParametro("Par_Moneda",creditosBean.getMonedaID());
			parametrosReporte.agregaParametro("Par_ProductoCre",creditosBean.getProducCreditoID());
			parametrosReporte.agregaParametro("Par_Promotor",creditosBean.getPromotorID());
			parametrosReporte.agregaParametro("Par_Genero", creditosBean.getSexo());
			parametrosReporte.agregaParametro("Par_Estado", creditosBean.getEstadoID());
			parametrosReporte.agregaParametro("Par_Municipio", creditosBean.getMunicipioID());
			parametrosReporte.agregaParametro("Par_InstNominaID", creditosBean.getInstitucionNominaID());
			parametrosReporte.agregaParametro("Par_ConvNominaID", creditosBean.getConvenioNominaID());


			parametrosReporte.agregaParametro("Par_NomSucursal",(!creditosBean.getNombreSucursal().isEmpty())? creditosBean.getNombreSucursal():"TODOS");
			parametrosReporte.agregaParametro("Par_NomMoneda",(!creditosBean.getNombreMoneda().isEmpty())? creditosBean.getNombreMoneda() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomProductoCre",(!creditosBean.getNombreProducto().isEmpty())? creditosBean.getNombreProducto() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomPromotor",(!creditosBean.getNombrePromotor().isEmpty())? creditosBean.getNombrePromotor() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomGenero",(!creditosBean.getNombreGenero().isEmpty())? creditosBean.getNombreGenero() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomEstado",(!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado() : "TODOS");
			parametrosReporte.agregaParametro("Par_NomMunicipio",(!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi() : "TODOS");

			parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
			parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");

			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

	// Reporte Plan de Pago Grupal
		public ByteArrayOutputStream reportePlanPagoPDF(RepPlanPagosGrupalBean planPago,
				String nombreReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_FechaMinistrado",planPago.getFechaMinistrado());
				parametrosReporte.agregaParametro("Par_MontoCredito",Utileria.convierteDoble(planPago.getMontoCredito()));
				parametrosReporte.agregaParametro("Par_NombreProducto",planPago.getNombreProducto());
				parametrosReporte.agregaParametro("Par_GrupoID",planPago.getGrupoID());
				parametrosReporte.agregaParametro("Par_NomInstitucion",planPago.getNombreInstitucion());
				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}

	public ByteArrayOutputStream reportePlanPagoIndPDF(RepPlanPagosIndividualBean planPago,
			String nombreReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_FechaMinistrado",planPago.getFechaMinistrado());
				parametrosReporte.agregaParametro("Par_MontoCredito",planPago.getMontoCredito());
				parametrosReporte.agregaParametro("Par_NombreProducto",planPago.getNombreProducto());
				parametrosReporte.agregaParametro("Par_CreditoID",planPago.getCreditoID());
				parametrosReporte.agregaParametro("Par_GrupoID",planPago.getGrupoID());
				parametrosReporte.agregaParametro("Par_ClienteID",planPago.getClienteID());
				parametrosReporte.agregaParametro("Par_NomInstitucion",planPago.getNombreInstitucion());
				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}


		//Reporte Ticket Pago de Credito
	public ByteArrayOutputStream reporteTicketPagoCredito(CreditosBean creditosBean,HttpServletRequest request, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_FechaPago", request.getParameter("fechaSistemaP"));
			parametrosReporte.agregaParametro("Par_MontoPago",  "$"+request.getParameter("monto"));

			parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
			parametrosReporte.agregaParametro("Par_NumSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
			parametrosReporte.agregaParametro("Par_NomSucursal", request.getParameter("nombreSucursal"));

			parametrosReporte.agregaParametro("Par_Plaza", request.getParameter("edoMunSucursal"));
			parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
			parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("varCreditoID"));
			parametrosReporte.agregaParametro("Par_FormaPago", request.getParameter("varFormaPago"));
			parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
			parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));
			parametrosReporte.agregaParametro("Par_ProductoCred", request.getParameter("productoCred"));

			parametrosReporte.agregaParametro("Par_Grupo", request.getParameter("grupo"));
			parametrosReporte.agregaParametro("Par_Ciclo", request.getParameter("ciclo"));
			parametrosReporte.agregaParametro("Par_TituloOperacion", request.getParameter("tituloOperacion"));

			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

		}

	//Reporte Ticket Pago de Comision por Apertura de Credito con Cargo a Cuenta
	public ByteArrayOutputStream reporteTicketPagoComApCredito(CreditosBean creditosBean,HttpServletRequest request, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_FechaPago", request.getParameter("fechaSistemaP"));
			parametrosReporte.agregaParametro("Par_MontoPago", Utileria.convierteFormatoMoneda(request.getParameter("monto")));
			parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
			parametrosReporte.agregaParametro("Par_NumSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
			parametrosReporte.agregaParametro("Par_NomSucursal", request.getParameter("nombreSucursal"));

			parametrosReporte.agregaParametro("Par_Plaza", request.getParameter("edoMunSucursal"));
			parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
			parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("varCreditoID"));
			parametrosReporte.agregaParametro("Par_FormaPago", request.getParameter("varFormaPago"));
			parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));

			parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));
			parametrosReporte.agregaParametro("Par_ProductoCred", request.getParameter("productoCred"));
			parametrosReporte.agregaParametro("Par_Grupo", request.getParameter("grupo"));
			parametrosReporte.agregaParametro("Par_Ciclo", request.getParameter("ciclo"));
			parametrosReporte.agregaParametro("Par_TituloOperacion", request.getParameter("tituloOperacion"));

			parametrosReporte.agregaParametro("Par_ClienteID", request.getParameter("clienteID"));
			parametrosReporte.agregaParametro("Par_NomCliente", request.getParameter("nombreCliente"));
			parametrosReporte.agregaParametro("Par_CuentaID", request.getParameter("cuentaID"));
			parametrosReporte.agregaParametro("Par_NomCuenta", request.getParameter("nomCuenta"));
			parametrosReporte.agregaParametro("Par_MontoPagar", Utileria.convierteFormatoMoneda(request.getParameter("montoPagar")));
			parametrosReporte.agregaParametro("Par_TotalComAp", Utileria.convierteFormatoMoneda(request.getParameter("totalComAper")));
			parametrosReporte.agregaParametro("Par_IVAComAp", Utileria.convierteFormatoMoneda(request.getParameter("IVAComisionApert")));

			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

		}

	// Reporte  de Comisiones Pendientes de Pago
public ByteArrayOutputStream creaRepComPendPagoPDF(CreditosBean creditosBean,
					String nombreReporte) throws Exception{
					ParametrosReporte parametrosReporte = new ParametrosReporte();

					parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
					parametrosReporte.agregaParametro("Par_GrupoID",Utileria.convierteEntero(creditosBean.getGrupoID()));
					parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(creditosBean.getSucursal()));
					parametrosReporte.agregaParametro("Par_MonedaID",Utileria.convierteEntero(creditosBean.getMonedaID()));
					parametrosReporte.agregaParametro("Par_ProductoCre",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
					parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(creditosBean.getPromotorID()));
					parametrosReporte.agregaParametro("Par_Genero",creditosBean.getSexo());
					parametrosReporte.agregaParametro("Par_Estado",Utileria.convierteEntero(creditosBean.getEstadoID()));
					parametrosReporte.agregaParametro("Par_Municipio",Utileria.convierteEntero(creditosBean.getMunicipioID()));
					parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());

					parametrosReporte.agregaParametro("Par_NomCliente",(!creditosBean.getNombreCliente().isEmpty())? creditosBean.getNombreCliente():"TODOS");
					parametrosReporte.agregaParametro("Par_NomGrupo",(!creditosBean.getNombreGrupo().isEmpty())? creditosBean.getNombreGrupo():"TODOS");
					parametrosReporte.agregaParametro("Par_NomSucursal",(!creditosBean.getNombreSucursal().isEmpty())? creditosBean.getNombreSucursal():"TODOS");
					parametrosReporte.agregaParametro("Par_NomMoneda",(!creditosBean.getNombreMoneda().isEmpty())? creditosBean.getNombreMoneda() : "TODOS");
					parametrosReporte.agregaParametro("Par_NomProductoCre",(!creditosBean.getNombreProducto().isEmpty())? creditosBean.getNombreProducto() : "TODOS");
					parametrosReporte.agregaParametro("Par_NomPromotor",(!creditosBean.getNombrePromotor().isEmpty())? creditosBean.getNombrePromotor() : "TODOS");
					parametrosReporte.agregaParametro("Par_NomGenero",(!creditosBean.getNombreGenero().isEmpty())? creditosBean.getNombreGenero() : "TODOS");
					parametrosReporte.agregaParametro("Par_NomEstado",(!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado() : "TODOS");
					parametrosReporte.agregaParametro("Par_NomMunicipio",(!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi() : "TODOS");

					parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
					parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");

					return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
				}

//Reporte  de requerimiento de cobranza
		public ByteArrayOutputStream creaPrimReqtosConbranzaPDF(CreditosBean creditosBean,
				String nombreReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_RequerimientoID",Utileria.convierteEntero(creditosBean.getRequerimientoID()));
				parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
				parametrosReporte.agregaParametro("Par_RFCInstitucion",creditosBean.getRFCInstit());
				parametrosReporte.agregaParametro("Par_DireccionInstitucion",creditosBean.getDireccionInstit());
				parametrosReporte.agregaParametro("Par_TelefonoSucursal",creditosBean.getTelefonoInst());
				parametrosReporte.agregaParametro("Par_Gerente",Utileria.convierteEntero(creditosBean.getGerenteSucursal()));
				parametrosReporte.agregaParametro("Par_NombreCortoIns",creditosBean.getNombreCortoInst());
				parametrosReporte.agregaParametro("Par_FechaAct",Utileria.convierteFecha(creditosBean.getFechaActual()));
				parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
				parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");
				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}

	public ByteArrayOutputStream creaSegReqtosConbranzaPDF(CreditosBean creditosBean,
			String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_RequerimientoID",Utileria.convierteEntero(creditosBean.getRequerimientoID()));
			parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
			parametrosReporte.agregaParametro("Par_RFCInstitucion",creditosBean.getRFCInstit());
			parametrosReporte.agregaParametro("Par_DireccionInstitucion",creditosBean.getDireccionInstit());
			parametrosReporte.agregaParametro("Par_TelefonoSucursal",creditosBean.getTelefonoInst());
			parametrosReporte.agregaParametro("Par_Gerente",Utileria.convierteEntero(creditosBean.getGerenteSucursal()));
			parametrosReporte.agregaParametro("Par_NombreCortoIns",creditosBean.getNombreCortoInst());
			parametrosReporte.agregaParametro("Par_FechaAct",creditosBean.getFechaActual());
			parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
			parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

	//Reporte  de requerimiento de cobranza
	public ByteArrayOutputStream creaTerReqtosConbranzaPDF(CreditosBean creditosBean,
			String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_RequerimientoID",Utileria.convierteEntero(creditosBean.getRequerimientoID()));
			parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
			parametrosReporte.agregaParametro("Par_RFCInstitucion",creditosBean.getRFCInstit());
			parametrosReporte.agregaParametro("Par_DireccionInstitucion",creditosBean.getDireccionInstit());
			parametrosReporte.agregaParametro("Par_TelefonoSucursal",creditosBean.getTelefonoInst());
			parametrosReporte.agregaParametro("Par_Gerente",Utileria.convierteEntero(creditosBean.getGerenteSucursal()));
			parametrosReporte.agregaParametro("Par_NombreCortoIns",creditosBean.getNombreCortoInst());
			parametrosReporte.agregaParametro("Par_FechaAct",creditosBean.getFechaActual());
			parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
			parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");

			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

		}

/* Funciones para Reportes de cliente*/

	// Reporte de Exigible de cartera por cliente en Pdf
	public ByteArrayOutputStream reporteExigibleCarteraCtePDF(CreditosBean creditosBean , String nomReporte) throws Exception{

		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
		parametrosReporte.agregaParametro("Par_NombreInstitucion", creditosBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaReporte",creditosBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_Usuario",creditosBean.getUsuario());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	// Reporte de Exigible de cartera por cliente a Pantalla
	public String reporteExigibleCarteraCtePantalla(CreditosBean creditosBean , String nomReporte) throws Exception{

		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
		parametrosReporte.agregaParametro("Par_NombreInstitucion", creditosBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaReporte",creditosBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_Usuario",creditosBean.getUsuario());

		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	} //


	//Se crea el Reporte de Creditos con Garantia liquida

	public ByteArrayOutputStream creaRepCreditosGarLiqPDF(CreditosBean creditosBean,HttpServletRequest request, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		long Numtrans;
		Numtrans = transaccionDAO.generaNumeroTransaccionOut();


		parametrosReporte.agregaParametro("Par_SucursalInicial",request.getParameter("sucursalInicial"));
		parametrosReporte.agregaParametro("Par_SucursalFinal",request.getParameter("sucursalFinal"));
		parametrosReporte.agregaParametro("Par_ClienteID",request.getParameter("clienteID"));
		parametrosReporte.agregaParametro("Par_CreditoID",request.getParameter("creditoID"));
		parametrosReporte.agregaParametro("Par_NumTransaccion",Numtrans);
		parametrosReporte.agregaParametro("Par_NombreInstitucion",creditosBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NomUsuario",request.getParameter("nomUsuario"));
		parametrosReporte.agregaParametro("Par_FechaEmision",request.getParameter("fechaEmision"));



		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}



	// Reporte Referencias Bancarios ::
	public ByteArrayOutputStream creaReporteReferencias(CreditosBean creditosBean, String nombreReporte) throws Exception{
					ParametrosReporte parametrosReporte = new ParametrosReporte();
					parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
					return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
				}

	//Se crea el Reporte de Creditos Otorgados
	public ByteArrayOutputStream creaRepCreditosOtorgadosPDF(CreditosBean creditosBean,HttpServletRequest request, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_Fecha",request.getParameter("fechaInicio"));
		parametrosReporte.agregaParametro("Par_SucursalID",request.getParameter("sucursalID"));
		parametrosReporte.agregaParametro("Par_UsuarioID",request.getParameter("usuario"));
		parametrosReporte.agregaParametro("Par_ProducCreditoID",request.getParameter("producCreditoID"));
		parametrosReporte.agregaParametro("Par_NombreInstitucion",request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NomUsuario",request.getParameter("nomUsuario"));
		parametrosReporte.agregaParametro("Par_FechaEmision",request.getParameter("fechaEmision"));

		parametrosReporte.agregaParametro("Par_nomSucursal",request.getParameter("nombreSucursal1"));
		parametrosReporte.agregaParametro("Par_nombreUsuario",request.getParameter("nombreUsuario"));
		parametrosReporte.agregaParametro("Par_nombreProducto",request.getParameter("nombreProducto"));
		parametrosReporte.agregaParametro("Par_TipoCredito",request.getParameter("tipoCredito"));


		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//Reporte Ticket RECUPERACION DE CREDITO CASTIGADO CON CARGO A CUENTA
	public ByteArrayOutputStream pagoRecCreditoCastAgro(CreditosBean creditosBean,HttpServletRequest request, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_FechaPago", request.getParameter("fechaSistemaP"));
			parametrosReporte.agregaParametro("Par_MontoPago", Utileria.convierteFormatoMoneda(request.getParameter("monto")));
			parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
			parametrosReporte.agregaParametro("Par_NumSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
			parametrosReporte.agregaParametro("Par_NomSucursal", request.getParameter("nombreSucursal"));

			parametrosReporte.agregaParametro("Par_Plaza", request.getParameter("edoMunSucursal"));
			parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
			parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("varCreditoID"));
			parametrosReporte.agregaParametro("Par_FormaPago", request.getParameter("varFormaPago"));
			parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));

			parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));
			parametrosReporte.agregaParametro("Par_ProductoCred", request.getParameter("productoCred"));
			parametrosReporte.agregaParametro("Par_TituloOperacion", request.getParameter("tituloOperacion"));

			parametrosReporte.agregaParametro("Par_ClienteID", request.getParameter("clienteID"));
			parametrosReporte.agregaParametro("Par_NomCliente", request.getParameter("nombreCliente"));
			parametrosReporte.agregaParametro("Par_UsuarioID", request.getParameter("usuarioID"));
			parametrosReporte.agregaParametro("Par_NomUsuario", request.getParameter("nomUsuario"));


			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

		}
	//Se crea el Reporte de Cartas Finiquito
		public ByteArrayOutputStream creaRepCartasFiniquitoPDF(CartasFiniquitoBean cartasFiniquito,HttpServletRequest request, String nomReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();

			parametrosReporte.agregaParametro("Par_ProducCreditoID",Utileria.convierteEntero(cartasFiniquito.getProducCreditoID()));
			parametrosReporte.agregaParametro("Par_NombreInstitucion",request.getParameter("nombreInstitucion"));
			parametrosReporte.agregaParametro("Par_FechaInicio",cartasFiniquito.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin",cartasFiniquito.getFechaFin());
			parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(cartasFiniquito.getSucursalID()));

			parametrosReporte.agregaParametro("Par_MonedaID",Utileria.convierteEntero(cartasFiniquito.getMonedaID()));
			parametrosReporte.agregaParametro("Par_InstNomID",Utileria.convierteEntero(cartasFiniquito.getInstitucionNominaID()));
			parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(cartasFiniquito.getPromotorID()));
			parametrosReporte.agregaParametro("Par_Genero",cartasFiniquito.getGenero());
			parametrosReporte.agregaParametro("Par_Estado",Utileria.convierteEntero(cartasFiniquito.getEstadoID()));
			parametrosReporte.agregaParametro("Par_Municipio",Utileria.convierteEntero(cartasFiniquito.getMunicipioID()));


			return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

		// Reporte Pagare Santa Fe
		public ByteArrayOutputStream reportePagareSF(String clienteEspecifico,CreditosBean creditosBean, Integer tipoReporte,
				String nombreReporte) throws Exception{
			MonedasBean monedaBean = null;
			monedaBean = monedasServicio.consultaMoneda(Enum_Con_Monedas.principal, creditosBean.getMonedaID());

			String montoLetra=Utileria.cantidadEnLetrasWeb(
					creditosBean.getMontoCredito(),
					Utileria.convierteEntero(monedaBean.getMonedaID()),
					monedaBean.getSimbolo(),
					monedaBean.getDescripcion());

			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_Credito",creditosBean.getCreditoID());
			parametrosReporte.agregaParametro("Par_Usuario",creditosBean.getUsuario());
			parametrosReporte.agregaParametro("Par_MontoEnLetras",montoLetra);
			parametrosReporte.agregaParametro("Par_Monto",creditosBean.getMontoCredito());
			parametrosReporte.agregaParametro("Par_RECA",creditosBean.getProducCreditoID());
			parametrosReporte.agregaParametro("Par_NomInstitucion", creditosBean.getNombreInstitucion());

			parametrosReporte.agregaParametro("Par_SucursalID", creditosBean.getSucursal());
			parametrosReporte.agregaParametro("Par_GerenteGeneral", creditosBean.getGerenteSucursal());
			parametrosReporte.agregaParametro("Par_DirecInstit",creditosBean.getDireccionInstit());
			parametrosReporte.agregaParametro("Par_RFCInt",creditosBean.getRFCInstit());
			parametrosReporte.agregaParametro("Par_TelInst",creditosBean.getTelefonoInst());

			parametrosReporte.agregaParametro("Par_FechaEmision", creditosBean.getFechaSistema());
			parametrosReporte.agregaParametro("Par_CteEspecifico", clienteEspecifico);
			parametrosReporte.agregaParametro("Par_TipoReporte", tipoReporte);

			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}


		// Reporte Pagare SOFINI
		public ByteArrayOutputStream reportePagareSOFINI(CreditosBean creditosBean, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_CreditoID",Utileria.convierteLong(creditosBean.getCreditoID()));
			parametrosReporte.agregaParametro("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
			parametrosReporte.agregaParametro("Par_NomInstitucion", creditosBean.getNombreInstitucion());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

		public ByteArrayOutputStream reporteContratoSOFINI(CreditosBean creditosBean, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_CreditoID",Utileria.convierteLong(creditosBean.getCreditoID()));
			parametrosReporte.agregaParametro("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
			parametrosReporte.agregaParametro("Par_NomInstitucion", creditosBean.getNombreInstitucion());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		public ByteArrayOutputStream reporteCaratulaAsefimex(CreditosBean creditosBean, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
			parametrosReporte.agregaParametro("Par_SolicitudCreditoID", creditosBean.getSolicitudCreditoID());
			parametrosReporte.agregaParametro("Par_NomInstitucion",creditosBean.getNombreInstitucion().toUpperCase());
			parametrosReporte.agregaParametro("Par_SucursalID",creditosBean.getSucursal());
			parametrosReporte.agregaParametro("Par_UsuarioID",creditosBean.getUsuario());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		public ByteArrayOutputStream reportePresentacionCreditoAsefimex(CreditosBean creditosBean, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
			parametrosReporte.agregaParametro("Par_SucursalID",creditosBean.getSucursal());
			parametrosReporte.agregaParametro("Par_UsuarioID",creditosBean.getUsuario());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		public ByteArrayOutputStream reporteAmortizacionAsefimex(CreditosBean creditosBean, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			CreditosBean creditos = null;
			String strBase64 = null;
			creditos = creditosDAO.consultaCodigoOxxo(creditosBean, 10);
			parametrosReporte.agregaParametro("Par_CodigoBarras",creditos.getDigVerificador());
			parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
			parametrosReporte.agregaParametro("Par_ClienteID", creditosBean.getClienteID());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		public ByteArrayOutputStream reporteContratoAsefimex(CreditosBean creditosBean, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_CreditoID",creditosBean.getCreditoID());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}


	//-------------------------------------------------------------------------------------------------
	// -------------------- PROCESOS ------------------------------------------------------------------
	//-------------------------------------------------------------------------------------------------

	// Proceso que ejecuta la Cobranza Automatica Intradia
	public MensajeTransaccionBean realizaCobranzaAutomatica(CreditosBean credBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<CobranzaAutomaticaBean> listaCreditos;
		List<CobranzaAutomaticaBean> listaCreditosComision;
		int totalAplicados = 0;
		int totalFallidos = 0;
		int tipoConsulta = 1;
		int consultaParam = 26;
		String numEmpresa = "1";
		String cobranzaCierre = "N";
		String cobraGarantiaFinanciada = "N";
		String cobraGarantiaFOGA = "N";
		String cobraGarantiaFOGAFI = "N";

		CobranzaAutomaticaBean cobranzaAutomaticaBean;
		CreditosBean creditosBean;
		CuentasAhoBean cuentasAhoBean;
		MensajeTransaccionBean mensajeDelPago;
		BitacoraCobAutoBean bitacoraCobAutoBean;
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean.setEmpresaID(numEmpresa);
		cobranzaCierre = credBean.getCobranzaCierre();
		parametrosSisBean = parametrosSisServicio.consulta(tipoConsulta, parametrosSisBean);
		ParamGeneralesBean parameGeneralesBean = new ParamGeneralesBean();
		parameGeneralesBean = paramGeneralesServicio.consulta(consultaParam, parameGeneralesBean);
		double tiempoProceso = 0;
		Date fecAhora;
		Date fecPago;

		cobraGarantiaFinanciada = parameGeneralesBean.getValorParametro();

		MensajeTransaccionBean mensajeActualiza = new MensajeTransaccionBean();
		CreditosBean creditos = null;

		mensajeActualiza = creditosDAO.actualizaCobranza(creditos, Enum_Con_Cobranza.actCobAutomaticaSI);

		if (mensajeActualiza.getNumero() == 0) {

			// Cobrar primero los créditos con adeudo en la comision por apertura

			listaCreditosComision = creditosDAO.listaParaCobranzaAutomatica(Enum_Con_CobAutomatica.CreditosPorPagarCom);
			listaCreditos = creditosDAO.listaParaCobranzaAutomatica(Enum_Con_CobAutomatica.CreditosPorPagar);

			if (listaCreditos != null || listaCreditosComision != null) {
				mensaje.setNumero(0);
				mensaje.setDescripcion("Creditos por Procesar Cobranza IntraDia: " + listaCreditos.size() + Constantes.SALTO_LINEA);

				// COBRO DE LA COMISIÓN POR APERTURA
				if (listaCreditosComision != null) {
					for (int i = 0; i < listaCreditosComision.size(); i++) {
						// Inicializaciones
						mensajeDelPago = null;
						creditosBean = new CreditosBean();
						fecAhora = new Date();
						cobranzaAutomaticaBean = (CobranzaAutomaticaBean) listaCreditosComision.get(i);
						double deudaExigible = 0;
						double disponibleEnCuenta = 0;
						bitacoraCobAutoBean = new BitacoraCobAutoBean();
						deudaExigible = cobranzaAutomaticaBean.getMontoExigible();
						String tipoComision = "CA";
						String tipoCobro = "I";

						// Consultamos el disponible de la Cuenta de Ahorro
						cuentasAhoBean = new CuentasAhoBean();
						cuentasAhoBean.setCuentaAhoID(cobranzaAutomaticaBean.getCuentaID());
						cuentasAhoBean = cuentasAhoServicio.consultaCuentasAho(CuentasAhoServicio.Enum_Con_CuentasAho.saldosYEstatus, cuentasAhoBean);
						if (cuentasAhoBean != null) {
							disponibleEnCuenta = Utileria.convierteDoble(cuentasAhoBean.getSaldoDispon());
						} else {
							disponibleEnCuenta = Constantes.ENTERO_CERO;
						}

						if (disponibleEnCuenta > Constantes.ENTERO_CERO) {

							// Verificamos el Monto del Pago

							creditosBean.setMontoPagar(String.valueOf(deudaExigible));

							creditosBean.setCreditoID(cobranzaAutomaticaBean.getCreditoID());
							creditosBean.setCuentaID(cobranzaAutomaticaBean.getCuentaID());
							creditosBean.setMonedaID(cobranzaAutomaticaBean.getMonedaID());
							creditosBean.setFiniquito(Constantes.ES_FINIQUITO_NO);
							creditosBean.setPrepago(Constantes.ES_PREPAGO_NO);
							creditosBean.setTipoComision(tipoComision);
							creditosBean.setTipoCobro(tipoCobro);
							// Se realiza el pago de la comisión
							mensajeDelPago = creditosDAO.PagoComisionCreditoCargoCuenta(creditosBean);

							if (mensajeDelPago == null || mensajeDelPago.getNumero() != 0) {
								totalFallidos = totalFallidos + 1;
								bitacoraCobAutoBean.setEstatus(BitacoraCobAutoBean.PAGO_FALLIDO);
							} else {
								totalAplicados = totalAplicados + 1;
								bitacoraCobAutoBean.setEstatus(BitacoraCobAutoBean.PAGO_APLICADO);
							}

							// Grabamos en la Bitacora de la Cobranza Automatica
							bitacoraCobAutoBean.setCreditoID(cobranzaAutomaticaBean.getCreditoID());
							bitacoraCobAutoBean.setGrupoID(Constantes.STRING_VACIO);
							bitacoraCobAutoBean.setClienteID(cuentasAhoBean.getClienteID());
							bitacoraCobAutoBean.setCuentaID(cobranzaAutomaticaBean.getCuentaID());
							bitacoraCobAutoBean.setDisponibleCuenta(disponibleEnCuenta);
							bitacoraCobAutoBean.setMontoExigible(deudaExigible);
							bitacoraCobAutoBean.setMontoAplicado(Utileria.convierteDoble(creditosBean.getMontoPagar()));
							fecPago = new Date();
							tiempoProceso = (fecPago.getTime() - fecAhora.getTime()) / 1000;
							bitacoraCobAutoBean.setTiempoProceso(tiempoProceso);

							creditosDAO.altaBitacoraCobAuto(bitacoraCobAutoBean);

						}

					} // End del For, del Ciclo de Barrer los Pagos

				}

				// FIN DEL COBRO DE LA COMISIÓN POR APERTURA

				for (int i = 0; i < listaCreditos.size(); i++) {
					// Inicializaciones
					mensajeDelPago = null;

					creditosBean = new CreditosBean();

					fecAhora = new Date();
					cobranzaAutomaticaBean = (CobranzaAutomaticaBean) listaCreditos.get(i);
					double deudaExigible = 0;
					double disponibleEnCuenta = 0;
					bitacoraCobAutoBean = new BitacoraCobAutoBean();
					deudaExigible = cobranzaAutomaticaBean.getMontoExigible();
					String prorrateaPago = cobranzaAutomaticaBean.getProrratea();
					String cobraCompleto = "";

					cobraGarantiaFOGA = cobranzaAutomaticaBean.getCobraGarFOGA();
					cobraGarantiaFOGAFI = cobranzaAutomaticaBean.getCobraGarFOGAFI();

					// Consultamos el disponible de la Cuenta de Ahorro
					cuentasAhoBean = new CuentasAhoBean();
					cuentasAhoBean.setCuentaAhoID(cobranzaAutomaticaBean.getCuentaID());
					if(cobraGarantiaFinanciada.equalsIgnoreCase("S") && (cobraGarantiaFOGA.equalsIgnoreCase("S") || cobraGarantiaFOGAFI.equalsIgnoreCase("S"))){
						// Consultar mediante credito
						cuentasAhoBean.setTransaccionID(cobranzaAutomaticaBean.getCreditoID());
						cuentasAhoBean = cuentasAhoServicio.consultaCuentasAho(CuentasAhoServicio.Enum_Con_CuentasAho.saldoCreditosFogafi,  cuentasAhoBean);
					} else {
						cuentasAhoBean = cuentasAhoServicio.consultaCuentasAho(CuentasAhoServicio.Enum_Con_CuentasAho.saldosYEstatus, cuentasAhoBean);
					}

					if (cuentasAhoBean != null) {
						disponibleEnCuenta = Utileria.convierteDoble(cuentasAhoBean.getSaldoDispon());
					} else {
						disponibleEnCuenta = Constantes.ENTERO_CERO;
					}

					if ((disponibleEnCuenta > Constantes.ENTERO_CERO) || (cobraGarantiaFinanciada.equalsIgnoreCase("S") && (cobraGarantiaFOGA.equalsIgnoreCase("S") || cobraGarantiaFOGAFI.equalsIgnoreCase("S")))) {

						// Verificamos el Monto del Pago
						if (disponibleEnCuenta >= deudaExigible) {
							creditosBean.setMontoPagar(String.valueOf(deudaExigible));
							if(cobraGarantiaFinanciada.equalsIgnoreCase("S") && (cobraGarantiaFOGA.equalsIgnoreCase("S") || cobraGarantiaFOGAFI.equalsIgnoreCase("S"))){
								creditosBean.setMontoPagar(String.valueOf(disponibleEnCuenta));
							}
							cobraCompleto = "S";
						} else {
							creditosBean.setMontoPagar(String.valueOf(disponibleEnCuenta));
							cobraCompleto = "N";
						}

						creditosBean.setCreditoID(cobranzaAutomaticaBean.getCreditoID());
						creditosBean.setCuentaID(cobranzaAutomaticaBean.getCuentaID());
						creditosBean.setMonedaID(cobranzaAutomaticaBean.getMonedaID());
						creditosBean.setFiniquito(Constantes.ES_FINIQUITO_NO);
						creditosBean.setPrepago(Constantes.ES_PREPAGO_NO);
						creditosBean.setCobranzaCierre(cobranzaCierre);
						creditosBean.setOrigen("A");
						// Realizamos el Pago Individual
						if (cobranzaAutomaticaBean.getGrupoCreditoID().equalsIgnoreCase(Constantes.STRING_CERO)) {

							if (creditosBean.getCobranzaCierre().equals("S")) {


								// Si se requieren realizar cobros completos
								if (parametrosSisBean.getCobroCompletoAut().equals("S") && cobraCompleto == "S") {
									mensajeDelPago = creditosDAO.PagoCredito(creditosBean);
								}

								if (parametrosSisBean.getCobroCompletoAut().equals("N") && cobraCompleto == "N") {
									mensajeDelPago = creditosDAO.PagoCredito(creditosBean);
								}

								if (parametrosSisBean.getCobroCompletoAut().equals("N") && cobraCompleto == "S") {
									mensajeDelPago = creditosDAO.PagoCredito(creditosBean);
								}
							} else {
								mensajeDelPago = creditosDAO.PagoCredito(creditosBean);
							}

						} else { // Realizamos el Pago Grupal
							if (prorrateaPago.equalsIgnoreCase("S")) {
								creditosBean.setGrupoID(cobranzaAutomaticaBean.getGrupoCreditoID());
								creditosBean.setCicloGrupo(String.valueOf(cobranzaAutomaticaBean.getCicloGrupo()));
								creditosBean.setFormaPago(Constantes.MODO_PAGO_CARGO_CUENTA);
								mensajeDelPago = creditosDAO.pagoGrupalCredito(creditosBean);
							} else {
								mensajeDelPago = creditosDAO.PagoCredito(creditosBean);
							}
						}
						if (mensajeDelPago == null || mensajeDelPago.getNumero() != 0) {
							totalFallidos = totalFallidos + 1;
							bitacoraCobAutoBean.setEstatus(BitacoraCobAutoBean.PAGO_FALLIDO);
						} else {
							totalAplicados = totalAplicados + 1;
							bitacoraCobAutoBean.setEstatus(BitacoraCobAutoBean.PAGO_APLICADO);
						}

						// Grabamos en la Bitacora de la Cobranza Automatica
						bitacoraCobAutoBean.setCreditoID(cobranzaAutomaticaBean.getCreditoID());
						bitacoraCobAutoBean.setGrupoID(Constantes.STRING_VACIO);
						bitacoraCobAutoBean.setClienteID(cuentasAhoBean.getClienteID());
						bitacoraCobAutoBean.setCuentaID(cobranzaAutomaticaBean.getCuentaID());
						bitacoraCobAutoBean.setDisponibleCuenta(disponibleEnCuenta);
						bitacoraCobAutoBean.setMontoExigible(deudaExigible);
						bitacoraCobAutoBean.setMontoAplicado(Utileria.convierteDoble(creditosBean.getMontoPagar()));
						fecPago = new Date();
						tiempoProceso = (fecPago.getTime() - fecAhora.getTime()) / 1000;
						bitacoraCobAutoBean.setTiempoProceso(tiempoProceso);

						creditosDAO.altaBitacoraCobAuto(bitacoraCobAutoBean);

					}

				} // End del For, del Ciclo de Barrer los Pagos
				mensaje.setDescripcion(mensaje.getDescripcion() + " . Total Aplicados: " + totalAplicados + Constantes.SALTO_LINEA);
				mensaje.setDescripcion(mensaje.getDescripcion() + " . Total Fallidos: " + totalFallidos);
				creditosDAO.actualizaCobranza(creditos, Enum_Con_Cobranza.actCobAutomaticaNO);

				mensaje.setNombreControl("procesar");
				mensaje.setConsecutivoString(Constantes.STRING_CERO);
				mensaje.setConsecutivoInt(Constantes.STRING_CERO);

			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("No existen Creditos por Procesar");
			}
		} else {
			mensaje = mensajeActualiza;
		}

		return mensaje;
	}


	// Proceso que ejecuta la Cobranza Automatica Nocturna o de Fin de Día
	// A diferencia de la cobranza automatica intradía, esta cobranza nocturna
	// intenta cobrar el total de adeudo del grupo, cargando en las cuentas de cualquier integrante
	public MensajeTransaccionBean realizaCobranzaAutomaticaFinDia(){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List listaCreditos;
		List listaCuentas;
		int totalAplicados = 0;
		int totalFallidos = 0;
		CobranzaAutomaticaBean cobranzaAutomaticaBean;
		CreditosBean creditosBean;
		CuentasAhoBean cuentasAhoBean;
		MensajeTransaccionBean mensajeDelPago;
		BitacoraCobAutoBean bitacoraCobAutoBean;
		IntegraGruposBean integraGruposBean;
		double tiempoProceso = 0;
		Date fecAhora;
		Date fecPago;


		bitacoraCobAutoBean = new BitacoraCobAutoBean();
		bitacoraCobAutoBean.setFechaProceso(parametrosSesionBean.getFechaAplicacion().toString());

		MensajeTransaccionBean mensajeActualiza = new MensajeTransaccionBean();
		CreditosBean creditos = null;

		mensajeActualiza = creditosDAO.actualizaCobranza(creditos,Enum_Con_Cobranza.actCobAutomaticaSI);

		if(mensajeActualiza.getNumero()==0){
		//Consultamos si ya se Ejecuto la Cobranza Automatica Intradia, si no la ejecutamos
		bitacoraCobAutoBean = consultaBitacoraCobranzaAut(Enum_Con_BitacoraCobranzaAuto.CobrosPorFecha, bitacoraCobAutoBean);

		mensaje.setDescripcion(Constantes.STRING_VACIO);
		if( bitacoraCobAutoBean == null || bitacoraCobAutoBean.getNumeroPagosPorFecha() <= 0){
			mensaje.setDescripcion(realizaCobranzaAutomatica(creditos).getDescripcion() + Constantes.SALTO_LINEA + Constantes.SALTO_LINEA);
		}

		//Consulta los Creditos Grupales con Saldo Exigible
		listaCreditos = creditosDAO.listaParaCobranzaAutomaticaFinDia(Enum_Con_CobAutomatica.CreditosGrupales);

		if(listaCreditos!=null){
			mensaje.setNumero(0);
			mensaje.setDescripcion("Grupos por Procesar Cobranza de Fin de Dia: " + listaCreditos.size() + Constantes.SALTO_LINEA);

			for(int i=0; i<listaCreditos.size(); i++){
				// Inicializaciones
				mensajeDelPago=null;
				listaCuentas = null;
				integraGruposBean = new IntegraGruposBean();
				fecAhora = new Date();
				double deudaExigible = 0;
				double disponibleEnCuenta = 0;
				bitacoraCobAutoBean = new BitacoraCobAutoBean();

				cobranzaAutomaticaBean = (CobranzaAutomaticaBean)listaCreditos.get(i);
				deudaExigible = cobranzaAutomaticaBean.getMontoExigible();

				//Consultamos las cuentas de ahorro de los Integrantes del Grupo, para intentar pagar
				//El total del adeudo del Grupo
				integraGruposBean.setGrupoID(cobranzaAutomaticaBean.getGrupoCreditoID());
				integraGruposBean.setCiclo(String.valueOf(cobranzaAutomaticaBean.getCicloGrupo()));

				listaCuentas = integraGruposServicio.lista(IntegraGruposServicio.Enum_Lis_Grupos.integrantesActivos, integraGruposBean);

				if(listaCuentas != null && deudaExigible > 0){
					for(int j=0; j<listaCuentas.size(); j++){

						//Consultamos el disponible de la Cuenta de Ahorro
						disponibleEnCuenta = Constantes.ENTERO_CERO;
						creditosBean = new CreditosBean();
						String CuentaAhoIDStr;

						cuentasAhoBean =  (CuentasAhoBean)listaCuentas.get(j);
						CuentaAhoIDStr = cuentasAhoBean.getCuentaAhoID();
						cuentasAhoBean = cuentasAhoServicio.consultaCuentasAho(CuentasAhoServicio.Enum_Con_CuentasAho.saldosYEstatus,
																			   cuentasAhoBean);
						if(cuentasAhoBean!= null){
							disponibleEnCuenta = Utileria.convierteDoble(cuentasAhoBean.getSaldoDispon());
						}else{
							disponibleEnCuenta = Constantes.ENTERO_CERO;
						}

						if(disponibleEnCuenta > Constantes.ENTERO_CERO){

							// Verificamos el Monto del Pago
							if(disponibleEnCuenta >= deudaExigible){
								creditosBean.setMontoPagar(String.valueOf(deudaExigible));
							}else{
								creditosBean.setMontoPagar(String.valueOf(disponibleEnCuenta));
							}

							creditosBean.setGrupoID(cobranzaAutomaticaBean.getGrupoCreditoID());
							creditosBean.setCuentaID(CuentaAhoIDStr);
							creditosBean.setMonedaID(cobranzaAutomaticaBean.getMonedaID());
							creditosBean.setFiniquito(Constantes.ES_FINIQUITO_NO);
							creditosBean.setPrepago(Constantes.ES_PREPAGO_NO);

							//Realizamos el Pago Grupal
							creditosBean.setGrupoID(cobranzaAutomaticaBean.getGrupoCreditoID());
							creditosBean.setFormaPago(Constantes.MODO_PAGO_CARGO_CUENTA);
							mensajeDelPago = creditosDAO.pagoGrupalCredito(creditosBean);

							if(mensajeDelPago == null || mensajeDelPago.getNumero() != 0){
								totalFallidos = totalFallidos+1;
								bitacoraCobAutoBean.setEstatus(BitacoraCobAutoBean.PAGO_FALLIDO);
							}else{
								totalAplicados = totalAplicados+1;
								bitacoraCobAutoBean.setEstatus(BitacoraCobAutoBean.PAGO_APLICADO);
								deudaExigible = deudaExigible - Utileria.convierteDoble(creditosBean.getMontoPagar());
							}

							//Grabamos en la Bitacora de la Cobranza Automatica
							bitacoraCobAutoBean.setCreditoID(Constantes.STRING_VACIO);
							bitacoraCobAutoBean.setGrupoID(cobranzaAutomaticaBean.getGrupoCreditoID());
							bitacoraCobAutoBean.setClienteID(cuentasAhoBean.getClienteID());
							bitacoraCobAutoBean.setCuentaID(CuentaAhoIDStr);
							bitacoraCobAutoBean.setDisponibleCuenta(disponibleEnCuenta);
							bitacoraCobAutoBean.setMontoExigible(deudaExigible);
							bitacoraCobAutoBean.setMontoAplicado(Utileria.convierteDoble(creditosBean.getMontoPagar()));
							fecPago= new Date();
							tiempoProceso = (fecPago.getTime() - fecAhora.getTime())/1000;
							bitacoraCobAutoBean.setTiempoProceso(tiempoProceso);

							creditosDAO.altaBitacoraCobAuto(bitacoraCobAutoBean);
						}
						//Si ya no tiene adeudo el Grupo salimos del Ciclo de barrer las Cuentas de los Integrantes para Pago
						if(deudaExigible <= 0){
							break;
						}

					}   //End del For listaCuentas
				}
			} //End del For, del Ciclo de Barrer los Pagos, listaCreditos

			mensaje.setDescripcion(mensaje.getDescripcion() + " . Total Pagos Aplicados: " + totalAplicados + Constantes.SALTO_LINEA);
			mensaje.setDescripcion(mensaje.getDescripcion() + " . Total Pagos Fallidos: " + totalFallidos);
			creditosDAO.actualizaCobranza(creditos,Enum_Con_Cobranza.actCobAutomaticaNO);

			mensaje.setNombreControl("procesar");
			mensaje.setConsecutivoString(Constantes.STRING_CERO);
			mensaje.setConsecutivoInt(Constantes.STRING_CERO);

		}else{
			mensaje.setNumero(999);
			mensaje.setDescripcion("No existen Creditos por Procesar");
			}
		}
		else{
			mensaje = mensajeActualiza;
		}
		return mensaje;
	}

	public MensajeTransaccionBean realizaCobranzaAutomaticaReferencia(CreditosBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		int tipoConsulta = 1;
		String numEmpresa = "1";
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean.setEmpresaID(numEmpresa);

		parametrosSisBean = parametrosSisServicio.consulta(tipoConsulta, parametrosSisBean);

		CreditosBean creditos = null;

		mensaje = creditosDAO.actualizaCobranza(creditos, Enum_Con_Cobranza.actCobAutoRefereSI);

		if (mensaje.getNumero() == 0) {
			// Cobrar primero los créditos con adeudo en la comision por apertura
			mensaje = creditosDAO.cobranzaAutxReferencia(bean);
			creditosDAO.actualizaCobranza(creditos, Enum_Con_Cobranza.actCobAutoRefereNO);
		}
		return mensaje;
	}

	/* =========  Reporte del Historico de Cartera por cliente PDF  =========== */
	public ByteArrayOutputStream reporteHisCarteraCliente(int tipoReporte, CreditosBean bean , String nomReporte) throws Exception{

		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_ClienteID",bean.getClienteID());
		parametrosReporte.agregaParametro("Par_NombreCliente",bean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_Estatus",bean.getEstatus());parametrosReporte.agregaParametro("Par_Estatus",bean.getEstatus());
		parametrosReporte.agregaParametro("Par_EstatusDes",bean.getDescripcion());
		parametrosReporte.agregaParametro("Par_NumRep",tipoReporte);

		parametrosReporte.agregaParametro("Par_NombreInstitucion", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema",bean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_Usuario",bean.getNombreUsuario());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}




	public Object consultaActividad(int tipoConsulta, Object consultaActividad){
		Object obj= null;
		switch (tipoConsulta) {
		case Enum_Con_CreditosWS.actividadCredito:
			ConsultaActividadCreditoRequest consultaRequest = (ConsultaActividadCreditoRequest)consultaActividad;
			ConsultaActividadCreditoResponse consultaResponse=null;
			consultaResponse = creditosDAO.consultaActividadCredito(consultaRequest, tipoConsulta);

			if(consultaResponse == null) {
				consultaResponse = new ConsultaActividadCreditoResponse();
				consultaResponse.setActivosTotal(String.valueOf(Constantes.ENTERO_CERO));
				consultaResponse.setTotalPrestado(String.valueOf(Constantes.ENTERO_CERO));
				consultaResponse.setSaldoActual(String.valueOf(Constantes.ENTERO_CERO));
				consultaResponse.setPesosenMora(String.valueOf(Constantes.ENTERO_CERO));
				consultaResponse.setMoraMayor(String.valueOf(Constantes.ENTERO_CERO));
				consultaResponse.setQuebrantos(String.valueOf(Constantes.ENTERO_CERO));
				consultaResponse.setPagosPuntuales(String.valueOf(Constantes.ENTERO_CERO));
				consultaResponse.setPagosRealizados(String.valueOf(Constantes.ENTERO_CERO));
				consultaResponse.setMoraMenorTreintaDias(String.valueOf(Constantes.ENTERO_CERO));
				consultaResponse.setMoraMayorTreintaDias(String.valueOf(Constantes.ENTERO_CERO));
				consultaResponse.setCodigoRespuesta("02");
				consultaResponse.setMensajeRespuesta("No existen datos para ese cliente");
			}
			obj=(Object)consultaResponse;
			break;
		}
		return obj;
	}





 	// Separador de campos y registros de la lista de Descuentos de Nomina WS
		private String transformArray(List listaDescuentos){
	        String resultadoDescuento = "";
	        String separadorCampos = "[";
	 		String separadorRegistro = "]";

	 		CreditosBean creditosBean;
	        if(listaDescuentos!= null){
	            Iterator<CreditosBean> it = listaDescuentos.iterator();
	            while(it.hasNext()){
	            	creditosBean = (CreditosBean)it.next();
	            	resultadoDescuento += creditosBean.getCreditoID()+separadorCampos+
	            			creditosBean.getClienteID()+ separadorCampos +
	            			creditosBean.getNombreCliente()+ separadorCampos +
	            			creditosBean.getFechaPago()+ separadorCampos +
	            			creditosBean.getMontoExigible()+ separadorRegistro;
	            }
	        }
	 		if(resultadoDescuento.length() !=0){
	 				resultadoDescuento = resultadoDescuento.substring(0,resultadoDescuento.length()-1);
	 		}
	        return resultadoDescuento;
	    }


//Metodo que transforma un Lista en una String con Separadores
//Separador de Registros ], Separador de Campos [
	private String transformListaSimulador(List listaSimuladorCredito) {
	    String resultadoSimulador = "";
	    String separadorCampos = "[";
	    String separadorRegistros = "]";

	    AmortizacionCreditoBean amortizacionBean;
	    if(listaSimuladorCredito != null) {
	        Iterator<AmortizacionCreditoBean> it = listaSimuladorCredito.iterator();
	        while(it.hasNext()){
	        	amortizacionBean = (AmortizacionCreditoBean)it.next();

	        	resultadoSimulador +=amortizacionBean.getAmortizacionID()+ separadorCampos +
	        	amortizacionBean.getFechaInicio()+ separadorCampos +
				amortizacionBean.getFechaVencim()+ separadorCampos +
				amortizacionBean.getFechaExigible()+ separadorCampos +
	        	amortizacionBean.getCapital()+ separadorCampos +
	        	amortizacionBean.getInteres()+ separadorCampos +
	        	amortizacionBean.getIvaInteres()+ separadorCampos +
	        	amortizacionBean.getTotalPago()+ separadorCampos +
	        	amortizacionBean.getSaldoInsoluto()+ separadorCampos +
	        	amortizacionBean.getDias()+ separadorCampos +
	        	amortizacionBean.getCuotasCapital()+ separadorCampos +
	        	amortizacionBean.getNumTransaccion()+ separadorCampos +
	        	amortizacionBean.getCat()+ separadorCampos +
	        	amortizacionBean.getFecUltAmor()+ separadorCampos +
	        	amortizacionBean.getFecInicioAmor()+ separadorCampos +
	        	amortizacionBean.getMontoCuota()+ separadorRegistros;

	        }
	    }
	    if(resultadoSimulador.length() != 0){
	    	resultadoSimulador = resultadoSimulador.substring(0,resultadoSimulador.length()-1);
	    }
	    return resultadoSimulador;
	}





 	// Separador de campos y registros de la lista de Creditos WS
		private String CreaString(List listaCredito)
	    {
	        String resultado= "";
	        String separadorCampos = "[";
	 		String separadorRegistro = "]";

	 		CreditosBean creditosBean;
	        if(listaCredito!= null)
	        {
	            Iterator<CreditosBean> it = listaCredito.iterator();
	            while(it.hasNext())
	            {
	            	creditosBean = (CreditosBean)it.next();
	            	resultado += creditosBean.getCreditoID()+separadorCampos+
	            			creditosBean.getCreditoProductoMonto()+ separadorRegistro;
	            }
	        }
	 		if(resultado.length() !=0){
	 				resultado = resultado.substring(0,resultado.length()-1);
	 		}
	        return resultado;
	    }




	   	// Separador de campos y registros de la lista de Creditos WS
			private String CreaStringSolCre(List listaCredito)
		    {
		        String resultado= "";
		        String separadorCampos = "[";
		 		String separadorRegistro = "]";

		 		CreditosBean creditosBean;
		        if(listaCredito!= null)
		        {
		            Iterator<CreditosBean> it = listaCredito.iterator();
		            while(it.hasNext())
		            {
		            	creditosBean = (CreditosBean)it.next();
		            	resultado += creditosBean.getCreditoID()+separadorCampos+
		            			creditosBean.getClienteID()+separadorCampos+
		            			creditosBean.getDescripcionCredito()+separadorCampos+
		            			creditosBean.getFechaInicio()+separadorCampos+
		            			creditosBean.getMontoCredito()+separadorCampos+
		            			creditosBean.getNombrePromotor()+separadorCampos;
		            				if (creditosBean.getTelefonoInst().isEmpty()){
		            					resultado += "   "+ separadorRegistro;
		            				}else
		            			resultado += creditosBean.getTelefonoInst()+ separadorRegistro;
		            }
		        }
		 		if(resultado.length() !=0){
		 				resultado = resultado.substring(0,resultado.length()-1);
		 		}
		        return resultado;
		    }




		   	// Separador de campos y registros de la lista de Pagos Aplicados WS
				private String transformArray1(List listaPagos)
			    {
			        String resultadoPagos = "";
			        String separadorCampos = "[";
			 		String separadorRegistro = "]";

			 		CreditosBean creditosBean;
			        if(listaPagos!= null)
			        {
			            Iterator<CreditosBean> it = listaPagos.iterator();
			            while(it.hasNext())
			            {
			            	creditosBean = (CreditosBean)it.next();
			            	resultadoPagos += creditosBean.getClienteID()+separadorCampos+
			            			creditosBean.getProducCreditoID()+ separadorCampos +
			            			creditosBean.getCreditoID()+ separadorCampos +
			            			creditosBean.getFechaPago()+ separadorCampos +
			            			creditosBean.getMontoPagar()+ separadorRegistro;
			            }
			        }
			 		if(resultadoPagos.length() !=0){
			 			resultadoPagos = resultadoPagos.substring(0,resultadoPagos.length()-1);
			 		}
			        return resultadoPagos;
			    }

			/*   ************************** LISTA DE METODOS QUE MARCAN ERROR EN QA *******/
				 //Lista de Creditos para Descuentos de Nomina WS
			 	public Object listaDescuentoNominaWS(int tipoLista, ConsultaDescuentosNominaRequest consultaDescuentosNominaRequest){
			 		Object obj= null;
					String cadena = "";
					codigo = "01";
					ConsultaDescuentosNominaResponse respuestaLista = new ConsultaDescuentosNominaResponse();
					List<ConsultaDescuentosNominaResponse> listaDescuentosNomina = creditosDAO.listaDescuentoNominaWS(consultaDescuentosNominaRequest, tipoLista);
					if (listaDescuentosNomina != null ){
						cadena = transformArray(listaDescuentosNomina);
					}
							respuestaLista.setListaDescuentosNomina(cadena);
							respuestaLista.setCodigoRespuesta("0");
							respuestaLista.setMensajeRespuesta("Consulta Exitosa");

							obj=(Object)respuestaLista;
							return obj;
					}

			 // Lista para el Simulador de Creditos WS
			 public Object listaSimuladorWS(SimuladorCreditoRequest simuladorCreditosRequest){
			 	Object obj= null;
			 	String cadena = "";
			 	codigo = "01";
			 	SimuladorCreditoResponse respuestaLista = new SimuladorCreditoResponse();
			 	List<SimuladorCreditoResponse> listaSimuladorCredito = creditosDAO.SimPagCrecientesWS(simuladorCreditosRequest);
			 		 if (listaSimuladorCredito != null ){
			 					cadena = transformListaSimulador(listaSimuladorCredito);
			 				}
			 						respuestaLista.setListaSimuladorCredito(cadena);
			 						respuestaLista.setCodigoRespuesta("0");
			 						respuestaLista.setMensajeRespuesta("Consulta Exitosa");

			 						obj=(Object)respuestaLista;
			 						return obj;
			 	 }

				// Lista de Creditos  WS
				public Object listaCreditosWS(int tipoLista, ListaCreditosBERequest listaCreditosBEResponse){
							Object obj= null;
							String cadena = "";

							ListaCreditosBEResponse respuestaLista = new ListaCreditosBEResponse();
							List<ListaCreditosBEResponse> listaCredito = creditosDAO.listaCreditos(listaCreditosBEResponse, tipoLista);
							if (listaCredito != null ){
								cadena = CreaString(listaCredito);
							}
									respuestaLista.setListaCreditos(cadena);
									respuestaLista.setCodigoRespuesta("0");
									respuestaLista.setMensajeRespuesta("Consulta Exitosa");

									obj=(Object)respuestaLista;
									return obj;
							}

			//	 Lista de Creditos  WS
			   	public Object listaSolCreditosWS(ListaSolicitudCreditoRequest listaSolicitudCreditoRequest){
						Object obj= null;
						String cadena = "";

						ListaSolicitudCreditoResponse respuestaLista = new ListaSolicitudCreditoResponse();
						List<ListaSolicitudCreditoResponse> listaCredito = creditosDAO.listaSolCreditos(listaSolicitudCreditoRequest);
						if (listaCredito != null ){
							cadena = CreaStringSolCre(listaCredito);
						}
								respuestaLista.setListaSolCre(cadena);

								obj=(Object)respuestaLista;
								return obj;
						}
			 // Lista de Pagos Aplicados de Crédito WS
			   	public Object listaPagosAplicadosWS(ConsultaPagosAplicadosRequest consultaPagosAplicadosRequest){
						Object obj= null;
						String cadena = "";
						codigo = "01";
						ConsultaPagosAplicadosResponse respuestaLista = new ConsultaPagosAplicadosResponse();
						List<ConsultaPagosAplicadosResponse> listaPagosAplicados = creditosDAO.pagosAplicados(consultaPagosAplicadosRequest);
						if (listaPagosAplicados != null ){
							cadena = transformArray1(listaPagosAplicados);
						}
								respuestaLista.setListaPagosAplicados(cadena);
								respuestaLista.setCodigoRespuesta("0");
								respuestaLista.setMensajeRespuesta("Consulta Exitosa");

								obj=(Object)respuestaLista;
								return obj;
						}

   	public String descripcionMes(String meses){
		String mes = "";
		int mese = Integer.parseInt(meses);
        switch (mese) {
            case 1:  mes ="ENERO" ; break;
            case 2:  mes ="FEBRERO"; break;
            case 3:  mes ="MARZO"; break;
            case 4:  mes ="ABRIL"; break;
            case 5:  mes ="MAYO"; break;
            case 6:  mes ="JUNIO"; break;
            case 7:  mes ="JULIO"; break;
            case 8:  mes ="AGOSTO"; break;
            case 9:  mes ="SEPTIEMBRE"; break;
            case 10: mes ="OCTUBRE"; break;
            case 11: mes ="NOVIEMBRE"; break;
            case 12: mes ="DICIEMBRE"; break;
        }
        return mes;
	}
	/*#### CREDITOS AGRO ##########################################################################################*/
	public List grabaListaSimPagLibAgro(CreditosBean creditosBean, String montosCapital, String ministraciones) throws Exception {
		List listaCreditos = null;
		List listaCreditosMensaje = (List) new ArrayList();
		MensajeTransaccionBean mensaje = null;
		try {
			ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLibAgro(montosCapital);
			String diaHabil = creditosBean.getFechaInhabil();
			mensaje = creditosDAO.grabaListaSimPagLib(creditosBean, listaSimPagLib, Enum_Sim_PagAmortizaciones.actPagLib, diaHabil);
			listaCreditos = creditosDAO.recalculoSimPagLibresFecCapAGRO(creditosBean, ministraciones);
		} catch (Exception ex) {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion(ex.getMessage());
			}
			ex.printStackTrace();
		}
		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;
	}

	public List grabaListaSimPagLibTasaVarAgro(CreditosBean creditosBean, String montosCapital, String montosMinistraciones) throws Exception {
		List listaCreditos = null;
		List listaCreditosMensaje = (List) new ArrayList();
		MensajeTransaccionBean mensaje = null;
		try {
			ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLibAgro(montosCapital);
			String diaHabil = creditosBean.getFechaInhabil();
			mensaje = creditosDAO.grabaListaSimPagLib(creditosBean, listaSimPagLib, Enum_Sim_PagAmortizaciones.actPagLib, diaHabil);
			listaCreditos = creditosDAO.consultaSimuladorPagosTemporalAgro(creditosBean, Enum_Sim_PagAmortizaciones.tmpPagAmort);
		} catch (Exception ex) {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion(ex.getMessage());
			}
			ex.printStackTrace();
		}
		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;
	}

	public List grabaListaSimPagLibFecCapAgro(CreditosBean creditosBean, String montosCapital, String montosMinistraciones) {
		List listaCreditos = null;
		List listaCreditosMensaje = (List) new ArrayList();
		MensajeTransaccionBean mensaje = null;
		try {
			String diaHabil = "";
			ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLibFecCapAgro(montosCapital);
			diaHabil = creditosBean.getFechaInhabil();
			mensaje = creditosDAO.grabaListaSimPagLib(creditosBean, listaSimPagLib, Enum_Sim_PagAmortizaciones.actPagLibFecCap, diaHabil);
			listaCreditos = creditosDAO.recalculoSimPagLibresFecCapAGRO(creditosBean, montosMinistraciones);
		} catch (Exception ex) {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion(ex.getMessage());
			}
			ex.printStackTrace();
		}
		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;
	}

	public List grabaListaSimPagLibFecCapReestAgro(CreditosBean creditosBean, String montosCapital, String montosMinistraciones) {
		List listaCreditos = null;
		List listaCreditosMensaje = (List) new ArrayList();
		MensajeTransaccionBean mensaje = null;
		try {
			String diaHabil = "";
			ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLibFecCapAgro(montosCapital);
			diaHabil = creditosBean.getFechaInhabil();
			mensaje = creditosDAO.grabaListaSimPagLib(creditosBean, listaSimPagLib, Enum_Sim_PagAmortizaciones.actPagLibFecCap, diaHabil);
			listaCreditos = creditosDAO.recalculoSimPagLibresFecCapReestAGRO(creditosBean, montosMinistraciones);
		} catch (Exception ex) {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion(ex.getMessage());
			}
			ex.printStackTrace();
		}
		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;
	}
	public List grabaListaSimPagLibFecCapTasVarAgro(CreditosBean creditosBean, String montosCapital, String montosMinistraciones) {
		MensajeTransaccionBean mensaje = null;
		List listaCreditosMensaje = (List) new ArrayList();
		List listaCreditos = null;
		try {
			String diaHabil = "";
			ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLibFecCapAgro(montosCapital);
			diaHabil = creditosBean.getFechaInhabil();
			mensaje = creditosDAO.grabaListaSimPagLib(creditosBean, listaSimPagLib, Enum_Sim_PagAmortizaciones.actPagLibFecCap, diaHabil);
			listaCreditos = creditosDAO.consultaSimuladorPagosTemporalAgro(creditosBean, Enum_Sim_PagAmortizaciones.tmpPagAmort);
			listaCreditosMensaje.add(mensaje);
			listaCreditosMensaje.add(listaCreditos);
		} catch (Exception ex) {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion(ex.getMessage());
			}
			ex.printStackTrace();
		}
		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;
	}
	/*#### FIN CREDITOS AGRO ##########################################################################################**/

	public List obtenerListaServiciosAdicionales(CreditosBean creditoBean) {
		List listaServiciosAdicionales = new ArrayList();
			if (!creditoBean.getServiciosAdicionales().isEmpty()) {
			String[] cadena = creditoBean.getServiciosAdicionales().split(",");
			if (cadena.length > 0) {
				for (int i = 0; i < cadena.length; i++) {
					ServiciosSolCredBean serviciosSolCredBean = new ServiciosSolCredBean();
					serviciosSolCredBean.setServicioID(cadena[i]);
					serviciosSolCredBean.setSolicitudCreditoID(creditoBean.getSolicitudCreditoID());
					serviciosSolCredBean.setCreditoID(creditoBean.getCreditoID());
					listaServiciosAdicionales.add(serviciosSolCredBean);
				}
			}
		}
		return listaServiciosAdicionales;
	}

	// Proyeccion de Cuotas Completas
	public CreditosBean proyeccionCuotas(int tipoConsulta, CreditosBean creditosBean) {
		CreditosBean creditos = null;
		switch (tipoConsulta) {
			case Enum_Con_Creditos.principal :
				creditos = creditosDAO.consultaCuotasProyectadas(creditosBean, tipoConsulta);
				break;
		}
		return creditos;
	}

	public List listaReportesRazonNoPago(int tipoLista, RazonesNoPagoBean razonesNoPagoBean, HttpServletResponse response){

		 List listaCreditos=null;

		switch(tipoLista){

			case Enum_Lista_Reporte_RazonNoPago.reporteExcel:
				listaCreditos = creditosDAO.consultaRepRazonNoPagoExcel(razonesNoPagoBean, tipoLista);
				break;
		}

		return listaCreditos;
	}

	public List listaPagosConciliadosMov(PagosConciliadoBean pagosConciliadoBean){

		List listaPagosConciliados = null;

		try {

			if(!pagosConciliadoBean.getConciliado().equals("S")) {
				pagosConciliadoBean.setConciliado("N");
			}

			listaPagosConciliados = creditosDAO.listaCobranzaConciliado(pagosConciliadoBean);
		} catch (Exception e) {
			listaPagosConciliados = new ArrayList<Object>();
			loggerSAFI.info("Ocurrio un error : " + e.getMessage());
		}

		return listaPagosConciliados;
	}

	/**
	 * Metodo que realiza el guardado de los datos conciliados de los pagos.
	 * @param pagosConciliadoBean
	 * @return
	 */
	public MensajeTransaccionBean guardarPagosConciliados(PagosConciliadoBean pagosConciliadoBean){

		MensajeTransaccionBean mensajeTransaccionBean = null;

		try {

			pagosConciliadoBean.setConciliado("S");

			mensajeTransaccionBean = creditosDAO.guardarDatosConciliados(pagosConciliadoBean);

		} catch (Exception e) {
			mensajeTransaccionBean = new MensajeTransaccionBean();
			mensajeTransaccionBean.setNumero(999);
			mensajeTransaccionBean.setDescripcion("Error en la capa servicio : " +e.getMessage());

			loggerSAFI.info("Ocurrio un error : " + e.getMessage());
		}

		return mensajeTransaccionBean;
	}


	/**
	 * Metodo que realiza el consumo del WS de consulta de documentos legales de credito.
	 * @param numDocumento -> {@link Integer}
	 * @param legalDocumentsBean -> {@link LegalDocumentsBean}
	 * @return {@link LegalDocumentsBeanResponse}
	 */
	public DocumentoFirmaBean documentoLegal(LegalDocumentsBean legalDocumentsBean){

		Gson gson =  new Gson();
		LegalDocumentsBeanResponse response = null;

		String urlWS =  "/";
		String autentificacionCodificada = "";

		try{

			ParamGeneralesBean	paramGeneralesBean = new ParamGeneralesBean();

			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Llave.llaveURLWS, paramGeneralesBean);
			urlWS  = paramGeneralesBean.getValorParametro() + "/microfinws/customer/legalDocuments";

			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Llave.llaveHeaderWS, paramGeneralesBean);
			autentificacionCodificada  = paramGeneralesBean.getValorParametro();

			loggerSAFI.info("URL : " + urlWS);
			loggerSAFI.info("Request : " + gson.toJson(legalDocumentsBean));

			ConsumidorRest<LegalDocumentsBeanResponse> consumidorRest =  new ConsumidorRest<LegalDocumentsBeanResponse>();
			consumidorRest.addHeader("Autorizacion", autentificacionCodificada);
			consumidorRest.addHeader("Authorization", autentificacionCodificada);

			response =  consumidorRest.consumePost(urlWS, legalDocumentsBean, LegalDocumentsBeanResponse.class);

			loggerSAFI.info("Respuesta WS : " + gson.toJson(response));

			if(!response.getResponseCode().equals(Constantes.STR_CODIGOEXITO[0])) {
				throw new Exception(response.getResponseMessage());
			}

			DocumentoFirmaBean documentoFirmaBean = new DocumentoFirmaBean();
			documentoFirmaBean.setDocumento(response.getDocument());
			documentoFirmaBean.setCodigoRespuesta(Constantes.STR_CODIGOEXITO[0]);
			documentoFirmaBean.setMensajeRespuesta(Constantes.STR_CODIGOEXITO[1]);

			return documentoFirmaBean;

		}catch(Exception e){
			if(response == null){
				response = new LegalDocumentsBeanResponse();
			}
			response.setResponseCode("404");
			response.setResponseMessage("No fue posible realizar el consumo de WS de consulta de documetos legales." + e.getMessage());


			DocumentoFirmaBean documentoFirmaBean = new DocumentoFirmaBean();
			documentoFirmaBean.setDocumento(response.getDocument());
			documentoFirmaBean.setCodigoRespuesta(Constantes.STR_ERROR[0]);
			documentoFirmaBean.setMensajeRespuesta("Ocurrio un error al generar el reporte : " + e.getMessage());

			return documentoFirmaBean;
		}

	}


	public void setCreditosDAO(CreditosDAO creditosDAO) {
		this.creditosDAO = creditosDAO;
	}
	public CreditosDAO getCreditosDAO() {
		return creditosDAO;
	}
	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}

	public void setOpeEscalamientoInternoServicio(
			OpeEscalamientoInternoServicio opeEscalamientoInternoServicio) {
		this.opeEscalamientoInternoServicio = opeEscalamientoInternoServicio;
	}


	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}


	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public IntegraGruposServicio getIntegraGruposServicio() {
		return integraGruposServicio;
	}

	public void setIntegraGruposServicio(IntegraGruposServicio integraGruposServicio) {
		this.integraGruposServicio = integraGruposServicio;
	}

	public SeguroVidaDAO getSeguroVidaDAO() {
		return seguroVidaDAO;
	}

	public void setSeguroVidaDAO(SeguroVidaDAO seguroVidaDAO) {
		this.seguroVidaDAO = seguroVidaDAO;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}

	public MinistraCredAgroDAO getMinistraCredAgroDAO() {
		return ministraCredAgroDAO;
	}

	public void setMinistraCredAgroDAO(MinistraCredAgroDAO ministraCredAgroDAO) {
		this.ministraCredAgroDAO = ministraCredAgroDAO;
	}

	public CambioFondeadorAgroDAO getCambioFondeadorAgroDAO() {
		return cambioFondeadorAgroDAO;
	}

	public void setCambioFondeadorAgroDAO(
			CambioFondeadorAgroDAO cambioFondeadorAgroDAO) {
		this.cambioFondeadorAgroDAO = cambioFondeadorAgroDAO;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public ServiciosSolCredDAO getServiciosSolCredDAO() {
		return serviciosSolCredDAO;
	}

	public void setServiciosSolCredDAO(ServiciosSolCredDAO serviciosSolCredDAO) {
		this.serviciosSolCredDAO = serviciosSolCredDAO;
	}

	public ReferenciasPagosDAO getReferenciasPagosDAO() {
		return referenciasPagosDAO;
	}

	public void setReferenciasPagosDAO(ReferenciasPagosDAO referenciasPagosDAO) {
		this.referenciasPagosDAO = referenciasPagosDAO;
	}
	
	

}
