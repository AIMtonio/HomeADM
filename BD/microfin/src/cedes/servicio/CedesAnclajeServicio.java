package cedes.servicio;

import java.util.List;

import cedes.bean.CedesAnclajeBean;
import cedes.dao.CedesAnclajeDAO;
import cuentas.servicio.MonedasServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CedesAnclajeServicio extends BaseServicio{
 
	CedesAnclajeDAO cedesAnclajeDAO = null;
	MonedasServicio monedasServicio = null;
	
	//---------- Constructor ------------------------------------------------------------------------
	public CedesAnclajeServicio(){
		super();
	}
			
	
	public static interface Enum_Tra_CedesAnclaje{
		int alta				    = 1;
	}
	
	public static interface Enum_Con_CedesAnclaje {
		int principal 				= 1;
		int foranea					= 2;
		int anclaje                 = 3;
		int anclajeHijo             = 4;
	}
	
	public static interface Enum_Lis_CedesAnclaje {
		int general 	=1;
		int anclaje 	=2;
		int sinAnclaje	=3;
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CedesAnclajeBean cedesAnclajeBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case(Enum_Tra_CedesAnclaje.alta):
				mensaje = cedesAnclajeDAO.alta(cedesAnclajeBean, tipoTransaccion);
				break;
				
		}
				
		return mensaje;
	}
	
	public CedesAnclajeBean consulta(int tipoConsulta, CedesAnclajeBean cedesAnclajeBean){
		
		CedesAnclajeBean cedesAnclaBean = null;
		
		switch(tipoConsulta){
			case(Enum_Con_CedesAnclaje.principal):
				cedesAnclaBean = cedesAnclajeDAO.consultaPrincipal(cedesAnclajeBean, tipoConsulta);
				break;
			case(Enum_Con_CedesAnclaje.foranea):
				cedesAnclaBean = cedesAnclajeDAO.consultaForanea(cedesAnclajeBean, tipoConsulta);
				break;
			case(Enum_Con_CedesAnclaje.anclaje):
				cedesAnclaBean = cedesAnclajeDAO.consultaAnclaje(cedesAnclajeBean, tipoConsulta);
				break;
			case(Enum_Con_CedesAnclaje.anclajeHijo):
				cedesAnclaBean = cedesAnclajeDAO.consultaAnclaje(cedesAnclajeBean, tipoConsulta);
				break;
		}		
		return cedesAnclaBean;		
	}

	public List lista(int tipoLista, CedesAnclajeBean cedesAnclajeBean){
		List inverLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_CedesAnclaje.general:
	        	inverLista = cedesAnclajeDAO.listaPrincipal(cedesAnclajeBean, tipoLista);
	        	break;
	        case  Enum_Lis_CedesAnclaje.anclaje:
	        	inverLista = cedesAnclajeDAO.listaConAnclaje(cedesAnclajeBean, tipoLista);
	        	break;
	        case  Enum_Lis_CedesAnclaje.sinAnclaje:
	        	inverLista = cedesAnclajeDAO.listaSinAnclaje(cedesAnclajeBean, tipoLista);
	        	break;
		}
		return inverLista;
	}

	public CedesAnclajeDAO getCedesAnclajeDAO() {
		return cedesAnclajeDAO;
	}

	public void setCedesAnclajeDAO(CedesAnclajeDAO cedesAnclajeDAO) {
		this.cedesAnclajeDAO = cedesAnclajeDAO;
	}

	public MonedasServicio getMonedasServicio() {
		return monedasServicio;
	}

	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}
	
	
}
