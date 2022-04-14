package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.OrganoAutorizaBean;
import originacion.dao.OrganoAutorizaDAO;;


public class OrganoAutorizaServicio extends BaseServicio {
	

	OrganoAutorizaDAO organoAutorizaDAO =null;
	
	public OrganoAutorizaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	//
		public static interface Enum_Tra_OrganoAutoriza{
			int alta = 1;
		}

		
		public static interface Enum_Lis_OrganoAutoriza {
			int principal = 1;
			int grid = 3;
			int gridFirmasAut = 4;
			int gridTodasFirmas = 5;
			int gridProdUsuarioFirmas = 6;
		}
		
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,OrganoAutorizaBean organoAutorizaBean, String datosBajasOrganoAutoriza, String datosAltaOrganosAutoriza,String datosModificaOrganoAutoriza) {
		MensajeTransaccionBean mensaje = null;		
		ArrayList listaAltaEsquemas = (ArrayList) creaListaAltaOrgano(datosAltaOrganosAutoriza);
		ArrayList listaBajaEsquemas = (ArrayList) creaListaBajaOrgano(datosBajasOrganoAutoriza);
		ArrayList listaModificaEsquemas = (ArrayList) creaListaModificaOrgano(datosModificaOrganoAutoriza);
		
		switch(tipoTransaccion){		
		case Enum_Tra_OrganoAutoriza.alta:
			mensaje = organoAutorizaDAO.grabaEsquemasFirmas(listaBajaEsquemas,listaAltaEsquemas,listaModificaEsquemas,tipoTransaccion);			
			break;	
		}
		
		return mensaje;
	
	}
	private List creaListaAltaOrgano(String datosAltaOrganosAutoriza){		
		StringTokenizer tokensBean = new StringTokenizer(datosAltaOrganosAutoriza, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaAltaOrganos = new ArrayList();
		OrganoAutorizaBean organoAutorizaBean;
		
		while(tokensBean.hasMoreTokens()){
			organoAutorizaBean = new OrganoAutorizaBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			organoAutorizaBean.setEsquemaID(tokensCampos[0]);
			organoAutorizaBean.setNumeroFirma(tokensCampos[1]);
			organoAutorizaBean.setOrganoID(tokensCampos[2]);			
			organoAutorizaBean.setProductoCreditoID(tokensCampos[3]);
			
			listaAltaOrganos.add(organoAutorizaBean);
			
			
		}
		
		return listaAltaOrganos;
	 }
	
	private List creaListaBajaOrgano(String datosBajasOrganoAutoriza){		
		StringTokenizer tokensBean = new StringTokenizer(datosBajasOrganoAutoriza, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaBajaOrganosAutoriza= new ArrayList();
		OrganoAutorizaBean organoAutorizaBean;
		
		while(tokensBean.hasMoreTokens()){
			organoAutorizaBean = new OrganoAutorizaBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			organoAutorizaBean.setEsquemaID(tokensCampos[0]);
			organoAutorizaBean.setNumeroFirma(tokensCampos[1]);
			organoAutorizaBean.setOrganoID(tokensCampos[2]);			
			organoAutorizaBean.setProductoCreditoID(tokensCampos[3]);
			
			listaBajaOrganosAutoriza.add(organoAutorizaBean);
			
		}
		
		return listaBajaOrganosAutoriza;
	 }
	private List creaListaModificaOrgano(String datosModificaOrganoAutoriza){		
		StringTokenizer tokensBean = new StringTokenizer(datosModificaOrganoAutoriza, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaModificaOrganosAutoriza= new ArrayList();
		OrganoAutorizaBean organoAutorizaBean;
		
		while(tokensBean.hasMoreTokens()){
			organoAutorizaBean = new OrganoAutorizaBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			organoAutorizaBean.setEsquemaID(tokensCampos[0]);
			organoAutorizaBean.setNumeroFirma(tokensCampos[1]);
			organoAutorizaBean.setOrganoID(tokensCampos[2]);			
			organoAutorizaBean.setProductoCreditoID(tokensCampos[3]);
			organoAutorizaBean.setEsquemas(tokensCampos[4]);
			organoAutorizaBean.setNumeroFirmas(tokensCampos[5]);
			organoAutorizaBean.setOrganosID(tokensCampos[6]);
			
			listaModificaOrganosAutoriza.add(organoAutorizaBean);
			
		}
		
		return listaModificaOrganosAutoriza;
	 }
		//lista para el grid				
	public List listaOrganoAutoriza(int tipoLista, OrganoAutorizaBean organoAutorizaBean){		
		List listaOrgano= null;
		switch (tipoLista) {
			case Enum_Lis_OrganoAutoriza.grid:		
				listaOrgano = organoAutorizaDAO.listaGridFirmasPorProducto(organoAutorizaBean, tipoLista);				
				break;	
			case Enum_Lis_OrganoAutoriza.gridFirmasAut:		
				listaOrgano = organoAutorizaDAO.listaGridFirmasAutorizarSolCred(organoAutorizaBean, tipoLista);				
				break;
			case Enum_Lis_OrganoAutoriza.gridTodasFirmas:		
				listaOrgano = organoAutorizaDAO.listaGridFirmasSolCred(organoAutorizaBean, tipoLista);				
				break;
			case Enum_Lis_OrganoAutoriza.gridProdUsuarioFirmas:		
				listaOrgano = organoAutorizaDAO.listaGridFirmasProdCred(organoAutorizaBean, tipoLista);				
				break;
		}		
		return listaOrgano;
	}
	
	

// ---------------setter y getter----------------------------------

	public OrganoAutorizaDAO getOrganoAutorizaDAO() {
		return organoAutorizaDAO;
	}
	public void setOrganoAutorizaDAO(OrganoAutorizaDAO organoAutorizaDAO) {
		this.organoAutorizaDAO = organoAutorizaDAO;
	}
	
	
}
