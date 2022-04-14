package pld.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import pld.bean.MotivosInuBean;
import pld.bean.MotivosPreoBean;
import pld.dao.MotivosInuDAO;
import pld.dao.MotivosPreoDAO;
import pld.servicio.MotivosPreoServicio.Enum_Con_MotivosPreo;
import pld.servicio.MotivosPreoServicio.Enum_Lis_MotivosPreo;

public class MotivosInuServicio extends BaseServicio {

	private MotivosInuServicio(){
		super();
	}

	MotivosInuDAO motivosInuDAO = null;

	public static interface Enum_Lis_MotivosInu{
		int alfanumerica = 1;
		int listaExterno = 2;
	}
	
	public static interface Enum_Con_MotivosInu{
		int principal = 1;
		int principalExterna=2;
		
	}
	
	public List lista(int tipoLista, MotivosInuBean motivosInu){		
		List listaMotivosInu = null;
		switch (tipoLista) {
			case Enum_Lis_MotivosInu.alfanumerica:		
				listaMotivosInu=  motivosInuDAO.listaAlfanumerica(motivosInu, Enum_Lis_MotivosInu.alfanumerica);				
				break;	
			case Enum_Lis_MotivosInu.listaExterno:		
				listaMotivosInu=  motivosInuDAO.listaAlfExterno(motivosInu, Enum_Lis_MotivosInu.alfanumerica);				
				break;	
		}		
		return listaMotivosInu;
	}
	
	public MotivosInuBean consulta(int tipoConsulta, MotivosInuBean motivosInu){
		MotivosInuBean motivosInuBean = null;
		switch(tipoConsulta){
			case Enum_Con_MotivosInu.principal:
				motivosInuBean = motivosInuDAO.consultaPrincipal(motivosInu, Enum_Con_MotivosInu.principal);
			break;
			case Enum_Con_MotivosInu.principalExterna:
				motivosInuBean = motivosInuDAO.consultaPrincipalExterna(motivosInu, Enum_Con_MotivosInu.principal);
			break;
		}
		return motivosInuBean;
		
	}

	public MotivosInuDAO getMotivosInuDAO() {
		return motivosInuDAO;
	}

	public void setMotivosInuDAO(MotivosInuDAO motivosInuDAO) {
		this.motivosInuDAO = motivosInuDAO;
	}
}
	
		
	
	/*
	
	*/
	
	