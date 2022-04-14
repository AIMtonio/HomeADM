package credito.servicio;
    
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import java.util.List;

import credito.bean.CreLimiteQuitasBean;
import credito.dao.CreLimiteQuitasDAO;

public class CreLimiteQuitasServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	CreLimiteQuitasDAO creLimiteQuitasDAO = null;			
	
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
	
	public CreLimiteQuitasServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CreLimiteQuitasBean creLimiteQuitasBean){
		MensajeTransaccionBean mensaje = null;		
		switch (tipoTransaccion) {
			case Enum_Tra_CreLimiteQuitas.alta:		
				mensaje =  creLimiteQuitasDAO.altaLimiteQuitas(creLimiteQuitasBean);	
				break;		
		}
		return mensaje;
	}

	public CreLimiteQuitasBean consulta(int tipoConsulta, CreLimiteQuitasBean creLimiteQuitasBean){
		CreLimiteQuitasBean creLimiteQuitasCon = null;
		switch (tipoConsulta) {
			case Enum_Con_CreLimiteQuitas.principal:		
				//creLimiteQuitasCon = creditosDAO.consultaPrincipal(creditosBean, tipoConsulta);				
				break;
			case Enum_Con_CreLimiteQuitas.proCreClaPu:		
				creLimiteQuitasCon = creLimiteQuitasDAO.consultaLimQuitasProCrePuesto(creLimiteQuitasBean, tipoConsulta);				
				break;	
		}
		return creLimiteQuitasCon;
	}
	
		
	public List lista(int tipoLista, CreLimiteQuitasBean creLimiteQuitasBean){		
		List listaCreLimiteQuitas = null;
		switch (tipoLista) {
			case Enum_Lis_CreLimiteQuitas.principal:		
				listaCreLimiteQuitas = creLimiteQuitasDAO.consultaGridDetallesPuestos(creLimiteQuitasBean, tipoLista);
				break;	
			case Enum_Lis_CreLimiteQuitas.prodsCreApl:		
				listaCreLimiteQuitas = creLimiteQuitasDAO.conProdsCreAplica(creLimiteQuitasBean, tipoLista);
				break;	
				
		}		
		return listaCreLimiteQuitas;
	}


	
	//------------------ Getters y Setters ------------------------------------------------------	
	public CreLimiteQuitasDAO getCreLimiteQuitasDAO() {
		return creLimiteQuitasDAO;
	}


	public void setCreLimiteQuitasDAO(CreLimiteQuitasDAO creLimiteQuitasDAO) {
		this.creLimiteQuitasDAO = creLimiteQuitasDAO;
	}
}

