package cliente.servicio;

import java.util.List;

import cliente.bean.InstitucionNominaBean;
import cliente.dao.InstitucionNominaDAO;
import general.servicio.BaseServicio;

public class InstitucionNominaServicio  extends BaseServicio{

	InstitucionNominaDAO institucionNominaDAO= null;

	public static interface Enum_Con_Institucion {
		int foranea =2;
		int institucion	= 3;	
		int promotor = 4;
		int Cte		=6;
		int institucionWS =7;
		int promotorWS = 8;

	}

	
	public static interface Enum_Lis_Institucion{
		int principal = 1;
	}
	
	public InstitucionNominaBean consulta(int tipoConsulta, InstitucionNominaBean institucionBean){
		InstitucionNominaBean institucion = null;
		switch (tipoConsulta) {
		case Enum_Con_Institucion.institucion:
			institucion = institucionNominaDAO.consultaInstitucion(Enum_Con_Institucion.institucion, institucionBean);
		break;
		case Enum_Con_Institucion.institucionWS:
			institucion = institucionNominaDAO.consultaInstitucionWS(Enum_Con_Institucion.institucion, institucionBean);
		break;
		case Enum_Con_Institucion.promotor:
			institucion = institucionNominaDAO.consultaPromotor(Enum_Con_Institucion.promotor, institucionBean);
		break;
		case Enum_Con_Institucion.promotorWS:
			institucion = institucionNominaDAO.consultaPromotorWS(Enum_Con_Institucion.promotor, institucionBean);
		break;
		case Enum_Con_Institucion.Cte:
			institucion = institucionNominaDAO.consultaCte(Enum_Con_Institucion.Cte, institucionBean);
			break;
		case Enum_Con_Institucion.foranea:
			institucion = institucionNominaDAO.consultaForanea(Enum_Con_Institucion.foranea, institucionBean);
			break;
	}
	return institucion;
	}
	
	
//	public List lista(int tipoLista, InstitucionNominaBean institucionBean){	
//	List listaInstitucionNomina = null;
//	switch (tipoLista) {
//		case Enum_Lis_Institucion.principal:		
//			listaInstitucionNomina = institucionNominaDAO.listaInstitucion(tipoLista,institucionBean);		
//			break;
//			}
//	return listaInstitucionNomina;		
//	}

	public InstitucionNominaDAO getInstitucionNominaDAO() {
		return institucionNominaDAO;
	}

	public void setInstitucionNominaDAO(InstitucionNominaDAO institucionNominaDAO) {
		this.institucionNominaDAO = institucionNominaDAO;
	}

	
}
