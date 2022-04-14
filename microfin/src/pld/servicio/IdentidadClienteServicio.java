package pld.servicio;

import pld.bean.IdentidadClienteBean;
import pld.dao.IdentidadClienteDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class IdentidadClienteServicio extends BaseServicio{
	IdentidadClienteDAO identidadClienteDAO=null;
	
	public IdentidadClienteServicio(){
		super();
	}
	
	public static interface Enum_Con_IdentidadCliente{
		int consultaPrincipal = 1;
	};
	
	public static interface Enum_Tran_IdentidadCliente{
		int agrega = 1;
		int modifica = 2;
	};
	
	public MensajeTransaccionBean grabaTransaccion(IdentidadClienteBean identidadClienteBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje= new MensajeTransaccionBean();
		switch(tipoTransaccion){
			case Enum_Tran_IdentidadCliente.agrega:
				mensaje=identidadClienteDAO.agregaIdentidad(identidadClienteBean);
			break;
			case Enum_Tran_IdentidadCliente.modifica:
				mensaje=identidadClienteDAO.modificaIdentidad(identidadClienteBean);
			break;
		}
		return mensaje;
	}
	
	
	public IdentidadClienteBean consulta(IdentidadClienteBean identidadClienteBean, int tipoConsulta){
		IdentidadClienteBean identiCliente = null;
		switch(tipoConsulta){
			case Enum_Con_IdentidadCliente.consultaPrincipal:
					identiCliente=identidadClienteDAO.consultaPrincipal(identidadClienteBean, tipoConsulta);
			break;
		}
		return identiCliente;
	}

	
	public IdentidadClienteDAO getIdentidadClienteDAO() {
		return identidadClienteDAO;
	}
	public void setIdentidadClienteDAO(IdentidadClienteDAO identidadClienteDAO) {
		this.identidadClienteDAO = identidadClienteDAO;
	}
}
