package originacion.servicio;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import cliente.bean.CicloCreditoBean;
import credito.beanWS.response.SimuladorCuotaCreditoResponse;
import credito.dao.SeguroVidaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import originacion.bean.EsquemaautfirmaBean;
import originacion.bean.SolicitudCreditoBean;
import originacion.dao.SolicitudCreditoDAO;
import pld.bean.OpeEscalamientoInternoBean;
import pld.servicio.OpeEscalamientoInternoServicio;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class SolicitudCreditoServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	SolicitudCreditoDAO solicitudCreditoDAO = null;		
	OpeEscalamientoInternoServicio opeEscalamientoInternoServicio = null;
	// inyeccion clase servicio esquema de autorizacion de firmas, al momento de dar de autorizar la sol.
	EsquemaautfirmaServicio esquemaautfirmaServicio = null;
	SeguroVidaDAO seguroVidaDAO = null;
	
	public String nomProcesoEsc = "SOLICITUDCREDITO";
	public int numTransaccionEscala = 1; // numero de respuesta de el proceso de escalamiento interno
	public int numResp = 0; // numero de respuesta de el proceso de escalamiento interno
	String numSolCredito = " "; // numero de solicitud que se dio de alta 
	String mensajedes = " "; // mensaje de la solicitud
		
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_SolCredito {
		int principal = 1;
		int foranea = 2;
		int asignaSol = 3;
		int solActiva = 4;
		int porSuc	= 5;
		int solicitudBE = 6;
		int existSolCreNom = 7;
		int status   = 8;
		int agropecuarios = 9;// Consulta solo creditos agropecuarios
		int general	=10; 
		int consultaReestr = 11;
		int porOblSuc	= 12;
		int detalleGarantiasSol = 13;
		int conDiasPrimerAmor = 14;
		int con_RenovacionesAgro = 15;
		int Con_SolCredInstConv = 16;
		int Con_SolCredInstDispersion = 17;
	}	

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_SolCredito {
		int principal 				= 1;
		int integraGrupo 			= 4;
		int integraAval 			= 5;
		int solInactivas			= 6;
		int solAutorizadas			= 7;
		int solCheckListGrid 		= 8;  // lista pantalla CheckList
		int liberadasProm 			= 9;  // Lista de solicitudes de credito Liberadas  Filtradas por el Promotor si es que atiende a sucursal
		int listaSolRatios			= 11; // Lista de Solicitudes con todos los estatus solo de productos de credito que requieren Calculo de Ratios
		int listaSolRenovacion		= 12; // Lista de Solicitudes para credito renovacion
		int listaSolReestructura	= 13; // Lista de Solicitudes para credito reestructura
		int	listaAgropecuarios		= 14; // lista agro
		int listaSolRiesgoComun		= 15; // Lista de Solicitudes que presentan Riesgo Común
		int listaReacreditamiento	= 16; // Lista de Solicitudes con Reacreditamiento
		int listaGuardaValores		= 17; // Lista de Guarda Valores
		int listaSolRenovacionAgro	= 18; // Lista de Solicitudes para credito renovacion Agro
		int listaSolCredInstConv	= 19; // Listado de las Solicitudes de Creditos de Nomina y que el convenio que se encuentra LIgado maneja Capacidad de Pago
		int listaSolCredInstruccionDispersion	= 20; // Listado de las Solicitudes de Creditos de Nomina y que el convenio que se encuentra LIgado maneja Capacidad de Pago
		int solicitudesConsolidadas	= 21;
		int listaSolCredConsolidada = 22;
	}
	
	//---------- Tipo de Lista Combo ----------------------------------------------------------------
	public static interface Enum_Lis_Combo {
		int motivosCancel 				= 1;
		int motivosDev 			       = 2;
	}

	//---------- Tipos ----------------------------------------------------------------	
	public static interface Enum_Tra_SolCredito {
		int alta = 1;
		int modificacion = 2;
		int actualiza = 3;
		int actualizaCalendario = 4;
		int altaBE = 5;
		int actualizaTasa = 6;
		int altaCreditoAgro = 7;
		int modifCreditoAgro = 8;
		int altaConsolidacionAgro		= 9;
		int modificaConsolidacionAgro 	= 10;
		int procesaCiclosClienteGrupal	= 11;
	}

	public static interface Enum_Act_SolCredito {
		int autoriza 		= 1;	// autoriza la solicitud de credito
		int regresarEjec	= 3;	//regresa a ejecutivo la solicitud de credito
		int rechazar		= 4;	// rechaza la solicitud de credito 
		int liberar			= 5;	//libera la solicitud de credito
		int liberarGrupal	= 6;	//libera la solicitud de credito Grupal
		int actComntEjecu	= 7;	// Guarda mensajes del ejecutivo
	}
	
	public static interface Enum_Act_SolAgro {
		int principal = 1;
		int actualizacionCreditoAgro = 2;
		int	pagare	= 3;
		int cambioFondeo = 4;
	}	

	public SolicitudCreditoServicio() {
		super();
	}	

	//enums de transaccion para enviar a servicio de esquema de autorizacion de firmas
	public static interface Enum_Tra_EsqAutFirmas {
		int grabaFirmas = 3;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, SolicitudCreditoBean solicitudCredito, String detalleFirmasAutoriza) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_SolCredito.alta:
				mensaje = solicitudCreditoDAO.procesoAltaSolicitudCredito(solicitudCredito);
				break;
			case Enum_Tra_SolCredito.modificacion:
				mensaje = solicitudCreditoDAO.procesoModificacionSolicitudCredito(solicitudCredito);
				break;
			case Enum_Tra_SolCredito.actualiza:
				mensaje = actualizaSolicitudCredito(solicitudCredito, tipoActualizacion, detalleFirmasAutoriza);
				break;
			case Enum_Tra_SolCredito.actualizaCalendario:
				mensaje = actualizaCalendarioSolicitudCredito(solicitudCredito);
				break;
			case Enum_Tra_SolCredito.altaBE:
				mensaje = solicitudCreditoDAO.altaSolicitudCreditoBE(solicitudCredito);
				break;
			case Enum_Tra_SolCredito.actualizaTasa:
				mensaje = solicitudCreditoDAO.actualizaTasa(solicitudCredito, tipoActualizacion);
				break;
			case Enum_Tra_SolCredito.altaCreditoAgro:
				mensaje = solicitudCreditoDAO.altaSolicitudCredAgro(solicitudCredito, tipoActualizacion);
				break;
			case Enum_Tra_SolCredito.modifCreditoAgro:
				mensaje = solicitudCreditoDAO.modificacionCredAgro(solicitudCredito, tipoActualizacion);
				break;
			case Enum_Tra_SolCredito.altaConsolidacionAgro:
				mensaje = procesoConsolidacionAgro(solicitudCredito, Enum_Tra_SolCredito.altaConsolidacionAgro);
			break;
			case Enum_Tra_SolCredito.modificaConsolidacionAgro:
				mensaje = procesoConsolidacionAgro(solicitudCredito, Enum_Tra_SolCredito.modificaConsolidacionAgro);
			break;
			case Enum_Tra_SolCredito.procesaCiclosClienteGrupal:
				mensaje = solicitudCreditoDAO.procesoCiclosClienteGrupal(solicitudCredito);
			break;
		}
		return mensaje;
	}
	
	//metodo para el simulador de amortizaciones de credito
	public SimuladorCuotaCreditoResponse simuladorCuotaCredito(SolicitudCreditoBean solicitudCredito){
		SimuladorCuotaCreditoResponse mensaje = new SimuladorCuotaCreditoResponse();
		mensaje = solicitudCreditoDAO.simuladorCuotaCredito(solicitudCredito);
		return mensaje;
	}

	public MensajeTransaccionBean actualizaCalendarioSolicitudCredito(SolicitudCreditoBean solicitudCredito){
		ArrayList listaSolCredBean = (ArrayList) creaListaDetalle(solicitudCredito);
		
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoDAO.auxActualizaCalendarioSolicitudCredito(listaSolCredBean);
		return mensaje;
	}
	

	public MensajeTransaccionBean actualizaSolicitudCredito(SolicitudCreditoBean solicitudCreditoBean,int tipoActualizacion,String detalleFirmasAutoriza){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
		case Enum_Act_SolCredito.autoriza:
			mensaje = autorizaSolicitudCredito(solicitudCreditoBean,tipoActualizacion,detalleFirmasAutoriza);	
			break;
		case Enum_Act_SolCredito.regresarEjec:
			mensaje = regresarEjecSolicitudCredito(solicitudCreditoBean,tipoActualizacion);	
			break;
		case Enum_Act_SolCredito.rechazar:
			mensaje = rechazarSolicitudCredito(solicitudCreditoBean,tipoActualizacion);	
			break;
		case Enum_Act_SolCredito.liberar:
			mensaje = liberarSolicitudCredito(solicitudCreditoBean,tipoActualizacion);	
			break;

		case Enum_Act_SolCredito.liberarGrupal:
			mensaje = liberarSolicitudCreditoGrupal(solicitudCreditoBean,tipoActualizacion);	
			break;

		case Enum_Act_SolCredito.actComntEjecu:
			mensaje = actComentarioEjecutivo(solicitudCreditoBean,tipoActualizacion);	
			break;
		}
		return mensaje;
	}			

	// metodo de autorizacion de soliictud de credito
	public MensajeTransaccionBean autorizaSolicitudCredito(SolicitudCreditoBean solicitudCreditoBean, int tipoActualizacion,String detalleFirmasAutor){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeEscala = null;
		OpeEscalamientoInternoBean opeEscalamientoInt = new OpeEscalamientoInternoBean();
		opeEscalamientoInt.setFolioOperacionID(solicitudCreditoBean.getSolicitudCreditoID());
		opeEscalamientoInt.setNombreCliente(nomProcesoEsc);
		opeEscalamientoInt.setResultadoRevision("0"); // PARA GRUPAL NO
		
		// Proceso de escalamiento interno
		mensajeEscala =opeEscalamientoInternoServicio.grabaTransaccion(numTransaccionEscala, opeEscalamientoInt);
		numResp=mensajeEscala.getNumero();

		if(numResp == 502 ){
			EsquemaautfirmaBean esquemaautfirmaBean =  new EsquemaautfirmaBean();
			esquemaautfirmaBean.setSolicitudCreditoID(solicitudCreditoBean.getSolicitudCreditoID());
			esquemaautfirmaBean.setMontoAutor(solicitudCreditoBean.getMontoAutorizado());
			esquemaautfirmaBean.setAportCliente(solicitudCreditoBean.getAporteCliente());
			esquemaautfirmaBean.setComentarioMesaControl((solicitudCreditoBean.getComentarioMesaControl()));
			//mensaje = solicitudCreditoDAO.autorizaSolicitudCredito(solicitudCreditoBean, tipoActualizacion);
			mensaje=esquemaautfirmaServicio.grabaTransaccion(Enum_Tra_EsqAutFirmas.grabaFirmas,esquemaautfirmaBean, detalleFirmasAutor);

			return mensaje;
		}else{
			return mensajeEscala;
		}
	}

	//metodo de rechazo de una solicitud de credito
	public MensajeTransaccionBean rechazarSolicitudCredito(SolicitudCreditoBean solicitudCreditoBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoDAO.rechazarSolicitudCredito(solicitudCreditoBean, tipoActualizacion);
		return mensaje;
	}

	//metodo de regreso a ejecutivo de una solicitud de credito
	public MensajeTransaccionBean regresarEjecSolicitudCredito(SolicitudCreditoBean solicitudCreditoBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoDAO.regresarEjecSolicitudCredito(solicitudCreditoBean, tipoActualizacion);
		return mensaje;
	}

	//metodo de liberacion de una solicitud de credito
	public MensajeTransaccionBean liberarSolicitudCredito(SolicitudCreditoBean solicitudCreditoBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoDAO.liberarSolicitudCredito(solicitudCreditoBean, tipoActualizacion);
		return mensaje;
	}

	//metodo de liberacion de una solicitud de credito grupal
	public MensajeTransaccionBean liberarSolicitudCreditoGrupal(SolicitudCreditoBean solicitudCreditoBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoDAO.liberarSolicitudCredito(solicitudCreditoBean, tipoActualizacion);
		return mensaje;
	} 

	//metodo de agregar mensajes de ejecutivo (unicamente)
	public MensajeTransaccionBean actComentarioEjecutivo(SolicitudCreditoBean solicitudCreditoBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoDAO.actComentarioEjecutivo(solicitudCreditoBean, tipoActualizacion);
		return mensaje;
	} 

	// metodo para consultar el ciclo del cliente o prospecto	
	public  CicloCreditoBean consultaCiclo(SolicitudCreditoBean solicitudCredito){
		CicloCreditoBean cicloCreditoBean = new CicloCreditoBean();	
		
		cicloCreditoBean.setClienteID(solicitudCredito.getClienteID());
		cicloCreditoBean.setProspectoID(solicitudCredito.getProspectoID());
		cicloCreditoBean.setProductoCreditoID(solicitudCredito.getProductoCreditoID());
		cicloCreditoBean.setGrupoID(solicitudCredito.getGrupoID());

		cicloCreditoBean = solicitudCreditoDAO.consultaCicloCredito(cicloCreditoBean);
			return cicloCreditoBean;
	}
	
	/**
	 * Método para realizar las consultas a las Solicitudes de Crédito
	 * @param tipoConsulta : Número de Consulta de acuerdo a {@link Enum_Con_SolCredito}
	 * @param solicitudCredito : {@link SolicitudCreditoBean} Bean con la Información de la Solicitud a Consultar
	 * @return {@link SolicitudCreditoBean}
	 */
	public SolicitudCreditoBean consulta(int tipoConsulta, SolicitudCreditoBean solicitudCredito) {
		SolicitudCreditoBean solicitudCreditoBean = null;
		switch (tipoConsulta) {
			case Enum_Con_SolCredito.principal:
			case Enum_Con_SolCredito.general:
				solicitudCreditoBean = solicitudCreditoDAO.consultaPrincipal(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.foranea:
				solicitudCreditoBean = solicitudCreditoDAO.consultaForeanea(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.asignaSol:
				solicitudCreditoBean = solicitudCreditoDAO.consultaSolicitudAs(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.solActiva:
				solicitudCreditoBean = solicitudCreditoDAO.consultaSolActYSuc(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.porSuc:
				solicitudCreditoBean = solicitudCreditoDAO.consultaSolPorSuc(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.solicitudBE:
				solicitudCreditoBean = solicitudCreditoDAO.consultaBancaEnLinea(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.existSolCreNom:
				solicitudCreditoBean = solicitudCreditoDAO.consultaExisSol(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.status:
				solicitudCreditoBean = solicitudCreditoDAO.consultaStatus(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.agropecuarios:
			case Enum_Con_SolCredito.consultaReestr:
				solicitudCreditoBean = solicitudCreditoDAO.consultaPrincipalAgro(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.porOblSuc:
				solicitudCreditoBean = solicitudCreditoDAO.consultaSolPorOblSuc(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.detalleGarantiasSol:
				solicitudCreditoBean = solicitudCreditoDAO.consultaDetalleGarFOGAFI(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.conDiasPrimerAmor:
				solicitudCreditoBean = solicitudCreditoDAO.consultaDiasPrimerAmor(solicitudCredito, tipoConsulta);
			break;
			case Enum_Con_SolCredito.con_RenovacionesAgro:
				solicitudCreditoBean = solicitudCreditoDAO.consultaPrincipalAgro(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.Con_SolCredInstConv:
				solicitudCreditoBean = solicitudCreditoDAO.consultaSolCredInstConv(solicitudCredito, tipoConsulta);
				break;	
			case Enum_Con_SolCredito.Con_SolCredInstDispersion:	
				solicitudCreditoBean = solicitudCreditoDAO.consultaInstruccionDispersion(solicitudCredito, tipoConsulta);
			break;
		}

		return solicitudCreditoBean;
	}

	/**
	 * Método para Listar las Solicitudes de Crédito
	 * @param tipoLista : Tipo de lista de acuerdo {@link Enum_Lis_SolCredito}
	 * @param solicitudCredito : {@link SolicitudCreditoBean} Con la Información de la Solicitud
	 * @return {@link List}
	 */
	public List lista(int tipoLista, SolicitudCreditoBean solicitudCredito) {
		List listaSolicitud = null;
		switch (tipoLista) {
			case Enum_Lis_SolCredito.principal:
			case Enum_Lis_SolCredito.listaAgropecuarios:
				listaSolicitud = solicitudCreditoDAO.listaPrincipal(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.integraGrupo:
				listaSolicitud = solicitudCreditoDAO.listaIntegraGrupo(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.integraAval:
				listaSolicitud = solicitudCreditoDAO.listaIntegraAvales(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.solInactivas:
				listaSolicitud = solicitudCreditoDAO.listaSolicitudesInactivas(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.solAutorizadas:
				listaSolicitud = solicitudCreditoDAO.listaSolicitudesAutorizadas(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.solCheckListGrid:
				listaSolicitud = solicitudCreditoDAO.listaSolCheckListGrid(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.liberadasProm:
				listaSolicitud = solicitudCreditoDAO.listaSolLiberadasPromotor(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.listaSolRatios:
				listaSolicitud = solicitudCreditoDAO.listaSolicitudesInactivas(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.listaSolRenovacion:
				listaSolicitud = solicitudCreditoDAO.listaSolTratamiento(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.listaSolReestructura:
				listaSolicitud = solicitudCreditoDAO.listaSolTratamiento(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.listaSolRiesgoComun:
				listaSolicitud = solicitudCreditoDAO.listaSolRiesgoComun(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.listaReacreditamiento:
				listaSolicitud = solicitudCreditoDAO.listaSolTratamiento(solicitudCredito, tipoLista);
				break;	
			case Enum_Lis_SolCredito.listaGuardaValores:
				listaSolicitud = solicitudCreditoDAO.listaGuardaValores(solicitudCredito, tipoLista);
			break;
			case Enum_Lis_SolCredito.listaSolRenovacionAgro:
				listaSolicitud = solicitudCreditoDAO.listaSolTratamiento(solicitudCredito, tipoLista);
			break;
			case Enum_Lis_SolCredito.listaSolCredInstConv:
				listaSolicitud = solicitudCreditoDAO.listaSolCredInstConv(solicitudCredito, tipoLista);
			break;
			case Enum_Lis_SolCredito.listaSolCredInstruccionDispersion:
				listaSolicitud = solicitudCreditoDAO.listaInstruccionDispersion(solicitudCredito, tipoLista);
			break;
			case Enum_Lis_SolCredito.solicitudesConsolidadas:
			case Enum_Lis_SolCredito.listaSolCredConsolidada:
				listaSolicitud = solicitudCreditoDAO.listaSolicitudConsolidada(solicitudCredito, tipoLista);
			break;
					
		}
		return listaSolicitud;
	}
	
	
	public ByteArrayOutputStream reporteSolicitudCreditoPDF(SolicitudCreditoBean solicitudCreditoBean, 
			String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_SoliCredID",solicitudCreditoBean.getSolicitudCreditoID());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",solicitudCreditoBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_Sucursal",solicitudCreditoBean.getSucursal());
		parametrosReporte.agregaParametro("Par_FechaEmision",solicitudCreditoBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_GrupoID",solicitudCreditoBean.getGrupoID());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ByteArrayOutputStream reporteMesaControlAsePDF(String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ByteArrayOutputStream reporteSolicitudCreditoPMoralPDF(SolicitudCreditoBean solicitudCreditoBean, 
			String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_SoliCredID",solicitudCreditoBean.getSolicitudCreditoID());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",solicitudCreditoBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_Sucursal",solicitudCreditoBean.getSucursal());
		parametrosReporte.agregaParametro("Par_FechaEmision",solicitudCreditoBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_GrupoID",solicitudCreditoBean.getGrupoID());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	public ByteArrayOutputStream reporteSolicitudCreditoPFisicaPDF(SolicitudCreditoBean solicitudCreditoBean, 
			String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_SoliCredID",Utileria.convierteLong(solicitudCreditoBean.getSolicitudCreditoID()));
		parametrosReporte.agregaParametro("Par_FechaEmision",solicitudCreditoBean.getFechaActual());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
		
	public ByteArrayOutputStream reporteRecaPDF(SolicitudCreditoBean solicitudCreditoBean, 
			String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_SoliCredID",Utileria.convierteEntero(solicitudCreditoBean.getSolicitudCreditoID()));
		parametrosReporte.agregaParametro("Par_FechaEmision",solicitudCreditoBean.getFechaActual());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	/**
	 * Método para generar el reporte de las Solicitudes generadas
	 * @param solicitudCreditoBean
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public ByteArrayOutputStream repSolicitudesCreditoGeneradas(SolicitudCreditoBean solicitudCreditoBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucion",solicitudCreditoBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaInicio",solicitudCreditoBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_SucursalID",solicitudCreditoBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_UsuarioID",solicitudCreditoBean.getUsuario());
		parametrosReporte.agregaParametro("Par_nomSucursal",solicitudCreditoBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_nombreUsuario",solicitudCreditoBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NomUsuario",solicitudCreditoBean.getNomUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",solicitudCreditoBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_FechaFin",solicitudCreditoBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_ProducCreditoID",solicitudCreditoBean.getProductoCreditoID());
		parametrosReporte.agregaParametro("Par_DescProducCredito",solicitudCreditoBean.getDescripcionProducto());
		parametrosReporte.agregaParametro("Par_ClienteID",solicitudCreditoBean.getClienteID());
		parametrosReporte.agregaParametro("Par_ClienteNombre",solicitudCreditoBean.getClienteNombre());
		parametrosReporte.agregaParametro("Par_ProspectoID",solicitudCreditoBean.getProspectoID());
		parametrosReporte.agregaParametro("Par_ProspectoNombre",solicitudCreditoBean.getProspectoNombre());
		parametrosReporte.agregaParametro("Par_Estatus",solicitudCreditoBean.getEstatus());
		parametrosReporte.agregaParametro("Par_EstatusDesc",solicitudCreditoBean.getEstatusDesc());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	
	/* Arma la lista de beans */
	public List creaListaDetalle( SolicitudCreditoBean bean) {		
		List<String> solicitudID		 = bean.getlSolicitudCre();
		List<String> estatusSol			 = bean.getlEstatusSolici();
		List<String> montoOriginal		 = bean.getlMontoSol();
		List<String> descuentoSeguro	 = bean.getlDescuentoSeguro();
		List<String> montoSegOriginal	 = bean.getlMontoSegOriginal();


		ArrayList listaDetalle = new ArrayList();
		SolicitudCreditoBean beanAux = null;	
		if(solicitudID != null){
			int tamanio = solicitudID.size();	
			for (int i = 0; i < tamanio; i++) {
				beanAux = new SolicitudCreditoBean();
				
				beanAux.setGrupoID(bean.getGrupoID());
				beanAux.setPlazoID(bean.getPlazoID());
				beanAux.setReqSeguroVida(bean.getReqSeguroVida());
				beanAux.setFactorRiesgoSeguro(bean.getFactorRiesgoSeguro());
				beanAux.setFechInhabil(bean.getFechInhabil());
				
				beanAux.setAjusFecExiVen(bean.getAjusFecExiVen());
				beanAux.setCalendIrregular(bean.getCalendIrregular());
				beanAux.setAjFecUlAmoVen(bean.getAjFecUlAmoVen());
				beanAux.setTipoPagoCapital(bean.getTipoPagoCapital());
				beanAux.setFrecuenciaInt(bean.getFrecuenciaInt());
				
				beanAux.setFrecuenciaCap(bean.getFrecuenciaCap());
				beanAux.setPeriodicidadInt(bean.getPeriodicidadInt());
				beanAux.setPeriodicidadCap(bean.getPeriodicidadCap());
				beanAux.setDiaPagoInteres(bean.getDiaPagoInteres());
				beanAux.setDiaPagoCapital(bean.getDiaPagoCapital());
				
				beanAux.setDiaMesInteres(bean.getDiaMesInteres());
				beanAux.setDiaMesCapital(bean.getDiaMesCapital());
				beanAux.setNumAmortizacion(bean.getNumAmortizacion());
				beanAux.setNumAmortInteres(bean.getNumAmortInteres());
				beanAux.setFechaVencimiento(bean.getFechaVencimiento());

				
				beanAux.setFechaInicio(bean.getFechaInicio());
				beanAux.setProductoCreditoID(bean.getProductoCreditoID());
				beanAux.setSolicitudCreditoID(solicitudID.get(i));
				beanAux.setEstatus(estatusSol.get(i));
				beanAux.setMontoSolici(montoOriginal.get(i));
				beanAux.setForCobroSegVida(bean.getForCobroSegVida());
				beanAux.setDescuentoSeguro(descuentoSeguro.get(i));
				beanAux.setMontoSegOriginal(montoSegOriginal.get(i));
				
				listaDetalle.add(beanAux);
			}
		}
		return listaDetalle;
		
	}
	
	
	// listas para comboBox  de motivos cancelacion
	public  Object[] listaComboMotivosCancelacion(int tipoLista) {	
		List listaBean = null;
			
		switch(tipoLista){
			case Enum_Lis_Combo.motivosCancel: 
				listaBean =  solicitudCreditoDAO.listaComboMotCancelacion(tipoLista);
				break;
			
		}
		return listaBean.toArray();		
	}
	// listas para comboBox  de motivos devolucion
	public Object[] listaCombo(int tipoLista){ 
		List listaMotivos = null;
		switch (tipoLista) {
			case Enum_Lis_Combo.motivosDev:		
				listaMotivos=  solicitudCreditoDAO.listaComboMotDevolucion(tipoLista);				
				break;				
		}		
		return listaMotivos.toArray();
	}
	
	// Alta de la Solicitud de Crédito de Consolidación
	public MensajeTransaccionBean procesoConsolidacionAgro(SolicitudCreditoBean solicitudCreditoBean, int tipoTransaccion){
		MensajeTransaccionBean mensajeTransaccionBean = null;

		try {
			solicitudCreditoBean.setEsConsolidadoAgro(Constantes.STRING_SI);
				switch (tipoTransaccion) {
					case Enum_Tra_SolCredito.altaConsolidacionAgro:
						mensajeTransaccionBean = solicitudCreditoDAO.procesoAltaConsolidacionAgro(solicitudCreditoBean);
					break;
					case Enum_Tra_SolCredito.modificaConsolidacionAgro:
						mensajeTransaccionBean = solicitudCreditoDAO.procesoModificaConsolidacionAgro(solicitudCreditoBean);
					break;
				}
			
			if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}
		} catch (Exception exception) {
			if( mensajeTransaccionBean.getNumero() == Constantes.ENTERO_CERO ){
				mensajeTransaccionBean.setNumero(999);
			}
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Nivel Servicio: Error en el Proceso de la Solicitud de Crédito de Consolidación ", exception);
			return mensajeTransaccionBean;
		}
		return mensajeTransaccionBean;
	}

	//------------------ Geters y Seters ------------------------------------------------------	

	public SolicitudCreditoDAO getSolicitudCreditoDAO() {
		return solicitudCreditoDAO;
	}

	public void setSolicitudCreditoDAO(SolicitudCreditoDAO solicitudCreditoDAO) {
		this.solicitudCreditoDAO = solicitudCreditoDAO;
	}

	public void setOpeEscalamientoInternoServicio(
			OpeEscalamientoInternoServicio opeEscalamientoInternoServicio) {
		this.opeEscalamientoInternoServicio = opeEscalamientoInternoServicio;
	}

	public void setEsquemaautfirmaServicio(
			EsquemaautfirmaServicio esquemaautfirmaServicio) {
		this.esquemaautfirmaServicio = esquemaautfirmaServicio;
	}

	public SeguroVidaDAO getSeguroVidaDAO() {
		return seguroVidaDAO;
	}

	public void setSeguroVidaDAO(SeguroVidaDAO seguroVidaDAO) {
		this.seguroVidaDAO = seguroVidaDAO;
	}

}