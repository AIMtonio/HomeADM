package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;


import credito.bean.DestinosCreditoBean;
import credito.bean.LineasCreditoBean;
import credito.dao.DestinosCreditoDAO;


public class DestinosCreditoServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	DestinosCreditoDAO destinosCreditoDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_DestinoCredito {
		int principal   = 1;
		int porProdCre 	= 2;
	}
	public static interface Enum_Tra_DestinoCredito  {
		int alta = 1;
		int modificacion = 2;

	}
	public static interface Enum_Con_DestinoCredito  {
		int principal = 1;
		int foranea =2;
		int prodCre = 3;
	}
	public DestinosCreditoServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	

	public DestinosCreditoBean consulta(int tipoConsulta, DestinosCreditoBean destinosCredito){
		DestinosCreditoBean destinosCreditoBean = null;
		switch(tipoConsulta){
			case Enum_Con_DestinoCredito.principal:
				destinosCreditoBean = destinosCreditoDAO.consultaPrincipal(destinosCredito, tipoConsulta);
			break;
			case Enum_Con_DestinoCredito.foranea:
				destinosCreditoBean = destinosCreditoDAO.consultaForanea(destinosCredito, tipoConsulta);
			break;
			case Enum_Con_DestinoCredito.prodCre:
				destinosCreditoBean = destinosCreditoDAO.consultaPrincipal(destinosCredito, tipoConsulta);
				break;
		}
		return destinosCreditoBean;
	}
	
	
	
	public List lista(int tipoLista, DestinosCreditoBean destinosCredito){
		List destinoCreditoLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_DestinoCredito.principal:
	        	destinoCreditoLista = destinosCreditoDAO.listaDestinoCredito(destinosCredito, tipoLista);
	        	break;
	        case Enum_Lis_DestinoCredito.porProdCre:
	        	destinoCreditoLista = destinosCreditoDAO.listaDestinoCredito(destinosCredito, tipoLista);
	        	break;
		}
		return destinoCreditoLista;
	}

	//------------------ Geters y Seters ------------------------------------------------------	
	
	public void setDestinosCreditoDAO(DestinosCreditoDAO destinosCreditoDAO) {
		this.destinosCreditoDAO = destinosCreditoDAO;
	}
}
