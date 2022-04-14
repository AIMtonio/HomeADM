package spei.servicio;

import spei.bean.CuentaClabePMoralBean;
import spei.dao.CuentaClabePMoralDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CuentaClabePMoralServicio extends BaseServicio {
	private CuentaClabePMoralServicio(){
		super();
	}
	
	private CuentaClabePMoralDAO cuentaClabePMoralDAO = null;

	public static interface Enum_Tra_CuentaClable{
		int autoriza = 1;
		int porAutoriza = 2;
		int Baja = 3;
	}
	public static interface Enum_Con_CuentaClabe{
		int principal = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CuentaClabePMoralBean cuentaClabePMoralBean){
		MensajeTransaccionBean mensaje = null;
		
		switch (tipoTransaccion) {
			case Enum_Tra_CuentaClable.autoriza:
				mensaje = cuentaClabePMoralDAO.actualizaCuentaClabePM(cuentaClabePMoralBean, tipoTransaccion);
				break;
			case Enum_Tra_CuentaClable.Baja:
				mensaje = cuentaClabePMoralDAO.actualizaCuentaClabePM(cuentaClabePMoralBean, tipoTransaccion);
				break;
		}
		
		return mensaje;
	}
	
	public CuentaClabePMoralBean consulta(int tipoConsulta, CuentaClabePMoralBean cuentaClabePMoralBean){
		CuentaClabePMoralBean cuentaClabePMoralBeanResponse = null;
		switch (tipoConsulta) {
		case Enum_Con_CuentaClabe.principal:
			cuentaClabePMoralBeanResponse = cuentaClabePMoralDAO.consultaCuentaClabe(cuentaClabePMoralBean, tipoConsulta);
			break;
		}
		return cuentaClabePMoralBeanResponse;
	}
	
	public CuentaClabePMoralDAO getCuentaClabePMoralDAO() {
		return cuentaClabePMoralDAO;
	}

	public void setCuentaClabePMoralDAO(CuentaClabePMoralDAO cuentaClabePMoralDAO) {
		this.cuentaClabePMoralDAO = cuentaClabePMoralDAO;
	}
}
