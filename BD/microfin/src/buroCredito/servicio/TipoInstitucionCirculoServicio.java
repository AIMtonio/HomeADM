package buroCredito.servicio;

import java.util.List;

import buroCredito.bean.TipoInstitucionCirculoBean;
import buroCredito.dao.TipoInstitucionCirculoDAO;
import general.servicio.BaseServicio;

public class TipoInstitucionCirculoServicio extends BaseServicio {

	TipoInstitucionCirculoDAO tipoInstitucionCirculoDAO = null;
	
	public static interface Enum_Con_TipoInstitucion {
		int Con_Principal = 1;
	}
	
	public static interface Enum_Lis_TipoInstitucion {
		int Lis_Principal = 1;
	}

	public TipoInstitucionCirculoBean consulta(int tipoConsulta, TipoInstitucionCirculoBean tipoInstitucionCirculoBean) {

		TipoInstitucionCirculoBean intituciones = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_TipoInstitucion.Con_Principal:
					intituciones = tipoInstitucionCirculoDAO.consultaPrincipal(tipoInstitucionCirculoBean, tipoConsulta);
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Tipo de Instituciones de Circulo ", exception);
			exception.printStackTrace();
		}
		return intituciones;
	}
	
	public List<TipoInstitucionCirculoBean> lista(int tipoLista, TipoInstitucionCirculoBean tipoInstitucionCirculoBean) {

		List<TipoInstitucionCirculoBean> listaInstituciones = null;
		try{
			switch(tipoLista){
				case Enum_Lis_TipoInstitucion.Lis_Principal:
					listaInstituciones = tipoInstitucionCirculoDAO.listaPrincipal(tipoInstitucionCirculoBean, tipoLista);
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Tipo de Instituciones de Circulo  ", exception);
			exception.printStackTrace();
		}
		return listaInstituciones;
	}

	public TipoInstitucionCirculoDAO getTipoInstitucionCirculoDAO() {
		return tipoInstitucionCirculoDAO;
	}

	public void setTipoInstitucionCirculoDAO(
			TipoInstitucionCirculoDAO tipoInstitucionCirculoDAO) {
		this.tipoInstitucionCirculoDAO = tipoInstitucionCirculoDAO;
	}
	
}
