package cliente.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ConsultaClientesRequest;
import cliente.BeanWS.Response.ConsultaClientesResponse;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;
import cliente.servicio.ClienteServicio.Enum_Con_ClienteWS;

public class ConsultaClientesWS extends AbstractMarshallingPayloadEndpoint{
	ClienteServicio clienteServicio = null;
	
	public ConsultaClientesWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaClientesResponse consultaClientes(ConsultaClientesRequest consultaClientesRequest){	
		ConsultaClientesResponse consultaClientesResponse= new ConsultaClientesResponse();
		ClienteBean clienteBean = new ClienteBean();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		clienteServicio.getClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);

		clienteBean.setClienteID(consultaClientesRequest.getClienteID());
		
		clienteBean= clienteServicio.consultaWS(Enum_Con_ClienteWS.conClienteWS,clienteBean);
		if(clienteBean==null){
			consultaClientesResponse.setClienteID(Constantes.STRING_VACIO);
			consultaClientesResponse.setNombreCompleto(Constantes.STRING_VACIO);
			consultaClientesResponse.setPrimerNombre(Constantes.STRING_VACIO);
			consultaClientesResponse.setSegundoNombre(Constantes.STRING_VACIO);
			consultaClientesResponse.setApellidoPaterno(Constantes.STRING_VACIO);
			consultaClientesResponse.setApellidoMaterno(Constantes.STRING_VACIO);
			consultaClientesResponse.setCorreo(Constantes.STRING_VACIO);
			consultaClientesResponse.setTelefonoCelular(Constantes.STRING_VACIO);
		}
		else{
			consultaClientesResponse.setClienteID(clienteBean.getClienteID());
			consultaClientesResponse.setNombreCompleto(clienteBean.getNombreCompleto());
			consultaClientesResponse.setPrimerNombre(clienteBean.getPrimerNombre());
			consultaClientesResponse.setSegundoNombre(clienteBean.getSegundoNombre());
			consultaClientesResponse.setApellidoPaterno(clienteBean.getApellidoPaterno());
			consultaClientesResponse.setApellidoMaterno(clienteBean.getApellidoMaterno());
			consultaClientesResponse.setCorreo(clienteBean.getCorreo());
			consultaClientesResponse.setTelefonoCelular(clienteBean.getTelefonoCelular());
		}
		return consultaClientesResponse;
		}
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaClientesRequest consultaClientesRequest = (ConsultaClientesRequest)arg0; 							
		return consultaClientes(consultaClientesRequest);
	}
	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}
	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}
	

}
