package originacion.servicio;

import java.util.ArrayList;
import java.util.List;

import originacion.bean.ClasificaTipDocBean;
import originacion.dao.ClasificaTipDocDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class ClasificaTipDocServicio extends BaseServicio{
	ClasificaTipDocDAO clasificaTipDocDAO =null;
	
	public ClasificaTipDocServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	//
	public static interface Enum_Tra_Clasifica{
		int alta 		= 1;
		int modifica	=2;
		int baja		=3;
	}
	public static interface Enum_bajaTra_Clasifica{
		int principal 	= 1;
	}
	public static interface Enum_Lis_Clasifica {
		int principal	= 1;
		int grid		=2;
		int documentos	=3;
	}
	public static interface Enum_Lis_Documentos {
		int principal	= 1;
	}
	
	public static interface Enum_Con_Clasifica {
		int principal = 1;
		int documentos = 2;
	}
	public static interface Enum_Tra_Grid{
		int alta 		= 1;
		
	}
		
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,int tipoBaja,ClasificaTipDocBean clasificaTipDocBean) {
		MensajeTransaccionBean mensaje = null;			
		switch(tipoTransaccion){		
		case Enum_Tra_Clasifica.alta:
			mensaje = clasificaTipDocDAO.altaClasificacionDoc(clasificaTipDocBean,Enum_Tra_Clasifica.alta);			
			break;	
		case Enum_Tra_Clasifica.modifica:
			mensaje = clasificaTipDocDAO.modificaClasificacionDoc(clasificaTipDocBean);		
			break;
		case Enum_Tra_Clasifica.baja:
			mensaje = bajaTransaccion(tipoBaja,clasificaTipDocBean);			
			break;		
		}
		
		return mensaje;
	
	}
	
	public MensajeTransaccionBean grabaGrid(int tipoTransaccion,int clasDocID, ClasificaTipDocBean clasificaTipDocBean) {
		MensajeTransaccionBean mensaje = null;	
		ArrayList listaBean = (ArrayList) listaGrid(clasificaTipDocBean);

		switch(tipoTransaccion){		
		case Enum_Tra_Grid.alta:

			mensaje = clasificaTipDocDAO.grabaListaClasDoc(clasDocID, listaBean);			
			break;
		}
		
		return mensaje;
	
	}
		
	public MensajeTransaccionBean bajaTransaccion(int tipoBaja,ClasificaTipDocBean clasificaTipDocBean) {
		MensajeTransaccionBean mensaje = null;			
		switch(tipoBaja){		
		case Enum_bajaTra_Clasifica.principal:
			mensaje = clasificaTipDocDAO.bajaClasificacionDoc(clasificaTipDocBean,Enum_bajaTra_Clasifica.principal);			
			break;	
		}
		return mensaje;
	
	}
	
	//consulta de clasificacion de documentos 
	public ClasificaTipDocBean consulta(int tipoConsulta, ClasificaTipDocBean clasificaTipDocBean){
		ClasificaTipDocBean clasificaTipDoc = null;
		switch (tipoConsulta) {
			case Enum_Con_Clasifica.principal:
				clasificaTipDoc = clasificaTipDocDAO.consultaPrincipal(clasificaTipDocBean,tipoConsulta);
				break;
			case Enum_Con_Clasifica.documentos:
				clasificaTipDoc = clasificaTipDocDAO.consultaDocumentos(clasificaTipDocBean,tipoConsulta);
				break;	
		}				
		return clasificaTipDoc;
	}
	

	public List lista(int tipoLista,  ClasificaTipDocBean clasificaTipDocBean){		
		List listaClasifica = null;
		switch (tipoLista) {
		case Enum_Lis_Clasifica.principal:		
			listaClasifica = clasificaTipDocDAO.listaClasificacionTiposDoc(clasificaTipDocBean, tipoLista);			
			break;
		case Enum_Lis_Clasifica.grid:
			listaClasifica = clasificaTipDocDAO.listaClasificacionGrid(tipoLista);			
			break;
		case Enum_Lis_Clasifica.documentos:
			listaClasifica = clasificaTipDocDAO.listaDocumentosGrid(tipoLista, clasificaTipDocBean);
			break;
		}		
		return listaClasifica;
	}
	
	public List listaDocumentos(int tipoLista, int clasificaDocID){		
		List listaDoc = null;
		switch (tipoLista) {
		case Enum_Lis_Documentos.principal:		
			listaDoc = clasificaTipDocDAO.listaDocPorClas(tipoLista, clasificaDocID);			
			break;
		}
		return listaDoc;
	}
	
	public List listaGrid(ClasificaTipDocBean lisDocumentosBean){
		List<String> tipoDocLis			= lisDocumentosBean.getLisTipoDocID();
		List<String> desDocLis 			= lisDocumentosBean.getLisDescDocumento();

		ArrayList listaDetalle = new ArrayList();
		ClasificaTipDocBean clasificaTipDocBean = null;
		if(tipoDocLis !=null){ 			
			try{
				
			for(int i=0; i<tipoDocLis.size(); i++){
				
				clasificaTipDocBean = new ClasificaTipDocBean();
				clasificaTipDocBean.setTipoDocID(tipoDocLis.get(i));
				clasificaTipDocBean.setDescDocumento(desDocLis.get(i));
				
				listaDetalle.add(i,clasificaTipDocBean);										
					
				}
			}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Documentos por Clasificación", e);	
		}
	}
		return listaDetalle;
	}
	
	

			
	//--------------getter y setter-----------
	public ClasificaTipDocDAO getClasificaTipDocDAO() {
		return clasificaTipDocDAO;
	}

	public void setClasificaTipDocDAO(ClasificaTipDocDAO clasificaTipDocDAO) {
		this.clasificaTipDocDAO = clasificaTipDocDAO;
	}


	
}
