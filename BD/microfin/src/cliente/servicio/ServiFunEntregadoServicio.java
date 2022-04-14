package cliente.servicio;

import java.util.List;

import cliente.bean.ServiFunEntregadoBean;
import cliente.dao.ServiFunEntregadoDAO;
import cliente.servicio.ServiFunFoliosServicio.Enum_Con_serviFunFolios;
import general.servicio.BaseServicio;

public class ServiFunEntregadoServicio extends BaseServicio{
	ServiFunEntregadoDAO serviFunEntregadoDAO	=null;
	
	public static interface Enum_Lis_ServifunEntregado{
		int beneficiarios = 2;					
	}

	public static interface Enum_Con_ServifunEntregado {
		int principal=1;		
	}
	
	// ---------- Consulta ----
	public ServiFunEntregadoBean consulta(int tipoConsulta, ServiFunEntregadoBean serviFunEntregadoBean){
		ServiFunEntregadoBean serviFunEntregado = null;
		switch(tipoConsulta){
			case Enum_Con_serviFunFolios.principal:
				serviFunEntregado = serviFunEntregadoDAO.consultaPrincipal(serviFunEntregadoBean,tipoConsulta);
			break;

		}
		return serviFunEntregado;
		
	}
	
//---------------settter y setter --------------------
	public ServiFunEntregadoDAO getServiFunEntregadoDAO() {
		return serviFunEntregadoDAO;
	}

	public void setServiFunEntregadoDAO(ServiFunEntregadoDAO serviFunEntregadoDAO) {
		this.serviFunEntregadoDAO = serviFunEntregadoDAO;
	}
	 
	 
	 
}
