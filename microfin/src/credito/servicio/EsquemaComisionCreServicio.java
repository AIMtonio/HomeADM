package credito.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.SolicitudCheckListBean;

import credito.bean.EsquemaComisionCreBean;
import credito.dao.EsquemaComisionCreDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class EsquemaComisionCreServicio extends BaseServicio{
	
	private EsquemaComisionCreServicio(){
		super();
	}
	
	EsquemaComisionCreDAO esquemaComisionCreDAO = null;
	
	public static interface Enum_Tra_EsquemComision{
		int alta = 1; // Guarda los datos
	}
	public static interface Enum_Lis_EsquemComision{
		int listaPrincipal =	1; // lista para llenar el grid de la pantalla
	}
	//----- Grabar Valores del Grid------------------------------
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,EsquemaComisionCreBean esquemaComisionCreBean, String datosGrid) {
		MensajeTransaccionBean mensaje = null;
		
		ArrayList listaCodigosResp = (ArrayList) creaListaGrid(datosGrid);
		switch(tipoTransaccion){		
		case Enum_Tra_EsquemComision.alta:
			mensaje = esquemaComisionCreDAO.grabaEsquemasComision(esquemaComisionCreBean,tipoTransaccion,listaCodigosResp);			
			break;	
			
		}
		
		return mensaje;
	
	}
// Crea la lista con los datos del grid para guardar
	 private List creaListaGrid(String listaGrid){	
		
			StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
			String stringCampos;
			String tokensCampos[];
			ArrayList listaCodigosResp = new ArrayList();
			EsquemaComisionCreBean esquemaComisionCreBean;
			
			 while(tokensBean.hasMoreTokens()){
				 esquemaComisionCreBean = new EsquemaComisionCreBean();
					
					stringCampos = tokensBean.nextToken();		
					tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
					
					esquemaComisionCreBean.setMontoInicial(tokensCampos[0]);
					esquemaComisionCreBean.setMontoFinal(tokensCampos[1]);
					esquemaComisionCreBean.setTipoComision(tokensCampos[2]);
					esquemaComisionCreBean.setComision(tokensCampos[3]);
					//esquemaComisionCreBean.setProducCreditoID(tokensCampos[4]);
				
					listaCodigosResp.add(esquemaComisionCreBean);
					
				}
				
				return listaCodigosResp;
			 }
	 
	
	//---------------Lista para llenar el Grid-----------------------------------
	public List lista(int tipoLista,EsquemaComisionCreBean esquemaComisionCreBean) {
		List esquemaComisionLis = null;
		switch (tipoLista) {
			case Enum_Lis_EsquemComision.listaPrincipal:
				esquemaComisionLis = esquemaComisionCreDAO.lista(esquemaComisionCreBean, tipoLista);
			break;
		}
		return esquemaComisionLis;
	}
	
	public EsquemaComisionCreDAO getEsquemaComisionCreDAO() {
		return esquemaComisionCreDAO;
	}

	public void setEsquemaComisionCreDAO(EsquemaComisionCreDAO esquemaComisionCreDAO) {
		this.esquemaComisionCreDAO = esquemaComisionCreDAO;
	}
}
