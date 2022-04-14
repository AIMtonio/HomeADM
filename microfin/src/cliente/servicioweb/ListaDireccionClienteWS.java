package cliente.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ListaDireccionClienteRequest;
import cliente.BeanWS.Response.ListaDireccionClienteResponse;
import cliente.servicio.DireccionesClienteServicio;

public class ListaDireccionClienteWS  extends AbstractMarshallingPayloadEndpoint{
	DireccionesClienteServicio direccionesclienteServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");	

	public ListaDireccionClienteWS(Marshaller marshaller) {
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}

	private ListaDireccionClienteResponse listaDireccionCliente(ListaDireccionClienteRequest listaDireccionClienteRequest){
		direccionesclienteServicio.getDireccionesClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ListaDireccionClienteResponse  listaDireccionClienteResponse = (ListaDireccionClienteResponse) 
				direccionesclienteServicio.listaDireccionWS(listaDireccionClienteRequest);
		return listaDireccionClienteResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		ListaDireccionClienteRequest listaDireccionClienteRequest = (ListaDireccionClienteRequest)arg0; 			
		return listaDireccionCliente(listaDireccionClienteRequest);
}
	public DireccionesClienteServicio getDireccionesclienteServicio() {
		return direccionesclienteServicio;
	}
	public void setDireccionesclienteServicio(
			DireccionesClienteServicio direccionesclienteServicio) {
		this.direccionesclienteServicio = direccionesclienteServicio;
	}
}