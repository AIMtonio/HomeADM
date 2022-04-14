package soporte.servicio;
  
import soporte.bean.ParamGeneralesBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import soporte.dao.ParamGeneralesDAO;

public class ParamGeneralesServicio extends BaseServicio {
	
	public static interface Enum_Act_ParamGenerales {
		int EjecucionBalanzaContableSI = 9;
		int EjecucionBalanzaContableNO = 10;
	}
	
	public static interface Enum_Con_ParamGenerales {
		int ConCteEspecifico = 13;
	}
	
	/* Declaracion de Variables */
	ParamGeneralesDAO paramGeneralesDAO = null;

	public ParamGeneralesServicio() {
		super();
	}


	/* consulta los parametros de caja */
	public ParamGeneralesBean consulta(int tipoConsulta,ParamGeneralesBean paramGeneralesBean){						
		ParamGeneralesBean paramGeneralesConBean = null;	
		paramGeneralesConBean = paramGeneralesDAO.consultaPrincipal(paramGeneralesBean,tipoConsulta);					
		return paramGeneralesConBean;
	}

	/**
	 * Actualización de Parámetro en PARAMGENERALES.
	 * @param tipoAct Número de Actualización.
	 * @param paramGeneralesBean {@linkplain ParamGeneralesBean} con los valores de entrada al SP-PARAMGENERALESACT.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la trasacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean actualizacion(int tipoAct, ParamGeneralesBean paramGeneralesBean){						
		MensajeTransaccionBean mensaje = null;	
				mensaje = paramGeneralesDAO.actualiza(paramGeneralesBean,tipoAct);					
		return mensaje;
	}

	public MensajeTransaccionBean ejecucionBalanzaContable(int tipoOperacion, ParamGeneralesBean paramGeneralesBean){						
		MensajeTransaccionBean mensajeTransaccionBean = null;				
		
		try{
			String nombreUsuario = paramGeneralesBean.getValorParametro();
 			paramGeneralesBean.setLlaveParametro("EjecucionBalanzaContable");		
			
			switch(tipoOperacion){
				case Enum_Act_ParamGenerales.EjecucionBalanzaContableSI:
					paramGeneralesBean.setValorParametro(Constantes.STRING_SI);
				break;
				case Enum_Act_ParamGenerales.EjecucionBalanzaContableNO:
					paramGeneralesBean.setValorParametro(Constantes.STRING_NO);
				break;
			}
			
			// Actualizo la Bandera de Ejecucion
			mensajeTransaccionBean = actualizacion(tipoOperacion, paramGeneralesBean);
			if(mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO) {
				throw new Exception(mensajeTransaccionBean.getNumero() + " - " + mensajeTransaccionBean.getDescripcion());
			}
	
			paramGeneralesBean.setLlaveParametro("UserEjecucionBalanzaContable");
			switch(tipoOperacion){
				case Enum_Act_ParamGenerales.EjecucionBalanzaContableSI:
					paramGeneralesBean.setValorParametro(nombreUsuario);
				break;
				case Enum_Act_ParamGenerales.EjecucionBalanzaContableNO:
					paramGeneralesBean.setValorParametro(Constantes.STRING_VACIO);
				break;
			}
			
			// Actualizo el usuario de Ejecucion
			mensajeTransaccionBean = actualizacion(tipoOperacion, paramGeneralesBean);
			if(mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO) {
				throw new Exception(mensajeTransaccionBean.getNumero() + " - " + mensajeTransaccionBean.getDescripcion());
			}

		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("Error en la Actualización del Parámetro de Ejecución de Balanza Contable: " + exception);
		}
		
		return mensajeTransaccionBean;
	}

	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}

	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}
		
}	//fin de la clase
