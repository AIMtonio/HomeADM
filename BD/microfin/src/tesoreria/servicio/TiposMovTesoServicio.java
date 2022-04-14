package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import tesoreria.bean.TiposMovTesoBean;
import tesoreria.dao.TiposMovTesoDAO;
import java.util.List;

import cuentas.servicio.TiposCuentaServicio.Enum_Lis_TiposCuenta;

public class TiposMovTesoServicio extends BaseServicio {
	
	private TiposMovTesoServicio(){
		super();
	}
	  
	TiposMovTesoDAO tiposMovTesoDAO = null;
	
	public static interface Enum_Lis_TiposMov{
		int principal = 1;
		int conciliacion = 2;
	}
	
	public static interface Enum_Con_TiposMov{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Tra_TiposMov{
		int alta = 1;
		int modificacion = 2;
	}
	final String tipoConciliado="C";
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,TiposMovTesoBean tiposMovTesoBean){
		MensajeTransaccionBean mensaje = null;
		tiposMovTesoBean.setTipoMovimiento(tipoConciliado);
		switch(tipoTransaccion){
		case Enum_Tra_TiposMov.alta:
			mensaje = tiposMovTesoDAO.altaTiposMovTeso(tiposMovTesoBean);
			break;
		case Enum_Tra_TiposMov.modificacion:
			mensaje = tiposMovTesoDAO.ModTiposMovTeso(tiposMovTesoBean);
			break;
		
		}
		return mensaje;
	}
	
	
	public List lista (int tipoLista,TiposMovTesoBean tiposMovTesoBean){
		List listaResultado=null;
		switch(tipoLista){
		
		case Enum_Lis_TiposMov.principal:
			tiposMovTesoBean.setTipoMovimiento(tipoConciliado);
			listaResultado = tiposMovTesoDAO.listaTiposMovTeso(tipoLista, tiposMovTesoBean);
			break;
		
		}
		return listaResultado;
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista, TiposMovTesoBean tiposMovTesoBean) {
		List listaTiposMovConciliacion = null;
		switch(tipoLista){
			case (Enum_Lis_TiposMov.conciliacion): // se llama a la tista de tipos de Mov de conciliacion
				listaTiposMovConciliacion =  tiposMovTesoDAO.listaTiposMovTesoConciliacion(tipoLista, tiposMovTesoBean);
				break;
		}
		return listaTiposMovConciliacion.toArray();		
	}
	
	public TiposMovTesoBean conTiposMovTeso (int tipoCon,TiposMovTesoBean tiposMovTesoBean){
		TiposMovTesoBean TiMovTesoBean = null;
		switch (tipoCon){
			case Enum_Con_TiposMov.principal:
				tiposMovTesoBean.setTipoMovimiento(tipoConciliado);
				TiMovTesoBean = tiposMovTesoDAO.consultaTiposMovTeso(tipoCon, tiposMovTesoBean);
				break;
				
			case Enum_Con_TiposMov.foranea:
				tiposMovTesoBean.setTipoMovimiento(Constantes.STRING_VACIO);
				TiMovTesoBean = tiposMovTesoDAO.consultaTiposMovTesoForanea(tipoCon, tiposMovTesoBean);
				break;
		}
		return TiMovTesoBean;
		
	}
	
	public void setTiposMovTesoDAO(TiposMovTesoDAO tiposMovTesoDAO){
		this.tiposMovTesoDAO=tiposMovTesoDAO;
	}
	
	public TiposMovTesoDAO getTiposMovTesoDAO(){
		return this.tiposMovTesoDAO;
	}
}
