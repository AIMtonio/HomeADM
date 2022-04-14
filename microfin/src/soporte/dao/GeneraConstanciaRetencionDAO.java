package soporte.dao;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
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

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import soporte.FacturacionElectronicaWS;
import soporte.bean.GeneraConstanciaRetencionBean;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParametrosSisServicio;

public class GeneraConstanciaRetencionDAO extends BaseDAO{

	public GeneraConstanciaRetencionDAO(){
		super();
	}

	String cliProcEspecMexi = "40";

	// Consulta de Constancias de Retención
	public static interface Enum_Con_ConsRet {
		int principal 		= 1;
		int foranea			= 2;
		int rango 			= 3;
		int paramConsRet	= 5;
		int rangoCtePDF		= 6;
		int rangoMasivo 	= 7;
	}

	// Listas de Constancias de Retención
	public static interface Enum_Lis_ConsRet {
		int principal 	= 1;
		int foranea		= 2;
		int lis_Suc		= 5;
	}

	// Consulta de Clientes
	public static interface Enum_Con_Cli {
		int principal 	= 1;
		int foranea		= 2;
	}

	// Consulta INPC
	public static interface Enum_Con_INPC {
		int foranea		= 2;
	}

	// Consulta Cliente Específico
	public static interface Enum_Con_CliProcEspec {
		int conCteEspecifico	= 13;
	}

	public static interface Enum_Con_ConsRetencion {
		int rangoClientes 	= 3;
	}
	ParametrosSisServicio parametrosSisServicio = null;
	ConstanciaRecursoDAO constanciaRecursoDAO	= null;
	ParamGeneralesDAO paramGeneralesDAO = null;
	GeneraConsRetencionCteDAO generaConsRetencionCteDAO = null;

	public MensajeTransaccionBean generacionConstanciaRetencion(final GeneraConstanciaRetencionBean generaConstanciaRetencionBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		try{
			//CONSULTA LOS PARAMETROS CONSTANCIAS DE RETENCION
			//QUE EL USUARIO Y PASSWORD PARA CONECTAR AL WS DEE TIMBRADO ESTEN CAPTURADOS
			GeneraConstanciaRetencionBean generaConstanciaRetencion = new GeneraConstanciaRetencionBean();
			generaConstanciaRetencion = consultaParamConstancia (generaConstanciaRetencionBean,Enum_Con_ConsRet.foranea);

			generaConstanciaRetencionBean.setUsuarioWS(generaConstanciaRetencion.getUsuarioWS());
			generaConstanciaRetencionBean.setContraseniaWS(generaConstanciaRetencion.getContraseniaWS());
			generaConstanciaRetencionBean.setUrlWSDL(generaConstanciaRetencion.getUrlWSDL());
			generaConstanciaRetencionBean.setTimbraConsRet(generaConstanciaRetencion.getTimbraConsRet());
			generaConstanciaRetencionBean.setTipoProveedorWS(generaConstanciaRetencion.getTipoProveedorWS());
			generaConstanciaRetencionBean.setTokenAcceso(generaConstanciaRetencion.getTokenAcceso());
			generaConstanciaRetencionBean.setRutaArchivosCertificado(generaConstanciaRetencion.getRutaArchivosCertificado());
			generaConstanciaRetencionBean.setNombreCertificado(generaConstanciaRetencion.getNombreCertificado());
			generaConstanciaRetencionBean.setNombreLlavePriv(generaConstanciaRetencion.getNombreLlavePriv());
			generaConstanciaRetencionBean.setRutaArchivosXSLT(generaConstanciaRetencion.getRutaArchivosXSLT());
			generaConstanciaRetencionBean.setPassCertificado(generaConstanciaRetencion.getPassCertificado());

			//SI SE REQUIERE HACER EL TIMBRADO DE LAS CONSTANCIAS VALIDA QUE EL USUARIO Y PASSWORD PARA CONECTAR AL PAC ESTEN CAPTURADOS
			if (generaConstanciaRetencionBean.getTimbraConsRet().equals(generaConstanciaRetencionBean.TimbraConstanciaSI)) {
				if(generaConstanciaRetencionBean.getUsuarioWS() == null || generaConstanciaRetencionBean.getUsuarioWS().equals("") ||
					generaConstanciaRetencionBean.getUrlWSDL() == null || generaConstanciaRetencionBean.getUrlWSDL().equals("") ||
					generaConstanciaRetencionBean.getContraseniaWS() == null || generaConstanciaRetencionBean.getContraseniaWS().equals("")){
					mensaje.setNumero(1);
					mensaje.setDescripcion("Especifique los Parametro Usuario, Password y WSDL para Conectar con el WS.");
					throw new Exception(mensaje.getDescripcion());
				}
			}

			if(generaConstanciaRetencion.getRfcEmisor().equals("")|| generaConstanciaRetencion.getRutaConstanciaPDF().equals("")
					||generaConstanciaRetencion.getRutaCBB().equals("") || generaConstanciaRetencion.getRutaXML().equals("")){
				mensaje.setNumero(2);
				mensaje.setDescripcion("Especifique en Parámetros Constancia de Retención las Rutas de los Directorios.");
				throw new Exception(mensaje.getDescripcion());
			}
			else{
				generaConstanciaRetencionBean.setRfcEmisor(generaConstanciaRetencion.getRfcEmisor());
				generaConstanciaRetencionBean.setRutaConstanciaPDF(generaConstanciaRetencion.getRutaConstanciaPDF());
				generaConstanciaRetencionBean.setRutaCBB(generaConstanciaRetencion.getRutaCBB());
				generaConstanciaRetencionBean.setRutaXML(generaConstanciaRetencion.getRutaXML());
				generaConstanciaRetencionBean.setRutaETL(generaConstanciaRetencion.getRutaETL());
			}

			//CONSULTA SI EXISTE REGISTROS DEL ANIO SELECCIONADO
			GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
			generaConstancia = consultaDatosAnio(generaConstanciaRetencionBean, Enum_Con_Cli.foranea);
			if (Integer.valueOf(generaConstancia.getNumRegistrosAnio()) == Constantes.ENTERO_CERO){
				mensaje.setNumero(3);
				mensaje.setDescripcion("No Existe Información del Año Seleccionado.");
				throw new Exception(mensaje.getDescripcion());
			}

			//CONSULTA INFORMACION DISPONIBLE PARA LA FECHA SELECCIONADA
			generaConstancia = new GeneraConstanciaRetencionBean();
			generaConstancia = consultaClientes(generaConstanciaRetencionBean, Enum_Con_Cli.principal);
			if (Integer.valueOf(generaConstancia.getNumRegistros()) == Constantes.ENTERO_CERO){
				mensaje.setNumero(4);
				mensaje.setDescripcion("No Existe Información en la Sucursal del Año Seleccionado.");
				throw new Exception(mensaje.getDescripcion());
			}

			// CONSULTA INFORMACION DEL CLIENTE PARA GENERAR CFDI y SALDO PROMEDIO
			mensaje = consultaInfoCliente(generaConstanciaRetencionBean);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}

			// CREA ESTRUCTURAS DE CARPETAS PARA EL ALOJAMIENTO DE LAS CONSTANCIAS DE RETENCIÓN
			String[] parametros = {
					generaConstanciaRetencionBean.getRutaConstanciaPDF()+generaConstanciaRetencionBean.getAnioProceso(),
					generaConstanciaRetencionBean.getRutaETL()
			};
			mensaje = procesarArchivoSH(generaConstanciaRetencionBean.getRutaETL()+"SH/","ejec_creadirectorios.sh",parametros);
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}

