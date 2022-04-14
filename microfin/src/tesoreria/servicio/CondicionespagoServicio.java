package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;


import tesoreria.bean.CondicionespagoBean;
import tesoreria.dao.CondicionespagoDAO;



public class CondicionespagoServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	CondicionespagoDAO condicionespagoDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_Condiciones{
		int principal   = 1;
		int listacombo  = 2;	
	}
	public static interface Enum_Tra_Condiciones {
		int alta = 1;
		int modificacion = 2;
	}
	
	public static interface Enum_Con_Condiciones {
		int principal = 1;
		int foranea =2;
		int dias =3;
	}
	
	public CondicionespagoServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public CondicionespagoBean consulta(int tipoConsulta, CondicionespagoBean condicionespagoBean){
		CondicionespagoBean condicionespago = null;
		switch(tipoConsulta){
			case Enum_Con_Condiciones.principal:
			// 	condicionespago = condicionespagoDAO.consultaPrincipal();
			break;
			case Enum_Con_Condiciones.dias:
				condicionespago = condicionespagoDAO.consultaDias(condicionespagoBean,Enum_Con_Condiciones.dias);
			break;
		}
		return condicionespago;
	}
	
	// listas para comboBox
			public  Object[] listaCombo(int tipoLista,CondicionespagoBean condicionespagoBean) {
				List listaCondiciones = null;
				switch(tipoLista){
					case (Enum_Lis_Condiciones.listacombo): 
						listaCondiciones =  condicionespagoDAO.listaCondicionespago(condicionespagoBean, tipoLista);
						break;
				}
				return listaCondiciones.toArray();		
			}

	//------------------ Geters y Seters ------------------------------------------------------	
	
			public CondicionespagoDAO getCondicionespagoDAO() {
				return condicionespagoDAO;
			}

			public void setCondicionespagoDAO(CondicionespagoDAO condicionespagoDAO) {
				this.condicionespagoDAO = condicionespagoDAO;
			}

}
