package pld.dao;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import pld.bean.CargaListasPLDBean;
import pld.bean.OpeInusualesBean;
import pld.bean.PLDDetecPersBean;
import pld.bean.PLDListaNegrasBean;
import pld.bean.PLDListasPersBloqBean;
import pld.servicio.CargaListasPLDServicio.Enum_Con_CargaListas;
import pld.servicio.CargaListasPLDServicio.Enum_Tipo_ListasPLD;
import pld.servicio.PLDListaNegrasServicio.Enum_Con_ClieListasNegras;
import pld.servicio.PLDListasPersBloqServicio.Enum_Con_ListasPersBloq;
import soporte.bean.ParamGeneralesBean;
import soporte.dao.ParamGeneralesDAO.Enum_Con_ParamGenerales;
import soporte.servicio.ParamGeneralesServicio;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Levenshtein;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class LevenshteinDAO extends BaseDAO {

	private LevenshteinDAO() {
		super();
	}

	ParametrosSesionBean parametrosSesionBean = null;
	PLDListasPersBloqDAO pldListasPersBloqDAO = null;
	PLDListaNegrasDAO pldListaNegrasDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	PLDDetecPersDAO pldDetecPersDAO = null;

	public static interface Enum_Tipo_Busqueda {
		int enListasNegras		= 1;
		int enListasPersBloq	= 2;
		int enAmbasListas		= 3;
	}

	/**
	 * Validación de Búsqueda de Coincidencias en Listas Negras y de Personas Bloqueadas.
	 * @param pldListasBean {@link OpeInusualesBean} con valores de entrada (nombres y apellidos).
	 * @param numTransaccion número de transacción.
	 * @param tipoBusqueda indica si busca en listas negras, personas bloqueadas o ambas.
	 * @return {@link MensajeTransaccionBean} con el resultado de la búsqueda.
	 */
	public MensajeTransaccionBean validaListasPLD(final OpeInusualesBean pldListasBean, long numTransaccion, int tipoBusqueda){
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		double porcentajeAceptado = 0.00;
		String realizaBusqueda = "N";

		// CONSULTAR PARÁMETRO HABILITADO
		ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
		paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.ParamBusquedaLV, paramGeneralesBean);
		realizaBusqueda = paramGeneralesBean.getValorParametro().trim();

		if(realizaBusqueda.equals(Constantes.STRING_SI)){
			paramGeneralesBean = new ParamGeneralesBean();
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.ParamPorcentajeMinLV, paramGeneralesBean);
			porcentajeAceptado = Utileria.convierteDoble(paramGeneralesBean.getValorParametro());

			if(tipoBusqueda == Enum_Tipo_Busqueda.enListasPersBloq || tipoBusqueda == Enum_Tipo_Busqueda.enAmbasListas){
				pldListasBean.setTipoLista(String.valueOf(Enum_Con_CargaListas.listasPersBloq));
				mensajeBean = validaListaLPB(pldListasBean, porcentajeAceptado, numTransaccion);

				if(mensajeBean.getNumero() == Constantes.DETECCION_PLD){
					return mensajeBean;
				}
			}

			if(tipoBusqueda == Enum_Tipo_Busqueda.enListasNegras|| tipoBusqueda == Enum_Tipo_Busqueda.enAmbasListas){
				pldListasBean.setTipoLista(String.valueOf(Enum_Con_CargaListas.listasNegras));
				mensajeBean = validaListaLN(pldListasBean, porcentajeAceptado, numTransaccion);
			}

		} else {
			mensajeBean.setNumero(Constantes.ENTERO_CERO);
			mensajeBean.setDescripcion("Busqueda Listas PLD Deshabilitada.");
		}
		return mensajeBean;
	}

	public MensajeTransaccionBean validaListaLN(final OpeInusualesBean pldListasBean, double porcentajeAceptado, long numTransaccion){
		try{
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			PLDListaNegrasBean resultadoBean = new PLDListaNegrasBean();
			JSONArray jsonResultado = new JSONArray();
			if(porcentajeAceptado>1){
				porcentajeAceptado=porcentajeAceptado/100;	
			}

			PLDListaNegrasBean listasBean = new PLDListaNegrasBean();
			listasBean.setTipoPersona(pldListasBean.getTipoPersona());
			
			jsonResultado = pldListaNegrasDAO.consultaDatosLev(listasBean, Enum_Con_ClieListasNegras.datosLevenshtein,numTransaccion);

			double porcentaje=0.0;
			double maxP = 0.0;
			// Nombre completo del Cliente.
			final String nombreCliente = pldListasBean.getNombreCompleto().replace(" ", "");
			Levenshtein lev = new Levenshtein();

			long tiempo1 = System.currentTimeMillis();

			for(int i = 0; i < jsonResultado.length() && (porcentaje<porcentajeAceptado); i++){
				JSONObject regListaPLD = jsonResultado.getJSONObject(i);
				String nombrePersBloq = regListaPLD.get("NombreCompleto").toString().replace(" ", "");
				porcentaje=lev.LevenshteinAlgorithm(nombreCliente, nombrePersBloq, porcentajeAceptado);
				if(porcentaje>maxP){
					maxP=porcentaje;
					resultadoBean.setListaNegraID(regListaPLD.get("ListaNegraID").toString());
					resultadoBean.setTipoLista(regListaPLD.get("TipoLista").toString());
				}
			}
			
			if(Utileria.convierteLong(resultadoBean.getListaNegraID())>Constantes.ENTERO_CERO){
				pldListasBean.setListaID(resultadoBean.getListaNegraID());
				pldListasBean.setTipoListaID(resultadoBean.getTipoLista());
				mensajeBean = pldListasPersBloqDAO.generaAlertaInus(pldListasBean, numTransaccion);
			}
			System.out.println("maxP: "+maxP);
			System.out.println("Tiempo Total:"+(int) (System.currentTimeMillis()-tiempo1)+" ms");
			return mensajeBean;
		} catch (Exception e) {
			throw new IllegalStateException("Error en validaListaLN: ", e);
		}
	}

	public MensajeTransaccionBean validaListaLPB(final OpeInusualesBean pldListasBean, double porcentajeAceptado, long numTransaccion){
		try{
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			PLDListasPersBloqBean resultadoBean = new PLDListasPersBloqBean();
			JSONArray jsonResultado = new JSONArray();
			if(porcentajeAceptado>1){
				porcentajeAceptado=porcentajeAceptado/100;
			}

			PLDListasPersBloqBean listasBean = new PLDListasPersBloqBean();
			listasBean.setTipoPersona(pldListasBean.getTipoPersona());

			jsonResultado = pldListasPersBloqDAO.consultaDatosLev(listasBean, Enum_Con_ListasPersBloq.datosLevenshtein,numTransaccion);

			double porcentaje=0.0;
			double maxP = 0.0;
			// Nombre completo del Cliente.
			final String nombreCliente = pldListasBean.getNombreCompleto().replace(" ", "");
			Levenshtein lev = new Levenshtein();

			long tiempo1 = System.currentTimeMillis();
			for(int i = 0; i < jsonResultado.length() && (porcentaje<porcentajeAceptado); i++){
				JSONObject regListaPLD = jsonResultado.getJSONObject(i);
				String nombrePersBloq = regListaPLD.get("NombreCompleto").toString().replace(" ", "");
				porcentaje=lev.LevenshteinAlgorithm(nombreCliente, nombrePersBloq, porcentajeAceptado);
				if(porcentaje>maxP){
					maxP=porcentaje;
					resultadoBean.setPersonaBloqID(regListaPLD.get("PersonaBloqID").toString());
					resultadoBean.setTipoLista(regListaPLD.get("TipoLista").toString());
				}
			}

			if(Utileria.convierteLong(resultadoBean.getPersonaBloqID())>Constantes.ENTERO_CERO){
				pldListasBean.setListaID(resultadoBean.getPersonaBloqID());
				pldListasBean.setTipoListaID(resultadoBean.getTipoLista());
				mensajeBean = pldListasPersBloqDAO.generaAlertaInus(pldListasBean, numTransaccion);
			}
			System.out.println("maxP: "+maxP);
			System.out.println("Tiempo Total:"+(int) (System.currentTimeMillis()-tiempo1)+" ms");
			return mensajeBean;
		} catch (Exception e) {
			throw new IllegalStateException("Error en validaListaLPB: ", e);
		}
	}


	public MensajeTransaccionBean validacionMasivaPLD(final CargaListasPLDBean pldListasBean, final JSONArray listaPersonas, JSONArray jsonResultadoPLD, double porcentajeAceptado, long numTransaccion){
		loggerSAFI.info("BusquedaMasivaPLD ["+numTransaccion+"] INICIO.");
		loggerSAFI.info("BusquedaMasivaPLD ["+numTransaccion+"] " + (pldListasBean.getTipoLista().equalsIgnoreCase(Enum_Tipo_ListasPLD.listasNegMasiva) ? "LISTAS NEGRAS." : "LISTAS PERS.BLOQ."));
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		MensajeTransaccionBean mensajeAlta = new MensajeTransaccionBean();
		Levenshtein lev = new Levenshtein();
		PLDDetecPersBean resultadoBean = new PLDDetecPersBean();
		ArrayList<PLDDetecPersBean> listaDetecciones = new ArrayList<PLDDetecPersBean>();

		try{
			String origenCargaMasiva = "C";
			if(porcentajeAceptado>1){
				porcentajeAceptado=porcentajeAceptado/100;
			}

			double porcentaje=0.0;
			double maxP = 0.0;
			long tiempo1 = System.currentTimeMillis();

			loggerSAFI.info("BusquedaMasivaPLD ["+numTransaccion+"] TOTAL DE REGISTROS CLIENTES SAFI ["+listaPersonas.length()+"]");
			loggerSAFI.info("BusquedaMasivaPLD ["+numTransaccion+"] TOTAL DE REGISTROS EN LISTAS PLD ["+jsonResultadoPLD.length()+"]");

			// Ciclo para recorrer la Lista PLD.
			for(int i_pld = 0; i_pld < jsonResultadoPLD.length(); i_pld++){
				JSONObject regListaPLD = jsonResultadoPLD.getJSONObject(i_pld);
				String nombrePBloq = regListaPLD.get("NombreCompleto").toString();
				String tipoPersonaPBloq = regListaPLD.get("TipoPersona").toString();

				// Ciclo para recorrer la lista de Personas en SAFI (ctes, proveedores, etc.).
				for(int i = 0; i < listaPersonas.length(); i++){
					JSONObject regListaCtes = listaPersonas.getJSONObject(i);
					String nombreCliente = regListaCtes.get("NombreCompleto").toString();
					String tipoPersonaCliente = regListaCtes.get("TipoPersona").toString();

					// Si el Tipo de Persona es el mismo. Solo F o M.
					if(tipoPersonaPBloq.equalsIgnoreCase(tipoPersonaCliente)){
						porcentaje = lev.LevenshteinAlgorithm(nombreCliente, nombrePBloq, porcentajeAceptado);
						if(porcentaje>maxP){
							maxP=porcentaje;
							resultadoBean.setTipoPersonaSAFI(regListaCtes.get("TipoPersonaSAFI").toString());
							resultadoBean.setClavePersonaInv(regListaCtes.get("ClavePersonaInv").toString());
							resultadoBean.setNombreCompleto(Constantes.STRING_VACIO);// Se obtiene en el sp de alta.
							resultadoBean.setTipoLista(pldListasBean.getTipoLista());// Indica si es lista negra o de pers. bloq.
							resultadoBean.setListaPLDID(regListaPLD.getString("ListaPLDID"));

							resultadoBean.setIdQEQ(regListaPLD.get("IDQEQ").toString());
							resultadoBean.setNumeroOficio(regListaPLD.get("NumeroOficio").toString());
							resultadoBean.setOrigenDeteccion(origenCargaMasiva);
							resultadoBean.setFechaAlta(regListaPLD.getString("FechaAlta"));
							resultadoBean.setTipoListaID(regListaPLD.get("TipoLista").toString());// Valor de catálogo.

							listaDetecciones.add(resultadoBean);
						}
					}
				}
			}

			System.out.println("maxP: "+maxP);
			loggerSAFI.info("BusquedaMasivaPLD ["+numTransaccion+"] TIEMPO TOTAL BUSQUEDA ["+(int) (System.currentTimeMillis()-tiempo1)+" MS.]");
			loggerSAFI.info("BusquedaMasivaPLD ["+numTransaccion+"] TOTAL DETECCIONES ENCONTRADAS ["+listaDetecciones.size()+"]");

			tiempo1 = System.currentTimeMillis();
			for(int i=0; i < listaDetecciones.size(); i++){
				mensajeAlta = pldDetecPersDAO.alta(listaDetecciones.get(i),numTransaccion);
			}

			if(listaDetecciones.size() > Constantes.ENTERO_CERO){
				loggerSAFI.info("BusquedaMasivaPLD ["+numTransaccion+"] TIEMPO TOTAL ALTA ["+(int) (System.currentTimeMillis()-tiempo1)+" MS.]");
			}

			mensajeBean.setNumero(Constantes.ENTERO_CERO);
			mensajeBean.setConsecutivoString(String.valueOf(numTransaccion));
			mensajeBean.setDescripcion("Busqueda de Coincidencias Realizada Exitosamente.");
			mensajeBean.setNombreControl("procesar");

			return mensajeBean;
		} catch (Exception e) {
			mensajeBean.setNumero(Constantes.ErrorGenerico);
			mensajeBean.setConsecutivoString(String.valueOf(numTransaccion));
			mensajeBean.setDescripcion("No se ha podido Realizar la Busqueda de Coincidencias.");
			mensajeBean.setNombreControl("procesar");

			throw new IllegalStateException("Error en validacionMasivaPLD(): ", e);
		}
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(
			ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
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

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public PLDDetecPersDAO getPldDetecPersDAO() {
		return pldDetecPersDAO;
	}

	public void setPldDetecPersDAO(PLDDetecPersDAO pldDetecPersDAO) {
		this.pldDetecPersDAO = pldDetecPersDAO;
	}

}