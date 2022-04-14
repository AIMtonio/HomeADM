package cliente.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;




import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ConsultaNomClienteBERequest;
import cliente.BeanWS.Response.ConsultaNomClienteBEResponse;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;




public class ConsultaNomClienteBEWS extends AbstractMarshallingPayloadEndpoint {

	public ConsultaNomClienteBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	ClienteServicio clienteServicio=null;
	
	private ConsultaNomClienteBEResponse nombreCompletoClientes(ConsultaNomClienteBERequest consultaNomClienteBERequest ){
		ConsultaNomClienteBEResponse consultaNomClienteBEResponse = new ConsultaNomClienteBEResponse();
		ClienteBean clienteBean =new ClienteBean();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		clienteServicio.getClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		clienteBean.setClienteID(consultaNomClienteBERequest.getClienteID());
		clienteBean.setInstitucionNominaID(consultaNomClienteBERequest.getInstitNominaID());
		clienteBean.setNegocioAfiliadoID(consultaNomClienteBERequest.getNegocioAfiliadoID());
		clienteBean.setNumCon(consultaNomClienteBERequest.getNumCon());
		
		clienteBean=clienteServicio.consultaWS(ClienteServicio.Enum_Con_ClienteWS.conNomClien, clienteBean);
		if(clienteBean==null){
			consultaNomClienteBEResponse.setNombreCompleto(Constantes.STRING_VACIO);
		}
		else{
			consultaNomClienteBEResponse.setNombreCompleto(clienteBean.getNombreCompleto());
		}		
		return consultaNomClienteBEResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaNomClienteBERequest consultaNomClienteBERequest = (ConsultaNomClienteBERequest)arg0;
		return nombreCompletoClientes(consultaNomClienteBERequest);
	}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}
	
}
