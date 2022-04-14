package soporte.servicio;


import java.util.List;

import tesoreria.bean.CuentasSantanderBean;
import tesoreria.dao.CuentasSantanderDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GeneracionArchPlanosServicio extends BaseServicio {
	CuentasSantanderDAO cuentasSantanderDAO = null;
		
	public static interface Enum_Lis_CuentaSantander {
		int principal = 1; 
	}
	
	public List listaCreaArchivoTxt(int tipoLista, CuentasSantanderBean cuentasSantanderBean){
		List cuentaSantander = null;
		
		switch (tipoLista) {
		    case  Enum_Lis_CuentaSantander.principal:
		    	cuentaSantander = cuentasSantanderDAO.listaPrincipal(cuentasSantanderBean, tipoLista);
		    break;
		   
		}
		return cuentaSantander;
	}

	public CuentasSantanderDAO getCuentasSantanderDAO() {
		return cuentasSantanderDAO;
	}

	public void setCuentasSantanderDAO(CuentasSantanderDAO cuentasSantanderDAO) {
		this.cuentasSantanderDAO = cuentasSantanderDAO;
	}
	

}
