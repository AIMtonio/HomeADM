package cuentas.servicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import operacionesPDA.beanWS.request.SP_PDA_Ahorros_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_DescargaResponse;
import operacionesPDA.beanWS.response.SP_PDA_Cuentas_DescargaResponse;
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.servicio.CorreoServicio;
import tesoreria.bean.DepositosRefeBean;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;
import cuentas.bean.AnaliticoAhorroBean;
import cuentas.bean.BloqueoCuentaBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.bean.CuentasPersonaBean;
import cuentas.bean.DesbloqueoMasCtaBean;
import cuentas.bean.IDEMensualBean;
import cuentas.bean.RepSaldosGlobalesBean;
import cuentas.bean.TasasAhorroBean;
import cuentas.beanWS.request.ConsultaCuentasPorClienteRequest;
import cuentas.beanWS.request.ConsultaDisponiblePorClienteRequest;
import cuentas.beanWS.request.ListaCtaClienteRequest;
import cuentas.beanWS.request.ListaCuentaAhoRequest;
import cuentas.beanWS.response.ConsultaCuentasPorClienteResponse;
import cuentas.beanWS.response.ConsultaDisponiblePorClienteResponse;
import cuentas.beanWS.response.ListaCtaClienteResponse;
import cuentas.beanWS.response.ListaCuentaAhoResponse;
import cuentas.dao.CuentasAhoDAO;

public class CuentasAhoServicio extends BaseServicio {

	private CuentasAhoServicio(){
		super();
	}

	CuentasAhoDAO cuentasAhoDAO = null;
	CorreoServicio correoServicio = null;
	CuentasPersonaServicio cuentasPersonaServicio = null;
	TasasAhorroServicio tasasAhorroServicio = null;
	ClienteServicio clienteServicio=null;
	String codigo= "";
	
	public static interface Enum_Tra_CuentasAho {
		int alta 			= 1;
		int modificacion 	= 2;
		int actualizacion 	= 3;
		int bloqueoCuenta 	= 4;
		int desbloqueoCta	= 5;
		int transferencia 	= 6;
		int altaWS 			= 7;

	}
	
	public static interface Enum_Act_CuentasAho {
		int apertura 		= 1;
		int bloqueo 		= 2;
		int desbloqueo 		= 3;
		int cancelacion 	= 4;
	}

	public static interface Enum_Con_CuentasAho{
		int principal 		= 1;
		int foranea 		= 2;
		int pantRegistro 	= 3;
		int campos 			= 4;
		int saldoDisp		= 5;
		int saldos			= 6;		
		int firmantes		= 7;	//Para Reporte de Firmas
		int reporteCuenta	= 8;	//Para el Reporte de la Caratula de la Cuenta
		int saldosYEstatus	= 9;
		int ctaCteWS		= 10;
		int saldoDisCte		= 11; // para el saldo disponible por cliente
		int saldoDispHis	= 12;
		int saldosHis		= 13;
		int ctaPrincipal	= 14;
		int ctaPrinAct		= 15;
		int ctaGLAdici		= 16; // para consultar la cuenta de GL adicional
		int ctaBloqueo 		= 17; // para consultar y bloquear cta BLoqueo Masivo
		int ctasDesbloq		= 18; // para consultar cuentas a desbloquear
		int saldoDispWS		= 19; // consultar saldo disponible WS
		int cuentaAhoWS     = 20;
		int saldosWS    	= 21;
		int saldosHisWS    	= 22;
		int ctasAsociaTar	= 23;
		int ctaBeneficiario = 24; // Consulta una cuenta principal con beneficiario para validacion en ventanilla cobro seguro ayuda
		int depCuentasVal  	= 27;//validaciones para deposito referenciados de cuentas
		int depCuentasValDR = 29;
		int ctaCteActPade   = 30;//consulta de cuentas para el alta de pademobile
		int cuentasCte		= 31;// Consulta las cuentas de los clientes pero no muestra las cuentas institucionales
		int cuentasProdAut	= 32; // Consulta las cuentas del cliente, incluyendo su tasa de rendimiento.
		int saldoCargoCta	= 33; // Consulta de saldos para la pantalla de pago de creditocon cargo a cta
		int saldoCreditosFogafi	= 34; // Consulta de saldos para la pantalla de pago de creditocon cargo a cta
		int banCuentaAho	= 35;// Consulta las cuentas de los clientes pero no muestra las cuentas institucionales
		int ctaAhoDepositoActiva= 36; // Consulta de cuenta de ahorro para deposito de activacion
	}
	
	public static interface Enum_Lis_CuenRep{
		int AnaliticoAhorro =1;       //reporte de  analitico ahorro
	}
	
	public static interface Enum_Lis_SaldosGlobalesRep{
		int saldosGlobales = 1;		// Reporte Saldos Globales
	}
	
	public static interface Enum_Con_CuentasAhoHis{
	}

	public static interface Enum_Lis_CuentasAho{
		int principal 			= 1;
		int numCte				= 2;
		int ctaCte				= 3;
		int resumCte			= 4;
		int beneficiario		= 6; //valor 6 porque es el valor de la lista de beneficiarios en el stored
		int anexoApoder			= 7; // lista de apoderados para el anexo de la portada del contrato de cta
		int clabeCliente    	= 5;
		int resumCteActivas	 	= 8;
		int ctasCteTodas		= 9;
		int ctasAsociaTarjetas	= 12;	//lista para pantalla de Asociacion de Tarjetas
		int ingOperaciones		= 13;
		int tipCta				= 14; //Lista que filtra por cte y Tipo de Cta
		int ingOperacionesSuc	= 15; // Lista 13
		int ingOperacionesVen	= 16;
		int AplicacionDocSBC	= 17; //Lista para pantalla de Aplicacion de Documento SBC en ventanilla
		int ctasCliente			= 19; // Lista las cuentas de los Clientes pero no incluye las cuentas institucionales
		int ctasActivaCte		= 20; // Lista de las cuentas activas de un cliente 
		int cuentaGuardaValores = 21;
		int cuentasCliente 		= 22;
		int comPendienteSalProm = 23;
		int ceuntasActivas		= 24;
		int ctasDepositoActiva	= 25;
	}
	
	public static interface Enum_Lis_CtaCreGrupoNoSol{
		int cuentasws =1;      
	}
	
	public static interface Enum_Lis_CuentasAhorroWS{
		int ahorroCuentas =1;      
	}
	
