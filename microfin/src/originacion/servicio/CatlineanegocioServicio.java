package originacion.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import originacion.dao.CatlineanegocioDAO;

import cliente.bean.TiposDireccionBean;
import cliente.dao.TiposDireccionDAO;
import cliente.servicio.TiposDireccionServicio.Enum_Con_TiposDir;
import cliente.servicio.TiposDireccionServicio.Enum_Lis_TiposDir;

public class CatlineanegocioServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	CatlineanegocioDAO catlineanegocioDAO = null;


	public static interface Enum_Lis_LinNegocio {
		int principal 		= 1;
		int combo 			= 2;
		int agropecuario 	= 3;
	}

	public CatlineanegocioServicio () {
		super();
		// TODO Auto-generated constructor stub
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		
		List listaLineaNego = null;
		
		switch(tipoLista){
			case (Enum_Lis_LinNegocio.combo): 
				listaLineaNego =  catlineanegocioDAO.lineasNegocioCombo(tipoLista);
				break;
			case (Enum_Lis_LinNegocio.agropecuario): 
				listaLineaNego =  catlineanegocioDAO.lineasNegocioCombo(tipoLista);
				break;
			
		}
		
		return listaLineaNego.toArray();		
	}



// getters y setters

	public CatlineanegocioDAO getCatlineanegocioDAO() {
		return catlineanegocioDAO;
	}

	public void setCatlineanegocioDAO(CatlineanegocioDAO catlineanegocioDAO) {
		this.catlineanegocioDAO = catlineanegocioDAO;
	}
	
	


}
