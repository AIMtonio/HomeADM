package fira.servicio;

import fira.bean.CatFIRAProgEspBean;
import fira.dao.CatFIRAProgEspDAO;
import general.servicio.BaseServicio;

import java.util.List;

public class CatFIRAProgEspServicio extends BaseServicio {

	CatFIRAProgEspDAO	catFIRAProgEspDAO;

	public static interface Enum_Lis_CatFIRAProgEsp {
		int	principal	= 1;
	}
	
	public static interface Enum_Con_CatFIRAProgEsp {
		int	principal	= 1;
	}
	
	public List<CatFIRAProgEspBean> lista(int tipoLista, CatFIRAProgEspBean catCadenaProductivaBean) {
		List<CatFIRAProgEspBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_CatFIRAProgEsp.principal:
			lista = catFIRAProgEspDAO.lista(tipoLista, catCadenaProductivaBean);
			break;
		}
		return lista;
	}
	
	public CatFIRAProgEspBean consulta(int tipoConsulta, CatFIRAProgEspBean catCadenaProductivaBean) {
		CatFIRAProgEspBean catCadenaProductivaBean2 = null;
		switch (tipoConsulta) {
		case Enum_Lis_CatFIRAProgEsp.principal:
			catCadenaProductivaBean2 = catFIRAProgEspDAO.consulta(tipoConsulta, catCadenaProductivaBean);
			break;
		}
		return catCadenaProductivaBean2;
	}

	public CatFIRAProgEspDAO getCatFIRAProgEspDAO() {
		return catFIRAProgEspDAO;
	}

	public void setCatFIRAProgEspDAO(CatFIRAProgEspDAO catFIRAProgEspDAO) {
		this.catFIRAProgEspDAO = catFIRAProgEspDAO;
	}

}
