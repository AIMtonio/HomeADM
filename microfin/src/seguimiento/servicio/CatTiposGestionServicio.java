package seguimiento.servicio;

import java.util.List;

import seguimiento.bean.CatTiposGestionBean;
import seguimiento.dao.CatTiposGestionDAO;
import seguimiento.servicio.CategoriaSegtoServicio.Enum_Lis_Categ;
import seguimiento.servicio.RegistroGestorServicio.Enum_Lis_Gestor;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CatTiposGestionServicio extends BaseServicio{
	
	CatTiposGestionDAO catTiposGestionDAO = null;
	
	public CatTiposGestionServicio(){
		super();
	}

	public static interface Enum_Tra_TipoGestion {
		int alta			= 1;
		int modificacion	= 2;	
	}
	
	public static interface Enum_Con_TipoGestion{
		int principal	= 1;
		int foranea		= 2;
	}
	
	public static interface Enum_Lis_TipoGestion {
		int principal	= 1;	
		int comboGestion = 2;
		int tipoGestores = 3;
		int supervisor	= 4;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CatTiposGestionBean catTiposGestoresBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
	    	case Enum_Tra_TipoGestion.alta:
	    		mensaje = catTiposGestionDAO.altaTiposGestor(tipoTransaccion,catTiposGestoresBean);
	    		break;
	        case Enum_Tra_TipoGestion.modificacion:
	        	mensaje = catTiposGestionDAO.modificaTiposGestor(catTiposGestoresBean);
			break;
		}
		return mensaje;
	}
	
	public CatTiposGestionBean consulta(int tipoConsulta, CatTiposGestionBean catTiposGestoresBean){
		CatTiposGestionBean tiposGestores = null;
		switch(tipoConsulta){
			case Enum_Con_TipoGestion.foranea:
				tiposGestores = catTiposGestionDAO.consulta(Enum_Con_TipoGestion.foranea, catTiposGestoresBean);
			break;	
		}
		return tiposGestores;
	}
	
	public List lista(int tipoLista, CatTiposGestionBean catTiposGestoresBean){
		List listaTipoGestion = null;
		switch (tipoLista) {
	        case  Enum_Lis_TipoGestion.principal:
	        	listaTipoGestion = catTiposGestionDAO.listaPrincipal(catTiposGestoresBean, tipoLista);
	        break;
	        case  Enum_Lis_TipoGestion.tipoGestores:
	        	listaTipoGestion = catTiposGestionDAO.listaTipoGestores(catTiposGestoresBean, tipoLista);
	        break;
	        case  Enum_Lis_TipoGestion.supervisor:
	        	listaTipoGestion = catTiposGestionDAO.listaSupervisor(catTiposGestoresBean, tipoLista);
	        break;
		}
		return listaTipoGestion;
	}
	
    // listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaTipoGestion = null;
		switch(tipoLista){
			case (Enum_Lis_TipoGestion.comboGestion):
				listaTipoGestion = catTiposGestionDAO.tipoGestionCombo(tipoLista);
				break;
		}
		return listaTipoGestion.toArray();
	}

	public CatTiposGestionDAO getCatTiposGestionDAO() {
		return catTiposGestionDAO;
	}

	public void setCatTiposGestionDAO(CatTiposGestionDAO catTiposGestionDAO) {
		this.catTiposGestionDAO = catTiposGestionDAO;
	}
}