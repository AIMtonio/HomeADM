package pld.servicio;

import general.dao.BaseDAO;
import general.servicio.BaseServicio;
import gestionComecial.bean.PuestosBean;
import gestionComecial.servicio.PuestosServicio.Enum_Con_Puestos;

import java.util.List;

import pld.bean.PeriodosReelevantesBean;
import pld.dao.EstadosPreocupantesDAO;
import pld.dao.PeriodosReelevantesDAO;
import pld.servicio.EstadosPreocupantesServicio.Enum_Lis_EstadosPreocupantes;

public class PeriodosReelevantesServicio extends BaseServicio{

	private PeriodosReelevantesServicio(){
		super();
	}

	PeriodosReelevantesDAO periodosReelevantesDAO = null;


	public static interface Enum_Lis_PeriodosRee{
		int principal = 1;

	}
	
	public static interface Enum_Con_PeriodosRee{
		int principal = 1;
	}



	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		
		List listaPeriodosReelevantes = null;
		
		switch(tipoLista){
			case (Enum_Lis_PeriodosRee.principal): 
				listaPeriodosReelevantes =  periodosReelevantesDAO.listaPrincipal(tipoLista);
				break;
			
		}
		
		return listaPeriodosReelevantes.toArray();		
	}
	
	public PeriodosReelevantesBean consulta(int tipoConsulta, PeriodosReelevantesBean periodos){
		PeriodosReelevantesBean periodosReelevantesBean = null;
		switch(tipoConsulta){
			case Enum_Con_PeriodosRee.principal:
				periodosReelevantesBean = periodosReelevantesDAO.consultaPeriodo(periodos, Enum_Con_PeriodosRee.principal);
			break;
			}
		return periodosReelevantesBean;
	}

	public PeriodosReelevantesDAO getPeriodosReelevantesDAO() {
		return periodosReelevantesDAO;
	}

	public void setPeriodosReelevantesDAO(
			PeriodosReelevantesDAO periodosReelevantesDAO) {
		this.periodosReelevantesDAO = periodosReelevantesDAO;
	}

	



}
