package cuentas.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import cuentas.bean.CatalogoNivelesBean;
import cuentas.dao.CatalogoNivelesDAO;

public class CatalogoNivelesServicio extends BaseServicio {

	// ---------- Variables ----------------------------------------------
	CatalogoNivelesDAO catalogoNivelesDAO = null;

	// ---------- Tipo de Lista ------------------------------------------
	public static interface Enum_Lis_Niveles {
		int combo = 1;
	}

	public CatalogoNivelesServicio() {
		super();
	}

	// Lista de Niveles para Combo Box
	public Object[] listaCombo(int tipoLista, CatalogoNivelesBean catalogoNivelesBean) {
		List listaNiveles = null;
		switch (tipoLista) {
		case Enum_Lis_Niveles.combo:
			listaNiveles = catalogoNivelesDAO.listaCombo(catalogoNivelesBean, tipoLista);
			break;
		}
		return listaNiveles.toArray();
	}

	// ------------------ Geters y Seters ------------------------------------------------------

	public CatalogoNivelesDAO getCatalogoNivelesDAO() {
		return catalogoNivelesDAO;
	}

	public void setCatalogoNivelesDAO(CatalogoNivelesDAO catalogoNivelesDAO) {
		this.catalogoNivelesDAO = catalogoNivelesDAO;
	}

}
