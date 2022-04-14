package inversiones.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import inversiones.bean.TipoInversionBean;
import inversiones.dao.TipoInversionesDAO;

import java.util.List;

public class TipoInversionesServicio extends BaseServicio {
	
	private TipoInversionesServicio(){
		super();
	}
	
	TipoInversionesDAO tipoInversionesDAO = null;
	
	
	public static interface Enum_Tra_TipoInversion {
		int alta = 1;
		int modificacion = 2;
	}
	
	public static interface Enum_Con_TipoInversion {
		int principal = 1;
		int foranea = 2;
		int general = 3;
	}
	
	public static interface Enum_Lis_TipoInversion {
		int principal = 1;
		int foranea = 2;
		int general = 3;
		int porMoneda = 4;
		int lis_tiposInverAct = 5;			//Lista Tipos Inversiones activos
		int comboTiposInverAct = 6;		//Lista Combo de los Tipos Inversiones activos
	}

	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TipoInversionBean tipoInversionBean){
		
		MensajeTransaccionBean mensaje = null;
		
		switch(tipoTransaccion){
			case (Enum_Tra_TipoInversion.alta):
					mensaje = tipoInversionesDAO.alta(tipoInversionBean);
				break;
			case (Enum_Tra_TipoInversion.modificacion):
					mensaje = tipoInversionesDAO.modificaTipoInvercion(tipoInversionBean);
				break;
		}

		
		return mensaje;
		
	}
	
	public TipoInversionBean consultaPrincipal(int tipoConsulta, TipoInversionBean tipoInversion){
		TipoInversionBean tipoInversionBean = null;
		
		switch(tipoConsulta){
			 case (Enum_Con_TipoInversion.principal):
				 tipoInversionBean = tipoInversionesDAO.consultaPrincipal(tipoInversion, tipoConsulta);
			 		break;
			 case (Enum_Con_TipoInversion.foranea):
				 tipoInversionBean = tipoInversionesDAO.consultaForanea(tipoInversion, tipoConsulta);
				 break;
			 case (Enum_Con_TipoInversion.general):
				 tipoInversionBean = tipoInversionesDAO.consultaGeneral(tipoInversion, tipoConsulta);
				 break;
			
		}
		return tipoInversionBean;		
	}
			
		
	public List lista(int tipoLista, TipoInversionBean tipoInversionBean){
		List listaTipoInversion = null;

		switch (tipoLista) {
			case Enum_Lis_TipoInversion.principal:
			case Enum_Lis_TipoInversion.lis_tiposInverAct:
				listaTipoInversion = tipoInversionesDAO.listaPrincipal(tipoInversionBean, tipoLista);				
				break;
			case Enum_Lis_TipoInversion.foranea:
				listaTipoInversion = tipoInversionesDAO.listaForanea(tipoInversionBean, tipoLista);				
				break;				
		}				
		
		return listaTipoInversion;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista, TipoInversionBean tipoInversionBean) {
		List listaTipoInversion = null;
		switch(tipoLista){
			case (Enum_Lis_TipoInversion.general): 
			case (Enum_Lis_TipoInversion.comboTiposInverAct): 
				listaTipoInversion =  tipoInversionesDAO.listaGeneral(tipoInversionBean, tipoLista);
				break;
			case (Enum_Lis_TipoInversion.porMoneda): 
				listaTipoInversion =  tipoInversionesDAO.listaPormoneda(tipoInversionBean, tipoLista);
				break;				
		}
		return listaTipoInversion.toArray();		
	}
	
	

	public void setTipoInversionesDAO(TipoInversionesDAO tipoInversionesDAO) {
		this.tipoInversionesDAO = tipoInversionesDAO;
	}
	

}
