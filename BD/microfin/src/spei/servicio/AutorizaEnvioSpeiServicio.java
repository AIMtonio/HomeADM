package spei.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import spei.bean.AutorizaEnvioSpeiBean;
import spei.dao.AutorizaEnvioSpeiDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

	public class AutorizaEnvioSpeiServicio extends BaseServicio{

		private AutorizaEnvioSpeiServicio(){
			super();
		}

		AutorizaEnvioSpeiDAO autorizaEnvioSpeiDAO = null;

		public static interface Enum_Lis_Autoriza{
			int autTeso = 3;
		}


		public static interface Enum_Tra_Autoriza {
			int autoriza = 9;
		}

		public static interface Enum_Con_Autoriza{
			int principal = 1;
		
		}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AutorizaEnvioSpeiBean autorizaEnvioSpeiBean, String listaGrid) {
			MensajeTransaccionBean mensaje = null;
			ArrayList listaCodigosResp = (ArrayList) creaListaGrid(listaGrid);
			switch(tipoTransaccion){		
			case Enum_Tra_Autoriza.autoriza:
				mensaje = autorizaEnvioSpeiDAO.actualizaListaCodigosResp(autorizaEnvioSpeiBean,tipoTransaccion,listaCodigosResp);
				break;	
		
			}
			
			return mensaje;
		
		}

		 private List creaListaGrid(String listaGrid){	
				StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
				String stringCampos;
				String tokensCampos[];
				ArrayList listaCodigosResp = new ArrayList();
				AutorizaEnvioSpeiBean autorizaEnvioSpeiBean;
				
				while(tokensBean.hasMoreTokens()){
					autorizaEnvioSpeiBean = new AutorizaEnvioSpeiBean();
					
					stringCampos = tokensBean.nextToken();		
					tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
	
					autorizaEnvioSpeiBean.setUsuarioVerifica(tokensCampos[0]);
					autorizaEnvioSpeiBean.setFolioSpeiID(tokensCampos[1]);
					autorizaEnvioSpeiBean.setClaveRastreo(tokensCampos[2]);
					autorizaEnvioSpeiBean.setCuentaOrd(tokensCampos[3]);
					autorizaEnvioSpeiBean.setCuentaBeneficiario(tokensCampos[4]);
					autorizaEnvioSpeiBean.setNombreBeneficiario(tokensCampos[5]);
					autorizaEnvioSpeiBean.setMonto(tokensCampos[6]);
					
				listaCodigosResp.add(autorizaEnvioSpeiBean);
			
				}
				
				return listaCodigosResp;
			 }
		


			public List lista(int tipoLista, AutorizaEnvioSpeiBean autorizaEnvioSpeiBean){		
				List listaAutoriza = null;
				switch (tipoLista) {
				case Enum_Lis_Autoriza.autTeso:		
					listaAutoriza =  autorizaEnvioSpeiDAO.listaAutTeso(autorizaEnvioSpeiBean, Enum_Lis_Autoriza.autTeso);				
					break;	

				}		
				return listaAutoriza;
			}
	


		public AutorizaEnvioSpeiDAO getAutorizaEnvioSpeiDAO() {
			return autorizaEnvioSpeiDAO;
		}

		public void setAutorizaEnvioSpeiDAO(AutorizaEnvioSpeiDAO autorizaEnvioSpeiDAO) {
			this.autorizaEnvioSpeiDAO = autorizaEnvioSpeiDAO;
		}



	}

