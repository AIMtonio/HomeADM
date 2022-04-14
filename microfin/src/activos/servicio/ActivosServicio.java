package activos.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import activos.bean.ActivosBean;
import activos.dao.ActivosDAO;

public class ActivosServicio extends BaseServicio{	
	ActivosDAO activosDAO = null;
	
	public static interface Enum_Tra_Activos{
		int alta	 = 1;
		int modifica = 2;
	}
	
	public static interface Enum_Lis_Activos{
		int listaActivos	= 1;
	}
	
	public static interface Enum_Con_Activos{
		int activo = 1;
	}
	
	public ActivosServicio(){
		super();
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ActivosBean activosBean){		
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case(Enum_Tra_Activos.alta):
				mensaje = activosDAO.altaActivo(activosBean);
				break;
			case(Enum_Tra_Activos.modifica):
				mensaje = activosDAO.modificaActivo(activosBean);
				break;
		}
		return mensaje;
	}
	
	public List lista(int tipoLista, ActivosBean activosBean){
		List listaBean = null;
		
		switch(tipoLista){
			case Enum_Lis_Activos.listaActivos:
				listaBean = activosDAO.listaActivos(tipoLista, activosBean);
				break;
		}
		
		return listaBean;
	}

	public ActivosBean consulta(int tipoConsulta, ActivosBean activosBean){
		ActivosBean consultabean = null;
		
		switch(tipoConsulta){
			case Enum_Con_Activos.activo:
				consultabean = activosDAO.consultaActivos(tipoConsulta, activosBean);
				break;
		}
		
		return consultabean;
	}
	
	public ActivosDAO getActivosDAO() {
		return activosDAO;
	}

	public void setActivosDAO(ActivosDAO activosDAO) {
		this.activosDAO = activosDAO;
	}

}
