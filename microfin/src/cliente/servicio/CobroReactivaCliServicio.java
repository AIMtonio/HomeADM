package cliente.servicio;

import java.util.List;

import cliente.bean.CobroReactivaCliBean;
import cliente.dao.CobroReactivaCliDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CobroReactivaCliServicio  extends BaseServicio{
	
	    // Variables 
		CobroReactivaCliDAO cobroReactivaCliDAO = null;
		
	    // tipo de consulta
		
	    public static interface Enum_Con_CobroReactivaCli { 
					int principal = 1;
				}
	  		
		public CobroReactivaCliServicio() {
			super();
		}
		
		public CobroReactivaCliBean consulta(int tipoConsulta,CobroReactivaCliBean cobroreact){
			
			CobroReactivaCliBean cobroReactivaCliBean = null;
			switch (tipoConsulta) {
				case Enum_Con_CobroReactivaCli.principal:		
					cobroReactivaCliBean = cobroReactivaCliDAO.consultaCobroReactivaCli(cobroreact, Enum_Con_CobroReactivaCli.principal);				
					break;				
			}
				
			return cobroReactivaCliBean;
		}

		//------------------ Getters y Setters ------------------------------------------------------
		
		public CobroReactivaCliDAO getCobroReactivaCliDAO() {
			return cobroReactivaCliDAO;
		}

		public void setCobroReactivaCliDAO(CobroReactivaCliDAO cobroReactivaCliDAO) {
			this.cobroReactivaCliDAO = cobroReactivaCliDAO;
		}
					
	
		
	
}


