package crowdfunding.servicio;

import crowdfunding.bean.CRWFondeoMovsBean;
import crowdfunding.dao.CRWFondeoMovsDAO;

import java.util.List;

import credito.bean.CreditosMovsBean;
import credito.dao.CreditosMovsDAO;
import credito.servicio.CreditosMovsServicio.Enum_List;
import general.servicio.BaseServicio;

public class CRWFondeoMovsServicio extends BaseServicio{

	public CRWFondeoMovsServicio(){
		super();
	}

	public static interface Enum_List_Movs{
		int principal = 1;
	}

	CRWFondeoMovsDAO crwFondeoMovsDAO = null;

	public List lista(int tipoLista,CRWFondeoMovsBean crwFondeoMovsBean){
		List crwFondeoMovsLista  = null;
		switch(tipoLista){
		case Enum_List_Movs.principal:
			crwFondeoMovsLista = crwFondeoMovsDAO.listaGrid(tipoLista, crwFondeoMovsBean);
			break;
		}
		return crwFondeoMovsLista;
	}

	public CRWFondeoMovsDAO getCrwFondeoMovsDAO() {
		return crwFondeoMovsDAO;
	}

	public void setCrwFondeoMovsDAO(CRWFondeoMovsDAO crwFondeoMovsDAO) {
		this.crwFondeoMovsDAO = crwFondeoMovsDAO;
	}
}