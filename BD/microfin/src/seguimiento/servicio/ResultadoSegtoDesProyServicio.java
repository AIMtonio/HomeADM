package seguimiento.servicio;

import seguimiento.bean.ResultadoSegtoDesProyBean;
import seguimiento.dao.ResultadoSegtoDesProyDAO;
import general.servicio.BaseServicio;

public class ResultadoSegtoDesProyServicio extends BaseServicio{

	public ResultadoSegtoDesProyServicio(){
		super();
	}
	
	public static interface Enum_Con_SegtoDesProy {
		int principal = 1;
	}
	
	ResultadoSegtoDesProyDAO resultadoSegtoDesProyDAO = null;

	public ResultadoSegtoDesProyBean consulta(int tipoConsulta, ResultadoSegtoDesProyBean segtoRealizadosBean){
		ResultadoSegtoDesProyBean resDesProyBean = null;
		switch (tipoConsulta) {
			case Enum_Con_SegtoDesProy.principal:
				resDesProyBean = resultadoSegtoDesProyDAO.consultaPrincipal(segtoRealizadosBean, tipoConsulta);
				break;
		}
		return resDesProyBean;
	}

	public ResultadoSegtoDesProyDAO getResultadoSegtoDesProyDAO() {
		return resultadoSegtoDesProyDAO;
	}

	public void setResultadoSegtoDesProyDAO(
			ResultadoSegtoDesProyDAO resultadoSegtoDesProyDAO) {
		this.resultadoSegtoDesProyDAO = resultadoSegtoDesProyDAO;
	}		
}