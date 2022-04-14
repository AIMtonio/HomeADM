package pld.servicio;

import general.servicio.BaseServicio;
import gestionComecial.bean.AreasBean;
import gestionComecial.dao.AreasDAO;
import gestionComecial.servicio.AreasServicio.Enum_Lis_Areas;

import java.util.List;

import pld.bean.MotivosPreoBean;
import pld.bean.OpIntPreocupantesBean;
import pld.dao.MotivosPreoDAO;
import pld.servicio.OpIntPreocupantesServicio.Enum_Con_OpIntPreocupantes;

public class MotivosPreoServicio extends BaseServicio {

	private MotivosPreoServicio(){
		super();
	}

	MotivosPreoDAO motivosPreoDAO = null;

	public static interface Enum_Lis_MotivosPreo{
		int alfanumerica = 1;
		int alfanumericaExterna=2;
	}
	
	public static interface Enum_Con_MotivosPreo{
		int principal = 1;
		int principalExterna=2;
	}
	
	public List lista(int tipoLista, MotivosPreoBean motivosPreo){		
		List listaMotivosPreo = null;
		switch (tipoLista) {
			case Enum_Lis_MotivosPreo.alfanumerica:		
				listaMotivosPreo=  motivosPreoDAO.listaAlfanumerica(motivosPreo, Enum_Lis_MotivosPreo.alfanumerica);				
				break;
			case Enum_Lis_MotivosPreo.alfanumericaExterna:		
				listaMotivosPreo=  motivosPreoDAO.listaAlfanumericaExterna(motivosPreo, Enum_Lis_MotivosPreo.alfanumerica);				
				break;
		}		
		return listaMotivosPreo;
	}
	
		
	
	public MotivosPreoBean consulta(int tipoConsulta, MotivosPreoBean motivosPreo){
		MotivosPreoBean motivosPreoBean = null;
		switch(tipoConsulta){
			case Enum_Con_MotivosPreo.principal:
				motivosPreoBean = motivosPreoDAO.consultaPrincipal(motivosPreo, Enum_Con_MotivosPreo.principal);
			break;
			case Enum_Con_MotivosPreo.principalExterna:
				motivosPreoBean = motivosPreoDAO.consultaPrincipalExterna(motivosPreo, Enum_Con_MotivosPreo.principal);
			break;
		}
		return motivosPreoBean;
		
	}
	
	
	
	public void setMotivosPreoDAO(MotivosPreoDAO motivosPreoDAO ){
		this.motivosPreoDAO = motivosPreoDAO;
	}

	public MotivosPreoDAO getMotivosPreoDAO() {
		return motivosPreoDAO;
	}

}
