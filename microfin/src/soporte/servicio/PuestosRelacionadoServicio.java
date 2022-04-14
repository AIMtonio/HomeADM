package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import soporte.bean.PuestosRelacionadoBean;
import soporte.dao.PuestosRelacionadoDAO;




public class PuestosRelacionadoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	PuestosRelacionadoDAO puestosRelacionadoDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Puestos {
		int principal = 1;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Puestos {
		int principal = 1;
		int foranea   = 2;
		int plazas    = 3;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Puestos {
		int alta = 1;
		int modificacion = 2;
	}
	
	public PuestosRelacionadoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PuestosRelacionadoBean cargos){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Puestos.alta:		
				mensaje = altaCargos(cargos);				
				break;				
			case Enum_Tra_Puestos.modificacion:
				mensaje = modificaCargos(cargos);				
				break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaCargos(PuestosRelacionadoBean puestos){
		MensajeTransaccionBean mensaje = null;		
		mensaje = puestosRelacionadoDAO.alta(puestos);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaCargos(PuestosRelacionadoBean puestos){
		MensajeTransaccionBean mensaje = null;
		mensaje = puestosRelacionadoDAO.modifica(puestos);		
		return mensaje;
	}
	
	
	public PuestosRelacionadoBean consulta(int tipoConsulta, PuestosRelacionadoBean puestosBean){
		PuestosRelacionadoBean puestos = null;
		switch (tipoConsulta) {
		
			case Enum_Con_Puestos.principal:		
				puestos = puestosRelacionadoDAO.consultaPrincipal(puestosBean, tipoConsulta);				
				break;	
			
		}
				
		return puestos;
	}
	
	public List lista(int tipoLista,PuestosRelacionadoBean puestosBean){		
		List listaCargos = null;
		switch (tipoLista) {
			case Enum_Lis_Puestos.principal:
				listaCargos = puestosRelacionadoDAO.listaPrincipal(puestosBean, tipoLista);
				break;
		}
		return listaCargos;
	}


	public PuestosRelacionadoDAO getPuestosRelacionadoDAO() {
		return puestosRelacionadoDAO;
	}


	public void setPuestosRelacionadoDAO(PuestosRelacionadoDAO puestosRelacionadoDAO) {
		this.puestosRelacionadoDAO = puestosRelacionadoDAO;
	}


	
	
	
		

		
}

