package buroCredito.servicio;
 
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.NoRouteToHostException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import org.springframework.core.task.TaskExecutor;

import originacion.bean.SolicitudCreditoBean;
import originacion.dao.SolicitudCreditoDAO;
import originacion.servicio.SolicitudCreditoServicio;

import reporte.ParametrosReporte;
import reporte.Reporte;
import buroCredito.bean.SolBuroCreditoBean;
import buroCredito.dao.SolBuroCreditoDAO;
import buroCredito.servicioWSCirculo.safisrv.ws.schemas.ConsultaCirculoCreditoRequest;
import buroCredito.servicioWSCirculo.safisrv.ws.schemas.ConsultaCirculoCreditoResponse;
import buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServicios;
import buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServiciosServiceLocator;



public class SolBuroCreditoServicio extends BaseServicio {
//---------- Variables ------------------------------------------------------------------------
	SolBuroCreditoDAO		solBuroCreditoDAO = null;
	ParametrosSesionBean	parametrosSesionBean;
	SolicitudCreditoDAO		solicitudCreditoDAO = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	
	// private TaskExecutor taskExecutor;
//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_SolBuro {
		int principal   	= 1;
		int consultaBuro 	= 2;
		int listaCirculo	= 3;
		int listaBuro		= 4;
	}
	public static interface Enum_Tra_SolBuro {
		int alta 				= 1;
		int modificacion 		= 2;
		int consultacirculo 	= 3;
		int altaBCCC 			= 4; 
		int altaporSolicitudA	= 5; // circulo y buro 
		int altaporSolicitudB	= 6;
		int altaporSolicitudC	= 7;
	}
	public static interface Enum_Con_SolBuro {
		int principal = 1;
		int circulo =2;
		int folioFecha=3;
		int circuloEstatus = 4;
		int consultaGeneral	=5;			/* Consulta Usada en Ratios*/
	
	}
	public static interface Enum_Act_SolBuro {
		int actFolioSol 			= 1;
		int actFolioSolCirc 		= 2;
		int actFolioSolBuro			= 3;
		int actFolioSolCircInd		= 4;
	}
	public SolBuroCreditoServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
//--------------------------------------------------- Transacciones ---------------------------------------------------------
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SolBuroCreditoBean solBuroCreditoBean,HttpServletRequest request) throws UnknownHostException, IOException{
		MensajeTransaccionBean mensaje = null;
		String tipo_Buro = "B";
		String tipo_Circulo = "C";

		switch(tipoTransaccion){
		case Enum_Tra_SolBuro.alta:
			mensaje = altaRespuesta(solBuroCreditoBean);	
			break;
		case Enum_Tra_SolBuro.consultacirculo:
			mensaje = altaRespuestaCirculo(solBuroCreditoBean,request);	
			break;
		case Enum_Tra_SolBuro.altaBCCC:
			//mensaje = altaBCCC(solBuroCreditoBean,request);	
			break;
		case Enum_Tra_SolBuro.altaporSolicitudA:
			mensaje = altaporSolicitudA(solBuroCreditoBean,request);	
			break;
		case Enum_Tra_SolBuro.altaporSolicitudB:
			mensaje = altaporSolicitud(solBuroCreditoBean,request, tipo_Buro);	
			break;
		case Enum_Tra_SolBuro.altaporSolicitudC:
			mensaje = altaporSolicitud(solBuroCreditoBean,request, tipo_Circulo);	
			break;
			
		}
		return mensaje;
	}
	
//---------------------------------------------------- Actualizaciones ---------------------------------------------------------- 
	public MensajeTransaccionBean actualizaciones(SolBuroCreditoBean solBuroCreditoBean,int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
			case Enum_Act_SolBuro.actFolioSol:
				mensaje = solBuroCreditoDAO.actualizaFolioSolicitudBC(solBuroCreditoBean,tipoActualizacion);
			break;
			case Enum_Act_SolBuro.actFolioSolCirc:
				mensaje = solBuroCreditoDAO.actualizaFolioSolicitudCC(solBuroCreditoBean,tipoActualizacion);
			break;
			case Enum_Act_SolBuro.actFolioSolBuro:
				mensaje = solBuroCreditoDAO.actualizaFolioSolicitudBC(solBuroCreditoBean,tipoActualizacion);
			break;
			case Enum_Act_SolBuro.actFolioSolCircInd:
				mensaje = solBuroCreditoDAO.actualizaFolioSolicitudCC(solBuroCreditoBean,tipoActualizacion);
			break;
		}
		return mensaje;
	}	
//---------------------------------------------------- Consultas ----------------------------------------------------------
	/**
	 * Consulta de solicitudes para Buro de crédito
	 * @param tipoConsulta
	 * @param solBuroCreditoBean
	 * @return
	 */
	public SolBuroCreditoBean consulta(int tipoConsulta, SolBuroCreditoBean solBuroCreditoBean){
		SolBuroCreditoBean solBuroCredito = null;
		switch (tipoConsulta) {
			case Enum_Con_SolBuro.principal:		
				solBuroCredito = solBuroCreditoDAO.consultaPrincipal(solBuroCreditoBean, tipoConsulta);				
				break;
			case Enum_Con_SolBuro.folioFecha:	
				solBuroCredito = solBuroCreditoDAO.consultaFolio(solBuroCreditoBean, tipoConsulta);				
				break;
			case Enum_Con_SolBuro.circulo:		
				solBuroCredito = solBuroCreditoDAO.consultaporFolioCirculo(solBuroCreditoBean, tipoConsulta);				
				break;
			case Enum_Con_SolBuro.circuloEstatus:		
				solBuroCredito = solBuroCreditoDAO.consultaporRFC(solBuroCreditoBean, tipoConsulta);				
				break;
			case Enum_Con_SolBuro.consultaGeneral:		
				solBuroCredito = solBuroCreditoDAO.consultaporGeneral(solBuroCreditoBean, tipoConsulta);				
				break;
		}		
		return solBuroCredito;
	}
