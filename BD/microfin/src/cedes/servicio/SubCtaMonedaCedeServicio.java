package cedes.servicio;

import cedes.bean.SubCtaMonedaCedeBean;
import cedes.dao.SubCtaMonedaCedeDAO;
import general.servicio.BaseServicio;
 
public class SubCtaMonedaCedeServicio extends BaseServicio{
	
	private SubCtaMonedaCedeServicio(){
		super();
	}

	SubCtaMonedaCedeDAO subCtaMonedaCedeDAO = null;
	
	public static interface Enum_Tra_SubCtaMonedaCede {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaMonedaCede{
		int principal = 1;
	}

	public SubCtaMonedaCedeBean consulta(int tipoConsulta, SubCtaMonedaCedeBean subCtaMonedaCede){
		SubCtaMonedaCedeBean subCtaMonedaCedeBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaMonedaCede.principal:
				subCtaMonedaCedeBean = subCtaMonedaCedeDAO.consultaPrincipal(subCtaMonedaCede, Enum_Con_SubCtaMonedaCede.principal);
			break;		
		}
		return subCtaMonedaCedeBean;
	}

	public SubCtaMonedaCedeDAO getSubCtaMonedaCedeDAO() {
		return subCtaMonedaCedeDAO;
	}

	public void setSubCtaMonedaCedeDAO(SubCtaMonedaCedeDAO subCtaMonedaCedeDAO) {
		this.subCtaMonedaCedeDAO = subCtaMonedaCedeDAO;
	}


}
