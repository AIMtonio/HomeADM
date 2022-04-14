package pld.servicio;

import java.util.List;

import pld.bean.PLDListaNegrasBean;
import pld.bean.SeguimientoPersonaListaBean;
import pld.dao.SeguimientoPersonaListaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SeguimientoPersonaListaServicio extends BaseServicio{

	SeguimientoPersonaListaDAO seguimientoPersonaListaDAO = null;
	
	public static interface Enum_Tra_SeguimientoPersonaLista {
		int alta   = 1;
		int modificacion =2;
	}

	public static interface Enum_Con_SeguimientoPersonaLista {
		int principal   = 1;
		int permite		= 2;
	}
	public static interface Enum_Lis_SeguimientoPersonaLista {
		int principal   = 1;
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SeguimientoPersonaListaBean seguimientoPersonaListaBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_SeguimientoPersonaLista.modificacion:
				mensaje = seguimientoPersonaListaDAO.modificacion(seguimientoPersonaListaBean);
			break;
			
		}
		return mensaje;
	}
	
	public SeguimientoPersonaListaBean consulta(int tipoConsulta, SeguimientoPersonaListaBean seguimientoPersonaListaBean){
		SeguimientoPersonaListaBean seguimientoPersona = null;
		switch(tipoConsulta){
			case Enum_Con_SeguimientoPersonaLista.principal:
				seguimientoPersona = seguimientoPersonaListaDAO.consultaPrincipal(seguimientoPersonaListaBean,tipoConsulta);
			break;	
			case Enum_Con_SeguimientoPersonaLista.permite:
				seguimientoPersona = seguimientoPersonaListaDAO.consultaPermite(seguimientoPersonaListaBean,tipoConsulta);
			break;
			
		}
		return seguimientoPersona;
	}
	
	public List lista(int tipoLista, SeguimientoPersonaListaBean seguimientoPersonaListaBean){		
		List listaSeguimiento = null;
		switch (tipoLista) {
			case Enum_Lis_SeguimientoPersonaLista.principal:		
				listaSeguimiento=  seguimientoPersonaListaDAO.listaPrincipal(seguimientoPersonaListaBean, tipoLista);				
				break;
		}		
		return listaSeguimiento;
	}
	
	
	public SeguimientoPersonaListaDAO getSeguimientoPersonaListaDAO() {
		return seguimientoPersonaListaDAO;
	}
	public void setSeguimientoPersonaListaDAO(
			SeguimientoPersonaListaDAO seguimientoPersonaListaDAO) {
		this.seguimientoPersonaListaDAO = seguimientoPersonaListaDAO;
	}
	
	
	
}
