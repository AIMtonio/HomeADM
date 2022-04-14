package cliente.servicio;

import herramientas.Utileria;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;
import cliente.bean.PaisesBean;
import cliente.dao.PaisesDAO;

import cliente.servicio.PaisesServicio.Enum_Con_Paises;
import cliente.servicio.PaisesServicio.Enum_Lis_Paises;

public class PaisesServicio extends BaseServicio {
	
	//---------- Variables ------------------------------------------------------------------------
	PaisesDAO paisesDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Paises {
		int principal   = 1;
		int foranea     = 2;
		int regulatorio = 3;
		int paisesSAT	= 4;
		int paisesResExt= 5;
		int tasasISRResExt = 6;
	}

	public static interface Enum_Lis_Paises {
		int principal   = 1;
		int regulatorio =2;
		int paisesSAT = 3;
		int tasasISRResExt = 4;
		int paisesResExt = 5;
	}

	
	public PaisesServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
	public PaisesBean consultaPaises(int tipoConsulta, String paisesID){
		PaisesBean paises = null;
		switch (tipoConsulta) {
		    case Enum_Con_Paises.principal:
		        paises = paisesDAO.consultaPais(Long.parseLong(paisesID),tipoConsulta);
		       break;
		    case Enum_Con_Paises.regulatorio:
		        paises = paisesDAO.consultaPaisCNBV(Long.parseLong(paisesID),Enum_Con_Paises.regulatorio);
		       break;
		    case Enum_Con_Paises.foranea:
		        paises = paisesDAO.consultaPaisForanea(Long.parseLong(paisesID),Enum_Con_Paises.foranea);
		       break;
		    case Enum_Con_Paises.paisesSAT:
		        paises = paisesDAO.consultaPaisDIOT(paisesID,Enum_Con_Paises.paisesSAT);
		       break;
		    case Enum_Con_Paises.paisesResExt:
		        paises = paisesDAO.consultaResExt(paisesID,tipoConsulta);
		       break;
		    case Enum_Con_Paises.tasasISRResExt:
		        paises = paisesDAO.consultaPais(Long.parseLong(paisesID),tipoConsulta);
		       break;
		}
		return paises;
	}
	

	
	public List lista(int tipoLista, PaisesBean paises){		
		List listaPaises = null;
		switch (tipoLista) {
			case Enum_Lis_Paises.principal:		
				listaPaises=  paisesDAO.listaPaises(paises,tipoLista);				
				break;	
			case Enum_Lis_Paises.regulatorio:		
				listaPaises=  paisesDAO.listaPaisesCNBV(paises,tipoLista);				
				break;
			case Enum_Lis_Paises.paisesSAT:		
				listaPaises=  paisesDAO.listaPaisesDIOT(paises,tipoLista);				
				break;
			case Enum_Lis_Paises.tasasISRResExt:		
				listaPaises = paisesDAO.listaPaises(paises,tipoLista);				
				break;
			case Enum_Lis_Paises.paisesResExt:		
				listaPaises = paisesDAO.listaPaises(paises,tipoLista);				
				break;
		}		
		return listaPaises;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setPaisesDAO(PaisesDAO paisesDAO) {
		this.paisesDAO = paisesDAO;
	}	
	

}
