package cliente.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ConsultaEstatusEmpRequest;
import cliente.BeanWS.Response.ConsultaEstatusEmpResponse;
import cliente.bean.EmpleadoNominaBean;
import cliente.servicio.EmpleadoNominaServicio;
import cliente.servicio.EmpleadoNominaServicio.Enum_Con_Empleado;

public class ConsultaEstatusEmpWS extends AbstractMarshallingPayloadEndpoint {
	EmpleadoNominaServicio empleadoNominaServicio=null;

	public ConsultaEstatusEmpWS(Marshaller marshaller) {
		super(marshaller);// TODO Auto-generated constructor stub
	}

	private ConsultaEstatusEmpResponse consultaEstatusEmpleado( ConsultaEstatusEmpRequest consultaEstatusEmpRequest){
		ConsultaEstatusEmpResponse consultaEstatusEmpResponse= new ConsultaEstatusEmpResponse();
		EmpleadoNominaBean empleadoNominaBean = new EmpleadoNominaBean();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		empleadoNominaServicio.getEmpleadoNominaDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		empleadoNominaBean.setInstitNominaID(consultaEstatusEmpRequest.getInstitNominaID());
		empleadoNominaBean.setClienteID(consultaEstatusEmpRequest.getClienteID());
		
		try{
		if((Integer.parseInt(empleadoNominaBean.getInstitNominaID())!=0)&&
				(Integer.parseInt(empleadoNominaBean.getClienteID())!=0)){
			
		empleadoNominaBean= empleadoNominaServicio.consulta(Enum_Con_Empleado.estatus, empleadoNominaBean);
		
		consultaEstatusEmpResponse.setNombreEmpleado(empleadoNominaBean.getNombreCompleto());
		consultaEstatusEmpResponse.setEstatusActual(empleadoNominaBean.getEstatusEmp());
		consultaEstatusEmpResponse.setFechaInicialInca(empleadoNominaBean.getFechaInicialInca());
		consultaEstatusEmpResponse.setFechaFinInca(empleadoNominaBean.getFechaFinInca());
		consultaEstatusEmpResponse.setFechaBaja(empleadoNominaBean.getFechaBaja());
		consultaEstatusEmpResponse.setMotivoBaja(empleadoNominaBean.getMotivoBaja());
		consultaEstatusEmpResponse.setCodigoRespuesta(empleadoNominaBean.getCodigoRespuesta());
		consultaEstatusEmpResponse.setMensajeRespuesta(empleadoNominaBean.getMensajeRespuesta());
				}
		}catch(NumberFormatException e){
			consultaEstatusEmpResponse.setNombreEmpleado(Constantes.STRING_VACIO);
			consultaEstatusEmpResponse.setEstatusActual(Constantes.STRING_VACIO);
			consultaEstatusEmpResponse.setFechaInicialInca(Constantes.STRING_VACIO);
			consultaEstatusEmpResponse.setFechaFinInca(Constantes.STRING_VACIO);
			consultaEstatusEmpResponse.setFechaBaja(Constantes.STRING_VACIO);
			consultaEstatusEmpResponse.setMotivoBaja(Constantes.STRING_VACIO);
			consultaEstatusEmpResponse.setCodigoRespuesta("02");
			consultaEstatusEmpResponse.setMensajeRespuesta("Ingrese Sólo Números");
			
		}	
	return consultaEstatusEmpResponse;
	}
	
	
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaEstatusEmpRequest consultaEstatusEmpRequest = (ConsultaEstatusEmpRequest)arg0; 			
		return consultaEstatusEmpleado(consultaEstatusEmpRequest);		
	}

	public EmpleadoNominaServicio getEmpleadoNominaServicio() {
		return empleadoNominaServicio;
	}

	public void setEmpleadoNominaServicio(
			EmpleadoNominaServicio empleadoNominaServicio) {
		this.empleadoNominaServicio = empleadoNominaServicio;
	}

}
