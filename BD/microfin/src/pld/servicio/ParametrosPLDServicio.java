package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import pld.bean.ParametrosPLDBean;
import pld.dao.ParametrosPLDDAO;

public class ParametrosPLDServicio extends BaseServicio  {
	
	ParametrosPLDDAO parametrosPLDDAO = null;
	
	public ParametrosPLDServicio() {
		
	}

	//---------- Tipo de Transaccion ----------------	
	public static interface Enum_Tra_ParamPLD {
		int alta 			= 1;
		int modificacion	= 2;
		int baja			= 3;
	}
	
	//---------- Tipo de Consulta ----------------	
	public static interface Enum_Con_ParamPLD {
		int principal 		= 1;
		int limitesExced	= 2;
		int porFolio		= 3;
		int existeFolio		= 4;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosPLDBean parametrosPLDBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_ParamPLD.alta:
				mensaje = parametrosPLDDAO.altaParametrosLimites(parametrosPLDBean);
			break;
			case Enum_Tra_ParamPLD.modificacion:
				mensaje = parametrosPLDDAO.modificaParametrosLimites(parametrosPLDBean);
			break;
			case Enum_Tra_ParamPLD.baja:
				mensaje = parametrosPLDDAO.bajaParametrosLimites(parametrosPLDBean);
			break;
			
		}
		return mensaje;
	}
	
	public ParametrosPLDBean consulta(ParametrosPLDBean paramPLDBean, int tipoConsulta){
		ParametrosPLDBean parametrosPLD = null;
		switch (tipoConsulta) {
			case Enum_Con_ParamPLD.principal:		
				parametrosPLD = parametrosPLDDAO.consultaPrincipal(paramPLDBean, tipoConsulta);				
				break;	
			case Enum_Con_ParamPLD.limitesExced:
				parametrosPLD = parametrosPLDDAO.consultaMontosLimite(paramPLDBean, tipoConsulta);				
				break;
			case Enum_Con_ParamPLD.porFolio:
				parametrosPLD = parametrosPLDDAO.consultaPorFolio(paramPLDBean, tipoConsulta);				
				break;	
			case Enum_Con_ParamPLD.existeFolio:
				parametrosPLD = parametrosPLDDAO.consultaExisteFolio(paramPLDBean, tipoConsulta);				
				break;	
		}
		
		return parametrosPLD;
	}

	public ParametrosPLDDAO getParametrosPLDDAO() {
		return parametrosPLDDAO;
	}

	public void setParametrosPLDDAO(ParametrosPLDDAO parametrosPLDDAO) {
		this.parametrosPLDDAO = parametrosPLDDAO;
	}

}
