package cliente.servicio;

import java.util.ArrayList;
import java.util.List;

import cliente.bean.ConvencionSeccionalBean;
import cliente.dao.ConvencionSeccionalDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ConvencionSeccionalServicio extends BaseServicio{
	
	ConvencionSeccionalDAO convencionSeccionalDAO = null;
	
	public ConvencionSeccionalServicio(){
		super();
	}
	
	public static interface Enum_Tra_ConvencionSeccional {
		int graba	=1;
	}
	
	public static interface Enum_Lis_ConvencionSeccional{
		int listaGridConvencionSecional = 1;
		int listaComboGral				= 2;
		int listaComboSecc              = 3;
		int lisComSucuGral		        = 4;
		int lisComSucuSecc		        = 5;
	}
	
	public static interface Enum_Con_ConvencionSeccional{
		int principal = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConvencionSeccionalBean convencionSeccionalBean){
		ArrayList listaConvencionSeccional = (ArrayList) creaListaDetalle(convencionSeccionalBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch(tipoTransaccion){		
	    	case Enum_Tra_ConvencionSeccional.graba:
	    		mensaje = convencionSeccionalDAO.grabaConvencionSeccional(convencionSeccionalBean, listaConvencionSeccional);
	    		break;
		}
		return mensaje;
	}
	
	public List creaListaDetalle(ConvencionSeccionalBean bean) {
		
		List<String> sucursalID  = bean.getLsucursalID();
		List<String> fecha  = bean.getLfecha();
		List<String> cantSocio  = bean.getLcantSocio();
		List<String> esGral  = bean.getLesGral();
		

		ArrayList listaDetalle = new ArrayList();
		ConvencionSeccionalBean convenSeccional = null;	
		
		if(sucursalID != null){
			int tamanio = sucursalID.size();			
			for (int i = 0; i < tamanio; i++) {
				convenSeccional = new ConvencionSeccionalBean();
				convenSeccional.setSucursalID(sucursalID.get(i));
				convenSeccional.setFecha(fecha.get(i));
				convenSeccional.setCantSocio(cantSocio.get(i));
				convenSeccional.setEsGral(esGral.get(i));
				listaDetalle.add(convenSeccional);
			}
		}
		return listaDetalle;		
	}
	
	public List lista(int tipoLista, ConvencionSeccionalBean convencionSeccionalBean){		
		List convencionSeccional = null;
		switch (tipoLista) {	
			case Enum_Lis_ConvencionSeccional.listaGridConvencionSecional:		
				convencionSeccional = convencionSeccionalDAO.listaGridConvencionSecional(convencionSeccionalBean, tipoLista);			
				break;			 
		}

		return convencionSeccional;
		}
	
	public List listaCombo(int tipoLista, ConvencionSeccionalBean convencionSeccionalBean){		
		List convencionSeccional = null;
		switch (tipoLista) {	
			case Enum_Lis_ConvencionSeccional.listaComboGral:		
				convencionSeccional = convencionSeccionalDAO.listaComboGral(convencionSeccionalBean, tipoLista);			
				break;	
			case Enum_Lis_ConvencionSeccional.listaComboSecc:		
				convencionSeccional = convencionSeccionalDAO.listaComboSecc(convencionSeccionalBean, tipoLista);			
				break;
			case Enum_Lis_ConvencionSeccional.lisComSucuGral:		
				convencionSeccional = convencionSeccionalDAO.lisComSucuGral(convencionSeccionalBean, tipoLista);			
				break;
			case Enum_Lis_ConvencionSeccional.lisComSucuSecc:		
				convencionSeccional = convencionSeccionalDAO.lisComSucuSecc(convencionSeccionalBean, tipoLista);			
				break;
		}

		return convencionSeccional;
		}

	public ConvencionSeccionalBean consulta(int tipoConsulta, ConvencionSeccionalBean convencionSeccional){
		ConvencionSeccionalBean convencionSeccionalBean = null;
		switch (tipoConsulta) {
		
			case Enum_Con_ConvencionSeccional.principal:		
				convencionSeccionalBean = convencionSeccionalDAO.consultaPrincipal(convencionSeccional, tipoConsulta);				
				break;	
	
		}
				
		return convencionSeccionalBean;
	}
	
	// --------------------getter y setter---------------------
	public ConvencionSeccionalDAO getConvencionSeccionalDAO() {
		return convencionSeccionalDAO;
	}

	public void setConvencionSeccionalDAO(
			ConvencionSeccionalDAO convencionSeccionalDAO) {
		this.convencionSeccionalDAO = convencionSeccionalDAO;
	}
	

}
