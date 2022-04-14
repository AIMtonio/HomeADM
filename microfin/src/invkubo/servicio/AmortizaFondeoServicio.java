package invkubo.servicio;

import general.servicio.BaseServicio;
import invkubo.bean.AmortizaFondeoBean;
import invkubo.dao.AmortizaFondeoDAO;

import java.util.List;

public class AmortizaFondeoServicio extends BaseServicio{

	AmortizaFondeoDAO amortizaFondeoDAO = null;			   
	
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_AmortiFon {
		int principal = 1;
		int gridAmFondeo = 2;
	}
	
	public List lista(int tipoLista,AmortizaFondeoBean amortizaFondeo){		
		List listaAmortFondeo = null;
		switch (tipoLista) {
			case Enum_Lis_AmortiFon.principal:		
				//listaAmortFondeo = fondeoSolicitudDAO.listaPrincipal(fondeoSolicitud, tipoLista);				
				break;	
			case Enum_Lis_AmortiFon.gridAmFondeo:		
				listaAmortFondeo = amortizaFondeoDAO.listaGridAmortizaFondeo(amortizaFondeo, tipoLista);				
				break;	
				
		}		
		return listaAmortFondeo;
	}

	
	
	public AmortizaFondeoDAO getAmortizaFondeoDAO() {
		return amortizaFondeoDAO;
	}



	public void setAmortizaFondeoDAO(AmortizaFondeoDAO amortizaFondeoDAO) {
		this.amortizaFondeoDAO = amortizaFondeoDAO;
	}

	
}

