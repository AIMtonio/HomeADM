package credito.servicio;

import java.util.List;

import credito.bean.ServiciosSolCredBean;
import credito.dao.ServiciosSolCredDAO;
import general.servicio.BaseServicio;

public class ServiciosSolCredServicio extends BaseServicio {
	
	private ServiciosSolCredDAO serviciosSolCredDAO;
	
	public static interface Enum_Tra_ServiciosAdicionales{
		int alta = 1; //Alta de servicios adicinales
	};
	
	public static interface Enum_Lis_ServicioAdicional {
		int solCred = 2; //Consulta de servicios adicionales por solicitud crédito y/o crédito
	}
	
	public List lista(int tipoLista, ServiciosSolCredBean serviciosSolCredBean){		
		List listaServiciosAdicionales = null;
		switch (tipoLista) {
			case Enum_Lis_ServicioAdicional.solCred:
			listaServiciosAdicionales = serviciosSolCredDAO.listaServicioSolicitudCredito(tipoLista, serviciosSolCredBean);
			break;
		}
		return listaServiciosAdicionales;
	}
	
	public ServiciosSolCredDAO getServiciosSolCredDAO() {
		return serviciosSolCredDAO;
	}

	public void setServiciosSolCredDAO(ServiciosSolCredDAO serviciosSolCredDAO) {
		this.serviciosSolCredDAO = serviciosSolCredDAO;
	}

}
