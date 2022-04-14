package fondeador.servicio;

import fondeador.bean.CreditoFondMovsBean;
import fondeador.dao.CreditoFondMovsDAO;
import general.servicio.BaseServicio;
import java.util.List;

public class CreditoFondMovsServicio extends BaseServicio {
	private CreditoFondMovsServicio(){
		super();
	} 

	CreditoFondMovsDAO creditoFondMovsDAO = null;
	
	public static interface Enum_Lis_MovimientosFondeoCredito{
		int principal			= 1; /* muestra todas los movimientos de credito filtradas por credito pasivo */
	}
	
	public List listaGrid(int tipoLista, CreditoFondMovsBean creditoFondMovsBean){
		List listaMovsCreditoFondeo = null;
		switch(tipoLista){
			case Enum_Lis_MovimientosFondeoCredito.principal:
				listaMovsCreditoFondeo= creditoFondMovsDAO.listaPrincipal(creditoFondMovsBean, tipoLista);
				break;
		}
		return listaMovsCreditoFondeo;
	}

	/* ----------GETTERS Y SETTERS----------*/
	public CreditoFondMovsDAO getCreditoFondMovsDAO() {
		return creditoFondMovsDAO;
	}

	public void setCreditoFondMovsDAO(CreditoFondMovsDAO creditoFondMovsDAO) {
		this.creditoFondMovsDAO = creditoFondMovsDAO;
	}

}