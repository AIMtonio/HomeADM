package tarjetas.servicio;


import tarjetas.bean.TarDebParamBean;
import tarjetas.dao.TarDebParamDAO;

import general.servicio.BaseServicio;


public class TarDebParamServicio extends BaseServicio {
	
	TarDebParamDAO tarDebParamDAO = null;

	public TarDebParamServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	public static interface Enum_Con_parametros{
		int conRuta  		= 2;	
	}
	public TarDebParamBean consulta(int tipoConsulta, TarDebParamBean tardebParam){
		TarDebParamBean consultaParametros = null;
		switch(tipoConsulta){
			case Enum_Con_parametros.conRuta:
				consultaParametros = tarDebParamDAO.consultaRuta(tipoConsulta,tardebParam);
			break;	
		}
		return consultaParametros;
	}
	
	//------------------setter y getter-----------

	
	public TarDebParamDAO getTarDebParamDAO() {
		return tarDebParamDAO;
	}
	public void setTarDebParamDAO(TarDebParamDAO tarDebParamDAO) {
		this.tarDebParamDAO = tarDebParamDAO;
	}
}