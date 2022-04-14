package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.List;

import pld.bean.NivelesRiesgoBean;
import pld.dao.NivelesRiesgoDAO;

public class NivelesRiesgoServicio extends BaseServicio{
	
	private NivelesRiesgoDAO nivelesRiesgoDAO=null;

	
	public static interface Enum_Con_CatalogoNivelesRiesgo{
		int consultaPrincipal = 1;
	};
	
	public List consultaPrincipal(NivelesRiesgoBean nivelRiesgoBean) {
		List listaNivelesRiesgo = null;
		int tipoConsulta = Utileria.convierteEntero(nivelRiesgoBean.getTipoConsulta());
		switch (tipoConsulta) {
			case Enum_Con_CatalogoNivelesRiesgo.consultaPrincipal :
				listaNivelesRiesgo = nivelesRiesgoDAO.consultaPrincipal(nivelRiesgoBean);
				break;
		}
		return listaNivelesRiesgo;
	}
	
	public MensajeTransaccionBean actualizaCatalogoNiveles(NivelesRiesgoBean nivelesBean){
		MensajeTransaccionBean mensaje;
		mensaje = nivelesRiesgoDAO.actualizaNivelRiesgo(nivelesBean);
		return mensaje;		
	}
	
	public NivelesRiesgoDAO getNivelesRiesgoDAO() {
		return nivelesRiesgoDAO;
	}

	public void setNivelesRiesgoDAO(NivelesRiesgoDAO nivelesRiesgoDAO) {
		this.nivelesRiesgoDAO = nivelesRiesgoDAO;
	}
}
