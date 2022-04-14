package cedes.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.CuentaArchivosBean;
import cedes.bean.CheckListCedesBean;
import cedes.dao.CheckListCedesDAO;
import cedes.servicio.CheckListCedesServicio;
 
public class CheckListCedesServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	//SolicitudCreditoDAO solicitudCreditoDAO = null;		
	CheckListCedesDAO checkListCedesDAO = null;
		
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_CheckList {
		int solCheckListGrid =4; // lista pantalla CheckList (Grid)
		int solCheckListLista =2;
		int doctosReqLista   = 5;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_CheckList {
		int actualiza = 1;
	}
	
	public CheckListCedesServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
								
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CheckListCedesBean checkListCedesBean, String listaGrid) {
		MensajeTransaccionBean mensaje = null;
		ArrayList listaCodigosResp = (ArrayList) creaListaGrid(listaGrid);
		switch(tipoTransaccion){		
		case Enum_Tra_CheckList.actualiza:
			mensaje = checkListCedesDAO.actualizaListaCodigosResp(checkListCedesBean,tipoTransaccion,listaCodigosResp);
			break;					
		}
		
		return mensaje;
	
	}
		
			
	 private List creaListaGrid(String listaGrid){		
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaCodigosResp = new ArrayList();
		CheckListCedesBean checkListCedesBean;
		
		while(tokensBean.hasMoreTokens()){
			checkListCedesBean = new CheckListCedesBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			checkListCedesBean.setCedeID(tokensCampos[0]);
			checkListCedesBean.setClasificaTipDocID(tokensCampos[1]);
			checkListCedesBean.setTipoDocumentoID(tokensCampos[2]);
			checkListCedesBean.setDocRecibido(tokensCampos[3]);
			checkListCedesBean.setObservacion(tokensCampos[4]);
	
				listaCodigosResp.add(checkListCedesBean);
			
			
		}
		
		return listaCodigosResp;
	 }
			 
					
	public List lista(int tipoLista, CheckListCedesBean checkListCedesBean){		
		List listaSolicitud = null;
		
		switch (tipoLista) {
		
			case Enum_Lis_CheckList.solCheckListGrid:		
				listaSolicitud = checkListCedesDAO.listaCheckListCedesGrid(checkListCedesBean, tipoLista);				
				break;	
		}		
		return listaSolicitud;
	}
			
			
		// listas para comboBox
	public  Object[] listaCombo(int tipoLista, CheckListCedesBean checkListCedesBean) {				
		List listaChekList = null;
		
		switch(tipoLista){
			case (Enum_Lis_CheckList.solCheckListLista): 
				listaChekList = checkListCedesDAO.listaCheckListLista(tipoLista,checkListCedesBean);
				break;	
				
			case (Enum_Lis_CheckList.doctosReqLista): 
				listaChekList = checkListCedesDAO.ListaDegitalComboDigita(tipoLista,checkListCedesBean);
				break;	
		}		
		return listaChekList.toArray();		
	}
	
	//Reporte de Archivos de Cedes PDF
	public ByteArrayOutputStream reporteArchivosCedesPDF(CheckListCedesBean checkListCedesBean,String cedeID, String nombreInstitucion, 
			String sucursal, String fecha,  String usuario, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_CedeID",  cedeID);
		parametrosReporte.agregaParametro("Par_NombreInstitucion", nombreInstitucion);
		parametrosReporte.agregaParametro("Par_Sucursal", sucursal);
		parametrosReporte.agregaParametro("Par_Fecha", fecha);
		parametrosReporte.agregaParametro("Par_Usuario", usuario);
	
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
		
	
	public CheckListCedesDAO getCheckListCedesDAO() {
		return checkListCedesDAO;
	}

	public void setCheckListCedesDAO(CheckListCedesDAO checkListCedesDAO) {
		this.checkListCedesDAO = checkListCedesDAO;
	}

	
}



