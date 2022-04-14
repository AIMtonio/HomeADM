package nomina.servicioweb;

import general.bean.MensajeTransaccionBean;
import nomina.bean.BitacoraPagoNominaBean;
import nomina.beanWS.request.RegistroCargaPagoNominaRequest;
import nomina.beanWS.response.RegistroCargaPagoNominaResponse;
import nomina.servicio.BitacoraPagoNominaServicio;
import nomina.servicio.BitacoraPagoNominaServicio.Enum_Tra_BitacoraPagos;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;
 
import soporte.PropiedadesSAFIBean;

public class RegistroCargaPagoNominaWS extends AbstractMarshallingPayloadEndpoint{
	BitacoraPagoNominaServicio bitacoraPagoNominaServicio= null; 
	
	public RegistroCargaPagoNominaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}

	private RegistroCargaPagoNominaResponse registroCargaPagoNomina(RegistroCargaPagoNominaRequest registroCargaRequest){
		BitacoraPagoNominaBean bitacoraBean = new BitacoraPagoNominaBean();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		bitacoraPagoNominaServicio.getBitacoraPagoNominaDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		
		RegistroCargaPagoNominaResponse registroCargaResponse = new RegistroCargaPagoNominaResponse();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		bitacoraBean.setFolioCargaIDBE(registroCargaRequest.getFolioCargaIDBE());
		bitacoraBean.setInstitNominaID(registroCargaRequest.getEmpresaNominaID());
		bitacoraBean.setClaveUsuario(registroCargaRequest.getClaveUsuarioBE());
		bitacoraBean.setNumTotalPagos(registroCargaRequest.getNumTotalPagos());
		bitacoraBean.setNumPagosExito(registroCargaRequest.getNumPagosExito());
		bitacoraBean.setNumPagosError(registroCargaRequest.getNumPagosError());
		bitacoraBean.setMontoPagos(registroCargaRequest.getMontoPagos());
		
		mensaje = bitacoraPagoNominaServicio.grabaTransaccion(Enum_Tra_BitacoraPagos.altaArchivosBE, bitacoraBean);

		registroCargaResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
		registroCargaResponse.setMensajeRespuesta(mensaje.getDescripcion());
		registroCargaResponse.setFolioCargaID(mensaje.getConsecutivoString());
		
		
		return registroCargaResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		RegistroCargaPagoNominaRequest registroPagosNominaRequest = (RegistroCargaPagoNominaRequest)arg0;
		return registroCargaPagoNomina(registroPagosNominaRequest);
	}
// -------------------- Getters y Setters --------------------------------
	public BitacoraPagoNominaServicio getBitacoraPagoNominaServicio() {
		return bitacoraPagoNominaServicio;
	}

	public void setBitacoraPagoNominaServicio(
			BitacoraPagoNominaServicio bitacoraPagoNominaServicio) {
		this.bitacoraPagoNominaServicio = bitacoraPagoNominaServicio;
	}
	
}
