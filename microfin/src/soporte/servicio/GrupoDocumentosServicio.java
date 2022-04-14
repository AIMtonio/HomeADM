package soporte.servicio;

import java.util.List;

import soporte.bean.ClasificaGrpDoctosBean;
import soporte.bean.GrupoDocumentosBean;
import soporte.dao.GrupoDocumentosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GrupoDocumentosServicio extends BaseServicio{
	GrupoDocumentosDAO grupoDocumentosDAO = null;
	
	public static interface Enum_Lis_GruposDtos {
		int principalGrid = 1;
		int principal	=2;
		int foraneaGrid=3;
	}
	
	public static interface Enum_Con_GruposDtos {
		int principal = 1;
	}
	
	
	public static interface Enum_Trans_GruposDtos {
		int alta = 1;
		int modifica=2;
		int elimina=4;
	}
	
	
	public GrupoDocumentosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}		
	
	
	//Transacciones alta , modifica,Elimina
	@SuppressWarnings("null")
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,ClasificaGrpDoctosBean clasificaGrpDoctosBean){
		MensajeTransaccionBean mensaje = null;
		GrupoDocumentosBean Bean = new GrupoDocumentosBean();
		
		Bean.setGrupoDocumentoID(clasificaGrpDoctosBean.getGrupoDocumentoID());
		Bean.setDescripcion(clasificaGrpDoctosBean.getDescripcion());
		Bean.setRequeridoEn(clasificaGrpDoctosBean.getRequeridoEn());
		Bean.setTipoPersona(clasificaGrpDoctosBean.getTipoPersona());
		Bean.setGrupoDocumentoID(clasificaGrpDoctosBean.getGrupoDocumentoID());
		
		switch (tipoTransaccion) {
			case Enum_Trans_GruposDtos.alta:		
				mensaje = grupoDocumentosDAO.altaActGruposDoc(Bean);				
				break;			
			case Enum_Trans_GruposDtos.modifica:		
				mensaje = grupoDocumentosDAO.modifica(Bean);				
				break;	
				
			case Enum_Trans_GruposDtos.elimina:		
				mensaje = grupoDocumentosDAO.elimina(Bean);				
				break;	
		}
		return mensaje;
	}	
		
	public List lista(int tipoLista,int tipoInstrumentoID, int instrumento){		
		List listaDocEnt = null;
		switch (tipoLista) {
		case Enum_Lis_GruposDtos.principalGrid:		
			listaDocEnt = grupoDocumentosDAO.listaGrupoDocumentos(instrumento,tipoInstrumentoID, tipoLista);				
			break;	
		case Enum_Lis_GruposDtos.foraneaGrid:		
			listaDocEnt = grupoDocumentosDAO.listaGrupoClasifica(tipoLista);				
			break;	
		}			
	return listaDocEnt;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int instrumento, int tipoInstrumentoID, int  tipoLista) {
		List listaInstrumentos = null;
		System.out.println("Parametros de entrada, instrumento: "+instrumento+"  instrumento: "+ tipoInstrumentoID + " tipoLista: " + tipoLista);
		loggerSAFI.info("Parametros de entrada, instrumento: "+instrumento+"  instrumento: "+ tipoInstrumentoID + " tipoLista: " + tipoLista);
		try{
			switch(tipoLista){
				case Enum_Lis_GruposDtos.principalGrid: 
					listaInstrumentos = grupoDocumentosDAO.listaGrupoDocumentos(instrumento, tipoInstrumentoID, tipoLista);
				break;
			}
			
		}catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Combo Movimientos de Pantalla Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaInstrumentos.toArray();		
	}
	
	public List listaP(int tipoLista,GrupoDocumentosBean grupoDocumentosBean){		
		List listaDocEnt = null;
		switch (tipoLista) {
		case Enum_Lis_GruposDtos.principal:		
			listaDocEnt = grupoDocumentosDAO.listaPrincipal(grupoDocumentosBean, tipoLista);				
			break;	
		}			
	return listaDocEnt;
	}
	
	public GrupoDocumentosBean consulta(int tipoConsulta, GrupoDocumentosBean grupoDocumentosBean){
		GrupoDocumentosBean grupoDocumentos = null;
		switch (tipoConsulta) {
			case Enum_Con_GruposDtos.principal:		
				grupoDocumentos = grupoDocumentosDAO.consultaPrincipal(grupoDocumentosBean, tipoConsulta);	
				break;					
		}	
		return grupoDocumentos;
	}
	
	public GrupoDocumentosDAO getGrupoDocumentosDAO() {
		return grupoDocumentosDAO;
	}
	public void setGrupoDocumentosDAO(GrupoDocumentosDAO grupoDocumentosDAO) {
		this.grupoDocumentosDAO = grupoDocumentosDAO;
	}

}
