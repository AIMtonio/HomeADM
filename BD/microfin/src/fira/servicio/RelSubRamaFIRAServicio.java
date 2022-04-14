package fira.servicio;

import fira.bean.RelSubRamaFIRABean;
import fira.dao.RelSubRamaFIRADAO;
import general.servicio.BaseServicio;

import java.util.List;

public class RelSubRamaFIRAServicio extends BaseServicio {
	RelSubRamaFIRADAO	relSubRamaFIRADAO;

	public static interface Enum_Lis_RelSubRamaFIRA{
		int	principal	= 1;
	}
	
	public static interface Enum_Con_RelSubRamaFIRA{
		int	principal	= 1;
	}
	
	public List<RelSubRamaFIRABean> lista(int tipoLista, RelSubRamaFIRABean relSubRamaFIRABean) {
		List<RelSubRamaFIRABean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_RelSubRamaFIRA.principal:
			lista = relSubRamaFIRADAO.lista(tipoLista, relSubRamaFIRABean);
			break;
		}
		return lista;
	}
	
	public RelSubRamaFIRABean consulta(int tipoConsulta, RelSubRamaFIRABean relSubRamaFIRABean) {
		RelSubRamaFIRABean relSubRamaFIRABean2 = null;
		switch (tipoConsulta) {
		case Enum_Lis_RelSubRamaFIRA.principal:
			relSubRamaFIRABean2 = relSubRamaFIRADAO.consulta(tipoConsulta, relSubRamaFIRABean);
			break;
		}
		return relSubRamaFIRABean2;
	}

	public RelSubRamaFIRADAO getRelSubRamaFIRADAO() {
		return relSubRamaFIRADAO;
	}

	public void setRelSubRamaFIRADAO(RelSubRamaFIRADAO relSubRamaFIRADAO) {
		this.relSubRamaFIRADAO = relSubRamaFIRADAO;
	}

}
