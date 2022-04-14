package tesoreria.servicio;

import java.util.ArrayList;
import java.util.List;

import soporte.bean.AsamGralUsuarioAutBean;
import soporte.servicio.AsamGralUsuarioAutServicio.Enum_Lis_Usuarios;
import tesoreria.bean.TipoproveimpuesBean;
import tesoreria.dao.TipoproveimpuesDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TipoproveimpuesServicio extends BaseServicio {
	
	//---------- Variables ------------------------------------------------------------------------
	TipoproveimpuesDAO tipoproveimpuesDAO = null;
	
	public TipoproveimpuesServicio () {
		super();
	}

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_TipoProImp{
		int principal   = 1;
		int listacombo 	= 2;
		int listaGrid 	= 3;
		
	}
	public static interface Enum_Tra_TipoProvee {
		int graba = 1;

	}
	
	public static interface Enum_Con_TipoProvee {
		int principal = 1;
		int foranea =2;
		int actualizacion = 3;
	}



	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TipoproveimpuesBean tipoproveimpuesBean){
		ArrayList listaBean = (ArrayList) creaListaImpuestos(tipoproveimpuesBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch(tipoTransaccion){
		case Enum_Tra_TipoProvee.graba:
			mensaje = tipoproveimpuesDAO.grabaImpuestosProveedor(tipoproveimpuesBean, listaBean);
			break;

			}
		return mensaje;

	}
		
	
	// Consulta de tipo de proveedor impuesto
	public TipoproveimpuesBean consulta(int tipoConsulta, String tipoProveedorID, String impuestoID){
		TipoproveimpuesBean tipoprovee= null;
		switch(tipoConsulta){
			case Enum_Con_TipoProvee.principal:
				tipoprovee = tipoproveimpuesDAO.consultaPrincipal(Integer.parseInt(tipoProveedorID), Integer.parseInt(impuestoID), tipoConsulta);
			break;
			case Enum_Con_TipoProvee.foranea:
			//	tipoprovee = tipoproveimpuesDAO.consultaForanea(tipoproveimpuesBean, tipoConsulta);
			break;
		
		}
		return tipoprovee;
	}

	// listas para comboBox
		public  Object[] listaCombo(int tipoLista,TipoproveimpuesBean tipoproveimpuesBean) {
			List listaImpuestos = null;
			switch(tipoLista){
				case (Enum_Lis_TipoProImp.listacombo): 
					listaImpuestos =  tipoproveimpuesDAO.listaImpuestosPorTipo(tipoproveimpuesBean, tipoLista);
					break;
			}
			return listaImpuestos.toArray();		
		}

		
		
		
		/* Arma la lista de beans */
		public List creaListaImpuestos(TipoproveimpuesBean bean) {		
			List<String> tipoProveedorID = bean.getLtipoProveedorID();
			List<String> impuestoID = bean.getLimpuestoID();
			List<String> orden = bean.getLorden();
			
			ArrayList listaDetalle = new ArrayList();
			TipoproveimpuesBean beanAux = null;	
			
			if(tipoProveedorID != null){
				int tamanio = tipoProveedorID.size();			
				for (int i = 0; i < tamanio; i++) {
					beanAux = new TipoproveimpuesBean();
					beanAux.setTipoProveedorID(tipoProveedorID.get(i));
					beanAux.setImpuestoID(impuestoID.get(i));
					beanAux.setOrden(orden.get(i));

					listaDetalle.add(beanAux);
				}
			}
			return listaDetalle;
		}

		
		//lista para el grid de impuestos por proveedor				
		public List listaImpuestos(String tipoProveedorID, int tipoLista, TipoproveimpuesBean tipoproveimpuesBean){		
			List listaImpuestos= null;
			switch (tipoLista) {
				case Enum_Lis_TipoProImp.principal:		
					listaImpuestos = tipoproveimpuesDAO.listaImpuestosPorTipo(tipoproveimpuesBean, tipoLista);				
					break;	
				case Enum_Lis_TipoProImp.listaGrid:		
					listaImpuestos = tipoproveimpuesDAO.listaImpuestosGrid(tipoproveimpuesBean, tipoLista, Integer.parseInt(tipoProveedorID));				
					break;

			}		
			return listaImpuestos;
		}
	//------------------ Geters y Seters ------------------------------------------------------	

	public TipoproveimpuesDAO getTipoproveimpuesDAO() {
		return tipoproveimpuesDAO;
	}


	public void setTipoproveimpuesDAO(TipoproveimpuesDAO tipoproveimpuesDAO) {
		this.tipoproveimpuesDAO = tipoproveimpuesDAO;
	}

	
}
