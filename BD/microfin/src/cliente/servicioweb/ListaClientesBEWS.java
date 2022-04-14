package cliente.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;




import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ListaClientesBERequest;
import cliente.BeanWS.Response.ListaClientesBEResponse;
import cliente.servicio.ClienteServicio;

public class ListaClientesBEWS extends AbstractMarshallingPayloadEndpoint {

	public ListaClientesBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	ClienteServicio clienteServicio=null;
	
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");	
	
	private ListaClientesBEResponse listaClientes(ListaClientesBERequest listaClientesBERequest){
		clienteServicio.getClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ListaClientesBEResponse  listaClientesBEResponse = (ListaClientesBEResponse)
				clienteServicio.listaClientesBEWS( listaClientesBERequest);
		return listaClientesBEResponse;
	}
	

	protected Object invokeInternal(Object arg0) throws Exception {
		ListaClientesBERequest listaClientesBERequest = (ListaClientesBERequest)arg0; 							
		return listaClientes(listaClientesBERequest);
		
	}


	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}


	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}
	

}
