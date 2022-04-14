package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import cuentas.servicio.TiposCuentaServicio.Enum_Lis_TiposCuenta;

import originacion.bean.SolicitudCheckListBean;
import originacion.dao.SolicitudCheckListDAO;
import sms.bean.SMSCapaniasBean;
import sms.bean.SMSCodigosRespBean;
import sms.servicio.SMSCapaniasServicio.Enum_Tra_Camp;

public class SolicitudCheckListServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	//SolicitudCreditoDAO solicitudCreditoDAO = null;		
	SolicitudCheckListDAO solicitudCheckListDAO = null;
		
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_SolCheckList {
		int solCheckListGrid =1; // lista pantalla CheckList (Grid)
		int solCheckListLista =1;
		int checkListGuardaValores = 2;
		int listaGuardaValores = 4;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_SolCheckList {
		int actualiza = 1;
	}
	
	public SolicitudCheckListServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
								
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SolicitudCheckListBean solicitudCheckListBean, String listaGrid) {
		MensajeTransaccionBean mensaje = null;
		ArrayList listaCodigosResp = (ArrayList) creaListaGrid(listaGrid);
		switch(tipoTransaccion){		
		case Enum_Tra_SolCheckList.actualiza:
			mensaje = solicitudCheckListDAO.actualizaListaCodigosResp(solicitudCheckListBean,tipoTransaccion,listaCodigosResp);
			break;					
		}
		
		return mensaje;
	
	}
			
			
	 private List creaListaGrid(String listaGrid){		
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaCodigosResp = new ArrayList();
		 SolicitudCheckListBean solicitudCheckListBean;
		
		while(tokensBean.hasMoreTokens()){
			solicitudCheckListBean = new SolicitudCheckListBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			solicitudCheckListBean.setSolicitudCreditoID(tokensCampos[0]);
			solicitudCheckListBean.setClasificaTipDocID(tokensCampos[1]);
			solicitudCheckListBean.setDocRecibido(tokensCampos[2]);
			solicitudCheckListBean.setTipoDocumentoID(tokensCampos[3]);
			solicitudCheckListBean.setComentarios(tokensCampos[4]);
		
			listaCodigosResp.add(solicitudCheckListBean);
			
		}
		
		return listaCodigosResp;
	 }
		
			 
						
	public List lista(int tipoLista, SolicitudCheckListBean solicitudCheckListBean){		
		List listaSolicitud = null;
		switch (tipoLista) {
			case Enum_Lis_SolCheckList.solCheckListGrid:		
				listaSolicitud = solicitudCheckListDAO.listaSolCheckListGrid(solicitudCheckListBean, tipoLista);				
			break;
			case Enum_Lis_SolCheckList.listaGuardaValores:		
				listaSolicitud = solicitudCheckListDAO.listaGuardaValores(solicitudCheckListBean, tipoLista);				
			break;
			
		}		
		return listaSolicitud;
	}
			
			
		// listas para comboBox
	public  Object[] listaCombo(int tipoLista, SolicitudCheckListBean solicitudCheckListBean) {				
		List listaChekList = null;
		
		switch(tipoLista){
			case (Enum_Lis_SolCheckList.solCheckListLista): 
				listaChekList = solicitudCheckListDAO.listaSolCheckListLista( tipoLista,solicitudCheckListBean);
			break;	
			case Enum_Lis_SolCheckList.checkListGuardaValores:		
				listaChekList = solicitudCheckListDAO.listaSolCheckListGrid(solicitudCheckListBean, Enum_Lis_SolCheckList.solCheckListGrid);				
			break;					
		}		
		return listaChekList.toArray();		
	}

	//------------------ Geters y Seters ------------------------------------------------------	
	public SolicitudCheckListDAO getSolicitudCheckListDAO() {
		return solicitudCheckListDAO;
	}

	public void setSolicitudCheckListDAO(SolicitudCheckListDAO solicitudCheckListDAO) {
		this.solicitudCheckListDAO = solicitudCheckListDAO;
	}

}
