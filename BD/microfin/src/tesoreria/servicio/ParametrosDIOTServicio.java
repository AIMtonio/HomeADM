package tesoreria.servicio;

import java.util.ArrayList;
import java.util.List;

import tesoreria.bean.ParametrosDIOTBean;
import tesoreria.dao.ParametrosDIOTDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ParametrosDIOTServicio extends BaseServicio {
	
	//---------- Variables ------------------------------------------------------------------------
	ParametrosDIOTDAO parametrosDIOTDAO = null;
	
	public ParametrosDIOTServicio () {
		super();
	}

	public static interface Enum_Tra_TipoProvee {
		int modifica = 1;

	}
	
	public static interface Enum_Con_TipoProvee {
		int principal = 1;
		int foranea =2;
		int actualizacion = 3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosDIOTBean parametrosDIOTBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch(tipoTransaccion){
		case Enum_Tra_TipoProvee.modifica:
			mensaje = parametrosDIOTDAO.modifica(parametrosDIOTBean);
			break;

			}
		return mensaje;

	}		
	
	// Consulta de tipo de proveedor impuesto
	public ParametrosDIOTBean consulta(int tipoConsulta){
		ParametrosDIOTBean parametros= null;
		switch(tipoConsulta){
			case Enum_Con_TipoProvee.principal:
				parametros = parametrosDIOTDAO.consultaPrincipal(tipoConsulta);
			break;
			
		
		}
		return parametros;
	}

		
	//------------------ Geters y Seters ------------------------------------------------------	

	public ParametrosDIOTDAO getParametrosDIOTDAO() {
		return parametrosDIOTDAO;
	}


	public void setParametrosDIOTDAO(ParametrosDIOTDAO parametrosDIOTDAO) {
		this.parametrosDIOTDAO = parametrosDIOTDAO;
	}
	
	

	
}
