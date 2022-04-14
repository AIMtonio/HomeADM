package bancaMovil.servicio;

import org.springframework.core.task.TaskExecutor;

import bancaMovil.bean.BAMEnviaCorreoBean;
import general.servicio.BaseServicio;
import soporte.servicio.CorreoServicio;

public class BAMNotificacionCorreoServicio extends BaseServicio{

	TaskExecutor taskExecutor;
	CorreoServicio correoServicio = null;
	BAMParametrosServicio parametrosServicio=null;
	

	BAMNotificacionCorreoServicio notificacion=null;
	

	public static interface Enum_Tipo_OperacionesBM {
		String 	inicioSesion 		= "I"; 			//Inicio de Session
		String 	transferencia		= "T";			// Tranferencia entre cuentas
		String	pagoServicio		= "S";			//Pago de Servicios
		String	altaServicio		= "A";			//Alta del Servicio de Banca Movil
		String  cambioSeguridad 	= "C";
	}
	//---------- Constructor ------------------------------------------------------------------------
	public BAMNotificacionCorreoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	//Prepara para enviar una notificacion 
	public void enviaCorreoNotificacion(BAMEnviaCorreoBean correoBean){		
		final String ruta =(String) parametrosServicio.consulta(BAMParametrosServicio.Enum_Con_Parametros.rutaKtr);
		try{
				taskExecutor.execute(new Runnable() {
					public void run() {
						correoServicio.enviarCorreo(ruta);
					}
				});
			}catch(Exception e){
				loggerSAFI.info(this.getClass()+" - "+e.getMessage());
			}		
	}	

	
	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}
	

	public TaskExecutor getTaskExecutor() {
		return taskExecutor;
	}

	public void setTaskExecutor(TaskExecutor taskExecutor) {
		this.taskExecutor = taskExecutor;
	}

	public BAMParametrosServicio getParametrosServicio() {
		return parametrosServicio;
	}

	public void setParametrosServicio(BAMParametrosServicio parametrosServicio) {
		this.parametrosServicio = parametrosServicio;
	}
}
