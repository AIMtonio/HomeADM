package credito.servicioweb;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;
import credito.beanWS.request.SimuladorCuotaCreditoRequest;
import credito.beanWS.response.SimuladorCuotaCreditoResponse;
import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;

public class SimuladorCuotaCreditoWS  extends AbstractMarshallingPayloadEndpoint {
	SolicitudCreditoServicio solicitudCreditoServicio = null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	String constanteNO = "N";
	String constanteSI = "S";
	String constanteFin = "F";
	String constanteDed = "D";
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public SimuladorCuotaCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SimuladorCuotaCreditoResponse simuladorCuotaCredito(SimuladorCuotaCreditoRequest simuladorCuotaCreditoRequest){
		SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();	
		SimuladorCuotaCreditoResponse simuladorCuotaCreditoResponse = new SimuladorCuotaCreditoResponse();
		
		solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		solicitudCredito.setMontoSolici(simuladorCuotaCreditoRequest.getMontoSolici());
		solicitudCredito.setPeriodicidadCap(simuladorCuotaCreditoRequest.getFrecuencia());
		solicitudCredito.setPlazoID(simuladorCuotaCreditoRequest.getPlazo());
		solicitudCredito.setTasaActiva(simuladorCuotaCreditoRequest.getTasaAnualizada());
		solicitudCredito.setFechaInicio(simuladorCuotaCreditoRequest.getFechaInicio());		
		
		if(simuladorCuotaCreditoRequest.getAjustarFecVen().equals(constanteSI) || simuladorCuotaCreditoRequest.getAjustarFecVen().equals(constanteNO)){
			if(simuladorCuotaCreditoRequest.getFormaCobroComAp().equals(constanteFin) || simuladorCuotaCreditoRequest.getFormaCobroComAp().equals(constanteDed)){
				
				solicitudCredito.setAjFecUlAmoVen(simuladorCuotaCreditoRequest.getAjustarFecVen());		
				solicitudCredito.setForCobroComAper(simuladorCuotaCreditoRequest.getFormaCobroComAp());						
				int varComisionApertura = 0;		
				
				
				UsuarioBean usuarioBean = new UsuarioBean();
				UsuarioBean usuario = new UsuarioBean();
				usuarioBean.setUsuarioID(usuarioWS);
				try{
					usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
					solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma("invkubo.ws.SimuladorCuotaCreditoWS");
					solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
					solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
					solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
					solicitudCreditoServicio.getSolicitudCreditoDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
				}catch (Exception e){
					e.printStackTrace();
					simuladorCuotaCreditoResponse.setMontoCuota(Constantes.STRING_CERO);
					simuladorCuotaCreditoResponse.setNumeroCuotas(Constantes.STRING_CERO);
					simuladorCuotaCreditoResponse.setTotalPagar(Constantes.STRING_CERO);
					simuladorCuotaCreditoResponse.setCat(Constantes.STRING_CERO);
					simuladorCuotaCreditoResponse.setCodigoRespuesta("99");
					simuladorCuotaCreditoResponse.setMensajeRespuesta("Por favor verifique los datos del Usuario del ws");
				}
				
				if(simuladorCuotaCreditoRequest.getFrecuencia().equals("S") || simuladorCuotaCreditoRequest.getFrecuencia().equals("C") || simuladorCuotaCreditoRequest.getFrecuencia().equals("Q")
						|| simuladorCuotaCreditoRequest.getFrecuencia().equals("M") || simuladorCuotaCreditoRequest.getFrecuencia().equals("P") || simuladorCuotaCreditoRequest.getFrecuencia().equals("B")
						|| simuladorCuotaCreditoRequest.getFrecuencia().equals("T") || simuladorCuotaCreditoRequest.getFrecuencia().equals("R") || simuladorCuotaCreditoRequest.getFrecuencia().equals("E")
						|| simuladorCuotaCreditoRequest.getFrecuencia().equals("A") ){
					 solicitudCredito.setFechaInicio(OperacionesFechas.conversionStrDate(solicitudCredito.getFechaInicio()).toString());
					 
					 if(Utileria.esNumero(simuladorCuotaCreditoRequest.getComisionApertura()) ){
						 solicitudCredito.setMontoComApert(simuladorCuotaCreditoRequest.getComisionApertura());		
						 solicitudCredito.setFechaInicio(OperacionesFechas.conversionStrDate(solicitudCredito.getFechaInicio()).toString());
						 simuladorCuotaCreditoResponse = solicitudCreditoServicio.simuladorCuotaCredito(solicitudCredito);
					 }else{
						 simuladorCuotaCreditoResponse.setMontoCuota(Constantes.STRING_CERO);
						 simuladorCuotaCreditoResponse.setNumeroCuotas(Constantes.STRING_CERO);
						 simuladorCuotaCreditoResponse.setTotalPagar(Constantes.STRING_CERO);
						 simuladorCuotaCreditoResponse.setCat(Constantes.STRING_CERO);
						 simuladorCuotaCreditoResponse.setCodigoRespuesta("10");
						 simuladorCuotaCreditoResponse.setMensajeRespuesta("El Valor Especificado para la Comisión no es Valido.");
					 }
				}else{
					simuladorCuotaCreditoResponse.setMontoCuota(Constantes.STRING_CERO);
					simuladorCuotaCreditoResponse.setNumeroCuotas(Constantes.STRING_CERO);
					simuladorCuotaCreditoResponse.setTotalPagar(Constantes.STRING_CERO);
					simuladorCuotaCreditoResponse.setCat(Constantes.STRING_CERO);
					simuladorCuotaCreditoResponse.setCodigoRespuesta("09");
					simuladorCuotaCreditoResponse.setMensajeRespuesta("El Valor Especificado para la Frecuencia no es Valido.");
				}
				
		
			}
			else{
				simuladorCuotaCreditoResponse.setMontoCuota(Constantes.STRING_CERO);
				simuladorCuotaCreditoResponse.setNumeroCuotas(Constantes.STRING_CERO);
				simuladorCuotaCreditoResponse.setTotalPagar(Constantes.STRING_CERO);
				simuladorCuotaCreditoResponse.setCat(Constantes.STRING_CERO);
				simuladorCuotaCreditoResponse.setCodigoRespuesta("08");
				simuladorCuotaCreditoResponse.setMensajeRespuesta("El Valor Especificado Forma de Cobro de Comisión de Apertura no es Valido.");
			}
		
			
		}
		else{
			simuladorCuotaCreditoResponse.setMontoCuota(Constantes.STRING_CERO);
			simuladorCuotaCreditoResponse.setNumeroCuotas(Constantes.STRING_CERO);
			simuladorCuotaCreditoResponse.setTotalPagar(Constantes.STRING_CERO);
			simuladorCuotaCreditoResponse.setCat(Constantes.STRING_CERO);
			simuladorCuotaCreditoResponse.setCodigoRespuesta("07");
			simuladorCuotaCreditoResponse.setMensajeRespuesta("El Valor Especificado para Ajustar Fecha de Vencimiento no es Valido.");
		}

		return simuladorCuotaCreditoResponse;
	}

	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		SimuladorCuotaCreditoRequest simuladorCuotaCreditoRequest = (SimuladorCuotaCreditoRequest)arg0; 							
		return simuladorCuotaCredito(simuladorCuotaCreditoRequest);
		
	}
}
