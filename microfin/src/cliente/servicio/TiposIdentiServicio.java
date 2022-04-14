package cliente.servicio;

import java.util.List;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cliente.dao.TiposIdentiDAO;
import cliente.servicio.TiposDireccionServicio.Enum_Con_TiposDir;
import cliente.bean.TiposIdentiBean;
public class TiposIdentiServicio extends BaseServicio {

	

	TiposIdentiDAO tiposIdentiDAO = null;


	public static interface Enum_Con_TiposIdenti{
		int principal = 1;
		int foranea	  = 2;
		int tident	  =	3;
	}

	public static interface Enum_Lis_TiposIdenti{
		int principal = 1;

	}
	private TiposIdentiServicio(){
		super();
	}


	public TiposIdentiBean consulta(int tipoConsulta, String tipoIdentiID){
		TiposIdentiBean tiposIdenti = null;
		switch (tipoConsulta) {
			case Enum_Con_TiposIdenti.principal:	
				tiposIdenti = tiposIdentiDAO.consultaPrincipal(Integer.parseInt(tipoIdentiID), Enum_Con_TiposIdenti.principal);
			break;
			case Enum_Con_TiposIdenti.foranea:	
				tiposIdenti = tiposIdentiDAO.consultaForanea(Integer.parseInt(tipoIdentiID), Enum_Con_TiposIdenti.foranea);
			break;
			}	
		return tiposIdenti;
	}
	
	

	public List lista(int tipoLista, TiposIdentiBean tiposIdenti){

		List listatiposIdenti = null;

		switch (tipoLista) {
		case Enum_Lis_TiposIdenti.principal:
			listatiposIdenti = tiposIdentiDAO.listaTiposIdenti(tiposIdenti, tipoLista);
			break;
		}
		return listatiposIdenti;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoConsulta) {
		
		List listaTident = null;
		
		switch(tipoConsulta){
			case (Enum_Con_TiposIdenti.tident): 
				listaTident =  tiposIdentiDAO.listaTiposIdentifC(tipoConsulta);
				break;
			
		}
		
		return listaTident.toArray();		
	}
	
	
	//------------------ Geters y Seters ------------------------------------------------------	

	public void setTiposIdentiDAO(TiposIdentiDAO tiposIdentiDAO ){
		this.tiposIdentiDAO = tiposIdentiDAO;
	}

}
