package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import pld.bean.ParamPLDOpeEfecBean;
import pld.bean.ParametrosPLDBean;
import pld.dao.ParamPLDOpeEfecDAO;
import pld.dao.ParametrosPLDDAO;

public class ParamPLDOpeEfecServicio extends BaseServicio  {
	
	ParamPLDOpeEfecDAO paramPLDOpeEfecDAO = null;
	
	public ParamPLDOpeEfecServicio() {
		
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

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParamPLDOpeEfecBean paramPLDOpeEfecBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_ParamPLD.alta:
				mensaje = paramPLDOpeEfecDAO.altaParametrosLimites(paramPLDOpeEfecBean);
			break;
			case Enum_Tra_ParamPLD.modificacion:
				mensaje = paramPLDOpeEfecDAO.modificaParametrosLimites(paramPLDOpeEfecBean);
			break;
			case Enum_Tra_ParamPLD.baja:
				mensaje = paramPLDOpeEfecDAO.bajaParametrosLimites(paramPLDOpeEfecBean);
			break;
			
		}
		return mensaje;
	}
	
	public ParamPLDOpeEfecBean consulta(ParamPLDOpeEfecBean paramPLDBean, int tipoConsulta){
		ParamPLDOpeEfecBean parametrosPLD = null;
		switch (tipoConsulta) {
			case Enum_Con_ParamPLD.principal:		
				parametrosPLD = paramPLDOpeEfecDAO.consultaPrincipal(paramPLDBean, tipoConsulta);				
				break;	
			case Enum_Con_ParamPLD.limitesExced:
				parametrosPLD = paramPLDOpeEfecDAO.consultaMontosLimite(paramPLDBean, tipoConsulta);				
				break;
			case Enum_Con_ParamPLD.porFolio:
				parametrosPLD = paramPLDOpeEfecDAO.consultaPorFolio(paramPLDBean, tipoConsulta);				
				break;	
			case Enum_Con_ParamPLD.existeFolio:
				parametrosPLD = paramPLDOpeEfecDAO.consultaExisteFolio(paramPLDBean, tipoConsulta);				
				break;	
		}
		
		return parametrosPLD;
	}

	public ParamPLDOpeEfecDAO getParamPLDOpeEfecDAO() {
		return paramPLDOpeEfecDAO;
	}

	public void setParamPLDOpeEfecDAO(ParamPLDOpeEfecDAO paramPLDOpeEfecDAO) {
		this.paramPLDOpeEfecDAO = paramPLDOpeEfecDAO;
	}

}
