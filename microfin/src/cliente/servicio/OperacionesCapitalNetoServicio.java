package cliente.servicio;

import java.util.List;


import cliente.bean.OperacionesCapitalNetoBean;
import cliente.dao.OperacionesCapitalNetoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class OperacionesCapitalNetoServicio extends BaseServicio{
	
	OperacionesCapitalNetoDAO operacionesCapitalNetoDAO = null;
	
	public OperacionesCapitalNetoServicio() {
		super();
	}

	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Tra_OperCapNeto {
		int autorizacion		 = 1;
		int rechazo		 		= 2;
	}
	
	/* Enumera los tipo de consulta */
	public static interface Enum_Con_OperCapNeto { 
		int principal 			= 1;
		int instrumento			= 2;
	}
	/* Enumera los tipos de lista */
	public static interface Enum_Lis_OperCapNeto{
		int principal 				= 1;
	}
	
	
	/* Controla el tipo de transaccion*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, OperacionesCapitalNetoBean operacionesCapitalNetoBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {		
			case Enum_Tra_OperCapNeto.autorizacion:
				mensaje = operacionesCapitalNetoDAO.autorizaOperCapitalNeto(operacionesCapitalNetoBean, tipoTransaccion);					
				break;
			case Enum_Tra_OperCapNeto.rechazo:
				mensaje = operacionesCapitalNetoDAO.autorizaOperCapitalNeto(operacionesCapitalNetoBean, tipoTransaccion);					
				break;
		}
		return mensaje;
	}
	
	/* controla el tipo de consulta */
	public OperacionesCapitalNetoBean consulta(int tipoConsulta,OperacionesCapitalNetoBean operCapitalNeto){						
		OperacionesCapitalNetoBean operacionesCapitalNetoBean = null;
		switch (tipoConsulta) {
			case Enum_Con_OperCapNeto.principal:		
				operacionesCapitalNetoBean = operacionesCapitalNetoDAO.consultaPrincipal(operCapitalNeto, tipoConsulta);				
			break;
			case Enum_Con_OperCapNeto.instrumento:		
				operacionesCapitalNetoBean = operacionesCapitalNetoDAO.consultaInstrumento(operCapitalNeto, tipoConsulta);				
			break;
		}
			
		return operacionesCapitalNetoBean;
	}
	
	/* controla los tipos de listas*/
	public List lista(int tipoLista, OperacionesCapitalNetoBean operCapitalNeto){		
		List listaOperCapitalNeto = null;
		switch (tipoLista) {
			case Enum_Lis_OperCapNeto.principal:		
				listaOperCapitalNeto = operacionesCapitalNetoDAO.listaPrincipal(operCapitalNeto, tipoLista);				
				break;
		}
				
		return listaOperCapitalNeto;
	}
	
	
	public OperacionesCapitalNetoDAO getOperacionesCapitalNetoDAO() {
		return operacionesCapitalNetoDAO;
	}

	public void setOperacionesCapitalNetoDAO(OperacionesCapitalNetoDAO operacionesCapitalNetoDAO) {
		this.operacionesCapitalNetoDAO = operacionesCapitalNetoDAO;
	}

	
	
}
