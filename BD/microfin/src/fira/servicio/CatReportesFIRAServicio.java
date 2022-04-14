package fira.servicio;

import fira.bean.CatReportesFIRABean;
import fira.dao.CatReportesFIRADAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;
import contabilidad.bean.ConceptosEdosFinancierosBean;
import contabilidad.servicio.ConceptosEdosFinancierosServicio;
import contabilidad.servicio.ConceptosEdosFinancierosServicio.Enum_Lis_ConceptosFin;
import contabilidad.servicio.ConceptosEdosFinancierosServicio.Enum_Tra_ConceptosFin;

public class CatReportesFIRAServicio extends BaseServicio {

	CatReportesFIRADAO catReportesFIRADAO = null;
	ConceptosEdosFinancierosServicio conceptosEdosFinancierosServicio = null;
	ParamGeneralesServicio paramGeneralesServicio = null;

	public static interface Enum_Con_TipoReporte {
		int nombreArchivoRep = 1;
	}

	public static interface Enum_Lista_TipoReporte {
		int principal = 1;
		int reporteFinanciero = 2;
		int proyeccionAnios = 3;

	}
	
	public static interface Enum_Cat_TipoReporte {
		int balanceGeneral = 1;
		int estadoResultados = 2;
		int fira = 5;
		int noFira = 6;
	}
	/**
	 * Método genérico de lista.
	 * @param tipoLista : Número de lista a mostrar.
	 * @param catCadenaProductivaBean : Clase bean {@linkplain CatReportesFIRABean} con los parámetros de entrada a los SPs de lista.
	 * @return List : Lista de objetos de la clase {@linkplain CatReportesFIRABean}.
	 * @author avelasco
	 * @param numTransaccion 
	 */
	public List<CatReportesFIRABean> lista(int tipoLista, CatReportesFIRABean catCadenaProductivaBean, long numTransaccion) {
		List<CatReportesFIRABean> lista = null;
		switch (tipoLista) {
		case Enum_Lista_TipoReporte.principal:
			lista = catReportesFIRADAO.lista(catCadenaProductivaBean, tipoLista);
			break;
		case Enum_Lista_TipoReporte.reporteFinanciero:
			listaReporte(catCadenaProductivaBean, tipoLista, numTransaccion);
			lista = catReportesFIRADAO.listaReporte(catCadenaProductivaBean, tipoLista, numTransaccion);
			break;
		case Enum_Lista_TipoReporte.proyeccionAnios:
			lista = catReportesFIRADAO.listaProyeccion(tipoLista);
			break;
		}
		
		return lista;
	}
	/**
	 * Método genérico para realizar consultas al Catálogo de los Reportes de Monitoreo.
	 * @param catReportesFIRABean : Clase bean {@linkplain CatReportesFIRABean} con los parámetros de entrada a SP-CATREPORTESFIRACON.
	 * @param tipoConsulta : Número de consulta.
	 * @return {@linkplain CatReportesFIRABean} con el resultado de la consulta.
	 * @author avelasco
	 */
	public CatReportesFIRABean consulta(CatReportesFIRABean catReportesFIRABean, int tipoConsulta, long numTransaccion){
		CatReportesFIRABean catReportesBean = null;
		switch (tipoConsulta) {
			case Enum_Con_TipoReporte.nombreArchivoRep:		
				catReportesBean = catReportesFIRADAO.consultaNombreReporte(catReportesFIRABean, tipoConsulta,numTransaccion);
				break;	
		}
		return catReportesBean;
	}
	/**
	 * Se listan los conceptos de los estados financieros de acuerdo al cliente parametrizado en
	 * PARAMGENERALES.
	 * @param reportesFiraBean : Clase bean que contiene el tipo de reporte financiero.
	 * @param tipoLista : Número de lista.
	 * @param numeroTransaccion : Número de transacción.
	 * @author avelasco
	 */
	public void listaReporte(CatReportesFIRABean reportesFiraBean, int tipoLista, long numeroTransaccion){
		ArrayList<ConceptosEdosFinancierosBean> listaAux = new ArrayList<ConceptosEdosFinancierosBean>();
		ConceptosEdosFinancierosBean conceptosBean = new ConceptosEdosFinancierosBean();
		ParamGeneralesBean parametrosBean = new ParamGeneralesBean();
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		int ConsultaClienteEspecifico = 13;
		try {
			switch (Utileria.convierteEntero(reportesFiraBean.getTipoReporteID())) {
				case Enum_Cat_TipoReporte.balanceGeneral:
				case Enum_Cat_TipoReporte.estadoResultados:
					// Se consulta el número de cliente para procesos específicos.
					parametrosBean = paramGeneralesServicio.consulta(ConsultaClienteEspecifico, parametrosBean);
					// Se setea el bean para listar los conceptos por el cliente y el reporte.
					conceptosBean.setNumClien(parametrosBean.getValorParametro());
					conceptosBean.setEstadoFinanID(reportesFiraBean.getTipoReporteID());
	
					listaAux = conceptosEdosFinancierosServicio.lista(Enum_Lis_ConceptosFin.principal, conceptosBean);
	
					// Se eliminan las fórmulas de la generación anterior.
					mensajeBean = conceptosEdosFinancierosServicio.grabaTransaccion(Enum_Tra_ConceptosFin.baja, conceptosBean, numeroTransaccion);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					registraNuevosConceptos(listaAux, numeroTransaccion);
					break;
			}
		} catch (Exception e){
			e.printStackTrace();
		}
	}
	/**
	 * Para el Balance Gral y el Edo. de Resultados se crean nuevos conceptos partiendo de los que ya se tienen.
	 * Este método separa aquellos conceptos que son calculados (S) en cuentas independientes guardándolos
	 * en una tabla exclusiva para el monitoreo de la cartera agro (FIRA).
	 * @param lista : Lista de conceptos contables para los estados financieros. {@linkplain ConceptosEdosFinancierosBean}.
	 * @param numeroTransaccion : Número de transacción.
	 * @author avelasco
	 */
	public void registraNuevosConceptos(ArrayList<ConceptosEdosFinancierosBean> lista, long numeroTransaccion){
		List<ConceptosEdosFinancierosBean> listaConceptos = lista;
		List<ConceptosEdosFinancierosBean> listaAux = new ArrayList<ConceptosEdosFinancierosBean> (lista);
		ConceptosEdosFinancierosBean beanAux = null;
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			for(ConceptosEdosFinancierosBean detalle : listaAux){
				// Si el concepto se calcula (si es parte de una suma y/o resta).
				if(detalle.getEsCalculado().equalsIgnoreCase("S")){
					// Se limpian de espacios.
					String cuentasFormula = detalle.getCuentaContable().trim().replace(" ", "");
					// Se separan las cuentas.
					String[] cuentas = cuentasFormula.split("-|\\+");
					String operador = "";
					int contadorCaracts = 0;
					for(int i=0; i<cuentas.length; i++){
						// Se cuentan la longitud en caracteres de la cuenta.
						contadorCaracts = contadorCaracts + cuentas[i].length();
						// Se crea un objeto copia del padre pero con los nuevos valores obtenidos.
						beanAux = new ConceptosEdosFinancierosBean();
						beanAux.setEstadoFinanID(detalle.getEstadoFinanID());
						beanAux.setConceptoFinanID(detalle.getConceptoFinanID());
						beanAux.setNumClien(detalle.getNumClien());
						beanAux.setDescripcion(detalle.getDescripcion());
						beanAux.setDesplegado(detalle.getDesplegado());
						beanAux.setEsCalculado("N");// No es calculado
						beanAux.setNombreCampo(detalle.getNombreCampo());
						beanAux.setEspacios(detalle.getEspacios());
						beanAux.setNegrita(detalle.getNegrita());
						beanAux.setSombreado(detalle.getSombreado());
						beanAux.setCombinarCeldas(detalle.getCombinarCeldas());
						beanAux.setCuentaFija(detalle.getCuentaFija());
						beanAux.setPresentacion(detalle.getPresentacion());
						beanAux.setTipo(detalle.getTipo());
						beanAux.setCuentaContable(cuentas[i]);
						
						if(contadorCaracts<cuentasFormula.length()){
							// Se obtiene el operador matemático
							operador = (cuentasFormula.substring(contadorCaracts, contadorCaracts+1)).equalsIgnoreCase("+")?"S":"R";
						} else {
							operador = "";
						}
						
						contadorCaracts++;
						beanAux.setTipoCalculo(operador);
						listaConceptos.add(beanAux);
					}
				}
			}
			for(ConceptosEdosFinancierosBean detalle : listaConceptos){
				mensajeBean = conceptosEdosFinancierosServicio.grabaTransaccion(Enum_Tra_ConceptosFin.alta, detalle, numeroTransaccion);
				if (mensajeBean.getNumero() != 0) {
					throw new Exception(mensajeBean.getDescripcion());
				}
			}
		} catch (Exception e){
			e.printStackTrace();
		}
	}

	public CatReportesFIRADAO getCatReportesFIRADAO() {
		return catReportesFIRADAO;
	}

	public void setCatReportesFIRADAO(CatReportesFIRADAO catReportesFIRADAO) {
		this.catReportesFIRADAO = catReportesFIRADAO;
	}

	public ConceptosEdosFinancierosServicio getConceptosEdosFinancierosServicio() {
		return conceptosEdosFinancierosServicio;
	}

	public void setConceptosEdosFinancierosServicio(
			ConceptosEdosFinancierosServicio conceptosEdosFinancierosServicio) {
		this.conceptosEdosFinancierosServicio = conceptosEdosFinancierosServicio;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

}