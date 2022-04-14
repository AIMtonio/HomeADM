package spei.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import spei.bean.OrigenesSpeiBean;
import spei.dao.OrigenesSpeiDAO;

public class OrigenesSpeiServicio extends BaseServicio{

	OrigenesSpeiDAO origenesSpeiDAO = null;

	private OrigenesSpeiServicio(){
		super();
	}

	public static interface Enum_Lis_Autoriza{
		int principal = 1;
	}

	public List<OrigenesSpeiBean> lista(int tipoLista){
		OrigenesSpeiBean origenesSpeiBean = null;
		List<OrigenesSpeiBean> listaAutoriza = null;
		switch (tipoLista) {
		case Enum_Lis_Autoriza.principal:
			listaAutoriza =  origenesSpeiDAO.listaPrincipal(origenesSpeiBean, Enum_Lis_Autoriza.principal);
			break;

		}
		return listaAutoriza;
	}

	public OrigenesSpeiDAO getOrigenesSpeiDAO() {
		return origenesSpeiDAO;
	}

	public void setOrigenesSpeiDAO(OrigenesSpeiDAO origenesSpeiDAO) {
		this.origenesSpeiDAO = origenesSpeiDAO;
	}

}