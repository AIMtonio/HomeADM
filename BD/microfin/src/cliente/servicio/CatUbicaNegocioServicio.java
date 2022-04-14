package cliente.servicio;

import java.util.List;

import cliente.bean.CatUbicaNegocioBean;
import cliente.dao.CatUbicaNegocioDAO;
import general.servicio.BaseServicio;
 
public class CatUbicaNegocioServicio extends BaseServicio{

	/* Declaracion de Variables */

	CatUbicaNegocioDAO catUbicaNegocioDAO = null;
		


		public CatUbicaNegocioServicio() {
			super();
		}

		/*Enumera los tipo de listas */
		public static interface Enum_Lis_Catalogo {
			int principal = 1;
		}
		
		


		/* ========================== TRANSACCIONES ==============================  */


		/* Lista para combos */
		public Object[] listaCombo(int tipoLista, CatUbicaNegocioBean bean){
			List listaCatalogo = null;
			switch (tipoLista) {			
				case Enum_Lis_Catalogo.principal:
					listaCatalogo = catUbicaNegocioDAO.listaPrincipal(bean, tipoLista);				
				break;	
			}
			return listaCatalogo.toArray();	
		}



		

		/* ===================== GETTER's Y SETTER's ======================= */

		public CatUbicaNegocioDAO getCatUbicaNegocioDAO() {
			return catUbicaNegocioDAO;
		}

		public void setCatUbicaNegocioDAO(CatUbicaNegocioDAO catUbicaNegocioDAO) {
			this.catUbicaNegocioDAO = catUbicaNegocioDAO;
		}

		
}	//fin de la clase
