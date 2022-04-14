package originacion.servicioweb;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import credito.beanWS.request.RegistroProspectoRequest;
import originacion.bean.SolicitudCreditoBean;
import originacion.beanWS.request.RegistroSolCreditoBERequest;
import originacion.beanWS.response.RegistroSolCreditoBEResponse;
import originacion.servicio.SolicitudCreditoServicio;
import originacion.servicio.SolicitudCreditoServicio.Enum_Con_SolCredito;
import originacion.servicio.SolicitudCreditoServicio.Enum_Tra_SolCredito;
import soporte.PropiedadesSAFIBean;


public class RegistroSolicitudCreditoBEWS extends AbstractMarshallingPayloadEndpoint {
	SolicitudCreditoServicio solicitudCreditoServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public RegistroSolicitudCreditoBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
		
	private RegistroSolCreditoBEResponse registroSolicitudCredito(RegistroSolCreditoBERequest  registroSolCredRequest){
		solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		SolicitudCreditoBean solicitudBean= new SolicitudCreditoBean();
		RegistroSolCreditoBEResponse registroSolCreditoResponse = new RegistroSolCreditoBEResponse();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		solicitudBean.setSolicitudCreditoID(registroSolCredRequest.getSolicitudCreditoID());
		solicitudBean.setProspectoID(registroSolCredRequest.getProspectoID());
		solicitudBean.setClienteID(registroSolCredRequest.getClienteID());
		solicitudBean.setProductoCreditoID(registroSolCredRequest.getProduCredID());
		solicitudBean.setFechaRegistro(registroSolCredRequest.getFechaReg());
		solicitudBean.setPromotorID(registroSolCredRequest.getPromotor());
		solicitudBean.setDestinoCreID(registroSolCredRequest.getDestinoCre());
		solicitudBean.setProyecto(registroSolCredRequest.getProyecto()) ;
		solicitudBean.setSucursalID(registroSolCredRequest.getSucursalID());
		solicitudBean.setMontoSolici(registroSolCredRequest.getMontoSolic()) ;
		solicitudBean.setPlazoID(registroSolCredRequest.getPlazoID());
		
		solicitudBean.setFactorMora(registroSolCredRequest.getFactorMora());
		solicitudBean.setMontoComApert(registroSolCredRequest.getComApertura());
		solicitudBean.setIvaComApert(registroSolCredRequest.getIVAComAper());
		solicitudBean.setTasaFija(registroSolCredRequest.getTasaFija());
		solicitudBean.setFrecuenciaCap(registroSolCredRequest.getFrecuencia());
		solicitudBean.setPeriodicidadCap(registroSolCredRequest.getPeriodicidad());
		solicitudBean.setNumAmortizacion(registroSolCredRequest.getNumAmorti());
		solicitudBean.setNumTransacSim(registroSolCredRequest.getNumAmorti());
		solicitudBean.setCAT(registroSolCredRequest.getCAT());
		solicitudBean.setCuentaCLABE(registroSolCredRequest.getCuentaClabe());
		
		solicitudBean.setMontoCuota(registroSolCredRequest.getMontoCuota());
		solicitudBean.setFechaVencimiento(registroSolCredRequest.getFechaVencim());
		solicitudBean.setFechaInicio(registroSolCredRequest.getFechaInicio());
		solicitudBean.setClasifiDestinCred(registroSolCredRequest.getClasiDestinCred());
		solicitudBean.setInstitucionNominaID(registroSolCredRequest.getInstitucionNominaID());
		solicitudBean.setNegocioAfiliadoID(registroSolCredRequest.getNegocioAfiliadoID());
		solicitudBean.setNumCreditos(registroSolCredRequest.getNumCreditos());
		
		if(Utileria.convierteEntero(registroSolCredRequest.getSolicitudCreditoID())== 0){
		
		mensaje= solicitudCreditoServicio.grabaTransaccion(Enum_Tra_SolCredito.altaBE, 0, solicitudBean, "");
		
		registroSolCreditoResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
		registroSolCreditoResponse.setMensajeRespuesta(mensaje.getDescripcion());
		
		registroSolCreditoResponse.setSolicitudCreditoID(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setClienteID(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setCliNombreCompleto(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setProspectoID(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setProNombreCompleto(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setProduCredID(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setDescripcionProducto(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setFechaReg(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setEstatus(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setProyecto(Constantes.STRING_VACIO);

		registroSolCreditoResponse.setMontoSolic(Constantes.STRING_VACIO); 
		registroSolCreditoResponse.setPlazoID(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setFormaComApertura(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setComApertura(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setNumAmorti(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setCAT(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setCuentaClabe(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setFechaVencim(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setFechaInicio(Constantes.STRING_VACIO);
		registroSolCreditoResponse.setFrecuencia(Constantes.STRING_VACIO);
		
		}else{
			
			solicitudBean= solicitudCreditoServicio.consulta(Enum_Con_SolCredito.solicitudBE, solicitudBean);
			
			registroSolCreditoResponse.setSolicitudCreditoID(solicitudBean.getSolicitudCreditoID());
			registroSolCreditoResponse.setClienteID(solicitudBean.getClienteID());
			registroSolCreditoResponse.setCliNombreCompleto(solicitudBean.getNombreCompletoCliente());
			registroSolCreditoResponse.setProspectoID(solicitudBean.getProspectoID());
			registroSolCreditoResponse.setProNombreCompleto(solicitudBean.getNombreCompletoProspecto());
			registroSolCreditoResponse.setProduCredID(solicitudBean.getProductoCreditoID());
			registroSolCreditoResponse.setDescripcionProducto(solicitudBean.getDescripcionProducto());
			registroSolCreditoResponse.setFechaReg(solicitudBean.getFechaRegistro());
			registroSolCreditoResponse.setEstatus(solicitudBean.getEstatus());
			registroSolCreditoResponse.setProyecto(solicitudBean.getProyecto());

			registroSolCreditoResponse.setMontoSolic(solicitudBean.getMontoSolici()); 
			registroSolCreditoResponse.setPlazoID(solicitudBean.getPlazoID());
			registroSolCreditoResponse.setFormaComApertura(solicitudBean.getFormaComApertura());
			registroSolCreditoResponse.setComApertura(solicitudBean.getMontoComApert());
			registroSolCreditoResponse.setNumAmorti(solicitudBean.getNumAmortizacion());
			registroSolCreditoResponse.setCAT(solicitudBean.getCAT());
			registroSolCreditoResponse.setCuentaClabe(solicitudBean.getCuentaCLABE());
			registroSolCreditoResponse.setFechaVencim(solicitudBean.getFechaVencimiento());
			registroSolCreditoResponse.setFechaInicio(solicitudBean.getFechaInicio());
			registroSolCreditoResponse.setFrecuencia(solicitudBean.getFrecuenciaCap());
			registroSolCreditoResponse.setCodigoRespuesta(Constantes.STRING_VACIO);
			registroSolCreditoResponse.setMensajeRespuesta(Constantes.STRING_VACIO);
			
			}
		
		return registroSolCreditoResponse;
	}


	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		RegistroSolCreditoBERequest registroSolicitudCredRequest = (RegistroSolCreditoBERequest)arg0; 							
		return registroSolicitudCredito(registroSolicitudCredRequest);
		
	}


	public SolicitudCreditoServicio getSolicitudCreditoServicio() {
		return solicitudCreditoServicio;
	}


	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}
	

}
