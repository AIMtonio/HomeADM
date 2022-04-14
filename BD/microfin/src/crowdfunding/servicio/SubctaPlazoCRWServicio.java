package crowdfunding.servicio;

import crowdfunding.bean.SubctaPlazoCRWBean;
import crowdfunding.dao.SubctaPlazoCRWDAO;
import general.servicio.BaseServicio;

public class SubctaPlazoCRWServicio extends BaseServicio{

	SubctaPlazoCRWDAO subctaPlazoCRWDAO = null;

	public SubctaPlazoCRWServicio() {
		super();
	}

	public static interface Enum_Tra_SubctaPlazoCRW {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubctaPlazoCRW{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubctaPlazoCRW{
		int principal = 1;
		int foranea = 2;
	}

	public SubctaPlazoCRWBean consulta(int tipoConsulta, SubctaPlazoCRWBean subctaPlazoCRWBean){
		SubctaPlazoCRWBean subctaPlazoCRW = null;

		switch(tipoConsulta){
		case Enum_Con_SubctaPlazoCRW.principal:
			subctaPlazoCRW = subctaPlazoCRWDAO.consultaPrincipal(subctaPlazoCRWBean, tipoConsulta);
			break;
		}
		return subctaPlazoCRW;
	}

	public SubctaPlazoCRWDAO getSubctaPlazoCRWDAO() {
		return subctaPlazoCRWDAO;
	}

	public void setSubctaPlazoCRWDAO(SubctaPlazoCRWDAO subctaPlazoCRWDAO) {
		this.subctaPlazoCRWDAO = subctaPlazoCRWDAO;
	}
}