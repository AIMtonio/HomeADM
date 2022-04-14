package cliente.servicio;

import cliente.bean.EstadoCuentaUnicoBean;
import cliente.dao.EdoCuentaUnicoRepDAO;
import general.servicio.BaseServicio;

public class EdoCuentaUnicoRepServicio extends BaseServicio{

	EdoCuentaUnicoRepDAO edoCuentaUnicoRepDAO= null;
	
	public static interface Enum_Con_Genera{
		int principal = 1;
		}
	
	public EdoCuentaUnicoRepServicio(){
		super();
	}
	
	// Consulta Estado de Cuenta
	public EstadoCuentaUnicoBean consulta(int tipoConsulta){
		EstadoCuentaUnicoBean edoCtaParamsBean= null;
		switch (tipoConsulta) {
			case Enum_Con_Genera.principal:
				edoCtaParamsBean = edoCuentaUnicoRepDAO.consultaPrincipal(Enum_Con_Genera.principal);
				break;
		}
		return edoCtaParamsBean;
	}


    /* ========== GETTER $ SETTER ======= */
	public EdoCuentaUnicoRepDAO getEdoCuentaUnicoRepDAO() {
		return edoCuentaUnicoRepDAO;
	}

	public void setEdoCuentaUnicoRepDAO(EdoCuentaUnicoRepDAO edoCuentaUnicoRepDAO) {
		this.edoCuentaUnicoRepDAO = edoCuentaUnicoRepDAO;
	}	
	
}
