package pld.servicio;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import org.pentaho.di.core.KettleEnvironment;
import org.pentaho.di.core.exception.KettleException;
import org.pentaho.di.job.Job;
import org.pentaho.di.job.JobMeta;

import pld.bean.CargaListasPLDBean;
import pld.dao.CargaListasPLDDAO;
import seguridad.bean.ConexionOrigenDatosBean;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;

public class CargaListasPLDServicio extends BaseServicio{

	String rutaCompletaArchivo = "";
	ParamGeneralesServicio paramGeneralesServicio = null;
	CargaListasPLDDAO cargaListasPLDDAO = null;

	public static interface Enum_Tra_CargaListas {
		int guardarArchivo = 1;
		int ejecutaKTR = 2;
	}

	public static interface Enum_Con_CargaListas {
		int listasNegras = 1;
		int listasPersBloq = 2;
	}

	public static interface Enum_Act_CargaListas {
		int exito = 1;
		int fallo = 2;
		int invalidaRecientes = 3;
	}

	public static interface Enum_Tipo_ListasPLD {
		String listasNegras = "LN";
		String listasPersBloq = "LPB";
		String listasNegMasiva = "N";
		String listasPBloqMasiva = "B";
	}

	public static interface Enum_Con_ParamGenerales {
		int KTRCargaListas = 6;
		int ScriptSHCargaListas = 28;
		int EncodeCargaListas = 29;
		int KTRArchivosPerd = 15;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CargaListasPLDBean cargaListasBean){
		MensajeTransaccionBean mensaje = null;

		switch (tipoTransaccion) {
		case Enum_Tra_CargaListas.ejecutaKTR:
			mensaje = ejecutaKTR(cargaListasBean);
			break;
		}

		return mensaje;
	}

	public CargaListasPLDBean consulta(CargaListasPLDBean cargaBean, int tipoConsulta){
		CargaListasPLDBean cargaListasBean = null;
		switch (tipoConsulta) {
			case Enum_Con_CargaListas.listasNegras:		
				cargaListasBean = cargaListasPLDDAO.consulta(cargaBean, tipoConsulta);				
				break;	
			case Enum_Con_CargaListas.listasPersBloq:
				cargaListasBean = cargaListasPLDDAO.consulta(cargaBean, tipoConsulta);				
				break;
		}
		
		return cargaListasBean;
	}

	public MensajeTransaccionBean actualiza(CargaListasPLDBean cargaBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		ParametrosAuditoriaBean parametrosAuditoriaBean = new ParametrosAuditoriaBean();
		parametrosAuditoriaBean = cargaListasPLDDAO.getParametrosAuditoriaBean();
		ConexionOrigenDatosBean conexionOrigenDatosBean = new ConexionOrigenDatosBean();
		conexionOrigenDatosBean = cargaListasPLDDAO.getConexionOrigenDatosBean();
		
		switch (tipoActualizacion) {
			case Enum_Act_CargaListas.exito:		
				mensaje = cargaListasPLDDAO.actualiza(cargaBean, parametrosAuditoriaBean,conexionOrigenDatosBean,tipoActualizacion);				
				break;	
			case Enum_Act_CargaListas.fallo:
				mensaje = cargaListasPLDDAO.actualiza(cargaBean,parametrosAuditoriaBean,conexionOrigenDatosBean,tipoActualizacion);				
				break;
		}
		
		return mensaje;
	}
	
	// Ejecuta el ktr para guardar en la bd los registros del archivo excel
	public MensajeTransaccionBean ejecutaKTR(final CargaListasPLDBean cargaListasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ParamGeneralesBean	paramGeneralesBean = new ParamGeneralesBean();
		ParametrosAuditoriaBean parametrosAuditoriaBean = new ParametrosAuditoriaBean();
		parametrosAuditoriaBean = cargaListasPLDDAO.getParametrosAuditoriaBean();
		ConexionOrigenDatosBean conexionOrigenDatosBean = new ConexionOrigenDatosBean();
		conexionOrigenDatosBean = cargaListasPLDDAO.getConexionOrigenDatosBean();
		
		try {
			CargaListasPLDBean beanCarga = new CargaListasPLDBean();
			
			beanCarga.setFechaCarga(cargaListasBean.getFechaCarga());
			beanCarga.setTipoLista(cargaListasBean.getTipoLista());
			beanCarga.setRutaArchivoSubido(cargaListasBean.getRutaArchivoSubido());
			
			// Se registra el archivo en la BD
			mensaje = cargaListasPLDDAO.alta(beanCarga);

			if(mensaje.getNumero()>0){
				throw new Exception(mensaje.getDescripcion());
			}

			if(cargaListasBean.getTipoLista().equalsIgnoreCase(Enum_Tipo_ListasPLD.listasNegras)){
				beanCarga = cargaListasPLDDAO.consulta(beanCarga, Enum_Con_CargaListas.listasNegras);
			} else if(cargaListasBean.getTipoLista().equalsIgnoreCase(Enum_Tipo_ListasPLD.listasPersBloq)){
				beanCarga = cargaListasPLDDAO.consulta(beanCarga, Enum_Con_CargaListas.listasPersBloq);
			}
			
			// Se obtiene el KTR a ejecutar
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.KTRCargaListas, paramGeneralesBean);

			if(paramGeneralesBean==null||paramGeneralesBean.getValorParametro().trim()==""){
				throw new Exception("Error. No se encuentra parametrizado la ruta del archivo KTR en PARAMGENERALES con llave \"RutaCargaListasPLD\".");
			}
			final String fileJOB = paramGeneralesBean.getValorParametro();
			
			// Se determina si se lleva a cabo la ejecución del SH que codifica el archivo de carga
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.EncodeCargaListas, paramGeneralesBean);

