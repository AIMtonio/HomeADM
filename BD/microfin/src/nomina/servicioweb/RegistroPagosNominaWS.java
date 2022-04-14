package nomina.servicioweb;

import general.bean.MensajeTransaccionBean;
import nomina.beanWS.request.RegistroPagosNominaRequest;
import nomina.beanWS.response.RegistroPagosNominaResponse;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.servicio.ParametrosSisServicio;
import nomina.bean.PagoNominaBean;
import nomina.servicio.PagoNominaServicio;

public class RegistroPagosNominaWS extends AbstractMarshallingPayloadEndpoint{
	PagoNominaServicio pagoNominaServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;

	public RegistroPagosNominaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}

	private RegistroPagosNominaResponse registroPagosNomina(RegistroPagosNominaRequest registroPagosNominaRequest){
		PagoNominaBean pagosNominaBean = new PagoNominaBean();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		pagoNominaServicio.getPagoNominaDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		parametrosSisServicio.getParametrosSisDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		RegistroPagosNominaResponse registroPagosNominaResponse = new RegistroPagosNominaResponse();

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		pagosNominaBean.setFolioCargaID(registroPagosNominaRequest.getFolioCargaID());
		pagosNominaBean.setFolioCargaIDBE(registroPagosNominaRequest.getFolioCargaIDBE());
		pagosNominaBean.setInstitNominaID(registroPagosNominaRequest.getEmpresaNominaID());
		pagosNominaBean.setCreditoID(registroPagosNominaRequest.getCreditoID());
		pagosNominaBean.setClienteID(registroPagosNominaRequest.getClienteID());
		pagosNominaBean.setMontoPagos(registroPagosNominaRequest.getMontoPagos());

		mensaje = pagoNominaServicio.grabaTransaccion(PagoNominaServicio.Enum_Tipo_Transaccion.alta,pagosNominaBean, null);

		registroPagosNominaResponse.setFolioNominaID(mensaje.getConsecutivoString());
		registroPagosNominaResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
		registroPagosNominaResponse.setMensajeRespuesta(mensaje.getDescripcion());

		return registroPagosNominaResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		RegistroPagosNominaRequest registroPagosNominaRequest = (RegistroPagosNominaRequest)arg0;
		return registroPagosNomina(registroPagosNominaRequest);
	}

	public PagoNominaServicio getPagoNominaServicio() {
		return pagoNominaServicio;
	}

	public void setPagoNominaServicio(PagoNominaServicio pagoNominaServicio) {
		this.pagoNominaServicio = pagoNominaServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}