	public static interface Enum_Rep_Cuentas{ // Reporte IDE MENSUAL
		int excelRep = 1;
	}
	

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, CuentasAhoBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_CuentasAho.alta:
			mensaje = altaCuentasAho(cuentasAho);
			break;
		case Enum_Tra_CuentasAho.altaWS:
			mensaje = altaCuentasAhoWS(cuentasAho);
			break;
		case Enum_Tra_CuentasAho.modificacion:
			mensaje = modificaCuentasAho(cuentasAho);
			break;
		case Enum_Tra_CuentasAho.actualizacion:
			mensaje = actualizaCuentasAho(cuentasAho,tipoActualizacion);
			break;
		case Enum_Tra_CuentasAho.transferencia:
			mensaje = beTransferencia(cuentasAho);
			break;
		}

		return mensaje;
	}

	// ----------------------------------
	public MensajeTransaccionBean grabaTransaccionBloqueoDebloqueo(	int tipoTransaccion) {		
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_CuentasAho.bloqueoCuenta:			
			mensaje = bloqueoCuentaMasivo();
			break;
		}

		return mensaje;
	}
	public MensajeTransaccionBean grabaTransaccionDesbloqueoCuenta(int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_CuentasAho.desbloqueoCta :
			mensaje = desbloqueoCuentaMas();
			break;
		}

		return mensaje;
	}

	public BloqueoCuentaBean consultaCuentasBloq(int tipoConsulta,
			BloqueoCuentaBean cuentasBloqueo) {
		BloqueoCuentaBean cuentasAhorro = null;
		switch (tipoConsulta) {

		case Enum_Con_CuentasAho.ctaBloqueo:
			cuentasAhorro = cuentasAhoDAO.consultaCtaBloqueMasivo(
					cuentasBloqueo, Enum_Con_CuentasAho.ctaBloqueo);
			break;
		}
		return cuentasAhorro;
	}
	
	public DesbloqueoMasCtaBean consultaCuentasDesbloq(int tipoConsulta,
			DesbloqueoMasCtaBean desbloqueoCuentas) {
		DesbloqueoMasCtaBean cuentasAhorro = null;
		switch (tipoConsulta) {

		case Enum_Con_CuentasAho.ctasDesbloq:
			cuentasAhorro = cuentasAhoDAO.consultaDesbloqueoMasivoCuentas(
					desbloqueoCuentas, Enum_Con_CuentasAho.ctasDesbloq);
			break;
		}
		return cuentasAhorro;
	}
	// --------------------------------------
	// -- ---------------
		public MensajeTransaccionBean bloqueoCuentaMasivo() {
			MensajeTransaccionBean mensaje = null;
			mensaje = cuentasAhoDAO.bloqueoCuentaMasivo();
			return mensaje;
		}

		// -----------
	
		public MensajeTransaccionBean desbloqueoCuentaMas(){
			MensajeTransaccionBean mensaje = null;
			mensaje = cuentasAhoDAO.desbloqueoCuentaMas();		
			return mensaje;
		}	

	  
	
	public MensajeTransaccionBean altaCuentasAho(CuentasAhoBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasAhoDAO.altaCuentasAho(cuentasAho);		
		return mensaje;
	}
	public MensajeTransaccionBean altaCuentasAhoWS(CuentasAhoBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasAhoDAO.altaCuentasAhoWS(cuentasAho);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaCuentasAho(CuentasAhoBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasAhoDAO.modificaCuentasAho(cuentasAho);		
		return mensaje;
	}	
	
	public MensajeTransaccionBean beTransferencia(CuentasAhoBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasAhoDAO.transferenciaBE(cuentasAho);		
		return mensaje;
	}
	
	
	public MensajeTransaccionBean actualizaCuentasAho(CuentasAhoBean cuentasAho,int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){

		case Enum_Act_CuentasAho.apertura:
			mensaje = cuentasAhoDAO.aperturaCtaAhoDepositoActivaCta(cuentasAho, tipoActualizacion);	
		break;
		case Enum_Act_CuentasAho.bloqueo:
			mensaje = cuentasAhoDAO.bloqueoCtaAho(cuentasAho, tipoActualizacion);	
		break;
		case Enum_Act_CuentasAho.desbloqueo:
			mensaje = cuentasAhoDAO.desbloqueoCtaAho(cuentasAho, tipoActualizacion);	
		break;
		case Enum_Act_CuentasAho.cancelacion:
			mensaje = cuentasAhoDAO.cancelacionCtaAho(cuentasAho, tipoActualizacion);	
		break;
		}
		return mensaje;
	}	

	public CuentasAhoBean consultaCuentasAho(int tipoConsulta, CuentasAhoBean cuentasAho){
		CuentasAhoBean cuentasAhorro = null;
		switch(tipoConsulta){ //lorena 
			case Enum_Con_CuentasAho.principal:
				cuentasAhorro = cuentasAhoDAO.consultaPrincipal(cuentasAho, Enum_Con_CuentasAho.principal);
			break;
			case Enum_Con_CuentasAho.foranea:
				cuentasAhorro = cuentasAhoDAO.consultaForanea(cuentasAho, Enum_Con_CuentasAho.foranea);
			break;
			case Enum_Con_CuentasAho.pantRegistro: 
		 		cuentasAhorro = cuentasAhoDAO.consultaPantallaRegistro(cuentasAho, Enum_Con_CuentasAho.pantRegistro);
			break;
			case Enum_Con_CuentasAho.campos: 
				cuentasAhorro = cuentasAhoDAO.consultaCampos(cuentasAho, Enum_Con_CuentasAho.campos);
			break;
			case Enum_Con_CuentasAho.saldoDisp: 
				cuentasAhorro = cuentasAhoDAO.consultaSaldoDisponible(cuentasAho, Enum_Con_CuentasAho.saldoDisp);
			break;
			case Enum_Con_CuentasAho.saldos: 
				cuentasAhorro = cuentasAhoDAO.consultaSaldos(cuentasAho, Enum_Con_CuentasAho.saldos);
			break;
			case Enum_Con_CuentasAho.saldoDispHis: 
				cuentasAhorro = cuentasAhoDAO.consultaSaldoDisponibleHistorico(cuentasAho, Enum_Con_CuentasAho.saldoDispHis);
			break;
			case Enum_Con_CuentasAho.saldosHis: 
				cuentasAhorro = cuentasAhoDAO.consultaSaldosHistorico(cuentasAho, Enum_Con_CuentasAho.saldosHis);
			break;
			case Enum_Con_CuentasAho.ctaPrincipal: 
				cuentasAhorro = cuentasAhoDAO.consultaCuentaPrincipal(cuentasAho, Enum_Con_CuentasAho.ctaPrincipal);
			break;
			case Enum_Con_CuentasAho.ctaPrinAct:
				cuentasAhorro = cuentasAhoDAO.consultaCuentaPrincipalActiva(cuentasAho, Enum_Con_CuentasAho.ctaPrinAct);
			break;
			case Enum_Con_CuentasAho.saldosYEstatus:
				cuentasAhorro = cuentasAhoDAO.consultaSaldoYEstatus(cuentasAho, Enum_Con_CuentasAho.saldosYEstatus);
			break;
			case Enum_Con_CuentasAho.ctaGLAdici:
				cuentasAhorro = cuentasAhoDAO.consultaCtaGLAdicional(cuentasAho, Enum_Con_CuentasAho.ctaGLAdici);
			break;
			case Enum_Con_CuentasAho.saldoDispWS:
				cuentasAhorro = cuentasAhoDAO.consultaSaldoCta(cuentasAho, Enum_Con_CuentasAho.saldoDispWS);
			break;
			case Enum_Con_CuentasAho.cuentaAhoWS:
				cuentasAhorro = cuentasAhoDAO.consultaCuentaWS(cuentasAho, Enum_Con_CuentasAho.cuentaAhoWS);
			break;
			case Enum_Con_CuentasAho.saldosWS:
				cuentasAhorro = cuentasAhoDAO.consultaSaldosWS(cuentasAho, Enum_Con_CuentasAho.saldosWS);
			break;
			case Enum_Con_CuentasAho.saldosHisWS:
				cuentasAhorro = cuentasAhoDAO.consultaSaldosHisWS(cuentasAho, Enum_Con_CuentasAho.saldosHisWS);
			break;
			case Enum_Con_CuentasAho.ctasAsociaTar:
				cuentasAhorro = cuentasAhoDAO.consultaCtasAsocia(cuentasAho, Enum_Con_CuentasAho.ctasAsociaTar);
			break;
			case Enum_Con_CuentasAho.ctaBeneficiario:
				cuentasAhorro = cuentasAhoDAO.consultaCtaBeneficiario(cuentasAho, Enum_Con_CuentasAho.ctaBeneficiario);
			break;
			case Enum_Con_CuentasAho.ctaCteActPade:
				cuentasAhorro = cuentasAhoDAO.consultaCtaCteAct(cuentasAho, Enum_Con_CuentasAho.ctaCteActPade);
			break;	
			case Enum_Con_CuentasAho.cuentasCte: 
				cuentasAhorro = cuentasAhoDAO.consultaCampos(cuentasAho, Enum_Con_CuentasAho.cuentasCte);
			break;
			case Enum_Con_CuentasAho.cuentasProdAut: 
				cuentasAhorro = cuentasAhoDAO.cuentasProdAut(cuentasAho, Enum_Con_CuentasAho.cuentasProdAut);
			break;
			case Enum_Con_CuentasAho.saldoCargoCta: 
				cuentasAhorro = cuentasAhoDAO.consultaSaldoDisponible(cuentasAho, Enum_Con_CuentasAho.saldoCargoCta);
			break;
			case Enum_Con_CuentasAho.banCuentaAho: 
				cuentasAhorro = cuentasAhoDAO.banCuentasAho(cuentasAho, Enum_Con_CuentasAho.banCuentaAho);
			break;
			case Enum_Con_CuentasAho.saldoCreditosFogafi: 
				cuentasAhorro = cuentasAhoDAO.saldoCreditosFogafi(cuentasAho, Enum_Con_CuentasAho.saldoCreditosFogafi);
			break;
			case Enum_Con_CuentasAho.ctaAhoDepositoActiva: 
				cuentasAhorro = cuentasAhoDAO.ctaAhoDepositoActiva(cuentasAho, Enum_Con_CuentasAho.ctaAhoDepositoActiva);
			break;
		}
		return cuentasAhorro;
	}

	public DepositosRefeBean validaCtaDepRefe(DepositosRefeBean refeBean){
		DepositosRefeBean depRefe = new DepositosRefeBean();
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasAhoDAO.depCuentasValDR(refeBean);		
		depRefe.setNumError(String.valueOf(mensaje.getNumero()));
		depRefe.setDescError(mensaje.getDescripcion());		
		return depRefe;
	}
	public List lista(int tipoLista, CuentasAhoBean cuentasAho){
		List cuentasAhoLista = null;
		switch (tipoLista) {
			case  Enum_Lis_CuentasAho.ctaCte:
				cuentasAhoLista = cuentasAhoDAO.listaCtasCliente(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.numCte:
				cuentasAhoLista = cuentasAhoDAO.listaNumCliente(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.resumCte:
				cuentasAhoLista = cuentasAhoDAO.listaResumenCte(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.clabeCliente:
				cuentasAhoLista = cuentasAhoDAO.listaClabeCliente(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.resumCteActivas:
				cuentasAhoLista = cuentasAhoDAO.listaResumenCte(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.ctasCteTodas:
				cuentasAhoLista = cuentasAhoDAO.listaCtasClienteTodas(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.ctasAsociaTarjetas:
				cuentasAhoLista = cuentasAhoDAO.listaCtasAsocia(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.ingOperaciones:
				cuentasAhoLista = cuentasAhoDAO.listaIngresOperaciones(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.tipCta:
				cuentasAhoLista = cuentasAhoDAO.listaTipCta(cuentasAho, tipoLista);
	        break;
	        
	        case  Enum_Lis_CuentasAho.ingOperacionesSuc:
				cuentasAhoLista = cuentasAhoDAO.listaIngresOperaciones(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.ingOperacionesVen:
				cuentasAhoLista = cuentasAhoDAO.listaIngresOperaciones(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.AplicacionDocSBC:
				cuentasAhoLista = cuentasAhoDAO.listaIngresOperaciones(cuentasAho, tipoLista);
	        break;
	        case  Enum_Lis_CuentasAho.ctasCliente:
				cuentasAhoLista = cuentasAhoDAO.listaTipCta(cuentasAho, tipoLista);
	        break;	 
	        case  Enum_Lis_CuentasAho.ctasActivaCte:
				cuentasAhoLista = cuentasAhoDAO.listaCtasActivasCliente(cuentasAho, tipoLista);
	        break;
	        case Enum_Lis_CuentasAho.cuentaGuardaValores:
				cuentasAhoLista = cuentasAhoDAO.listaGuardaValores(cuentasAho, tipoLista);
	        break;	        
	        case Enum_Lis_CuentasAho.comPendienteSalProm:
				cuentasAhoLista = cuentasAhoDAO.listaComisionesPendientesPag(cuentasAho, tipoLista);
	        break;	        
	        case  Enum_Lis_CuentasAho.ceuntasActivas:
		 		cuentasAhoLista = cuentasAhoDAO.listaCtasActivas(cuentasAho, tipoLista);
		    break;
	        case Enum_Lis_CuentasAho.ctasDepositoActiva:
				cuentasAhoLista = cuentasAhoDAO.listaCtasDepositoActiva(cuentasAho, tipoLista);
	        break;
	        
		}
		return cuentasAhoLista;
	}
	
	// Seccion de Reportes
	
	//Reporte de Cuentas por Cliente
	public String reporteCuentasCliente(ClienteBean clienteBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Cliente", clienteBean.getNumero());
		parametrosReporte.agregaParametro("Par_NombreCliente", clienteBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_NomEmpresa", clienteBean.getSucursalOrigen());
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//Reporte de Cuentas por Cliente PDF
	public ByteArrayOutputStream reporteCuentasClientePDF(ClienteBean clienteBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Cliente", clienteBean.getNumero());
		parametrosReporte.agregaParametro("Par_NombreCliente", clienteBean.getNombreCompleto());	
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//Reporte IDE Mensual Excel
	public List listaIDEMensual(int tipoLista,IDEMensualBean IDEMensualBean){		
		List listaIDE = null;
		switch(tipoLista){
		case Enum_Rep_Cuentas.excelRep:
			listaIDE = cuentasAhoDAO.reporteIDEMensual(tipoLista,IDEMensualBean);
			break;
		}

		return listaIDE;
	}

	// reporte portada contrato de cuenta persona Fisica
	public String reportePortadaContratoCtaPF(CuentasPersonaBean cuentasPersona, String nombreReportePF) throws Exception{
		List  listaBeneficiarios = null;
		List  listaTasasAho = null;
		CuentasPersonaBean personBean ;
		TasasAhorroBean	tasasAhoBean;
		listaBeneficiarios = cuentasPersonaServicio.lista(Enum_Lis_CuentasAho.beneficiario,cuentasPersona);
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		for(int i=0; i<listaBeneficiarios.size(); i++){
			personBean = (CuentasPersonaBean)listaBeneficiarios.get(i);
			if(i==4){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_Nomb_Benefic" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_Porcentaje" +i, personBean.getPorcentaje());
			parametrosReporte.agregaParametro("Par_Parentesco" +i, personBean.getParentescoID());
														
		}
										   
		parametrosReporte.agregaParametro("Par_CuentaAhoID", cuentasPersona.getCuentaAhoID());
	
		
		CuentasAhoBean ctasAhoID = new CuentasAhoBean();
		CuentasAhoBean ctasAho = new CuentasAhoBean();
		ClienteBean cteID = new ClienteBean();
		ClienteBean cteBean =new ClienteBean();
		TasasAhorroBean tasasCta = new TasasAhorroBean();
		String cta=  cuentasPersona.getCuentaAhoID();
		ctasAho.setCuentaAhoID(cta);
		ctasAhoID = consultaCuentasAho(Enum_Con_CuentasAho.pantRegistro,ctasAho);
		String tipoCta = ctasAhoID.getTipoCuentaID();
		String monedaID = ctasAhoID.getMonedaID();
		cteID.setNumero(ctasAhoID.getClienteID());
		cteBean = clienteServicio.consulta(Enum_Lis_CuentasAho.principal,ctasAhoID.getClienteID(),"");
		
		parametrosReporte.agregaParametro("Par_ClienteID",ctasAhoID.getClienteID());
		parametrosReporte.agregaParametro("Par_NomCte",cteBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_FechaNac",cteBean.getFechaNacimiento());
		parametrosReporte.agregaParametro("Par_RFC",cteBean.getRFC());
		parametrosReporte.agregaParametro("Par_TipoPersona",cteBean.getTipoPersona());
		parametrosReporte.agregaParametro("Par_EdoCta",ctasAhoID.getEstadoCta());	
		
		String tipoPerson = cteBean.getTipoPersona();
		tasasCta.setTipoCuentaID(tipoCta);
		tasasCta.setMonedaID(monedaID);
		tasasCta.setTipoPersona(tipoPerson);
		listaTasasAho = tasasAhorroServicio.lista(Enum_Lis_CuentasAho.ctaCte,tasasCta);
		
		for(int i=0; i<listaTasasAho.size(); i++){
			tasasAhoBean = (TasasAhorroBean)listaTasasAho.get(i);
			/*if(i==4){
				break;
			}*/
			parametrosReporte.agregaParametro("Par_Tasa" +i, tasasAhoBean.getTasa());
			parametrosReporte.agregaParametro("Par_MontoInf" +i, tasasAhoBean.getMontoInferior());
			parametrosReporte.agregaParametro("Par_MontoSup" +i, tasasAhoBean.getMontoSuperior());
														
		}
		
		return Reporte.creaHtmlReporte(nombreReportePF, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// reporte portada contrato de cuenta persona Moral
	public String reportePortadaContratoCtaPM(CuentasPersonaBean cuentasPersona, String nombreReportePF) throws Exception{
		List  listaBeneficiarios = null;
		List  listaTasasAho = null;
		CuentasPersonaBean personBean ;
		TasasAhorroBean	tasasAhoBean;
		listaBeneficiarios = cuentasPersonaServicio.lista(Enum_Lis_CuentasAho.beneficiario,cuentasPersona);
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		for(int i=0; i<listaBeneficiarios.size(); i++){
			personBean = (CuentasPersonaBean)listaBeneficiarios.get(i);
			if(i==4){
				break;
			}
			parametrosReporte.agregaParametro("Par_Nomb_Benefic" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_Porcentaje" +i, personBean.getPorcentaje());
			parametrosReporte.agregaParametro("Par_Parentesco" +i, personBean.getParentescoID());
														
		}
		
		parametrosReporte.agregaParametro("Par_CuentaAhoID", cuentasPersona.getCuentaAhoID());
	
		CuentasAhoBean ctasAhoID = new CuentasAhoBean();
		CuentasAhoBean ctasAho = new CuentasAhoBean();
		ClienteBean cteID = new ClienteBean();
		ClienteBean cteBean =new ClienteBean();
		TasasAhorroBean tasasCta = new TasasAhorroBean();
		String cta=  cuentasPersona.getCuentaAhoID();
		ctasAho.setCuentaAhoID(cta);
		ctasAhoID = consultaCuentasAho(Enum_Con_CuentasAho.pantRegistro,ctasAho);
		String tipoCta = ctasAhoID.getTipoCuentaID();
		String monedaID = ctasAhoID.getMonedaID();
		cteID.setNumero(ctasAhoID.getClienteID());
		cteBean = clienteServicio.consulta(Enum_Lis_CuentasAho.principal,ctasAhoID.getClienteID(),"");
		
		parametrosReporte.agregaParametro("Par_ClienteID",ctasAhoID.getClienteID());
		parametrosReporte.agregaParametro("Par_EdoCta",ctasAhoID.getEstadoCta());	
		parametrosReporte.agregaParametro("Par_NomCte",cteBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_FechaNac",cteBean.getFechaNacimiento());
		parametrosReporte.agregaParametro("Par_RFC",cteBean.getRFCpm());
		parametrosReporte.agregaParametro("Par_TipoPersona",cteBean.getTipoPersona());
		
		String tipoPerson = cteBean.getTipoPersona();
		tasasCta.setTipoCuentaID(tipoCta);
		tasasCta.setMonedaID(monedaID);
		tasasCta.setTipoPersona(tipoPerson);
		listaTasasAho = tasasAhorroServicio.lista(Enum_Lis_CuentasAho.ctaCte,tasasCta);
		
		for(int i=0; i<listaTasasAho.size(); i++){
			tasasAhoBean = (TasasAhorroBean)listaTasasAho.get(i);
			if(i==4){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_Tasa" +i, tasasAhoBean.getTasa());
			parametrosReporte.agregaParametro("Par_MontoInf" +i, tasasAhoBean.getMontoInferior());
			parametrosReporte.agregaParametro("Par_MontoSup" +i, tasasAhoBean.getMontoSuperior());
														
		}
		return Reporte.creaHtmlReporte(nombreReportePF, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	
	/*REPORTE DE PORTADA DE CONTRADO EN PDF*/
	public ByteArrayOutputStream reportePortadaContratoCtaPFPDF(CuentasPersonaBean cuentasPersona, String nombreReportePF) throws Exception{
		List  listaBeneficiarios = null;
		List  listaTasasAho = null;
		CuentasPersonaBean personBean ;
		TasasAhorroBean	tasasAhoBean;
		listaBeneficiarios = cuentasPersonaServicio.lista(Enum_Lis_CuentasAho.beneficiario,cuentasPersona);
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		for(int i=0; i<listaBeneficiarios.size(); i++){
			personBean = (CuentasPersonaBean)listaBeneficiarios.get(i);
			/*if(i==4){
				break;
			}*/
			
			parametrosReporte.agregaParametro("Par_Nomb_Benefic" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_Porcentaje" +i, personBean.getPorcentaje());
			parametrosReporte.agregaParametro("Par_Parentesco" +i, personBean.getDescripParentesco());
														
		}
		
		parametrosReporte.agregaParametro("Par_CuentaAhoID", cuentasPersona.getCuentaAhoID());
		parametrosReporte.agregaParametro("Par_NomInstitucion",(cuentasPersona.getNombreInstitucion()));
		parametrosReporte.agregaParametro("Par_DirecInstit",cuentasPersona.getDirInst());
		parametrosReporte.agregaParametro("Par_RFCInt",cuentasPersona.getRFCInst());
		parametrosReporte.agregaParametro("Par_TelInst",cuentasPersona.getTelInst());
		parametrosReporte.agregaParametro("Par_RepresentanteLegal",cuentasPersona.getRepresentanteLegal());
		parametrosReporte.agregaParametro("Par_FechaEmision",(cuentasPersona.getFechaEmision()));
		parametrosReporte.agregaParametro("Par_SucursalID",(cuentasPersona.getSucursalID()));
		parametrosReporte.agregaParametro("Par_NombreSucursal",(cuentasPersona.getNombreSucursal()));

		
		CuentasAhoBean ctasAhoID = new CuentasAhoBean();
		CuentasAhoBean ctasAho = new CuentasAhoBean();
		ClienteBean cteID = new ClienteBean();
		ClienteBean cteBean =new ClienteBean();
		TasasAhorroBean tasasCta = new TasasAhorroBean();
		String cta=  cuentasPersona.getCuentaAhoID();
		ctasAho.setCuentaAhoID(cta);
		ctasAhoID = consultaCuentasAho(Enum_Con_CuentasAho.pantRegistro,ctasAho);
		String tipoCta = ctasAhoID.getTipoCuentaID();
		String monedaID = ctasAhoID.getMonedaID();
		cteID.setNumero(ctasAhoID.getClienteID());
		cteBean = clienteServicio.consulta(Enum_Lis_CuentasAho.principal,ctasAhoID.getClienteID(),"");
		
		parametrosReporte.agregaParametro("Par_ClienteID",ctasAhoID.getClienteID());
		parametrosReporte.agregaParametro("Par_NomCte",cteBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_FechaNac",cteBean.getFechaNacimiento());
		parametrosReporte.agregaParametro("Par_RFC",cteBean.getRFC());
		parametrosReporte.agregaParametro("Par_TipoPersona",cteBean.getTipoPersona());
		parametrosReporte.agregaParametro("Par_EdoCta",ctasAhoID.getEstadoCta());	
		
		String tipoPerson = cteBean.getTipoPersona();
		tasasCta.setTipoCuentaID(tipoCta);
		tasasCta.setMonedaID(monedaID);
		tasasCta.setTipoPersona(tipoPerson);
		listaTasasAho = tasasAhorroServicio.lista(Enum_Lis_CuentasAho.ctaCte,tasasCta);
		
		for(int i=0; i<listaTasasAho.size(); i++){
			tasasAhoBean = (TasasAhorroBean)listaTasasAho.get(i);
			/*if(i==4){
				break;
			}*/
		
			parametrosReporte.agregaParametro("Par_Tasa" +i, tasasAhoBean.getTasa());
			parametrosReporte.agregaParametro("Par_MontoInf" +i, tasasAhoBean.getMontoInferior());
			parametrosReporte.agregaParametro("Par_MontoSup" +i, tasasAhoBean.getMontoSuperior());
			
		}
		parametrosReporte.agregaParametro("Par_TipoCtaAhoID", tasasCta.getTipoCuentaID());	
		return Reporte.creaPDFReporte(nombreReportePF, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//REPORTE DE CARÃTULA DEL CONTRATO DE DEPÃSITO DE AHORRO DE MENORES
	public ByteArrayOutputStream reportePortadaContratoCtaPFMENORPDF(CuentasPersonaBean cuentasPersona, String nombreReportePF) throws Exception{	
		List  listaBeneficiarios = null;
		List  listaTasasAho = null;
		CuentasPersonaBean personBean ;
		TasasAhorroBean	tasasAhoBean;
		listaBeneficiarios = cuentasPersonaServicio.lista(Enum_Lis_CuentasAho.beneficiario,cuentasPersona);
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		for(int i=0; i<listaBeneficiarios.size(); i++){
			personBean = (CuentasPersonaBean)listaBeneficiarios.get(i);
			/*if(i==4){
				break;
			}*/
			
			parametrosReporte.agregaParametro("Par_Nomb_Benefic" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_Porcentaje" +i, personBean.getPorcentaje());
			parametrosReporte.agregaParametro("Par_Parentesco" +i, personBean.getDescripParentesco());
														
		}
		
		parametrosReporte.agregaParametro("Par_CuentaAhoID", cuentasPersona.getCuentaAhoID());
		parametrosReporte.agregaParametro("Par_NomInstitucion",(cuentasPersona.getNombreInstitucion()));
		
		CuentasAhoBean ctasAhoID = new CuentasAhoBean();
		CuentasAhoBean ctasAho = new CuentasAhoBean();
		ClienteBean cteID = new ClienteBean();
		ClienteBean cteBean =new ClienteBean();
		TasasAhorroBean tasasCta = new TasasAhorroBean();
		String cta=  cuentasPersona.getCuentaAhoID();
		ctasAho.setCuentaAhoID(cta);
		ctasAhoID = consultaCuentasAho(Enum_Con_CuentasAho.pantRegistro,ctasAho);
		String tipoCta = ctasAhoID.getTipoCuentaID();
		String monedaID = ctasAhoID.getMonedaID();
		cteID.setNumero(ctasAhoID.getClienteID());
		cteBean = clienteServicio.consulta(Enum_Lis_CuentasAho.principal,ctasAhoID.getClienteID(),"");
		
		parametrosReporte.agregaParametro("Par_ClienteID",ctasAhoID.getClienteID());
		parametrosReporte.agregaParametro("Par_NomCte",cteBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_FechaNac",cteBean.getFechaNacimiento());
		parametrosReporte.agregaParametro("Par_RFC",cteBean.getRFC());
		parametrosReporte.agregaParametro("Par_TipoPersona",cteBean.getTipoPersona());
		parametrosReporte.agregaParametro("Par_EdoCta",ctasAhoID.getEstadoCta());	
		
		String tipoPerson = cteBean.getTipoPersona();
		tasasCta.setTipoCuentaID(tipoCta);
		tasasCta.setMonedaID(monedaID);
		tasasCta.setTipoPersona(tipoPerson);
		listaTasasAho = tasasAhorroServicio.lista(Enum_Lis_CuentasAho.ctaCte,tasasCta);
		
		for(int i=0; i<listaTasasAho.size(); i++){
			tasasAhoBean = (TasasAhorroBean)listaTasasAho.get(i);
			/*if(i==4){
				break;
			}*/
		
			parametrosReporte.agregaParametro("Par_Tasa" +i, tasasAhoBean.getTasa());
			parametrosReporte.agregaParametro("Par_MontoInf" +i, tasasAhoBean.getMontoInferior());
			parametrosReporte.agregaParametro("Par_MontoSup" +i, tasasAhoBean.getMontoSuperior());
			
		}
		parametrosReporte.agregaParametro("Par_TipoCtaAhoID", tasasCta.getTipoCuentaID());
		parametrosReporte.agregaParametro("Par_SucursalID",(cuentasPersona.getSucursalID()));
		return Reporte.creaPDFReporte(nombreReportePF, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}///////////////////////////////////
	
	
	public ByteArrayOutputStream reportePortadaContratoCtaPMPDF(CuentasPersonaBean cuentasPersona, String nombreReportePF) throws Exception{
		List  listaBeneficiarios = null;
		List  listaTasasAho = null;
		CuentasPersonaBean personBean ;
		TasasAhorroBean	tasasAhoBean;
		listaBeneficiarios = cuentasPersonaServicio.lista(Enum_Lis_CuentasAho.beneficiario,cuentasPersona);
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		for(int i=0; i<listaBeneficiarios.size(); i++){
			personBean = (CuentasPersonaBean)listaBeneficiarios.get(i);
			if(i==4){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_Nomb_Benefic" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_Porcentaje" +i, personBean.getPorcentaje());
			parametrosReporte.agregaParametro("Par_Parentesco" +i, personBean.getDescripParentesco());
			
		}
		
		parametrosReporte.agregaParametro("Par_CuentaAhoID", cuentasPersona.getCuentaAhoID());
		
		CuentasAhoBean ctasAhoID = new CuentasAhoBean();
		CuentasAhoBean ctasAho = new CuentasAhoBean();
		ClienteBean cteID = new ClienteBean();
		ClienteBean cteBean =new ClienteBean();
		TasasAhorroBean tasasCta = new TasasAhorroBean();
		String cta=  cuentasPersona.getCuentaAhoID();
		ctasAho.setCuentaAhoID(cta);
		ctasAhoID = consultaCuentasAho(Enum_Con_CuentasAho.pantRegistro,ctasAho);
		String tipoCta = ctasAhoID.getTipoCuentaID();
		String monedaID = ctasAhoID.getMonedaID();
		cteID.setNumero(ctasAhoID.getClienteID());
		cteBean = clienteServicio.consulta(Enum_Lis_CuentasAho.principal,ctasAhoID.getClienteID(),"");
		
		parametrosReporte.agregaParametro("Par_ClienteID",ctasAhoID.getClienteID());
		parametrosReporte.agregaParametro("Par_EdoCta",ctasAhoID.getEstadoCta());	
		parametrosReporte.agregaParametro("Par_NomCte",cteBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_FechaNac",cteBean.getFechaNacimiento());
		parametrosReporte.agregaParametro("Par_RFC",cteBean.getRFCpm());
		parametrosReporte.agregaParametro("Par_TipoPersona",cteBean.getTipoPersona());
		
		String tipoPerson = cteBean.getTipoPersona();
		tasasCta.setTipoCuentaID(tipoCta);
		tasasCta.setMonedaID(monedaID);
		tasasCta.setTipoPersona(tipoPerson);
		listaTasasAho = tasasAhorroServicio.lista(Enum_Lis_CuentasAho.ctaCte,tasasCta);
		
		for(int i=0; i<listaTasasAho.size(); i++){
			tasasAhoBean = (TasasAhorroBean)listaTasasAho.get(i);
			if(i==4){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_Tasa" +i, tasasAhoBean.getTasa());
			parametrosReporte.agregaParametro("Par_MontoInf" +i, tasasAhoBean.getMontoInferior());
			parametrosReporte.agregaParametro("Par_MontoSup" +i, tasasAhoBean.getMontoSuperior());
														
		}
		parametrosReporte.agregaParametro("Par_TipoCtaAhoID", tasasCta.getTipoCuentaID());
		parametrosReporte.agregaParametro("Par_SucursalID",(cuentasPersona.getSucursalID()));
		return Reporte.creaPDFReporte(nombreReportePF, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// Anexo portada contrato de cuenta persona Fisica
	public String anexoPortadaContratoCtaPF(CuentasPersonaBean cuentasPersona, String nombreReportePF) throws Exception{
		List  listaApoderados = null;
		CuentasPersonaBean personBean ;
		
		listaApoderados = cuentasPersonaServicio.lista(Enum_Lis_CuentasAho.anexoApoder,cuentasPersona);
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		for(int i=0; i<listaApoderados.size(); i++){
			personBean = (CuentasPersonaBean)listaApoderados.get(i);
			if(i==4){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_NomAPod" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_RFC" +i, personBean.getRFC());
			parametrosReporte.agregaParametro("Par_FechNac" +i, personBean.getFechaNacimiento());
			parametrosReporte.agregaParametro("Par_Direccion" +i, personBean.getDomicilio());
														
		}
		
		parametrosReporte.agregaParametro("Par_CuentaAhoID", cuentasPersona.getCuentaAhoID());	
		
		CuentasAhoBean ctasAhoID = new CuentasAhoBean();
		CuentasAhoBean ctasAho = new CuentasAhoBean();
		ClienteBean cteID = new ClienteBean();
		ClienteBean cteBean =new ClienteBean();
		
		String cta=  cuentasPersona.getCuentaAhoID();
		ctasAho.setCuentaAhoID(cta);
		ctasAhoID = consultaCuentasAho(Enum_Con_CuentasAho.pantRegistro,ctasAho);
		cteID.setNumero(ctasAhoID.getClienteID());
		cteBean = clienteServicio.consulta(Enum_Lis_CuentasAho.principal,ctasAhoID.getClienteID(),"");
		parametrosReporte.agregaParametro("Par_NomCte",cteBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_TipoCtaAhoID", ctasAhoID.getTipoCuentaID());
		return Reporte.creaHtmlReporte(nombreReportePF, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	
	public ByteArrayOutputStream anexoPortadaContratoCtaPFPDF(CuentasPersonaBean cuentasPersona, String nombreReportePF) throws Exception{
		List  listaApoderados = null;
		CuentasPersonaBean personBean ;
		
		listaApoderados = cuentasPersonaServicio.lista(Enum_Lis_CuentasAho.anexoApoder,cuentasPersona);
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		for(int i=0; i<listaApoderados.size(); i++){
			personBean = (CuentasPersonaBean)listaApoderados.get(i);
			if(i==4){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_NomAPod" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_RFC" +i, personBean.getRFC());
			parametrosReporte.agregaParametro("Par_FechNac" +i, personBean.getFechaNacimiento());
			parametrosReporte.agregaParametro("Par_Direccion" +i, personBean.getDomicilio());
														
		}
		
		parametrosReporte.agregaParametro("Par_CuentaAhoID", cuentasPersona.getCuentaAhoID());	
		
		CuentasAhoBean ctasAhoID = new CuentasAhoBean();
		CuentasAhoBean ctasAho = new CuentasAhoBean();
		ClienteBean cteID = new ClienteBean();
		ClienteBean cteBean =new ClienteBean();
		
		String cta=  cuentasPersona.getCuentaAhoID();
		ctasAho.setCuentaAhoID(cta);
		ctasAhoID = consultaCuentasAho(Enum_Con_CuentasAho.pantRegistro,ctasAho);
		cteID.setNumero(ctasAhoID.getClienteID());
		cteBean = clienteServicio.consulta(Enum_Lis_CuentasAho.principal,ctasAhoID.getClienteID(),"");
		parametrosReporte.agregaParametro("Par_NomCte",cteBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_TipoCtaAhoID", ctasAhoID.getTipoCuentaID());
		return Reporte.creaPDFReporte(nombreReportePF, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public Object consultaCuentasPorClienteWS(int tipoConsulta, ConsultaCuentasPorClienteRequest consultaRequest){
		Object obj= null;
		String cadena;
		codigo = "01";
		ConsultaCuentasPorClienteResponse res=new ConsultaCuentasPorClienteResponse();
		List<ConsultaCuentasPorClienteResponse> tmpcuentasCliente = cuentasAhoDAO.consultaCtaCteWS(consultaRequest, tipoConsulta );
		if (tmpcuentasCliente!=null){
			cadena=transformArray(tmpcuentasCliente);
			if(codigo!=null){
				if (codigo.equals("0")){
					res.setInfocuenta(cadena);
					res.setCodigoRespuesta("0");
					res.setMensajeRespuesta("Exito");
				}				
			}
			else
			{	res.setInfocuenta(" ");
				res.setCodigoRespuesta("01");
				res.setMensajeRespuesta("Fallo");
			}	
		} else
		{  	res.setInfocuenta(" ");
			res.setCodigoRespuesta("01");
			res.setMensajeRespuesta("Fallo");
		}		
		obj=(Object)res;
		return obj;
	}
	
	private String transformArray(List  a)
    {
	
        String res ="";
        ConsultaCuentasPorClienteResponse temp;
        if(a!=null)
        {   //res = new String[a.size()];
            Iterator<ConsultaCuentasPorClienteResponse> it = a.iterator();
            while(it.hasNext())
            {    
                temp = (ConsultaCuentasPorClienteResponse)it.next();
                
                codigo = temp.getCodigoRespuesta(); 
                res+= temp.getInfocuenta()+"&|&";
            }
        }
        return res;
    }
	
	public Object consultaDisponibleCte(int tipoConsulta, Object consultaCuentasPorCliente){
		Object obj= null;
		switch (tipoConsulta) {
		case Enum_Con_CuentasAho.saldoDisCte:		
			ConsultaDisponiblePorClienteRequest consultaRequest = (ConsultaDisponiblePorClienteRequest)consultaCuentasPorCliente;
			ConsultaDisponiblePorClienteResponse consultaResponse=null;
			consultaResponse= cuentasAhoDAO.consultaDisponiblePorCliente(consultaRequest, tipoConsulta);
			if(consultaResponse == null) {
				consultaResponse = new ConsultaDisponiblePorClienteResponse();
				consultaResponse.setSaldoDispon(Constantes.STRING_CERO);
			}
			obj=(Object)consultaResponse;
			break;
		}
		return obj;
	}
	
	/*case para listas de reportes de credito*/
	public List listaReportesCuentas(int tipoLista, AnaliticoAhorroBean analiticoAhorroBean, HttpServletResponse response){

		// List listaCreditos = null;
		 List listaCuentas=null;
	
		switch(tipoLista){
		
					
			case Enum_Lis_CuenRep.AnaliticoAhorro:
				listaCuentas = cuentasAhoDAO.consultaRepProxAnalitico(analiticoAhorroBean, tipoLista);
				break;	
			}
		
		return listaCuentas;
	}
	
	// Reporte de Saldos Globales
	public List<RepSaldosGlobalesBean> listaReporteSaldoGlobal(int tipoLista, RepSaldosGlobalesBean repSaldosGlobalesBean, HttpServletResponse response){
	
		List<RepSaldosGlobalesBean> listaCuentas = null;
		switch(tipoLista){
			case Enum_Lis_SaldosGlobalesRep.saldosGlobales:
				listaCuentas = cuentasAhoDAO.reporteSaldosGlobales(repSaldosGlobalesBean, tipoLista);
			break;	
		}
		return listaCuentas;
	}
	
	public ByteArrayOutputStream creaRepAnaliticoAhorroPDF(AnaliticoAhorroBean analiticoAhorroBean , String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero((!analiticoAhorroBean.getClienteID().isEmpty())?analiticoAhorroBean.getClienteID(): "Todos"));
		parametrosReporte.agregaParametro("Par_CuentaAho",Utileria.convierteEntero((!analiticoAhorroBean.getCuentasAho().isEmpty())?analiticoAhorroBean.getCuentasAho(): "Todos"));
		parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(analiticoAhorroBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_Moneda",Utileria.convierteEntero((!analiticoAhorroBean.getMonedaID().isEmpty())?analiticoAhorroBean.getMonedaID(): "Todos"));
		parametrosReporte.agregaParametro("Par_TipoCuenta",Utileria.convierteEntero((!analiticoAhorroBean.getTipoCuentaID().isEmpty())?analiticoAhorroBean.getTipoCuentaID(): "Todos"));
		
		parametrosReporte.agregaParametro("Par_PromotorActual",Utileria.convierteEntero(analiticoAhorroBean.getPromotorID()));
		parametrosReporte.agregaParametro("Par_Genero",analiticoAhorroBean.getGenero());
		parametrosReporte.agregaParametro("Par_Estado",Utileria.convierteEntero(analiticoAhorroBean.getEstadoID()));
		parametrosReporte.agregaParametro("Par_Municipio",Utileria.convierteEntero(analiticoAhorroBean.getMunicipioID()));
		parametrosReporte.agregaParametro("Par_nombreSucursal",(!analiticoAhorroBean.getNombreSucursal().isEmpty())?analiticoAhorroBean.getNombreSucursal():"Todos");;
		parametrosReporte.agregaParametro("Par_nombreTipoCuenta",(!analiticoAhorroBean.getNombreTipocuenta().isEmpty())?analiticoAhorroBean.getNombreTipocuenta():"Todos");
		parametrosReporte.agregaParametro("Par_nombreCliente",analiticoAhorroBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_nombreGenero",(!analiticoAhorroBean.getNombreGenero().isEmpty())?analiticoAhorroBean.getNombreGenero():"Todos");
		
		parametrosReporte.agregaParametro("Par_nombreMoneda",(!analiticoAhorroBean.getNombreMoneda().isEmpty())?analiticoAhorroBean.getNombreMoneda():"Todos");
		parametrosReporte.agregaParametro("Par_nombreCuentaAho",(!analiticoAhorroBean.getNombreCuentaAho().isEmpty())?analiticoAhorroBean.getCuentasAho():"Todos");
		parametrosReporte.agregaParametro("Par_nombrePromotorI",(!analiticoAhorroBean.getNombrePromotorI().isEmpty())?analiticoAhorroBean.getNombrePromotorI():"Todos");
		parametrosReporte.agregaParametro("Par_nombreEstado",(!analiticoAhorroBean.getNombreEstado().isEmpty())?analiticoAhorroBean.getNombreEstado():"Todos");
		parametrosReporte.agregaParametro("Par_nombreMunicipio",(!analiticoAhorroBean.getNombreMunicipio().isEmpty())?analiticoAhorroBean.getNombreMunicipio():"Todos");
		parametrosReporte.agregaParametro("Par_nombreCliente",(!analiticoAhorroBean.getNombreCliente().isEmpty())?analiticoAhorroBean.getNombreCliente():"Todos");

		parametrosReporte.agregaParametro("Par_FechaEmision",analiticoAhorroBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!analiticoAhorroBean.getNombreUsuario().isEmpty())?analiticoAhorroBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!analiticoAhorroBean.getNombreInstitucion().isEmpty())?analiticoAhorroBean.getNombreInstitucion(): "Todos");
		 	 
		
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	
	
	

	
	// Lista de Cuentas Por Cliente WS
   	public Object listaCtaCliente(ListaCtaClienteRequest listaCtaClienteRequest){
			Object obj= null;
			String cadena = "";
			
			CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
			cuentasAhoBean.setClienteID(listaCtaClienteRequest.getClienteID());
			ListaCtaClienteResponse respuestaLista = new ListaCtaClienteResponse();
			List<ListaCtaClienteResponse> listaCtas = cuentasAhoDAO.listaNumCliente(cuentasAhoBean, Enum_Lis_CuentasAho.numCte);
			if (listaCtas != null ){
				cadena = CreaStringCtasCliente(listaCtas);
			}
					respuestaLista.setListaCta(cadena);
			
					obj=(Object)respuestaLista;
					return obj;
			}	
 
   	// Separador de campos y registros de la lista de Creditos WS
		private String CreaStringCtasCliente(List listaCtas)
	    {
	        String resultado= "";
	        String separadorCampos = "[";
	 		String separadorRegistro = "]";
	 		
	 		CuentasAhoBean cuentasAhoBean;
	        if(listaCtas!= null)
	        {   
	            Iterator<CuentasAhoBean> it = listaCtas.iterator();
	            while(it.hasNext())
	            {    
	            	cuentasAhoBean = (CuentasAhoBean)it.next();             	
	            	resultado += cuentasAhoBean.getCuentaAhoID()+separadorCampos+
	            				cuentasAhoBean.getEtiqueta()+separadorRegistro;
	            			
	            }
	        }
	 		if(resultado.length() !=0){
	 				resultado = resultado.substring(0,resultado.length()-1);
	 		}
	        return resultado;
	    }
		
	 //Lista Cuentas Ahorro WS
		public Object listaCuentasAhoWS(ListaCuentaAhoRequest listaCuentaAhoRequest){
			Object obj= null;
			String cadena= "";

			ListaCuentaAhoResponse listaCuentaAhoResponse=new ListaCuentaAhoResponse();
			List<ListaCuentaAhoResponse> lisCuentas = cuentasAhoDAO.listaCuentasAhoWS(listaCuentaAhoRequest);
			if (lisCuentas != null ){
				cadena = creaCadenaCuentas(lisCuentas);							
			}
			listaCuentaAhoResponse.setListaCuenta(cadena);
		
			obj=(Object)listaCuentaAhoResponse;
			
			return obj;
		} 
		// Separador de campos y registros de la lista de Cuentas de Ahorro
		private String creaCadenaCuentas(List  listaCuentas){
			String resultadoCuenta = "";
		    String separadorCampos = "[";  
		    String separadorRegistros = "]";
	 
		    CuentasAhoBean cuentasAhoBean;
		    if(listaCuentas != null) {   
		        Iterator<CuentasAhoBean> it = listaCuentas.iterator();
		        while(it.hasNext()){    
		        	cuentasAhoBean = (CuentasAhoBean)it.next();
		        	resultadoCuenta += cuentasAhoBean.getCuentaAhoID() + separadorCampos +
		        						cuentasAhoBean.getNombreCompleto() + separadorRegistros;
		        }
		    }
		    if(resultadoCuenta.length() != 0){
		    	resultadoCuenta = resultadoCuenta.substring(0,resultadoCuenta.length()-1);
		    }
		    return resultadoCuenta;
	    }
		
		
		/* lista cuentas para WS */
		public SP_PDA_Cuentas_DescargaResponse listaCuentasWS(int tipoLista){
			SP_PDA_Cuentas_DescargaResponse respuestaLista = new SP_PDA_Cuentas_DescargaResponse();			
			List listaCuentas;
			CuentasAhoBean cuentas;
			
			listaCuentas = cuentasAhoDAO.listaCuentasWS(tipoLista);
			
			if(listaCuentas !=null){ 			
				try{
					for(int i=0; i<listaCuentas.size(); i++){	
						cuentas = (CuentasAhoBean)listaCuentas.get(i);
						
						respuestaLista.addCuentas(cuentas);
					}
					
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Cuentas y/o Creditos para WS", e);
				}			
			}		
		 return respuestaLista;
		}
		
		
		/* lista cuentas para WS */
		public SP_PDA_Ahorros_DescargaResponse listacuentasAhoWS(SP_PDA_Ahorros_DescargaRequest request){
			SP_PDA_Ahorros_DescargaResponse respuestaLista = new SP_PDA_Ahorros_DescargaResponse();			
			List listaCuentas;
			CuentasAhoBean cuentas;
			
			listaCuentas = cuentasAhoDAO.listacuentasAhoWS(request,Enum_Lis_CuentasAhorroWS.ahorroCuentas);
			
			if(listaCuentas !=null){ 			
				try{
					for(int i=0; i<listaCuentas.size(); i++){	
						cuentas = (CuentasAhoBean)listaCuentas.get(i);
						
						respuestaLista.addCuenta(cuentas);
					}
					
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Ahorros de cuentas para WS", e);
				}			
			}		
		 return respuestaLista;
		} // fin lista WS
		
		
	public void setCuentasPersonaServicio(
			CuentasPersonaServicio cuentasPersonaServicio) {
		this.cuentasPersonaServicio = cuentasPersonaServicio;
	}

	public void setTasasAhorroServicio(TasasAhorroServicio tasasAhorroServicio) {
		this.tasasAhorroServicio = tasasAhorroServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}
	
	public void setCuentasAhoDAO(CuentasAhoDAO cuentasAhoDAO ){
		this.cuentasAhoDAO = cuentasAhoDAO;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

	public CuentasAhoDAO getCuentasAhoDAO() {
		return cuentasAhoDAO;
	}
	
}