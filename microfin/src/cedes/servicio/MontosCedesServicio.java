package cedes.servicio;

import herramientas.Utileria;
import inversiones.bean.MontoInversionBean;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import cedes.bean.MontosCedesBean;
import cedes.bean.PlazosCedesBean;
import cedes.dao.MontosCedesDAO;
import cedes.servicio.CedesServicio.Enum_Con_Cedes;
import cedes.servicio.PlazosCedesServicio.Enum_Lis_PlazosCedes;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

 
public class MontosCedesServicio extends BaseServicio{
	
	// ------------------ Propiedades y Atributos ------------------------------------------
		MontosCedesDAO montosCedesDAO = null;
		
		private MontosCedesServicio(){
			super();
		}

		public static interface Enum_Tra_MontosCedes {
			int alta = 1;
			int modificacion = 2;
		}

		public static interface Enum_Con_MontosCedes{
			int principal = 1;
			int foranea = 2;
		}

		public static interface Enum_Lis_MontosCedes{
			int principal 	= 1;
			int foranea 	= 2;
			int combo		= 3;
		}
		
		public MensajeTransaccionBean grabaListaMontosCedes(int tipoTransaccion, MontosCedesBean montoCedes,
				String plazosInferior, String plazosSuperior){
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			ArrayList listaMontosCede = (ArrayList) creaListaMontosCede(montoCedes, plazosInferior, plazosSuperior);
			mensaje = montosCedesDAO.grabaListaMontosCedes(montoCedes, listaMontosCede);
		return mensaje;		
		}
		
		public MontosCedesBean consulta(int tipoConsulta,MontosCedesBean montosCedesBean){
			MontosCedesBean montoCedesBean = null;
			switch (tipoConsulta) {
				case Enum_Con_Cedes.principal:		
					montoCedesBean = montosCedesDAO.consultaPrincipal(montosCedesBean, Enum_Con_MontosCedes.principal);				
					break;			
			}
			return montoCedesBean;
		}
		
		private List creaListaMontosCede(MontosCedesBean monto,String plazosInferior,String plazosSuperior){
			StringTokenizer tokensInferior = new StringTokenizer(plazosInferior, ",");
			StringTokenizer tokensSuperior = new StringTokenizer(plazosSuperior, ",");
			ArrayList listaMontos = new ArrayList();
			MontosCedesBean montosBean;
			
			String montosInferior[] = new String[tokensInferior.countTokens()];
			String montosSuperior[] = new String[tokensSuperior.countTokens()];
			
			int i=0;		
			
			while(tokensInferior.hasMoreTokens()){
				montosInferior[i] = tokensInferior.nextToken();
				i++;
			}
				i=0;
			while(tokensSuperior.hasMoreTokens()){
				montosSuperior[i] = tokensSuperior.nextToken();
				i++;
			}
			
			for(int contador=0; contador < montosInferior.length; contador++){		
				montosBean = new MontosCedesBean();
				montosBean.setTipoCedeID(monto.getTipoCedeID());
				montosBean.setMontoInferior(montosInferior[contador]);
				montosBean.setMontoSuperior(montosSuperior[contador]);
			listaMontos.add(montosBean);
			}
			return listaMontos;
			}
		
		/* Lista todos los detalles */
		public List lista(int tipoLista, MontosCedesBean bean){
			List lista = null;
			switch (tipoLista) {			
				case Enum_Lis_MontosCedes.foranea:
						lista = montosCedesDAO.lista(bean, tipoLista);
					break;		
			}
			return lista;	
		}

		public Object[] listaCombo(int tipoLista, MontosCedesBean bean){
			List montoslista = null;
			switch (tipoLista) {
				case Enum_Lis_MontosCedes.combo:
					montoslista = montosCedesDAO.listaComboBox(bean, tipoLista);
					break;
			}
			return montoslista.toArray();
		}
		
		
		
		
		public MontosCedesDAO getMontosCedesDAO() {
			return montosCedesDAO;
		}

		public void setMontosCedesDAO(MontosCedesDAO montosCedesDAO) {
			this.montosCedesDAO = montosCedesDAO;
		}
		

}
