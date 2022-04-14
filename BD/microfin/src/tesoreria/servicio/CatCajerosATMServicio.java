package tesoreria.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import tesoreria.bean.CatCajerosATMBean;
import tesoreria.bean.CatTipoCajeroBean;
import tesoreria.dao.CatCajerosATMDAO;
import general.bean.MensajeTransaccionBean;

public class CatCajerosATMServicio extends BaseServicio {
	CatCajerosATMDAO catCajerosATMDAO = null;
	
	private CatCajerosATMServicio(){
		super();
	}
	public static interface Enum_Tra_CatCajerosATM{
		int alta					= 1;
		int modificacion			= 2;		
	}
	
	public static interface Enum_Act_CatCajerosATM {
		int cancelacion 		= 3;
	}
	public static interface Enum_Lis_CatCajerosATM{
		int listaPrincipalCajeros      = 1;
		int listaPorUsuario     = 2;
	}
	public static interface Enum_Con_CatCajerosATM{
		int consultaPrincipal      = 1;
	}
	
	

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CatCajerosATMBean catCajerosATMBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){		
	    	case Enum_Tra_CatCajerosATM.alta:
	    		mensaje = catCajerosATMDAO.altaCajeroATM(catCajerosATMBean);
	    		break;
	    	case Enum_Tra_CatCajerosATM.modificacion:
				mensaje = catCajerosATMDAO.modificaCajeroATM(catCajerosATMBean);
				break;
	    	case Enum_Act_CatCajerosATM.cancelacion:
	    		mensaje=catCajerosATMDAO.cancelarCajeroATM(catCajerosATMBean,tipoActualizacion);
		}
		return mensaje;
	}
	
	

	public CatCajerosATMBean consulta(int tipoConsulta, CatCajerosATMBean catCajerosATMBean){
		CatCajerosATMBean catCajerosATM = null;
		switch (tipoConsulta) {
			case  Enum_Con_CatCajerosATM.consultaPrincipal:
				catCajerosATM = catCajerosATMDAO.consultaPrincipal(catCajerosATMBean,tipoConsulta);
				break;				
		}
		return catCajerosATM;
	}
	
	public List lista(int tipoLista, CatCajerosATMBean catCajerosATMBean){		
		List listaCajerosATM = null;
		switch (tipoLista) {
		case Enum_Lis_CatCajerosATM.listaPrincipalCajeros:		
			listaCajerosATM = catCajerosATMDAO.listaCajerosATM(tipoLista,catCajerosATMBean);				
			break;		
		case Enum_Lis_CatCajerosATM.listaPorUsuario:		
			listaCajerosATM = catCajerosATMDAO.listaForaneaATM(tipoLista,catCajerosATMBean);				
			break;
		}		
		return listaCajerosATM;
	}	
	
	public List listaTiposCajerosATM(int tipoLista){
		CatTipoCajeroBean catTipoCajeroBean = new CatTipoCajeroBean();
		List listaTiposCajerosATM  = catCajerosATMDAO.listaTipoCajerosATM(tipoLista, catTipoCajeroBean);
		return listaTiposCajerosATM;
	}
	
	
	//------------------------------------getter y setter------------------
	public CatCajerosATMDAO getCatCajerosATMDAO() {
		return catCajerosATMDAO;
	}

	
	public void setCatCajerosATMDAO(CatCajerosATMDAO catCajerosATMDAO) {
		this.catCajerosATMDAO = catCajerosATMDAO;
	}
	
	
	
}