			if(paramGeneralesBean.getValorParametro().trim().equalsIgnoreCase(Constantes.STRING_SI)){
				// Ejecuta el SH que codifica el archivo de carga
				paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.ScriptSHCargaListas, paramGeneralesBean);

				if(paramGeneralesBean==null||paramGeneralesBean.getValorParametro().equalsIgnoreCase("")){
					throw new Exception("Error. No se encuentra parametrizado el Script SH en PARAMGENERALES con llave \"SHListasPLD\".");
				}
				cargaListasBean.setRutaArchivoSubido(ejecutaSH(paramGeneralesBean, cargaListasBean));

				if(cargaListasBean.getRutaArchivoSubido().trim().equalsIgnoreCase("")){
					throw new Exception("Error. No se encuentra Archivo Generado. Nada que Procesar.");
				}
			}
			
			KettleEnvironment.init();
			JobMeta jobmeta = new JobMeta(fileJOB, null);
			Job job = new Job(null, jobmeta);
			jobmeta.setParameterValue("Par_RutaArchivoSubido", cargaListasBean.getRutaArchivoSubido());
			jobmeta.setParameterValue("Par_IncluyeEncabezado", cargaListasBean.getIncluyeEncabezado());
			jobmeta.setParameterValue("Par_TipoLista", Constantes.STRING_VACIO);
			jobmeta.setInternalKettleVariables(job);
			jobmeta.activateParameters();
			job.shareVariablesWith(jobmeta);
			job.start();
			job.waitUntilFinished();

			if(job.getErrors()>0){
				cargaListasPLDDAO.actualiza(beanCarga, parametrosAuditoriaBean,conexionOrigenDatosBean,Enum_Act_CargaListas.fallo);
				mensaje.setNumero(999);
				mensaje.setConsecutivoString(Constantes.STRING_CERO);
				mensaje.setDescripcion("Ha ocurrido un Error. No se pudo completar la Carga de Listas PLD.");
				mensaje.setNombreControl("adjuntar");
				throw new RuntimeException("Error durante la ejecución del job: " + fileJOB);
			} else {
				if(cargaListasBean.getTipoLista().equalsIgnoreCase(Enum_Tipo_ListasPLD.listasNegras)){
					mensaje = cargaListasPLDDAO.procesaListasNegras(cargaListasBean);
				} else if(cargaListasBean.getTipoLista().equalsIgnoreCase(Enum_Tipo_ListasPLD.listasPersBloq)){
					mensaje = cargaListasPLDDAO.procesaListasPersBloq(cargaListasBean);
				}
				if(mensaje.getNumero()==0){
					cargaListasPLDDAO.actualiza(beanCarga,parametrosAuditoriaBean,conexionOrigenDatosBean,Enum_Act_CargaListas.exito);
				} else {
					cargaListasPLDDAO.actualiza(beanCarga, parametrosAuditoriaBean,conexionOrigenDatosBean,Enum_Act_CargaListas.fallo);
				}
			}

		} catch (KettleException e) {
			e.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setConsecutivoString(Constantes.STRING_CERO);
			mensaje.setDescripcion("Ha ocurrido un Error. No se pudo completar la Carga de Listas PLD.");
			mensaje.setNombreControl("adjuntar");
			loggerSAFI.error("Ha ocurrido un Error. No se pudo completar la Carga de Listas PLD: ", e);
		} catch (Exception e) {
			e.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setConsecutivoString(Constantes.STRING_CERO);
			mensaje.setDescripcion("Ha ocurrido un Error. No se pudo completar la Carga de Listas PLD.");
			mensaje.setNombreControl("adjuntar");
			loggerSAFI.error("Ha ocurrido un Error. No se pudo completar la Carga de Listas PLD: ", e);
		}
		return mensaje;
	}
	/**
	 * Método que ejecuta un script shell, el cual dependiendo de la codificación del archivo de carga crea un archivo
	 * temporal cuya codificación final es UTF-8. Convierte el archivo cuando se trata de una codificación es "binary" o "ISO88591".
	 * @param paramGeneralesBean : Contiene la ruta absoluta del archivo sh a ejecutar.
	 * @param cargaListasBean : Contiene la ruta absoluta del archivo a cargar.
	 * @return La ruta absoluta del nuevo archivo a cargar.
	 * @author avelasco
	 */
	public String ejecutaSH(ParamGeneralesBean paramGeneralesBean, CargaListasPLDBean cargaListasBean){
		String comandoSH = "sudo "+paramGeneralesBean.getValorParametro().trim() + " " +cargaListasBean.getRutaArchivoSubido().trim();
		String [] respuestaSH = new String [2];
		try {
			Process process = Runtime.getRuntime().exec(comandoSH);
			loggerSAFI.info(comandoSH);
			BufferedReader read = new BufferedReader(new InputStreamReader(process.getInputStream()));
			process.waitFor();
			int i = 0;
			while (read.ready()) {
				respuestaSH[i]=read.readLine().toString();
				i++;
			}
			// La codificacion del archivo es: [codificación]
			loggerSAFI.info(respuestaSH[0]);
			loggerSAFI.info("El Archivo a Cargar es: " + respuestaSH[1]);
		} catch (IOException e) {
			loggerSAFI.error("Error al ejecutar el comando: \"" + comandoSH + "\"", e);
		} catch (InterruptedException e) {
			loggerSAFI.error("Error al ejecutar el comando: \"" + comandoSH + "\"", e);
		}
		return respuestaSH[1];
	}
	
	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public CargaListasPLDDAO getCargaListasPLDDAO() {
		return cargaListasPLDDAO;
	}

	public void setCargaListasPLDDAO(CargaListasPLDDAO cargaListasPLDDAO) {
		this.cargaListasPLDDAO = cargaListasPLDDAO;
	}

}
