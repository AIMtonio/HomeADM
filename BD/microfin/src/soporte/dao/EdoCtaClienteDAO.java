package soporte.dao;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.codec.binary.Base64;
import org.castor.core.util.Base64Decoder;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.sun.org.apache.xerces.internal.parsers.DOMParser;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import soporte.FacturacionElectronicaWS;
import soporte.bean.CompaniasBean;
import soporte.bean.EdoCtaParamsBean;
import soporte.bean.GeneraEdoCtaBean;
import soporte.bean.ParametrosSisBean;
import soporte.beanWS.request.TimbradoEdoCtaRequest;
import soporte.beanWS.response.TimbradoEdoCtaResponse;
import soporte.servicio.CompaniasServicio;
import soporte.servicio.CorreoServicio;
import soporte.servicio.InstitucionesServicio;
import soporte.servicio.ParametrosSisServicio;

public class EdoCtaClienteDAO extends BaseDAO{

	public EdoCtaClienteDAO(){
		super();
	}
	public static interface Enum_Con_EdoCta {
		int principal 	= 1;
		int foranea		= 2;
		int rango 		= 3;
		int paramEdoCta	= 5;
	}

	public static interface Enum_Lis_EdoCta {
		int principal 	= 1;
		int foranea		= 2;
		int lis_Cte		= 4;
	}
	public static interface Enum_EstatusEdoCta {
		int procesada 			= 2;
		int errorAlProcesar		= 3;
	}

	public static interface Enum_Act_EdoCta {
		int estEdoCtaXCli = 3;
	}

	public static interface Enum_Con_Cli {
		int principal 	= 1;
	}

	public static interface Enum_Con_ParamSis {
		int principal 	= 1;
	}
	public static interface Enum_Con_Institucion {
		int foranea 	= 2;
	}

	public static interface Enum_TipoGeneraEdoCta {
		String mensual 		= "M";
		String semestral	= "S";
	}

	public static interface Enum_MesGeneracionEdoCta {
		int cincoMeses	= 5;
		int junio 		= 6;
		int diciembre	= 12;
	}

	public static interface Enum_Con_Pre {
		int prefijo = 1;
	}

	ParametrosSisServicio parametrosSisServicio = null;
	CorreoServicio correoServicio = null;
	InstitucionesServicio institucionesServicio = null;
	EdoCtaRecursoDAO edoCtaRecursoDAO	=	null;
	String institucionCrediclub = "CREDICLUB";
	HubServiciosDAO hubServiciosDAO = null;
	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	CompaniasBean companiasBean = null;
	CompaniasServicio companiasServicio = null;
	EdoCtaParamsDAO edoCtaParamsDAO = null;

