package cliente.servicio;
import herramientas.Utileria;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import cliente.bean.TiposDireccionBean;
import cliente.dao.TiposDireccionDAO;
import cliente.servicio.DireccionesClienteServicio.Enum_Con_DireccionesCliente;



public class TiposDireccionServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	TiposDireccionDAO direccionesDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_TiposDir {
		int principal = 1;
		int foranea = 2;
		int tdirec=3;
	}

	public static interface Enum_Lis_TiposDir {
		int principal = 1;
	}

	public TiposDireccionServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
	public TiposDireccionBean consulta(int tipoConsulta, String tipoDireccionID){
		TiposDireccionBean direcciones = null;
		switch (tipoConsulta) {
		case Enum_Con_TiposDir.principal:	
			direcciones = direccionesDAO.consultaPrincipal(Integer.parseInt(tipoDireccionID),Enum_Con_TiposDir.principal);
			break;	
		case Enum_Con_TiposDir.foranea:	
			direcciones = direccionesDAO.consultaForanea(Integer.parseInt(tipoDireccionID),Enum_Con_TiposDir.foranea);
			break;	
	
		}
		
		return direcciones;
	}
	

	
	public List lista(int tipoLista,TiposDireccionBean direcciones){		
		List listaTiposDir = null;
		switch (tipoLista) {
			case Enum_Lis_TiposDir.principal:		
				listaTiposDir=  direccionesDAO.listaTiposDirec(direcciones,tipoLista);				
				break;				
		}		
		return listaTiposDir;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoConsulta) {
		
		List listaTdirec = null;
		
		switch(tipoConsulta){
			case (Enum_Con_TiposDir.tdirec): 
				 listaTdirec =  direccionesDAO.listaTiposDireccionC(tipoConsulta);
				break;
			
		}
		
		return listaTdirec.toArray();		
	}
	
	
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setTiposDireccionDAO(TiposDireccionDAO direccionesDAO) {
		this.direccionesDAO = direccionesDAO;
	}	
	

}
