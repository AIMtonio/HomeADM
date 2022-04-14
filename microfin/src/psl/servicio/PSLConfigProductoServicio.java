package psl.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import psl.bean.PSLConfigProductoBean;
import psl.bean.PSLParamBrokerBean;
import psl.dao.PSLConfigProductoDAO;

public class PSLConfigProductoServicio extends BaseServicio {
	PSLConfigProductoDAO pslConfigProductoDAO;
	
	public static interface Enum_Con_PSLConfigProducto {
		int ConsultaConfiguracionProducto	= 1;
	}
	
	public static interface Enum_Lis_PSLConfigProducto {
		int ListaProductosActivosVentanilla	= 1;
		int ListaPorServicio 				= 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PSLParamBrokerBean paramBrokerBean){
		MensajeTransaccionBean mensaje = null;
		return mensaje;
	}
	
	public PSLConfigProductoBean consulta(int tipoConsulta, PSLConfigProductoBean pslConfigProductoBean) {
		loggerSAFI.info("PSLConfigProductoServicio.consulta");
				
		PSLConfigProductoBean result = null;	
		switch(tipoConsulta){
			case Enum_Con_PSLConfigProducto.ConsultaConfiguracionProducto:
				result = pslConfigProductoDAO.consultaConfiguracionProducto(pslConfigProductoBean, tipoConsulta);
				break;
		}	
		
		return result;		
	}

	public List lista(int tipoLista, PSLConfigProductoBean pslConfigProductoBean) {
		loggerSAFI.info("PSLConfigProductoServicio.lista");
		
		List listaConfiguracionProductos = null;		
		switch(tipoLista){
			case Enum_Lis_PSLConfigProducto.ListaProductosActivosVentanilla:
				listaConfiguracionProductos = pslConfigProductoDAO.listaProductosActivosVentanilla(pslConfigProductoBean, tipoLista);
				break;
			case (Enum_Lis_PSLConfigProducto.ListaPorServicio): 
				//Consultamos la configuracion de los productos por servicio y clasificacion
				listaConfiguracionProductos = pslConfigProductoDAO.listaPorServicio(pslConfigProductoBean, tipoLista);
				break;
		}
		
		return listaConfiguracionProductos;
	}

	public PSLConfigProductoDAO getPslConfigProductoDAO() {
		return pslConfigProductoDAO;
	}

	public void setPslConfigProductoDAO(PSLConfigProductoDAO pslConfigProductoDAO) {
		this.pslConfigProductoDAO = pslConfigProductoDAO;
	}
}
