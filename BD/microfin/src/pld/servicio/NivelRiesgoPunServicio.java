package pld.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import pld.bean.NivelRiesgoPunBean;
import pld.dao.NivelRiesgoPunDAO;

public class NivelRiesgoPunServicio extends BaseServicio {
	NivelRiesgoPunDAO	nivelRiesgoPunDAO;
	
	public static interface Enum_Lis_NivelHis {
		int	historica		= 1;
	}

	public List<NivelRiesgoPunBean> listaReporte(int tipoLista, NivelRiesgoPunBean bean) {
		List<NivelRiesgoPunBean> lista = null;
		lista = nivelRiesgoPunDAO.listaReporte(bean, tipoLista);
		return lista;
	}

	public NivelRiesgoPunDAO getNivelRiesgoPunDAO() {
		return nivelRiesgoPunDAO;
	}

	public void setNivelRiesgoPunDAO(NivelRiesgoPunDAO nivelRiesgoPunDAO) {
		this.nivelRiesgoPunDAO = nivelRiesgoPunDAO;
	}
	
	
}
