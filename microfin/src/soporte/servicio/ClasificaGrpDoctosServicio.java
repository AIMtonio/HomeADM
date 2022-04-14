package soporte.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import soporte.bean.ClasificaGrpDoctosBean;
import soporte.dao.ClasificaGrpDoctosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ClasificaGrpDoctosServicio extends BaseServicio{
	ClasificaGrpDoctosDAO clasificaGrpDoctosDAO = null;
	
	public static interface Enum_Lis_GruposDtos {
		int principalGrid = 1;
		int principal	=2;
		int foraneaGrid=3;
	}
	public static interface Enum_Con_GruposDtos {
		int principal = 1;
	}
	
	public static interface Enum_Lis_GruposDtosGuardaValores {
		int principal = 1;
	}
	
	public static interface Enum_Trans_GruposDtos {
		int act = 3;
	}
	
	
	public ClasificaGrpDoctosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}		
	
	
	//Transacciones alta , modifica,Elimina
	@SuppressWarnings("null")
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,String listaTipos,String listaBaja){
		MensajeTransaccionBean mensaje = null;	
		ArrayList listaBean = (ArrayList) creaListaDetalleAlta(listaTipos);
		ArrayList listaBajaBean = (ArrayList) creaListaDetalleBaja(listaBaja);
		switch (tipoTransaccion) {
			case Enum_Trans_GruposDtos.act:		
				mensaje = clasificaGrpDoctosDAO.metodoActClasifica(listaBean,listaBajaBean);				
				break;			
		}
		return mensaje;
	}
	
	// Crea la lista para alta de tipos de documentos por grupo
		private List creaListaDetalleAlta(String ListaTipos){		
			StringTokenizer tokensBean = new StringTokenizer(ListaTipos, "[");
			String stringCampos;
			String tokensCampos[];
			ArrayList listaDetalleCheck = new ArrayList();
			ClasificaGrpDoctosBean clasificaGrpDoctosBean;
			while(tokensBean.hasMoreTokens()){
			clasificaGrpDoctosBean = new ClasificaGrpDoctosBean();
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			clasificaGrpDoctosBean.setTipoDocumentoID(tokensCampos[0]);
			clasificaGrpDoctosBean.setDescripcion(tokensCampos[1]);
			clasificaGrpDoctosBean.setNumeroGrupo(tokensCampos[2]);
			listaDetalleCheck.add(clasificaGrpDoctosBean);
			}
			return listaDetalleCheck;
		}
		
		
		//  Crea la lista para baja de tipos de documentos por grupo
				private List creaListaDetalleBaja(String ListaTipos){		
					StringTokenizer tokensBean = new StringTokenizer(ListaTipos, "[");
					String stringCampos;
					String tokensCampos[];
					ArrayList listaDetalleCheck = new ArrayList();
					ClasificaGrpDoctosBean clasificaGrpDoctosBean;
					while(tokensBean.hasMoreTokens()){
					clasificaGrpDoctosBean = new ClasificaGrpDoctosBean();
					stringCampos = tokensBean.nextToken();		
					tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
					clasificaGrpDoctosBean.setTipoDocumentoID(tokensCampos[0]);
					clasificaGrpDoctosBean.setDescripcion(tokensCampos[1]);
					clasificaGrpDoctosBean.setNumeroGrupo(tokensCampos[2]);
					listaDetalleCheck.add(clasificaGrpDoctosBean);
					}
					return listaDetalleCheck;
				}
	
	// listas para comboBox
	public  Object[] listaCombo(ClasificaGrpDoctosBean clasificaGrpDoctosBean, int tipoLista ) {
		List listaClasifica = null;
		try{
			switch(tipoLista){
				case (Enum_Lis_GruposDtos.principal): 
					listaClasifica =  clasificaGrpDoctosDAO.listaCombo(clasificaGrpDoctosBean,tipoLista);
				break;
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return listaClasifica.toArray(); 
	}

	//Listas
	public List lista(ClasificaGrpDoctosBean clasificaGrpDoctosBean, int tipoLista){		
		List listaDoctoPorGrupo = null;
		switch (tipoLista) {
		case Enum_Lis_GruposDtos.principal:		
			listaDoctoPorGrupo = clasificaGrpDoctosDAO.listaCombo(clasificaGrpDoctosBean,tipoLista);				
			break;
			case (Enum_Lis_GruposDtos.principalGrid): 
				listaDoctoPorGrupo = clasificaGrpDoctosDAO.listaGuardaValores(clasificaGrpDoctosBean,Enum_Lis_GruposDtosGuardaValores.principal);
			break;
		}			
		return listaDoctoPorGrupo;
	}


	public ClasificaGrpDoctosDAO getClasificaGrpDoctosDAO() {
		return clasificaGrpDoctosDAO;
	}


	public void setClasificaGrpDoctosDAO(ClasificaGrpDoctosDAO clasificaGrpDoctosDAO) {
		this.clasificaGrpDoctosDAO = clasificaGrpDoctosDAO;
	}	


	


}
