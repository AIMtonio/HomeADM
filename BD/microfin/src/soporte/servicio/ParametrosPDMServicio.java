package soporte.servicio;

import soporte.bean.ParametrosPDMBean;
import soporte.dao.ParametrosPDMDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ParametrosPDMServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------
	ParametrosPDMDAO parametrosPDMDAO = null;
	
	public ParametrosPDMServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// Consulta Parametros Pademobile
	public static interface Enum_Con_ParamPDM{
		int principal   = 1;		
	}
	
	// Transaccion Parametros Pademobile
	public static interface Enum_Tra_ParamPDM{
		int modifica = 1;		
	}
	
	// Transacciones Parametros Pademobile
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,ParametrosPDMBean parametrosPDMBean) { 
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_ParamPDM.modifica:
			mensaje = parametrosPDMDAO.modificaPametrosPDM(parametrosPDMBean);
			break;
		}
		return mensaje;
	}
		
	// Consulta Parametros Pademobile
	public ParametrosPDMBean consulta(ParametrosPDMBean parametrosPDMBean, int tipoConsulta){
		ParametrosPDMBean parametrosPDMBeanCon= null;
		switch(tipoConsulta){
			case Enum_Con_ParamPDM.principal:
				parametrosPDMBeanCon = parametrosPDMDAO.consultaPrincipal(parametrosPDMBean, tipoConsulta);
			break;
					
		}
		return parametrosPDMBeanCon;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------		
	public ParametrosPDMDAO getParametrosPDMDAO() {
		return parametrosPDMDAO;
	}

	public void setParametrosPDMDAO(ParametrosPDMDAO parametrosPDMDAO) {
		this.parametrosPDMDAO = parametrosPDMDAO;
	}
		

}
