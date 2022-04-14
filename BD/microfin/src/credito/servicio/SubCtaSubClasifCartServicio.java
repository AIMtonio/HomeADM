package credito.servicio;

import credito.bean.SubCtaSubClasifCartBean;
import credito.dao.SubCtaSubClasifCartDAO;
import general.servicio.BaseServicio;

public class SubCtaSubClasifCartServicio extends BaseServicio{
	SubCtaSubClasifCartDAO subCtaSubClasifCartDAO=null;
	
	public SubCtaSubClasifCartServicio(){
		super();
	}
	
		//---------- Tipos de Transacciones---------------------------------------------------------------
	
		public static interface Enum_Tra_SubClasCart{
			int alta = 1;
			int modificacion = 2;
			int baja = 3;
		}
		
		//---------- Tipos de Consultas---------------------------------------------------------------

		public static interface Enum_Con_SubClasCart{
			int principal = 1;
			int foranea = 2;
		}
		
		//---------- Tipos de Listas---------------------------------------------------------------

		public static interface Enum_Lis_SubClasCart{
			int principal = 1;
			int foranea = 2;
		}

		
		public SubCtaSubClasifCartBean consulta(int tipoConsulta,SubCtaSubClasifCartBean subCtaSubClasifBean){
			SubCtaSubClasifCartBean subClasifBean=null;
			switch(tipoConsulta){
				case Enum_Con_SubClasCart.principal:
					subClasifBean=subCtaSubClasifCartDAO.consultaPrincipal(subCtaSubClasifBean,tipoConsulta);
					break;
			}
			return subClasifBean;
			
		}


		public SubCtaSubClasifCartDAO getSubCtaSubClasifCartDAO() {
			return subCtaSubClasifCartDAO;
		}


		public void setSubCtaSubClasifCartDAO(
				SubCtaSubClasifCartDAO subCtaSubClasifCartDAO) {
			this.subCtaSubClasifCartDAO = subCtaSubClasifCartDAO;
		}
		
		
		
}
