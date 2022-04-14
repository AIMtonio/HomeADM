package soporte.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import soporte.bean.ApoyoEscCicloBean;
import soporte.dao.ApoyoEscCicloDAO;

public class ApoyoEscCicloServicio extends BaseServicio{

	/* Declaracion de Variables */

		ApoyoEscCicloDAO apoyoEscCicloDAO = null;
		


		public ApoyoEscCicloServicio() {
			super();
		}

		/*Enumera los tipo de listas */
		public static interface Enum_Lis_ApoyoCiclo {
			int principal = 1;
		}
		
		


		/* ========================== TRANSACCIONES ==============================  */


		/* Lista para combos */
		public Object[] listaCombo(int tipoLista, ApoyoEscCicloBean apoyoEscCicloBean){
			List listaApoyoEscolar = null;
			switch (tipoLista) {			
				case Enum_Lis_ApoyoCiclo.principal:
					listaApoyoEscolar = apoyoEscCicloDAO.listaPrincipal(apoyoEscCicloBean, tipoLista);				
				break;	
			}
			return listaApoyoEscolar.toArray();	
		}



		public ApoyoEscCicloDAO getApoyoEscCicloDAO() {
			return apoyoEscCicloDAO;
		}



		public void setApoyoEscCicloDAO(ApoyoEscCicloDAO apoyoEscCicloDAO) {
			this.apoyoEscCicloDAO = apoyoEscCicloDAO;
		}


		

		/* ===================== GETTER's Y SETTER's ======================= */


		
}	//fin de la clase
