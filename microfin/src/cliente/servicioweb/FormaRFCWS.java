package cliente.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.FormaRFCRequest;
import cliente.BeanWS.Response.FormaRFCResponse;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;
import cliente.servicio.ClienteServicio.Enum_Con_Cliente;

public class FormaRFCWS extends AbstractMarshallingPayloadEndpoint {
	ClienteServicio clienteServicio = null;

	public FormaRFCWS(Marshaller marshaller) {
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}

	private FormaRFCResponse formaRFC(FormaRFCRequest formaRFCRequest){
		FormaRFCResponse  formaRFCResponse = new FormaRFCResponse();
		ClienteBean clienteBean= new ClienteBean();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		clienteServicio.getClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		clienteBean.setPrimerNombre(formaRFCRequest.getPrimerNombre());
		clienteBean.setApellidoPaterno(formaRFCRequest.getApellidoPaterno());
		clienteBean.setApellidoMaterno(formaRFCRequest.getApellidoMaterno());
		clienteBean.setFechaNacimiento(formaRFCRequest.getFechaNacimiento());
		
		clienteBean=clienteServicio.formaRFC(clienteBean);
		if(clienteBean==null){
			formaRFCResponse.setRFC(Constantes.STRING_VACIO);
		}else{
			formaRFCResponse.setRFC(clienteBean.getRFC());
		}
		
		return formaRFCResponse;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		FormaRFCRequest formaRFCRequest = (FormaRFCRequest)arg0; 			
	return formaRFC(formaRFCRequest);
	}

	
	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

}
