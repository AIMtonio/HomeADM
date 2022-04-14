package pld.servicio;


import java.util.List;

import javax.servlet.http.HttpServletResponse;

import pld.bean.SociosAltoRiesgoRepBean;
import pld.dao.SociosAltoRiesgoRepDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class SociosAltoRiesgoRepServicio extends BaseServicio{

	public static interface Enum_Lis_SociosAltoRiesgo {
		int sociosAltoRiesgo = 1;
	}
	
	
	private SociosAltoRiesgoRepServicio(){
		super();
	}
	
	SociosAltoRiesgoRepDAO sociosAltoRiesgoRepDAO = null;
	
	

	public List listaSociosAltoRiesgoRep(int tipoLista, 
			SociosAltoRiesgoRepBean sociosAltoRiesgoRepBean, 
					HttpServletResponse response){
		List listaSociosAltoRiesgo=null;
			switch(tipoLista){		
			case Enum_Lis_SociosAltoRiesgo.sociosAltoRiesgo:
				listaSociosAltoRiesgo = sociosAltoRiesgoRepDAO.sociosAltoRiesgo(sociosAltoRiesgoRepBean, tipoLista); 
			break;	
			}

return listaSociosAltoRiesgo;
}

	public SociosAltoRiesgoRepDAO getSociosAltoRiesgoRepDAO() {
		return sociosAltoRiesgoRepDAO;
	}

	public void setSociosAltoRiesgoRepDAO(
			SociosAltoRiesgoRepDAO sociosAltoRiesgoRepDAO) {
		this.sociosAltoRiesgoRepDAO = sociosAltoRiesgoRepDAO;
	}
	


	
}
