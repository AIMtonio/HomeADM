package seguimiento.servicio;

import java.util.List;

import seguimiento.bean.RegistroGestorBean;
import seguimiento.bean.SegtoRealizadosBean;
import seguimiento.dao.RegistroGestorDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class RegistroGestorServicio extends BaseServicio{
	RegistroGestorDAO registroGestorDAO = null;

	public RegistroGestorServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_Tra_Gestor {
		int altaCliente = 1;
		int altaSucursal = 2;
		int altaZona = 3;
		int altaPromotor = 4;
	}
	  
	public static interface Enum_Con_Gestor{
        int principal		= 1;
        int sucursal 		= 2;
		int zona 		    = 3;
		int promotor        = 4;
	}
	
	public static interface Enum_Con_TipoGestor{
        int principal		= 1;
	}
	
	public static interface Enum_Lis_Gestor{
        int principal		= 1;
        int tipoGestor		= 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RegistroGestorBean registroGestorBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Gestor.altaCliente:
				mensaje = registroGestorDAO.altaCliente(registroGestorBean);
				break;
			case Enum_Tra_Gestor.altaSucursal:
				mensaje = registroGestorDAO.altaSucursal(registroGestorBean);
				break;
			case Enum_Tra_Gestor.altaZona:
				mensaje = registroGestorDAO.altaZona(registroGestorBean);
				break;
			case Enum_Tra_Gestor.altaPromotor:
				mensaje = registroGestorDAO.altaPromotor(registroGestorBean);
				break;
		}
		return mensaje;
	}
	
	public RegistroGestorBean consulta(int tipoConsulta, RegistroGestorBean registroGestorBean){
		RegistroGestorBean registroGestor = null;
		switch(tipoConsulta){
			case Enum_Con_Gestor.principal:
				registroGestor = registroGestorDAO.consultaGestor(tipoConsulta, registroGestorBean);
			break;
			}
		return registroGestor;
	}
	
	public List lista(int tipoLista, RegistroGestorBean registroGestorBean){
		List listaTipoGestor = null;
		switch (tipoLista) {
	        case  Enum_Lis_Gestor.tipoGestor:
	        	listaTipoGestor = registroGestorDAO.listaTipoGestor(registroGestorBean, tipoLista);
	        break;
		}
		return listaTipoGestor;
	}
	
	public  Object[] listaConsulta(int tipoConsulta, RegistroGestorBean registroGestorBean){
		List listaGestor = null;
		switch(tipoConsulta){
			case Enum_Con_Gestor.sucursal:
				listaGestor = registroGestorDAO.consultaSucursalGestor(registroGestorBean, tipoConsulta);
			break;
			case Enum_Con_Gestor.zona:
				listaGestor = registroGestorDAO.consultaZonaGestor(registroGestorBean, tipoConsulta);
			break;
			case Enum_Con_Gestor.promotor:
				listaGestor = registroGestorDAO.consultaPromotorGestor(registroGestorBean, tipoConsulta);
			break;
		}
		return listaGestor.toArray();
	}

	// --------------------getter y setter---------------------	
	public RegistroGestorDAO getRegistroGestorDAO() {
		return registroGestorDAO;
	}

	public void setRegistroGestorDAO(RegistroGestorDAO registroGestorDAO) {
		this.registroGestorDAO = registroGestorDAO;
	}
	
}
