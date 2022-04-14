package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import org.json.JSONArray;
import org.pentaho.di.core.KettleEnvironment;
import org.pentaho.di.core.exception.KettleException;
import org.pentaho.di.job.Job;
import org.pentaho.di.job.JobMeta;

import pld.bean.CargaListasPLDBean;
import pld.bean.PLDDetecPersBean;
import pld.bean.PLDListaNegrasBean;
import pld.bean.PLDListasPersBloqBean;
import pld.dao.CargaListasPLDDAO;
import pld.dao.LevenshteinDAO;
import pld.dao.PLDDetecPersDAO;
import pld.dao.PLDListaNegrasDAO;
import pld.dao.PLDListasPersBloqDAO;
import pld.servicio.CargaListasPLDServicio.Enum_Tipo_ListasPLD;
import pld.servicio.PLDListaNegrasServicio.Enum_Con_ClieListasNegras;
import pld.servicio.PLDListasPersBloqServicio.Enum_Con_ListasPersBloq;
import soporte.bean.ParamGeneralesBean;
import soporte.dao.ParamGeneralesDAO.Enum_Con_ParamGenerales;
import soporte.servicio.ParamGeneralesServicio;

public class CoincidenciasListasPLDServicio extends BaseServicio{

	ParamGeneralesServicio paramGeneralesServicio = null;
	CargaListasPLDDAO cargaListasPLDDAO = null;
	PLDDetecPersDAO pldDetecPersDAO = null;
	PLDListasPersBloqDAO pldListasPersBloqDAO = null;
	PLDListaNegrasDAO pldListaNegrasDAO = null;
	LevenshteinDAO levenshteinDAO = null;

	public static interface Enum_Tra_CoincidenciasListas {
		int busquedaMasiva = 1;
	}

	public static interface Enum_Con_BusquedaListas {
		int datosLevMasivo = 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CargaListasPLDBean cargaListasBean){
		MensajeTransaccionBean mensaje = null;

		switch (tipoTransaccion) {
		case Enum_Tra_CoincidenciasListas.busquedaMasiva:
			mensaje = procesaBusqueda(cargaListasBean);
			break;
		}

		return mensaje;
	}
	public MensajeTransaccionBean procesaBusqueda(final CargaListasPLDBean cargaListasBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ParamGeneralesBean	paramGeneralesBean = new ParamGeneralesBean();
		String realizaBusqueda = "N";
		long numTransaccionID = cargaListasPLDDAO.getNumTransaccion();

		// CONSULTAR PARÁMETRO HABILITADO
		paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.ParamBusquedaLV, paramGeneralesBean);
		realizaBusqueda = paramGeneralesBean.getValorParametro().trim();
		realizaBusqueda = (realizaBusqueda.equalsIgnoreCase("") ? Constantes.STRING_NO : realizaBusqueda);

