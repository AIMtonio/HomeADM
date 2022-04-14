package tarjetas.servicio;

import java.util.ArrayList;
import java.util.List;

import originacion.bean.ClidatsocioeBean;
import originacion.servicio.ClidatsocioeServicio.Enum_Lis_DatosSocioE;
import tarjetas.bean.DestinatariosCorreoFTPProsaBean;
import tarjetas.dao.DestinatariosCorreoFTPProsaDAO;
import general.servicio.BaseServicio;

public class DestinatariosCorreoFTPProsaServicio extends BaseServicio {
	DestinatariosCorreoFTPProsaDAO destinatariosCorreoFTPProsaDAO = null;
	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_DestinaProsa {
		int alta = 1;
		int modificacion = 2;
		int grabaListaSocioEcon =3;
	}
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_DestinaProsa {
		int principal 		= 1;	
		int gridDatosSocioe	= 2;
		
	}
	
	public List lista(int tipoLista, DestinatariosCorreoFTPProsaBean destinatariosCorreoFTPProsaBean){		
		List listaDatosSocioEco =(List) new ArrayList();
		switch (tipoLista) {
			case Enum_Lis_DatosSocioE.principal:		
				listaDatosSocioEco = destinatariosCorreoFTPProsaDAO.listaDestinatariosPantalla(destinatariosCorreoFTPProsaBean, tipoLista);				
				break;
			
		}			
		return listaDatosSocioEco;
	}

	public DestinatariosCorreoFTPProsaDAO getDestinatariosCorreoFTPProsaDAO() {
		return destinatariosCorreoFTPProsaDAO;
	}

	public void setDestinatariosCorreoFTPProsaDAO(
			DestinatariosCorreoFTPProsaDAO destinatariosCorreoFTPProsaDAO) {
		this.destinatariosCorreoFTPProsaDAO = destinatariosCorreoFTPProsaDAO;
	}


}
