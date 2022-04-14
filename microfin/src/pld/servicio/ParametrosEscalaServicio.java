package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import pld.bean.ParametrosEscalaBean;
import pld.bean.ParametrosOpRelBean;
import pld.dao.ParametrosEscalaDAO;
import pld.dao.ParametrosOpRelDAO;
import pld.servicio.ParametrosOpRelServicio.Enum_Con_ParOpRel;

public class ParametrosEscalaServicio extends BaseServicio {

	// ---------- Variables ------------------------------------------------------------------------
	ParametrosEscalaDAO parametrosEscalaDAO = null;

	// ---------- Tipos de transacciones---------------------------------------------------------------
	public static interface Enum_Trans_ParEsca {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_ParEsca {
		int principal = 1;
		int foranea = 2;
	}

	// ---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_ParEsca {
		int principal = 1;
	}

	public ParametrosEscalaBean consulta(int tipoConsulta, ParametrosEscalaBean parametrosEscalaBean) {
		ParametrosEscalaBean parametrosEscala = null;
		switch (tipoConsulta) {
			case Enum_Con_ParEsca.principal:
				parametrosEscala = parametrosEscalaDAO.consultaPrincipal(parametrosEscalaBean, tipoConsulta);
				break;
		}
		return parametrosEscala;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosEscalaBean parametrosEscalaBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Trans_ParEsca.alta:
			mensaje = parametrosEscalaDAO.alta(parametrosEscalaBean);
			break;
		case Enum_Trans_ParEsca.modificacion:
			mensaje = parametrosEscalaDAO.modificacion(parametrosEscalaBean);
			break;

		}
		return mensaje;
	}

	// ------------------ Geters y Seters --------------------------------------------

	public ParametrosEscalaDAO getParametrosEscalaDAO() {
		return parametrosEscalaDAO;
	}

	public void setParametrosEscalaDAO(ParametrosEscalaDAO parametrosEscalaDAO) {
		this.parametrosEscalaDAO = parametrosEscalaDAO;
	}

}
