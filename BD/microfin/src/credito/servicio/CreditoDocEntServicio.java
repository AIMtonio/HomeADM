package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.CreditoDocEntBean;
import credito.dao.CreditoDocEntDAO;


public class CreditoDocEntServicio  extends BaseServicio {

	//---------- Variables 	
	CreditoDocEntDAO creditoDocEntDAO = null;
		

	public static interface Enum_Lis_CrDocEnt {
		int crDocEntGrid =1;
		int listaCombo		   = 2;
		int listaGuardaValores = 3;
	}

	public static interface Enum_Tra_CrDocEnt {
		int actualiza = 1;
	}
	
	public CreditoDocEntServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
								
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CreditoDocEntBean creditoDocEntBean, String listaGrid) {
		MensajeTransaccionBean mensaje = null;
		ArrayList listaDatosGrid= (ArrayList) creaListaGrid(listaGrid);
		switch(tipoTransaccion){		
		case Enum_Tra_CrDocEnt.actualiza:
			mensaje = creditoDocEntDAO.actualizaDocEnt(tipoTransaccion,listaDatosGrid);
		
			break;					
		}
		return mensaje;
		
	}
			
			
	 private List creaListaGrid(String listaGrid){		
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDatosGrid = new ArrayList();
		CreditoDocEntBean creditoDocEntBean;
		
		while(tokensBean.hasMoreTokens()){
			creditoDocEntBean = new CreditoDocEntBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			creditoDocEntBean.setCreditoID(tokensCampos[0]);
			creditoDocEntBean.setClasificaTipDocID(tokensCampos[1]);
			creditoDocEntBean.setDocAceptado(tokensCampos[2]);
			creditoDocEntBean.setTipoDocumentoID(tokensCampos[3]);			
			creditoDocEntBean.setComentarios(tokensCampos[4]);
			
			listaDatosGrid.add(creditoDocEntBean);			
		}		
		return listaDatosGrid;
	 }
		
			
						
	public List lista(int tipoLista, CreditoDocEntBean creditoDocEntBean){		
		List listaDocEnt = null;
		switch (tipoLista) {
			case Enum_Lis_CrDocEnt.crDocEntGrid:		
				listaDocEnt = creditoDocEntDAO.listaDocEntregados(creditoDocEntBean, tipoLista);				
			break;
			case Enum_Lis_CrDocEnt.listaGuardaValores:		
				listaDocEnt = creditoDocEntDAO.listaGuardaValores(creditoDocEntBean, tipoLista);				
			break;	
		}			
		return listaDocEnt;
	}	
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista, CreditoDocEntBean creditoDocEntBean) {
		List listaInstrumentos = null;
		try{
			switch(tipoLista){
				case Enum_Lis_CrDocEnt.listaCombo: 
					listaInstrumentos = creditoDocEntDAO.listaCombo(creditoDocEntBean, tipoLista) ;
				break;
			}
			
		}catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Documento de Crédito en Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaInstrumentos.toArray();		
	}
	
	
	//------------------ Geters y Seters ------------------------------------------------------		
	public CreditoDocEntDAO getCreditoDocEntDAO() {
		return creditoDocEntDAO;
	}

	public void setCreditoDocEntDAO(
			CreditoDocEntDAO creditoDocEntDAO) {
		this.creditoDocEntDAO = creditoDocEntDAO;
	}
	
}
