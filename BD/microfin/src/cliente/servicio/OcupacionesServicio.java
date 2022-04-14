package cliente.servicio;

import herramientas.Utileria;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;
import cliente.bean.OcupacionesBean;
import cliente.dao.OcupacionesDAO;
import cliente.servicio.ClienteServicio.Enum_Tra_Cliente;


public class OcupacionesServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	OcupacionesDAO ocupacionesDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Ocupacion {
		int principal = 1;
		int foranea = 2;
				
	}

	public static interface Enum_Lis_Ocupacion {
		int principal = 1;
	}

	
	public OcupacionesServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
	public OcupacionesBean consultaOcupacion(int tipoConsulta, String ocupacionID){
		OcupacionesBean ocupaciones = null;
		switch(tipoConsulta){
			case Enum_Con_Ocupacion.principal:
				ocupaciones = ocupacionesDAO.consultaOcupacion(Long.parseLong(ocupacionID),
						Enum_Con_Ocupacion.principal);
			break;
			case Enum_Con_Ocupacion.foranea:
				ocupaciones = ocupacionesDAO.consultaOcupacion(Long.parseLong(ocupacionID),tipoConsulta);
			break;
		}
		
		
		
		return ocupaciones;
	}
	

	
	public List lista(int tipoLista, OcupacionesBean ocupaciones){		
		List listaOcupaciones = null;
		switch (tipoLista) {
			case Enum_Lis_Ocupacion.principal:		
				listaOcupaciones=  ocupacionesDAO.listaOcupaciones(ocupaciones,tipoLista);				
				break;				
		}		
		return listaOcupaciones;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setOcupacionesDAO(OcupacionesDAO ocupacionesDAO) {
		this.ocupacionesDAO = ocupacionesDAO;
	}	
	

}
