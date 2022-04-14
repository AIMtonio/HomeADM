package fira.servicio;
    
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import java.util.List;

import fira.bean.CreLimiteQuitasFiraBean;
import fira.dao.CreLimiteQuitasFiraDAO;

public class CreLimiteQuitasFiraServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	CreLimiteQuitasFiraDAO creLimiteQuitasFiraDAO = null;			
	
	//------------Constantes------------------
	 
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_CreLimiteQuitas {
		int principal 		= 1;
		int proCreClaPu 	= 2;		
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_CreLimiteQuitas {
		int principal 			= 1;
		int prodsCreApl			=3;
	}
	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
	public static interface Enum_Tra_CreLimiteQuitas {
		int alta = 1;
	}
	
	public static interface Enum_Act_CreLimiteQuitas {
		int autoriza = 1;
	}
	
	public CreLimiteQuitasFiraServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CreLimiteQuitasFiraBean creLimiteQuitasFiraBean){
		MensajeTransaccionBean mensaje = null;		
		switch (tipoTransaccion) {
			case Enum_Tra_CreLimiteQuitas.alta:		
				mensaje =  creLimiteQuitasFiraDAO.altaLimiteQuitas(creLimiteQuitasFiraBean);	
				break;		
		}
		return mensaje;
	}

	public CreLimiteQuitasFiraBean consulta(int tipoConsulta, CreLimiteQuitasFiraBean creLimiteQuitasFiraBean){
		CreLimiteQuitasFiraBean creLimiteQuitasCon = null;
		switch (tipoConsulta) {
			case Enum_Con_CreLimiteQuitas.principal:		
				//creLimiteQuitasCon = creditosDAO.consultaPrincipal(creditosBean, tipoConsulta);				
				break;
			case Enum_Con_CreLimiteQuitas.proCreClaPu:		
				creLimiteQuitasCon = creLimiteQuitasFiraDAO.consultaLimQuitasProCrePuesto(creLimiteQuitasFiraBean, tipoConsulta);				
				break;	
		}
		return creLimiteQuitasCon;
	}
	
		
	public List lista(int tipoLista, CreLimiteQuitasFiraBean creLimiteQuitasFiraBean){		
		List listaCreLimiteQuitas = null;
		switch (tipoLista) {
			case Enum_Lis_CreLimiteQuitas.principal:		
				listaCreLimiteQuitas = creLimiteQuitasFiraDAO.consultaGridDetallesPuestos(creLimiteQuitasFiraBean, tipoLista);
				break;	
			case Enum_Lis_CreLimiteQuitas.prodsCreApl:		
				listaCreLimiteQuitas = creLimiteQuitasFiraDAO.conProdsCreAplica(creLimiteQuitasFiraBean, tipoLista);
				break;	
				
		}		
		return listaCreLimiteQuitas;
	}


	//------------------ Getters y Setters ------------------------------------------------------	

	
	public CreLimiteQuitasFiraDAO getCreLimiteQuitasFiraDAO() {
		return creLimiteQuitasFiraDAO;
	}


	public void setCreLimiteQuitasFiraDAO(
			CreLimiteQuitasFiraDAO creLimiteQuitasFiraDAO) {
		this.creLimiteQuitasFiraDAO = creLimiteQuitasFiraDAO;
	}

}