//---------------------------------------------------- Listas ----------------------------------------------------------
	
	public List lista(int tipoLista, SolBuroCreditoBean solBuroCreditoBean){
		List listaBuroCredito = null;		
		switch (tipoLista) {
		case Enum_Lis_SolBuro.principal:		
			listaBuroCredito=  solBuroCreditoDAO.listaSolBuroCredito(solBuroCreditoBean, tipoLista);				
			break;
		case Enum_Lis_SolBuro.consultaBuro:	
			listaBuroCredito= solBuroCreditoDAO.listaBuroCreditoPorSol(solBuroCreditoBean, tipoLista);
		break;
		case Enum_Lis_SolBuro.listaCirculo:
			listaBuroCredito= solBuroCreditoDAO.listaSolBuroCredito(solBuroCreditoBean, tipoLista);
		break;
		case Enum_Lis_SolBuro.listaBuro:		
			listaBuroCredito= solBuroCreditoDAO.listaSolBuroCredito(solBuroCreditoBean, tipoLista);
		break;
		}
		return listaBuroCredito;
	}
	
	//-------------------------********************* BURO Y  CIRCULO DE CREDITO **************---------------------------------------------------------------
	// Alta de solicitud buró de crédito y círculo de crédito
	public MensajeTransaccionBean altaporSolicitudA(SolBuroCreditoBean solBuroCreditoBean, HttpServletRequest request) throws UnknownHostException, IOException{
		MensajeTransaccionBean mensaje = null;
		String var_tipo_CirculoCredito = "C";
		String var_tipo_BuroCredito = "B";
		
		SolBuroCreditoBean solBuroCredito = new SolBuroCreditoBean();
		solBuroCredito = solBuroCreditoDAO.consultaporRFC(solBuroCreditoBean, Enum_Con_SolBuro.circuloEstatus);
		
		
		mensaje = solBuroCreditoDAO.altaRespuestaBuro(solBuroCreditoBean);
		solBuroCreditoBean.setNumTransaccion(mensaje.getConsecutivoString());
		
		mensaje = actualizaCirculoCreditoA(solBuroCreditoBean,	var_tipo_CirculoCredito,	request, solBuroCredito);
		mensaje = actualizaCirculoCreditoA(solBuroCreditoBean,	var_tipo_BuroCredito,		request, solBuroCredito );
			
	  return mensaje;
	 }
	
	// ............ Metodo de Actualizacion  Asincronamente de Buro y Circulo de Credito ....................		
	public MensajeTransaccionBean actualizaCirculoCreditoA(final  SolBuroCreditoBean solBuroCreditoBean,  final String Tipo, final HttpServletRequest request, SolBuroCreditoBean solBuroCredito) {
//		taskExecutor.execute(new Runnable() {
//		public void run() {
		
		  MensajeTransaccionBean mensaje = new MensajeTransaccionBean() ;
		  SolBuroCreditoBean solicitud = new SolBuroCreditoBean();
	  
				if( Tipo == "B" ){
				
					try {
						mensaje = solBuroCreditoDAO.validacionesBuroCredito(solBuroCreditoBean);
						if(mensaje.getNumero()==0){
							
							solicitud= consultaBC(solBuroCreditoBean);
							
							solicitud.setRFC(solBuroCreditoBean.getRFC());
							solicitud.setNumTransaccion(solBuroCreditoBean.getNumTransaccion());
							solicitud.setSolicitudCreditoID(solBuroCreditoBean.getSolicitudCreditoID());
							
							if(Integer.parseInt(solicitud.getFolioConsulta())> 0){
								// Se actualiza el folio de la solicitud
								mensaje=solBuroCreditoDAO.actualizaFolioSolicitudBC(solicitud,Enum_Act_SolBuro.actFolioSol);
							}else {
								solicitud.setFolioConsulta("Error_al_consultar");
								mensaje=solBuroCreditoDAO.actualizaFolioSolicitudBC(solicitud,Enum_Act_SolBuro.actFolioSolBuro);
							}	
							
						}
					} catch (UnknownHostException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}
	
					
				}
				if( Tipo == "C" ){ 
					
					if(solBuroCreditoBean.getApellidoMaterno()		== null 	|| solBuroCreditoBean.getApellidoMaterno().isEmpty())	{solBuroCreditoBean.setApellidoMaterno("NO PROPORCIONADO");} // asi lo requiere circulo
					if(solBuroCreditoBean.getApellidoPaterno()		== null 	|| solBuroCreditoBean.getApellidoPaterno().isEmpty())	{solBuroCreditoBean.setApellidoPaterno("");}
					if(solBuroCreditoBean.getCalle()				== null 	|| solBuroCreditoBean.getCalle().isEmpty())				{solBuroCreditoBean.setCalle("");}
					if(solBuroCreditoBean.getClaveEstado()			== null 	|| solBuroCreditoBean.getClaveEstado().isEmpty())		{solBuroCreditoBean.setClaveEstado("");}
					if(solBuroCreditoBean.getCP()					== null 	|| solBuroCreditoBean.getCP().isEmpty())				{solBuroCreditoBean.setCP("");}
					if(solBuroCreditoBean.getEstadoCivil()			== null 	|| solBuroCreditoBean.getEstadoCivil().isEmpty())		{solBuroCreditoBean.setEstadoCivil("");}
					if(solBuroCreditoBean.getFechaNacimiento()		== null 	|| solBuroCreditoBean.getFechaNacimiento().isEmpty())	{solBuroCreditoBean.setFechaNacimiento("");}
					if(solBuroCreditoBean.getFolioConsultaC()		== null 	|| solBuroCreditoBean.getFolioConsultaC().isEmpty())	{solBuroCreditoBean.setFolioConsultaC("0");}
					if(solBuroCreditoBean.getNombreColonia() 		== null 	|| solBuroCreditoBean.getNombreColonia().isEmpty())		{solBuroCreditoBean.setNombreColonia("");}
					if(solBuroCreditoBean.getNombreEstado()			== null 	|| solBuroCreditoBean.getNombreEstado().isEmpty())		{solBuroCreditoBean.setNombreEstado("");}
					if(solBuroCreditoBean.getNombreMuni()			== null		|| solBuroCreditoBean.getNombreMuni().isEmpty())		{solBuroCreditoBean.setNombreMuni("");}
					if(solBuroCreditoBean.getNumeroExterior()		== null 	|| solBuroCreditoBean.getNumeroExterior().isEmpty())	{solBuroCreditoBean.setNumeroExterior("");}
					if(solBuroCreditoBean.getNumeroInterior()		== null 	|| solBuroCreditoBean.getNumeroInterior().isEmpty())	{solBuroCreditoBean.setNumeroInterior("");}
					if(solBuroCreditoBean.getPrimerNombre()			== null 	|| solBuroCreditoBean.getPrimerNombre().isEmpty())		{solBuroCreditoBean.setPrimerNombre("");}
					if(solBuroCreditoBean.getRFC()					== null 	|| solBuroCreditoBean.getRFC().isEmpty())				{solBuroCreditoBean.setRFC("");}
					if(solBuroCreditoBean.getSegundoNombre()		== null 	|| solBuroCreditoBean.getSegundoNombre().isEmpty())		{solBuroCreditoBean.setSegundoNombre("");}
					if(solBuroCreditoBean.getSolicitudCreditoID()	== null 	|| solBuroCreditoBean.getSolicitudCreditoID().isEmpty()){solBuroCreditoBean.setSolicitudCreditoID("0");}
					if(solBuroCreditoBean.getTercerNombre()			== null 	|| solBuroCreditoBean.getSegundoNombre().isEmpty())		{solBuroCreditoBean.setTercerNombre("");}

					
					
						
					try{
						SAFIServiciosServiceLocator locator = new SAFIServiciosServiceLocator();
						SAFIServicios servicio = locator.getSAFIServiciosSoap11();
						ConsultaCirculoCreditoRequest	consultaRequest			= new ConsultaCirculoCreditoRequest();
						SolicitudCreditoBean			solicitudCreditoBean	= new SolicitudCreditoBean();
						solicitudCreditoBean.setSolicitudCreditoID(solBuroCreditoBean.getSolicitudCreditoID());
						solicitudCreditoBean = solicitudCreditoDAO.consultaPrincipal(solicitudCreditoBean, SolicitudCreditoServicio.Enum_Con_SolCredito.principal);	
						
	// sandra
						// info para ejecucion real
						consultaRequest.setFolioConsultaOtorgante(solBuroCreditoBean.getSolicitudCreditoID());
						
						consultaRequest.setApellidoMaterno(solBuroCreditoBean.getApellidoMaterno());
						
						consultaRequest.setApellidoPaterno(solBuroCreditoBean.getApellidoPaterno());
						consultaRequest.setNombres(solBuroCreditoBean.getPrimerNombre()+""+solBuroCreditoBean.getSegundoNombre()+" "+solBuroCreditoBean.getTercerNombre());
						consultaRequest.setClaveUnidadMonetaria("MX");
						consultaRequest.setColoniaPoblacion(solBuroCreditoBean.getNombreColonia());
						consultaRequest.setCp(solBuroCreditoBean.getCP());
						consultaRequest.setDireccion(solBuroCreditoBean.getNumeroExterior()+" "+solBuroCreditoBean.getNumeroInterior()+" "+solBuroCreditoBean.getCalle());
						consultaRequest.setEstado(solBuroCreditoBean.getClaveEstado());// pendiente
						consultaRequest.setFechaNacimiento(solBuroCreditoBean.getFechaNacimiento());
						consultaRequest.setImporteContrato(request.getParameter("importe"));
						consultaRequest.setRfc(solBuroCreditoBean.getRFC());
						consultaRequest.setNombreUsuario(request.getParameter("usuarioCirculo"));
						consultaRequest.setPassword(request.getParameter("contrasenaCirculo"));
						consultaRequest.setDelegacionMunicipio(solBuroCreditoBean.getNombreMuni()); 
						consultaRequest.setTipoCuenta(solicitudCreditoBean.getTipoContratoCCID());
						
						if(solicitudCreditoBean.getTipoContratoCCID()		== null 	|| solicitudCreditoBean.getTipoContratoCCID().isEmpty()){
							mensaje.setNumero(999);
							mensaje.setDescripcion("El Producto de Crédito no Tiene Parametrizado un tipo de contrato.");
							throw new Exception("El Producto de Crédito no Tiene Parametrizado: Tipo de Contrato de Cículo de Crédito.");
						}
						
						consultaRequest.setImporteContrato(solicitudCreditoBean.getMontoSolici());
						
						solBuroCreditoBean.setSucursal(String.valueOf(parametrosAuditoriaBean.getSucursal()));
						
						String numeroFirma = request.getParameter("abreviaturaCirculo");
						
						numeroFirma = numeroFirma + Utileria.completaCerosIzquierda(solBuroCreditoBean.getSucursal(), 4)+
								Utileria.completaCerosIzquierda(solBuroCreditoBean.getClienteID(), 8)+
								Utileria.completaCerosIzquierda(solBuroCredito.getFolioConsultaC(), 10);
						
						consultaRequest.setNumeroFirma(numeroFirma); // pendiente
						consultaRequest.setSexo(solBuroCreditoBean.getSexo()); // pendiente
						
						consultaRequest.setCurp("");
						consultaRequest.setNacionalidad("MX");
						consultaRequest.setResidencia("");
				     	
						String varEstadoCivil =solBuroCreditoBean.getEstadoCivil();
						if(varEstadoCivil.isEmpty() || varEstadoCivil != null){
							if(varEstadoCivil.equals("CS") || varEstadoCivil.equals("CM") || varEstadoCivil.equals("CC") ){
								varEstadoCivil = "C";
							}else{
								if(varEstadoCivil.equals("U") ){
									varEstadoCivil = "L";
								}else{
									if(varEstadoCivil.equals("SE") ){
										varEstadoCivil = "E";
									}
								}
							}							
						}
						consultaRequest.setEstadoCivil(varEstadoCivil);
				     	
						consultaRequest.setClaveElectorIFE("");
						consultaRequest.setNumeroDependientes("");
						consultaRequest.setNumeroTelefono("");
						consultaRequest.setTipoDomicilio("");
						consultaRequest.setNombreEmpresa("");
						consultaRequest.setDireccionEmpleo("");
						consultaRequest.setColoniaPoblacionEmpleo("");
						consultaRequest.setDelegacionMunicipioEmpleo("");
						consultaRequest.setEstadoEmpleo("");
						consultaRequest.setCpEmpleo("");
						consultaRequest.setNumeroTelefonoEmpleo("");
						consultaRequest.setExtension("");
						consultaRequest.setPuesto("");
						consultaRequest.setSalarioMensual("");
						consultaRequest.setOrigenDatos(solBuroCreditoBean.getOrigenDatos());
							
						ConsultaCirculoCreditoResponse respuesta = servicio.consultaCirculoCredito(consultaRequest);
						
						if(respuesta != null && Integer.parseInt(respuesta.getNumMensaje()) == 0){
							solBuroCreditoBean.setFolioConsultaC(respuesta.getFolioSolicitudConsulta());
							mensaje=solBuroCreditoDAO.actualizaFolioSolicitudCC(solBuroCreditoBean,Enum_Act_SolBuro.actFolioSolCirc);
							
						 }else{
							solBuroCreditoBean.setFolioConsultaC("Error_al_consultar");
								solBuroCreditoDAO.actualizaFolioSolicitudCC(solBuroCreditoBean,Enum_Act_SolBuro.actFolioSolCircInd);
								throw new Exception(respuesta.getMensajeRespuesta());
						 }
						mensaje.setNumero(0);
					}catch(Exception e){
						e.printStackTrace();
						if(mensaje == null){
							mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(999);
							mensaje.setDescripcion("La Respuesta de Circulo de Credito fue de Error.");
						} 
						mensaje.setNumero(999);
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+e.getMessage());
					}	
				}// fin if tipo C
