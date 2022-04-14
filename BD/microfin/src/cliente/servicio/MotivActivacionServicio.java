package cliente.servicio;

import java.util.List;

import cliente.bean.MotivActivacionBean;
import cliente.dao.MotivActivacionDAO;
import general.servicio.BaseServicio;

public class MotivActivacionServicio extends BaseServicio{
	MotivActivacionDAO motivActivacionDAO = null;

	public static interface Enum_Con_Motivos {
		int principal = 1;
		int foranea = 2;
	}
	
	public static interface Enum_Lis_Motivos {
		int principal = 1;
		int foranea = 2;
		int comboMotivos = 3; 
		int motivosNoMuerte = 4; 
	}
	
	
	public MotivActivacionServicio(){
		super();
	}  
	
	public MotivActivacionBean consulta(MotivActivacionBean motivActivaBean, int tipoConsulta){
		MotivActivacionBean motivoBean = null;
		switch(tipoConsulta){
			case Enum_Con_Motivos.principal:
				motivoBean = motivActivacionDAO.consultaPrincipal(motivActivaBean, tipoConsulta);
			break;
		}
		return motivoBean;
	}
	
	public List lista(MotivActivacionBean motivActiva, int tipoLista){
		List listaMotivos = null;
		switch(tipoLista){
			case Enum_Lis_Motivos.principal:
				listaMotivos = motivActivacionDAO.listaMotivosActivacion(motivActiva, tipoLista);
			break;
		}
		return listaMotivos;
	}

	// listas para comboBox 
	public  Object[] listaCombo(MotivActivacionBean motivActiva, int tipoLista) {
		List listaConceptosAhorro = null;
		switch(tipoLista){
			case (Enum_Lis_Motivos.comboMotivos): 
				listaConceptosAhorro = motivActivacionDAO.listaMotivosActiva(motivActiva, tipoLista);
				break;
			case (Enum_Lis_Motivos.motivosNoMuerte): 
				listaConceptosAhorro = motivActivacionDAO.listaMotivosActiva(motivActiva, tipoLista);
				break;
		}
		return listaConceptosAhorro.toArray();		
	}

	public MotivActivacionDAO getMotivActivacionDAO() {
		return motivActivacionDAO;
	}

	public void setMotivActivacionDAO(MotivActivacionDAO motivActivacionDAO) {
		this.motivActivacionDAO = motivActivacionDAO;
	}
	
	
}
