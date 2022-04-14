package contabilidad.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import contabilidad.bean.TipoInstrumentosBean;
import contabilidad.dao.TipoInstrumentosDAO;



public class TipoInstrumentosServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	TipoInstrumentosDAO tipoInstrumentosDAO = null;
	
	//---------- Constructor ------------------------------------------------------------------------
	public TipoInstrumentosServicio() {
		super();
	// TODO Auto-generated constructor stub
	}
	public static interface Enum_Con_tipoInstrumentos{
		int tipoInstrumentos = 1;
		int tipoInstrumPrin= 3;				// Lista Instrumentos Principales del Safi
	}
	public static interface Enum_Lis_tipoInstrumentos{
		int listaPrincipal = 2;
	}
	
	public static interface Enum_TipoInstrumentosConsulta{
		int principal = 1;
	}
	
	
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaTipoInstrumentos = null;
		switch(tipoLista){
			case Enum_Con_tipoInstrumentos.tipoInstrumentos:
			case Enum_Con_tipoInstrumentos.tipoInstrumPrin:
				listaTipoInstrumentos = tipoInstrumentosDAO.listaTipoInstrumentos( tipoLista);
			break;					
		}
		return listaTipoInstrumentos.toArray();		
	}
	
	
	public List lista(int tipoLista,TipoInstrumentosBean tipoInstrumentosBean){	
		List listaInstrumento = null;
		switch (tipoLista) {
			case Enum_Lis_tipoInstrumentos.listaPrincipal:
				listaInstrumento = tipoInstrumentosDAO.lista(tipoInstrumentosBean,tipoLista);
			break;		
		}		
		return listaInstrumento;
	}	
	
	public TipoInstrumentosBean consulta(int tipoConsulta, TipoInstrumentosBean tipoInstrumentosBean){
		TipoInstrumentosBean tipoInstrumentos = null;
		switch (tipoConsulta) {
			case Enum_TipoInstrumentosConsulta.principal:	
				tipoInstrumentos = tipoInstrumentosDAO.consultaPrincipal(tipoInstrumentosBean,tipoConsulta);
				break;				
		}
		return tipoInstrumentos;
	}
	


	public void setTipoInstrumentosDAO(TipoInstrumentosDAO tipoInstrumentosDAO) {
		this.tipoInstrumentosDAO = tipoInstrumentosDAO;
	}

	
}