	public MensajeTransaccionBean generaracionEdoCtaProveedor(final GeneraEdoCtaBean generaEdoCtaBean){
		loggerSAFI.info("EdoCtaClienteDAO.generaracionEdoCtaProveedor.");
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		try {
			//Valida que el usuario y password para conectar al PAC esten capturados
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_EdoCta.paramEdoCta, parametrosSisBean);
			generaEdoCtaBean.setUsuarioWS(parametrosSisBean.getUsuarioFactElect());
			generaEdoCtaBean.setPasswordWS(parametrosSisBean.getPassFactElec());
			generaEdoCtaBean.setTimbraEdoCta(parametrosSisBean.getTimbraEdoCta());
			generaEdoCtaBean.setUrlWSDLFactElec(parametrosSisBean.getUrlWSDLFactElec());
			generaEdoCtaBean.setProveedorTimbrado(parametrosSisBean.getProveedorTimbrado());
			//Validaciones para el timbrado de Estado de Cuenta
			if (generaEdoCtaBean.getTimbraEdoCta().equals(generaEdoCtaBean.TimbraEdoCtaSI)) {
				if(generaEdoCtaBean.getUsuarioWS() == null || generaEdoCtaBean.getUsuarioWS().equals("") ||
				   generaEdoCtaBean.getUrlWSDLFactElec() == null || generaEdoCtaBean.getUrlWSDLFactElec().equals("") ||
				   generaEdoCtaBean.getProveedorTimbrado() == null || generaEdoCtaBean.getProveedorTimbrado().equals("")){
					mensaje.setDescripcion("Especifique en los Parametros del Sistema el Proveedor, Usuario, Password y WSDL para Realizar el Timbrado.");
					throw new Exception(mensaje.getDescripcion());
				}
				else{
					mensaje.setNumero(0);
					mensaje.setDescripcion("Usuario y Password Correctos para Conectar con el PAC.");
				}
			}

			// ---------------------------- EdoCta MultiBase -----------------------------------------------
			//Se consulta el prefijo de la empresa necesario para la creacion de directorios
			CompaniasBean prefijoEmpresa = companiasServicio.consulta(Enum_Con_Pre.prefijo, companiasBean);
			//Se parametriza el prefijo de la empresa y se le quitan espacios en blanco
			generaEdoCtaBean.setPrefijoEmpresa( prefijoEmpresa.getDesplegado().replaceAll("\\s", "") );

			// Se guarda el prefijo en la tabla EDOCTAPARAMS para su posterior uso.
			EdoCtaParamsBean prefijo = new EdoCtaParamsBean();;
			prefijo.setPrefijoEmpresa( prefijoEmpresa.getDesplegado().replaceAll("\\s", "") );
			edoCtaParamsDAO.modificarPrefijo(prefijo);
			// ---------------------------- EdoCta MultiBase -----------------------------------------------

			// ---------------------- Necesarios para el EdoCta MultiBase -----------------------------------
			//Se consulta los parametros de sesion del usuario logueado
			ParametrosSesionBean parametrosSesion = parametrosAplicacionServicio.consultaParametrosSessionLocal();
			//Se parametriza el origenDatos para el creaDirectorio
			generaEdoCtaBean.setOrigenDatos( parametrosSesion.getOrigenDatos() );

			//Se consulta las rutas para los archivos sh necesario para la creacion del EdoCta.
			EdoCtaParamsBean rutasSH = edoCtaParamsDAO.consultaPrincipal(Enum_Con_EdoCta.principal);
			//Se parametriza la ruta del SH para la creacion de directorios.
			generaEdoCtaBean.setRutasSHs( rutasSH.getRutaExpPDF() );
			//Se parametriza la ruta del Data-integration
			generaEdoCtaBean.setRutaPDI( rutasSH.getRutaPDI() );
			// ---------------------- Necesarios para el EdoCta MultiBase -----------------------------------

			String proveedor = parametrosSisBean.getProveedorTimbrado();
			if (proveedor.equals("F")) {
				mensaje = generacionEdoCta(generaEdoCtaBean);
			}
			else if (proveedor.equals("S")) {
				mensaje = generacionEdoCtaSmarterWeb(generaEdoCtaBean);
			}
			else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("Especifique en los Parametros del Sistema un Proveedor de timbrado válido.");
				throw new Exception(mensaje.getDescripcion());
			}

		} catch (Exception e) {
			if(mensaje.getNumero()==0){
				mensaje .setNumero(999);
				mensaje.setDescripcion("Error en Proceso de Generacion de Estados de Cuenta Por Proveedor");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de Edo De Ctas Por Proveedor", e);
		}
		return mensaje;
	}

	public MensajeTransaccionBean generacionEdoCtaSmarterWeb (final GeneraEdoCtaBean generaEdoCtaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			GeneraEdoCtaBean direccionDirect = new GeneraEdoCtaBean();
			direccionDirect = consultaParamEdoCta(generaEdoCtaBean, Enum_Con_EdoCta.foranea);

			if(direccionDirect.getRfcEmisor().equals(Constantes.STRING_VACIO)){
				mensaje.setDescripcion("Especifique en los Param. Cta. el RFC del Emisor.");
				throw new Exception(mensaje.getDescripcion());
			}
			if(direccionDirect.getRutaEdoCtaPDF().equals(Constantes.STRING_VACIO)){
				mensaje.setDescripcion("Especifique en los Param. Cta. la ruta del directorio para PDF.");
				throw new Exception(mensaje.getDescripcion());
			}
			if (direccionDirect.getRutaCBB().equals(Constantes.STRING_VACIO)) {
				mensaje.setDescripcion("Especifique en los Param. Cta. la ruta del directorio para CBB");
				throw new Exception(mensaje.getDescripcion());

			}
			if (direccionDirect.getRutaXML().equals(Constantes.STRING_VACIO)) {
				mensaje.setDescripcion("Especifique en los Param. Cta. la ruta del directorio para XML");
				throw new Exception(mensaje.getDescripcion());

			}
			generaEdoCtaBean.setRfcEmisor(direccionDirect.getRfcEmisor());
			generaEdoCtaBean.setRutaEdoCtaPDF(direccionDirect.getRutaEdoCtaPDF());
			generaEdoCtaBean.setRutaCBB(direccionDirect.getRutaCBB());
			generaEdoCtaBean.setRutaXML(direccionDirect.getRutaXML());


			//Consulta historial de generacion de estados de cuenta
			mensaje = consultaHistorialGenEdoCta(generaEdoCtaBean);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}

			//Consulta informacion disponible para la Fecha Seleccionada
			mensaje = validaInfoCliente(generaEdoCtaBean);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}
			//Crea estructura de Carpetas
			mensaje = creaEstructura(generaEdoCtaBean);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}
			mensaje = validaDirectorios();

			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}

			GeneraEdoCtaBean generaEdoCtaRango = new GeneraEdoCtaBean();
			generaEdoCtaRango.setClienteInicio(generaEdoCtaBean.getClienteID());
			generaEdoCtaRango.setClienteFin(generaEdoCtaBean.getClienteID());
			generaEdoCtaRango.setNumRegistros("1");
			generaEdoCtaRango.setSucursalInicio(generaEdoCtaBean.getSucursalInicio());
			generaEdoCtaRango.setSucursalFin(generaEdoCtaBean.getSucursalInicio());
			int inicio = Integer.parseInt(generaEdoCtaRango.getClienteInicio());
			int fin = Integer.parseInt(generaEdoCtaRango.getClienteInicio());

			// ---------------------- Necesarios para el EdoCta MultiBase -----------------------------------
			//Se parametriza el origenDatos para el EdoCta
			generaEdoCtaRango.setOrigenDatos( generaEdoCtaBean.getOrigenDatos() );

			//Se parametriza el prefijo de la empresa y se le quitan espacios en blanco
			generaEdoCtaRango.setPrefijoEmpresa( generaEdoCtaBean.getPrefijoEmpresa() );

			//Se parametriza la ruta del SH para EdoCta.
			generaEdoCtaRango.setRutasSHs( generaEdoCtaBean.getRutasSHs() );

			//Se parametriza la ruta del Data-integration
			generaEdoCtaRango.setRutaPDI( generaEdoCtaBean.getRutaPDI() );
			// ---------------------- Necesarios para el EdoCta MultiBase -----------------------------------

			if (Integer.valueOf(generaEdoCtaRango.getNumRegistros()) >=1 ){

				mensaje= generaEdoCtaUnico(generaEdoCtaRango);
				if(mensaje.getNumero() != 0){
					throw new Exception(mensaje.getDescripcion());

				}
			}
		}catch (Exception e) {
			if(mensaje .getNumero()==0){
				mensaje .setNumero(999);
				mensaje.setDescripcion("Error en Proceso de Generacion de Estados de Cuenta");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de Edo De Ctas", e);
		}
		return mensaje;
	}

	public MensajeTransaccionBean timbradoRest(final GeneraEdoCtaBean generaEdoCtaBean, String urlServicio, String autentificacionCodif) throws Exception {
		String CODIGO_EXITO = "000000";
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Iterator<GeneraEdoCtaBean> clientesItera = null;
		List<GeneraEdoCtaBean> listaCLientesTimbrar = null;


		listaCLientesTimbrar = consultaDatosCliente(generaEdoCtaBean, Enum_Lis_EdoCta.lis_Cte);
		clientesItera = listaCLientesTimbrar.iterator();


		int timbresExitosos = 0;
		int timbresFallidos = 0;
		int timbradosAnteriores = 0;

		boolean generaPDF = false;
		boolean generaTXT = false;
		boolean generaCBB = true;

		while (clientesItera.hasNext()) {
			GeneraEdoCtaBean elemGeneraEdo = (GeneraEdoCtaBean) clientesItera
					.next();

			//INFO: LA CONSULTA VA DIRIGIDA PARA UN CLIENTE
			if (elemGeneraEdo.getEstatus() == 2) {
				timbradosAnteriores ++;
				mensaje.setDescripcion("El cliente ya se ha timbrado anteriormente");
				throw new Exception(mensaje.getDescripcion());
			}
			// timbrado tipo de ingreso
			if (!elemGeneraEdo.getCadenaCFDI().isEmpty() &&	elemGeneraEdo.getEstatus() != 2 ) {
				TimbradoEdoCtaRequest timbradoEdoCtaRequest = new TimbradoEdoCtaRequest();

				timbradoEdoCtaRequest.setCadenaTimbrado(elemGeneraEdo.getCadenaCFDI());
				timbradoEdoCtaRequest.setIdentificadorBus(elemGeneraEdo.getIdentificadorBus());
				timbradoEdoCtaRequest.setUsuario(elemGeneraEdo.getUsuario());
				timbradoEdoCtaRequest.setIpUsuario(elemGeneraEdo.getDireccionIP());
				timbradoEdoCtaRequest.setSucursal(elemGeneraEdo.getSucursalID());

				String remplazarComillas = elemGeneraEdo.getCadenaCFDI().replaceAll("\"", "\'");
				timbradoEdoCtaRequest.setCadenaTimbrado(remplazarComillas);


				TimbradoEdoCtaResponse timbradoEdoCtaResponse = hubServiciosDAO.timbrarSWRest(timbradoEdoCtaRequest, urlServicio, autentificacionCodif);
				loggerSAFI.info("Respuesta de HubServicios:" + timbradoEdoCtaResponse.getCodigoRespuesta() + "-" + timbradoEdoCtaResponse.getMensajeRespuesta());
				if (timbradoEdoCtaResponse.getCodigoRespuesta().equals("408")) {
					throw new Exception(timbradoEdoCtaResponse.getMensajeRespuesta());
				}
				if (!timbradoEdoCtaResponse.getCodigoRespuesta().equals(CODIGO_EXITO)) {
					timbresFallidos ++;
					elemGeneraEdo.setEstatus(3);
					elemGeneraEdo.setTipoTimbrado("I");
					modificaDatosCteEstatus(elemGeneraEdo);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Timbrado Fallido. Cliente: "+ elemGeneraEdo.getClienteID() +"\nError: " + timbradoEdoCtaResponse.getMensajeRespuesta() , null);
				}else{
					timbresExitosos++;
					String xml = new String((timbradoEdoCtaResponse.getCfdi()));
					elemGeneraEdo.setEstatus(2);
					elemGeneraEdo.setTipoTimbrado("I");
					modificaDatosCteEstatus(elemGeneraEdo);
					altaCadenaXml(elemGeneraEdo, xml);

					try {
						File archivo = new File(generaEdoCtaBean.getRutaXML()+generaEdoCtaBean.getPrefijoEmpresa()+"/"+generaEdoCtaBean.getFechaProceso()+"/"+Utileria.completaCerosIzquierda(elemGeneraEdo.getSucursalID(), 3) +"/"+ Utileria.completaCerosIzquierda(elemGeneraEdo.getClienteID(),10)+"-"+"1"+"-"+generaEdoCtaBean.getFechaProceso()+".xml" );
						MensajeTransaccionBean mensajeArchivo = convierteStringXml(archivo, xml);
						if (mensajeArchivo.getNumero() !=  Constantes.CODIGO_SIN_ERROR){
							throw new Exception(mensajeArchivo.getDescripcion());
						}

					}catch(Exception e) {
						loggerSAFI.info("Fallo de Generación de Archivo XML: "+e.getMessage());
						e.printStackTrace();
					}

					if (generaCBB) {
						OutputStream out;
						try {
							byte[] b = Base64Decoder.decode(timbradoEdoCtaResponse.getQrCode());
							out = new FileOutputStream(generaEdoCtaBean.getRutaCBB()+generaEdoCtaBean.getPrefijoEmpresa()+"/"+generaEdoCtaBean.getFechaProceso()+"/"+Utileria.completaCerosIzquierda(elemGeneraEdo.getSucursalID(), 3) +"/"+ Utileria.completaCerosIzquierda(elemGeneraEdo.getClienteID(),10)+"-"+"1"+"-"+generaEdoCtaBean.getFechaProceso()+".png");
							out.write(b, 0, b.length);
							out.close();
						}catch (Exception e) {
							loggerSAFI.info("Fallo de Generación de Archivo CBB: "+e.getMessage());
							e.printStackTrace();
						}
					}
					//Actualiza registro
					String rutaXML = generaEdoCtaBean.getRutaXML()+generaEdoCtaBean.getPrefijoEmpresa()+"/"+generaEdoCtaBean.getFechaProceso()+"/"+Utileria.completaCerosIzquierda(elemGeneraEdo.getSucursalID(), 3) +"/"+ Utileria.completaCerosIzquierda(elemGeneraEdo.getClienteID(),10)+"-"+"1"+"-"+generaEdoCtaBean.getFechaProceso()+".xml";
					elemGeneraEdo.setRutaXML(rutaXML);
					elemGeneraEdo.setRutaXMLRet(Constantes.STRING_VACIO);

					try {
						leerArchivoXML(elemGeneraEdo);
					} catch (Exception e) {
						e.printStackTrace();
					}



				}//fin else timbrado normal

			}//fin if
		}//fin while
		mensaje.setNumero(0);
		mensaje.setConsecutivoInt(String.valueOf(timbresExitosos));
		mensaje.setDescripcion("Total de Timbrado Exitosos: " + timbresExitosos + "\n Total de Timbrados Fallidos: " + timbresFallidos);
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Total de Timbrado Exitosos: " + timbresExitosos + "\n Total de Timbrados Fallidos: " + timbresFallidos, null);
		return mensaje;
	}

	/**
	 * Lee archivo xml ingreso y egreso de un cliente
	 * @return
	 */
	public MensajeTransaccionBean leerArchivoXML(GeneraEdoCtaBean generaEdo) throws Exception{
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		boolean existsXMLIngreso = (new File( generaEdo.getRutaXML())).exists();
		boolean existsXMLEgreso = (new File( generaEdo.getRutaXMLRet() )).exists();

		if (existsXMLIngreso) {

			File fXmlFile = new File(generaEdo.getRutaXML());
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(fXmlFile);
			//	optional, but recommended
			//read this - http://stackoverflow.com/questions/13786607/normalization-in-dom-parsing-with-java-how-does-it-work
			doc.getDocumentElement().normalize();

			String fechaTimbrado = "";
		    String selloCFD = "";
		    String noCertificadoSAT = "";
		    String UUID = "";
		    String version = "";
		    String selloSAT = "";
		    String fechaCertificacion = "";
		    String noCertEmisor = "";
		    String lugarExpedicion = "";
		    String serie = "";
		    String subTotal = "";
		    String descuento ="";
		    String total = "";
			NodeList nodeLst = doc.getElementsByTagName("cfdi:Comprobante");
			Element eleCode = (Element) nodeLst.item(0);
	        fechaCertificacion = eleCode.getAttribute("Fecha");
	        noCertEmisor = eleCode.getAttribute("NoCertificado");
	        lugarExpedicion = eleCode.getAttribute("LugarExpedicion");
	        serie = eleCode.getAttribute("Serie");
	        subTotal = eleCode.getAttribute("SubTotal");
	        descuento = eleCode.getAttribute("Descuento");
	        total = eleCode.getAttribute("Total");

	        for (int i = 0; i < nodeLst.getLength(); i++) {
		          Element ele = (Element) nodeLst.item(i);
		          NodeList nlsCode = ele.getElementsByTagName("tfd:TimbreFiscalDigital");
		          Element eleCode2 = (Element) nlsCode.item(0);
		          fechaTimbrado = eleCode2.getAttribute("FechaTimbrado");
			      selloCFD = eleCode2.getAttribute("SelloCFD");
			      noCertificadoSAT = eleCode2.getAttribute("NoCertificadoSAT");
			      UUID = eleCode2.getAttribute("UUID");
			      version = eleCode2.getAttribute("Version");
			      selloSAT = eleCode2.getAttribute("SelloSAT");
	        }

	        GeneraEdoCtaBean edoCtaCFDI = new GeneraEdoCtaBean();
	        edoCtaCFDI.setClienteID(generaEdo.getClienteID());
	        edoCtaCFDI.setSucursalID(generaEdo.getSucursal());
			edoCtaCFDI.setVersion(version);
			edoCtaCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 90));
			edoCtaCFDI.setUUID(recorreCadena(UUID, 20));
			edoCtaCFDI.setFechaTimbrado(fechaTimbrado);
			edoCtaCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 90)));
			edoCtaCFDI.setSelloSAT(recorreCadena(selloSAT, 90));
			edoCtaCFDI.setFechaCertificacion(fechaCertificacion);
			edoCtaCFDI.setNoCertEmisor(noCertEmisor);
			edoCtaCFDI.setLugarExpedicion(lugarExpedicion);
			// -------------------------------
			edoCtaCFDI.setSerie(serie);
			edoCtaCFDI.setSubTotal(subTotal);
			edoCtaCFDI.setDescuento(descuento);
			edoCtaCFDI.setTotal(total);
			edoCtaCFDI.setCadenaOriginal(recorreCadena("||"+version+ "|"+UUID+
					"|"+fechaTimbrado+"|"+selloCFD+"|"+noCertificadoSAT+"||", 90));

			edoCtaCFDI.setTipoTimbrado("I");

			mensaje = modificaDatosCte(edoCtaCFDI);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}
		}
		if (existsXMLEgreso) {
			//edoCtaCFDI.setTipoTimbrado("E");
			File fXmlFile = new File(generaEdo.getRutaXMLRet());
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(fXmlFile);
			//	optional, but recommended
			//read this - http://stackoverflow.com/questions/13786607/normalization-in-dom-parsing-with-java-how-does-it-work
			doc.getDocumentElement().normalize();

			String fechaTimbrado = "";
		    String selloCFD = "";
		    String noCertificadoSAT = "";
		    String UUID = "";
		    String version = "";
		    String selloSAT = "";
		    String fechaCertificacion = "";
		    String noCertEmisor = "";
		    String lugarExpedicion = "";
		    String serie = "";
		    String subTotal = "";
		    String descuento ="";
		    String total = "";
			NodeList nodeLst = doc.getElementsByTagName("cfdi:Comprobante");
			Element eleCode = (Element) nodeLst.item(0);
	        fechaCertificacion = eleCode.getAttribute("Fecha");
	        noCertEmisor = eleCode.getAttribute("NoCertificado");
	        lugarExpedicion = eleCode.getAttribute("LugarExpedicion");
	        serie = eleCode.getAttribute("Serie");
	        subTotal = eleCode.getAttribute("SubTotal");
	        descuento = eleCode.getAttribute("Descuento");
	        total = eleCode.getAttribute("Total");

	        for (int i = 0; i < nodeLst.getLength(); i++) {
		          Element ele = (Element) nodeLst.item(i);
		          NodeList nlsCode = ele.getElementsByTagName("tfd:TimbreFiscalDigital");
		          Element eleCode2 = (Element) nlsCode.item(0);
		          fechaTimbrado = eleCode2.getAttribute("FechaTimbrado");
			      selloCFD = eleCode2.getAttribute("SelloCFD");
			      noCertificadoSAT = eleCode2.getAttribute("NoCertificadoSAT");
			      UUID = eleCode2.getAttribute("UUID");
			      version = eleCode2.getAttribute("Version");
			      selloSAT = eleCode2.getAttribute("SelloSAT");
	        }

	        GeneraEdoCtaBean edoCtaCFDI = new GeneraEdoCtaBean();
	        edoCtaCFDI.setClienteID(generaEdo.getClienteID());
	        edoCtaCFDI.setSucursalID(generaEdo.getSucursal());
			edoCtaCFDI.setVersion(version);
			edoCtaCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 90));
			edoCtaCFDI.setUUID(recorreCadena(UUID, 20));
			edoCtaCFDI.setFechaTimbrado(fechaTimbrado);
			edoCtaCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 90)));
			edoCtaCFDI.setSelloSAT(recorreCadena(selloSAT, 90));
			edoCtaCFDI.setFechaCertificacion(fechaCertificacion);
			edoCtaCFDI.setNoCertEmisor(noCertEmisor);
			edoCtaCFDI.setLugarExpedicion(lugarExpedicion);
			// -------------------------------
			edoCtaCFDI.setSerie(serie);
			edoCtaCFDI.setSubTotal(subTotal);
			edoCtaCFDI.setDescuento(descuento);
			edoCtaCFDI.setTotal(total);
			edoCtaCFDI.setCadenaOriginal(recorreCadena("||"+version+ "|"+UUID+
					"|"+fechaTimbrado+"|"+selloCFD+"|"+noCertificadoSAT+"||", 90));

			edoCtaCFDI.setTipoTimbrado("E");

			mensaje = modificaDatosCte(edoCtaCFDI);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}
		}
		return mensaje;

	}
	/**
	 * Convierte una cadena xml a un archivo xml
	 * @param archivo
	 * @param xml
	 * @return
	 */
	public MensajeTransaccionBean convierteStringXml(File archivo, String xml){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {

		    DOMParser parser = new DOMParser();
		    parser.parse(new InputSource(new java.io.StringReader(xml)));
		    Document doc = parser.getDocument();

		    DOMSource source = new DOMSource(doc);
		    FileWriter writer = new FileWriter(archivo);
		    StreamResult result = new StreamResult(writer);

		    TransformerFactory transformerFactory = TransformerFactory.newInstance();
		    Transformer transformer = transformerFactory.newTransformer();
		    transformer.transform(source, result);

		    mensaje.setNumero(Constantes.CODIGO_SIN_ERROR);
			mensaje.setDescripcion("Listo");

		} catch (Exception e) {
			mensaje.setNumero(1);
			mensaje.setDescripcion(e.getMessage());
			loggerSAFI.info("Resp: "+e.getMessage());
			e.printStackTrace();
		}
		return mensaje;
	}

	public MensajeTransaccionBean generacionEdoCta(final GeneraEdoCtaBean generaEdoCtaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
			//Consulta parametros de Estado de Cuenta
			GeneraEdoCtaBean generaEdoCta = new GeneraEdoCtaBean();

			generaEdoCta = consultaParamEdoCta(generaEdoCtaBean, Enum_Con_EdoCta.foranea);
			if(generaEdoCta.getRfcEmisor().equals("")||generaEdoCta.getRutaEdoCtaPDF().equals("")||generaEdoCta.getRutaCBB().equals("")||generaEdoCta.getRutaXML().equals("")){
				mensaje.setDescripcion("Especifique en los Param. Cta. las Rutas de los Directorios.");
				throw new Exception(mensaje.getDescripcion());
			}
			else{
				generaEdoCtaBean.setRfcEmisor(generaEdoCta.getRfcEmisor());
				generaEdoCtaBean.setRutaEdoCtaPDF(generaEdoCta.getRutaEdoCtaPDF());
				generaEdoCtaBean.setRutaCBB(generaEdoCta.getRutaCBB());
				generaEdoCtaBean.setRutaXML(generaEdoCta.getRutaXML());
			}

			//Consulta historial de generacion de estados de cuenta
			mensaje = consultaHistorialGenEdoCta(generaEdoCtaBean);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}
			//Consulta informacion disponible para la Fecha Seleccionada
			mensaje = validaInfoCliente(generaEdoCtaBean);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}
			//Crea estructura de Carpetas
			mensaje = creaEstructura(generaEdoCtaBean);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}
			mensaje = validaDirectorios();

			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}

			GeneraEdoCtaBean generaEdoCtaRango = new GeneraEdoCtaBean();
			generaEdoCtaRango.setClienteInicio(generaEdoCtaBean.getClienteID());
			generaEdoCtaRango.setClienteFin(generaEdoCtaBean.getClienteID());
			generaEdoCtaRango.setNumRegistros("1");
			generaEdoCtaRango.setSucursalInicio(generaEdoCtaBean.getSucursalInicio());
			generaEdoCtaRango.setSucursalFin(generaEdoCtaBean.getSucursalInicio());
			int inicio = Integer.parseInt(generaEdoCtaRango.getClienteInicio());
			int fin = Integer.parseInt(generaEdoCtaRango.getClienteInicio());

			// ---------------------- Necesarios para el EdoCta MultiBase -----------------------------------
			//Se parametriza el origenDatos para el EdoCta
			generaEdoCtaRango.setOrigenDatos( generaEdoCtaBean.getOrigenDatos() );

			//Se parametriza el prefijo de la empresa y se le quitan espacios en blanco
			generaEdoCtaRango.setPrefijoEmpresa( generaEdoCtaBean.getPrefijoEmpresa() );

			//Se parametriza la ruta del SH para EdoCta.
			generaEdoCtaRango.setRutasSHs( generaEdoCtaBean.getRutasSHs() );

			//Se parametriza la ruta del Data-integration
			generaEdoCtaRango.setRutaPDI( generaEdoCtaBean.getRutaPDI() );
			// ---------------------- Necesarios para el EdoCta MultiBase -----------------------------------

			if (Integer.valueOf(generaEdoCtaRango.getNumRegistros()) >=1 ){

				mensaje= generaEdoCtaUnico(generaEdoCtaRango);
				if(mensaje.getNumero() != 0){
					throw new Exception(mensaje.getDescripcion());

				}
			}
		} catch (Exception e) {
			if(mensaje .getNumero()==0){
				mensaje .setNumero(999);
				mensaje.setDescripcion("Error en Proceso de Generacion de Estados de Cuenta");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de Edo De Ctas", e);
		}
		return mensaje;
	}

	public MensajeTransaccionBean generacionEdoCtaCrediclub(final GeneraEdoCtaBean generaEdoCtaBean) {
		loggerSAFI.info("EdoCtaClienteDAO.generacionEdoCtaCrediclub.");
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_EdoCta.paramEdoCta, parametrosSisBean);
			generaEdoCtaBean.setTimbraEdoCta(parametrosSisBean.getTimbraEdoCta());
			//Consulta parametros de Estado de Cuenta
			GeneraEdoCtaBean generaEdoCta = new GeneraEdoCtaBean();

			generaEdoCta = consultaParamEdoCta(generaEdoCtaBean, Enum_Con_EdoCta.foranea);
			if(generaEdoCta.getRfcEmisor().equals("")||generaEdoCta.getRutaEdoCtaPDF().equals("")||generaEdoCta.getRutaCBB().equals("")||generaEdoCta.getRutaXML().equals("")){
				mensaje.setDescripcion("Especifique en los Param. Cta. las Rutas de los Directorios.");
				throw new Exception(mensaje.getDescripcion());
			}
			else{
				generaEdoCtaBean.setRfcEmisor(generaEdoCta.getRfcEmisor());
				generaEdoCtaBean.setRutaEdoCtaPDF(generaEdoCta.getRutaEdoCtaPDF());
				generaEdoCtaBean.setRutaCBB(generaEdoCta.getRutaCBB());
				generaEdoCtaBean.setRutaXML(generaEdoCta.getRutaXML());
			}
			//Consulta historial de generacion de estados de cuenta
			mensaje = consultaHistorialGenEdoCta(generaEdoCtaBean);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}

			//Editamos los parametros de conexion de ETL
			mensaje = editaParamsConexionETL(generaEdoCtaBean);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}

			//Crea estructura de Carpetas
			mensaje = creaEstructura(generaEdoCtaBean);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}
			mensaje = validaDirectorios();

			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}


			GeneraEdoCtaBean generaEdoCtaRango = new GeneraEdoCtaBean();
			generaEdoCtaRango.setClienteInicio(generaEdoCtaBean.getClienteID());
			generaEdoCtaRango.setClienteFin(generaEdoCtaBean.getClienteID());
			generaEdoCtaRango.setNumRegistros("1");
			generaEdoCtaRango.setSucursalInicio(generaEdoCtaBean.getSucursalInicio());
			generaEdoCtaRango.setSucursalFin(generaEdoCtaBean.getSucursalInicio());
			int inicio = Integer.parseInt(generaEdoCtaRango.getClienteInicio());
			int fin = Integer.parseInt(generaEdoCtaRango.getClienteInicio());

			if (Integer.valueOf(generaEdoCtaRango.getNumRegistros()) >=1 ){

				mensaje= generaEdoCtaUnicoCrediclub(generaEdoCtaRango);
				if(mensaje.getNumero() != 0){
					throw new Exception(mensaje.getDescripcion());

				}

			}
		} catch (Exception e) {
			if(mensaje .getNumero()==0){
				mensaje .setNumero(999);
				mensaje.setDescripcion("Error en Proceso de Generacion de Estados de Cuenta");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de Edo De Ctas", e);
		}
		return mensaje;
	}



	public GeneraEdoCtaBean validarEdosCtaEjecutados(final GeneraEdoCtaBean generaEdoCtaBean) {

		GeneraEdoCtaBean generaEdoCtaMen = new GeneraEdoCtaBean();

		if(generaEdoCtaBean.getTipoGeneracion().equals(Enum_TipoGeneraEdoCta.semestral)){
			generaEdoCtaMen = consultaEdoCtaPerMenEjecutado(generaEdoCtaBean, Enum_Con_EdoCta.principal);
		}

		return generaEdoCtaMen;
	}

	public MensajeTransaccionBean consultaHistorialGenEdoCta(final GeneraEdoCtaBean generaEdoCtaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//Valida que se haya realizado el timbrado correspondiente antes de generar los estados de cuenta
		GeneraEdoCtaBean generaEdoCtaMen = new GeneraEdoCtaBean();
		generaEdoCtaMen = consultaEdoCtaPerMenEjecutado(generaEdoCtaBean, Enum_Con_EdoCta.principal);
		if(generaEdoCtaBean.getTipoGeneracion().equals(Enum_TipoGeneraEdoCta.semestral)){
			if(generaEdoCtaMen == null){
				mensaje.setNumero(999);
				mensaje.setDescripcion("No Existe Información sobre el Semestre Seleccionado");
			}
		}
		if(generaEdoCtaBean.getTipoGeneracion().equals(Enum_TipoGeneraEdoCta.mensual)){
			if(generaEdoCtaMen == null){
				mensaje.setNumero(999);
				mensaje.setDescripcion("No Existe Información sobre el Mes Seleccionado");
			}
			if(Utileria.convierteEntero(generaEdoCtaBean.getMesFinGen()) == Enum_MesGeneracionEdoCta.junio ||
			   Utileria.convierteEntero(generaEdoCtaBean.getMesFinGen()) == Enum_MesGeneracionEdoCta.diciembre){
				generaEdoCtaBean.setTipoGeneracion(Enum_TipoGeneraEdoCta.semestral);
				int mesInicioSemestre = Utileria.convierteEntero(generaEdoCtaBean.getMesFinGen()) - Enum_MesGeneracionEdoCta.cincoMeses;
				generaEdoCtaBean.setMesInicioGen(String.valueOf(mesInicioSemestre));
				generaEdoCtaMen = consultaEdoCtaPerMenEjecutado(generaEdoCtaBean, Enum_Con_EdoCta.principal);
				if(generaEdoCtaMen != null){
					mensaje.setNumero(999);
					mensaje.setDescripcion("No Existe Información sobre el Mes Seleccionado debido a la existencia de Informacion Semestral.");
				}
				generaEdoCtaBean.setTipoGeneracion(Enum_TipoGeneraEdoCta.mensual);
				generaEdoCtaBean.setMesInicioGen(generaEdoCtaBean.getMesFinGen());
			}
		}
		return mensaje;
	}

	public MensajeTransaccionBean validaInfoCliente(final GeneraEdoCtaBean generaEdoCtaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					GeneraEdoCtaBean generaEdoCta = new GeneraEdoCtaBean();
					generaEdoCta = consultaClientes(generaEdoCtaBean, Enum_Con_Cli.principal);
					if (Integer.valueOf(generaEdoCta.getNumRegistros()) == Constantes.ENTERO_CERO){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("No Existe Información sobre la Fecha Seleccionada");
						throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error en Validacion de Informacion sobre la Fecha Seleccionada");
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					//e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Validacion de Informacion sobre la Fecha Seleccionada", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean creaEstructura(GeneraEdoCtaBean generaEdoCtaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//Ejecucion de Estado de Cuentas
		try{
			loggerSAFI.error("Creando estructuras para los PDFs del proceso de timbrado.");
			String rutaPDFEdoCta = generaEdoCtaBean.getPrefijoEmpresa()+"/"+generaEdoCtaBean.getFechaProceso();
			loggerSAFI.error(generaEdoCtaBean.getRutaEdoCtaPDF() + rutaPDFEdoCta);
			ProcessBuilder pb = new ProcessBuilder("/bin/bash", "./ejec_creadirectorios.sh", generaEdoCtaBean.getRutaEdoCtaPDF()+rutaPDFEdoCta, generaEdoCtaBean.getOrigenDatos(),
													generaEdoCtaBean.getPrefijoEmpresa(), generaEdoCtaBean.getRutasSHs(), generaEdoCtaBean.getRutaPDI() );
			pb.directory(new File( generaEdoCtaBean.getRutasSHs() + "JOBS/" ));
			Process p = pb.start();
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			String line;
			while ((line = br.readLine()) != null) {
				System.out.println(line);
			}
		}catch(IllegalThreadStateException e){
			mensaje.setNumero(Integer.valueOf("001"));
			mensaje.setDescripcion("Error al Generar Estructura de Carpetas para Edo. de Cta.");
		}catch(Exception e){
			e.printStackTrace();
		}
		return mensaje;
	}


	public MensajeTransaccionBean validaDirectorios(){
		loggerSAFI.error("Verificando que los directorios se crearon correctamente.");
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<GeneraEdoCtaBean> directorios;
		directorios=edoCtaRecursoDAO.consultaDirec();
		for(GeneraEdoCtaBean directorio:directorios){
			String path=directorio.getRutaEdoCtaPDF().substring(18,directorio.getRutaEdoCtaPDF().length());
			File dir=new File(path);
			if(!dir.exists()){
				mensaje.setNumero(Integer.valueOf("001"));
				mensaje.setDescripcion("Error al Crear los Directorios.");
				return mensaje;
			}
		}
		mensaje.setNumero(Integer.valueOf("000"));
		mensaje.setDescripcion("Directorios Generados con Exito.");
		return mensaje;
	}

	public MensajeTransaccionBean realizaTimbrado(GeneraEdoCtaBean generaEdoCtaBean ){
		// Realizar el timbrado para cada cliente
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<GeneraEdoCtaBean> mensajeClientes = null;

		/*Se crea una nueva instancia de la Clase FacturacionElectronicaWS,
		 * se envian los siguientes parametros para inciar
		 * userID	-- Usuario para conectar con el WS,
		 * userPass	-- Password para conectar con el WS,
		 * rfcEmisor-- RFC del Emisor de la Factura,
		 * generaPDF-- parametro boleano que indica si genera el PDF,
		 * generaTXT-- parametro boleano que indica si genera TXT,
		 * generaCBB-- parametro boleano que indica si genera el CBB(PNG)
		 * */
		boolean generaPDF = false;
		boolean generaTXT = false;
		boolean generaCBB = true;
		FacturacionElectronicaWS connect = new FacturacionElectronicaWS(generaEdoCtaBean.getUrlWSDLFactElec(), generaEdoCtaBean.getUsuarioWS(), generaEdoCtaBean.getPasswordWS(),
				generaEdoCtaBean.getRfcEmisor(), generaPDF, generaTXT, generaCBB);

		mensajeClientes = consultaDatosCliente(generaEdoCtaBean, Enum_Lis_EdoCta.lis_Cte);
		GeneraEdoCtaBean generaEdo = null;
		GeneraEdoCtaBean generaEdoIter = null;
		String pathdir = generaEdoCtaBean.getRutaEdoCtaPDF();
		int countExitos = 0;
		int countFallidos = 0;
		String r;
		Iterator<GeneraEdoCtaBean> itera = null;
		itera = mensajeClientes.iterator();
		while(itera.hasNext()){
			generaEdo = new  GeneraEdoCtaBean();
			generaEdoIter = itera.next();
			generaEdo.setCadenaCFDI(generaEdoIter.getCadenaCFDI());
			generaEdo.setClienteID(generaEdoIter.getClienteID());
			generaEdo.setSucursal(generaEdoIter.getSucursalID());
			generaEdo.setCadenaCFDIRet(generaEdoIter.getCadenaCFDIRet());
			generaEdo.setFechaProceso(generaEdoIter.getFechaProceso());

			// Timbrado Tipo Ingreso
			if (!generaEdo.getCadenaCFDI().isEmpty() && generaEdoIter.getEstatus()!=2){
					r = connect.timbrarFactura(generaEdo.getCadenaCFDI());
				if (r.equals("error")) {
					countFallidos++;
					generaEdo.setEstatus(3);
					generaEdo.setTipoTimbrado("I");
					modificaDatosCteEstatus(generaEdo);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Timbrado Fallido. Cliente: "+ generaEdo.getClienteID() +"\nError: " + r , null);
				}
				else {
					countExitos++;
					String xml = new String(Base64Decoder.decode(connect.strXml));
					generaEdo.setEstatus(2);
					generaEdo.setTipoTimbrado("I");
					modificaDatosCteEstatus(generaEdo);
					altaCadenaXml(generaEdo, xml);
					try {
						File archivo = new File(generaEdoCtaBean.getRutaXML() + generaEdoCtaBean.getPrefijoEmpresa()+"/"+generaEdoCtaBean.getFechaProceso()+"/"+Utileria.completaCerosIzquierda(generaEdo.getSucursal(), 3) +"/"+ Utileria.completaCerosIzquierda(generaEdo.getClienteID(),10)+"-"+"1"+"-"+generaEdoCtaBean.getFechaProceso()+".xml" );
						FileWriter escribir = new FileWriter(archivo);
						escribir.write(xml);
						escribir.close();
					}catch(Exception e) {
						System.out.println(e.getMessage().toString());
					}
					if (connect.generarPDF) {
						OutputStream out;
						try {
							byte[] b = Base64Decoder.decode(connect.strPdf);
							File archivo = new File( generaEdoCtaBean.getRutasSHs() + generaEdoCtaBean.getPrefijoEmpresa() + "/" + generaEdoCtaBean.getFechaProceso()+"/"+Utileria.completaCerosIzquierda(generaEdo.getSucursal(), 3) +"/"+ Utileria.completaCerosIzquierda(generaEdo.getClienteID(),10)+"-"+generaEdoCtaBean.getFechaProceso()+"PAC.pdf");
							out = new FileOutputStream(archivo);
							out.write(b, 0, b.length);
							out.close();
						}catch (Exception e) {
							System.out.println(e);
						}
					}
					if (connect.generarCBB) {
						OutputStream out;
						try {
							byte[] b = Base64Decoder.decode(connect.strCbb);
							out = new FileOutputStream(generaEdoCtaBean.getRutaCBB() + generaEdoCtaBean.getPrefijoEmpresa() + "/" + generaEdoCtaBean.getFechaProceso()+"/"+Utileria.completaCerosIzquierda(generaEdo.getSucursal(), 3) +"/"+ Utileria.completaCerosIzquierda(generaEdo.getClienteID(),10)+"-"+"1"+"-"+generaEdoCtaBean.getFechaProceso()+".png");
							out.write(b, 0, b.length);
							out.close();
						}catch (Exception e) {
							System.out.println(e);
						}
					}
					if (connect.generarTXT) {
						String txt = new String(Base64Decoder.decode(connect.strTxt));
						try {
							File archivo = new File(pathdir+"TXT/" + generaEdoCtaBean.getPrefijoEmpresa() + "/" + generaEdoCtaBean.getFechaProceso()+"/"+Utileria.completaCerosIzquierda(generaEdo.getSucursal(), 3) +"/"+Utileria.completaCerosIzquierda(generaEdo.getClienteID(),10)+"-"+generaEdoCtaBean.getFechaProceso()+ ".txt");
							FileWriter escribir = new FileWriter(archivo);
							escribir.write(txt);
							escribir.close();
						}
						catch(Exception e) {
							System.out.println(e.getMessage().toString())	;
						}
					}
					//Actualiza registro
					String rutaXML = generaEdoCtaBean.getRutaXML() + generaEdoCtaBean.getPrefijoEmpresa()+"/"+generaEdoCtaBean.getFechaProceso()+"/"+Utileria.completaCerosIzquierda(generaEdo.getSucursal(), 3) +"/"+ Utileria.completaCerosIzquierda(generaEdo.getClienteID(),10)+"-"+"1"+"-"+generaEdoCtaBean.getFechaProceso()+".xml";
				try {
					boolean exists = (new File( rutaXML )).exists();

		    		if (exists) {
		    			File fXmlFile = new File(rutaXML);
						DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
						DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
						Document doc = dBuilder.parse(fXmlFile);
						//	optional, but recommended
						//read this - http://stackoverflow.com/questions/13786607/normalization-in-dom-parsing-with-java-how-does-it-work
						doc.getDocumentElement().normalize();

						String fechaTimbrado = "";
					    String selloCFD = "";
					    String noCertificadoSAT = "";
					    String UUID = "";
					    String version = "";
					    String selloSAT = "";
					    String fechaCertificacion = "";
					    String noCertEmisor = "";
					    String lugarExpedicion = "";
					    String serie = "";
					    String subTotal = "";
					    String descuento ="";
					    String total = "";
						NodeList nodeLst = doc.getElementsByTagName("cfdi:Comprobante");
						Element eleCode = (Element) nodeLst.item(0);
				        fechaCertificacion = eleCode.getAttribute("Fecha");
				        noCertEmisor = eleCode.getAttribute("NoCertificado");
				        lugarExpedicion = eleCode.getAttribute("LugarExpedicion");
				        serie = eleCode.getAttribute("Serie");
				        subTotal = eleCode.getAttribute("SubTotal");
				        descuento = eleCode.getAttribute("Descuento");
				        total = eleCode.getAttribute("Total");

				        for (int i = 0; i < nodeLst.getLength(); i++) {
					          Element ele = (Element) nodeLst.item(i);
					          NodeList nlsCode = ele.getElementsByTagName("tfd:TimbreFiscalDigital");
					          Element eleCode2 = (Element) nlsCode.item(0);
					          fechaTimbrado = eleCode2.getAttribute("FechaTimbrado");
						      selloCFD = eleCode2.getAttribute("SelloCFD");
						      noCertificadoSAT = eleCode2.getAttribute("NoCertificadoSAT");
						      UUID = eleCode2.getAttribute("UUID");
						      version = eleCode2.getAttribute("Version");
						      selloSAT = eleCode2.getAttribute("SelloSAT");
				        }

				        GeneraEdoCtaBean edoCtaCFDI = new GeneraEdoCtaBean();
				        edoCtaCFDI.setClienteID(generaEdo.getClienteID());
				        edoCtaCFDI.setSucursalID(generaEdo.getSucursal());
						edoCtaCFDI.setVersion(version);
						edoCtaCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 90));
						edoCtaCFDI.setUUID(recorreCadena(UUID, 20));
						edoCtaCFDI.setFechaTimbrado(fechaTimbrado);
						edoCtaCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 90)));
						edoCtaCFDI.setSelloSAT(recorreCadena(selloSAT, 90));
						edoCtaCFDI.setFechaCertificacion(fechaCertificacion);
						edoCtaCFDI.setNoCertEmisor(noCertEmisor);
						edoCtaCFDI.setLugarExpedicion(lugarExpedicion);
						// -------------------------------
						edoCtaCFDI.setSerie(serie);
						edoCtaCFDI.setSubTotal(subTotal);
						edoCtaCFDI.setDescuento(descuento);
						edoCtaCFDI.setTotal(total);
						edoCtaCFDI.setCadenaOriginal(recorreCadena("||"+version+ "|"+UUID+
								"|"+fechaTimbrado+"|"+selloCFD+"|"+noCertificadoSAT+"||", 90));

						edoCtaCFDI.setTipoTimbrado("I");

						mensaje = modificaDatosCte(edoCtaCFDI);
						if(mensaje.getNumero() != 0){
							throw new Exception(mensaje.getDescripcion());
						}
		    		}
				}catch(Exception e){
					e.printStackTrace();
				}
			   }
			}
		}
		mensaje.setNumero(0);
		mensaje.setConsecutivoInt(String.valueOf(countExitos));
		mensaje.setDescripcion("Total de Timbrado Exitosos: " + countExitos + "\n Total de Timbrados Fallidos: " + countFallidos);
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Total de Timbrado Exitosos: " + countExitos + "\n Total de Timbrados Fallidos: " + countFallidos, null);
		return mensaje;
	}

	public MensajeTransaccionBean leerXML(GeneraEdoCtaBean generaEdoCtaBean) {
		/*Actualizacion para obtener datos del CFDI */
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<GeneraEdoCtaBean> mensajeClientes = null;
		GeneraEdoCtaBean generaEdo = null;
		GeneraEdoCtaBean generaEdoIter = null;

		String listaErrores = "Clientes a los cuales no se generaron los Estados de Cuenta: ";
		String listaCorrectos = "";
		try {
			//Obtener clientes que se le hayan generado su Timbrado
			mensajeClientes = consultaForanea(generaEdoCtaBean, Enum_Lis_EdoCta.foranea);
			//Leer sus xml por cada cliente
			//Actualizar los campos donde se va guardar los campos del CFDI
			String r;
			Iterator<GeneraEdoCtaBean> itera = null;
			itera = mensajeClientes.iterator();
			while(itera.hasNext()){
				generaEdo = new  GeneraEdoCtaBean();
				generaEdoIter = itera.next();
				generaEdo.setClienteID(generaEdoIter.getClienteID());
				generaEdo.setRutaCBB(generaEdoIter.getRutaCBB());
				generaEdo.setRutaXML(generaEdoIter.getRutaXML());
				generaEdo.setSucursalID(generaEdoIter.getSucursalID());

				generaEdo.setRutaCBBRet(generaEdoIter.getRutaCBBRet());
				generaEdo.setRutaXMLRet(generaEdoIter.getRutaXMLRet());

				boolean exists = (new File(generaEdo.getRutaXML())).exists();
				boolean existssRet = (new File(generaEdo.getRutaXMLRet())).exists();

				// Lee XM Tipo Timbrado Ingreso
	    		if (exists) {
	    			File fXmlFile = new File(generaEdo.getRutaXML());
					DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
					DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
					Document doc = dBuilder.parse(fXmlFile);
					//	optional, but recommended
					//read this - http://stackoverflow.com/questions/13786607/normalization-in-dom-parsing-with-java-how-does-it-work
					doc.getDocumentElement().normalize();

					String fechaTimbrado = "";
				    String selloCFD = "";
				    String noCertificadoSAT = "";
				    String UUID = "";
				    String version = "";
				    String selloSAT = "";
				    String fechaCertificacion = "";
				    String noCertEmisor = "";
				    String lugarExpedicion = "";
				    String serie = "";
				    String subTotal = "";
				    String descuento ="";
				    String total = "";
					NodeList nodeLst = doc.getElementsByTagName("cfdi:Comprobante");
					Element eleCode = (Element) nodeLst.item(0);
			        fechaCertificacion = eleCode.getAttribute("Fecha");
			        noCertEmisor = eleCode.getAttribute("NoCertificado");
			        lugarExpedicion = eleCode.getAttribute("LugarExpedicion");
			        serie = eleCode.getAttribute("Serie");
			        subTotal = eleCode.getAttribute("SubTotal");
			        descuento = eleCode.getAttribute("Descuento");
			        total = eleCode.getAttribute("Total");

			        for (int i = 0; i < nodeLst.getLength(); i++) {
				          Element ele = (Element) nodeLst.item(i);
				          NodeList nlsCode = ele.getElementsByTagName("tfd:TimbreFiscalDigital");
				          Element eleCode2 = (Element) nlsCode.item(0);
				          fechaTimbrado = eleCode2.getAttribute("FechaTimbrado");
					      selloCFD = eleCode2.getAttribute("SelloCFD");
					      noCertificadoSAT = eleCode2.getAttribute("NoCertificadoSAT");
					      UUID = eleCode2.getAttribute("UUID");
					      version = eleCode2.getAttribute("Version");
					      selloSAT = eleCode2.getAttribute("SelloSAT");
			        }

			        GeneraEdoCtaBean edoCtaCFDI = new GeneraEdoCtaBean();
			        edoCtaCFDI.setClienteID(generaEdo.getClienteID());
			        edoCtaCFDI.setSucursalID(generaEdo.getSucursalID());
					edoCtaCFDI.setVersion(version);
					edoCtaCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 90));
					edoCtaCFDI.setUUID(recorreCadena(UUID, 20));
					edoCtaCFDI.setFechaTimbrado(fechaTimbrado);
					edoCtaCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 90)));
			        edoCtaCFDI.setClienteID(generaEdo.getClienteID());

					edoCtaCFDI.setVersion(version);
					edoCtaCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 90));
					edoCtaCFDI.setUUID(recorreCadena(UUID, 20));
					edoCtaCFDI.setFechaTimbrado(fechaTimbrado);
					edoCtaCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 90)));
					edoCtaCFDI.setSelloSAT(recorreCadena(selloSAT, 90));
					edoCtaCFDI.setFechaCertificacion(fechaCertificacion);
					edoCtaCFDI.setNoCertEmisor(noCertEmisor);
					edoCtaCFDI.setLugarExpedicion(lugarExpedicion);
					// -------------------------------
					edoCtaCFDI.setSerie(serie);
					edoCtaCFDI.setSubTotal(subTotal);
					edoCtaCFDI.setDescuento(descuento);
					edoCtaCFDI.setTotal(total);
					edoCtaCFDI.setCadenaOriginal(recorreCadena("||"+version+ "|"+UUID+
							"|"+fechaTimbrado+"|"+selloCFD+"|"+noCertificadoSAT+"||", 90));

					edoCtaCFDI.setTipoTimbrado("I");

					mensaje = modificaDatosCte(edoCtaCFDI);
					if(mensaje.getNumero() != 0){
						throw new Exception(mensaje.getDescripcion());
					}
	    		}

	    		// Lee XM Tipo Timbrado Egreso
	    		if (existssRet) {
	    			File fXmlFile = new File(generaEdo.getRutaXMLRet());
					DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
					DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
					Document doc = dBuilder.parse(fXmlFile);
					//	optional, but recommended
					//read this - http://stackoverflow.com/questions/13786607/normalization-in-dom-parsing-with-java-how-does-it-work
					doc.getDocumentElement().normalize();

					String fechaTimbrado = "";
				    String selloCFD = "";
				    String noCertificadoSAT = "";
				    String UUID = "";
				    String version = "";
				    String selloSAT = "";
				    String fechaCertificacion = "";
				    String noCertEmisor = "";
				    String lugarExpedicion = "";
				    String serie = "";
				    String subTotal = "";
				    String descuento ="";
				    String total = "";
					NodeList nodeLst = doc.getElementsByTagName("cfdi:Comprobante");
					Element eleCode = (Element) nodeLst.item(0);
			        fechaCertificacion = eleCode.getAttribute("Fecha");
			        noCertEmisor = eleCode.getAttribute("NoCertificado");
			        lugarExpedicion = eleCode.getAttribute("LugarExpedicion");
			        serie = eleCode.getAttribute("Serie");
			        subTotal = eleCode.getAttribute("SubTotal");
			        descuento = eleCode.getAttribute("Descuento");
			        total = eleCode.getAttribute("Total");

			        for (int i = 0; i < nodeLst.getLength(); i++) {
				          Element ele = (Element) nodeLst.item(i);
				          NodeList nlsCode = ele.getElementsByTagName("tfd:TimbreFiscalDigital");
				          Element eleCode2 = (Element) nlsCode.item(0);
				          fechaTimbrado = eleCode2.getAttribute("FechaTimbrado");
					      selloCFD = eleCode2.getAttribute("SelloCFD");
					      noCertificadoSAT = eleCode2.getAttribute("NoCertificadoSAT");
					      UUID = eleCode2.getAttribute("UUID");
					      version = eleCode2.getAttribute("Version");
					      selloSAT = eleCode2.getAttribute("SelloSAT");
			        }

			        GeneraEdoCtaBean edoCtaCFDI = new GeneraEdoCtaBean();
			        edoCtaCFDI.setClienteID(generaEdo.getClienteID());
			        edoCtaCFDI.setSucursalID(generaEdo.getSucursalID());
					edoCtaCFDI.setVersion(version);
					edoCtaCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 90));
					edoCtaCFDI.setUUID(recorreCadena(UUID, 20));
					edoCtaCFDI.setFechaTimbrado(fechaTimbrado);
					edoCtaCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 90)));
			        edoCtaCFDI.setClienteID(generaEdo.getClienteID());

					edoCtaCFDI.setVersion(version);
					edoCtaCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 90));
					edoCtaCFDI.setUUID(recorreCadena(UUID, 20));
					edoCtaCFDI.setFechaTimbrado(fechaTimbrado);
					edoCtaCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 90)));
					edoCtaCFDI.setSelloSAT(recorreCadena(selloSAT, 90));
					edoCtaCFDI.setFechaCertificacion(fechaCertificacion);
					edoCtaCFDI.setNoCertEmisor(noCertEmisor);
					edoCtaCFDI.setLugarExpedicion(lugarExpedicion);
					// -------------------------------
					edoCtaCFDI.setSerie(serie);
					edoCtaCFDI.setSubTotal(subTotal);
					edoCtaCFDI.setDescuento(descuento);
					edoCtaCFDI.setTotal(total);
					edoCtaCFDI.setCadenaOriginal(recorreCadena("||"+version+ "|"+UUID+
							"|"+fechaTimbrado+"|"+selloCFD+"|"+noCertificadoSAT+"||", 90));

					edoCtaCFDI.setTipoTimbrado("E");

					mensaje = modificaDatosCte(edoCtaCFDI);
					if(mensaje.getNumero() != 0){
						throw new Exception(mensaje.getDescripcion());
					}
	    		}

			}
			mensaje.setNumero(Integer.valueOf(Constantes.ENTERO_CERO));
			mensaje.setDescripcion("Lectura XML Finalizado");
			mensaje.setNombreControl(Constantes.STRING_VACIO);
		 }catch(FileNotFoundException e){
			 listaErrores = listaErrores + ""+ generaEdo.getClienteID();
		 }catch (Exception e) {
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error Lextura XML" + e);
			e.printStackTrace();
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
	    }
		return mensaje;
	}

	public MensajeTransaccionBean generaEdoCtaUnico(GeneraEdoCtaBean generaEdoCtaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//Ejecucion de Estado de Cuentas
		try{
			String[] command = {"/bin/bash", "ejec_edoctaxsucurs.sh", generaEdoCtaBean.getSucursalInicio(), generaEdoCtaBean.getSucursalInicio(),
					generaEdoCtaBean.getClienteInicio(), generaEdoCtaBean.getClienteInicio(), generaEdoCtaBean.getOrigenDatos(),
					generaEdoCtaBean.getPrefijoEmpresa(), generaEdoCtaBean.getRutasSHs(), generaEdoCtaBean.getRutaPDI()};
			ProcessBuilder pb2 = new ProcessBuilder(command);
			pb2.directory(new File( generaEdoCtaBean.getRutasSHs() + "JOBS/" ));
			Process p2 = pb2.start();
			//p2.waitFor();
			InputStream is2 = p2.getInputStream();
			InputStreamReader isr2 = new InputStreamReader(is2);
			BufferedReader br2 = new BufferedReader(isr2);
			String line2;
			while ((line2 = br2.readLine()) != null) {
				System.out.println(line2);
			}
			//p2.destroy();
		}catch(Exception e){
			e.printStackTrace();
		}
		mensaje.setNumero(0);
		mensaje.setDescripcion("Generación de Estado de Cuentas ha Finalizado Correctamente");
		return mensaje;
	}

	public String recorreCadena(String cadena, int longitud){
		String cadenaArray[] = new String[cadena.length()];
	    String cadenaAux="";
	    int x = 0;
	    for(int i=0;i<cadenaArray.length;i++)
	    {
	    	cadenaAux += cadena.charAt(i);
	    	if(x == longitud ){
	    		cadenaAux += "\n";
	    		x = 0;
	    	}
	    	x++;
	    }
	    return cadenaAux;
	}
	public MensajeTransaccionBean modificaDatosCte(final GeneraEdoCtaBean datosCFDIBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query cons el Store Procedure
					String query = "call EDOCTADATOSCTEMOD(" +
							"?,?,?,?,?, ?,?,?,?,?," +
							"?,?,?,?,?, ?,?,?," +
							"?,?,?,?,?,	?,?,?);";
					Object[] parametros = {
							datosCFDIBean.getClienteID(),
							datosCFDIBean.getVersion(),
							datosCFDIBean.getNoCertificadoSAT(),
							datosCFDIBean.getUUID(),
							datosCFDIBean.getFechaTimbrado(),

							datosCFDIBean.getSelloCFD(),
							datosCFDIBean.getSelloSAT(),
							datosCFDIBean.getCadenaOriginal(),
							datosCFDIBean.getFechaCertificacion(),
							datosCFDIBean.getNoCertEmisor(),

							datosCFDIBean.getLugarExpedicion(),
							datosCFDIBean.getSucursalID(),
							datosCFDIBean.getSerie(),
							datosCFDIBean.getSubTotal(),
							datosCFDIBean.getDescuento(),

							datosCFDIBean.getTotal(),
							1,
							Constantes.ENTERO_CERO,
							datosCFDIBean.getTipoTimbrado(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};

					//Logeo del Query a Ejecutar
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTADATOSCTEMOD(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(resultSet.getString(4));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Cliente" + e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaDatosCteEstatus(final GeneraEdoCtaBean datosCFDIBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query cons el Store Procedure
					String query = "call EDOCTADATOSCTEMOD(" +
							"?,?,?,?,?, ?,?,?,?,?," +
							"?,?,?,?,?, ?,?,?," +
							"?,?,?,?,?,	?,?,?);";
					Object[] parametros = {
							datosCFDIBean.getClienteID(),
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,

							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,

							Constantes.STRING_VACIO,
							Constantes.ENTERO_CERO,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,


							Constantes.STRING_VACIO,
							2,
							datosCFDIBean.getEstatus(),
							datosCFDIBean.getTipoTimbrado(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};

					//Logeo del Query a Ejecutar
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTADATOSCTEMOD(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(resultSet.getString(4));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Cliente" + e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Consulta informacion de todos los clientes para generar CFDI
	public MensajeTransaccionBean consultaInfoCliente(final GeneraEdoCtaBean generaEdoCtaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call EDOCTATIMBRADOPRO("
							+ "?,?,?,?,?,		"
							+ "?,?,?,?,?,		"
							+ "?,?);";
					Object[] parametros = {
							generaEdoCtaBean.getFechaProceso(),/*01*/
							generaEdoCtaBean.getSucursalInicio(),/*02*/
							generaEdoCtaBean.getSucursalInicio(),/*03*/
							generaEdoCtaBean.getClienteID(),/*04*/
							Constantes.STRING_VACIO,/*05*/

							parametrosAuditoriaBean.getEmpresaID(),/*06*/
							parametrosAuditoriaBean.getUsuario(),/*07*/
							parametrosAuditoriaBean.getFecha(),/*08*/
							parametrosAuditoriaBean.getDireccionIP(),/*09*/
							"EdoCtaClienteDAO.consultaInfoCliente",/*10*/
							parametrosAuditoriaBean.getSucursal(),/*11*/
							parametrosAuditoriaBean.getNumeroTransaccion()/*12*/
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTATIMBRADOPRO(" +Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List<GeneraEdoCtaBean> consultaDatosCliente(GeneraEdoCtaBean generaEdoCtaBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call EDOCTADATOSCTELIS(?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?);";
		Object[] parametros = {
								generaEdoCtaBean.getFechaProceso(),
								generaEdoCtaBean.getSucursalInicio(),
								generaEdoCtaBean.getSucursalInicio(),
								generaEdoCtaBean.getClienteID(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTADATOSCTELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GeneraEdoCtaBean generaEdoCta = new GeneraEdoCtaBean();
				generaEdoCta.setFechaProceso(resultSet.getString("AnioMes"));
				generaEdoCta.setSucursalID(resultSet.getString("SucursalID"));
				generaEdoCta.setClienteID(resultSet.getString("ClienteID"));
				generaEdoCta.setCadenaCFDI(resultSet.getString("CadenaCFDI"));
				generaEdoCta.setEstatus(resultSet.getInt("Estatus"));
				generaEdoCta.setCadenaCFDIRet(resultSet.getString("CadenaCFDIRet"));
				generaEdoCta.setEstatusRet(resultSet.getInt("EstatusRet"));
				generaEdoCta.setIdentificadorBus(resultSet.getString("IdentificadorBus"));
				return generaEdoCta;
			}
		});
		return matches;
	}

	public List<GeneraEdoCtaBean> consultaForanea(GeneraEdoCtaBean generaEdoCtaBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call EDOCTADATOSCTELIS(?,?,?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
								generaEdoCtaBean.getFechaProceso(),
								generaEdoCtaBean.getSucursalInicio(),
								generaEdoCtaBean.getSucursalInicio(),
								Constantes.ENTERO_CERO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTADATOSCTELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GeneraEdoCtaBean generaEdoCta = new GeneraEdoCtaBean();
				generaEdoCta.setClienteID(resultSet.getString("ClienteID"));
				generaEdoCta.setSucursalID(resultSet.getString("SucursalID"));
				generaEdoCta.setRutaCBB(resultSet.getString("RutaCBB"));
				generaEdoCta.setRutaXML(resultSet.getString("RutaXML"));
				generaEdoCta.setRutaCBBRet(resultSet.getString("RutaCBBRet"));
				generaEdoCta.setRutaXMLRet(resultSet.getString("RutaXMLRet"));
				return generaEdoCta;
			}
		});
		return matches;
	}

	public GeneraEdoCtaBean consultaRangoClientes(GeneraEdoCtaBean generaEdoCta, int tipoConsulta) {
		GeneraEdoCtaBean generaEdoCtaBean= new GeneraEdoCtaBean();
		try{
			//Query con el Store Procedure
			String query = "call EDOCTADATOSCTELIS(?,?,?,?," +
													"?,?,?,?," +
													"?,?,?,?);";

			Object[] parametros = {
									generaEdoCta.getFechaProceso(),
									generaEdoCta.getSucursalInicio(),
									generaEdoCta.getSucursalFin(),
									Constantes.ENTERO_CERO,
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTADATOSCTELIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraEdoCtaBean generaEdoCta = new GeneraEdoCtaBean();
					generaEdoCta.setClienteInicio(resultSet.getString(1));
					generaEdoCta.setClienteFin(resultSet.getString(2));
					generaEdoCta.setNumRegistros(resultSet.getString(3));
					return generaEdoCta;
				}// trows ecexeption
			});//lista

			generaEdoCtaBean= matches.size() > 0 ? (GeneraEdoCtaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta ", e);
		}
		return generaEdoCtaBean;
	}



	public GeneraEdoCtaBean consultaParamEdoCta(GeneraEdoCtaBean generaEdoCta, int tipoConsulta) {
		GeneraEdoCtaBean generaEdo= new GeneraEdoCtaBean();
		try{
			//Query con el Store Procedure
			String query = "call EDOCTAPARAMSCON(?,?,?," +
													"?,?,?," +
													"?,?);";

			Object[] parametros = { tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAPARAMSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraEdoCtaBean generaEdoCta = new GeneraEdoCtaBean();
					generaEdoCta.setRutaEdoCtaPDF(resultSet.getString("RutaExpPDF"));
					generaEdoCta.setRutaCBB(resultSet.getString("RutaCBB"));
					generaEdoCta.setRutaXML(resultSet.getString("RutaCFDI"));
					generaEdoCta.setRfcEmisor(resultSet.getString("RFC"));
					generaEdoCta.setRutaReporte(resultSet.getString("RutaReporte"));
					return generaEdoCta;
				}// trows ecexeption
			});//lista

			generaEdo= matches.size() > 0 ? (GeneraEdoCtaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta ", e);
		}
		return generaEdo;
	}

	public GeneraEdoCtaBean consultaClientes(GeneraEdoCtaBean generaEdoCta, int tipoConsulta) {
		GeneraEdoCtaBean generaEdoCtaBean= new GeneraEdoCtaBean();
		try{
			//Query con el Store Procedure
			String query = "call EDOCTADATOSCTECON(?,?,?,?," +
													"?,?,?," +
													"?,?,?,?,?);";

			Object[] parametros = {
									generaEdoCta.getFechaProceso(),
									generaEdoCta.getSucursalInicio(),
									generaEdoCta.getSucursalInicio(),
									Constantes.STRING_VACIO,
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTADATOSCTECON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraEdoCtaBean generaEdoCta = new GeneraEdoCtaBean();
					generaEdoCta.setNumRegistros(resultSet.getString("NumRegistros"));
					return generaEdoCta;
				}// trows ecexeption
			});//lista

			generaEdoCtaBean= matches.size() > 0 ? (GeneraEdoCtaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta ", e);
		}
		return generaEdoCtaBean;
	}

	/**
	 * Funcion para dar de alta en base de datos el archivo xml del timbrado en formato de cadena.
	 *
	 * @param generaEdoCta: Bean con los datos para encontrar donde se da de alta la cadena xml
	 * @param cadenaXml: Cadena que representa el archivo xml generado en el timbrado.
	 * @return MensajeTransaccionBean
	 * @author jcardenas
	 */
	public MensajeTransaccionBean altaCadenaXml(final GeneraEdoCtaBean generaEdoCta, final String cadenaXml) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		@SuppressWarnings("unchecked")
		public Object doInTransaction(TransactionStatus transaction) {

			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

				// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call EDOCTAXMLTIMBREALT(?,?,?,?,?,	?,?,?,?,?," +
																	"?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_AnioMes",Utileria.convierteEntero(generaEdoCta.getFechaProceso()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(generaEdoCta.getClienteID()));
								sentenciaStore.setString("Par_Xml",cadenaXml);
								sentenciaStore.setString("Par_TipoTimbrado",generaEdoCta.getTipoTimbrado());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","EdoCtaClienteDAO.altaCadenaXml");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {

								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){

									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
								}else{

									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EdoCtaClienteDAO.altaCadenaXml");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){

						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .EdoCtaClienteDAO.altaCadenaXml");
					}else if(mensajeBean.getNumero()!=0){

						throw new Exception(mensajeBean.getDescripcion());

					}
				} catch (Exception e) {

					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cadena XML" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {

						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**
	 * Funcion para actualizar el estatus del estado de cuenta de un cliente en base a la tabla EDOCTADATOSCTE.
	 *
	 * @param generaEdoCta: Bean con los datos para actualizar el estatus.
	 * @return MensajeTransaccionBean
	 * @author jcardenas
	 */
	public MensajeTransaccionBean actualizaEstEdoCtaPorCli(final GeneraEdoCtaBean generaEdoCta) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call EDOCTAENVIOCORREOACT(" +
																		"?,?,?,?,?, ?,?,?,?,?," +
																		"?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_AnioMes",Utileria.convierteEntero(generaEdoCta.getFechaProceso()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(generaEdoCta.getClienteID()));
								sentenciaStore.setString("Par_FechaEnvio",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Productos",Constantes.STRING_VACIO );
								sentenciaStore.setInt("Par_NumAct",Enum_Act_EdoCta.estEdoCtaXCli);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","GeneraEdoCtaDAO.altaCadenaXml");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							       loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GeneraEdoCtaDAO.actualizaEstEdoCtaPorCli");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .GeneraEdoCtaDAO.actualizaEstEdoCtaPorCli");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cadena XML" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public GeneraEdoCtaBean consultaEdoCtaPerMenEjecutado(GeneraEdoCtaBean generaEdoCta, int tipoConsulta) {
		GeneraEdoCtaBean generaEdo= new GeneraEdoCtaBean();
		try{
			//Query con el Store Procedure
			String query = "call EDOCTAPERMENEJECUTADOSCON(?,?,?,?,		?," +
															"?,?,?,?,?,?,?);";

			Object[] parametros = {
									Utileria.convierteEntero(generaEdoCta.getAnioGeneracion()),
									Utileria.convierteEntero(generaEdoCta.getMesInicioGen()),
									Utileria.convierteEntero(generaEdoCta.getMesFinGen()),
									generaEdoCta.getTipoGeneracion(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAPERMENEJECUTADOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraEdoCtaBean generaEdoCta = new GeneraEdoCtaBean();
					generaEdoCta.setAnioGeneracion(resultSet.getString("Anio"));
					generaEdoCta.setMesInicioGen(resultSet.getString("MesInicio"));
					generaEdoCta.setMesFinGen(resultSet.getString("MesFin"));
					generaEdoCta.setTipoGeneracion(resultSet.getString("Tipo"));
					return generaEdoCta;
				}// throws exception
			});//lista

			generaEdo= matches.size() > 0 ? (GeneraEdoCtaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta ", e);
		}
		return generaEdo;
	}

	//Consulta informacion de todos los clientes para generar CFDI a traves de un ETL para el cliente Crediclub
	public MensajeTransaccionBean editaParamsConexionETL(final GeneraEdoCtaBean generaEdoCtaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String linea;
		List<String> lineas = new ArrayList<String>();
		//Ejecucion de Estado de Cuentas
		try{
			//Se modifica el archivo de conexiones para insertar las sucursales
			//colocadas en la pantalla
			File fichero = new File("/opt/SAFI/EdoCta/Crediclub/Conexiones.properties");
			FileReader freader = new FileReader(fichero);
			BufferedReader archivo = new BufferedReader(freader);
			while ((linea = archivo.readLine()) != null) {
				if (linea.contains("V.SUC.INI=")){
					linea = linea.replaceAll("[0-9]", "");
					linea = linea.concat(generaEdoCtaBean.getSucursalInicio());
				}
				if (linea.contains("V.SUC.FIN=")){
					linea = linea.replaceAll("[0-9]", "");
					linea = linea.concat(generaEdoCtaBean.getSucursalInicio());
				}
				if (linea.contains("V.CLIENTEID=")){
					linea = linea.replaceAll("[0-9]", "");
					linea = linea.concat(generaEdoCtaBean.getClienteID());
				}
				linea = linea.concat("\n");
				lineas.add(linea);
			}
			freader.close();
			archivo.close();

			FileWriter fw = new FileWriter(fichero);
			BufferedWriter out = new BufferedWriter(fw);
			for(String s : lineas)
				out.write(s);
			out.flush();
			out.close();
			mensaje.setNumero(0);
			mensaje.setDescripcion("Edicion de parametros de conexion con ETL Finalizado con exito");
		}catch(IllegalThreadStateException e){
			mensaje.setNumero(Integer.valueOf("001"));
			mensaje.setDescripcion("Error al Editar parametros de conexion del ETL");
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en edicion de parametros de conexion ", e);
		}
		return mensaje;
	}

	//Consulta informacion de todos los clientes para generar CFDI a traves de un ETL para el cliente Crediclub
	public MensajeTransaccionBean consultaInfoClienteCrediclub(final GeneraEdoCtaBean generaEdoCtaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//Ejecucion de Estado de Cuentas
		try{
			ProcessBuilder pb = new ProcessBuilder("/bin/bash", "./EdoctaSafi_SoloCadenaCFDI.sh", generaEdoCtaBean.getFechaProceso(), generaEdoCtaBean.getSucursalInicio(), generaEdoCtaBean.getSucursalInicio(), generaEdoCtaBean.getClienteID() );
			pb.directory(new File("/opt/SAFI/EdoCta/Crediclub/"));
			Process p = pb.start();
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			String line;
			while ((line = br.readLine()) != null) {
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Ejecucion de JOB de generacion de cadenas: " + line);
			}
			mensaje.setNumero(0);
			mensaje.setDescripcion("Generacion de Cadenas CFDI finalizada Correctamente");
		}catch(IllegalThreadStateException e){
			mensaje.setNumero(Integer.valueOf("001"));
			mensaje.setDescripcion("Error al Generar Cadenas CFDI del cliente solicitado");
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de cadena CFDI ", e);
		}
		return mensaje;
	}

	//Realiza el timbrado del rango de sucursales parametrizado en pantalla
	public MensajeTransaccionBean realizaTimbradoCrediclub(final GeneraEdoCtaBean generaEdoCtaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String linea;
		List<String> lineas = new ArrayList<String>();
		//Ejecucion de Estado de Cuentas
		try{
			ProcessBuilder pb = new ProcessBuilder("/bin/bash", "./EdoctaSafi_SoloTimbre.sh");
			pb.directory(new File("/opt/SAFI/EdoCta/Crediclub/"));
			Process p = pb.start();
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader bufferedR = new BufferedReader(isr);
			String line;
			while ((line = bufferedR.readLine()) != null) {
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Ejecucion de JOB de generacion de cadenas: " + line);
			}
			mensaje.setNumero(0);
			mensaje.setDescripcion("Generación de Estado de Cuentas ha Finalizado Correctamente");
		}catch(IllegalThreadStateException e){
			mensaje.setNumero(Integer.valueOf("001"));
			mensaje.setDescripcion("Error al Generar Cadenas CFDI del cliente solicitado");
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de cadena CFDI ", e);
		}
		return mensaje;
	}

	public MensajeTransaccionBean generaEdoCtaUnicoCrediclub(GeneraEdoCtaBean generaEdoCtaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//Generacion de Archivos de Estado de Cuentas
		try{
			ProcessBuilder pb = new ProcessBuilder("/bin/bash", "./EdoctaSafi_SoloArchivos.sh");
			pb.directory(new File("/opt/SAFI/EdoCta/Crediclub/"));
			Process p = pb.start();
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader bufferedR = new BufferedReader(isr);
			String line;
			while ((line = bufferedR.readLine()) != null) {
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Ejecucion de JOB de generacion de archivos: " + line);
			}
			mensaje.setNumero(0);
			mensaje.setDescripcion("Generación de Estado de Cuentas ha Finalizado Correctamente");
		}catch(IllegalThreadStateException e){
			mensaje.setNumero(Integer.valueOf("001"));
			mensaje.setDescripcion("Error al generar los archivos de estado de cuenta del cliente solicitado");
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de archivos de Edo. de Cta.  ", e);
		}
		return mensaje;
	}



	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

	public InstitucionesServicio getInstitucionesServicio() {
		return institucionesServicio;
	}

	public void setInstitucionesServicio(InstitucionesServicio institucionesServicio) {
		this.institucionesServicio = institucionesServicio;
	}

	public EdoCtaRecursoDAO getEdoCtaRecursoDAO() {
		return edoCtaRecursoDAO;
	}

	public void setEdoCtaRecursoDAO(EdoCtaRecursoDAO edoCtaRecursoDAO) {
		this.edoCtaRecursoDAO = edoCtaRecursoDAO;
	}
	public HubServiciosDAO getHubServiciosDAO() {
		return hubServiciosDAO;
	}
	public void setHubServiciosDAO(HubServiciosDAO hubServiciosDAO) {
		this.hubServiciosDAO = hubServiciosDAO;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}

	public CompaniasServicio getCompaniasServicio() {
		return companiasServicio;
	}

	public void setCompaniasServicio(CompaniasServicio companiasServicio) {
		this.companiasServicio = companiasServicio;
	}

	public EdoCtaParamsDAO getEdoCtaParamsDAO() {
		return edoCtaParamsDAO;
	}

	public void setEdoCtaParamsDAO(EdoCtaParamsDAO edoCtaParamsDAO) {
		this.edoCtaParamsDAO = edoCtaParamsDAO;
	}
}
