package fira.servicio;

import fira.bean.ArchPerdidaEsperadaBean;
import fira.dao.ArchPerdidaEsperadaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.pentaho.di.core.KettleEnvironment;
import org.pentaho.di.job.Job;
import org.pentaho.di.job.JobMeta;

import soporte.bean.ParamGeneralesBean;
import soporte.dao.ParamGeneralesDAO.Enum_Con_ParamGenerales;
import soporte.servicio.ParamGeneralesServicio;

public class ArchPerdidaEsperadaServicio extends BaseServicio {
	ArchPerdidaEsperadaDAO archPerdidaEsperadaDAO;
	ParamGeneralesServicio	paramGeneralesServicio	= null;
	
	public MensajeTransaccionBean ejecutaKTRArchivosPerdida(ArchPerdidaEsperadaBean archPerdidaEsperadaBean,HttpServletResponse response) {
		MensajeTransaccionBean mensaje= new MensajeTransaccionBean();
		try {
			ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
			long numTransaccion = archPerdidaEsperadaDAO.getNumTransaccion();
			// Se obtiene el KTR a ejecutar
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.KTRArchivosPerd, paramGeneralesBean);
			if(paramGeneralesBean==null||paramGeneralesBean.getValorParametro().trim()==""){
				throw new Exception("Error. No se encuentra parametrizado la ruta del archivo JOB en PARAMGENERALES con llave \"ArchivosPerdidaEsp\".");
			}
			final String file = paramGeneralesBean.getValorParametro();
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.RutaPropConexionesSAFI, paramGeneralesBean);
			if(paramGeneralesBean==null||paramGeneralesBean.getValorParametro().trim()==""){
				throw new Exception("Error. No se encuentra parametrizado la ruta del properties RutaPropConexionesSAFI en PARAMGENERALES con llave \"ArchivosPerdidaEsp\".");
			}
			final String rutaConexionesSAFIProp = paramGeneralesBean.getValorParametro();
			
			KettleEnvironment.init();
			JobMeta jobmeta = new JobMeta(file, null);
			Job job = new Job(null, jobmeta);
			String arrayDirectorio[] = archPerdidaEsperadaBean.getRutaFinal().split("/");
			String directorio = archPerdidaEsperadaBean.getRutaFinal().replace(arrayDirectorio[arrayDirectorio.length-1], "");
			jobmeta.setParameterValue("Par_ConexionesSAFI", rutaConexionesSAFIProp);
			jobmeta.setParameterValue("Par_Fecha", archPerdidaEsperadaBean.getFecha());
			jobmeta.setParameterValue("Par_RutaArchivFinalCSV", directorio+archPerdidaEsperadaBean.getNombreArchivo());
			jobmeta.setParameterValue("Par_RutaArchivoCSV", archPerdidaEsperadaBean.getRutaFinal());
			jobmeta.setParameterValue("Par_TipoReporte", archPerdidaEsperadaBean.getArchivo());
			jobmeta.setParameterValue("Par_TransaccionID", String.valueOf(numTransaccion));
			
			jobmeta.setInternalKettleVariables(job);
			jobmeta.activateParameters();
			job.shareVariablesWith(jobmeta);
			job.start();
			job.waitUntilFinished();
			ArchPerdidaEsperadaBean bean = archPerdidaEsperadaDAO.consultaPrincipal(numTransaccion, 1);
			File reporte = new File(directorio+archPerdidaEsperadaBean.getNombreArchivo()+".csv");
			if(reporte.exists()){
				if(reporte.canRead()){
					FileInputStream enviar = new FileInputStream(directorio+archPerdidaEsperadaBean.getNombreArchivo()+".csv");
					int longitud = enviar.available();
					byte[] datos = new byte[longitud];
					enviar.read(datos);
					enviar.close();
	
					response.setHeader("Content-Disposition", "attachment;filename="+ archPerdidaEsperadaBean.getNombreArchivo()+".csv");
					response.setContentType("application/text");
					ServletOutputStream outputStream = response.getOutputStream();
					outputStream.write(datos);
					outputStream.flush();
					outputStream.close();
				} else {
					mensaje.setNumero(888);
					mensaje.setDescripcion("Error al generar el reporte.");
				}
			} else {
				mensaje.setNumero(888);
				mensaje.setDescripcion("Error al generar el reporte.");
			}
			
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(888);
			mensaje.setDescripcion("Error al generar el reporte."+ex.getMessage());
		} 
		return mensaje;
	}
	
	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}
	
	public void setParamGeneralesServicio(ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public ArchPerdidaEsperadaDAO getArchPerdidaEsperadaDAO() {
		return archPerdidaEsperadaDAO;
	}

	public void setArchPerdidaEsperadaDAO(ArchPerdidaEsperadaDAO archPerdidaEsperadaDAO) {
		this.archPerdidaEsperadaDAO = archPerdidaEsperadaDAO;
	}
	
}
