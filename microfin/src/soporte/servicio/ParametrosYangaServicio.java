package soporte.servicio;

import soporte.bean.ParametrosYangaBean;
import general.servicio.BaseServicio;
import general.bean.MensajeTransaccionBean;
import soporte.dao.ParametrosYangaDAO;



public class ParametrosYangaServicio extends BaseServicio {


	/* Declaracion de Variables */

		ParametrosYangaDAO parametrosYangaDAO = null;
		


		public ParametrosYangaServicio() {
			super();
		}
		

		/*Enumera los tipo de transaccion */
		public static interface Enum_Tra_ParametrosYanga {
			int modifica = 1;
		}
		
		/* Enumera los tipo de consulta */
		public static interface Enum_Con_ParametrosYanga { 
			int principal = 1;
		}
	



		/* ========================== TRANSACCIONES ==============================  */


		/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosYangaBean parametrosYangaBean){
			MensajeTransaccionBean mensaje = null;
			switch (tipoTransaccion) {			
				case Enum_Tra_ParametrosYanga.modifica:
					mensaje = parametrosYangaDAO.modificar(parametrosYangaBean);					
					break;
			}
			return mensaje;
		}


		/* consulta los parametros del sist. YANGA */
		public ParametrosYangaBean consulta(int tipoConsulta,ParametrosYangaBean parametrosYangaBean){						
			ParametrosYangaBean parametrosYangaConBean = null;
			switch (tipoConsulta) {
				case Enum_Con_ParametrosYanga.principal:		
					parametrosYangaConBean = parametrosYangaDAO.consultaPrincipal(parametrosYangaBean, Enum_Con_ParametrosYanga.principal);				
					break;
			}
				
			return parametrosYangaConBean;
		}
	
		

		/* ===================== GETTER's Y SETTER's ======================= */


		public ParametrosYangaDAO getParametrosYangaDAO() {
			return parametrosYangaDAO;
		}

		public void setParametrosYangaDAO(ParametrosYangaDAO parametrosYangaDAO) {
			this.parametrosYangaDAO = parametrosYangaDAO;
		}	
		
}	//fin de la clase
