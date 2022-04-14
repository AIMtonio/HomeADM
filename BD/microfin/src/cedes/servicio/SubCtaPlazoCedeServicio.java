package cedes.servicio;

import java.util.List;

import cedes.bean.SubCtaPlazoCedeBean;
import cedes.dao.SubCtaPlazoCedeDAO;
import general.servicio.BaseServicio;

public class SubCtaPlazoCedeServicio extends BaseServicio {
	 
	private SubCtaPlazoCedeServicio(){
		super();
	}

	SubCtaPlazoCedeDAO subCtaPlazoCedeDAO = null;
	
	public static interface Enum_Tra_SubCtaPlazoCede {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaPlazoCede{
		int principal = 1;
	}


	public SubCtaPlazoCedeBean consulta(int tipoConsulta, SubCtaPlazoCedeBean subCtaPlazoCede){
		SubCtaPlazoCedeBean subCtaPlazoCedeBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaPlazoCede.principal:
				subCtaPlazoCedeBean = subCtaPlazoCedeDAO.consultaPrincipal(subCtaPlazoCede, Enum_Con_SubCtaPlazoCede.principal);
			break;		
		}
		return subCtaPlazoCedeBean;
	}

	public SubCtaPlazoCedeDAO getSubCtaPlazoCedeDAO() {
		return subCtaPlazoCedeDAO;
	}

	public void setSubCtaPlazoCedeDAO(SubCtaPlazoCedeDAO subCtaPlazoCedeDAO) {
		this.subCtaPlazoCedeDAO = subCtaPlazoCedeDAO;
	}
	
	
}
