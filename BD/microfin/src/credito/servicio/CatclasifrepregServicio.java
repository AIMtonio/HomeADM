package credito.servicio;

import java.util.List;

import credito.bean.CatclasifrepregBean;
import credito.bean.ClasificCreditoBean;
import credito.dao.CatclasifrepregDAO;
import credito.dao.ClasificCreditoDAO;
import credito.servicio.ClasificCreditoServicio.Enum_Con_ClasificCredito;
import credito.servicio.ClasificCreditoServicio.Enum_Lis_ClasificCredito;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CatclasifrepregServicio  extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CatclasifrepregDAO catclasifrepregDAO = null;

		//---------- Tipos de Listas---------------------------------------------------------------
		public static interface Enum_Lis_Clasific {
			int principal  = 1;
		}
		public static interface Enum_Tra_Clasific {
			int alta = 1;
			int modificacion = 2;
		}
		public static interface Enum_Con_Clasific {
			int principal   = 1;
			int foranea   = 2;
		}

		public CatclasifrepregServicio ()    {
			super();
			// TODO Auto-generated constructor stub
		}

		
		public CatclasifrepregBean consulta(int tipoConsulta, CatclasifrepregBean catclasifrepreg){
			CatclasifrepregBean catclasifrepregBean = null;
			switch(tipoConsulta){
				case Enum_Con_Clasific.principal:
					catclasifrepregBean = catclasifrepregDAO.consultaPrincipal(catclasifrepreg, Enum_Con_Clasific.principal);
				break;
				case Enum_Con_Clasific.foranea:
					catclasifrepregBean = catclasifrepregDAO.consultaForanea(catclasifrepreg, Enum_Con_Clasific.foranea);
				break;
				
			}
			return catclasifrepregBean;
		}
		


		
		public List lista(int tipoLista, CatclasifrepregBean catclasifrepreg){
			List clasificCreditoLista = null;

			switch (tipoLista) {
		        case  Enum_Lis_Clasific.principal:
		        	clasificCreditoLista = catclasifrepregDAO.listaClasificRepRegulatorio(catclasifrepreg, tipoLista);
		        break;
		        
			}
			return clasificCreditoLista;
		}
		//------------------ Geters y Seters ------------------------------------------------------	


		public CatclasifrepregDAO getCatclasifrepregDAO() {
			return catclasifrepregDAO;
		}


		public void setCatclasifrepregDAO(CatclasifrepregDAO catclasifrepregDAO) {
			this.catclasifrepregDAO = catclasifrepregDAO;
		}
	
		
		
	}

