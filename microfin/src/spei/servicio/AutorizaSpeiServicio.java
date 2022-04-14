package spei.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import spei.bean.AutorizaSpeiBean;

import spei.dao.AutorizaSpeiDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

	public class AutorizaSpeiServicio extends BaseServicio{

		private AutorizaSpeiServicio(){
			super();
		}

		AutorizaSpeiDAO autorizaSpeiDAO = null;

		public static interface Enum_Lis_Autoriza{
			int principal = 1;
		}


		public static interface Enum_Tra_Autoriza {
			int autoriza = 7;
			int cancela = 8;
	
		}

		public static interface Enum_Con_Autoriza{
			int principal = 1;
		
		}

		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AutorizaSpeiBean autorizaSpeiBean, String listaGrid) {
			
			MensajeTransaccionBean mensaje = null;
			ArrayList listaCodigosResp = (ArrayList) creaListaGrid(listaGrid);
			switch(tipoTransaccion){		
			case Enum_Tra_Autoriza.autoriza:
				mensaje = autorizaSpeiDAO.actualizaListaCodigosResp(autorizaSpeiBean,tipoTransaccion,listaCodigosResp);
				break;	
				
			case Enum_Tra_Autoriza.cancela:
				mensaje = autorizaSpeiDAO.cancelaListaCodigosResp(autorizaSpeiBean,tipoTransaccion,listaCodigosResp);
				break;	
			}
			
			return mensaje;
		
		}

		
		 private List creaListaGrid(String listaGrid){		
				StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
				String stringCampos;
				String tokensCampos[];
				ArrayList listaCodigosResp = new ArrayList();
				AutorizaSpeiBean autorizaSpeiBean;
				
				while(tokensBean.hasMoreTokens()){
					autorizaSpeiBean = new AutorizaSpeiBean();
					
					stringCampos = tokensBean.nextToken();		
					tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
					autorizaSpeiBean.setUsuarioVerifica(tokensCampos[0]);
					autorizaSpeiBean.setFolioSpeiID(tokensCampos[1]);
					autorizaSpeiBean.setClaveRastreo(tokensCampos[2]);
					autorizaSpeiBean.setClienteID(tokensCampos[3]);
					autorizaSpeiBean.setComentario(tokensCampos[4]);
					
				listaCodigosResp.add(autorizaSpeiBean);
					
					
				}
				
				return listaCodigosResp;
			 }

		


		public List lista(int tipoLista, AutorizaSpeiBean autorizaSpeiBean){		
			List listaAutoriza = null;
			switch (tipoLista) {
			case Enum_Lis_Autoriza.principal:		
				listaAutoriza =  autorizaSpeiDAO.listaPrincipal(autorizaSpeiBean, Enum_Lis_Autoriza.principal);				
				break;	

			}		
			return listaAutoriza;
		}
	


		public AutorizaSpeiDAO getAutorizaSpeiDAO() {
			return autorizaSpeiDAO;
		}

		public void setAutorizaSpeiDAO(AutorizaSpeiDAO autorizaSpeiDAO) {
			this.autorizaSpeiDAO = autorizaSpeiDAO;
		}



	}

