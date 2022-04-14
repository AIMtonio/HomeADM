package cliente.servicio;

import cliente.bean.ExpedienteClienteBean;
import cliente.dao.ExpedienteClienteDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;

public class ExpedienteClienteServicio extends BaseServicio {
	
	ParametrosSesionBean parametrosSesionBean = null;
	ExpedienteClienteDAO expedienteClienteDAO = null;
	
	public ExpedienteClienteServicio() {
		super();
	}

	public static interface Enum_Tra_Expediente{
		int alta	 = 1;
	}
	
	public static interface Enum_Con_Expediente{
		int principal	 = 1;
		int expediente	 = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,  ExpedienteClienteBean bean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {		
			case Enum_Tra_Expediente.alta:
				mensaje = expedienteClienteDAO.alta(bean);					
				break;
		}
		return mensaje;
	}

	public ExpedienteClienteBean consulta(ExpedienteClienteBean clienteBean,  int tipoConsulta){
		ExpedienteClienteBean bean = null;
		switch (tipoConsulta) {		
		case Enum_Con_Expediente.principal:
			bean = expedienteClienteDAO.consulta(clienteBean, tipoConsulta);					
			break;
		case Enum_Con_Expediente.expediente:
			bean = expedienteClienteDAO.consultaFechaExpediente(clienteBean, tipoConsulta);					
			break;
		}
		return bean;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ExpedienteClienteDAO getExpedienteClienteDAO() {
		return expedienteClienteDAO;
	}

	public void setExpedienteClienteDAO(ExpedienteClienteDAO expedienteClienteDAO) {
		this.expedienteClienteDAO = expedienteClienteDAO;
	}
}
