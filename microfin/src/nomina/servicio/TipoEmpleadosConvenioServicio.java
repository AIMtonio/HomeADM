package nomina.servicio;

import java.util.ArrayList;
import java.util.List;


import nomina.bean.TipoEmpleadosConvenioBean;
import nomina.dao.TipoEmpleadosConvenioDAO;
import nomina.servicio.ConveniosNominaServicio.Enum_Tra_Convenios;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TipoEmpleadosConvenioServicio extends BaseServicio{
	TipoEmpleadosConvenioDAO tipoEmpleadosConvenioDAO = null;
		public TipoEmpleadosConvenioServicio() {
			super();
			// TODO Auto-generated constructor stub
		}
		
	
		public static interface Enum_Transaccion_Convenios{
			int alta	= 1;
			
		}
	// -------------- Tipo Lista ----------------
		public static interface Enum_Lis_Convenios{
			int lisTipoEmplConv	= 1;
			int listaComboTiposEmp	= 2;
			int listaTiposEmpConvNom = 3;
		}
		
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	TipoEmpleadosConvenioBean tipoEmpleadosConvenioBean){
			ArrayList listaTipoEmplConvenio = (ArrayList) creaListaDetalle(tipoEmpleadosConvenioBean);
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			switch (tipoTransaccion) {
				case Enum_Transaccion_Convenios.alta:		
					mensaje = tipoEmpleadosConvenioDAO.grabarTipoEmpleadoConv(tipoEmpleadosConvenioBean,listaTipoEmplConvenio);
				break ;	
			}
			return mensaje;
			
			}
		
		public List lista(int tipoLista,TipoEmpleadosConvenioBean tipoEmpleadosConvenioBean){
			List cargalisTipoEmplConv = null;
			switch (tipoLista) {
		        case Enum_Lis_Convenios.lisTipoEmplConv:
		        	cargalisTipoEmplConv = tipoEmpleadosConvenioDAO.listaTipoEmplConv(tipoEmpleadosConvenioBean,tipoLista);
				break;
		        case Enum_Lis_Convenios.listaTiposEmpConvNom:
		        	cargalisTipoEmplConv = tipoEmpleadosConvenioDAO.listaTipoEmpleadoConvenio(tipoEmpleadosConvenioBean,tipoLista);
				break;
			}
			return cargalisTipoEmplConv;
		}
		

		public List listaCombo(int tipoLista,TipoEmpleadosConvenioBean tipoEmpleadosConvenioBean){
			List cargaListaConvenios = null;
			switch (tipoLista) {
		        case Enum_Lis_Convenios.listaComboTiposEmp:
		        	cargaListaConvenios = tipoEmpleadosConvenioDAO.listaComboTipoEmpleados(tipoEmpleadosConvenioBean,tipoLista);
				break;
			}
			return cargaListaConvenios;
		}
		
		public List creaListaDetalle(	TipoEmpleadosConvenioBean tipoEmpleadosConvenioBean) {
			List<String> tipoEmplConv1  = tipoEmpleadosConvenioBean.getListaTipoEmpleadoID();
			List<String> tipoEmplConv2  = tipoEmpleadosConvenioBean.getListaSinTratamiento();
			List<String> tipoEmplConv3  = tipoEmpleadosConvenioBean.getListaConTratamiento();
			List<String> tipoEmplConv4  = tipoEmpleadosConvenioBean.getListaSeleccionado();
			ArrayList listaDetalle = new ArrayList();
			TipoEmpleadosConvenioBean tipoEmpleadosConvenio = null;	
				if(tipoEmplConv1 != null){
					int tamanio = tipoEmplConv1.size();			
					for (int i = 0; i < tamanio; i++) {
						tipoEmpleadosConvenio = new TipoEmpleadosConvenioBean();
						tipoEmpleadosConvenio.setInstitNominaID(tipoEmpleadosConvenioBean.getInstitNominaID());
						tipoEmpleadosConvenio.setConvenioNominaID(tipoEmpleadosConvenioBean.getConvenioNominaID());
						
						tipoEmpleadosConvenio.setTipoEmpleadoID(tipoEmplConv1.get(i));
						tipoEmpleadosConvenio.setSinTratamiento(tipoEmplConv2.get(i));
						tipoEmpleadosConvenio.setConTratamiento(tipoEmplConv3.get(i));
						tipoEmpleadosConvenio.setSeleccionado((tipoEmplConv4.get(i)));
						listaDetalle.add(tipoEmpleadosConvenio);
					}
					
				}
			return listaDetalle;
				
			}
		
		public TipoEmpleadosConvenioDAO getTipoEmpleadosConvenioDAO() {
			return tipoEmpleadosConvenioDAO;
		}
		public void setTipoEmpleadosConvenioDAO(
				TipoEmpleadosConvenioDAO tipoEmpleadosConvenioDAO) {
			this.tipoEmpleadosConvenioDAO = tipoEmpleadosConvenioDAO;
		}
	
	
}
