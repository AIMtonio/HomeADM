package cliente.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ListaClienteRequest;
import cliente.BeanWS.Response.ListaClienteResponse;
import cliente.servicio.ClienteServicio;

public class ListaClientesWS extends AbstractMarshallingPayloadEndpoint {
	ClienteServicio clienteServicio = null;

	public ListaClientesWS(Marshaller marshaller) {
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}
	
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");	

	private ListaClienteResponse listaCliente(ListaClienteRequest listaClienteRequest){
		clienteServicio.getClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);

		ListaClienteResponse  listaClienteResponse = 
				(ListaClienteResponse) clienteServicio.listaClienteWS
				(ClienteServicio.Enum_Lis_Cliente.listaClienteWS, listaClienteRequest);
	return listaClienteResponse;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		ListaClienteRequest listaClienteRequest = (ListaClienteRequest)arg0; 			
	return listaCliente(listaClienteRequest);
}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

}