//				}
//			});
			
				return mensaje; 
		}
		
// ...................... Método para alta de alta solicitudes asicronas, segun sea el tipo Buró o Circuculo de Credito ............................		
	public MensajeTransaccionBean altaporSolicitud(SolBuroCreditoBean solBuroCreditoBean, HttpServletRequest request,String tipo) throws UnknownHostException, IOException{
		MensajeTransaccionBean mensaje = null;
	
		SolBuroCreditoBean solBuroCredito = new SolBuroCreditoBean();
		solBuroCredito = solBuroCreditoDAO.consultaporRFC(solBuroCreditoBean, Enum_Con_SolBuro.circuloEstatus);
		
		mensaje = solBuroCreditoDAO.altaRespuestaBuro(solBuroCreditoBean);
				
		solBuroCreditoBean.setNumTransaccion(mensaje.getConsecutivoString());
		solBuroCreditoBean.setFolioConsultaC(mensaje.getConsecutivoString());
		
		mensaje = actualizaCirculoCreditoA(solBuroCreditoBean, tipo, request, solBuroCredito);
			
		return mensaje;
			
	}

//-------------------------*********************  CIRCULO DE CREDITO **************---------------------------------------------------------------			
//.........................  Alta de solicitud Círculo de credito ........................................
	public MensajeTransaccionBean altaRespuestaCirculo(SolBuroCreditoBean solBuroCreditoBean, HttpServletRequest request) throws UnknownHostException, IOException{
		MensajeTransaccionBean mensaje = null;
		SolBuroCreditoBean	respuestaFolio = null;
		try{
			if(solBuroCreditoBean.getApellidoMaterno()== null 	|| solBuroCreditoBean.getApellidoMaterno().isEmpty())	{solBuroCreditoBean.setApellidoMaterno("NO PROPORCIONADO");} // asi lo requiere circulo
			mensaje = solBuroCreditoDAO.altaRespuestaBuro(solBuroCreditoBean);
			solBuroCreditoBean.setNumTransaccion(mensaje.getConsecutivoString());
			respuestaFolio = consultaCC(solBuroCreditoBean, request);
		
			solBuroCreditoBean.setFolioConsultaC(respuestaFolio.getFolioConsultaC());
			//solBuroCreditoBean.setFolioConsulta(respuestaFolio.getFolioConsultaC());
			// Actualización del folio de solicitud
			if(Integer.parseInt(respuestaFolio.getNumErr()) == 0){
				mensaje=actualizaciones(solBuroCreditoBean,Enum_Act_SolBuro.actFolioSolCircInd);
				mensaje.setDescripcion("Consulta Realizada,"+" Folio: "+mensaje.getConsecutivoString());
				mensaje.setCampoGenerico(mensaje.getCampoGenerico()); // Setea la fecha de la consulta para mostrarlo en pantalla 
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion(Utileria.generaLocale("Error "+respuestaFolio.getNumErr()+":"+respuestaFolio.getMensajeErr(), parametrosSesionBean.getNomCortoInstitucion()));
				mensaje.setCampoGenerico("0"); // Setea la fecha de la consulta para mostrarlo en pantalla
				mensaje.setConsecutivoInt("0");
				mensaje.setConsecutivoString("0");
			}
		}catch(NoRouteToHostException e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al conectar con el ws de Circulo de Credito \n"+ e);
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error: Verifique la Conexión con Círculo de Crédito. ");
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al conectar con el ws de Circulo de Credito \n"+ e);
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error: Verifique la Conexión con Círculo de Crédito.");
		}
		
		
		return mensaje;

	}	
	
	//................................ Metodo de consulta a Círculo de Crédito ..................................
	public SolBuroCreditoBean consultaCC(SolBuroCreditoBean solBuroCreditoBean, HttpServletRequest request) throws UnknownHostException, IOException{
		try{
			SAFIServiciosServiceLocator locator = new SAFIServiciosServiceLocator();
			SAFIServicios servicio = locator.getSAFIServiciosSoap11();
			ConsultaCirculoCreditoRequest consultaRequest= new ConsultaCirculoCreditoRequest();
			
			// info para ejecucion real
			consultaRequest.setApellidoMaterno(solBuroCreditoBean.getApellidoMaterno());
			consultaRequest.setApellidoPaterno(solBuroCreditoBean.getApellidoPaterno());
			consultaRequest.setNombres(solBuroCreditoBean.getPrimerNombre()+" "+solBuroCreditoBean.getSegundoNombre()+" "+solBuroCreditoBean.getTercerNombre());
			consultaRequest.setClaveUnidadMonetaria("MX");
			consultaRequest.setColoniaPoblacion(solBuroCreditoBean.getNombreColonia());
			consultaRequest.setCp(solBuroCreditoBean.getCP());
			consultaRequest.setDireccion(solBuroCreditoBean.getNumeroExterior()+" "+solBuroCreditoBean.getNumeroInterior()+" "+solBuroCreditoBean.getCalle());
			consultaRequest.setEstado(solBuroCreditoBean.getClaveEstado());
			consultaRequest.setFechaNacimiento(solBuroCreditoBean.getFechaNacimiento());
			consultaRequest.setImporteContrato(request.getParameter("importe"));
			consultaRequest.setRfc(solBuroCreditoBean.getRFC());
			consultaRequest.setNumeroFirma(request.getParameter("numeroFirma"));
			consultaRequest.setNombreUsuario(request.getParameter("usuarioCirculo"));
			consultaRequest.setPassword(request.getParameter("contrasenaCirculo"));
			consultaRequest.setFolioConsultaOtorgante(request.getParameter("folioConsultaOtorgante"));
			consultaRequest.setTipoCuenta(request.getParameter("tipoCuenta"));
			consultaRequest.setDelegacionMunicipio(solBuroCreditoBean.getNombreMuni());
			
			consultaRequest.setCurp("");
			consultaRequest.setNacionalidad("MX");
			consultaRequest.setResidencia("");
	     	
			String varEstadoCivil =request.getParameter("estadoCivil");
			if(varEstadoCivil.isEmpty() || varEstadoCivil != null){
				if(varEstadoCivil.equals("CS") || varEstadoCivil.equals("CM") || varEstadoCivil.equals("CC") ){
					varEstadoCivil = "C";
				}else{
					if(varEstadoCivil.equals("U") ){
						varEstadoCivil = "L";
					}else{
						if(varEstadoCivil.equals("SE") ){
							varEstadoCivil = "E";
						}
					}
				}			
				consultaRequest.setEstadoCivil(varEstadoCivil);
			}
     	
			consultaRequest.setSexo(request.getParameter("sexo"));
			consultaRequest.setClaveElectorIFE("");
			consultaRequest.setNumeroDependientes("");
			consultaRequest.setNumeroTelefono("");
			consultaRequest.setTipoDomicilio("");
			consultaRequest.setNombreEmpresa("");
			consultaRequest.setDireccionEmpleo("");
			consultaRequest.setColoniaPoblacionEmpleo("");
			consultaRequest.setDelegacionMunicipioEmpleo("");
			consultaRequest.setEstadoEmpleo("");
			consultaRequest.setCpEmpleo("");
			consultaRequest.setNumeroTelefonoEmpleo("");
			consultaRequest.setExtension("");
			consultaRequest.setPuesto("");
			consultaRequest.setSalarioMensual("");
			consultaRequest.setOrigenDatos(solBuroCreditoBean.getOrigenDatos());
			
			ConsultaCirculoCreditoResponse respuesta = servicio.consultaCirculoCredito(consultaRequest);
			
			if(Integer.parseInt(respuesta.getNumMensaje()) != 0){			
				solBuroCreditoBean.setNumErr(respuesta.getNumMensaje());
				solBuroCreditoBean.setMensajeErr(respuesta.getMensajeRespuesta());
				
			} else{
				solBuroCreditoBean.setNumErr("0");
				solBuroCreditoBean.setFolioConsultaC(respuesta.getFolioSolicitudConsulta());	
			}
			
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+e.getMessage());
		}
		return solBuroCreditoBean;
	}
			

