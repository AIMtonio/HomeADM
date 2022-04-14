package seguimiento.servicio;

import java.util.List;

import seguimiento.bean.SegtoMotNoPagoBean;
import seguimiento.dao.SegtoMotNoPagoDAO;
import general.dao.BaseDAO;

public class SegtoMotNoPagoServicio extends BaseDAO{
	
	SegtoMotNoPagoDAO segtoMotNoPagoDAO = null;
	public SegtoMotNoPagoServicio(){
		super();
	}
	public static interface Enum_Lis_NoPago{
		int principal = 1;
		int foranea = 2;
		int listaCombo = 3;
	}
	
	
	// listas para comboBox 
		public  Object[] listaCombo(SegtoMotNoPagoBean segtoOrigen, int tipoLista) {
			List listaOrigenPago = null;
			switch(tipoLista){
				case Enum_Lis_NoPago.listaCombo: 
					listaOrigenPago = segtoMotNoPagoDAO.listaMotivoNP(segtoOrigen, tipoLista);
					break;
			}
			return listaOrigenPago.toArray();		
		}
	
	
	
	public SegtoMotNoPagoDAO getSegtoMotNoPagoDAO() {
		return segtoMotNoPagoDAO;
	}
	public void setSegtoMotNoPagoDAO(SegtoMotNoPagoDAO segtoMotNoPagoDAO) {
		this.segtoMotNoPagoDAO = segtoMotNoPagoDAO;
	}
}