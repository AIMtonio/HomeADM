package seguimiento.servicio;

import java.util.List;

import seguimiento.bean.SegtoOrigenPagoBean;
import seguimiento.dao.SegtoOrigenPagoDAO;

import general.servicio.BaseServicio;

public class SegtoOrigenPagoServicio extends BaseServicio{
	SegtoOrigenPagoDAO segtoOrigenPagoDAO = null;
	
	public SegtoOrigenPagoServicio(){
		super();
	}
	public static interface Enum_Lis_Origen{
		int principal = 1;
		int foranea = 2;
		int listaCombo = 3;
	}
	
	
	// listas para comboBox 
		public  Object[] listaCombo(SegtoOrigenPagoBean segtoOrigen, int tipoLista) {
			List listaOrigenPago = null;
			switch(tipoLista){
				case Enum_Lis_Origen.listaCombo: 
					listaOrigenPago = segtoOrigenPagoDAO.listaOrigenPago(segtoOrigen, tipoLista);
					break;
			}
			return listaOrigenPago.toArray();		
		}

		public SegtoOrigenPagoDAO getSegtoOrigenPagoDAO() {
			return segtoOrigenPagoDAO;
		}

		public void setSegtoOrigenPagoDAO(SegtoOrigenPagoDAO segtoOrigenPagoDAO) {
			this.segtoOrigenPagoDAO = segtoOrigenPagoDAO;
		}
}