//-------------------------*********************  BURO DE CREDITO **************---------------------------------------------------------------	
//..................... Método de Alta de solicitud buro de credito ...............................
 public MensajeTransaccionBean altaRespuesta(SolBuroCreditoBean solBuroCreditoBean) throws UnknownHostException, IOException{
	 if(solBuroCreditoBean.getApellidoMaterno()		== null 	|| solBuroCreditoBean.getApellidoMaterno().isEmpty())	{solBuroCreditoBean.setApellidoMaterno("NO PROPORCIONADO");} // asi lo requiere circulo
		
	 MensajeTransaccionBean mensaje = null;
	 SolBuroCreditoBean solBuroCredito = null;
	 SolBuroCreditoBean solBuroCreditoAct 	= new SolBuroCreditoBean(); // bean para actualizar el folio de solicitud de BC 

	 solBuroCreditoAct.setRFC(solBuroCreditoBean.getRFC());
		
	 mensaje = solBuroCreditoDAO.validacionesBuroCredito(solBuroCreditoBean);
		if(mensaje.getNumero()==0){
			mensaje = solBuroCreditoDAO.altaRespuestaBuro(solBuroCreditoBean);
			 solBuroCreditoAct.setNumTransaccion(mensaje.getConsecutivoString());
				
			 solBuroCredito = consultaBC(solBuroCreditoBean);// realiza la consulta a Buró de Credito
			
			 //validacion si el cliente esta bloqueado por error ERRR
			 if(solBuroCredito.getFolioConsulta().equalsIgnoreCase("ERRR")){
				 mensaje.setDescripcion("Error Expediente Bloqueado para Consulta.");
			 }else
			 if(solBuroCredito.getFolioConsulta().equalsIgnoreCase("ERR00")){
				 mensaje.setDescripcion("No se puede Procesar la Solicitud.");
			 }else{
			 
				 solBuroCreditoAct.setFolioConsulta(solBuroCredito.getFolioConsulta()); // setea el Folio Generado de la Consulta a BC
				 solBuroCreditoAct.setNumTransaccion(solBuroCreditoBean.getNumTransaccion());
			 
				 // Actualización del folio de solicitud
				 mensaje= actualizaciones(solBuroCreditoAct,Enum_Act_SolBuro.actFolioSolBuro);
							
				 mensaje.setDescripcion("Consulta Realizada,"+" Folio: "+mensaje.getConsecutivoString());
			 	}
			 mensaje.setCampoGenerico(mensaje.getCampoGenerico()); // Setea la fecha de la consulta para mostrarlo en pantalla
		}
	  
		return mensaje;
	}
