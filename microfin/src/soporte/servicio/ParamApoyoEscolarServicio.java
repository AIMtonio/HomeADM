package soporte.servicio;

import java.util.List;

import cliente.bean.ApoyoEscolarSolBean;
import cliente.servicio.ApoyoEscolarSolServicio.Enum_Con_ApoyoEscolarSol;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import soporte.bean.ParamApoyoEscolarBean;
import soporte.dao.ParamApoyoEscolarDAO;
 
public class ParamApoyoEscolarServicio extends BaseServicio{

	/* Declaracion de Variables */

		ParamApoyoEscolarDAO paramApoyoEscolarDAO = null;
		


		public ParamApoyoEscolarServicio() {
			super();
		}
		

		/* Enumera los tipo de consulta */
		public static interface Enum_Tra_ParamApoyoEsc  { 
			int alta = 2;
			int baja = 3;
		}

		/*Enumera los tipo de listas */
		public static interface Enum_Lis_ParamApoyoEsc {
			int principal = 1;
		}
		
		/*Enumera los tipo de listas */
		public static interface Enum_Con_ParamApoyoEsc {
			int principal = 1;
		}
		
		


		/* ========================== TRANSACCIONES ==============================  */

			/* controla el tipo de transaccion a ejecutar*/
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParamApoyoEscolarBean paramApoyoEscolarBean){
			MensajeTransaccionBean mensaje = null;
			try{
			switch (tipoTransaccion) {
				case Enum_Tra_ParamApoyoEsc.alta:		
					mensaje = paramApoyoEscolarDAO.alta(paramApoyoEscolarBean);				
					break;				
				case Enum_Tra_ParamApoyoEsc.baja:
					mensaje = paramApoyoEscolarDAO.baja(paramApoyoEscolarBean);				
					break;
				
			}
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error transaccion de parametros apoyo escolar", e);
			}
			return mensaje;
		}
		
		
		/* controla el tipo de consulta  */
		public ParamApoyoEscolarBean consulta(ParamApoyoEscolarBean paramApoyoEscolarBean, int tipoConsulta){						
			ParamApoyoEscolarBean paramApoyoEscolarConBean = null;
			switch (tipoConsulta) {
				case Enum_Con_ParamApoyoEsc.principal:		
					paramApoyoEscolarConBean = paramApoyoEscolarDAO.consultaPrincipal(paramApoyoEscolarBean, tipoConsulta);				
					break;
			}
				
			return paramApoyoEscolarConBean;
		}
	


		/* Lista todos los detalles */
		public List lista(int tipoLista, ParamApoyoEscolarBean paramApoyoEscolarBean){
			List listaApoyoEscolar = null;
			switch (tipoLista) {			
				case Enum_Lis_ParamApoyoEsc.principal:
					listaApoyoEscolar = paramApoyoEscolarDAO.listaPrincipal(paramApoyoEscolarBean, tipoLista);				
				break;	
			}
			return listaApoyoEscolar;	
		}



		public ParamApoyoEscolarDAO getParamApoyoEscolarDAO() {
			return paramApoyoEscolarDAO;
		}



		public void setParamApoyoEscolarDAO(ParamApoyoEscolarDAO paramApoyoEscolarDAO) {
			this.paramApoyoEscolarDAO = paramApoyoEscolarDAO;
		}


		

		/* ===================== GETTER's Y SETTER's ======================= */
	
		
}	//fin de la clase
