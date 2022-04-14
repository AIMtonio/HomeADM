package nomina.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import nomina.bean.CatQuinqueniosBean;
import nomina.dao.CatQuinqueniosDAO;

public class CatQuinqueniosServicio extends BaseServicio {
	CatQuinqueniosDAO catQuinqueniosDAO = null;

	public static interface Enum_Lis_CatQuinquenios {
		int principal = 1;
	}
	
	public static interface Enum_Con_CatQuinquenios {
		int principal = 1;
	}

	public List<?> lista(int tipoLista, CatQuinqueniosBean catQuinqueniosBean) {
		List<?> resultado = null;
		switch (tipoLista) {
		case Enum_Lis_CatQuinquenios.principal:
			resultado = catQuinqueniosDAO.listaPrincipal(tipoLista, catQuinqueniosBean);
			break;
		}
		return resultado;
	}
	
	public CatQuinqueniosBean consulta(int tipoConsulta, CatQuinqueniosBean catQuinqueniosBean) {
		CatQuinqueniosBean resultado = null;

		switch (tipoConsulta) {
		case Enum_Con_CatQuinquenios.principal:
			resultado = catQuinqueniosDAO.consultaPrincipal(tipoConsulta, catQuinqueniosBean);
			break;
		}

		return resultado;
	}
	
	public CatQuinqueniosDAO getCatQuinqueniosDAO() {
		return catQuinqueniosDAO;
	}

	public void setCatQuinqueniosDAO(CatQuinqueniosDAO catQuinqueniosDAO) {
		this.catQuinqueniosDAO = catQuinqueniosDAO;
	}

	
	
	
}
