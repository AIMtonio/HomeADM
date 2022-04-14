package cliente.servicioweb;

import org.apache.log4j.Logger;
import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ListaReporteNomBitacoEstEmpRequest;
import cliente.BeanWS.Response.ListaReporteNomBitacoEstEmpResponse;
import cliente.servicio.EmpleadoNominaServicio;

public class ListaReporteEstatusBitEmpleadoNomWS extends AbstractMarshallingPayloadEndpoint  {
	
	EmpleadoNominaServicio empleadoNominaServicio =null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");	

	public ListaReporteEstatusBitEmpleadoNomWS(Marshaller marshaller) {
		
		super(marshaller);
		
		// TODO Auto-generated constructor stub
	}

	private ListaReporteNomBitacoEstEmpResponse listaEmpleado(ListaReporteNomBitacoEstEmpRequest listaEmpleadoRequest){
		empleadoNominaServicio.getEmpleadoNominaDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ListaReporteNomBitacoEstEmpResponse  listaEmpleadoResponse = 
				(ListaReporteNomBitacoEstEmpResponse) empleadoNominaServicio.listaRepEstaEmpWS(
				EmpleadoNominaServicio.Enum_Lis_EmpleadoRepEst.listaEmpleadoRepEstWS, listaEmpleadoRequest);
		
	return listaEmpleadoResponse;
	}
	
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ListaReporteNomBitacoEstEmpRequest listaEmpleadoRequest = (ListaReporteNomBitacoEstEmpRequest)arg0; 			
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
