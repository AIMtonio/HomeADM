package tarjetas.servicioweb;

import java.sql.Types;

import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import tarjetas.bean.OperacionesTarjetaBean;
import tarjetas.beanWS.request.OperacionesTarjetaRequest;
import tarjetas.beanWS.response.OperacionesTarjetaResponse;
import tarjetas.servicio.OperacionesTarjetaServicio;
import tarjetas.servicio.OperacionesTarjetaServicio.Enum_Tra_OpeTarjeta;


public class OperacionesTarjetaWS extends AbstractMarshallingPayloadEndpoint {
	
	OperacionesTarjetaServicio operacionesTarjetaServicio = null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	int tipoTransaccion = 0;
	long numeroTarjeta = 0;
	float monto = 0;
	float montoAdicional = 0;
	float montoSurcharge = 0;
	float montoLoyaltyfee = 0;
	float floatCero = 0;
	int continuar = 0;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public OperacionesTarjetaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private OperacionesTarjetaResponse operacionesTarjetaWS(OperacionesTarjetaRequest operacionesTarjetaRequest){
		operacionesTarjetaServicio.getOperacionesTarjetaDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		OperacionesTarjetaResponse respuesta = new OperacionesTarjetaResponse();
		OperacionesTarjetaBean operacionesTarjetaBean = new OperacionesTarjetaBean();
		try{
			if(operacionesTarjetaRequest.getNumeroTarjeta().length()== 16){
				if(operacionesTarjetaRequest.getCodigoMonedaoperacion().equals(OperacionesTarjetaBean.monedaPesosWS)){
					operacionesTarjetaBean.setMonedaID(OperacionesTarjetaBean.monedaPesosSafi);
					
					try{
						numeroTarjeta = Long.parseLong(operacionesTarjetaRequest.getNumeroTarjeta());
					
						try{
							monto = Float.parseFloat(operacionesTarjetaRequest.getMontoTransaccion());
							montoAdicional = Float.parseFloat(operacionesTarjetaRequest.getMontosAdicionales());
							montoSurcharge = Float.parseFloat(operacionesTarjetaRequest.getMontoSurcharge());
							montoLoyaltyfee = Float.parseFloat(operacionesTarjetaRequest.getMontoLoyaltyfee());
							
							continuar = 0;
						}catch(NumberFormatException e){
							continuar = 1;
							e.printStackTrace();
							respuesta.setNumeroTransaccion(Constantes.STRING_CERO);
							respuesta.setSaldoActualizado(Constantes.STRING_CERO);
							respuesta.setCodigoRespuesta("13");
							respuesta.setMensajeRespuesta("Cantidad Invalida.");
						}
						if(continuar == 0){
							if(	(	operacionesTarjetaRequest.getTipoOperacion().equalsIgnoreCase(OperacionesTarjetaBean.compraConRetiroEfec)
									&& montoAdicional >= monto	) ||
									(	operacionesTarjetaRequest.getTipoOperacion().equalsIgnoreCase(OperacionesTarjetaBean.retiroEfectivo)
									&&  montoSurcharge >= monto	) ){
								respuesta.setNumeroTransaccion(Constantes.STRING_CERO);
								respuesta.setSaldoActualizado(Constantes.STRING_CERO);
								respuesta.setCodigoRespuesta("13");
								respuesta.setMensajeRespuesta("Cantidad Invalida.");
								continuar = 1;
							}else{
								if(monto> floatCero && montoAdicional >= floatCero && montoSurcharge>= floatCero && montoLoyaltyfee >= floatCero  &&
										operacionesTarjetaRequest.getTipoOperacion() !=OperacionesTarjetaBean.consultaSaldo){
									continuar = 0;
								}else{
									
									if(operacionesTarjetaRequest.getTipoOperacion().equals(OperacionesTarjetaBean.consultaSaldo)){
										continuar = 0;
									}else{
										respuesta.setNumeroTransaccion(Constantes.STRING_CERO);
										respuesta.setSaldoActualizado(Constantes.STRING_CERO);
										respuesta.setCodigoRespuesta("13");
										respuesta.setMensajeRespuesta("Cantidad Invalida.");
										continuar = 1;
									}
								}
							}
						}
						if(continuar == 0){
							operacionesTarjetaBean.setNumeroTarjeta(operacionesTarjetaRequest.getNumeroTarjeta());
							operacionesTarjetaBean.setMontoTransaccion(operacionesTarjetaRequest.getMontoTransaccion());
							operacionesTarjetaBean.setMontosAdicionales(operacionesTarjetaRequest.getMontosAdicionales());
							operacionesTarjetaBean.setNumeroTransaccion(operacionesTarjetaRequest.getNumeroTransaccion());
							operacionesTarjetaBean.setNombreUbicacionTerminal(operacionesTarjetaRequest.getNombreUbicacionTerminal());
							
							operacionesTarjetaBean.setTipoOperacion(operacionesTarjetaRequest.getTipoOperacion());
							operacionesTarjetaBean.setOrigenInstrumento(operacionesTarjetaRequest.getOrigenInstrumento());
							operacionesTarjetaBean.setFechaHoraOperacion(operacionesTarjetaRequest.getFechaHoraOperacion());
							operacionesTarjetaBean.setGiroNegocio(operacionesTarjetaRequest.getGiroNegocio());
							operacionesTarjetaBean.setPuntoEntrada(operacionesTarjetaRequest.getPuntoEntrada());
							
							operacionesTarjetaBean.setIdTerminal(operacionesTarjetaRequest.getIdTerminal());
							operacionesTarjetaBean.setNip(operacionesTarjetaRequest.getNip());
							operacionesTarjetaBean.setCodigoMonedaoperacion(operacionesTarjetaRequest.getCodigoMonedaoperacion());
							operacionesTarjetaBean.setMontoSurcharge(operacionesTarjetaRequest.getMontoSurcharge());
							operacionesTarjetaBean.setMontoLoyaltyfee(operacionesTarjetaRequest.getMontoLoyaltyfee());
							operacionesTarjetaBean.setFechaVencimiento(operacionesTarjetaRequest.getFechaVencimiento());
							
							UsuarioBean usuarioBean = new UsuarioBean();
							UsuarioBean usuario = new UsuarioBean();
							usuarioBean.setUsuarioID(usuarioWS);
							usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
							operacionesTarjetaServicio.getOperacionesTarjetaDAO().getParametrosAuditoriaBean().setNombrePrograma("tarjetas.ws.OperacionesTarjeta");
							operacionesTarjetaServicio.getOperacionesTarjetaDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
							operacionesTarjetaServicio.getOperacionesTarjetaDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
							operacionesTarjetaServicio.getOperacionesTarjetaDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
							operacionesTarjetaServicio.getOperacionesTarjetaDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
							
							/* if para determinar que operacion se realizara */
							if(operacionesTarjetaRequest.getTipoOperacion().equals(OperacionesTarjetaBean.compraNormal)) {
								operacionesTarjetaBean.setNaturalezaMovimiento(OperacionesTarjetaBean.naturalezaCargo);
								operacionesTarjetaBean.setTipoMovAho(OperacionesTarjetaBean.tipoMovAhoCompraNormal);
								respuesta = operacionesTarjetaServicio.grabaTransaccion(OperacionesTarjetaServicio.Enum_Tra_OpeTarjeta.compraNormal,
										operacionesTarjetaBean);
								
							}else{
								if(operacionesTarjetaRequest.getTipoOperacion().equals(OperacionesTarjetaBean.retiroEfectivo)) {
									operacionesTarjetaBean.setNaturalezaMovimiento(OperacionesTarjetaBean.naturalezaCargo);
									operacionesTarjetaBean.setTipoMovAho(OperacionesTarjetaBean.tipoMovAhoRetiroEfec);
									respuesta = operacionesTarjetaServicio.grabaTransaccion(OperacionesTarjetaServicio.Enum_Tra_OpeTarjeta.retiroEfectivo,
											operacionesTarjetaBean);
									
								}else{
									if(operacionesTarjetaRequest.getTipoOperacion().equals(OperacionesTarjetaBean.pago)) {
										operacionesTarjetaBean.setNaturalezaMovimiento(OperacionesTarjetaBean.naturalezaAbono);
										operacionesTarjetaBean.setTipoMovAho(OperacionesTarjetaBean.tipoMovAhoPago);
										respuesta = operacionesTarjetaServicio.grabaTransaccion(OperacionesTarjetaServicio.Enum_Tra_OpeTarjeta.pago,
												operacionesTarjetaBean);	
									}else{
										if(operacionesTarjetaRequest.getTipoOperacion().equals(OperacionesTarjetaBean.consultaSaldo)) {
											respuesta = operacionesTarjetaServicio.grabaTransaccion(OperacionesTarjetaServicio.Enum_Tra_OpeTarjeta.consultaSaldo,
													operacionesTarjetaBean);
										}else{
											if(operacionesTarjetaRequest.getTipoOperacion().equals(OperacionesTarjetaBean.compraConRetiroEfec)) {
												operacionesTarjetaBean.setNaturalezaMovimiento(OperacionesTarjetaBean.naturalezaCargo);
												operacionesTarjetaBean.setTipoMovAho(OperacionesTarjetaBean.tipoMovAhoCompraNormal);
												respuesta = operacionesTarjetaServicio.grabaTransaccion(OperacionesTarjetaServicio.Enum_Tra_OpeTarjeta.compraRetiroE,
														operacionesTarjetaBean);
											}else{
												respuesta.setNumeroTransaccion(Constantes.STRING_CERO);
												respuesta.setSaldoActualizado(Constantes.STRING_CERO);
												respuesta.setCodigoRespuesta("12");
												respuesta.setMensajeRespuesta("Transaccion Invalida.");
											}
										}
									}
								}
							}
						}
					}catch(NumberFormatException e){
						e.printStackTrace();
						respuesta.setNumeroTransaccion(Constantes.STRING_CERO);
						respuesta.setSaldoActualizado(Constantes.STRING_CERO);
						respuesta.setCodigoRespuesta("30");
						respuesta.setMensajeRespuesta("Error de Formato.");
					} 
				}else{
					respuesta.setNumeroTransaccion(Constantes.STRING_CERO);
					respuesta.setSaldoActualizado(Constantes.STRING_CERO);
					respuesta.setCodigoRespuesta("12");
					respuesta.setMensajeRespuesta("Transaccion Invalida.");
				}
			}else{
				respuesta.setNumeroTransaccion(Constantes.STRING_CERO);
				respuesta.setSaldoActualizado(Constantes.STRING_CERO);
				respuesta.setCodigoRespuesta("14");
				respuesta.setMensajeRespuesta("Numero de tarjeta no valido.");
			}
		}catch(Exception e){
			e.printStackTrace();
			respuesta.setNumeroTransaccion(Constantes.STRING_CERO);
			respuesta.setSaldoActualizado(Constantes.STRING_CERO);
			respuesta.setCodigoRespuesta("96");
			respuesta.setMensajeRespuesta("Sistema no funcionando.");
		}
		return respuesta;
	}

	public OperacionesTarjetaServicio getOperacionesTarjetaServicio() {
		return operacionesTarjetaServicio;
	}

	public void setOperacionesTarjetaServicio(
			OperacionesTarjetaServicio operacionesTarjetaServicio) {
		this.operacionesTarjetaServicio = operacionesTarjetaServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		OperacionesTarjetaRequest operacionesTarjetaRequest = (OperacionesTarjetaRequest)arg0; 			
		return operacionesTarjetaWS(operacionesTarjetaRequest);		
	}

}