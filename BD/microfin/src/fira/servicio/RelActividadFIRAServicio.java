package fira.servicio;

import fira.bean.RelActividadFIRABean;
import fira.dao.RelActividadFIRADAO;
import general.servicio.BaseServicio;

import java.util.List;

public class RelActividadFIRAServicio extends BaseServicio{
	RelActividadFIRADAO relActividadFIRADAO;
	
	public static interface Enum_Lis_RelActividadFIRA{
		int	principal	= 1;
	}
	
	public static interface Enum_Con_RelActividadFIRA{
		int	principal	= 1;
	}
	
	public List<RelActividadFIRABean> lista(int tipoLista, RelActividadFIRABean relActividadFIRABean) {
		List<RelActividadFIRABean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_RelActividadFIRA.principal:
			lista = relActividadFIRADAO.lista(tipoLista, relActividadFIRABean);
			break;
		}
		return lista;
	}
	
	public RelActividadFIRABean consulta(int tipoConsulta, RelActividadFIRABean relActividadFIRABean) {
		RelActividadFIRABean relActividadFIRABean2 = null;
		switch (tipoConsulta) {
		case Enum_Lis_RelActividadFIRA.principal:
			relActividadFIRABean2 = relActividadFIRADAO.consulta(tipoConsulta, relActividadFIRABean);
			break;
		}
		return relActividadFIRABean2;
	}
	public RelActividadFIRADAO getRelActividadFIRADAO() {
		return relActividadFIRADAO;
	}

	public void setRelActividadFIRADAO(RelActividadFIRADAO relActividadFIRADAO) {
		this.relActividadFIRADAO = relActividadFIRADAO;
	}
}
