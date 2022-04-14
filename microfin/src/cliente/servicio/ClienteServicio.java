package cliente.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Constantes.Enum_TipoPersonaSAFI;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import pld.bean.OpeInusualesBean;
import pld.dao.LevenshteinDAO;
import pld.dao.LevenshteinDAO.Enum_Tipo_Busqueda;
import reporte.ParametrosReporte;
import reporte.Reporte;
import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.ParametrosSisBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.ParamGeneralesServicio;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;
import cliente.BeanWS.Request.ListaClienteRequest;
import cliente.BeanWS.Request.ListaClientesBERequest;
import cliente.BeanWS.Response.ListaClienteResponse;
import cliente.BeanWS.Response.ListaClientesBEResponse; 
import cliente.bean.ClienteBean;
import cliente.bean.RepSaldosSocioBean;
import cliente.bean.ReporteClienteBean;
import cliente.dao.ClienteDAO;

public class ClienteServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	ClienteDAO clienteDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	ParametrosSisServicio		parametrosSisServicio	= null;
	UsuarioServicio usuarioServicio = null;
	LevenshteinDAO levenshteinDAO = null;
	String codigo= "";

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Cliente {
		int principal 		= 1;
		int foranea 		= 2;
		int correo 			= 3;	
		int validaRFC 		= 4;
		int otraPantalla 	= 5;
		int paraInversiones = 6;		
		int resumen 		= 7;
		int pagoCred 		= 8; // consulta para pantalla pago de credito
		int tipoPersona 	= 9; // consulta para obtener tipo de persona
		int prospecClien 	= 10; // consulta para obtener tipo de persona
		int validaCURP 		= 11;
		int corporativo 	= 12;	
		int estatusCred		= 13;
		int apoyoesc		= 15;
		int calificacion	= 16;
		int validaCurpEstatus= 17;
		int consultaDatosGrid = 18;
		int consultaDatosGen	=19; 
		int principalOpeInusuales=20;
		int principalWS 		= 21;
		int asociaTarDebEntura	= 22;
		int conocimientoCte		= 23;
		int conClientePersonaFisica = 24;
		int paraAportaciones	= 25;
		int clienteConsolidadoAgro = 26;
	}
	public static interface Enum_Con_ClienteWS {
		 int conNomClien	=  2;
		 int conClienteWS   = 14;  //consulta de clientes para carga de archivos de pagos de nomina
	}
	public static interface Enum_Con_ClienteCorpRel {
		int corClienteRel =1;		
	}
	
	public static interface Enum_Lis_Cliente {
		int principal 		= 1;
		int listaSMS		= 2;
		int listaCorpRel 	= 3;
		int listaCliCorpRel = 4;//lista de Cliente relacionado a un coorporativo
		int listaSocioMenor = 5;
		int	listaNacion		= 6; //lista los clientes extranjeros
		int listaClienteWS  = 7; //lista de Clientes WS
		int listaPerFis		= 8; //lista personas fisicas con o sin actividad empresarial
		int listaActivos	= 9; //lista clientes ACtivos
		int listaInactivos	= 10; //lista clientes Inactivos
		int mayoresActivos	= 12; // lista clientes mayores de edad activos, usado en pantalla de historico de cartera por cliente
		int paraTutores		= 13; // lista solo clientes que pueden ser tutores
		int mayoresEdad		= 14; // lista clientes mayores de edad
		int reactivacionCte	= 15; // lista clientes para pagar y reactivar en ventanilla
		int CtePorSucural	= 16; //Lista los clientes que pertenecen a una sucursal
		
		int CteSucursal		= 19;// Lista 1
		int mayoresActSuc	= 20;// Lista 12
		int listaNacionSuc	= 21;// Lista 6
		int lisInactivosSuc = 22;// Lista 10
		int lisSocioMenorSuc= 23;// Lista 5
		int listaPerFisSuc  = 24;// Lista 8
		int listaActivosSuc = 25;// Lista 9
		int lisMayoresSuc   = 26;// Lista 14
		int lisReacCteSuc	= 27;// Lista 15
		int listaSMSSuc		= 28;// Lista 2
		int listaCorpRelSuc	= 29;// Lista 3
		int listaCancela	= 30;// Lista 3
		int lisCteVentanilla= 31;// Lista Principal para el Modulo de Ventanilla.
		int lisReacCteSucVen= 32;// Lista para la Pantalla de Ventanilla(Lista 15 en las demas pantallas)
		int lisCteExterno   = 33;// Lista externa para pantallas sin logeo
		int lisDepGaranGene	= 34;
		int lisDepGaranSuc	= 35;
		int listaActInact	= 36;
		int listaSeido		= 37;// Lista de clientes para busqueda de persona SEIDO
		int listaCliMoral	= 38;// Lista de clientes de tipo Persona Moral
		int lisCliBitaDomi	= 39;// Lista de clientes de bitacora de pagos domiciliados
		int listaCliAport	= 40;// Lista de clientes para alta de aportaciones
		int clienteConsolidadoAgro	= 41;// Lista de clientes para alta de aportaciones
		
	}
	
	public static interface Enum_Tra_Cliente {
		int alta		 = 1;
		int modificacion = 2;
		int actualiza	 = 3;
		int altaWS 		 = 4;
		int activa		 = 5;
		int inactiva	 = 6;
		int actualizaPromotor = 7;

	}


	public static interface Enum_Con_CicloBaseIni {
		int principal = 1;
	}
	
	public ClienteServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ClienteBean cliente){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Cliente.alta:		
				mensaje = altaCliente(cliente);				
				break;				
			case Enum_Tra_Cliente.modificacion:
				mensaje = modificaCliente(cliente);				
				break;
			case Enum_Tra_Cliente.actualiza:
				mensaje = actualizaCliente(cliente, Enum_Tra_Cliente.actualiza);				
				break;
			case Enum_Tra_Cliente.activa:
				mensaje = activaInactivaCliente(cliente, Enum_Tra_Cliente.activa);				
				break;
			case Enum_Tra_Cliente.inactiva:
				mensaje = activaInactivaCliente(cliente, Enum_Tra_Cliente.inactiva);
				break;
			case Enum_Tra_Cliente.actualizaPromotor:
				mensaje = actualizaPromotorActual(cliente, Enum_Tra_Cliente.actualizaPromotor);				
				break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaCliente(ClienteBean cliente){
		MensajeTransaccionBean mensaje = null;
		
		mensaje = altaClientes(cliente);
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaCliente(ClienteBean cliente){
		MensajeTransaccionBean mensaje = null;
		
		mensaje = modificaClientes(cliente);
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizaCliente(ClienteBean cliente,  int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		mensaje = clienteDAO.actualizaCliente(cliente, tipoTransaccion);

		return mensaje;
	}
	
	public MensajeTransaccionBean activaInactivaCliente(ClienteBean cliente, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		UsuarioBean usuarioBean = new UsuarioBean();
		/* Validar password */
		String passValidaUser = null;
		String presentedPassword = cliente.getContraseniaUsu();
		/* -- -----------------------------------------------------------------
		 *  Consulta para otener la clave del usuario sin importar si es mayuscula o minuscula
		 * -- -----------------------------------------------------------------
		 */	
		usuarioBean.setClave(cliente.getClaveUsuAuto());
		usuarioBean= usuarioServicio.consulta(Enum_Con_Usuario.clave,usuarioBean);
		if(usuarioBean == null){
			mensaje = new MensajeTransaccionBean();
    		mensaje.setNumero(404);
    		mensaje.setDescripcion("Usuario Invalido");
    		
    		return mensaje;
		}
		cliente.setClaveUsuAuto(usuarioBean.getClave());	
        if(presentedPassword.contains("HD>>")){
        	loggerSAFI.info("SAFIHUELLAS: "+cliente.getClaveUsuAuto()+"-  Inicia Validacion de Token de Huella [activaInactivaCliente]");
        	presentedPassword = presentedPassword.replace("HD>>", "");
        	cliente.setContraseniaUsu(SeguridadRecursosServicio.encriptaPass(cliente.getClaveUsuAuto(), presentedPassword));
        	passValidaUser = SeguridadRecursosServicio.generaTokenHuella(cliente.getClaveUsuAuto());
        	        	
        	if(cliente.getContraseniaUsu().equals(passValidaUser)){       		
        		cliente.setContraseniaUsu(usuarioBean.getContrasenia());
        		mensaje = clienteDAO.activaInactivaCliente(cliente, tipoTransaccion);
        	}else{
        		mensaje = new MensajeTransaccionBean();
        		mensaje.setNumero(405);
        		mensaje.setDescripcion("Token Huella Invalida");
        	}
        	loggerSAFI.info("SAFIHUELLAS: "+cliente.getClaveUsuAuto()+"-  Fin Validacion de Token de Huella [activaInactivaCliente]");
        }else{
        	cliente.setContraseniaUsu(SeguridadRecursosServicio.encriptaPass(cliente.getClaveUsuAuto(), cliente.getContraseniaUsu()));        	
        	mensaje = clienteDAO.activaInactivaCliente(cliente, tipoTransaccion);
        }		
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizaPromotorActual(ClienteBean cliente, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		mensaje = clienteDAO.actualizaPromotorActual(cliente, tipoTransaccion);		
		return mensaje;
	}

	public ClienteBean consulta(int tipoConsulta, String numeroCliente, String RFC){
		ClienteBean cliente = null;
		switch (tipoConsulta) {
			case Enum_Con_Cliente.principal:		
				cliente = clienteDAO.consultaPrincipal(Utileria.convierteEntero(numeroCliente), tipoConsulta);				
				break;	
			case Enum_Con_Cliente.principalWS:		
				cliente = clienteDAO.consultaPrincipalWS(Utileria.convierteEntero(numeroCliente), Enum_Con_Cliente.principal);				
				break;	
			case Enum_Con_Cliente.foranea:
				cliente = clienteDAO.consultaForanea(Utileria.convierteEntero(numeroCliente), tipoConsulta);
				break;
			case Enum_Con_Cliente.correo:
				cliente = clienteDAO.consultaParaEnvioCorreo(Utileria.convierteEntero(numeroCliente), tipoConsulta);
				break;				
			case Enum_Con_Cliente.validaRFC:
				cliente = clienteDAO.validaClienteRFC(RFC, tipoConsulta);
				break;
			case Enum_Con_Cliente.otraPantalla:
                cliente = clienteDAO.consultaOtraPantalla(Utileria.convierteEntero(numeroCliente), tipoConsulta);
                break;
			case Enum_Con_Cliente.paraInversiones:
                cliente = clienteDAO.consultaParaInversiones(Utileria.convierteEntero(numeroCliente), tipoConsulta);
                break;
			case Enum_Con_Cliente.resumen:
                cliente = clienteDAO.consultaResumenCte(Integer.parseInt(numeroCliente), tipoConsulta);
                break; 
			case Enum_Con_Cliente.pagoCred:
                cliente = clienteDAO.consultaPagoCredito(Integer.parseInt(numeroCliente), tipoConsulta);
                break;
			case Enum_Con_Cliente.tipoPersona:
				cliente = clienteDAO.consultaTipoPersona(Integer.parseInt(numeroCliente), tipoConsulta);
				break;
			case Enum_Con_Cliente.prospecClien:
				cliente = clienteDAO.consultaProspectoCliente(Integer.parseInt(numeroCliente), tipoConsulta);
				break;	
			case Enum_Con_Cliente.validaCURP:
				cliente = clienteDAO.validaClienteCURP(RFC, tipoConsulta);
				break;	
			case Enum_Con_Cliente.corporativo://solo necesito nombre del corportativo
				cliente = clienteDAO.consultaForanea(Integer.parseInt(numeroCliente), tipoConsulta);
				break;
			case Enum_Con_Cliente.apoyoesc:
				cliente = clienteDAO.consultaCliente(Integer.parseInt(numeroCliente), tipoConsulta);
				break;
			case Enum_Con_Cliente.calificacion:
				cliente = clienteDAO.consultaCalificacion(Integer.parseInt(numeroCliente), tipoConsulta);
				break;
			case Enum_Con_Cliente.validaCurpEstatus:
				cliente = clienteDAO.consultaCURPESTATUS(Integer.parseInt(numeroCliente), tipoConsulta);
				break;
			case Enum_Con_Cliente.consultaDatosGrid:
				cliente = clienteDAO.consultaDatosGrid(Integer.parseInt(numeroCliente), tipoConsulta);
				break;
			case Enum_Con_Cliente.consultaDatosGen:
				cliente = clienteDAO.consultaDatosGenerales(Integer.parseInt(numeroCliente), tipoConsulta);
				break;
			case Enum_Con_Cliente.principalOpeInusuales:
				cliente = clienteDAO.consultaPrincipalOpeInusuales(Integer.parseInt(numeroCliente), 1, RFC);				
				break;	
			case Enum_Con_Cliente.asociaTarDebEntura:		
				cliente = clienteDAO.consultaTarDebEntura(Utileria.convierteEntero(numeroCliente), tipoConsulta);				
				break;
			case Enum_Con_Cliente.conocimientoCte:		
				cliente = clienteDAO.consultaConocimientoCte(Utileria.convierteEntero(numeroCliente), tipoConsulta);				
				break;	
			case Enum_Con_Cliente.conClientePersonaFisica:
				cliente = clienteDAO.consultaClientePersonaFisica(Utileria.convierteEntero(numeroCliente), tipoConsulta);
				break;
			case Enum_Con_Cliente.paraAportaciones:
                cliente = clienteDAO.consultaAportaciones(Utileria.convierteEntero(numeroCliente), tipoConsulta);
            break;
			case Enum_Con_Cliente.clienteConsolidadoAgro:
                cliente = clienteDAO.consultaForanea(Utileria.convierteEntero(numeroCliente), tipoConsulta);
            break;
		}
		if(cliente!=null){
			cliente.setNumero(Utileria.completaCerosIzquierda(cliente.getNumero(), 7));
		}
		
		return cliente;
	}
	
	public ClienteBean consultaCorp(int tipoConsulta, String numeroCorp,String numeroCliente ){
		ClienteBean cliente = null;
		switch (tipoConsulta) {
			case Enum_Con_ClienteCorpRel.corClienteRel://solo necesito nombre del corportativo
				cliente = clienteDAO.consultaCorpRel(Integer.parseInt(numeroCorp),Integer.parseInt(numeroCliente),tipoConsulta);
				break;
		
		}
		if(cliente!=null){
			cliente.setNumero(Utileria.completaCerosIzquierda(cliente.getNumero(), 7));
		}
		
		return cliente;
	}
	
	public ClienteBean consultaEsta(int tipoConsulta, ClienteBean clienteBean){
		ClienteBean cliente = null;
		switch (tipoConsulta) {
		case Enum_Con_Cliente.estatusCred:
			cliente = clienteDAO.consultaEstatusCred(clienteBean, tipoConsulta);
			break;
		}		
		return cliente;
	}
	
	// Consulta de Clientes para carga de archivos de pagos de nomina
	public ClienteBean consultaWS(int tipoConsulta, ClienteBean clienteBean){
		ClienteBean cliente = null;
		switch (tipoConsulta) {
		case Enum_Con_ClienteWS.conClienteWS:
			cliente = clienteDAO.consultaClienteWS(clienteBean, tipoConsulta);
			break;
		case Enum_Con_ClienteWS.conNomClien:
			cliente = clienteDAO.consultaNombreCliente(clienteBean);
			break;
		}		
		return cliente;
	}
	
	
	public ClienteBean formaRFC(ClienteBean clienteb){
		ClienteBean cliente = null;
		cliente = clienteDAO.formaClienteRFC(clienteb);
				
		return cliente;
	}
	
	public ClienteBean consultaRFC(int tipoConsulta, String RFC){
		ClienteBean cliente = null;
		cliente = clienteDAO.validaClienteRFC(RFC, tipoConsulta);
				
		return cliente;
	}
	
	public ClienteBean formaCURP(ClienteBean clienteb){
		ClienteBean cliente = null;
		cliente = clienteDAO.formaClienteCURP(clienteb);
				
		return cliente;
	}
	
	public ClienteBean consultaCURP(int tipoConsulta, String CURP){
		ClienteBean cliente = null;
		cliente = clienteDAO.validaClienteCURP(CURP, tipoConsulta);
				
		return cliente;
	}
	
	
	public List lista(int tipoLista, ClienteBean cliente){		
		List listaClientes = null;
		switch (tipoLista) {
			case Enum_Lis_Cliente.principal:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaSMS:		
				listaClientes = clienteDAO.listaSMS(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaCorpRel:		
				listaClientes = clienteDAO.listaCorpRelacionado(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaCliCorpRel:		
				listaClientes = clienteDAO.listaClienteRelCorp(cliente, tipoLista);				
				break;		
			case Enum_Lis_Cliente.listaSocioMenor:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaNacion:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaPerFis:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaActivos:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaInactivos:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.mayoresActivos:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.paraTutores:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.mayoresEdad:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.reactivacionCte:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.CtePorSucural:		
				listaClientes = clienteDAO.listaCtePorSucural(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.CteSucursal:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.mayoresActSuc:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaNacionSuc:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.lisInactivosSuc:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.lisSocioMenorSuc:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaPerFisSuc:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaActivosSuc:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.lisMayoresSuc:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.lisReacCteSuc:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.listaSMSSuc:		
				listaClientes = clienteDAO.listaSMSBotones(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaCorpRelSuc:		
				listaClientes = clienteDAO.listaCorpRelacionadoBotones(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaCancela:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);	
				break;
			case Enum_Lis_Cliente.lisCteVentanilla:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.lisReacCteSucVen:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.lisCteExterno:		
				listaClientes = clienteDAO.listaPriExterna(cliente, tipoLista);				
				break;		
			case Enum_Lis_Cliente.lisDepGaranGene:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.lisDepGaranSuc:		
				listaClientes = clienteDAO.listaPrincipalVentanilla(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.listaActInact:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaSeido:		
				listaClientes = clienteDAO.listaSeido(cliente, tipoLista);				
				break;	
			case Enum_Lis_Cliente.listaCliMoral:		
				listaClientes = clienteDAO.listaClienteMoral(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.listaCliAport:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);				
				break;
			case Enum_Lis_Cliente.lisCliBitaDomi:		
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);
			break;
			case Enum_Lis_Cliente.clienteConsolidadoAgro:
				listaClientes = clienteDAO.listaPrincipal(cliente, tipoLista);
			break;
		}
		return listaClientes;
	}
	
	//alta de cleintes
	public MensajeTransaccionBean altaClientes(ClienteBean cliente){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajePLD = null;
		OpeInusualesBean pldListasBean = new OpeInusualesBean();
		ClienteBean clienteBean = new ClienteBean();
		long numTransaccion = clienteDAO.getNumTransaccion();

		//llenamos el bean dependiendo del tipo de persona
		if(cliente.getTipoPersona().equals("M")){
			clienteBean.setCorreo(cliente.getCorreoPM());
			clienteBean.setFea(cliente.getFeaPM());
			clienteBean.setPaisFea(cliente.getPaisFeaPM());
			clienteBean.setTelefonoCasa(cliente.getTelefonoPM());
			clienteBean.setExtTelefonoPart(cliente.getExtTelefonoPM());
			clienteBean.setFechaConstitucion(cliente.getFechaRegistroPM());
			clienteBean.setNacion(cliente.getNacionalidadPM());
			cliente.setObservaciones(cliente.getObservacionesPM());

			pldListasBean.setPrimerNombre(Constantes.STRING_VACIO);
			pldListasBean.setSegundoNombre(Constantes.STRING_VACIO);
			pldListasBean.setTercerNombre(Constantes.STRING_VACIO);
			pldListasBean.setApPaternoPersonaInv(Constantes.STRING_VACIO);
			pldListasBean.setApMaternoPersonaInv(Constantes.STRING_VACIO);
			pldListasBean.setrFC(cliente.getRFCpm());
			pldListasBean.setFechaNacimiento(Constantes.FECHA_VACIA);
			pldListasBean.setPaisID(Constantes.STRING_CERO);
			pldListasBean.setEstadoID(Constantes.STRING_CERO);
			pldListasBean.setNombreCompleto(cliente.getRazonSocial());
			pldListasBean.setTipoPersona(cliente.getTipoPersona());

		}else{
			clienteBean.setCorreo(cliente.getCorreo());
			clienteBean.setFea(cliente.getFea());
			clienteBean.setPaisFea(cliente.getPaisFea());
			clienteBean.setTelefonoCasa(cliente.getTelefonoCasa());
			clienteBean.setExtTelefonoPart(cliente.getExtTelefonoPart());
			clienteBean.setFechaConstitucion(cliente.getFechaConstitucion());
			clienteBean.setNacion(cliente.getNacion());

			pldListasBean.setPrimerNombre(cliente.getPrimerNombre());
			pldListasBean.setSegundoNombre(cliente.getSegundoNombre());
			pldListasBean.setTercerNombre(cliente.getTercerNombre());
			pldListasBean.setApPaternoPersonaInv(cliente.getApellidoPaterno());
			pldListasBean.setApMaternoPersonaInv(cliente.getApellidoMaterno());
			pldListasBean.setrFC(cliente.getRFC());
			pldListasBean.setFechaNacimiento(cliente.getFechaNacimiento());
			pldListasBean.setPaisID(cliente.getLugarNacimiento());
			pldListasBean.setEstadoID(cliente.getEstadoID());
			pldListasBean.setNombreCompleto(cliente.getPrimerNombre()+cliente.getSegundoNombre()+cliente.getTercerNombre()+cliente.getApellidoPaterno()+cliente.getApellidoMaterno());
			pldListasBean.setTipoPersona("F");
		}

		pldListasBean.setClavePersonaInv(Constantes.STRING_CERO);
		pldListasBean.setTipoPersonaSAFI(Enum_TipoPersonaSAFI.NoAplica);
		pldListasBean.setCuentaAhoID(Constantes.STRING_CERO);
		
		// Se busca únicamente en listas de personas bloqueadas.
		mensajePLD = levenshteinDAO.validaListasPLD(pldListasBean, numTransaccion, Enum_Tipo_Busqueda.enListasPersBloq);
		if(mensajePLD.getNumero() == Constantes.DETECCION_PLD){
			return mensajePLD;
		}

		// Alta de cliente.
		mensaje = clienteDAO.altaCliente(cliente,clienteBean);
		if(mensaje.getNumero() != Constantes.ENTERO_CERO){
			return mensaje;
		}

		// Una vez que el cliente se dió de alta, se busca en listas negras.
		pldListasBean.setClavePersonaInv(mensaje.getConsecutivoString());
		pldListasBean.setTipoPersonaSAFI(Enum_TipoPersonaSAFI.Cliente);
		mensajePLD = levenshteinDAO.validaListasPLD(pldListasBean, numTransaccion, Enum_Tipo_Busqueda.enListasNegras);

		return mensaje;
	}
	
	public MensajeTransaccionBean modificaClientes(ClienteBean cliente){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajePLD = null;
		OpeInusualesBean pldListasBean = new OpeInusualesBean();
		ClienteBean clienteBean = new ClienteBean();
		long numTransaccion = clienteDAO.getNumTransaccion();

		//llenamos el bean dependiendo del tipo de persona
		if(cliente.getTipoPersona().equals("M")){
			clienteBean.setCorreo(cliente.getCorreoPM());
			clienteBean.setFea(cliente.getFeaPM());
			clienteBean.setPaisFea(cliente.getPaisFeaPM());
			clienteBean.setTelefonoCasa(cliente.getTelefonoPM());
			clienteBean.setExtTelefonoPart(cliente.getExtTelefonoPM());
			clienteBean.setFechaConstitucion(cliente.getFechaRegistroPM());
			clienteBean.setNacion(cliente.getNacionalidadPM());
			cliente.setObservaciones(cliente.getObservacionesPM());

			pldListasBean.setPrimerNombre(Constantes.STRING_VACIO);
			pldListasBean.setSegundoNombre(Constantes.STRING_VACIO);
			pldListasBean.setTercerNombre(Constantes.STRING_VACIO);
			pldListasBean.setApPaternoPersonaInv(Constantes.STRING_VACIO);
			pldListasBean.setApMaternoPersonaInv(Constantes.STRING_VACIO);
			pldListasBean.setrFC(cliente.getRFCpm());
			pldListasBean.setFechaNacimiento(Constantes.FECHA_VACIA);
			pldListasBean.setPaisID(Constantes.STRING_CERO);
			pldListasBean.setEstadoID(Constantes.STRING_CERO);
			pldListasBean.setNombreCompleto(cliente.getRazonSocial());
			pldListasBean.setTipoPersona(cliente.getTipoPersona());
		}else{
			clienteBean.setCorreo(cliente.getCorreo());
			clienteBean.setFea(cliente.getFea());
			clienteBean.setPaisFea(cliente.getPaisFea());
			clienteBean.setTelefonoCasa(cliente.getTelefonoCasa());
			clienteBean.setExtTelefonoPart(cliente.getExtTelefonoPart());
			clienteBean.setFechaConstitucion(cliente.getFechaConstitucion());
			clienteBean.setNacion(cliente.getNacion());

			pldListasBean.setPrimerNombre(cliente.getPrimerNombre());
			pldListasBean.setSegundoNombre(cliente.getSegundoNombre());
			pldListasBean.setTercerNombre(cliente.getTercerNombre());
			pldListasBean.setApPaternoPersonaInv(cliente.getApellidoPaterno());
			pldListasBean.setApMaternoPersonaInv(cliente.getApellidoMaterno());
			pldListasBean.setrFC(cliente.getRFC());
			pldListasBean.setFechaNacimiento(cliente.getFechaNacimiento());
			pldListasBean.setPaisID(cliente.getLugarNacimiento());
			pldListasBean.setEstadoID(cliente.getEstadoID());
			pldListasBean.setNombreCompleto(cliente.getPrimerNombre()+cliente.getSegundoNombre()+cliente.getTercerNombre()+cliente.getApellidoPaterno()+cliente.getApellidoMaterno());
			pldListasBean.setTipoPersona("F");
		}
		pldListasBean.setClavePersonaInv(cliente.getNumero());
		pldListasBean.setTipoPersonaSAFI(Enum_TipoPersonaSAFI.Cliente);
		pldListasBean.setCuentaAhoID(Constantes.STRING_CERO);


		// Se busca únicamente en listas de personas bloqueadas.
		mensajePLD = levenshteinDAO.validaListasPLD(pldListasBean, numTransaccion, Enum_Tipo_Busqueda.enListasPersBloq);
		if(mensajePLD.getNumero() == Constantes.DETECCION_PLD){
			return mensajePLD;
		}

		// Modificación del cliente.
		mensaje = clienteDAO.modificaCliente(cliente, clienteBean);
		if(mensaje.getNumero() != Constantes.ENTERO_CERO){
			return mensaje;
		}

		// Una vez que el cliente se dió de alta, se busca en listas negras.
		mensajePLD = levenshteinDAO.validaListasPLD(pldListasBean, numTransaccion, Enum_Tipo_Busqueda.enListasNegras);
		
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean.setEmpresaID("1");
		parametrosSisBean = parametrosSisServicio.consulta(1, parametrosSisBean);
		
		if(mensaje.getNumero() == 0 ) {
			if(parametrosSisBean.getReplicaAct().equalsIgnoreCase("S")) {
				mensaje = clienteDAO.modificaClienteReplica(cliente, clienteBean, parametrosSisBean.getOrigenReplica());
			}
		}
		
		return mensaje;
		
	}

/* Funciones para Reportes de cliente*/
	
	// Reporte de Perfil de Cliente a PDF
	public ByteArrayOutputStream reportePerfilClientePDF(ReporteClienteBean reporteClienteBean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(reporteClienteBean.getClienteID())  );
		parametrosReporte.agregaParametro("Par_NombreInstitucion", reporteClienteBean.getNombreInstitucion()  );
		parametrosReporte.agregaParametro("Par_FechaSistema",reporteClienteBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_NombreSucursal",reporteClienteBean.getNombreSucursal() );
		parametrosReporte.agregaParametro("Par_Usuario",reporteClienteBean.getNombreUsuario());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

	}
	
	// Reporte de Saldos Socios  PDF
		public ByteArrayOutputStream reporteSaldosSociosPDF(RepSaldosSocioBean reporteClienteBean , String nomReporte) throws Exception{
			
			ParametrosReporte parametrosReporte = new ParametrosReporte();

			parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(reporteClienteBean.getClienteID() )  );
			parametrosReporte.agregaParametro("Par_NomInstitucion", reporteClienteBean.getNombreInstitucion()  );
			parametrosReporte.agregaParametro("Par_FechaEmision",reporteClienteBean.getFechaSistema());
			parametrosReporte.agregaParametro("Par_CreditoID",Utileria.convierteLong(reporteClienteBean.getCreditoID() )  );

			return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

		}
		
	// Reporte de Perfil de Cliente a PDF
	public ByteArrayOutputStream reporteDireccionesClientePDF(ReporteClienteBean reporteClienteBean , String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(reporteClienteBean.getClienteID() )  );
		parametrosReporte.agregaParametro("Par_NomInstitucion", reporteClienteBean.getNombreInstitucion()  );
		parametrosReporte.agregaParametro("Par_FechaEmision",reporteClienteBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_NomSucursal",reporteClienteBean.getNombreSucursal() );
		parametrosReporte.agregaParametro("Par_NomUsuario",reporteClienteBean.getNombreUsuario());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		

	}

	// Reporte de Perfil de Cliente a Pantalla
	public String reportePerfilCtePantalla(ReporteClienteBean reporteClienteBean , String nomReporte) throws Exception{
		
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(reporteClienteBean.getClienteID() )  );
		parametrosReporte.agregaParametro("Par_NombreInstitucion", reporteClienteBean.getNombreInstitucion()  );
		parametrosReporte.agregaParametro("Par_FechaSistema",reporteClienteBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_NombreSucursal",reporteClienteBean.getNombreSucursal() );
		parametrosReporte.agregaParametro("Par_Usuario",reporteClienteBean.getNombreUsuario());
				
		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		

	} // fin metodos para reporte
	
	
	
/* Funciones para Reportes de Estadistico del cliente*/
	
	// Reporte de Perfil de Cliente a PDF
		public ByteArrayOutputStream reporteEstadisticoClientePDF(ReporteClienteBean reporteClienteBean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();

 		
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(reporteClienteBean.getSucursalID()) );
		parametrosReporte.agregaParametro("Par_PromotorID",Utileria.convierteEntero(reporteClienteBean.getPromotorID()) );
		parametrosReporte.agregaParametro("Par_EstadoID", Utileria.convierteEntero(reporteClienteBean.getEstadoID()));
		parametrosReporte.agregaParametro("Par_MunicipioID", Utileria.convierteEntero(reporteClienteBean.getMunicipioID()));
		parametrosReporte.agregaParametro("Par_Genero",reporteClienteBean.getGenero() );
		
		parametrosReporte.agregaParametro("Par_NombreSucursal",!reporteClienteBean.getNombreSucursal().isEmpty()?reporteClienteBean.getNombreSucursal():"TODAS" );
		parametrosReporte.agregaParametro("Par_NombrePromotor",!reporteClienteBean.getNombrePromotor().isEmpty()?reporteClienteBean.getNombrePromotor():"TODOS" );
		parametrosReporte.agregaParametro("Par_NombreGenero", !reporteClienteBean.getNombreGenero().isEmpty()?reporteClienteBean.getNombreGenero():"TODOS");
		parametrosReporte.agregaParametro("Par_NombreEstado", !reporteClienteBean.getNombreEstado().isEmpty()?reporteClienteBean.getNombreEstado():"TODOS");
		parametrosReporte.agregaParametro("Par_NombreMunicipio", !reporteClienteBean.getNombreMunicipio().isEmpty()?reporteClienteBean.getNombreMunicipio():"TODOS");
		parametrosReporte.agregaParametro("Par_FechaSistema", reporteClienteBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_Usuario", reporteClienteBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",reporteClienteBean.getNombreInstitucion());
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());


		}

	// Reporte de Perfil de Cliente a Pantalla
	public String reporteEstadisticoPantalla(ReporteClienteBean reporteClienteBean , String nomReporte) throws Exception{
		
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(reporteClienteBean.getSucursalID()) );
		parametrosReporte.agregaParametro("Par_PromotorID",Utileria.convierteEntero(reporteClienteBean.getPromotorID()) );
		parametrosReporte.agregaParametro("Par_EstadoID", Utileria.convierteEntero(reporteClienteBean.getEstadoID()));
		parametrosReporte.agregaParametro("Par_MunicipioID", Utileria.convierteEntero(reporteClienteBean.getMunicipioID()));
		parametrosReporte.agregaParametro("Par_Genero",reporteClienteBean.getGenero() );
		
		parametrosReporte.agregaParametro("Par_NombreSucursal",!reporteClienteBean.getNombreSucursal().isEmpty()?reporteClienteBean.getNombreSucursal():"TODAS" );
		parametrosReporte.agregaParametro("Par_NombrePromotor",!reporteClienteBean.getNombrePromotor().isEmpty()?reporteClienteBean.getNombrePromotor():"TODOS" );
		parametrosReporte.agregaParametro("Par_NombreGenero", !reporteClienteBean.getNombreGenero().isEmpty()?reporteClienteBean.getNombreGenero():"TODOS");
		parametrosReporte.agregaParametro("Par_NombreEstado", !reporteClienteBean.getNombreEstado().isEmpty()?reporteClienteBean.getNombreEstado():"TODOS");
		parametrosReporte.agregaParametro("Par_NombreMunicipio", !reporteClienteBean.getNombreMunicipio().isEmpty()?reporteClienteBean.getNombreMunicipio():"TODOS");
		parametrosReporte.agregaParametro("Par_FechaSistema", reporteClienteBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_Usuario", reporteClienteBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",reporteClienteBean.getNombreInstitucion());
		
		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		

	} // fin metodos para reporte
	

	public ByteArrayOutputStream reporteSolicitudIngresoPDF(ReporteClienteBean reporteClienteBean,
            String nombreReporte) throws Exception{
                ParametrosReporte parametrosReporte = new ParametrosReporte();
                parametrosReporte.agregaParametro("Par_SoliCredID","0");
                parametrosReporte.agregaParametro("Par_NombreInstitucion", reporteClienteBean.getNombreInstitucion()  );
                parametrosReporte.agregaParametro("Par_Sucursal",reporteClienteBean.getSucursalID());
                parametrosReporte.agregaParametro("Par_FechaEmision",reporteClienteBean.getFechaSistema());
                parametrosReporte.agregaParametro("Par_ClienteID",reporteClienteBean.getClienteID());
                return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
    }
	
	public ByteArrayOutputStream reporteSolicitudIngresoMenorPDF(ReporteClienteBean reporteClienteBean, 
			String nombreReporte) throws Exception{

			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(reporteClienteBean.getClienteID()));
			parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(reporteClienteBean.getSucursalID()));
			
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			
	
	}
	
		/// Reporte de Identificación del Cliente en PDF
	
	public ByteArrayOutputStream reporteIdentClientePDF(ReporteClienteBean reporteClienteBean, String nombreReporte) throws Exception{
	
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_ClienteID",reporteClienteBean.getClienteID());
		parametrosReporte.agregaParametro("Par_UsuarioLog",reporteClienteBean.getPromotorID());
		parametrosReporte.agregaParametro("Par_NombreSucursal",reporteClienteBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_Usuario",reporteClienteBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_FechaSistema",reporteClienteBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_DireccionSucursal",reporteClienteBean.getDireccionSucursal());
	
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		 

	}

		/// Reporte de Clientes Por Promotor
		
	public ByteArrayOutputStream reporteClientePorPromotor(ClienteBean clienteBean, HttpServletRequest request,String nombreReporte) throws Exception{
	
		ParametrosReporte parametrosReporte = new ParametrosReporte();	
		parametrosReporte.agregaParametro("Par_SucursalID",clienteBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_PromotorID",clienteBean.getPromotorAct());
		parametrosReporte.agregaParametro("Par_Genero",clienteBean.getSexo());
		parametrosReporte.agregaParametro("Par_CreditoEst",clienteBean.getEstatus());
		parametrosReporte.agregaParametro("Par_EstadoID",clienteBean.getEstadoID());
		parametrosReporte.agregaParametro("Par_MunicipioID",request.getParameter("municipioID"));
				
		parametrosReporte.agregaParametro("Par_NombreSucursal",clienteBean.getNombSucursal());
		parametrosReporte.agregaParametro("Par_ClaveUsuario",request.getParameter("clave"));
		parametrosReporte.agregaParametro("Par_FechaEmision",clienteBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_DireccionInstitucion",clienteBean.getDireccion());		
		parametrosReporte.agregaParametro("Par_NombreInstitucion",request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NombreEstado",request.getParameter("nombreEstado"));
		parametrosReporte.agregaParametro("Par_NombreMunicipio",request.getParameter("nombreMunicipio"));
		parametrosReporte.agregaParametro("Par_NombrePromotor",request.getParameter("nombrePromotor"));

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		 

	}
	
	private String creaCadenaCLientes(List  listaClientes){
		String resultadoCliente = "";
	    String separadorCampos = "[";  
	    String separadorRegistros = "]";
 
        ClienteBean clienteBean;
	    if(listaClientes != null) {   
	        Iterator<ClienteBean> it = listaClientes.iterator();
	        while(it.hasNext()){    
	        	clienteBean = (ClienteBean)it.next();
	        	resultadoCliente += clienteBean.getClienteID() + separadorCampos +
	        						clienteBean.getNombreCompleto() + separadorRegistros;
	        }
	    }
	    if(resultadoCliente.length() != 0){
	    	resultadoCliente = resultadoCliente.substring(0,resultadoCliente.length()-1);
	    }
	    return resultadoCliente;
    }

	public Object listaClientesBEWS(ListaClientesBERequest listaClientesBERequest){
		Object obj= null;
		String cadena= "";

		ListaClientesBEResponse listaClientesBEResponse=new ListaClientesBEResponse();
		List<ListaClientesBEResponse> lisClientes = clienteDAO.listaClienteBEWS(listaClientesBERequest);
		if (lisClientes != null ){
			cadena = creaCadenaCLientes(lisClientes);							
		}
		listaClientesBEResponse.setListaClientes(cadena);

		obj=(Object)listaClientesBEResponse;

		return obj;
	}

	// Lista de Cliente WS

	public Object listaClienteWS(int tipoLista, ListaClienteRequest listaClienteRequest){
		  Object obj= null;
		  String cadena;
		  codigo = "01";
		  ListaClienteResponse resultadoCliente=new ListaClienteResponse();
		  List<ListaClienteResponse> listaCliente = clienteDAO.listaClienteWS(listaClienteRequest, tipoLista);
		  if (listaCliente != null ){
			  cadena=creaCadenaCLientes(listaCliente);

			  resultadoCliente.setListaCliente(cadena);

		  } else {
			  resultadoCliente.setListaCliente("");

		  }	

		  obj=(Object)resultadoCliente;
		  return obj;
	}

	private String transformArray(List  a){
		String resultadoCliente ="";
		ListaClienteResponse temp;
		if(a!=null){   
			Iterator<ListaClienteResponse> it = a.iterator();
			while(it.hasNext()){    
				temp = (ListaClienteResponse)it.next();
				resultadoCliente+= temp.getListaCliente()+"&|&";
			}
		}
		return resultadoCliente;
	}

	public ByteArrayOutputStream cuestionariosAdicionalesPDF(ClienteBean cliente, String nombreReporte) throws Exception{

		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_ClienteID",cliente.getClienteID());
		parametrosReporte.agregaParametro("Par_TipoPersona",cliente.getTipoPersona());
		parametrosReporte.agregaParametro("Par_NivelRiesgo",cliente.getNivelRiesgo());
		parametrosReporte.agregaParametro("Par_SucursalID", cliente.getSucursalID());

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public void setClienteDAO(ClienteDAO clienteDAO) {
		this.clienteDAO = clienteDAO;
	}

	public ClienteDAO getClienteDAO() {
		return clienteDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}
	
	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public LevenshteinDAO getLevenshteinDAO() {
		return levenshteinDAO;
	}

	public void setLevenshteinDAO(LevenshteinDAO levenshteinDAO) {
		this.levenshteinDAO = levenshteinDAO;
	}

} 
