package cliente.servicioweb;

import org.apache.log4j.Logger;
import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ListaEmpleadoNomRequest;
import cliente.BeanWS.Response.ListaEmpleadoNomResponse;
import cliente.servicio.ClienteServicio;
import cliente.servicio.EmpleadoNominaServicio;

public class ListaEmpleadoNomWS extends AbstractMarshallingPayloadEndpoint  {
	
	EmpleadoNominaServicio empleadoNominaServicio =null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");	

	public ListaEmpleadoNomWS(Marshaller marshaller) {
		
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}

	private ListaEmpleadoNomResponse listaEmpleado(ListaEmpleadoNomRequest listaEmpleadoRequest){
		empleadoNominaServicio.getEmpleadoNominaDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ListaEmpleadoNomResponse  listaEmpleadoResponse = 
				(ListaEmpleadoNomResponse) empleadoNominaServicio.listaClienteWS
				(EmpleadoNominaServicio.Enum_Lis_Empleado.listaEmpleadoWS, listaEmpleadoRequest);
		
	return listaEmpleadoResponse;
	}
	
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ListaEmpleadoNomRequest listaEmpleadoRequest = (ListaEmpleadoNomRequest)arg0; 			
	return listaEmpleado(listaEmpleadoRequest);
	}

	public EmpleadoNominaServicio getEmpleadoNominaServicio() {
		return empleadoNominaServicio;
	}

	public void setEmpleadoNominaServicio(
			EmpleadoNominaServicio empleadoNominaServicio) {
		this.empleadoNominaServicio = empleadoNominaServicio;
	}
	
	
	
}
