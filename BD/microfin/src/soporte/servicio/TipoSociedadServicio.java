package soporte.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import soporte.bean.TipoSociedadBean;
import soporte.dao.TipoSociedadDAO;



public class TipoSociedadServicio extends BaseServicio {

	TipoSociedadDAO tipoSociedadDAO = null;


	public static interface Enum_Con_TiposSoc{
		int principal = 1;
		int foranea	  = 2;
		int tident	  =	3;
	}

	public static interface Enum_Lis_TiposSoc{
		int principal = 1;

	}
	private TipoSociedadServicio(){
		super();
	}


	public TipoSociedadBean consulta(int tipoConsulta, TipoSociedadBean sociedadBean){
		TipoSociedadBean sociedad = null;
		switch (tipoConsulta) {
			case Enum_Con_TiposSoc.principal:	
				sociedad = tipoSociedadDAO.consultaPrincipal(sociedadBean, Enum_Con_TiposSoc.principal);
			break;
			case Enum_Con_TiposSoc.foranea:	
				sociedad = tipoSociedadDAO.consultaForanea(sociedadBean, Enum_Con_TiposSoc.foranea);
			break;
			}	
		return sociedad;
	}
	
	

	public List lista(int tipoLista, TipoSociedadBean sociedadBean){

		List listatiposSociedad = null;

		switch (tipoLista) {
		case Enum_Lis_TiposSoc.principal:
			listatiposSociedad = tipoSociedadDAO.listaTiposSociedad(sociedadBean, tipoLista);
			break;
		}
		return listatiposSociedad;
	}


	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setTipoSociedadDAO(TipoSociedadDAO tipoSociedadDAO) {
		this.tipoSociedadDAO = tipoSociedadDAO;
	}

	

}
