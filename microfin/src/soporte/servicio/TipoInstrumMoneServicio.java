package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.List;

import pld.bean.ParametrosOpRelBean;
import pld.servicio.ParametrosOpRelServicio.Enum_Con_ParOpRel;

import soporte.bean.TipoInstrumMoneBean;
import soporte.dao.TipoInstrumMoneDAO;

import cliente.bean.SucursalesBean;
import cliente.dao.SucursalesDAO;
import cliente.servicio.SucursalesServicio.Enum_Con_Sucursal;
import cliente.servicio.SucursalesServicio.Enum_Lis_Sucursal;
import cliente.servicio.SucursalesServicio.Enum_Tra_Sucursal;

public class TipoInstrumMoneServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------
	TipoInstrumMoneDAO tipoInstrumMoneDAO = null;

			//---------- Tipod de Consulta ----------------------------------------------------------------
			public static interface Enum_Con_TipoInstrum{
				int principal = 1;
				int foranea = 2;
						
			}

			public static interface Enum_Lis_TipoInstrum {
				int principal = 1;
				int combo = 2;
			}
			public static interface Enum_Tra_TipoInstrum {
				int alta = 1;
				int modificacion = 2;

			}

			
			public TipoInstrumMoneServicio () {
				super();
				// TODO Auto-generated constructor stub
			}
			
			public TipoInstrumMoneBean consulta(int tipoConsulta,TipoInstrumMoneBean tipoInstrum){
				TipoInstrumMoneBean tipoInstrumMone = null;
				switch(tipoConsulta){
					case Enum_Con_TipoInstrum.foranea:
						tipoInstrumMone = tipoInstrumMoneDAO.consultaForanea(tipoInstrum,tipoConsulta);
					break;
					
				}
				return tipoInstrumMone;
			}
			

			public Object[] listaCombo(int tipoLista){ 
				List listaInstrumentos = null;
				switch (tipoLista) {
					case Enum_Lis_TipoInstrum.combo:		
						listaInstrumentos=  tipoInstrumMoneDAO.listaComboInstrumentos(tipoLista);				
						break;				
				}		
				return listaInstrumentos.toArray();
			}


			//------------------ Geters y Seters ------------------------------------------------------	
		
			public void setTipoInstrumMoneDAO(TipoInstrumMoneDAO tipoInstrumMoneDAO) {
				this.tipoInstrumMoneDAO = tipoInstrumMoneDAO;
			}	

}
