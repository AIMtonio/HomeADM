package fondeador.servicio;

import java.util.List;

import fondeador.bean.TipoFondeadorBean;
import fondeador.dao.TipoFondeadorDAO;
import general.servicio.BaseServicio;

public class TipoFondeadorServicio extends BaseServicio {
	//---------- Variabless ------------------------------------------------------------------------
	 TipoFondeadorDAO tipoFondeadorDAO = null;
	 
	public TipoFondeadorServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Fondeador {
		int principal = 1;
		int comboTipFondAct = 2;
	}
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
		public static interface Enum_Con_Fondeador {
			int principal = 1;
		}
	
	public List lista(int tipoLista, TipoFondeadorBean tipoFondeadorBean){		
		List listaTipoFondeador = null;
		switch (tipoLista) {
			case Enum_Lis_Fondeador.principal:		
				listaTipoFondeador = tipoFondeadorDAO.listaPrincipal(tipoFondeadorBean, tipoLista);				
				break;
			
		}		
		return listaTipoFondeador;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaTipoFondeador = null;
		switch(tipoLista){
		case Enum_Lis_Fondeador.comboTipFondAct:		
			listaTipoFondeador = tipoFondeadorDAO.listaComboTiposFondAct(tipoLista);				
			break;
		}
		return listaTipoFondeador.toArray();		
	}
	
	public TipoFondeadorBean consulta(int tipoConsulta, TipoFondeadorBean TipoFondeadorBean){
		TipoFondeadorBean TipoFondeador = null;
		switch(tipoConsulta){
			case Enum_Con_Fondeador.principal:
				TipoFondeador = tipoFondeadorDAO.consultaPrincipal(TipoFondeadorBean, Enum_Con_Fondeador.principal);
			break;
		}
		return TipoFondeador;
	}

	public TipoFondeadorDAO getTipoFondeadorDAO() {
		return tipoFondeadorDAO;
	}

	public void setTipoFondeadorDAO(TipoFondeadorDAO tipoFondeadorDAO) {
		this.tipoFondeadorDAO = tipoFondeadorDAO;
	}
	
}
