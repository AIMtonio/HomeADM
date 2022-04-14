package tarjetas.servicio;


import java.util.List;

import tarjetas.bean.CatalogoBloqueoCancelacionTarDebitoBean;
import tarjetas.dao.CatalogoBloqueoCancelacionTarDebitoDAO;
import general.servicio.BaseServicio;
       
public class CatalogoBloqueoCancelacionTarDebitoServicio extends BaseServicio{
	CatalogoBloqueoCancelacionTarDebitoDAO catalogoBloqueoCancelacionTarDebitoDAO =null;
	public CatalogoBloqueoCancelacionTarDebitoServicio(){
		super();
	}
	public static interface Enum_Lis_Catalogo{
		int principal 		= 1;
		int foranea 		= 2;
		int listaBloq	    = 3;
		int listaDesbloq 	= 4;
		int listaCance		= 5;
	}
	
	
	// listas para comboBox 
		public  Object[] listaCombo( int tipoLista,CatalogoBloqueoCancelacionTarDebitoBean catalogoTarDebBean) {

			List listaCatalogo = null;
			switch(tipoLista){
				case Enum_Lis_Catalogo.listaBloq: 
					listaCatalogo = catalogoBloqueoCancelacionTarDebitoDAO.listaCatalogoMotivoBloq(tipoLista, catalogoTarDebBean);
				
					break;
				case Enum_Lis_Catalogo.listaDesbloq: 
					listaCatalogo = catalogoBloqueoCancelacionTarDebitoDAO.listaCatalogoMotivoBloq(tipoLista, catalogoTarDebBean);
				
					break;
				case Enum_Lis_Catalogo.listaCance: 
					listaCatalogo = catalogoBloqueoCancelacionTarDebitoDAO.listaCatalogoMotivoBloq(tipoLista, catalogoTarDebBean);
				
					break;
			}
			return listaCatalogo.toArray();		
		}


		public CatalogoBloqueoCancelacionTarDebitoDAO getCatalogoBloqueoCancelacionTarDebitoDAO() {
			return catalogoBloqueoCancelacionTarDebitoDAO;
		}


		public void setCatalogoBloqueoCancelacionTarDebitoDAO(
				CatalogoBloqueoCancelacionTarDebitoDAO catalogoBloqueoCancelacionTarDebitoDAO) {
			this.catalogoBloqueoCancelacionTarDebitoDAO = catalogoBloqueoCancelacionTarDebitoDAO;
		}


	
	
	
	

}