package soporte.servicio;

import soporte.bean.ParametrosCajaBean;
import general.servicio.BaseServicio;
import general.bean.MensajeTransaccionBean;
import soporte.dao.ParametrosCajaDAO;



public class ParametrosCajaServicio extends BaseServicio {


	/* Declaracion de Variables */

		ParametrosCajaDAO parametrosCajaDAO = null;
		


		public ParametrosCajaServicio() {
			super();
		}
		

		/*Enumera los tipo de transaccion */
		public static interface Enum_Tra_ParametrosCaja {
			int modifica = 1;
		}
		
		/* Enumera los tipo de consulta */
		public static interface Enum_Con_ParametrosCaja { 
			int principal = 1;
			int paramApoyoEsc = 2;
			int paramVersionWS = 3;

		}
		
	



		/* ========================== TRANSACCIONES ==============================  */


		/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosCajaBean parametrosCajaBean){
			MensajeTransaccionBean mensaje = null;
			switch (tipoTransaccion) {			
				case Enum_Tra_ParametrosCaja.modifica:
					mensaje = parametrosCajaDAO.modificar(parametrosCajaBean);					
					break;
			}
			return mensaje;
		}


		/* consulta los parametros de caja */
		public ParametrosCajaBean consulta(int tipoConsulta,ParametrosCajaBean parametrosCajaBean){						
			ParametrosCajaBean parametrosCajaConBean = null;
			switch (tipoConsulta) {
				case Enum_Con_ParametrosCaja.principal:		
					parametrosCajaConBean = parametrosCajaDAO.consultaPrincipal(parametrosCajaBean,tipoConsulta);				
					break;
				case Enum_Con_ParametrosCaja.paramApoyoEsc:		
					parametrosCajaConBean = parametrosCajaDAO.consultaParamApoyoEsc(parametrosCajaBean, tipoConsulta);				
					break;
				case Enum_Con_ParametrosCaja.paramVersionWS:		
					parametrosCajaConBean = parametrosCajaDAO.consultaVersionWS(parametrosCajaBean, tipoConsulta);				
				    break;
			}
				
			return parametrosCajaConBean;
		}
	
		

		/* ===================== GETTER's Y SETTER's ======================= */


		public ParametrosCajaDAO getParametrosCajaDAO() {
			return parametrosCajaDAO;
		}

		public void setParametrosCajaDAO(ParametrosCajaDAO parametrosCajaDAO) {
			this.parametrosCajaDAO = parametrosCajaDAO;
		}	
		
}	//fin de la clase
