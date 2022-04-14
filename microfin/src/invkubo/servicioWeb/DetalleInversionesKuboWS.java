package invkubo.servicioWeb;

import herramientas.Utileria;
import invkubo.beanws.request.ConsultaDetalleInverRequest;
import invkubo.beanws.request.ConsultaInversionesRequest;
import invkubo.beanws.response.ConsultaDetalleInverResponse;
import invkubo.beanws.response.ConsultaInversionesResponse;
import invkubo.servicio.FondeoKuboServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;

public class DetalleInversionesKuboWS extends AbstractMarshallingPayloadEndpoint {
	FondeoKuboServicio fondeoKuboServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public DetalleInversionesKuboWS(Marshaller marshaller) {
		super(marshaller);

		// TODO Auto-generated constructor stub
	}
	
	private ConsultaDetalleInverResponse consultaDetalleInversionKubo(ConsultaDetalleInverRequest detalleInverRequest){
		fondeoKuboServicio.getFondeoKuboDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		Object objDetInvRequest=(Object)detalleInverRequest;
		Object obj = null;
		obj = fondeoKuboServicio.consultaDetalleInverKuboWS(FondeoKuboServicio.Enum_Con_Fondeo.detalleInversiones,objDetInvRequest);

		ConsultaDetalleInverResponse detalleInverRespon =(ConsultaDetalleInverResponse)obj;
		ConsultaDetalleInverResponse detalleInverResponse = new ConsultaDetalleInverResponse();

		if (Integer.parseInt(detalleInverRespon.getCodigoRespuesta())== 0) {
			detalleInverResponse.setNumeroTotInversiones(detalleInverRespon.getNumeroTotInversiones());
			detalleInverResponse.setNumeroInverEnProceso(detalleInverRespon.getNumeroInverEnProceso());
			detalleInverResponse.setSaldoInverEnProceso(detalleInverRespon.getSaldoInverEnProceso());
			detalleInverResponse.setNumeroInvActivasResum(detalleInverRespon.getNumeroInvActivasResum());
			detalleInverResponse.setSaldoInvActivasResum(detalleInverRespon.getSaldoInvActivasResum());
			detalleInverResponse.setNumeroTotInversiones(detalleInverRespon.getNumeroTotInversiones());
			detalleInverResponse.setNumeroInvAtrasadas1a15(detalleInverRespon.getNumeroInvAtrasadas1a15());
			detalleInverResponse.setSaldoInvAtrasadas1a15(detalleInverRespon.getSaldoInvAtrasadas1a15());
			detalleInverResponse.setNumeroInvAtrasadas16a30(detalleInverRespon.getNumeroInvAtrasadas16a30());
			detalleInverResponse.setSaldoInvAtrasadas16a30(detalleInverRespon.getSaldoInvAtrasadas16a30());
			detalleInverResponse.setNumeroInvAtrasadas31a90(detalleInverRespon.getNumeroInvAtrasadas31a90());
			detalleInverResponse.setSaldoInvAtrasadas31a90(detalleInverRespon.getSaldoInvAtrasadas31a90());
			detalleInverResponse.setNumeroInvVencidas91a120(detalleInverRespon.getNumeroInvVencidas91a120());
			detalleInverResponse.setSaldoInvVencidas91a120(detalleInverRespon.getSaldoInvVencidas91a120());
			detalleInverResponse.setNumeroInvVencidas121a180(detalleInverRespon.getNumeroInvVencidas121a180());
			detalleInverResponse.setSaldoInvVencidas121a180(detalleInverRespon.getSaldoInvVencidas121a180());
			detalleInverResponse.setNumeroInvQuebrantadas(detalleInverRespon.getNumeroInvQuebrantadas());
			detalleInverResponse.setSaldoInvQuebrantadas(detalleInverRespon.getSaldoInvQuebrantadas());
			detalleInverResponse.setNumeroInvLiquidadas(detalleInverRespon.getNumeroInvLiquidadas());
			detalleInverResponse.setSaldoInvLiquidadas(detalleInverRespon.getSaldoInvLiquidadas());
			detalleInverResponse.setInfoCalifPorc(detalleInverRespon.getInfoCalifPorc());
			detalleInverResponse.setInfoPlazosPorc(detalleInverRespon.getInfoPlazosPorc());
			detalleInverResponse.setInfoTasasPonCalif(detalleInverRespon.getInfoTasasPonCalif());
			detalleInverResponse.setTasaPonderada(detalleInverRespon.getTasaPonderada());
			detalleInverResponse.setNumeroIntDev(detalleInverRespon.getNumeroIntDev());
			detalleInverResponse.setSaldoIntDev(detalleInverRespon.getSaldoIntDev());
			detalleInverResponse.setNumPagosRecibidos(detalleInverRespon.getNumPagosRecibidos());
			detalleInverResponse.setSalPagosRecibidos(detalleInverRespon.getSalPagosRecibidos());
			detalleInverResponse.setNumPagosCapital(detalleInverRespon.getNumPagosCapital());
			detalleInverResponse.setSalPagosCapital(detalleInverRespon.getSalPagosCapital());
			detalleInverResponse.setNumPagosInterOrdi(detalleInverRespon.getNumPagosInterOrdi());
			detalleInverResponse.setSalPagosInterOrdi(detalleInverRespon.getSalPagosInterOrdi());
			detalleInverResponse.setNumPagosInteMora(detalleInverRespon.getNumPagosInteMora());
			detalleInverResponse.setSalPagosInteMora(detalleInverRespon.getSalPagosInteMora());
			detalleInverResponse.setImpuestos(detalleInverRespon.getImpuestos());
			detalleInverResponse.setComisPagadas(detalleInverRespon.getComisPagadas());
			detalleInverResponse.setNumComisRecibidas(detalleInverRespon.getNumComisRecibidas());
			detalleInverResponse.setSalComisRecibidas(detalleInverRespon.getSalComisRecibidas());
			detalleInverResponse.setNumEfecDisp(detalleInverRespon.getNumEfecDisp());
			detalleInverResponse.setSalEfecDisp(detalleInverRespon.getSalEfecDisp());
			detalleInverResponse.setNumeroInvActivas(detalleInverRespon.getNumeroInvActivas());
			detalleInverResponse.setSaldoInvActivas(detalleInverRespon.getSaldoInvActivas());
			detalleInverResponse.setNumeroIntDev(detalleInverRespon.getNumeroIntDev());
			detalleInverResponse.setSaldoIntDev(detalleInverRespon.getSaldoIntDev());
			detalleInverResponse.setDepositos(detalleInverRespon.getDepositos());
			detalleInverResponse.setInverRealiz(detalleInverRespon.getInverRealiz());
			detalleInverResponse.setPagCapRecib(detalleInverRespon.getPagCapRecib());
			detalleInverResponse.setIntOrdRec(detalleInverRespon.getIntOrdRec());
			detalleInverResponse.setIntMoraRec(detalleInverRespon.getIntMoraRec());
			detalleInverResponse.setRecupMorosos(detalleInverRespon.getRecupMorosos());
			detalleInverResponse.setISRretenido(detalleInverRespon.getISRretenido());
			detalleInverResponse.setComisCobrad(detalleInverRespon.getComisCobrad());
			detalleInverResponse.setComisPagad(detalleInverRespon.getComisPagad());
			detalleInverResponse.setAjustes(detalleInverRespon.getAjustes());
			detalleInverResponse.setQuebrantos(detalleInverRespon.getQuebrantos());
			detalleInverResponse.setQuebranXapli(detalleInverRespon.getQuebranXapli());
			detalleInverResponse.setPremiosRecom(detalleInverRespon.getPremiosRecom());
			
			detalleInverResponse.setCodigoRespuesta(detalleInverRespon.getCodigoRespuesta());
			detalleInverResponse.setMensajeRespuesta(detalleInverRespon.getMensajeRespuesta());
			}else
				if (Integer.parseInt(detalleInverRespon.getCodigoRespuesta())!= 0){
				

					detalleInverResponse.setCodigoRespuesta(detalleInverRespon.getCodigoRespuesta());
					detalleInverResponse.setMensajeRespuesta(detalleInverRespon.getMensajeRespuesta());
			
		}
		return detalleInverResponse;	
	}
	
	
	

	public void setFondeoKuboServicio(FondeoKuboServicio fondeoKuboServicio) {
		this.fondeoKuboServicio = fondeoKuboServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {

		ConsultaDetalleInverRequest detalleInverRequest = (ConsultaDetalleInverRequest)arg0; 			
						
		return consultaDetalleInversionKubo(detalleInverRequest);
		
	}
	

	
}

