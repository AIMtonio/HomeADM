package tesoreria.servicio;

import java.util.List;

import tesoreria.bean.TipoPagoProvBean;
import tesoreria.dao.TipoPagoProvDAO;
import general.servicio.BaseServicio;

public class TipoPagoProvServicio extends BaseServicio{
	TipoPagoProvDAO tipoPagoProvDAO=null;
	public TipoPagoProvServicio(){
		super();
	}
	
	public static interface Enum_Lis_TipoPagoProv{
		int listaCombo = 1;
	}
	
	// listas para comboBox
	public  Object[] listaTipoPagoProv(int tipoLista,TipoPagoProvBean tipoPagoProvBean) {
		List listaTipoPago = null;
		switch(tipoLista){
			case (Enum_Lis_TipoPagoProv.listaCombo): 
				listaTipoPago =  tipoPagoProvDAO.listaTipoPago(tipoPagoProvBean, tipoLista);
				break;
		}
		return listaTipoPago.toArray();
	}

	public TipoPagoProvDAO getTipoPagoProvDAO() {
		return tipoPagoProvDAO;
	}

	public void setTipoPagoProvDAO(TipoPagoProvDAO tipoPagoProvDAO) {
		this.tipoPagoProvDAO = tipoPagoProvDAO;
	}

	

}