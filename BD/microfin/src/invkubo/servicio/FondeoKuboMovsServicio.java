package invkubo.servicio;

import invkubo.bean.FondeoKuboMovsBean;
import invkubo.dao.FondeoKuboMovsDAO;

import java.util.List;

import credito.bean.CreditosMovsBean;
import credito.dao.CreditosMovsDAO;
import credito.servicio.CreditosMovsServicio.Enum_List;
import general.servicio.BaseServicio;

public class FondeoKuboMovsServicio extends BaseServicio{

	public FondeoKuboMovsServicio() 
	// TODO Auto-generated constructor stub
{
	
	super();
}
public static interface Enum_List_Movs{
	
	int principal = 1; 
}

FondeoKuboMovsDAO fondeoKuboMovsDAO = null;


public List lista(int tipoLista,FondeoKuboMovsBean fondeoKuboMovsBean){
	List fondeoKuboMovsLista  = null; 
	
	switch(tipoLista){
		
		
		case Enum_List_Movs.principal:
			fondeoKuboMovsLista = fondeoKuboMovsDAO.listaGrid(tipoLista, fondeoKuboMovsBean);
			break;		
	}
	
	return fondeoKuboMovsLista;
}


public FondeoKuboMovsDAO getFondeoKuboMovsDAO() {
	return fondeoKuboMovsDAO;
}


public void setFondeoKuboMovsDAO(FondeoKuboMovsDAO fondeoKuboMovsDAO) {
	this.fondeoKuboMovsDAO = fondeoKuboMovsDAO;
}


}

