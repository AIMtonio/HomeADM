package gestionComecial.servicio;

import general.servicio.BaseServicio;
import gestionComecial.bean.AreasBean;
import gestionComecial.bean.CategoriasBean;
import gestionComecial.dao.AreasDAO;
import gestionComecial.dao.CategoriasDAO;
import gestionComecial.servicio.AreasServicio.Enum_Lis_Areas;

import java.util.List;

public class CategoriasServicio extends BaseServicio {

	private CategoriasServicio(){
		super();
	}

	CategoriasDAO categoriasDAO = null;

	public static interface Enum_Lis_Categorias{
		int alfanumerica = 1;
	}
	
	
	public List lista(int tipoLista, CategoriasBean categorias){		
		List listaCategorias = null;
		switch (tipoLista) {
			case Enum_Lis_Categorias.alfanumerica:		
				listaCategorias=  categoriasDAO.listaAlfanumerica(categorias, Enum_Lis_Categorias.alfanumerica);				
				break;	
		}		
		return listaCategorias;
	}
	
		
	public void setCategoriasDAO(CategoriasDAO categoriasDAO ){
		this.categoriasDAO = categoriasDAO;
	}

	public CategoriasDAO getCategoriasDAO() {
		return categoriasDAO;
	}

}
