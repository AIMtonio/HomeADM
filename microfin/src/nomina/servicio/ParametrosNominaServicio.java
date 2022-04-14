package nomina.servicio;

import nomina.bean.ParametrosNominaBean;
import nomina.dao.ParametrosNominaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ParametrosNominaServicio extends BaseServicio{

	public ParametrosNominaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	ParametrosNominaDAO parametrosNominaDAO = null;
	
	public static interface Enum_Tra_Params {
		int alta = 1;
		int modifica = 2;
	}
	
	public static interface Enum_Con_Params {
		int principal = 1;
	}
	

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,ParametrosNominaBean parametrosNominaBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			
			case Enum_Tra_Params.modifica:
				mensaje = parametrosNominaDAO.modificaParams(parametrosNominaBean);
				break;
			
		}
		return mensaje;
	}
	public ParametrosNominaBean consulta(int tipoConsulta, ParametrosNominaBean parametrosNominaBean){

		ParametrosNominaBean parametrosNomina = null;
		switch (tipoConsulta) { 
			case Enum_Con_Params.principal:				
				parametrosNomina = parametrosNominaDAO.consultaParametros(parametrosNominaBean, tipoConsulta);
			break;
			
		}
		return parametrosNomina;
	}

 /* ********************** GETTERS y SETTERS **************************** */
	
	public ParametrosNominaDAO getParametrosNominaDAO() {
		return parametrosNominaDAO;
	}
	public void setParametrosNominaDAO(ParametrosNominaDAO parametrosNominaDAO) {
		this.parametrosNominaDAO = parametrosNominaDAO;
	}
	
	
}