			// Valida Directorios Creados
			mensaje = validaDirectorios();

			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}

			ParamGeneralesBean paramGeneralesConBean = new ParamGeneralesBean();
			paramGeneralesConBean = paramGeneralesDAO.consultaPrincipal(paramGeneralesConBean,Enum_Con_CliProcEspec.conCteEspecifico);

			String sucursalInicio = generaConstanciaRetencionBean.getSucursalInicio();
			String sucursalFin = generaConstanciaRetencionBean.getSucursalFin();
			//Realizamos timbrado de Constancias de Retencion
			if (generaConstanciaRetencionBean.getTimbraConsRet().equals(generaConstanciaRetencionBean.TimbraConstanciaSI)) {
				if(!paramGeneralesConBean.getValorParametro().equalsIgnoreCase(cliProcEspecMexi)){
					if(generaConstanciaRetencionBean.getTipoProveedorWS().equals("3")){//el proveedor 3 hub servicios
						mensaje= generaConsRetencionCteDAO.realizaTimbradoHubServicios(generaConstanciaRetencionBean,Enum_Lis_ConsRet.principal);
					}
					else if(generaConstanciaRetencionBean.getTipoProveedorWS().equals("2")){//el proveedor 2 es smarter web
						mensaje= generaConsRetencionCteDAO.realizaTimbradoSmarterWeb(generaConstanciaRetencionBean,Enum_Lis_ConsRet.principal);
					}else{// si no utiliza el proveedor uno facturacion moderna
						mensaje= realizaTimbrado(generaConstanciaRetencionBean);
					}
				}
				else{
					mensaje = realizaTimbradoConstancia(generaConstanciaRetencionBean);
				}

				if(mensaje.getNumero() != 0){
					throw new Exception(mensaje.getDescripcion());
				}else{
					//Obtenemos numero de Timbrados Exitosos
					generaConstanciaRetencionBean.setTotalTimbrados(mensaje.getConsecutivoInt());
				}
			}
			else{

				if(!paramGeneralesConBean.getValorParametro().equalsIgnoreCase(cliProcEspecMexi)){
					mensaje = leerXML(generaConstanciaRetencionBean);
				}
				else{
					mensaje = leerXMLConstancia(generaConstanciaRetencionBean);
				}
			}

			GeneraConstanciaRetencionBean generaConstanciaRango = new GeneraConstanciaRetencionBean();

			if (generaConstanciaRetencionBean.getTimbraConsRet().equals(generaConstanciaRetencionBean.TimbraConstanciaSI)){
				if(!paramGeneralesConBean.getValorParametro().equalsIgnoreCase(cliProcEspecMexi)){
					generaConstanciaRango = consultaRangoClientes(generaConstanciaRetencionBean, Enum_Con_ConsRet.rango);
				}else{
					GeneraConstanciaRetencionBean generaConstanciaSucursal = new GeneraConstanciaRetencionBean();

					generaConstanciaSucursal = consultaSucursales(generaConstanciaRetencionBean, Enum_Lis_ConsRet.lis_Suc);
					generaConstanciaRetencionBean.setSucursalInicio(generaConstanciaSucursal.getSucursalInicio());
					generaConstanciaRetencionBean.setSucursalFin(generaConstanciaSucursal.getSucursalFin());

					generaConstanciaRango = consultaRangoClientesRelacionados(generaConstanciaRetencionBean, Enum_Con_ConsRetencion.rangoClientes);

					if(generaConstanciaRango.getClienteInicio() == null){

						generaConstanciaRetencionBean.setSucursalInicio(sucursalInicio);
						generaConstanciaRetencionBean.setSucursalFin(sucursalFin);

						generaConstanciaRango = consultaRangoClientesRelacionados(generaConstanciaRetencionBean, Enum_Con_ConsRet.rangoMasivo);

					}

				}
			}else{
				if(!paramGeneralesConBean.getValorParametro().equalsIgnoreCase(cliProcEspecMexi)){
					generaConstanciaRango = consultaRangoClientes(generaConstanciaRetencionBean, Enum_Con_ConsRet.rango);
				}else{
					GeneraConstanciaRetencionBean generaConstanciaSucursal = new GeneraConstanciaRetencionBean();

					generaConstanciaSucursal = consultaSucursales(generaConstanciaRetencionBean, Enum_Lis_ConsRet.lis_Suc);
					generaConstanciaRetencionBean.setSucursalInicio(generaConstanciaSucursal.getSucursalInicio());
					generaConstanciaRetencionBean.setSucursalFin(generaConstanciaSucursal.getSucursalFin());

					if(generaConstanciaRetencionBean.getSucursalInicio() == null){

						generaConstanciaRetencionBean.setSucursalInicio(sucursalInicio);
						generaConstanciaRetencionBean.setSucursalFin(sucursalFin);
					}

					generaConstanciaRango = consultaRangoClientesRelacionados(generaConstanciaRetencionBean, Enum_Con_ConsRet.rangoMasivo);
				}
			}

			generaConstanciaRango.setAnioProceso(generaConstanciaRetencionBean.getAnioProceso());
			generaConstanciaRango.setSucursalInicio(generaConstanciaRetencionBean.getSucursalInicio());
			generaConstanciaRango.setSucursalFin(generaConstanciaRetencionBean.getSucursalFin());
			int inicio = Integer.parseInt(generaConstanciaRango.getClienteInicio());
			generaConstanciaRango.setOrigenDatos(generaConstanciaRetencionBean.getOrigenDatos());
			int fin = Integer.parseInt(generaConstanciaRango.getClienteFin());

			// SI EL NUMERO DE REGISTROS ES MAYOR AL PARAMETRO 500 LA GENEERACIÓN DE LOS PDF SERA EN BLOQUES IGUAL AL PARAMETRO
			if (Integer.valueOf(generaConstanciaRango.getNumRegistros()) > 500 ){
				for (int i= inicio; i<= fin; i++){
					GeneraConstanciaRetencionBean rangoCtsPDF = new GeneraConstanciaRetencionBean();
					rangoCtsPDF.setAnioProceso(generaConstanciaRango.getAnioProceso());
					rangoCtsPDF.setSucursalInicio(generaConstanciaRango.getSucursalInicio());
					rangoCtsPDF.setSucursalFin(generaConstanciaRango.getSucursalFin());
					rangoCtsPDF.setClienteID(String.valueOf(i));
					rangoCtsPDF = consultaRangoClientes(rangoCtsPDF, Enum_Con_ConsRet.rangoCtePDF);
					int aux = 0;
					if(!rangoCtsPDF.getNumRegistros().equals("0")){
						i = Integer.valueOf(rangoCtsPDF.getClienteInicio());
						aux = Integer.valueOf(rangoCtsPDF.getClienteFin());;

						generaConstanciaRango.setClienteInicio(String.valueOf(i));
						generaConstanciaRango.setClienteFin(String.valueOf(aux));

						// Se genera la Constancia de Retención del Cliente
						String[] parametros2 = {
							Integer.toString(Utileria.convierteEntero(generaConstanciaRango.getAnioProceso())),
							Integer.toString(Utileria.convierteEntero(generaConstanciaRango.getSucursalInicio())),
							Integer.toString(Utileria.convierteEntero(generaConstanciaRango.getSucursalFin())),
							Integer.toString(Utileria.convierteEntero(generaConstanciaRango.getClienteInicio())),
							Integer.toString(Utileria.convierteEntero(generaConstanciaRango.getClienteFin())),
							generaConstanciaRetencionBean.getRutaETL(),
						};
						mensaje = procesarArchivoSH(generaConstanciaRetencionBean.getRutaETL()+"SH/","ejec_consretxsucurs.sh",parametros2);
						if(mensaje.getNumero() != 0){
							throw new Exception(mensaje.getDescripcion());
						}
					}else{
						aux= fin;
					}

					i= aux;
				}

			}else{
				// Se genera la Constancia de Retención del Cliente
				String[] parametros2 = {
					Integer.toString(Utileria.convierteEntero(generaConstanciaRango.getAnioProceso())),
					Integer.toString(Utileria.convierteEntero(generaConstanciaRango.getSucursalInicio())),
					Integer.toString(Utileria.convierteEntero(generaConstanciaRango.getSucursalFin())),
					Integer.toString(Utileria.convierteEntero(generaConstanciaRango.getClienteInicio())),
					Integer.toString(Utileria.convierteEntero(generaConstanciaRango.getClienteFin())),
					generaConstanciaRetencionBean.getRutaETL(),
				};
				mensaje = procesarArchivoSH(generaConstanciaRetencionBean.getRutaETL()+"SH/","ejec_consretxsucurs.sh",parametros2);
				if(mensaje.getNumero() != 0){
					throw new Exception(mensaje.getDescripcion());
				}
			}
			mensaje.setNumero(0);
			mensaje.setDescripcion("Generación de Constancias de Retención Finalizado Exitosamente.");
			mensaje.setNombreControl("procesar");

		} catch (Exception e) {
			if(mensaje .getNumero()==0){
				mensaje .setNumero(999);
				mensaje.setDescripcion("Error en Proceso de Generacion de Constancias de Retención.");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Generación de Constancias de Retención.", e);
		}
		return mensaje;
	}

	// Consulta registros del INPC el Anio seleccionado
	public MensajeTransaccionBean validaInfoINPC(final GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
					generaConstancia = consultaDatosINPC(generaConstanciaRetencionBean, Enum_Con_INPC.foranea);
					if (Integer.valueOf(generaConstancia.getNumRegistrosINPC()) != 12){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Registrar los Valores del INPC de los Meses Faltantes del Año Seleccionado.");
						throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error en Validación de Informacion INPC sobre el Año Seleccionado.");
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					//e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Validación de Informacion INPC sobre el Año Seleccionado.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Se valida si existen registros del Anio seleccionado
	public MensajeTransaccionBean validaDatosAnio(final GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
					generaConstancia = consultaDatosAnio(generaConstanciaRetencionBean, Enum_Con_Cli.foranea);
					if (Integer.valueOf(generaConstancia.getNumRegistrosAnio()) == Constantes.ENTERO_CERO){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("No Existe Información del Año Seleccionado.");
						throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error en Validación de Información del Año Seleccionado.");
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					//e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Validación de Información del Año Seleccionado.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Se valida si existen registros de la sucursal del Anio seleccionado
	public MensajeTransaccionBean validaInfoCliente(final GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
					generaConstancia = consultaClientes(generaConstanciaRetencionBean, Enum_Con_Cli.principal);
					if (Integer.valueOf(generaConstancia.getNumRegistros()) == Constantes.ENTERO_CERO){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("No Existe Información en la Sucursal del Año Seleccionado.");
						throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error en Validacion de Información en la Sucursal del Año Seleccionado.");
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					//e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Validacion de Información en la Sucursal del Año Seleccionado", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Crea estructuras de Carpetas para el Alojamiento de las Constancias de Retención
	public MensajeTransaccionBean creaEstructura(GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//Ejecucion de Constancias de Retención
		try{
			ProcessBuilder pb = new ProcessBuilder("/bin/bash", "./ejec_creadirectorios.sh", generaConstanciaRetencionBean.getRutaConstanciaPDF()+generaConstanciaRetencionBean.getAnioProceso(),generaConstanciaRetencionBean.getOrigenDatos());
			pb.directory(new File("/opt/SAFI/ConstanciaRetencion/JOBS/"));
			Process p = pb.start();
			//p.waitFor();
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			String line;
			while ((line = br.readLine()) != null) {
				System.out.println(line);
			}
		}catch(IllegalThreadStateException e){
			mensaje.setNumero(Integer.valueOf("001"));
			mensaje.setDescripcion("Error al Generar Estructura de Carpetas para Constancias de Retención");
		}catch(Exception e){
			e.printStackTrace();
		}
		return mensaje;
	}

	// Valida Directorios Creados
	public MensajeTransaccionBean validaDirectorios(){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<GeneraConstanciaRetencionBean> directorios;
		directorios = constanciaRecursoDAO.consultaDirecConsRet();
		for(GeneraConstanciaRetencionBean directorio:directorios){
			String path=directorio.getRutaConstanciaPDF().substring(18,directorio.getRutaConstanciaPDF().length());
			File dir=new File(path);
			if(!dir.exists()){
				//Crear el directorio
				dir.mkdirs();
				if(!dir.exists()){
					mensaje.setNumero(Integer.valueOf("001"));
					mensaje.setDescripcion("Error al Crear los Directorios.");
					return mensaje;
				}
			}
		}
		mensaje.setNumero(Integer.valueOf("000"));
		mensaje.setDescripcion("Directorios Generados con Exito.");
		return mensaje;
	}

	// Se realiza el timbrado de Constancias de Retencion
	public MensajeTransaccionBean realizaTimbrado(GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
		// Realizar el timbrado para cada cliente
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<GeneraConstanciaRetencionBean> mensajeClientes = null;

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
		FacturacionElectronicaWS connect = new FacturacionElectronicaWS(generaConstanciaRetencionBean.getUrlWSDL(), generaConstanciaRetencionBean.getUsuarioWS(), generaConstanciaRetencionBean.getContraseniaWS(),
				generaConstanciaRetencionBean.getRfcEmisor(), generaPDF, generaTXT, generaCBB);

		mensajeClientes = consultaDatosCliente(generaConstanciaRetencionBean, Enum_Lis_ConsRet.principal);
		GeneraConstanciaRetencionBean generaConstancia = null;
		GeneraConstanciaRetencionBean generaConsIter = null;
		String pathdir = generaConstanciaRetencionBean.getRutaConstanciaPDF();
		int countExitos = 0;
		int countFallidos = 0;
		String r;
		Iterator<GeneraConstanciaRetencionBean> itera = null;
		itera = mensajeClientes.iterator();
		while(itera.hasNext()){
			generaConstancia = new  GeneraConstanciaRetencionBean();
			generaConsIter = itera.next();
			generaConstancia.setCadenaCFDI(generaConsIter.getCadenaCFDI());
			generaConstancia.setClienteID(generaConsIter.getClienteID());
			generaConstancia.setSucursal(generaConsIter.getSucursalID());
			generaConstancia.setAnioProceso(generaConsIter.getAnioProceso());

			if (!generaConstancia.getCadenaCFDI().isEmpty() && generaConsIter.getEstatus()!=2){
				r = connect.timbrarFactura(generaConstancia.getCadenaCFDI());

				if (r.equals("error")) {
					countFallidos++;
					generaConstancia.setEstatus(3);
					actualizaDatosCteEstatus(generaConstancia);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Timbrado Fallido. Cliente: "+ generaConstancia.getClienteID() +"\nError: " + r , null);
				}
				else {
					countExitos++;
					String xml = new String(Base64Decoder.decode(connect.strXml));
					generaConstancia.setEstatus(2);
					actualizaDatosCteEstatus(generaConstancia);
					try {
						File archivo = new File(generaConstanciaRetencionBean.getRutaXML()+generaConstanciaRetencionBean.getAnioProceso()+"/"+Utileria.completaCerosIzquierda(generaConstancia.getSucursal(), 3) +"/"+ Utileria.completaCerosIzquierda(generaConstancia.getClienteID(),10)+"-"+generaConstanciaRetencionBean.getAnioProceso()+".xml" );
						FileWriter escribir = new FileWriter(archivo);
						escribir.write(xml);
						escribir.close();
					}catch(Exception e) {
						loggerSAFI.info(this.getClass()+" - "+"WS: " +e.getMessage().toString());
					}
					if (connect.generarPDF) {
						OutputStream out;
						try {
							byte[] b = Base64Decoder.decode(connect.strPdf);
							File archivo = new File("/opt/SAFI/ConstanciaRetencion/"+generaConstanciaRetencionBean.getAnioProceso()+"/"+Utileria.completaCerosIzquierda(generaConstancia.getSucursal(), 3) +"/"+ Utileria.completaCerosIzquierda(generaConstancia.getClienteID(),10)+"-"+generaConstanciaRetencionBean.getAnioProceso()+"PAC.pdf");
							out = new FileOutputStream(archivo);
							out.write(b, 0, b.length);
							out.close();
						}catch (Exception e) {
							loggerSAFI.info(this.getClass()+" - "+"WS: " +e);
						}
					}
					if (connect.generarCBB) {
						OutputStream out;
						try {
							byte[] b = Base64Decoder.decode(connect.strCbb);
							out = new FileOutputStream(generaConstanciaRetencionBean.getRutaCBB()+generaConstanciaRetencionBean.getAnioProceso()+"/"+Utileria.completaCerosIzquierda(generaConstancia.getSucursal(), 3) +"/"+ Utileria.completaCerosIzquierda(generaConstancia.getClienteID(),10)+"-"+generaConstanciaRetencionBean.getAnioProceso()+".png");
							out.write(b, 0, b.length);
							out.close();
						}catch (Exception e) {
							loggerSAFI.info(this.getClass()+" - "+"WS: " +e);
						}
					}
					if (connect.generarTXT) {
						String txt = new String(Base64Decoder.decode(connect.strTxt));
						try {
							File archivo = new File(pathdir+"TXT/"+generaConstanciaRetencionBean.getAnioProceso()+"/"+Utileria.completaCerosIzquierda(generaConstancia.getSucursal(), 3) +"/"+Utileria.completaCerosIzquierda(generaConstancia.getClienteID(),10)+"-"+generaConstanciaRetencionBean.getAnioProceso()+ ".txt");
							FileWriter escribir = new FileWriter(archivo);
							escribir.write(txt);
							escribir.close();
						}
						catch(Exception e) {
							loggerSAFI.info(this.getClass()+" - "+"WS: " +e.getMessage().toString());
						}
					}
					//Actualiza registro
					String rutaXML = generaConstanciaRetencionBean.getRutaXML()+generaConstanciaRetencionBean.getAnioProceso()+"/"+Utileria.completaCerosIzquierda(generaConstancia.getSucursal(), 3) +"/"+ Utileria.completaCerosIzquierda(generaConstancia.getClienteID(),10)+"-"+generaConstanciaRetencionBean.getAnioProceso()+".xml";
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

						NodeList nodeLst = doc.getElementsByTagName("retenciones:Retenciones");
						Element eleCode = (Element) nodeLst.item(0);
				        fechaCertificacion = eleCode.getAttribute("FechaExp");
				        noCertEmisor = eleCode.getAttribute("NumCert");

				        for (int i = 0; i < nodeLst.getLength(); i++) {
					          Element ele = (Element) nodeLst.item(i);
					          NodeList nlsCode = ele.getElementsByTagName("tfd:TimbreFiscalDigital");
					          Element eleCode2 = (Element) nlsCode.item(0);
					          fechaTimbrado = eleCode2.getAttribute("FechaTimbrado");
						      selloCFD = eleCode2.getAttribute("selloCFD");
						      noCertificadoSAT = eleCode2.getAttribute("noCertificadoSAT");
						      UUID = eleCode2.getAttribute("UUID");
						      version = eleCode2.getAttribute("version");
						      selloSAT = eleCode2.getAttribute("selloSAT");
				        }

				        GeneraConstanciaRetencionBean consRetCFDI = new GeneraConstanciaRetencionBean();
				        consRetCFDI.setClienteID(generaConstancia.getClienteID());
				        consRetCFDI.setSucursalID(generaConstancia.getSucursal());
				        consRetCFDI.setAnioProceso(generaConstancia.getAnioProceso());
				        consRetCFDI.setVersion(version);
				        consRetCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 115));
				        consRetCFDI.setUUID(recorreCadena(UUID, 35));
				        consRetCFDI.setFechaTimbrado(fechaTimbrado);
				        consRetCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 115)));
				        consRetCFDI.setSelloSAT(recorreCadena(selloSAT, 115));
				        consRetCFDI.setFechaCertificacion(fechaCertificacion);
				        consRetCFDI.setNoCertEmisor(noCertEmisor);

				        consRetCFDI.setCadenaOriginal(recorreCadena("||"+version+ "|"+UUID+
								"|"+fechaTimbrado+"|"+selloCFD+"|"+noCertificadoSAT+"||", 115));
						mensaje = actualizaDatosCte(consRetCFDI);
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

	// Se realiza el timbrado de Constancias de Retencion para Relacionados
	public MensajeTransaccionBean realizaTimbradoConstancia(GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
		// Realizar el timbrado para cada cliente
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<GeneraConstanciaRetencionBean> mensajeClientes = null;

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
		FacturacionElectronicaWS connect = new FacturacionElectronicaWS(generaConstanciaRetencionBean.getUrlWSDL(), generaConstanciaRetencionBean.getUsuarioWS(), generaConstanciaRetencionBean.getContraseniaWS(),
				generaConstanciaRetencionBean.getRfcEmisor(), generaPDF, generaTXT, generaCBB);

		GeneraConstanciaRetencionBean generaConstanciaSucursal = new GeneraConstanciaRetencionBean();

		generaConstanciaSucursal = consultaSucursales(generaConstanciaRetencionBean, Enum_Lis_ConsRet.lis_Suc);

		generaConstanciaRetencionBean.setSucursalInicio(generaConstanciaSucursal.getSucursalInicio());
		generaConstanciaRetencionBean.setSucursalFin(generaConstanciaSucursal.getSucursalFin());

		mensajeClientes = consultaDatosClienteRelacionado(generaConstanciaRetencionBean, Enum_Lis_ConsRet.principal);
		GeneraConstanciaRetencionBean generaConstancia = null;
		GeneraConstanciaRetencionBean generaConsIter = null;

		int countExitos = 0;
		int countFallidos = 0;
		String r;
		Iterator<GeneraConstanciaRetencionBean> itera = null;
		itera = mensajeClientes.iterator();

		while(itera.hasNext()){
			generaConstancia = new  GeneraConstanciaRetencionBean();
			generaConsIter = itera.next();
			generaConstancia.setConstanciaRetID(generaConsIter.getConstanciaRetID());
			generaConstancia.setCadenaCFDI(generaConsIter.getCadenaCFDI());
			generaConstancia.setClienteID(generaConsIter.getClienteID());
			generaConstancia.setSucursal(generaConsIter.getSucursalID());
			generaConstancia.setAnioProceso(generaConsIter.getAnioProceso());
			generaConstancia.setTipo(generaConsIter.getTipo());
			generaConstancia.setCteRelacionadoID(generaConsIter.getCteRelacionadoID());
			generaConstancia.setRutaXML(generaConsIter.getRutaXML());
			generaConstancia.setRutaCBB(generaConsIter.getRutaCBB());

			if(generaConstancia.getTipo().equalsIgnoreCase("A") || generaConstancia.getTipo().equalsIgnoreCase("R")){
				generaConstancia.setCliente(generaConstancia.getClienteID());
			}

			if(generaConstancia.getTipo().equalsIgnoreCase("C")){
				generaConstancia.setCliente(generaConstancia.getCteRelacionadoID());
			}

			if (!generaConstancia.getCadenaCFDI().isEmpty() && generaConsIter.getEstatus() != 2){
				r = connect.timbrarFactura(generaConstancia.getCadenaCFDI());
				if (r.equals("error")) {
					countFallidos++;
					generaConstancia.setEstatus(3);
					actualizaDatosCteRelacionadoEstatus(generaConstancia);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Timbrado Fallido. Cliente: "+ generaConstancia.getCliente() +"\nError: " + r , null);
				}else {
					countExitos++;
					String xml = new String(Base64Decoder.decode(connect.strXml));
					generaConstancia.setEstatus(2);
					actualizaDatosCteRelacionadoEstatus(generaConstancia);
					try {
						File archivo = new File(generaConstancia.getRutaXML());
						FileWriter escribir = new FileWriter(archivo);
						escribir.write(xml);
						escribir.close();
					}catch(Exception e) {
						System.out.println(e.getMessage().toString());
					}

					if (connect.generarCBB) {
						OutputStream out;
						try {
							byte[] b = Base64Decoder.decode(connect.strCbb);
							out = new FileOutputStream(generaConstancia.getRutaCBB());
							out.write(b, 0, b.length);
							out.close();
						}catch (Exception e) {
							System.out.println(e);
						}
					}

					// Se obtiene la ruta del XML para su lectura
					String rutaXML = generaConstancia.getRutaXML();

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

							NodeList nodeLst = doc.getElementsByTagName("retenciones:Retenciones");
							Element eleCode = (Element) nodeLst.item(0);
					        fechaCertificacion = eleCode.getAttribute("FechaExp");
					        noCertEmisor = eleCode.getAttribute("NumCert");

					        for (int i = 0; i < nodeLst.getLength(); i++) {
						          Element ele = (Element) nodeLst.item(i);
						          NodeList nlsCode = ele.getElementsByTagName("tfd:TimbreFiscalDigital");
						          Element eleCode2 = (Element) nlsCode.item(0);
						          fechaTimbrado = eleCode2.getAttribute("FechaTimbrado");
							      selloCFD = eleCode2.getAttribute("selloCFD");
							      noCertificadoSAT = eleCode2.getAttribute("noCertificadoSAT");
							      UUID = eleCode2.getAttribute("UUID");
							      version = eleCode2.getAttribute("version");
							      selloSAT = eleCode2.getAttribute("selloSAT");
					        }

					        GeneraConstanciaRetencionBean consRetCFDI = new GeneraConstanciaRetencionBean();
					        consRetCFDI.setConstanciaRetID(generaConstancia.getConstanciaRetID());
					        consRetCFDI.setClienteID(generaConstancia.getClienteID());
					        consRetCFDI.setSucursalID(generaConstancia.getSucursal());
					        consRetCFDI.setAnioProceso(generaConstancia.getAnioProceso());

					        consRetCFDI.setVersion(version);
					        consRetCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 115));
					        consRetCFDI.setUUID(recorreCadena(UUID, 35));
					        consRetCFDI.setFechaTimbrado(fechaTimbrado);
					        consRetCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 115)));
					        consRetCFDI.setSelloSAT(recorreCadena(selloSAT, 115));
					        consRetCFDI.setFechaCertificacion(fechaCertificacion);
					        consRetCFDI.setNoCertEmisor(noCertEmisor);

					        consRetCFDI.setCadenaOriginal(recorreCadena("||"+version+ "|"+UUID+
									"|"+fechaTimbrado+"|"+selloCFD+"|"+noCertificadoSAT+"||", 115));
							mensaje = actualizaDatosCteRelacionado(consRetCFDI);
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

	// Funcion para leer XML
	public MensajeTransaccionBean leerXML(GeneraConstanciaRetencionBean generaConstanciaRetencionBean) {
		/*Actualizacion para obtener datos del CFDI */
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<GeneraConstanciaRetencionBean> mensajeClientes = null;
		GeneraConstanciaRetencionBean generaConstancia = null;
		GeneraConstanciaRetencionBean generaConsIter = null;

		String listaErrores = "Clientes a los cuales no se generaron las Cosntancias de Retención: ";
		String listaCorrectos = "";
		try {
			//Obtener clientes que se le hayan generado su Timbrado
			mensajeClientes = consultaForanea(generaConstanciaRetencionBean, Enum_Lis_ConsRet.foranea);
			//Leer sus xml por cada cliente
			//Actualizar los campos donde se va guardar los campos del CFDI
			String r;
			Iterator<GeneraConstanciaRetencionBean> itera = null;
			itera = mensajeClientes.iterator();
			while(itera.hasNext()){
				generaConstancia = new  GeneraConstanciaRetencionBean();
				generaConsIter = itera.next();
				generaConstancia.setClienteID(generaConsIter.getClienteID());
				generaConstancia.setRutaCBB(generaConsIter.getRutaCBB());
				generaConstancia.setRutaXML(generaConsIter.getRutaXML());
				generaConstancia.setSucursalID(generaConsIter.getSucursalID());
				generaConstancia.setAnioProceso(generaConstanciaRetencionBean.getAnioProceso());

				boolean exists = (new File(generaConstancia.getRutaXML())).exists();
	    		if (exists) {
	    			File fXmlFile = new File(generaConstancia.getRutaXML());
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

					NodeList nodeLst = doc.getElementsByTagName("retenciones:Retenciones");
					Element eleCode = (Element) nodeLst.item(0);
			        fechaCertificacion = eleCode.getAttribute("FechaExp");
			        noCertEmisor = eleCode.getAttribute("NumCert");

			        for (int i = 0; i < nodeLst.getLength(); i++) {
				          Element ele = (Element) nodeLst.item(i);
				          NodeList nlsCode = ele.getElementsByTagName("tfd:TimbreFiscalDigital");
				          Element eleCode2 = (Element) nlsCode.item(0);
				          fechaTimbrado = eleCode2.getAttribute("FechaTimbrado");
					      selloCFD = eleCode2.getAttribute("selloCFD");
					      noCertificadoSAT = eleCode2.getAttribute("noCertificadoSAT");
					      UUID = eleCode2.getAttribute("UUID");
					      version = eleCode2.getAttribute("version");
					      selloSAT = eleCode2.getAttribute("selloSAT");
			        }

			        GeneraConstanciaRetencionBean consRetCFDI = new GeneraConstanciaRetencionBean();
			        consRetCFDI.setClienteID(generaConstancia.getClienteID());
			        consRetCFDI.setSucursalID(generaConstancia.getSucursalID());
			        consRetCFDI.setAnioProceso(generaConstancia.getAnioProceso());
			        consRetCFDI.setVersion(version);
			        consRetCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 115));
			        consRetCFDI.setUUID(recorreCadena(UUID, 35));
			        consRetCFDI.setFechaTimbrado(fechaTimbrado);
			        consRetCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 115)));
			        consRetCFDI.setClienteID(generaConstancia.getClienteID());

			        consRetCFDI.setVersion(version);
			        consRetCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 115));
			        consRetCFDI.setUUID(recorreCadena(UUID, 35));
			        consRetCFDI.setFechaTimbrado(fechaTimbrado);
			        consRetCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 115)));
			        consRetCFDI.setSelloSAT(recorreCadena(selloSAT, 115));
			        consRetCFDI.setFechaCertificacion(fechaCertificacion);
			        consRetCFDI.setNoCertEmisor(noCertEmisor);

			        consRetCFDI.setCadenaOriginal(recorreCadena("||"+version+ "|"+UUID+
							"|"+fechaTimbrado+"|"+selloCFD+"|"+noCertificadoSAT+"||", 115));
					mensaje = actualizaDatosCte(consRetCFDI);
					if(mensaje.getNumero() != 0){
						throw new Exception(mensaje.getDescripcion());
					}
	    		}
			}
			mensaje.setNumero(Integer.valueOf(Constantes.ENTERO_CERO));
			mensaje.setDescripcion("Lectura XML Finalizado");
			mensaje.setNombreControl(Constantes.STRING_VACIO);
		 }catch(FileNotFoundException e){
			 listaErrores = listaErrores + ""+ generaConstancia.getClienteID();
		 }catch (Exception e) {
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error Lectura XML" + e);
			e.printStackTrace();
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
	    }
		return mensaje;
	}

	// Funcion para leer XML Constancias Relacionados
	public MensajeTransaccionBean leerXMLConstancia(GeneraConstanciaRetencionBean generaConstanciaRetencionBean) {
		/*Actualizacion para obtener datos del CFDI */
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<GeneraConstanciaRetencionBean> mensajeClientes = null;
		GeneraConstanciaRetencionBean generaConstancia = null;
		GeneraConstanciaRetencionBean generaConsIter = null;

		String listaErrores = "Clientes a los cuales no se generaron las Constancias de Retención: ";

		try {
			//Obtener clientes relacionados que se le hayan generado su Timbrado
			mensajeClientes = consultaForaneaConstancia(generaConstanciaRetencionBean, Enum_Lis_ConsRet.foranea);
			//Leer sus xml por cada cliente
			//Actualizar los campos donde se va guardar los campos del CFDI
			Iterator<GeneraConstanciaRetencionBean> itera = null;
			itera = mensajeClientes.iterator();

			while(itera.hasNext()){
				generaConstancia = new  GeneraConstanciaRetencionBean();
				generaConsIter = itera.next();
				generaConstancia.setConstanciaRetID(generaConsIter.getConstanciaRetID());
				generaConstancia.setClienteID(generaConsIter.getClienteID());
				generaConstancia.setSucursalID(generaConsIter.getSucursalID());
				generaConstancia.setRutaXML(generaConsIter.getRutaXML());
				generaConstancia.setAnioProceso(generaConstanciaRetencionBean.getAnioProceso());

				// Se obtiene la ruta del XML para su lectura
				String rutaXML = generaConstancia.getRutaXML();

				boolean exists = (new File(rutaXML)).exists();
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

					NodeList nodeLst = doc.getElementsByTagName("retenciones:Retenciones");
					Element eleCode = (Element) nodeLst.item(0);
			        fechaCertificacion = eleCode.getAttribute("FechaExp");
			        noCertEmisor = eleCode.getAttribute("NumCert");

			        for (int i = 0; i < nodeLst.getLength(); i++) {
				          Element ele = (Element) nodeLst.item(i);
				          NodeList nlsCode = ele.getElementsByTagName("tfd:TimbreFiscalDigital");
				          Element eleCode2 = (Element) nlsCode.item(0);
				          fechaTimbrado = eleCode2.getAttribute("FechaTimbrado");
					      selloCFD = eleCode2.getAttribute("selloCFD");
					      noCertificadoSAT = eleCode2.getAttribute("noCertificadoSAT");
					      UUID = eleCode2.getAttribute("UUID");
					      version = eleCode2.getAttribute("version");
					      selloSAT = eleCode2.getAttribute("selloSAT");
			        }

			        GeneraConstanciaRetencionBean consRetCFDI = new GeneraConstanciaRetencionBean();
			        consRetCFDI.setConstanciaRetID(generaConstancia.getConstanciaRetID());
			        consRetCFDI.setClienteID(generaConstancia.getClienteID());
			        consRetCFDI.setSucursalID(generaConstancia.getSucursalID());
			        consRetCFDI.setAnioProceso(generaConstancia.getAnioProceso());

			        consRetCFDI.setVersion(version);
			        consRetCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 115));
			        consRetCFDI.setUUID(recorreCadena(UUID, 35));
			        consRetCFDI.setFechaTimbrado(fechaTimbrado);
			        consRetCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 115)));

			        consRetCFDI.setVersion(version);
			        consRetCFDI.setNoCertificadoSAT(recorreCadena(noCertificadoSAT, 115));
			        consRetCFDI.setUUID(recorreCadena(UUID, 35));
			        consRetCFDI.setFechaTimbrado(fechaTimbrado);
			        consRetCFDI.setSelloCFD(String.valueOf(recorreCadena(selloCFD, 115)));
			        consRetCFDI.setSelloSAT(recorreCadena(selloSAT, 115));
			        consRetCFDI.setFechaCertificacion(fechaCertificacion);
			        consRetCFDI.setNoCertEmisor(noCertEmisor);

			        consRetCFDI.setCadenaOriginal(recorreCadena("||"+version+ "|"+UUID+
							"|"+fechaTimbrado+"|"+selloCFD+"|"+noCertificadoSAT+"||", 115));
					mensaje = actualizaDatosCteRelacionado(consRetCFDI);
					if(mensaje.getNumero() != 0){
						throw new Exception(mensaje.getDescripcion());
					}
	    		}
			}
			mensaje.setNumero(Integer.valueOf(Constantes.ENTERO_CERO));
			mensaje.setDescripcion("Lectura XML Finalizado");
			mensaje.setNombreControl(Constantes.STRING_VACIO);
		 }catch(FileNotFoundException e){
			 listaErrores = listaErrores + ""+ generaConstancia.getClienteID();
		 }catch (Exception e) {
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error Lectura XML" + e);
			e.printStackTrace();
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
	    }
		return mensaje;
	}

	// Se genera la Constancia de Retención del Cliente
	public MensajeTransaccionBean generaConstanciaRetencionUnico(GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//Ejecucion de Constancias de Retencion
		try{
			String[] command = {"/bin/bash", "ejec_consretxsucurs.sh",
					generaConstanciaRetencionBean.getAnioProceso(),
					generaConstanciaRetencionBean.getSucursalInicio(),
					 generaConstanciaRetencionBean.getSucursalFin(),
					 generaConstanciaRetencionBean.getClienteInicio(),
					 generaConstanciaRetencionBean.getClienteFin(),
					 generaConstanciaRetencionBean.getOrigenDatos()};
			ProcessBuilder pb2 = new ProcessBuilder(command);
			pb2.directory(new File("/opt/SAFI/ConstanciaRetencion/JOBS/"));
			Process p2 = pb2.start();
			//p2.waitFor();
			InputStream is2 = p2.getInputStream();
			InputStreamReader isr2 = new InputStreamReader(is2);
			BufferedReader br2 = new BufferedReader(isr2);
			String line2;
			while ((line2 = br2.readLine()) != null) {
				loggerSAFI.info(this.getClass()+" - "+"sh : " +line2);
			}
			//p2.destroy();
		}catch(Exception e){
			e.printStackTrace();
		}
		mensaje.setNumero(0);
		mensaje.setDescripcion("Generación de Constancia de Retención ha Finalizado Correctamente.");
		return mensaje;
	}

	// Recorre cadena XML
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

	// Actualiza Datos CFDI del Cliente
	public MensajeTransaccionBean actualizaDatosCte(final GeneraConstanciaRetencionBean datosCFDIBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure


			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CONSTANCIARETCTEACT(" +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?);";


								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_AnioProceso",datosCFDIBean.getAnioProceso());
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(datosCFDIBean.getClienteID()));
								sentenciaStore.setString("Par_Version",datosCFDIBean.getVersion());
								sentenciaStore.setString("Par_NoCertifSAT",datosCFDIBean.getNoCertificadoSAT());
								sentenciaStore.setString("Par_UUID",datosCFDIBean.getUUID());

								sentenciaStore.setString("Par_FechaTimbrado",datosCFDIBean.getFechaTimbrado());
								sentenciaStore.setString("Par_SelloCFD",datosCFDIBean.getSelloCFD());
								sentenciaStore.setString("Par_SelloSAT",datosCFDIBean.getSelloSAT());
								sentenciaStore.setString("Par_CadenaOriginal",datosCFDIBean.getCadenaOriginal());
								sentenciaStore.setString("Par_FechaCertifica",datosCFDIBean.getFechaCertificacion());

								sentenciaStore.setString("Par_NoCertEmisor",datosCFDIBean.getNoCertEmisor());
								sentenciaStore.setInt("Par_SucursalCte",Utileria.convierteEntero(datosCFDIBean.getClienteID()));
								sentenciaStore.setInt("Par_NumAct",datosCFDIBean.ActualizaCFDI);
								sentenciaStore.setInt("Par_Estatus",Constantes.ENTERO_CERO);

								//Parametros de Salida
   								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
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

	// Actualiza Datos CFDI del Cliente Relacionado
	public MensajeTransaccionBean actualizaDatosCteRelacionado(final GeneraConstanciaRetencionBean datosCFDIBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure


					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CONSTANCIARETCTERELACT(" +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_ConstanciaRetID",datosCFDIBean.getConstanciaRetID());
								sentenciaStore.setString("Par_AnioProceso",datosCFDIBean.getAnioProceso());
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(datosCFDIBean.getClienteID()));
								sentenciaStore.setString("Par_Version",datosCFDIBean.getVersion());
								sentenciaStore.setString("Par_NoCertifSAT",datosCFDIBean.getNoCertificadoSAT());

								sentenciaStore.setString("Par_UUID",datosCFDIBean.getUUID());
								sentenciaStore.setString("Par_FechaTimbrado",datosCFDIBean.getFechaTimbrado());
								sentenciaStore.setString("Par_SelloCFD",datosCFDIBean.getSelloCFD());
								sentenciaStore.setString("Par_SelloSAT",datosCFDIBean.getSelloSAT());
								sentenciaStore.setString("Par_CadenaOriginal",datosCFDIBean.getCadenaOriginal());

								sentenciaStore.setString("Par_FechaCertifica",datosCFDIBean.getFechaCertificacion());
								sentenciaStore.setString("Par_NoCertEmisor",datosCFDIBean.getNoCertEmisor());
								sentenciaStore.setInt("Par_SucursalCte",Utileria.convierteEntero(datosCFDIBean.getSucursalID()));
								sentenciaStore.setInt("Par_NumAct",datosCFDIBean.ActualizaCFDI);
								sentenciaStore.setInt("Par_Estatus",Constantes.ENTERO_CERO);

								//Parametros de Salida
   								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
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

	// Actualiza Estatus del Cliente
	public MensajeTransaccionBean actualizaDatosCteEstatus(final GeneraConstanciaRetencionBean datosCFDIBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure


			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CONSTANCIARETCTEACT(" +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?);";


								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_AnioProceso",datosCFDIBean.getAnioProceso());
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(datosCFDIBean.getClienteID()));
								sentenciaStore.setString("Par_Version",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_NoCertifSAT",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_UUID",Constantes.STRING_VACIO);

								sentenciaStore.setString("Par_FechaTimbrado",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_SelloCFD",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_SelloSAT",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_CadenaOriginal",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechaCertifica",Constantes.STRING_VACIO);

								sentenciaStore.setString("Par_NoCertEmisor",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_SucursalCte",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_NumAct",datosCFDIBean.ActualizaEstatus);
								sentenciaStore.setInt("Par_Estatus",datosCFDIBean.getEstatus());

								//Parametros de Salida
   								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
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

	// Actualiza Estatus del Cliente Relacionado
	public MensajeTransaccionBean actualizaDatosCteRelacionadoEstatus(final GeneraConstanciaRetencionBean datosCFDIBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure


					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CONSTANCIARETCTERELACT(" +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_ConstanciaRetID",datosCFDIBean.getConstanciaRetID());
								sentenciaStore.setString("Par_AnioProceso",datosCFDIBean.getAnioProceso());
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(datosCFDIBean.getClienteID()));
								sentenciaStore.setString("Par_Version",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_NoCertifSAT",Constantes.STRING_VACIO);

								sentenciaStore.setString("Par_UUID",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechaTimbrado",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_SelloCFD",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_SelloSAT",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_CadenaOriginal",Constantes.STRING_VACIO);

								sentenciaStore.setString("Par_FechaCertifica",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_NoCertEmisor",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_SucursalCte",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_NumAct",datosCFDIBean.ActualizaEstatus);
								sentenciaStore.setInt("Par_Estatus",datosCFDIBean.getEstatus());

								//Parametros de Salida
   								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Actualizar Estatus Timbrado Constancia de Retención" + e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Genera informacion de Clientes para las Constancias de Retención
	public MensajeTransaccionBean consultaInfoCliente(final GeneraConstanciaRetencionBean generaConstanciaRetencionBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call CONSTANCIARETIMBRADOPRO(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_AnioProceso",generaConstanciaRetencionBean.getAnioProceso());
								sentenciaStore.setString("Par_SucursalInicio",generaConstanciaRetencionBean.getSucursalInicio());
								sentenciaStore.setString("Par_SucursalFin",generaConstanciaRetencionBean.getSucursalFin());
								sentenciaStore.setInt("Par_ClienteID",Constantes.ENTERO_CERO);

								//Parametros de Salida
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error Proceso Timbrado Constancias de Retención", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Consulta si existen registros de INPC del Anio seleccionado
	public GeneraConstanciaRetencionBean consultaDatosINPC(GeneraConstanciaRetencionBean generaConstancia, int tipoConsulta) {
		GeneraConstanciaRetencionBean generaConstanciaRetencionBean= new GeneraConstanciaRetencionBean();
		try{
			//Query con el Store Procedure
			String query = "call INDICENAPRECONSCON(?,?,?," +
													"?,?,?,?,?,?,?);"; //Parametros de auditoria

			Object[] parametros = {
				Utileria.convierteEntero(generaConstancia.getAnioProceso()),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"GeneraConstanciaRetencionDAO.consultaINPC",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INDICENAPRECONSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
					generaConstancia.setNumRegistrosINPC(resultSet.getString("NumRegistrosINPC"));
					return generaConstancia;
				}// trows ecexeption
			});//lista

			generaConstanciaRetencionBean= matches.size() > 0 ? (GeneraConstanciaRetencionBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de INPC. ", e);
		}
		return generaConstanciaRetencionBean;
	}

	// Consulta de Parámetros de Constancia de Retención
	public GeneraConstanciaRetencionBean consultaParamConstancia(GeneraConstanciaRetencionBean generaConstancia, int tipoConsulta) {
		GeneraConstanciaRetencionBean generaConsRet= new GeneraConstanciaRetencionBean();
		try{
			//Query con el Store Procedure
			String query = "call CONSTANCIARETPARAMSCON(?,?,?,?,?,	?,?,?);";

			Object[] parametros = {
									tipoConsulta,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraConstanciaRetencionDAO.consultaForanea",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETPARAMSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();

					generaConstancia.setRutaConstanciaPDF(resultSet.getString("RutaExpPDF"));
					generaConstancia.setRutaCBB(resultSet.getString("RutaCBB"));
					generaConstancia.setRutaXML(resultSet.getString("RutaCFDI"));
					generaConstancia.setRfcEmisor(resultSet.getString("RFC"));
					generaConstancia.setRutaReporte(resultSet.getString("RutaReporte"));

					generaConstancia.setRutaLogo(resultSet.getString("RutaLogo"));
					generaConstancia.setRutaCedula(resultSet.getString("RutaCedula"));
					generaConstancia.setRutaETL(resultSet.getString("RutaETL"));
					generaConstancia.setCalcCierreIntReal(resultSet.getString("CalcCierreIntReal"));
					generaConstancia.setGeneraConsRetPDF(resultSet.getString("GeneraConsRetPDF"));

					generaConstancia.setTipoProveedorWS(resultSet.getString("TipoProveedorWS"));
					generaConstancia.setUsuarioWS(resultSet.getString("UsuarioWS"));
					generaConstancia.setContraseniaWS(resultSet.getString("ContraseniaWS"));
					generaConstancia.setUrlWSDL(resultSet.getString("UrlWSDL"));
					generaConstancia.setTokenAcceso(resultSet.getString("TokenAcceso"));

					generaConstancia.setTimbraConsRet(resultSet.getString("TimbraConsRet"));
					generaConstancia.setRutaArchivosCertificado(resultSet.getString("RutaArchivosCertificado"));
					generaConstancia.setNombreCertificado(resultSet.getString("NombreCertificado"));
					generaConstancia.setNombreLlavePriv(resultSet.getString("NombreLlavePriv"));
					generaConstancia.setRutaArchivosXSLT(resultSet.getString("RutaArchivosXSLT"));
					generaConstancia.setPassCertificado(resultSet.getString("PassCertificado"));

					return generaConstancia;
				}// trows ecexeption
			});//lista

			generaConsRet= matches.size() > 0 ? (GeneraConstanciaRetencionBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta Parámetros Constancia Retención ", e);
		}
		return generaConsRet;
	}

	// Consulta si Existe Información de Clientes en la Sucursal del Anio seleccionado
	public GeneraConstanciaRetencionBean consultaClientes(GeneraConstanciaRetencionBean generaConstancia, int tipoConsulta) {
		GeneraConstanciaRetencionBean generaConstanciaRetencionBean= new GeneraConstanciaRetencionBean();
		try{
			//Query con el Store Procedure
			String query = "call CONSTANCIARETCTECON(?,?,?,?,?,  ?,?,?,?,?,	 ?,?);";

			Object[] parametros = {
									generaConstancia.getAnioProceso(),
									generaConstancia.getSucursalInicio(),
									generaConstancia.getSucursalFin(),
									Constantes.ENTERO_CERO,
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraConstanciaRetencionDAO.consultaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETCTECON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
					generaConstancia.setNumRegistros(resultSet.getString("NumRegistros"));
					return generaConstancia;
				}// trows ecexeption
			});//lista

			generaConstanciaRetencionBean= matches.size() > 0 ? (GeneraConstanciaRetencionBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta ", e);
		}
		return generaConstanciaRetencionBean;
	}

	// Consulta si existen registros del Anio seleccionado
	public GeneraConstanciaRetencionBean consultaDatosAnio(GeneraConstanciaRetencionBean generaConstancia, int tipoConsulta) {
		GeneraConstanciaRetencionBean generaConstanciaRetencionBean= new GeneraConstanciaRetencionBean();
		try{
			//Query con el Store Procedure
			String query = "call CONSTANCIARETCTECON(?,?,?,?,?,  ?,?,?,?,?,	 ?,?);";

			Object[] parametros = {
									generaConstancia.getAnioProceso(),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraConstanciaRetencionDAO.consultaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETCTECON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
					generaConstancia.setNumRegistrosAnio(resultSet.getString("NumRegistrosAnio"));
					return generaConstancia;
				}// trows ecexeption
			});//lista

			generaConstanciaRetencionBean= matches.size() > 0 ? (GeneraConstanciaRetencionBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta ", e);
		}
		return generaConstanciaRetencionBean;
	}


	// Se consultan los datos del cliente a realizar el timbrado
	public List<GeneraConstanciaRetencionBean> consultaDatosCliente(GeneraConstanciaRetencionBean generaConstanciaRetencionBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONSTANCIARETCTELIS(?,?,?,?,?,		?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
								generaConstanciaRetencionBean.getAnioProceso(),
								generaConstanciaRetencionBean.getSucursalInicio(),
								generaConstanciaRetencionBean.getSucursalFin(),
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraConstanciaRetencionDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETCTELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
				generaConstancia.setAnioProceso(resultSet.getString("Anio"));
				generaConstancia.setSucursalID(resultSet.getString("SucursalID"));
				generaConstancia.setClienteID(resultSet.getString("ClienteID"));
				generaConstancia.setCadenaCFDI(resultSet.getString("CadenaCFDI"));
				generaConstancia.setEstatus(resultSet.getInt("Estatus"));
				generaConstancia.setRfcReceptor(resultSet.getString("RFC"));
				return generaConstancia;
			}
		});
		return matches;
	}

	// Consulta de Sucursales del Aportante
	public GeneraConstanciaRetencionBean consultaSucursales(GeneraConstanciaRetencionBean generaConstancia, int tipoLista) {
		GeneraConstanciaRetencionBean generaConstanciaRetencionBean= new GeneraConstanciaRetencionBean();
		try{
			//Query con el Store Procedure
			String query = "call CONSTANCIARETCTERELLIS(?,?,?,?,?,		?,?,?,?,?,	?,?,?);";

			Object[] parametros = {
									generaConstancia.getAnioProceso(),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									generaConstancia.getClienteID(),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraConstanciaRetencionDAO.listaSucursales",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETCTERELLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
					generaConstancia.setSucursalInicio(resultSet.getString("Minimo"));
					generaConstancia.setSucursalFin(resultSet.getString("Maximo"));

					return generaConstancia;
				}// trows ecexeption
			});//lista

			generaConstanciaRetencionBean= matches.size() > 0 ? (GeneraConstanciaRetencionBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de sucursales", e);
		}
		return generaConstanciaRetencionBean;
	}

	// Se consultan los datos del cliente relacionado fiscal a realizar el timbrado
	public List<GeneraConstanciaRetencionBean> consultaDatosClienteRelacionado(GeneraConstanciaRetencionBean generaConstanciaRetencionBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONSTANCIARETCTERELLIS(?,?,?,?,?,		?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
								generaConstanciaRetencionBean.getAnioProceso(),
								generaConstanciaRetencionBean.getSucursalInicio(),
								generaConstanciaRetencionBean.getSucursalFin(),
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraConstanciaRetencionDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETCTERELLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
				generaConstancia.setConstanciaRetID(resultSet.getString("ConstanciaRetID"));
				generaConstancia.setAnioProceso(resultSet.getString("Anio"));
				generaConstancia.setSucursalID(resultSet.getString("SucursalID"));
				generaConstancia.setClienteID(resultSet.getString("ClienteID"));
				generaConstancia.setCadenaCFDI(resultSet.getString("CadenaCFDI"));
				generaConstancia.setEstatus(resultSet.getInt("Estatus"));
				generaConstancia.setTipo(resultSet.getString("Tipo"));
				generaConstancia.setCteRelacionadoID(resultSet.getString("CteRelacionadoID"));
				generaConstancia.setRutaXML(resultSet.getString("RutaXML"));
				generaConstancia.setRutaCBB(resultSet.getString("RutaCBB"));
				return generaConstancia;
			}
		});
		return matches;
	}

	// Consulta Foranea
	public List<GeneraConstanciaRetencionBean> consultaForanea(GeneraConstanciaRetencionBean generaConstanciaRetencionBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONSTANCIARETCTELIS(?,?,?,?,?,		?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
								generaConstanciaRetencionBean.getAnioProceso(),
								generaConstanciaRetencionBean.getSucursalInicio(),
								generaConstanciaRetencionBean.getSucursalFin(),
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraConstanciaRetencionDAO.listaForanea",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETCTELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
				generaConstancia.setClienteID(resultSet.getString("ClienteID"));
				generaConstancia.setSucursalID(resultSet.getString("SucursalID"));
				generaConstancia.setRutaCBB(resultSet.getString("RutaCBB"));
				generaConstancia.setRutaXML(resultSet.getString("RutaXML"));
				return generaConstancia;
			}
		});
		return matches;
	}

	// Consulta Foranea Relacionados
	public List<GeneraConstanciaRetencionBean> consultaForaneaConstancia(GeneraConstanciaRetencionBean generaConstanciaRetencionBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONSTANCIARETCTERELLIS(?,?,?,?,?,		?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
								generaConstanciaRetencionBean.getAnioProceso(),
								generaConstanciaRetencionBean.getSucursalInicio(),
								generaConstanciaRetencionBean.getSucursalFin(),
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraConstanciaRetencionDAO.listaForanea",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETCTERELLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
				generaConstancia.setConstanciaRetID(resultSet.getString("ConstanciaRetID"));
				generaConstancia.setClienteID(resultSet.getString("ClienteID"));
				generaConstancia.setSucursalID(resultSet.getString("SucursalID"));
				generaConstancia.setRutaXML(resultSet.getString("RutaXML"));
				return generaConstancia;
			}
		});
		return matches;
	}

	// Consulta de Rangos de Clientes y consulta rango de bloques de clientes para geenerar la constancia
	public GeneraConstanciaRetencionBean consultaRangoClientes(GeneraConstanciaRetencionBean generaConstancia, int tipoLista) {
		GeneraConstanciaRetencionBean generaConstanciaRetencionBean= new GeneraConstanciaRetencionBean();
		try{
			//Query con el Store Procedure
			String query = "call CONSTANCIARETCTELIS(?,?,?,?,?,		?,?,?,?,?,	?,?,?);";

			Object[] parametros = {
									generaConstancia.getAnioProceso(),
									generaConstancia.getSucursalInicio(),
									generaConstancia.getSucursalFin(),
									Constantes.STRING_VACIO,
									generaConstancia.getClienteID(),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraConstanciaRetencionDAO.listaRangos",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETCTELIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
					generaConstancia.setClienteInicio(resultSet.getString("Minimo"));
					generaConstancia.setClienteFin(resultSet.getString("Maximo"));
					generaConstancia.setNumRegistros(resultSet.getString("NumRegistros"));
					return generaConstancia;
				}// trows ecexeption
			});//lista

			generaConstanciaRetencionBean= matches.size() > 0 ? (GeneraConstanciaRetencionBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta ", e);
		}
		return generaConstanciaRetencionBean;
	}

	// Consulta de Rangos de Clientes Relacionados
	public GeneraConstanciaRetencionBean consultaRangoClientesRelacionados(GeneraConstanciaRetencionBean generaConstancia, int tipoLista) {
		GeneraConstanciaRetencionBean generaConstanciaRetencionBean= new GeneraConstanciaRetencionBean();
		try{
			//Query con el Store Procedure
			String query = "call CONSTANCIARETCTERELLIS(?,?,?,?,?,		?,?,?,?,?,	?,?,?);";

			Object[] parametros = {
									generaConstancia.getAnioProceso(),
									generaConstancia.getSucursalInicio(),
									generaConstancia.getSucursalFin(),
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraConstanciaRetencionDAO.listaRangos",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETCTERELLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraConstanciaRetencionBean generaConstancia = new GeneraConstanciaRetencionBean();
					generaConstancia.setClienteInicio(resultSet.getString("Minimo"));
					generaConstancia.setClienteFin(resultSet.getString("Maximo"));
					generaConstancia.setNumRegistros(resultSet.getString("NumRegistros"));
					return generaConstancia;
				}// trows ecexeption
			});//lista

			generaConstanciaRetencionBean= matches.size() > 0 ? (GeneraConstanciaRetencionBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta ", e);
		}
		return generaConstanciaRetencionBean;
	}


	// METODO PARA EJECUTAR UN ARCHIVO SHELL (SH)
	// rutaSH: Ruta donde se encuentra el archivo sh: /opt/SAFI/
	// nombreSH: Nombre del archivo sh con su extencion: nombreSH.sh
	// parametros: lista de los parametros que se mandan al sh
	public MensajeTransaccionBean procesarArchivoSH(String rutaSH, String nombreSH, String[] parametros){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		try{
	        ArrayList<String> command = new ArrayList<String>();

	        command.add("/bin/bash");
	        command.add(nombreSH);

			for(String param : parametros){
		        command.add(param);
			}

			loggerSAFI.info(this.getClass()+" - "+"Inicio Ejecucion SH"+" - "+"Ruta: "+rutaSH+" - "+"Nombre sh: "+nombreSH);

			// Valida si existe el archivo
			File directorio = new File(rutaSH+nombreSH);
			if (!directorio.exists()) {
				throw new Exception("No se existe el archivo sh en la ruta especificada.");
			}

			ProcessBuilder pb = new ProcessBuilder(command);
			pb.directory(new File(rutaSH));

			Process p = pb.start();
			//p.waitFor();
			// LEEMOS SALIDA DEL PROGRAMA
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);

			String line;
			String respuesta = null;
			while ((line = br.readLine()) != null) {
				loggerSAFI.info(line);
				respuesta = line;
			}

			String[] partes = respuesta.split("-");
			int codigoRespuesta = Integer.parseInt(partes[0]);
			String mensajeRespuesta = partes[1];
			loggerSAFI.info(this.getClass()+" - "+"Respuesta recibida del SH: " +respuesta);
			loggerSAFI.info(this.getClass()+" - "+"Fin Ejecucion SH"+" - "+"Nombre sh: "+nombreSH);

			mensaje.setNumero(codigoRespuesta);
			mensaje.setDescripcion(mensajeRespuesta);

		}catch(Exception e){
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error al procesar el archivo SH: " + e);
			e.printStackTrace();
			if (mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR) {
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}

		return mensaje;
	}

	/* ============ SETTER's Y GETTER's =============== */

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public ConstanciaRecursoDAO getConstanciaRecursoDAO() {
		return constanciaRecursoDAO;
	}

	public void setConstanciaRecursoDAO(ConstanciaRecursoDAO constanciaRecursoDAO) {
		this.constanciaRecursoDAO = constanciaRecursoDAO;
	}

	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}

	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}

	public GeneraConsRetencionCteDAO getGeneraConsRetencionCteDAO() {
		return generaConsRetencionCteDAO;
	}

	public void setGeneraConsRetencionCteDAO(
			GeneraConsRetencionCteDAO generaConsRetencionCteDAO) {
		this.generaConsRetencionCteDAO = generaConsRetencionCteDAO;
	}
}