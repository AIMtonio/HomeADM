package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import soporte.bean.EdoCtaEnvioCorreoBean;
import soporte.dao.EdoCtaEnvioCorreoDAO;

public class EdoCtaEnvioCorreoServicio extends BaseServicio {
	EdoCtaEnvioCorreoDAO edoCtaEnvioCorreoDAO = null;
	
	public static interface Enum_Tra_EdoCtaEnvioCorreo {
		int actualizacion = 1;
		int importaEnvioCorreos = 2;
		int sincronizaCarpetasEdoCta = 3;
	}
	
	public static interface Enum_Lis_EdoCtaEnvioCorreo {
		int listaPorPeriodo = 2;
		int listaPorCliente = 4;
		int listaPeriodos 	= 5;
		int listaEdoCtas 	= 6;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_EdoCtaEnvioCorreo.actualizacion:
				ArrayList listaDetalleGrid = (ArrayList) detalleGrid(edoCtaEnvioCorreoBean);
				mensaje = edoCtaEnvioCorreoDAO.grabaDatosEnvioCorreo(edoCtaEnvioCorreoBean, listaDetalleGrid);
				break;
			case Enum_Tra_EdoCtaEnvioCorreo.importaEnvioCorreos:
				mensaje = edoCtaEnvioCorreoDAO.importaEdoCtasGenerados(edoCtaEnvioCorreoBean);
				break;
			case Enum_Tra_EdoCtaEnvioCorreo.sincronizaCarpetasEdoCta:
				mensaje = edoCtaEnvioCorreoDAO.sincronizaCarpetaEdoCta(edoCtaEnvioCorreoBean);
				break;
		}
		return mensaje;
	}
	
	public List lista(int tipoLista, EdoCtaEnvioCorreoBean edoCtaEnvioCorreo){
		List edoCtaEnvioCorreoBean = null;
		switch (tipoLista) {
			case Enum_Lis_EdoCtaEnvioCorreo.listaPorPeriodo:
				edoCtaEnvioCorreoBean = edoCtaEnvioCorreoDAO.listaPorPeriodo(tipoLista, edoCtaEnvioCorreo);
				break;
			case Enum_Lis_EdoCtaEnvioCorreo.listaPorCliente:
				edoCtaEnvioCorreoBean = edoCtaEnvioCorreoDAO.listaPorCliente(tipoLista, edoCtaEnvioCorreo);
				break;
			case Enum_Lis_EdoCtaEnvioCorreo.listaPeriodos:
				edoCtaEnvioCorreoBean = edoCtaEnvioCorreoDAO.listaPeriodos(tipoLista, edoCtaEnvioCorreo);
				break;
			case Enum_Lis_EdoCtaEnvioCorreo.listaEdoCtas:
				edoCtaEnvioCorreoBean = edoCtaEnvioCorreoDAO.listaEdoCtas(tipoLista, edoCtaEnvioCorreo);
				break;
		}
		return edoCtaEnvioCorreoBean;
	}
	
	private List detalleGrid(EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean){
		// Separa las listas del grid en beans individuales
		
		List<String> listaPeriodos			= edoCtaEnvioCorreoBean.getListaPeriodos();
		List<String> listaSucursales		= edoCtaEnvioCorreoBean.getListaSucursales();
		List<String> listaClientes			= edoCtaEnvioCorreoBean.getListaClientes();
		List<String> listaPDF				= edoCtaEnvioCorreoBean.getListaPDF();
		List<String> listaXML				= edoCtaEnvioCorreoBean.getListaXML();
		List<String> listaCorreo			= edoCtaEnvioCorreoBean.getListaCorreos();
		
		ArrayList listaDetalle = new ArrayList();
		
		EdoCtaEnvioCorreoBean iterEdoCtaEnvioCorreoBean  = null; 
		int tamanio = 0;
		if(listaPeriodos != null){
			tamanio = listaPeriodos.size();
		}

		for(int fila = 0; fila < tamanio; fila++){
			iterEdoCtaEnvioCorreoBean = new EdoCtaEnvioCorreoBean();
			iterEdoCtaEnvioCorreoBean.setAnioMes(listaPeriodos.get(fila));
			iterEdoCtaEnvioCorreoBean.setSucursalID(listaSucursales.get(fila));
			iterEdoCtaEnvioCorreoBean.setClienteID(listaClientes.get(fila));
			iterEdoCtaEnvioCorreoBean.setRutaPDF(listaPDF.get(fila));
			iterEdoCtaEnvioCorreoBean.setRutaXML(listaXML.get(fila));
			iterEdoCtaEnvioCorreoBean.setCorreo(listaCorreo.get(fila));
			
			listaDetalle.add(iterEdoCtaEnvioCorreoBean);
		}
		 
		return listaDetalle;
	}
	
	public EdoCtaEnvioCorreoDAO getEdoCtaEnvioCorreoDAO() {
		return edoCtaEnvioCorreoDAO;
	}
	
	public void setEdoCtaEnvioCorreoDAO(EdoCtaEnvioCorreoDAO edoCtaEnvioCorreoDAO) {
		this.edoCtaEnvioCorreoDAO = edoCtaEnvioCorreoDAO;
	}
}