		// SÍ SE REALIZA A NIVEL JAVA.
		if(realizaBusqueda.equalsIgnoreCase(Constantes.STRING_SI)){
			mensaje = ejecutaProcesoLV(cargaListasBean,numTransaccionID);
		} else {
		// SINO, SE EJECUTA EL ETL PARA LA BÚSQUEDA A NIVEL DE BD.
			mensaje = ejecutaKTR(cargaListasBean,numTransaccionID);
		}
		return mensaje;
	}
	/**
	 * Ejecuta el job para realizar la búsqueda masiva de coincidencias a nivel de BD.
	 * @param cargaListasBean : Clase bean con el valor del tipo de lista a evaluar.
	 * @param numTrasaccionbusqueda : Número de transacción para la búsqueda.
	 * @return MensajeTransaccionBean con el resultado de la ejecución.
	 * @author avelasco
	 */
	public MensajeTransaccionBean ejecutaKTR(final CargaListasPLDBean cargaListasBean, final long numTrasaccionbusqueda) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ParamGeneralesBean	paramGeneralesBean = new ParamGeneralesBean();
		try {
			
			// Se obtiene el KTR a ejecutar
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.busquedaListasJOB, paramGeneralesBean);

			if(paramGeneralesBean==null||paramGeneralesBean.getValorParametro().trim()==""){
				throw new Exception("Error. No se encuentra parametrizado la ruta del archivo JOB en PARAMGENERALES con llave \"BusquedaListasPLD\".");
			}
			
			final String file = paramGeneralesBean.getValorParametro();
			
			KettleEnvironment.init();
			JobMeta jobmeta = new JobMeta(file, null);
			Job job = new Job(null, jobmeta);
			jobmeta.setParameterValue("Par_TipoLista", cargaListasBean.getTipoLista());
			jobmeta.setParameterValue("Par_NumTransaccion", String.valueOf(numTrasaccionbusqueda));
			jobmeta.setInternalKettleVariables(job);
			jobmeta.activateParameters();
			job.shareVariablesWith(jobmeta);
			job.start();
			job.waitUntilFinished();

			if(job.getErrors()>0){
				mensaje = seteaError();
				throw new RuntimeException("Error durante la ejecución del job: " + file);
			} else {
				mensaje.setNumero(0);
				mensaje.setConsecutivoString(Constantes.STRING_CERO);
				mensaje.setDescripcion("Busqueda de Coincidencias Realizada Exitosamente.");
				mensaje.setNombreControl("adjuntar");
			}

		} catch (KettleException e) {
			e.printStackTrace();
			mensaje = seteaError();
			loggerSAFI.error("Ha ocurrido un Error. No se pudo completar la Carga de Listas PLD: ", e);
		} catch (Exception e) {
			e.printStackTrace();
			mensaje = seteaError();
			loggerSAFI.error("Ha ocurrido un Error. No se pudo completar la Carga de Listas PLD: ", e);
		}
		return mensaje;
	}

	/**
	 * Ejecuta el método Leveinstein para realizar la búsqueda masiva de coincidencias
	 * a nivel JAVA por porcentaje definido.
	 * @param cargaListasBean : Clase bean con el valor del tipo de lista a evaluar.
	 * @param numTrasaccionbusqueda : Número de transacción para la búsqueda.
	 * @return MensajeTransaccionBean con el resultado de la ejecución.
	 * @author avelasco
	 */
	public MensajeTransaccionBean ejecutaProcesoLV(final CargaListasPLDBean cargaListasBean, final long numTrasaccionbusqueda) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();

		PLDDetecPersBean personasBean = new PLDDetecPersBean();
		// Se setea como vacío para obtener todos los tipos de personas del SAFI.
		personasBean.setTipoPersonaSAFI(Constantes.STRING_VACIO);

		JSONArray jsonResultadoPLD = new JSONArray();
		JSONArray jsonClientesSAFI = new JSONArray();
		double porcentajeAceptado = 0.00;
		try {
			// Se consulta el porcentaje de coincidencias para poder realizar la búsqueda.
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.ParamPorcentajeMinLV, paramGeneralesBean);
			porcentajeAceptado = Utileria.convierteDoble(paramGeneralesBean.getValorParametro());

			// Se obtiene la lista de personas existentes en el SAFI (Clientes, Usuarios de Serv., Prospectos, etc.).
			jsonClientesSAFI = pldDetecPersDAO.consultaDatosPersonas(personasBean, Enum_Con_BusquedaListas.datosLevMasivo, numTrasaccionbusqueda);

			// Se obtienen los registros de las listas para realizar la búsqueda.
			if(cargaListasBean.getTipoLista().equalsIgnoreCase(Enum_Tipo_ListasPLD.listasNegMasiva)){
				PLDListaNegrasBean listaNegBean = new PLDListaNegrasBean();
				listaNegBean.setListaNegraID(Constantes.STRING_CERO);
				listaNegBean.setTipoPersona(Constantes.STRING_VACIO);
				jsonResultadoPLD = pldListaNegrasDAO.consultaDatosLev(listaNegBean, Enum_Con_ClieListasNegras.datosLevMasivo,numTrasaccionbusqueda);
			}

			if(cargaListasBean.getTipoLista().equalsIgnoreCase(Enum_Tipo_ListasPLD.listasPBloqMasiva)){
				PLDListasPersBloqBean listaBloqBean = new PLDListasPersBloqBean();
				listaBloqBean.setPersonaBloqID(Constantes.STRING_CERO);
				listaBloqBean.setTipoPers(Constantes.STRING_VACIO);
				listaBloqBean.setTipoPersona(Constantes.STRING_VACIO);
				listaBloqBean.setCuentaAhoID(Constantes.STRING_CERO);
				listaBloqBean.setCreditoID(Constantes.STRING_CERO);
				jsonResultadoPLD = pldListasPersBloqDAO.consultaDatosLev(listaBloqBean, Enum_Con_ListasPersBloq.datosLevMasivo,numTrasaccionbusqueda);
			}

			mensaje = levenshteinDAO.validacionMasivaPLD(cargaListasBean, jsonClientesSAFI, jsonResultadoPLD, porcentajeAceptado, numTrasaccionbusqueda);

		} catch (Exception e) {
			e.printStackTrace();
			mensaje = seteaError();
			loggerSAFI.error("Ha ocurrido un Error. No se pudo completar la Carga de Listas PLD: ", e);
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean seteaError(){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(999);
		mensaje.setConsecutivoString(Constantes.STRING_CERO);
		mensaje.setDescripcion("Ha ocurrido un Error. No se pudo completar la Busqueda de Coincidencias en Listas PLD.");
		mensaje.setNombreControl("procesar");
		return mensaje;
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

	public PLDDetecPersDAO getPldDetecPersDAO() {
		return pldDetecPersDAO;
	}

	public void setPldDetecPersDAO(PLDDetecPersDAO pldDetecPersDAO) {
		this.pldDetecPersDAO = pldDetecPersDAO;
	}

	public PLDListasPersBloqDAO getPldListasPersBloqDAO() {
		return pldListasPersBloqDAO;
	}

	public void setPldListasPersBloqDAO(
			PLDListasPersBloqDAO pldListasPersBloqDAO) {
		this.pldListasPersBloqDAO = pldListasPersBloqDAO;
	}

	public PLDListaNegrasDAO getPldListaNegrasDAO() {
		return pldListaNegrasDAO;
	}

	public void setPldListaNegrasDAO(PLDListaNegrasDAO pldListaNegrasDAO) {
		this.pldListaNegrasDAO = pldListaNegrasDAO;
	}

	public LevenshteinDAO getLevenshteinDAO() {
		return levenshteinDAO;
	}

	public void setLevenshteinDAO(LevenshteinDAO levenshteinDAO) {
		this.levenshteinDAO = levenshteinDAO;
	}

}