package credito.servicio;

import general.dao.BaseDAO;

import java.util.List;

import credito.bean.CreditosMovsBean;
import credito.dao.CreditosMovsDAO;

public class CreditosMovsServicio extends BaseDAO {
	
	public CreditosMovsServicio() 
		// TODO Auto-generated constructor stub
	{
		
		super();
	}
	public static interface Enum_List{
		
		int movs = 1;
		int movsContingentes = 3;
	}
	
	CreditosMovsDAO creditosMovsDAO = null;
	
	
	public List lista(int tipoLista,CreditosMovsBean creditosMovsBean){
		List creditosMovsCreditoLista  = null; 
		
		switch(tipoLista){
			
			
			case Enum_List.movs:
				creditosMovsCreditoLista = creditosMovsDAO.listaGrid(tipoLista, creditosMovsBean);
			break;
			case Enum_List.movsContingentes:
				creditosMovsCreditoLista = creditosMovsDAO.listaGrid(tipoLista, creditosMovsBean);
			break;
			
		}
		
		return creditosMovsCreditoLista;
	}


	public CreditosMovsDAO getCreditosMovsDAO() {
		return creditosMovsDAO;
	}


	public void setCreditosMovsDAO(CreditosMovsDAO creditosMovsDAO) {
		this.creditosMovsDAO = creditosMovsDAO;
	}
	

	

}
