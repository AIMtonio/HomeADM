package tesoreria.servicio;

import tesoreria.bean.ParametrosDepRefBean;
import tesoreria.dao.ParametrosDepRefDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ParametrosDepRefServicio extends BaseServicio{
	ParametrosDepRefDAO parametrosDepRefDAO = null;

	public ParametrosDepRefServicio (){
		super();
	}

	public static interface Enum_Tra_ParDepRef {
		int modifica = 1;
	}

	public static interface Enum_Con_ParDepRef {
		int principal = 1;
		int paramCobranzRef = 2;
	}


	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosDepRefBean parametrosDepRefBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		switch(tipoTransaccion){
		case Enum_Tra_ParDepRef.modifica:
			mensaje = parametrosDepRefDAO.modifica(parametrosDepRefBean);
			break;
			}
		return mensaje;
	}

	public ParametrosDepRefBean consulta(ParametrosDepRefBean paramDepRefBean, int tipoConsulta){
		ParametrosDepRefBean parametros= null;
		
		switch(tipoConsulta){
			case Enum_Con_ParDepRef.principal:
				parametros = parametrosDepRefDAO.consultaPrincipal(paramDepRefBean, tipoConsulta);
			break;
			case Enum_Con_ParDepRef.paramCobranzRef:
				parametros = parametrosDepRefDAO.paramCobranzRef(paramDepRefBean, tipoConsulta);
			break;
		}
		return parametros;
	}

	

	public ParametrosDepRefDAO getParametrosDepRefDAO() {
		return parametrosDepRefDAO;
	}

	public void setParametrosDepRefDAO(ParametrosDepRefDAO parametrosDepRefDAO) {
		this.parametrosDepRefDAO = parametrosDepRefDAO;
	}
}
