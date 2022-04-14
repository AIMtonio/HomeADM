package fira.servicio;

import fira.bean.CatCadenaProductivaBean;
import fira.dao.CatCadenaProductivaDAO;
import general.servicio.BaseServicio;

import java.util.List;

public class CatCadenaProductivaServicio extends BaseServicio {
	CatCadenaProductivaDAO	catCadenaProductivaDAO;

	public static interface Enum_Lis_CatCadenaProductiva {
		int	principal	= 1;
	}
	
	public static interface Enum_Con_CatCadenaProductiva {
		int	principal	= 1;
	}
	
	public List<CatCadenaProductivaBean> lista(int tipoLista, CatCadenaProductivaBean catCadenaProductivaBean) {
		List<CatCadenaProductivaBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_CatCadenaProductiva.principal:
			lista = catCadenaProductivaDAO.lista(tipoLista, catCadenaProductivaBean);
			break;
		}
		return lista;
	}
	
	public CatCadenaProductivaBean consulta(int tipoConsulta, CatCadenaProductivaBean catCadenaProductivaBean) {
		CatCadenaProductivaBean catCadenaProductivaBean2 = null;
		switch (tipoConsulta) {
		case Enum_Lis_CatCadenaProductiva.principal:
			catCadenaProductivaBean2 = catCadenaProductivaDAO.consulta(tipoConsulta, catCadenaProductivaBean);
			break;
		}
		return catCadenaProductivaBean2;
	}

	public CatCadenaProductivaDAO getCatCadenaProductivaDAO() {
		return catCadenaProductivaDAO;
	}

	public void setCatCadenaProductivaDAO(CatCadenaProductivaDAO catCadenaProductivaDAO) {
		this.catCadenaProductivaDAO = catCadenaProductivaDAO;
	}
}