//............... Método de consulta a Buro de Crédito .........................................
	public SolBuroCreditoBean consultaBC(SolBuroCreditoBean solBuroCreditoBean) throws UnknownHostException, IOException{
		if(solBuroCreditoBean.getApellidoMaterno()		== null 	|| solBuroCreditoBean.getApellidoMaterno().isEmpty())	{solBuroCreditoBean.setApellidoMaterno("NO PROPORCIONADO");} // asi lo requiere circulo

		SolBuroCreditoBean SolBuroCredito = new SolBuroCreditoBean();
		String cadenaFormada = armaCadenaConsultaBC(solBuroCreditoBean);
		String cadenaRespuesta = consultaBCSocket(cadenaFormada); //obtiene la Cadena de Respuesta
		
		String[] respuesta;
		//leo la cadena y la corto con el delimitador | y lo guardo en un arreglo 
		respuesta = cadenaRespuesta.split("\\|");
		String folio = respuesta[1];
		SolBuroCredito.setFolioConsulta(folio);
	
		return SolBuroCredito;
	}
//.............. Método para armar la cadena de Consulta a Buró de Crédito ...................... 		
	
	public String armaCadenaConsultaBC(SolBuroCreditoBean solBuroCreditoBean){

		String fecha = convierteFecha(solBuroCreditoBean.getFechaNacimiento());
		String CadenaFormadaBC="BC|1.0.0|||||"+
				EsNull(solBuroCreditoBean.getApellidoPaterno()).replace(',',' ')+"|"+
				EsNull(solBuroCreditoBean.getApellidoMaterno()).replace(',',' ')+"|"+
				EsNull(solBuroCreditoBean.getPrimerNombre()).replace(',',' ')+"|"+
				EsNull(solBuroCreditoBean.getSegundoNombre()).replace(',',' ')+"|"+
				EsNull(fecha)+"|"+ 
				EsNull(solBuroCreditoBean.getRFC()).replace(',',' ')+"|"+
				EsNull(solBuroCreditoBean.getCalle()).replace(',',' ')+",mz "+
				EsNull(solBuroCreditoBean.getManzana()).replace(',',' ')+",lt "+
				EsNull(solBuroCreditoBean.getLote()).replace(',',' ')+",num "+
				EsNull(solBuroCreditoBean.getNumeroExterior()).replace(',',' ')+",int "+
				EsNull(solBuroCreditoBean.getNumeroInterior()).replace(',',' ')+"*"+"|"+
				EsNull(solBuroCreditoBean.getNombreColonia()).replace(',',' ')+"|"+
				EsNull(solBuroCreditoBean.getNombreMuni()).replace(',',' ')+"|"+
				EsNull(solBuroCreditoBean.getClaveEstado()).replace(',',' ')+"|"+
				EsNull(solBuroCreditoBean.getCP()).replace(',',' ')+"|"+
				"|"+
				"|"+
				"|"+
				"|"+
				"|&*&";
		
		CadenaFormadaBC= CadenaFormadaBC.toUpperCase().replace('Ñ', 'N');
		CadenaFormadaBC = "%" + solBuroCreditoBean.getOrigenDatos() + "%"+ String.valueOf(parametrosAuditoriaBean.getUsuario()) + "%" + CadenaFormadaBC;
		loggerSAFI.debug(CadenaFormadaBC);

		//	String CadenaFormadaBC=	"ID|1.0.0|10072810163119||132|001004|LOPEZ|GUZMAN|RICARDO|MAGNO|1987/12/16||BERINSTAIN Y SAUSA, mz 0, lt 0, num 85, int 3|VIADUCTO PIEDAD|01010270|001|08200|5555909036|1||1|1|1|&*&";
		return CadenaFormadaBC;
	}
	/**
	 * Evalua y regresa una cadena vacía cuando el valor sea nulo.
	 * @param valor : Valor de un campo.
	 * @return Valor de la cadena o cadena vacía en caso de ser un volor nulo.
	 * @author avelasco
	 */
	public String EsNull(String valor){
		return (valor==null)?"":valor;
	}
