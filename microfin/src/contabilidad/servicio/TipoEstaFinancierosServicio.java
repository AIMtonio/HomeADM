package contabilidad.servicio;

import java.util.List;

import contabilidad.bean.TipoEstaFinancieroBean;
import contabilidad.dao.TipoEstaFinancieroDAO;
import general.servicio.BaseServicio;

public class TipoEstaFinancierosServicio extends BaseServicio{
	
	TipoEstaFinancieroDAO tipoEstaFinancieroDAO=null;
	
	public static interface Enum_Lis_TipsEstaFinan {
		int principal = 1;
		int combo = 2;
	}
	
	public TipoEstaFinancierosServicio() {
		super();
	}
	public  Object[] listaCombo(TipoEstaFinancieroBean tipoEstaFinancieroBean,int tipoLista) {
		List listatipoEstodosFinancieros = null;
		switch(tipoLista){
			case (Enum_Lis_TipsEstaFinan.combo): 
				listatipoEstodosFinancieros =  tipoEstaFinancieroDAO.listatipoEstadoFinan(tipoEstaFinancieroBean, tipoLista);
				break;
		}
		return listatipoEstodosFinancieros.toArray();		
	}
	public TipoEstaFinancieroDAO getTipoEstaFinancieroDAO() {
		return tipoEstaFinancieroDAO;
	}
	public void setTipoEstaFinancieroDAO(TipoEstaFinancieroDAO tipoEstaFinancieroDAO) {
		this.tipoEstaFinancieroDAO = tipoEstaFinancieroDAO;
	}
	
}
