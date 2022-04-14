package cliente.servicioweb;

import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ConsultaDireccionClienteRequest;
import cliente.BeanWS.Response.ConsultaDireccionClienteResponse;
import cliente.bean.DireccionesClienteBean;
import cliente.servicio.DireccionesClienteServicio;

public class DireccionesClienteWS extends AbstractMarshallingPayloadEndpoint {
	DireccionesClienteServicio direccionesclienteServicio = null;
	
	
	public void setDireccionesclienteServicio(
			DireccionesClienteServicio direccionesclienteServicio) {
		this.direccionesclienteServicio = direccionesclienteServicio;
	}

	public DireccionesClienteWS(Marshaller marshaller) {
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaDireccionClienteResponse consultadireccionCliente(ConsultaDireccionClienteRequest direccionclienteRequest){
		DireccionesClienteBean direccionesclienteBean = new DireccionesClienteBean();
		ConsultaDireccionClienteResponse direccionclienteResponse = new ConsultaDireccionClienteResponse();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		direccionesclienteServicio.getDireccionesClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
	
		direccionesclienteBean.setClienteID(direccionclienteRequest.getNumero());
		
		direccionesclienteBean = direccionesclienteServicio.consulta(4,direccionesclienteBean);
		
		direccionclienteResponse.setNumero(direccionesclienteBean.getClienteID());
		direccionclienteResponse.setDireccionCompleta(direccionesclienteBean.getDireccionCompleta());
		return direccionclienteResponse;
	}
	
	
	protected Object invokeInternal(Object arg0) throws Exception {
		
		ConsultaDireccionClienteRequest consultadireccionClienteRequest = (ConsultaDireccionClienteRequest)arg0; 			
						
		return consultadireccionCliente(consultadireccionClienteRequest);
		
	}
	

	
}