// ......................... Método para la Conección a BC .............................
	public String consultaBCSocket(String cadenaBC) throws UnknownHostException, IOException{
		Socket cliente = new Socket("srvAppBC",7900);
        DataInputStream entrada = new DataInputStream(cliente.getInputStream());
        DataOutputStream salida = new DataOutputStream(cliente.getOutputStream());
      //escribir("ID|1.0.0|10072810163119||132|001004|LOPEZ|GUZMAN|RICARDO|MAGNO|1987/12/16||BERINSTAIN Y SAUSA, mz 0, lt 0, num 85, int 3|VIADUCTO PIEDAD|01010270|001|08200|5555909036|1||1|1|1|&*&",salida);
     
        recibeCadenaBC(cadenaBC,salida);
        String cadenaResultado = leeRespuestaBC("&*&", entrada);

        entrada.close();
        salida.close();
   
        return cadenaResultado;  
	}
	
//............................ Método escribir ..........................................
	public static void recibeCadenaBC(String cadena,DataOutputStream salida){
	  for (int i=0;i<cadena.length();i++){
	     try {          
	          salida.write(cadena.charAt(i));
	          
	     } catch (IOException ex) {           
	    }
	
	   }
	 }
//......................... Método para leer la respuesta de BC ................................................
  public static String leeRespuestaBC(String recibir,DataInputStream entrada){
	  String cadena = "";     
	    while(cadena.indexOf(recibir)==-1){
	      try {     
	              cadena += (char) entrada.read();
	          } catch (IOException ex) {
	     
	            }
	        }
	        return cadena;
	    }
