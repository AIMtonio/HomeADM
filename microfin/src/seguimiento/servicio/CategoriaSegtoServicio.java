package seguimiento.servicio;

import java.util.List;

import seguimiento.dao.CategoriaSegtoDAO;

import general.servicio.BaseServicio;

public class CategoriaSegtoServicio extends BaseServicio{
	
	CategoriaSegtoDAO categoriaSegtoDAO = null;
	public CategoriaSegtoServicio(){
		super();
	}
	
	public static interface Enum_Lis_Categ {
		int principal = 1;
		int foranea = 2;
		int combo = 3;
		int comboCobranza = 4;
	}
	
	// listas para comboBox
		public  Object[] listaCombo(int tipoLista) {
			List listaCatego = null;
			switch(tipoLista){
				case (Enum_Lis_Categ.combo):
					listaCatego = categoriaSegtoDAO.categoriaCombo(tipoLista);
					break;
				case (Enum_Lis_Categ.comboCobranza):
					listaCatego = categoriaSegtoDAO.categoriaCombo(tipoLista);
					break;
			}
			return listaCatego.toArray();
		}

		public CategoriaSegtoDAO getCategoriaSegtoDAO() {
			return categoriaSegtoDAO;
		}

		public void setCategoriaSegtoDAO(CategoriaSegtoDAO categoriaSegtoDAO) {
			this.categoriaSegtoDAO = categoriaSegtoDAO;
		}
		
}