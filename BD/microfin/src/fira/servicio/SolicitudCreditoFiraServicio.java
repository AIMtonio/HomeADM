package fira.servicio;
import originacion.bean.ComentariosMonitorBean;
import originacion.bean.EsquemaautfirmaBean;
import originacion.servicio.EsquemaautfirmaServicio;
import fira.bean.SolicitudCreditoFiraBean;
import fira.dao.SolicitudCreditoFiraDAO;
import fira.servicio.MinistraCredAgroServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;


import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cliente.bean.CicloCreditoBean;
import pld.bean.OpeEscalamientoInternoBean;
import pld.servicio.OpeEscalamientoInternoServicio;
import reporte.ParametrosReporte;
import reporte.Reporte;
import credito.bean.SeguroVidaBean;
import credito.beanWS.response.SimuladorCuotaCreditoResponse;
import credito.dao.SeguroVidaDAO;

public class SolicitudCreditoFiraServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	SolicitudCreditoFiraDAO solicitudCreditoFiraDAO = null;		
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

	}	

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_SolCredito {
		int principal 				= 1;
		int integraGrupo 			= 4;
		int integraAval 			= 5;
		int solInactivas			= 6;
		int solAutorizadas			= 7;
		int solCheckListGrid 		= 8; // lista pantalla CheckList
		int liberadasProm 			= 9;// Lista de solicitudes de credito Liberadas  Filtradas por el Promotor si es que atiende a sucursal
		int listaSolRatios			= 11; // Lista de Solicitudes con todos los estatus solo de productos de credito que requieren Calculo de Ratios
		int listaSolRenovacion		= 12; // Lista de Solicitudes para credito renovacion
		int listaSolReestructura	= 13; /*Lista de Solicitudes para credito reestructura*/
		int	listaAgropecuarios		= 14; // lista agro
		int listaSolRiesgoComun		= 15; // Lista de Solicitudes que presentan Riesgo Común
		int listaReacreditamiento	= 16; // Lista de Solicitudes con Reacreditamiento
		int listaGuardaValores		= 17;	// Lista de Guarda Valores
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

	public SolicitudCreditoFiraServicio() {
		super();
	}	

	//enums de transaccion para enviar a servicio de esquema de autorizacion de firmas
	public static interface Enum_Tra_EsqAutFirmas {
		int grabaFirmas = 3;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, SolicitudCreditoFiraBean solicitudCredito, String detalleFirmasAutoriza) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_SolCredito.alta:
				mensaje = altaSolicitudCredito(solicitudCredito);
				break;
			case Enum_Tra_SolCredito.modificacion:
				mensaje = modificacionSolicitudCredito(solicitudCredito);
				break;
			case Enum_Tra_SolCredito.actualiza:
				mensaje = actualizaSolicitudCredito(solicitudCredito, tipoActualizacion, detalleFirmasAutoriza);
				break;
			case Enum_Tra_SolCredito.actualizaCalendario:
				mensaje = actualizaCalendarioSolicitudCredito(solicitudCredito);
				break;
			case Enum_Tra_SolCredito.altaBE:
				mensaje = solicitudCreditoFiraDAO.altaSolicitudCreditoBE(solicitudCredito);
				break;
			case Enum_Tra_SolCredito.actualizaTasa:
				mensaje = solicitudCreditoFiraDAO.actualizaTasa(solicitudCredito, tipoActualizacion);
				break;
			case Enum_Tra_SolCredito.altaCreditoAgro:
				mensaje = solicitudCreditoFiraDAO.altaSolicitudCredAgro(solicitudCredito, tipoActualizacion);
				break;
			case Enum_Tra_SolCredito.modifCreditoAgro:
				mensaje = solicitudCreditoFiraDAO.modificacionCredAgro(solicitudCredito, tipoActualizacion);
				break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean altaSolicitudCredito(SolicitudCreditoFiraBean solicitudCredito){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeSol = null;
		MensajeTransaccionBean mensajeActualiza = null;
		ComentariosMonitorBean comentarios = new ComentariosMonitorBean();	
		String estatusRegistro = "SI";
		int actualizaReacredita = 13;

		if(solicitudCredito.getReqSeguroVida()!=null &&
				solicitudCredito.getReqSeguroVida().equalsIgnoreCase(SeguroVidaBean.Requiere_Seguro_SI)){
			mensaje = solicitudCreditoFiraDAO.altaSolicitudConSeguroVida(solicitudCredito);
			comentarios.setSolicitudCreditoID(mensaje.getConsecutivoString());
			comentarios.setEstatus(estatusRegistro);
			comentarios.setComentario(solicitudCredito.getComentario());
			comentarios.setFecha(solicitudCredito.getFechaAutoriza());
			mensajeSol = solicitudCreditoFiraDAO.altaComentario(comentarios);
			solicitudCredito.setSolicitudCreditoID(mensaje.getConsecutivoString());
			if(solicitudCredito.getEsReacreditado()!=null &&
					solicitudCredito.getEsReacreditado().equalsIgnoreCase("S")){
				mensajeActualiza = solicitudCreditoFiraDAO.actualizaSolicitud(solicitudCredito, actualizaReacredita);
			}
			
		}else{
			
						
			mensaje = solicitudCreditoFiraDAO.altaSolicitudCredito(solicitudCredito);
			
			comentarios.setSolicitudCreditoID(mensaje.getConsecutivoString());
			comentarios.setEstatus(estatusRegistro);
			comentarios.setFecha(solicitudCredito.getFechaRegistro());
			comentarios.setComentario(solicitudCredito.getComentario());
			comentarios.setUsuarioAutoriza(solicitudCredito.getUsuarioAutoriza());
			
			mensajeSol = solicitudCreditoFiraDAO.altaComentario(comentarios);	
			solicitudCredito.setSolicitudCreditoID(mensaje.getConsecutivoString());
			if(solicitudCredito.getEsReacreditado()!=null &&
					solicitudCredito.getEsReacreditado().equalsIgnoreCase("S")){
				
				mensajeActualiza = solicitudCreditoFiraDAO.actualizaSolicitud(solicitudCredito, actualizaReacredita);
			}
			
		}
		return mensaje;
	}
	
	//metodo para el simulador de amortizaciones de credito
	public SimuladorCuotaCreditoResponse simuladorCuotaCredito(SolicitudCreditoFiraBean solicitudCredito){
		SimuladorCuotaCreditoResponse mensaje = new SimuladorCuotaCreditoResponse();
		mensaje = solicitudCreditoFiraDAO.simuladorCuotaCredito(solicitudCredito);
		return mensaje;
	}

	public MensajeTransaccionBean modificacionSolicitudCredito(SolicitudCreditoFiraBean solicitudCredito){
		MensajeTransaccionBean mensaje = null;
		
		if(solicitudCredito.getReqSeguroVida()!=null &&
				solicitudCredito.getReqSeguroVida().equalsIgnoreCase(SeguroVidaBean.Requiere_Seguro_SI)){
			mensaje = solicitudCreditoFiraDAO.modificacionSolicitudConSeguroVida(solicitudCredito);
		}else{
			mensaje = solicitudCreditoFiraDAO.modificacionSolicitudCredito(solicitudCredito);	
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizaCalendarioSolicitudCredito(SolicitudCreditoFiraBean solicitudCredito){
		ArrayList listaSolCredBean = (ArrayList) creaListaDetalle(solicitudCredito);
		
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoFiraDAO.auxActualizaCalendarioSolicitudCredito(listaSolCredBean);
		return mensaje;
	}
	

	public MensajeTransaccionBean actualizaSolicitudCredito(SolicitudCreditoFiraBean solicitudCreditoFiraBean,int tipoActualizacion,String detalleFirmasAutoriza){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
		case Enum_Act_SolCredito.autoriza:
			mensaje = autorizaSolicitudCredito(solicitudCreditoFiraBean,tipoActualizacion,detalleFirmasAutoriza);	
			break;
		case Enum_Act_SolCredito.regresarEjec:
			mensaje = regresarEjecSolicitudCredito(solicitudCreditoFiraBean,tipoActualizacion);	
			break;
		case Enum_Act_SolCredito.rechazar:
			mensaje = rechazarSolicitudCredito(solicitudCreditoFiraBean,tipoActualizacion);	
			break;
		case Enum_Act_SolCredito.liberar:
			mensaje = liberarSolicitudCredito(solicitudCreditoFiraBean,tipoActualizacion);	
			break;

		case Enum_Act_SolCredito.liberarGrupal:
			mensaje = liberarSolicitudCreditoGrupal(solicitudCreditoFiraBean,tipoActualizacion);	
			break;

		case Enum_Act_SolCredito.actComntEjecu:
			mensaje = actComentarioEjecutivo(solicitudCreditoFiraBean,tipoActualizacion);	
			break;
		}
		return mensaje;
	}			

	// metodo de autorizacion de soliictud de credito
	public MensajeTransaccionBean autorizaSolicitudCredito(SolicitudCreditoFiraBean solicitudCreditoFiraBean, int tipoActualizacion,String detalleFirmasAutor){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeEscala = null;
		OpeEscalamientoInternoBean opeEscalamientoInt = new OpeEscalamientoInternoBean();
		opeEscalamientoInt.setFolioOperacionID(solicitudCreditoFiraBean.getSolicitudCreditoID());
		opeEscalamientoInt.setNombreCliente(nomProcesoEsc);
		opeEscalamientoInt.setResultadoRevision("0"); // PARA GRUPAL NO
		
		// Proceso de escalamiento interno
		mensajeEscala =opeEscalamientoInternoServicio.grabaTransaccion(numTransaccionEscala, opeEscalamientoInt);
		numResp=mensajeEscala.getNumero();

		if(numResp == 502 ){
			EsquemaautfirmaBean esquemaautfirmaBean =  new EsquemaautfirmaBean();
			esquemaautfirmaBean.setSolicitudCreditoID(solicitudCreditoFiraBean.getSolicitudCreditoID());
			esquemaautfirmaBean.setMontoAutor(solicitudCreditoFiraBean.getMontoAutorizado());
			esquemaautfirmaBean.setAportCliente(solicitudCreditoFiraBean.getAporteCliente());
			esquemaautfirmaBean.setComentarioMesaControl((solicitudCreditoFiraBean.getComentarioMesaControl()));
			//mensaje = solicitudCreditoFiraDAO.autorizaSolicitudCredito(solicitudCreditoFiraBean, tipoActualizacion);
			mensaje=esquemaautfirmaServicio.grabaTransaccion(Enum_Tra_EsqAutFirmas.grabaFirmas,esquemaautfirmaBean, detalleFirmasAutor);

			return mensaje;
		}else{
			return mensajeEscala;
		}
	}

	//metodo de rechazo de una solicitud de credito
	public MensajeTransaccionBean rechazarSolicitudCredito(SolicitudCreditoFiraBean solicitudCreditoFiraBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoFiraDAO.rechazarSolicitudCredito(solicitudCreditoFiraBean, tipoActualizacion);
		return mensaje;
	}

	//metodo de regreso a ejecutivo de una solicitud de credito
	public MensajeTransaccionBean regresarEjecSolicitudCredito(SolicitudCreditoFiraBean solicitudCreditoFiraBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoFiraDAO.regresarEjecSolicitudCredito(solicitudCreditoFiraBean, tipoActualizacion);
		return mensaje;
	}

	//metodo de liberacion de una solicitud de credito
	public MensajeTransaccionBean liberarSolicitudCredito(SolicitudCreditoFiraBean solicitudCreditoFiraBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoFiraDAO.liberarSolicitudCredito(solicitudCreditoFiraBean, tipoActualizacion);
		return mensaje;
	}

	//metodo de liberacion de una solicitud de credito grupal
	public MensajeTransaccionBean liberarSolicitudCreditoGrupal(SolicitudCreditoFiraBean solicitudCreditoFiraBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoFiraDAO.liberarSolicitudCredito(solicitudCreditoFiraBean, tipoActualizacion);
		return mensaje;
	} 

	//metodo de agregar mensajes de ejecutivo (unicamente)
	public MensajeTransaccionBean actComentarioEjecutivo(SolicitudCreditoFiraBean solicitudCreditoFiraBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCreditoFiraDAO.actComentarioEjecutivo(solicitudCreditoFiraBean, tipoActualizacion);
		return mensaje;
	} 

	// metodo para consultar el ciclo del cliente o prospecto	
	public  CicloCreditoBean consultaCiclo(SolicitudCreditoFiraBean solicitudCredito){
		CicloCreditoBean cicloCreditoBean = new CicloCreditoBean();	
		
		cicloCreditoBean.setClienteID(solicitudCredito.getClienteID());
		cicloCreditoBean.setProspectoID(solicitudCredito.getProspectoID());
		cicloCreditoBean.setProductoCreditoID(solicitudCredito.getProductoCreditoID());
		cicloCreditoBean.setGrupoID(solicitudCredito.getGrupoID());

		cicloCreditoBean = solicitudCreditoFiraDAO.consultaCicloCredito(cicloCreditoBean);
			return cicloCreditoBean;
	}
	
	/**
	 * Método para realizar las consultas a las Solicitudes de Crédito
	 * @param tipoConsulta : Número de Consulta de acuerdo a {@link Enum_Con_SolCredito}
	 * @param solicitudCredito : {@link SolicitudCreditoFiraBean} Bean con la Información de la Solicitud a Consultar
	 * @return {@link SolicitudCreditoFiraBean}
	 */
	public SolicitudCreditoFiraBean consulta(int tipoConsulta, SolicitudCreditoFiraBean solicitudCredito) {
		SolicitudCreditoFiraBean solicitudCreditoFiraBean = null;
		switch (tipoConsulta) {
			case Enum_Con_SolCredito.principal:
			case Enum_Con_SolCredito.general:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaPrincipal(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.foranea:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaForeanea(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.asignaSol:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaSolicitudAs(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.solActiva:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaSolActYSuc(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.porSuc:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaSolPorSuc(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.solicitudBE:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaBancaEnLinea(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.existSolCreNom:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaExisSol(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.status:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaStatus(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.agropecuarios:
			case Enum_Con_SolCredito.consultaReestr:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaPrincipalAgro(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.porOblSuc:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaSolPorOblSuc(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.detalleGarantiasSol:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaDetalleGarFOGAFI(solicitudCredito, tipoConsulta);
				break;
			case Enum_Con_SolCredito.conDiasPrimerAmor:
				solicitudCreditoFiraBean = solicitudCreditoFiraDAO.consultaDiasPrimerAmor(solicitudCredito, tipoConsulta);
			break;
				
		}

		return solicitudCreditoFiraBean;
	}

	/**
	 * Método para Listar las Solicitudes de Crédito
	 * @param tipoLista : Tipo de lista de acuerdo {@link Enum_Lis_SolCredito}
	 * @param solicitudCredito : {@link SolicitudCreditoFiraBean} Con la Información de la Solicitud
	 * @return {@link List}
	 */
	public List lista(int tipoLista, SolicitudCreditoFiraBean solicitudCredito) {
		List listaSolicitud = null;
		switch (tipoLista) {
			case Enum_Lis_SolCredito.principal:
			case Enum_Lis_SolCredito.listaAgropecuarios:
				listaSolicitud = solicitudCreditoFiraDAO.listaPrincipal(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.integraGrupo:
				listaSolicitud = solicitudCreditoFiraDAO.listaIntegraGrupo(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.integraAval:
				listaSolicitud = solicitudCreditoFiraDAO.listaIntegraAvales(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.solInactivas:
				listaSolicitud = solicitudCreditoFiraDAO.listaSolicitudesInactivas(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.solAutorizadas:
				listaSolicitud = solicitudCreditoFiraDAO.listaSolicitudesAutorizadas(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.solCheckListGrid:
				listaSolicitud = solicitudCreditoFiraDAO.listaSolCheckListGrid(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.liberadasProm:
				listaSolicitud = solicitudCreditoFiraDAO.listaSolLiberadasPromotor(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.listaSolRatios:
				listaSolicitud = solicitudCreditoFiraDAO.listaSolicitudesInactivas(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.listaSolRenovacion:
				listaSolicitud = solicitudCreditoFiraDAO.listaSolTratamiento(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.listaSolReestructura:
				listaSolicitud = solicitudCreditoFiraDAO.listaSolTratamiento(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.listaSolRiesgoComun:
				listaSolicitud = solicitudCreditoFiraDAO.listaSolRiesgoComun(solicitudCredito, tipoLista);
				break;
			case Enum_Lis_SolCredito.listaReacreditamiento:
				listaSolicitud = solicitudCreditoFiraDAO.listaSolTratamiento(solicitudCredito, tipoLista);
				break;	
			case Enum_Lis_SolCredito.listaGuardaValores:
				listaSolicitud = solicitudCreditoFiraDAO.listaGuardaValores(solicitudCredito, tipoLista);
			break;
		}
		return listaSolicitud;
	}
	
	
	public ByteArrayOutputStream reporteSolicitudCreditoPDF(SolicitudCreditoFiraBean solicitudCreditoFiraBean, 
			String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_SoliCredID",solicitudCreditoFiraBean.getSolicitudCreditoID());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",solicitudCreditoFiraBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_Sucursal",solicitudCreditoFiraBean.getSucursal());
		parametrosReporte.agregaParametro("Par_FechaEmision",solicitudCreditoFiraBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_GrupoID",solicitudCreditoFiraBean.getGrupoID());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
		
	public ByteArrayOutputStream reporteRecaPDF(SolicitudCreditoFiraBean solicitudCreditoFiraBean, 
			String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_SoliCredID",Utileria.convierteEntero(solicitudCreditoFiraBean.getSolicitudCreditoID()));
		parametrosReporte.agregaParametro("Par_NombreInstitucion",solicitudCreditoFiraBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_Sucursal",solicitudCreditoFiraBean.getSucursal());
		parametrosReporte.agregaParametro("Par_FechaEmision",solicitudCreditoFiraBean.getFechaActual());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	/**
	 * Método para generar el reporte de las Solicitudes generadas
	 * @param solicitudCreditoFiraBean
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public ByteArrayOutputStream repSolicitudesCreditoGeneradas(SolicitudCreditoFiraBean solicitudCreditoFiraBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucion",solicitudCreditoFiraBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaInicio",solicitudCreditoFiraBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_SucursalID",solicitudCreditoFiraBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_UsuarioID",solicitudCreditoFiraBean.getUsuario());
		parametrosReporte.agregaParametro("Par_nomSucursal",solicitudCreditoFiraBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_nombreUsuario",solicitudCreditoFiraBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NomUsuario",solicitudCreditoFiraBean.getNomUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",solicitudCreditoFiraBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_FechaFin",solicitudCreditoFiraBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_ProducCreditoID",solicitudCreditoFiraBean.getProductoCreditoID());
		parametrosReporte.agregaParametro("Par_DescProducCredito",solicitudCreditoFiraBean.getDescripcionProducto());
		parametrosReporte.agregaParametro("Par_ClienteID",solicitudCreditoFiraBean.getClienteID());
		parametrosReporte.agregaParametro("Par_ClienteNombre",solicitudCreditoFiraBean.getClienteNombre());
		parametrosReporte.agregaParametro("Par_ProspectoID",solicitudCreditoFiraBean.getProspectoID());
		parametrosReporte.agregaParametro("Par_ProspectoNombre",solicitudCreditoFiraBean.getProspectoNombre());
		parametrosReporte.agregaParametro("Par_Estatus",solicitudCreditoFiraBean.getEstatus());
		parametrosReporte.agregaParametro("Par_EstatusDesc",solicitudCreditoFiraBean.getEstatusDesc());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	
	/* Arma la lista de beans */
	public List creaListaDetalle( SolicitudCreditoFiraBean bean) {		
		List<String> solicitudID		 = bean.getlSolicitudCre();
		List<String> estatusSol			 = bean.getlEstatusSolici();
		List<String> montoOriginal		 = bean.getlMontoSol();
		List<String> descuentoSeguro	 = bean.getlDescuentoSeguro();
		List<String> montoSegOriginal	 = bean.getlMontoSegOriginal();


		ArrayList listaDetalle = new ArrayList();
		SolicitudCreditoFiraBean beanAux = null;	
		if(solicitudID != null){
			int tamanio = solicitudID.size();	
			for (int i = 0; i < tamanio; i++) {
				beanAux = new SolicitudCreditoFiraBean();
				
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
	

	//------------------ Geters y Seters ------------------------------------------------------	



	public void setOpeEscalamientoInternoServicio(
			OpeEscalamientoInternoServicio opeEscalamientoInternoServicio) {
		this.opeEscalamientoInternoServicio = opeEscalamientoInternoServicio;
	}

	
	public SeguroVidaDAO getSeguroVidaDAO() {
		return seguroVidaDAO;
	}

	public void setSeguroVidaDAO(SeguroVidaDAO seguroVidaDAO) {
		this.seguroVidaDAO = seguroVidaDAO;
	}

	public SolicitudCreditoFiraDAO getSolicitudCreditoFiraDAO() {
		return solicitudCreditoFiraDAO;
	}

	public void setSolicitudCreditoFiraDAO(
			SolicitudCreditoFiraDAO solicitudCreditoFiraDAO) {
		this.solicitudCreditoFiraDAO = solicitudCreditoFiraDAO;
	}

	public EsquemaautfirmaServicio getEsquemaautfirmaServicio() {
		return esquemaautfirmaServicio;
	}

	public void setEsquemaautfirmaServicio(
			EsquemaautfirmaServicio esquemaautfirmaServicio) {
		this.esquemaautfirmaServicio = esquemaautfirmaServicio;
	}



}


