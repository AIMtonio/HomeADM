package cliente.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ConsultaClienteRequest;
import cliente.BeanWS.Response.ConsultaClienteResponse;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;

public class ClienteWS extends AbstractMarshallingPayloadEndpoint {
	ClienteServicio clienteServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ClienteWS(Marshaller marshaller) {
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}

	public static interface Enum_Lis_Actividad {
		int principal = 1;
		int filtrada=2;

	}
	private ConsultaClienteResponse consultaCliente(ConsultaClienteRequest clienteRequest){
		ClienteBean clienteBean = new ClienteBean();
		ConsultaClienteResponse clienteResponse = new ConsultaClienteResponse();
			
		clienteServicio.getClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		clienteBean.setNumero(clienteRequest.getNumero());
		clienteBean = clienteServicio.consulta(ClienteServicio.Enum_Con_Cliente.principalWS,
												  clienteBean.getNumero(), "Vacio");
		
		clienteResponse.setNumero(clienteBean.getNumero());
		clienteResponse.setNombreCompleto(clienteBean.getNombreCompleto());

		clienteResponse.setRfc(clienteBean.getRFC());
		clienteResponse.setCalificaCredito(clienteBean.getCalificaCredito());

		return clienteResponse;
	}
	
	public void setClienteServicio(ClienteServicio clienteServicio) {
	
		this.clienteServicio = clienteServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		
		ConsultaClienteRequest clienteRequest = (ConsultaClienteRequest)arg0; 			
						
		return consultaCliente(clienteRequest);
		
	}
	

	
}
