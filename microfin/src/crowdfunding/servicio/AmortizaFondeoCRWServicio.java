package crowdfunding.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import crowdfunding.bean.AmortizaFondeoCRWBean;
import crowdfunding.dao.AmortizaFondeoCRWDAO;

public class AmortizaFondeoCRWServicio extends BaseServicio{

	AmortizaFondeoCRWDAO amortizaFondeoCRWDAO = null;			   

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_AmortiFon {
		int principal = 1;
		int gridAmFondeo = 2;
	}

	public List lista(int tipoLista, AmortizaFondeoCRWBean amortizaFondeo){		
		List listaAmortFondeo = null;
		switch (tipoLista) {
		case Enum_Lis_AmortiFon.principal:		
			break;	
		case Enum_Lis_AmortiFon.gridAmFondeo:		
			listaAmortFondeo = amortizaFondeoCRWDAO.listaGridAmortizaFondeo(amortizaFondeo, tipoLista);				
			break;	

		}		
		return listaAmortFondeo;
	}

	public AmortizaFondeoCRWDAO getAmortizaFondeoCRWDAO() {
		return amortizaFondeoCRWDAO;
	}

	public void setAmortizaFondeoCRWDAO(AmortizaFondeoCRWDAO amortizaFondeoCRWDAO) {
		this.amortizaFondeoCRWDAO = amortizaFondeoCRWDAO;
	}

}