//......... Método para cambiar el formato de la fecha de nacimiento de (aaaa-mm-dd) a (aaaa/mm/dd) .... 
   public static String convierteFecha(String fecha){
		String año= fecha.substring(0, 4);
		String mes= fecha.substring(5, 7);
		String dia= fecha.substring(8, 10);
		
		String fechaNac= año+"/"+mes+"/"+dia;
			
		return fechaNac;
	}
	 
/*----------------------------------------  R E P O R T E S ----------------------------------------------*/
//.........................  Reporte BC prpt ..............................................
	public String reporteBC(SolBuroCreditoBean solBuroCreditoBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_NomInstitucion",solBuroCreditoBean.getProgramaID());
			parametrosReporte.agregaParametro("Par_FechaConsulta",solBuroCreditoBean.getFechaConsulta());
			parametrosReporte.agregaParametro("Par_HoraConsulta",solBuroCreditoBean.getFechaActual());
			parametrosReporte.agregaParametro("Par_FolioBC",solBuroCreditoBean.getFolioConsulta());
			parametrosReporte.agregaParametro("Par_UsuarioConsulto",solBuroCreditoBean.getUsuario());
		
		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
		
//........................... Reporte BC en pdf .............................................
	public ByteArrayOutputStream reporteBCPDF(SolBuroCreditoBean solBuroCreditoBean, String nomReporte) throws Exception{
		 ParametrosReporte parametrosReporte = new ParametrosReporte();
		 int entero_uno = 1;
			parametrosReporte.agregaParametro("Par_NomInstitucion",solBuroCreditoBean.getProgramaID());
			parametrosReporte.agregaParametro("Par_FechaConsulta",solBuroCreditoBean.getFechaConsulta());
			parametrosReporte.agregaParametro("Par_HoraConsulta",solBuroCreditoBean.getFechaActual());
			parametrosReporte.agregaParametro("Par_FolioBC",solBuroCreditoBean.getFolioConsulta());
			parametrosReporte.agregaParametro("Par_UsuarioConsulto",solBuroCreditoBean.getUsuario());
			parametrosReporte.agregaParametro("Par_Consecutivo",entero_uno);
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// Reporte CC en pdf
	public ByteArrayOutputStream reporteCCPDF(SolBuroCreditoBean solBuroCreditoBean, String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomInstitucion",solBuroCreditoBean.getProgramaID());
		parametrosReporte.agregaParametro("Par_FechaConsulta",solBuroCreditoBean.getFechaConsulta());
		parametrosReporte.agregaParametro("Par_HoraConsulta",solBuroCreditoBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_NumSolicitud",solBuroCreditoBean.getFolioConsulta());
		parametrosReporte.agregaParametro("Par_UsuarioConsulto",solBuroCreditoBean.getUsuario());
		parametrosReporte.agregaParametro("Par_UsuarioCirculo",solBuroCreditoBean.getUsuarioCirculo());
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// Reporte Autorizacion Credito CC
	public ByteArrayOutputStream reporteAutorizacionPDF(SolBuroCreditoBean solBuroCreditoBean, String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomInstitucion",solBuroCreditoBean.getProgramaID());
		parametrosReporte.agregaParametro("Par_FechaConsulta",solBuroCreditoBean.getFechaConsulta());
		parametrosReporte.agregaParametro("Par_HoraConsulta",solBuroCreditoBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_NumSolicitud",solBuroCreditoBean.getFolioConsulta());
		parametrosReporte.agregaParametro("Par_UsuarioConsulto",solBuroCreditoBean.getUsuario());
		parametrosReporte.agregaParametro("Par_UsuarioCirculo",solBuroCreditoBean.getUsuarioCirculo());
		parametrosReporte.agregaParametro("Par_NombreCompleto",solBuroCreditoBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_ApellidoPaterno",solBuroCreditoBean.getApellidoPaterno());
		parametrosReporte.agregaParametro("Par_ApellidoMaterno",solBuroCreditoBean.getApellidoMaterno());
		parametrosReporte.agregaParametro("Par_PrimerNombre",solBuroCreditoBean.getPrimerNombre());
		parametrosReporte.agregaParametro("Par_SegundoNombre",solBuroCreditoBean.getSegundoNombre());
		parametrosReporte.agregaParametro("Par_TercerNombre",solBuroCreditoBean.getTercerNombre());
		parametrosReporte.agregaParametro("Par_Direccion",solBuroCreditoBean.getDireccion());
		
		parametrosReporte.agregaParametro("Par_Calle",solBuroCreditoBean.getCalle());
		parametrosReporte.agregaParametro("Par_NumeroExterior",solBuroCreditoBean.getNumeroExterior());
		parametrosReporte.agregaParametro("Par_NumeroInterior",solBuroCreditoBean.getNumeroInterior());
		parametrosReporte.agregaParametro("Par_NombreColonia",solBuroCreditoBean.getNombreColonia());
		parametrosReporte.agregaParametro("Par_NombreLocalidad",solBuroCreditoBean.getNombreLocalidad());
		parametrosReporte.agregaParametro("Par_CP",solBuroCreditoBean.getCP());
		parametrosReporte.agregaParametro("Par_Direccion",solBuroCreditoBean.getDireccion());
		parametrosReporte.agregaParametro("Par_SucursalID",solBuroCreditoBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_NumeroFirma",solBuroCreditoBean.getNumeroFirma());
		parametrosReporte.agregaParametro("Par_FechaSistema",solBuroCreditoBean.getFechaSistema());
		
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//........................... Reporte Autorizacion para Solicitar Reportes de Crédito.............................................
		public ByteArrayOutputStream reporteAutoSolRepCreditoPDF(SolBuroCreditoBean solBuroCreditoBean, String nomReporte) throws Exception{
			 ParametrosReporte parametrosReporte = new ParametrosReporte();
			 int entero_uno = 1;
			 parametrosReporte.agregaParametro("Par_PrimerNombre", solBuroCreditoBean.getPrimerNombre());
			 parametrosReporte.agregaParametro("Par_SegundoNombre", solBuroCreditoBean.getSegundoNombre());
			 parametrosReporte.agregaParametro("Par_TercerNombre", solBuroCreditoBean.getTercerNombre());
			 parametrosReporte.agregaParametro("Par_ApellidoPaterno", solBuroCreditoBean.getApellidoPaterno());
			 parametrosReporte.agregaParametro("Par_ApellidoMaterno", solBuroCreditoBean.getApellidoMaterno());
			 parametrosReporte.agregaParametro("Par_Calle", solBuroCreditoBean.getCalle());			 
			 parametrosReporte.agregaParametro("Par_Numero", solBuroCreditoBean.getNumeroExterior());
			 parametrosReporte.agregaParametro("Par_Colonia", solBuroCreditoBean.getNombreColonia());
			 parametrosReporte.agregaParametro("Par_Municipio", solBuroCreditoBean.getNombreMuni());
			 parametrosReporte.agregaParametro("Par_Estado", solBuroCreditoBean.getNombreEstado());
			 parametrosReporte.agregaParametro("Par_CP", solBuroCreditoBean.getCP());
			 parametrosReporte.agregaParametro("Par_RFC", solBuroCreditoBean.getRFC());	
			 parametrosReporte.agregaParametro("Par_SucursalID", solBuroCreditoBean.getSucursalID());
			 
			 parametrosReporte.agregaParametro("Par_TipoPersona", solBuroCreditoBean.getTipoPersona());
			 parametrosReporte.agregaParametro("Par_TelefonoCasa", solBuroCreditoBean.getTelefono());
			 parametrosReporte.agregaParametro("Par_TelefonoCelular", solBuroCreditoBean.getTelefonoCelular());
			 parametrosReporte.agregaParametro("Par_TelefonoTrabajo", solBuroCreditoBean.getTelTrabajo());
			 parametrosReporte.agregaParametro("Par_FechaConsulta", solBuroCreditoBean.getFechaConsulta());
			 parametrosReporte.agregaParametro("Par_FolioConsulta", solBuroCreditoBean.getFolioConsulta());
			
			return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
	
	
		public SolBuroCreditoDAO getSolBuroCreditoDAO() {
			return solBuroCreditoDAO;
		}

		public void setSolBuroCreditoDAO(SolBuroCreditoDAO solBuroCreditoDAO) {
			this.solBuroCreditoDAO = solBuroCreditoDAO;
		}

		public ParametrosSesionBean getParametrosSesionBean() {
			return parametrosSesionBean;
		}

		public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
			this.parametrosSesionBean = parametrosSesionBean;
		}

		public SolicitudCreditoDAO getSolicitudCreditoDAO() {
			return solicitudCreditoDAO;
		}

		public void setSolicitudCreditoDAO(SolicitudCreditoDAO solicitudCreditoDAO) {
			this.solicitudCreditoDAO = solicitudCreditoDAO;
		}

		public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
			return parametrosAuditoriaBean;
		}

		public void setParametrosAuditoriaBean(
				ParametrosAuditoriaBean parametrosAuditoriaBean) {
			this.parametrosAuditoriaBean = parametrosAuditoriaBean;
		}

}
