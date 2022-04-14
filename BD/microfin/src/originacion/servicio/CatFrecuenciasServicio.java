package originacion.servicio;

import java.util.List;

import originacion.bean.FrecuenciaBean;
import originacion.dao.CatFrecuenciasDAO;
import general.servicio.BaseServicio;

public class CatFrecuenciasServicio extends BaseServicio {
	
	CatFrecuenciasDAO catFrecuenciasDAO;

	public static interface Enum_Lis_Frecuencias {
		int todasCalRegular = 1;
		int todasCalIrregular = 2;
		int combo = 3;
		int desembolsos = 4;
	}
	
	/**
	 * Lista las frecuencias de los productos
	 * @param tipoLista
	 * @param frecuenciaBean
	 * @return
	 */
	public List<FrecuenciaBean> lista(int tipoLista, FrecuenciaBean frecuenciaBean){
		List<FrecuenciaBean> lista = null;
		switch (tipoLista) {
			case Enum_Lis_Frecuencias.todasCalRegular:
				lista=  catFrecuenciasDAO.listaFrecuencias(tipoLista,frecuenciaBean);
				break;
			case Enum_Lis_Frecuencias.todasCalIrregular:
				lista=  catFrecuenciasDAO.listaFrecuencias(tipoLista,frecuenciaBean);
				break;
			case Enum_Lis_Frecuencias.combo:
				lista=  catFrecuenciasDAO.listaFrecuencias(tipoLista,frecuenciaBean);
				break;
			case Enum_Lis_Frecuencias.desembolsos:
				lista=  catFrecuenciasDAO.listaFrecuencias(tipoLista,frecuenciaBean);
				break;
		}		
		return lista;
	}
	
	public CatFrecuenciasDAO getCatFrecuenciasDAO() {
		return catFrecuenciasDAO;
	}

	public void setCatFrecuenciasDAO(CatFrecuenciasDAO catFrecuenciasDAO) {
		this.catFrecuenciasDAO = catFrecuenciasDAO;
	}

}
