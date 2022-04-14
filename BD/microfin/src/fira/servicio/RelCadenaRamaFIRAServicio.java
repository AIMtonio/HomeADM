package fira.servicio;

import fira.bean.RelCadenaRamaFIRABean;
import fira.dao.RelCadenaRamaFIRADAO;
import general.servicio.BaseServicio;

import java.util.List;

public class RelCadenaRamaFIRAServicio extends BaseServicio {
	RelCadenaRamaFIRADAO	relCadenaRamaFIRADAO;

	public static interface Enum_Lis_RelCadenaRamaFIRA{
		int	principal	= 1;
	}
	
	public static interface Enum_Con_RelCadenaRamaFIRA{
		int	principal	= 1;
	}
	
	public List<RelCadenaRamaFIRABean> lista(int tipoLista, RelCadenaRamaFIRABean relCadenaRamaFIRABean) {
		List<RelCadenaRamaFIRABean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_RelCadenaRamaFIRA.principal:
			lista = relCadenaRamaFIRADAO.lista(tipoLista, relCadenaRamaFIRABean);
			break;
		}
		return lista;
	}
	
	public RelCadenaRamaFIRABean consulta(int tipoConsulta, RelCadenaRamaFIRABean relCadenaRamaFIRABean) {
		RelCadenaRamaFIRABean relCadenaRamaFIRABean2 = null;
		switch (tipoConsulta) {
		case Enum_Lis_RelCadenaRamaFIRA.principal:
			relCadenaRamaFIRABean2 = relCadenaRamaFIRADAO.consulta(tipoConsulta, relCadenaRamaFIRABean);
			break;
		}
		return relCadenaRamaFIRABean2;
	}

	public RelCadenaRamaFIRADAO getRelCadenaRamaFIRADAO() {
		return relCadenaRamaFIRADAO;
	}

	public void setRelCadenaRamaFIRADAO(RelCadenaRamaFIRADAO relCadenaRamaFIRADAO) {
		this.relCadenaRamaFIRADAO = relCadenaRamaFIRADAO;
	}
}
