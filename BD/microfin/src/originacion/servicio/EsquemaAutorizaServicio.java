package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.EsquemaAutorizaBean;
import originacion.bean.SolicitudCheckListBean;
import originacion.dao.EsquemaAutorizaDAO;
import originacion.servicio.SolicitudCheckListServicio.Enum_Lis_SolCheckList;


public class EsquemaAutorizaServicio extends BaseServicio{

	
	EsquemaAutorizaDAO esquemaAutorizaDAO =null;
	
	public EsquemaAutorizaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	// esquema Autoriza
	public static interface Enum_Tra_Esquema{
		int alta = 1;
	}


	
	public static interface Enum_Lis_EsquemaAutoriza {
		int principal = 1;
		int grid = 2;
	}
	
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,EsquemaAutorizaBean esquemaAutorizaBean, String datosBajasEsquema, String datosAltaEsquema) {
		MensajeTransaccionBean mensaje = null;		
		ArrayList listaAltaEsquemas = (ArrayList) creaListaAltaEsquema(datosAltaEsquema);
		ArrayList listaBajaEsquemas = (ArrayList) creaListaBajaEsquema(datosBajasEsquema);
		switch(tipoTransaccion){		
		case Enum_Tra_Esquema.alta:
			mensaje = esquemaAutorizaDAO.grabaEsquemasAutorizacion(listaBajaEsquemas,listaAltaEsquemas,tipoTransaccion);			
			break;	
		}
		
		return mensaje;
	
	}
	private List creaListaAltaEsquema(String datosAltaEsquema){		
		StringTokenizer tokensBean = new StringTokenizer(datosAltaEsquema, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaAltaEsquemas = new ArrayList();
		EsquemaAutorizaBean esquemaAutorizaBean;
		
		while(tokensBean.hasMoreTokens()){
			esquemaAutorizaBean = new EsquemaAutorizaBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			esquemaAutorizaBean.setEsquemaID(tokensCampos[0]);
			esquemaAutorizaBean.setCicloInicial(tokensCampos[1]);
			esquemaAutorizaBean.setCicloFinal(tokensCampos[2]);
			esquemaAutorizaBean.setMontoInicial(tokensCampos[3]);
			esquemaAutorizaBean.setMontoFinal(tokensCampos[4]);
			esquemaAutorizaBean.setMontoMaximo(tokensCampos[5]);
			esquemaAutorizaBean.setProducCreditoID(tokensCampos[6]);

			listaAltaEsquemas.add(esquemaAutorizaBean);
			
			
		}
		
		return listaAltaEsquemas;
	 }
	
	private List creaListaBajaEsquema(String datosBajasEsquema){		
		StringTokenizer tokensBean = new StringTokenizer(datosBajasEsquema, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaBajaEsquemas = new ArrayList();
		EsquemaAutorizaBean esquemaAutorizaBean;
		
		while(tokensBean.hasMoreTokens()){
			esquemaAutorizaBean = new EsquemaAutorizaBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			esquemaAutorizaBean.setEsquemaID(tokensCampos[0]);
			esquemaAutorizaBean.setCicloInicial(tokensCampos[1]);
			esquemaAutorizaBean.setCicloFinal(tokensCampos[2]);
			esquemaAutorizaBean.setMontoInicial(tokensCampos[3]);
			esquemaAutorizaBean.setMontoFinal(tokensCampos[4]);
			esquemaAutorizaBean.setMontoMaximo(tokensCampos[5]);
			esquemaAutorizaBean.setProducCreditoID(tokensCampos[6]);
		
			listaBajaEsquemas.add(esquemaAutorizaBean);
			
		}
		
		return listaBajaEsquemas;
	 }
	
	

	
		//lista para el grid				
	public List listaEsquemaAutoriza(int tipoLista, EsquemaAutorizaBean esquemaAutorizaBean){		
		List listaEsquema= null;
		switch (tipoLista) {
			case Enum_Lis_EsquemaAutoriza.grid:		
				listaEsquema = esquemaAutorizaDAO.listaGridEsquemaAutoriza(esquemaAutorizaBean, tipoLista);				
				break;	
		}		
		return listaEsquema;
	}
	
	
		// listas para comboBox
	public  Object[] listaCombo(int tipoLista,EsquemaAutorizaBean esquemaAutorizaBean) {				
		List listaEsquemas = null;
		
		switch(tipoLista){
			case (Enum_Lis_EsquemaAutoriza.grid): 
				listaEsquemas = esquemaAutorizaDAO.listaComboEsquemas( esquemaAutorizaBean, tipoLista);
				break;					
		}		
		return listaEsquemas.toArray();		
	}	
	

// ---------------setter y getter----------------------------------
	public EsquemaAutorizaDAO getEsquemaAutorizaDAO() {
		return esquemaAutorizaDAO;
	}

	public void setEsquemaAutorizaDAO(EsquemaAutorizaDAO esquemaAutorizaDAO) {
		this.esquemaAutorizaDAO = esquemaAutorizaDAO;
	}
	
}
