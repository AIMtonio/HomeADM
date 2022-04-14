package seguimiento.servicio;

import java.util.List;

import seguimiento.bean.CatSegtoCategoriasBean;
import seguimiento.dao.CatSegtoCategoriasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CatSegtoCategoriasServicio extends BaseServicio{

	public CatSegtoCategoriasServicio(){
		super();
	}
	CatSegtoCategoriasDAO catSegtoCategoriasDAO = null;
	
	public static interface Enum_Tra_Categoria {
		int alta			= 1;
		int modificacion	= 2;	
	}
	
	public static interface Enum_Con_Categoria{
		int principal	= 1;
		int foranea		= 2;	
	}
	public static interface Enum_Lis_Categoria {
		int principal	= 1;
		int foranea		= 2;
		int combo = 3;
		int comboCobranza = 4;
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CatSegtoCategoriasBean segtoCategoriasBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
	    	case Enum_Tra_Categoria.alta:
	    		mensaje = catSegtoCategoriasDAO.altaCategoria(tipoTransaccion,segtoCategoriasBean);
	    	break;
	    	case Enum_Tra_Categoria.modificacion:
	    		mensaje = catSegtoCategoriasDAO.modificaCategoria(segtoCategoriasBean);
	    	break;
		}
		return mensaje;
	}
	
	public CatSegtoCategoriasBean consulta(int tipoConsulta, CatSegtoCategoriasBean segtoCategoriasBean){
		CatSegtoCategoriasBean tiposGestores = null;
		switch(tipoConsulta){
			case Enum_Con_Categoria.principal:
				tiposGestores = catSegtoCategoriasDAO.consulta(Enum_Con_Categoria.principal, segtoCategoriasBean);
			break;
		}
		return tiposGestores;
	}

	public List lista(int tipoLista, CatSegtoCategoriasBean catSegtoCategoria){
		List listaTipoGestion = null;
		switch (tipoLista) {
	        case  Enum_Lis_Categoria.principal:
	        	listaTipoGestion = catSegtoCategoriasDAO.listaPrincipal(catSegtoCategoria, Enum_Lis_Categoria.principal);
	        break;
		}
		return listaTipoGestion;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaCatego = null;
		switch(tipoLista){
			case (Enum_Lis_Categoria.combo):
				listaCatego = catSegtoCategoriasDAO.categoriaCombo(tipoLista);
				break;
			case (Enum_Lis_Categoria.comboCobranza):
				listaCatego = catSegtoCategoriasDAO.categoriaCombo(tipoLista);
				break;
		}
		return listaCatego.toArray();
	}

	public CatSegtoCategoriasDAO getCatSegtoCategoriasDAO() {
		return catSegtoCategoriasDAO;
	}
	public void setCatSegtoCategoriasDAO(CatSegtoCategoriasDAO catSegtoCategoriasDAO) {
		this.catSegtoCategoriasDAO = catSegtoCategoriasDAO;
	}	
}
