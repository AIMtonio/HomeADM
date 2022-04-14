package soporte.servicio;

import java.util.List;

import soporte.bean.TiposPuestosBean;
import soporte.dao.TiposPuestosDAO;
import general.servicio.BaseServicio;

public class TiposPuestosServicio extends BaseServicio{

	TiposPuestosDAO tiposPuestosDAO = null;			   

	
	//---------- Tipo de Lista ----------------------------------------------------------------
		public static interface Enum_Lis_TiposPuestos{
			int principal = 1;
		}
		
		
		
		public  List listaCombo(int tipoConsulta, TiposPuestosBean tiposPuestosBean){
			List listTipPuestos= null;
			switch(tipoConsulta){
				case Enum_Lis_TiposPuestos.principal:
					listTipPuestos= tiposPuestosDAO.listaTiposPuestos(tiposPuestosBean, tipoConsulta);
				break;
			}
			return listTipPuestos;
		}



		public TiposPuestosDAO getTiposPuestosDAO() {
			return tiposPuestosDAO;
		}


		public void setTiposPuestosDAO(TiposPuestosDAO tiposPuestosDAO) {
			this.tiposPuestosDAO = tiposPuestosDAO;
		}
		
}
