package cliente.servicioweb;

import java.io.File;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.springframework.core.io.FileSystemResource;
import org.springframework.oxm.Marshaller;
import org.springframework.util.StringUtils;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.CorreoServicio;
import cliente.BeanWS.Request.ActualizaEstatusEmpRequest;
import cliente.BeanWS.Response.ActualizaEstatusEmpResponse;
import cliente.bean.EmpleadoNominaBean;
import cliente.servicio.EmpleadoNominaServicio;
import cliente.servicio.EmpleadoNominaServicio.Enum_Tran_Empleado;

public class ActualizaEstatusEmpWS extends AbstractMarshallingPayloadEndpoint {
	CorreoServicio correoServicio = null;
	EmpleadoNominaServicio empleadoNominaServicio=null;
	

	public ActualizaEstatusEmpWS(Marshaller marshaller) {
		super(marshaller);// TODO Auto-generated constructor stub
	}
	
	private ActualizaEstatusEmpResponse actualizaEstatus(ActualizaEstatusEmpRequest actualizaEstatusEmpRequest){
		ActualizaEstatusEmpResponse actualizaResponse= new ActualizaEstatusEmpResponse();
		EmpleadoNominaBean empleadoNomina = new EmpleadoNominaBean();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		empleadoNominaServicio.getEmpleadoNominaDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		empleadoNomina.setInstitNominaID(actualizaEstatusEmpRequest.getInstitNominaID());
		empleadoNomina.setClienteID(actualizaEstatusEmpRequest.getClienteID());
		empleadoNomina.setEstatusEmp(actualizaEstatusEmpRequest.getEstatus());
		empleadoNomina.setFechaInicialInca(actualizaEstatusEmpRequest.getFechaInicialInca());
		empleadoNomina.setFechaFinInca(actualizaEstatusEmpRequest.getFechaFinInca());
		empleadoNomina.setFechaBaja(actualizaEstatusEmpRequest.getFechaBaja());
		empleadoNomina.setMotivoBaja(actualizaEstatusEmpRequest.getMotivoBaja());
	
		try{
			if((Integer.parseInt(empleadoNomina.getInstitNominaID())!=0)&&
					(Integer.parseInt(empleadoNomina.getClienteID())!=0)){
				
				mensaje= empleadoNominaServicio.grabaTransaccion(Enum_Tran_Empleado.actualiza, empleadoNomina);
		
				actualizaResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
				actualizaResponse.setMensajeRespuesta(mensaje.getDescripcion());
				enviaCorreoPromotor(mensaje.getCampoGenerico());
				
				}else{
					actualizaResponse.setCodigoRespuesta("01");
					actualizaResponse.setMensajeRespuesta("El Numero de Cliente y de la Cuenta son requeridos");
					
				}
		}catch(NumberFormatException e){
			actualizaResponse.setCodigoRespuesta("02");
			actualizaResponse.setMensajeRespuesta("Ingrese Sólo Números");
		}
			
	return actualizaResponse;
	}
	
	public void enviaCorreoPromotor(String correo){
		String mensajeCorreo = "";
		mensajeCorreo=  Constantes.ACTUALIZA_EMPLEADO_NOMINA;
		FileSystemResource recurso = new FileSystemResource(new File(Constantes.RUTA_IMAGENES +
				System.getProperty("file.separator") +
				"LogoPrincipal.png"));
		
			correoServicio.enviaCorreo("",correo,null, "Cambio de estatus en Empleado de Nómina.",mensajeCorreo,null,4,recurso);

	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ActualizaEstatusEmpRequest actualizaEstatusEmpRequest = (ActualizaEstatusEmpRequest)arg0; 			
		return actualizaEstatus(actualizaEstatusEmpRequest);		
	}

	public EmpleadoNominaServicio getEmpleadoNominaServicio() {
		return empleadoNominaServicio;
	}

	public void setEmpleadoNominaServicio(
			EmpleadoNominaServicio empleadoNominaServicio) {
		this.empleadoNominaServicio = empleadoNominaServicio;
	}
	

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}
	
	
}
