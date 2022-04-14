package soporte.servicio;

import java.util.List;

import soporte.bean.TiposDocumentosBean;
import soporte.dao.TiposDocumentosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TiposDocumentosServicio extends BaseServicio{


	private TiposDocumentosServicio(){
		super();
	}

	TiposDocumentosDAO tiposDocumentosDAO = null;

	public static interface Enum_Con_TiposDocumentos{
		int descripcion = 1;		
		int principal = 3;	
	}
	public static interface Enum_Lis_TiposDocumentos{
		int combo  = 1;
		int combox = 2;
		int principal=3;
		int listaRequeridoEn=4;
		int listaDocCliente=5;
	}
	public static interface Enum_Trans_TiposDocumentos{
		int alta = 1;	
		int modifica = 2;	
		int elimina=3;
	}
	

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TiposDocumentosBean tiposDocumentosBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Trans_TiposDocumentos.alta:		
				mensaje = tiposDocumentosDAO.alta(tiposDocumentosBean);				
				break;		
			case Enum_Trans_TiposDocumentos.modifica:		
				mensaje = tiposDocumentosDAO.modifica(tiposDocumentosBean);				
				break;	
			case Enum_Trans_TiposDocumentos.elimina:		
				mensaje = tiposDocumentosDAO.elimina(tiposDocumentosBean);				
				break;	
		}
		return mensaje;
	}	
	
	
	
	public TiposDocumentosBean consulta(int tipoConsulta, TiposDocumentosBean tiposDocumentosBean){

		TiposDocumentosBean tiposDocumentos = null;
		switch (tipoConsulta) {
			case Enum_Con_TiposDocumentos.descripcion:		
				tiposDocumentos = tiposDocumentosDAO.consultaDescripcion(tiposDocumentosBean, tipoConsulta);	
				break;	
			case Enum_Con_TiposDocumentos.principal:		
				tiposDocumentos = tiposDocumentosDAO.consultaPrincipal(tiposDocumentosBean, tipoConsulta);	
				break;	
		}	
		return tiposDocumentos;
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista, TiposDocumentosBean tiposDocumentosBean) {
		
		List listaTiposDocumentos = null;
		
		switch(tipoLista){
			case (Enum_Lis_TiposDocumentos.combo): 
				listaTiposDocumentos =  tiposDocumentosDAO.listaTiposDocumentos(tiposDocumentosBean, tipoLista);
				break;
			case (Enum_Lis_TiposDocumentos.combox): 
				listaTiposDocumentos =  tiposDocumentosDAO.listaTiposDocumentos(tiposDocumentosBean, tipoLista);
				break;
			
		}
		
		
		return listaTiposDocumentos.toArray();		
	}
	
	public List lista(int tipoLista, TiposDocumentosBean tiposDocumentosBean) {
		List listaDocumentos = null;
		switch (tipoLista) {
			case Enum_Lis_TiposDocumentos.principal :
				listaDocumentos = tiposDocumentosDAO.listaPrincipal(tiposDocumentosBean, tipoLista);
				break;
			case Enum_Lis_TiposDocumentos.listaRequeridoEn :
				listaDocumentos = tiposDocumentosDAO.listaDocumentoFirma(tiposDocumentosBean, tipoLista);
				break;
			case Enum_Lis_TiposDocumentos.listaDocCliente :
				listaDocumentos = tiposDocumentosDAO.listaPrincipal(tiposDocumentosBean, tipoLista);
				break;
		}
		return listaDocumentos;
	}
	
	
	
	public void setTiposDocumentosDAO(TiposDocumentosDAO tiposDocumentosDAO) {
		this.tiposDocumentosDAO = tiposDocumentosDAO;
	}


	public TiposDocumentosDAO getTiposDocumentosDAO() {
		return tiposDocumentosDAO;
	}
}
