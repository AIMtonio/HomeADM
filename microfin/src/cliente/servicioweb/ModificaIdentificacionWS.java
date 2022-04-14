package cliente.servicioweb;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.OperacionesFechas;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.AltaConocimientoCteRequest;
import cliente.BeanWS.Request.ModificaIdentificacionRequest;
import cliente.BeanWS.Response.AltaConocimientoCteResponse;
import cliente.BeanWS.Response.ModificaIdentificacionResponse;
import cliente.bean.IdentifiClienteBean;
import cliente.servicio.IdentifiClienteServicio;
import cliente.servicio.IdentifiClienteServicio.Enum_Tra_IdentifiCliente;

public class ModificaIdentificacionWS  extends AbstractMarshallingPayloadEndpoint {
	
	IdentifiClienteServicio identifiClienteServicio=null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");	

	public ModificaIdentificacionWS(Marshaller marshaller) {
		super(marshaller);// TODO Auto-generated constructor stub
	}

	private ModificaIdentificacionResponse modificaIdentificacionC(ModificaIdentificacionRequest modificaIdentificacionRequest){
		ModificaIdentificacionResponse modificaIdentificacionResponse= new ModificaIdentificacionResponse();
		
		IdentifiClienteBean identifiClienteBean = new IdentifiClienteBean();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		identifiClienteServicio.getIdentifiClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		identifiClienteBean.setClienteID(modificaIdentificacionRequest.getNumEmpleado());
		identifiClienteBean.setIdentificID(modificaIdentificacionRequest.getIdentificID());
		identifiClienteBean.setTipoIdentiID(modificaIdentificacionRequest.getTipoIdentID());
		identifiClienteBean.setOficial(modificaIdentificacionRequest.getOficial());
		identifiClienteBean.setNumIdentific(modificaIdentificacionRequest.getFolio());
		identifiClienteBean.setFecExIden(modificaIdentificacionRequest.getFechaExpIden());
		identifiClienteBean.setFecVenIden(modificaIdentificacionRequest.getFechaVenIden());
		
		try{
			if(Integer.parseInt(identifiClienteBean.getClienteID())!=0 && Integer.parseInt(identifiClienteBean.getIdentificID())!=0 
					&& Integer.parseInt(identifiClienteBean.getTipoIdentiID())!=0){
				if(identifiClienteBean.getOficial().equalsIgnoreCase("S") || identifiClienteBean.getOficial().equalsIgnoreCase("N")){
					if( (OperacionesFechas.validarFecha(identifiClienteBean.getFecExIden())== true) || OperacionesFechas.validarFecha(identifiClienteBean.getFecVenIden())){
										
						mensaje=identifiClienteServicio.grabaTransaccion(Enum_Tra_IdentifiCliente.modificacion,identifiClienteBean);
		
						modificaIdentificacionResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
						modificaIdentificacionResponse.setMensajeRespuesta(mensaje.getDescripcion());
						modificaIdentificacionResponse.setTipoIdentiID(mensaje.getConsecutivoInt());
					}else{
						modificaIdentificacionResponse.setCodigoRespuesta("7");
						modificaIdentificacionResponse.setMensajeRespuesta("Formato de Fecha incorrecto, ingrese yyyy-mm-dd");
						modificaIdentificacionResponse.setTipoIdentiID(Constantes.STRING_CERO);
						
					}				
				}else{
					modificaIdentificacionResponse.setCodigoRespuesta("6");
					modificaIdentificacionResponse.setMensajeRespuesta("Ingrese para Oficial= S, No oficial= N");
					modificaIdentificacionResponse.setTipoIdentiID(Constantes.STRING_CERO);
				}
			}else{
				modificaIdentificacionResponse.setCodigoRespuesta("4");
				modificaIdentificacionResponse.setMensajeRespuesta("El número de empleado, identificación y tipo de identificación son requeridos");
				modificaIdentificacionResponse.setTipoIdentiID(Constantes.STRING_CERO);
			}
		}catch(NumberFormatException e)	{
			modificaIdentificacionResponse.setCodigoRespuesta("5");
			modificaIdentificacionResponse.setMensajeRespuesta("Ingresar sólo números");
			modificaIdentificacionResponse.setTipoIdentiID(Constantes.STRING_CERO);
			
		}		
	
		return modificaIdentificacionResponse;
	}
	
	
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ModificaIdentificacionRequest modificaIdentificacionRequest = (ModificaIdentificacionRequest)arg0; 			
		return modificaIdentificacionC(modificaIdentificacionRequest);		
	}

	public IdentifiClienteServicio getIdentifiClienteServicio() {
		return identifiClienteServicio;
	}

	public void setIdentifiClienteServicio(IdentifiClienteServicio identifiClienteServicio) {
		this.identifiClienteServicio = identifiClienteServicio;
	}


	
	
}
