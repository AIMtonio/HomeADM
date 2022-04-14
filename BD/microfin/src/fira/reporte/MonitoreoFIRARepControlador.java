package fira.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.pentaho.di.core.KettleEnvironment;
import org.pentaho.di.job.Job;
import org.pentaho.di.job.JobMeta;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ParamGeneralesBean;
import soporte.bean.ParametrosSisBean;
import soporte.dao.ParamGeneralesDAO.Enum_Con_ParamGenerales;
import soporte.servicio.ParamGeneralesServicio;
import soporte.servicio.ParametrosSisServicio;
import fira.bean.CatReportesFIRABean;
import fira.servicio.CatReportesFIRAServicio;
import fira.servicio.CatReportesFIRAServicio.Enum_Cat_TipoReporte;

public class MonitoreoFIRARepControlador extends AbstractCommandController  {

	CatReportesFIRAServicio catReportesFIRAServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	ParamGeneralesServicio	paramGeneralesServicio	= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporCsv= 1 ;
	}
	
	public MonitoreoFIRARepControlador () {
		setCommandClass(CatReportesFIRABean.class);
		setCommandName("catReportesBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {

		CatReportesFIRABean catReportesBean = (CatReportesFIRABean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		int tipoConsulta = Utileria.convierteEntero(request.getParameter("tipoConsulta"));

		catReportesFIRAServicio.getCatReportesFIRADAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		String htmlString= "";

		reporteCSV(tipoLista, tipoConsulta, catReportesBean, response);

		return null;
	}
	
	/**
	 * Método que genera el reporte de Monitoreo de la Cartera Agro (FIRA).
	 * El nombre del archivo generado se consulta en el SP-CATREPORTESFIRACON.
	 * @param tipoLista : Tipo de reporte a Generar: 2 para los reportes financieros.
	 * @param tipoConsulta : Número de consulta 1 para obtener el nombre del archivo a generar.
	 * @param catReportesBean : Clase Bean con los valores de los parámetros de entrada al SP.
	 * @param response : Response (uso futuro).
	 * @return List: Lista con los registros generados para el reporte.
	 * @author avelasco
	 */
	public List reporteCSV(int tipoLista, int tipoConsulta, CatReportesFIRABean catReportesBean, HttpServletResponse response) {
		List listaReporte = null;
		
		String nombreArchivoReporte = "";
		try {
			System.out.println("Tipo Lista: " + tipoLista + "\tTipoConsulta: " + tipoConsulta);
			long numTransaccion = catReportesFIRAServicio.getCatReportesFIRADAO().getNumTransaccion();
			ParametrosSisBean parametrosBean = new ParametrosSisBean();
			parametrosBean.setEmpresaID(String.valueOf(catReportesFIRAServicio.getCatReportesFIRADAO().getParametrosAuditoriaBean().getEmpresaID()));
			parametrosBean = parametrosSisServicio.consulta(1, parametrosBean);
			catReportesBean.setRecurso(parametrosBean.getRutaArchivos());
			if (Enum_Cat_TipoReporte.fira == Utileria.convierteEntero(catReportesBean.getTipoReporteID()) || Enum_Cat_TipoReporte.noFira == Utileria.convierteEntero(catReportesBean.getTipoReporteID())) {
				ejecutaKTRMonitor(tipoLista, tipoConsulta, catReportesBean, numTransaccion);
			}
			listaReporte = catReportesFIRAServicio.lista(tipoLista, catReportesBean,numTransaccion);
			
			CatReportesFIRABean auxNombre = catReportesFIRAServicio.consulta(catReportesBean, tipoConsulta,numTransaccion);
			nombreArchivoReporte = auxNombre.getNombreReporte().trim();
			
			File directorioBuro = new File(parametrosBean.getRutaArchivos() + "/FIRA/");
			
			if (!directorioBuro.exists()) {
				directorioBuro.mkdirs();
			}
			
			// Crea un archivo temporal
			File f = File.createTempFile(nombreArchivoReporte, ".csv", directorioBuro);
			
			ServletOutputStream ouputStream = null;
			BufferedWriter writer = new BufferedWriter(new FileWriter(f));
			
			if (!listaReporte.isEmpty()) {
				int i = 1, iter = 0;
				int tamanioLista = listaReporte.size();
				CatReportesFIRABean creditos = null;
				for (iter = 0; iter < tamanioLista; iter++) {
					creditos = (CatReportesFIRABean) listaReporte.get(iter);
					writer.write(creditos.getReporte() + "\n");
				}
			} else {
				writer.write("");
			}
			
			writer.close();
			
			FileInputStream archivoLect = new FileInputStream(f);
			int longitud = archivoLect.available();
			byte[] datos = new byte[longitud];
			archivoLect.read(datos);
			archivoLect.close();
			
			f.deleteOnExit();
			
			response.setHeader("Content-Disposition", "attachment;filename=" + nombreArchivoReporte + ".csv");
			response.setContentType("application/text");
			ouputStream = response.getOutputStream();
			ouputStream.write(datos);
			ouputStream.flush();
			ouputStream.close();
			
		} catch (IOException io) {
			io.printStackTrace();
		}
		return listaReporte;
	}


	private MensajeTransaccionBean ejecutaKTRMonitor(int tipoLista, int tipoConsulta, CatReportesFIRABean catReportesBean, long numTransaccion) {
		MensajeTransaccionBean mensaje= new MensajeTransaccionBean();
		try {
			System.out.println("Ejecucion del proceso KTR");
			ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
			
			// Se obtiene el KTR a ejecutar
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.KTRArchivosMonitoreo, paramGeneralesBean);
			if(paramGeneralesBean==null||paramGeneralesBean.getValorParametro().trim()==""){
				throw new Exception("Error. No se encuentra parametrizado la ruta del archivo JOB en PARAMGENERALES con llave \"ArchivosMonitorAgro\".");
			}
			final String file = paramGeneralesBean.getValorParametro();
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.RutaPropConexionesSAFI, paramGeneralesBean);
			if(paramGeneralesBean==null||paramGeneralesBean.getValorParametro().trim()==""){
				throw new Exception("Error. No se encuentra parametrizado la ruta del properties RutaPropConexionesSAFI en PARAMGENERALES con llave \"RutaPropConexionesSAFI\".");
			}
			final String rutaConexionesSAFIProp = paramGeneralesBean.getValorParametro();
			if(Utileria.convierteEntero(catReportesBean.getTipoReporteID())==5){
				ejecKTR(1,file,rutaConexionesSAFIProp, catReportesBean,numTransaccion);
				ejecKTR(2,file,rutaConexionesSAFIProp, catReportesBean,numTransaccion);
			} else if(Utileria.convierteEntero(catReportesBean.getTipoReporteID())==6){
				ejecKTR(3,file,rutaConexionesSAFIProp, catReportesBean,numTransaccion);
			}
			
			mensaje.setNumero(0);
			mensaje.setDescripcion("Informacion Procesada Exitosamente");

		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(888);
			mensaje.setDescripcion("Error al generar el reporte."+ex.getMessage());
		} 
		return mensaje;
	}
	
	public MensajeTransaccionBean ejecKTR(int tipoArchivo, String file, String rutaConexionesSAFIProp, CatReportesFIRABean catReportesBean, long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			System.out.println("KTR "+tipoArchivo);
			String directorio = catReportesBean.getRecurso() + "FIRA/MONITOREO/" + catReportesBean.getFechaReporte() + "/";
			String directCalif = directorio+catReportesBean.getRutaFinalCalCartFira();
			String directReserva = directorio+catReportesBean.getRutaFinalArchivoRes();
			System.out.println("Cl:"+directCalif);
			System.out.println("Re:"+directReserva);
			KettleEnvironment.init();
			JobMeta jobmeta = new JobMeta(file, null);
			Job job = new Job(null, jobmeta);
			
			jobmeta.setParameterValue("Par_ConexionesSAFI", rutaConexionesSAFIProp);
			jobmeta.setParameterValue("Par_Fecha", catReportesBean.getFechaReporte());
			jobmeta.setParameterValue("Par_RutaFinalCalCartFira", directCalif);
			jobmeta.setParameterValue("Par_RutaFinalArchivoRes", directReserva);
			jobmeta.setParameterValue("Par_TipoReporte", String.valueOf(tipoArchivo));
			jobmeta.setParameterValue("Par_TransaccionID", String.valueOf(numTransaccion));
			
			jobmeta.setInternalKettleVariables(job);
			jobmeta.activateParameters();
			job.shareVariablesWith(jobmeta);
			job.start();
			job.waitUntilFinished();
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(888);
			mensaje.setDescripcion("Error al ejecutar el proceso KTR para el Archivo. " + tipoArchivo);
		}
		return mensaje;
	}

	public CatReportesFIRAServicio getCatReportesFIRAServicio() {
		return catReportesFIRAServicio;
	}

	public void setCatReportesFIRAServicio(
			CatReportesFIRAServicio catReportesFIRAServicio) {
		this.catReportesFIRAServicio = catReportesFIRAServicio;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}
	
}