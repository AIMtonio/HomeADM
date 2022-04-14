package aportaciones.servicio;

import general.bean.MensajeTransaccionBean;

import java.util.List;


import aportaciones.bean.TiposAportacionesBean;
import aportaciones.dao.TiposAportacionesDAO;
import aportaciones.servicio.AportacionesServicio.Enum_Lis_Aportaciones;

 public class TiposAportacionesServicio {
	
	private TiposAportacionesServicio(){
		super();
	}

	TiposAportacionesDAO tiposAportacionesDAO = null;
	
	public static interface Enum_Tra_TiposAportaciones{
		int alta			= 1;
		int modificacion	= 2;
	}
	
	public static interface Enum_Con_TipoAportaciones {
		int principal = 1;
		int general		=2;
	}
	
	public static interface Enum_Lis_TipoAportaciones{
		int principal	=1;
	}

	
	public static interface Enum_Lis_TiposAportaciones{
		int listaPrincipal 	= 1;
		int comboTiposAportaciones = 2;
	}
		
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TiposAportacionesBean tiposAportacionesBean){
		
		MensajeTransaccionBean mensaje = null;
		
		switch(tipoTransaccion){
			case (Enum_Tra_TiposAportaciones.alta):
					mensaje = tiposAportacionesDAO.alta(tiposAportacionesBean);
				break;
			case (Enum_Tra_TiposAportaciones.modificacion):
					mensaje = tiposAportacionesDAO.modifica(tiposAportacionesBean);
				break;
		}

		
		return mensaje;
		
	}
	
	
	public TiposAportacionesBean consulta(int tipoConsulta, TiposAportacionesBean tiposAportacionesBean){
		TiposAportacionesBean tiposAportaciones = null;
		
		switch(tipoConsulta){
			 case (Enum_Con_TipoAportaciones.principal):
				 tiposAportaciones = tiposAportacionesDAO.consultaPrincipal(tiposAportacionesBean, tipoConsulta);
			 		break;
			 case (Enum_Con_TipoAportaciones.general):
				 tiposAportaciones = tiposAportacionesDAO.consultaGeneral(tiposAportacionesBean, tipoConsulta);
			 		break;
			
		}
		return tiposAportaciones;		
	}
	
	
	public List lista(int tipoLista, TiposAportacionesBean tiposAportacionesBean){		
		List listaTiposAportaciones = null;
		switch (tipoLista) {
			case Enum_Lis_Aportaciones.principal:		
				listaTiposAportaciones = tiposAportacionesDAO.listaPrincipal(tiposAportacionesBean, tipoLista);				
				break;				
		}
		return listaTiposAportaciones;
	}
	
	// listas para comboBox
		public  Object[] listaCombo(int tipoLista) {
			List listaTiposAportaciones = null;
			switch(tipoLista){
				case (Enum_Lis_TiposAportaciones.comboTiposAportaciones): 
					listaTiposAportaciones =  tiposAportacionesDAO.listaAportaciones(tipoLista);
					break;
			}
			return listaTiposAportaciones.toArray();		
		}


		public TiposAportacionesDAO getTiposAportacionesDAO() {
			return tiposAportacionesDAO;
		}


		public void setTiposAportacionesDAO(TiposAportacionesDAO tiposAportacionesDAO) {
			this.tiposAportacionesDAO = tiposAportacionesDAO;
		}
		
	
}
