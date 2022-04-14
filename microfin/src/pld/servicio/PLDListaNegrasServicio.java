package pld.servicio;

import java.util.List;

import pld.bean.PLDListaNegrasBean;
import pld.dao.PLDListaNegrasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class PLDListaNegrasServicio extends BaseServicio{
	PLDListaNegrasDAO	pldListaNegrasDAO=null;
	
	//---------- Tipos de transacciones---------------------------------------------------------------
		public static interface Enum_Tra_ListasNegras {
			int alta   = 1;
			int modificacion =2;
		}

		public static interface Enum_Con_ListasNegras {
			int principal   = 1;
		}
		public static interface  Enum_Con_ClieListasNegras {
			int principal   = 2;
			int datosLevenshtein = 3;
			int datosLevMasivo	 = 4;
		}
		public static interface Enum_Lis_ListasNegras {
			int principal   = 1;
		}
		
		
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PLDListaNegrasBean pldListaNegrasBean){
			MensajeTransaccionBean mensaje = null;
			switch(tipoTransaccion){
				case Enum_Tra_ListasNegras.alta:
					mensaje = pldListaNegrasDAO.alta(pldListaNegrasBean, tipoTransaccion);
				break;
				case Enum_Tra_ListasNegras.modificacion:
					mensaje = pldListaNegrasDAO.modificacion(pldListaNegrasBean);
				break;
				
			}
			return mensaje;
		}
		
		public PLDListaNegrasBean consulta(int tipoConsulta, PLDListaNegrasBean pldListaNegrasBean){
			PLDListaNegrasBean pldListaNegras = null;
			switch(tipoConsulta){
				case Enum_Con_ListasNegras.principal:
				pldListaNegras = pldListaNegrasDAO.consultaPrincipal(pldListaNegrasBean,tipoConsulta);
				break;		
				case Enum_Con_ClieListasNegras.principal:
					pldListaNegras = pldListaNegrasDAO.consultaPrincipalClie(pldListaNegrasBean,tipoConsulta);
					break;	
			}
			return pldListaNegras;
		}
		
		public List lista(int tipoLista, PLDListaNegrasBean pldListaNegrasBean){		
			List listaNegra = null;
			switch (tipoLista) {
				case Enum_Lis_ListasNegras.principal:		
					listaNegra=  pldListaNegrasDAO.listaPrincipal( Enum_Lis_ListasNegras.principal,pldListaNegrasBean);				
					break;
			}		
			return listaNegra;
		}
		
		//-----------setter y getter----------------
		public PLDListaNegrasDAO getPldListaNegrasDAO() {
			return pldListaNegrasDAO;
		}

		public void setPldListaNegrasDAO(PLDListaNegrasDAO pldListaNegrasDAO) {
			this.pldListaNegrasDAO = pldListaNegrasDAO;
		}
		
		
		
		
}
