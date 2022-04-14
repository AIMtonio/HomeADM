package crowdfunding.servicio;

import crowdfunding.bean.SubctaMonedaCRWBean;
import crowdfunding.dao.SubctaMonedaCRWDAO;
import general.servicio.BaseServicio;

public class SubctaMonedaCRWServicio extends BaseServicio{

	SubctaMonedaCRWDAO subctaMonedaCRWDAO = null;

	public SubctaMonedaCRWServicio() {
		super();
	}

	public static interface Enum_Tra_SubctaMonedaCRW {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubctaMonedaCRW {
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubctaMonedaCRW{
		int principal = 1;
		int foranea = 2;
	}

	public SubctaMonedaCRWBean consulta(int tipoConsulta, SubctaMonedaCRWBean subctaMonedaCRWBean){
		SubctaMonedaCRWBean subctaMonedaCRW = null;

		switch(tipoConsulta){
		case Enum_Con_SubctaMonedaCRW.principal:
			subctaMonedaCRW = subctaMonedaCRWDAO.consultaPrincipal(subctaMonedaCRWBean, tipoConsulta);
		}
		return subctaMonedaCRW;
	}

	public SubctaMonedaCRWDAO getSubctaMonedaCRWDAO() {
		return subctaMonedaCRWDAO;
	}

	public void setSubctaMonedaCRWDAO(SubctaMonedaCRWDAO subctaMonedaCRWDAO) {
		this.subctaMonedaCRWDAO = subctaMonedaCRWDAO;
	}
}