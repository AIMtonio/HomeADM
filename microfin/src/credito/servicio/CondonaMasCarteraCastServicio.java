package credito.servicio;

import org.pentaho.di.core.KettleEnvironment;
import org.pentaho.di.job.Job;
import org.pentaho.di.job.JobMeta;

import credito.bean.CreditosBean;
import credito.dao.CondonaMasCarteraCastDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import soporte.bean.ParamGeneralesBean;
import soporte.dao.ParamGeneralesDAO.Enum_Con_ParamGenerales;
import soporte.servicio.ParamGeneralesServicio;

public class CondonaMasCarteraCastServicio extends BaseServicio {
	
	ParamGeneralesServicio paramGeneralesServicio = null;
	CondonaMasCarteraCastDAO condonaMasCarteraCastDAO = null;

	private CondonaMasCarteraCastServicio(){
		super();
	}
	
	public MensajeTransaccionBean ejecutaKTR(final CreditosBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
			
			// Se obtiene el KTR a ejecutar
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.KTRCondonacionMasiva, paramGeneralesBean);
			if (paramGeneralesBean == null || paramGeneralesBean.getValorParametro() ==null || paramGeneralesBean.getValorParametro().trim() == "") {
				throw new Exception("Error. No se encuentra parametrizado la ruta del archivo JOB en PARAMGENERALES con llave \"CondonaMasivoKTR\".");
			}
			final String file = paramGeneralesBean.getValorParametro();
			paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.RutaPropConexionesSAFI, paramGeneralesBean);
			if(paramGeneralesBean==null||paramGeneralesBean.getValorParametro() ==null || paramGeneralesBean.getValorParametro().trim()==""){
				throw new Exception("Error. No se encuentra parametrizado la ruta del properties RutaPropConexionesSAFI en PARAMGENERALES con llave \"RutaPropConexionesSAFI\".");
			}
			final String rutaConexionesSAFIProp = paramGeneralesBean.getValorParametro();
			long numTransaccion = paramGeneralesServicio.getParamGeneralesDAO().getNumTransaccion();
			loggerSAFI.info("Numero de Transaccion:"+numTransaccion);
			loggerSAFI.info("Ruta KTR:"+ file);
			loggerSAFI.info("Ruta properties:"+rutaConexionesSAFIProp);
			mensaje = ejecKTR(1,file,rutaConexionesSAFIProp, bean,numTransaccion);
			if(mensaje.getNumero()!=0) {
				return mensaje;
			}
			CreditosBean bean2 = new CreditosBean();
			bean2.setNumTransaccion(String.valueOf(numTransaccion));
			bean2.setFechaCondona(bean.getFechaCondona());
			
			mensaje = condonaMasCarteraCastDAO.condonacionMasiva(bean2);
			if(mensaje.getNumero()!=0) {
				return mensaje;
			}
			
		}catch(Exception ex) {
			ex.printStackTrace();
			if(mensaje!=null) {
				mensaje=new MensajeTransaccionBean();
			}
			if(mensaje.getNumero()==0) {
				mensaje.setNumero(888);
			}
			mensaje.setDescripcion(ex.getMessage());
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean ejecKTR(int tipoArchivo, String file, String rutaConexionesSAFIProp, CreditosBean bean, long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			KettleEnvironment.init();
			JobMeta jobmeta = new JobMeta(file, null);
			Job job = new Job(null, jobmeta);
			
			jobmeta.setParameterValue("Par_ConexionesSAFI", rutaConexionesSAFIProp);
			jobmeta.setParameterValue("Par_Fecha", bean.getFechaCondona());
			jobmeta.setParameterValue("Par_RutaExcel", bean.getRutaArchivoFinal());
			jobmeta.setParameterValue("Par_TipoReporte", String.valueOf(tipoArchivo));
			jobmeta.setParameterValue("Par_TransaccionID", String.valueOf(numTransaccion));
			
			jobmeta.setInternalKettleVariables(job);
			jobmeta.activateParameters();
			job.shareVariablesWith(jobmeta);
			job.start();
			job.waitUntilFinished();
			
			if (job.getErrors() != 0) {
				throw new Exception("Error en la ejecución del Proceso.");
			}
			mensaje.setNumero(0);
			mensaje.setDescripcion("Proceso realizado exitosamente.");
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(888);
			if(mensaje.getDescripcion()==null || mensaje.getDescripcion().isEmpty()) {
				mensaje.setDescripcion("Error al ejecutar el proceso KTR para el Archivo. " + ex.getMessage());
			}
		}
		return mensaje;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public CondonaMasCarteraCastDAO getCondonaMasCarteraCastDAO() {
		return condonaMasCarteraCastDAO;
	}

	public void setCondonaMasCarteraCastDAO(CondonaMasCarteraCastDAO condonaMasCarteraCastDAO) {
		this.condonaMasCarteraCastDAO = condonaMasCarteraCastDAO;
	}

}
