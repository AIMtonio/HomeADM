package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.util.List;

import org.springframework.core.task.TaskExecutor;

import pld.bean.PLDListasPersBloqBean;
import pld.dao.PLDListasPersBloqDAO;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.CorreoServicio;
import soporte.servicio.ParamGeneralesServicio;


public class PLDListasPersBloqServicio extends BaseServicio {
	
	PLDListasPersBloqDAO pldListasPersBloqDAO = null;
	TaskExecutor taskExecutor = null;
	CorreoServicio correoServicio = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	
	public static interface Enum_Tra_ListasPersBloq {
		int alta   = 1;
		int modificacion =2;
	}
	
	public static interface Enum_Con_ListasPersBloq {
		int principal   = 1;
		int bloqueo		= 2;
		int datosLevenshtein = 3;
		int datosLevMasivo	 = 4;
	}
	
	public static interface Enum_Lis_ListasPersBloq {
		int principal   = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PLDListasPersBloqBean PLDListasPersBloqBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_ListasPersBloq.alta:
				mensaje = pldListasPersBloqDAO.alta(PLDListasPersBloqBean, tipoTransaccion);
			break;
			case Enum_Tra_ListasPersBloq.modificacion:
				mensaje = pldListasPersBloqDAO.modificacion(PLDListasPersBloqBean);
			break;
			
		}
		return mensaje;
	}
	
	public PLDListasPersBloqBean consulta(int tipoConsulta, PLDListasPersBloqBean PLDListasPersBloqBean){
		PLDListasPersBloqBean pldListaPersB = null;
		switch(tipoConsulta){
			case Enum_Con_ListasPersBloq.principal:
				pldListaPersB = pldListasPersBloqDAO.consultaPrincipal(PLDListasPersBloqBean, tipoConsulta);
			break;				
			case Enum_Con_ListasPersBloq.bloqueo:
				pldListaPersB = pldListasPersBloqDAO.consultaEstaBloq(PLDListasPersBloqBean, tipoConsulta);

				// Si se detecta en lista de pers bloqueadas, se hace el envio de correo al Oficial de Cumplimiento
				if(pldListaPersB.getEstaBloqueado().equalsIgnoreCase(Constantes.STRING_SI)){
					EjecutaEnvioCorreo();
				}
			break;				
		}
		return pldListaPersB;
	}
	
	public List lista(int tipoLista, PLDListasPersBloqBean PLDListasPersBloqBean){		
		List listaNegra = null;
		switch (tipoLista) {
			case Enum_Lis_ListasPersBloq.principal:		
				listaNegra=  pldListasPersBloqDAO.listaPrincipal( Enum_Lis_ListasPersBloq.principal, PLDListasPersBloqBean);				
				break;
		}		
		return listaNegra;
	}

	/**
	 * Ejecuta mediante un taskEjecutor el envio de correo por ktr.
	 */
	public void EjecutaEnvioCorreo(){
		// Tipo de consulta 3 para obtener la ruta de EnvioCorreo.ktr
		int tipoConParam = correoServicio.RutaCorreoKTR;

		ParamGeneralesBean	paramGeneralesBean = new ParamGeneralesBean();
		paramGeneralesBean = paramGeneralesServicio.consulta(tipoConParam, paramGeneralesBean);

		final String ruta=paramGeneralesBean.getValorParametro();

		taskExecutor.execute(new Runnable() {
			public void run() {
				correoServicio.enviarCorreo(ruta);
			}
		});
	}
	
	public PLDListasPersBloqDAO getPldListasPersBloqDAO() {
		return pldListasPersBloqDAO;
	}
	
	public void setPldListasPersBloqDAO(PLDListasPersBloqDAO pldListasPersBloqDAO) {
		this.pldListasPersBloqDAO = pldListasPersBloqDAO;
	}

	public TaskExecutor getTaskExecutor() {
		return taskExecutor;
	}

	public void setTaskExecutor(TaskExecutor taskExecutor) {
		this.taskExecutor = taskExecutor;
	}

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}
}
