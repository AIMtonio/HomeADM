package fira.servicio;

import fira.bean.CatTipoGarantiaFIRABean;
import fira.dao.CatTipoGarantiaFIRADAO;
import general.servicio.BaseServicio;

import java.util.List;

public class CatTipoGarantiaFIRAServicio extends BaseServicio {
	CatTipoGarantiaFIRADAO	catTipoGarantiaFIRADAO;

	public static interface Enum_Lis_CatTipoGarantiaFIRA {
		int	combo	= 1;
		int comboReporte = 2;
	}

	public Object[] listaCombo(int tipoLista, CatTipoGarantiaFIRABean catTipoGarantiaFIRABean) {
		List<CatTipoGarantiaFIRABean> lista = null;

		switch (tipoLista) {
			case Enum_Lis_CatTipoGarantiaFIRA.combo:
				lista = catTipoGarantiaFIRADAO.lista(tipoLista, catTipoGarantiaFIRABean);
			break;
			case Enum_Lis_CatTipoGarantiaFIRA.comboReporte:
				lista = catTipoGarantiaFIRADAO.lista(tipoLista, catTipoGarantiaFIRABean);
			break;
		}
		return lista.toArray();
	}

	public CatTipoGarantiaFIRADAO getCatTipoGarantiaFIRADAO() {
		return catTipoGarantiaFIRADAO;
	}

	public void setCatTipoGarantiaFIRADAO(CatTipoGarantiaFIRADAO catTipoGarantiaFIRADAO) {
		this.catTipoGarantiaFIRADAO = catTipoGarantiaFIRADAO;
	}
}
