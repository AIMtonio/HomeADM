package invkubo.servicioWeb;

import invkubo.bean.FondeoKuboBean;
import invkubo.beanws.request.ConsultaInversionesRequest;
import invkubo.beanws.response.ConsultaInversionesResponse;
import invkubo.servicio.FondeoKuboServicio;
import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ConsultaClienteRequest;
import cliente.BeanWS.Response.ConsultaClienteResponse;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;

public class InversionesKuboWS extends AbstractMarshallingPayloadEndpoint {
	FondeoKuboServicio fondeoKuboServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public InversionesKuboWS(Marshaller marshaller) {
		super(marshaller);

		// TODO Auto-generated constructor stub
	}
	
	private ConsultaInversionesResponse consultaInversionKubo(ConsultaInversionesRequest inversionesKuboRequest){
		fondeoKuboServicio.getFondeoKuboDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		Object objInvRequest=(Object)inversionesKuboRequest;
		Object obj = null;
		obj = fondeoKuboServicio.consultaMisInversionesWS(FondeoKuboServicio.Enum_Con_Fondeo.misInversiones,objInvRequest);

		ConsultaInversionesResponse fondeoKuboRespon =(ConsultaInversionesResponse)obj;
		ConsultaInversionesResponse fondeoKuboResponse = new ConsultaInversionesResponse();
		ConsultaInversionesResponse fondeoKuboResponse2 = new ConsultaInversionesResponse();

		if (Integer.parseInt(fondeoKuboRespon.getCodigoRespuesta())== 0) {
	
			fondeoKuboResponse.setGananciaAnuTot(fondeoKuboRespon.getGananciaAnuTot());
			fondeoKuboResponse.setNumInteresCobrado(fondeoKuboRespon.getNumInteresCobrado());
			fondeoKuboResponse.setInteresCobrado(fondeoKuboRespon.getInteresCobrado());
			fondeoKuboResponse.setPagTotalRecib(fondeoKuboRespon.getPagTotalRecib());
			fondeoKuboResponse.setSaldoTotal(fondeoKuboRespon.getSaldoTotal());
			fondeoKuboResponse.setNumeroEfectivoDispon(fondeoKuboRespon.getNumeroEfectivoDispon());
			fondeoKuboResponse.setSaldoEfectivoDispon(fondeoKuboRespon.getSaldoEfectivoDispon());
			fondeoKuboResponse.setNumeroInverEnProceso(fondeoKuboRespon.getNumeroInverEnProceso());
			fondeoKuboResponse.setSaldoInverEnProceso(fondeoKuboRespon.getSaldoInverEnProceso());
			fondeoKuboResponse.setNumeroInvActivas(fondeoKuboRespon.getNumeroInvActivas());
			fondeoKuboResponse.setSaldoInvActivas(fondeoKuboRespon.getSaldoInvActivas());
			fondeoKuboResponse.setNumeroIntDevengados(fondeoKuboRespon.getNumeroIntDevengados());
			fondeoKuboResponse.setSaldoIntDevengados(fondeoKuboRespon.getSaldoIntDevengados());
			fondeoKuboResponse.setNumeroTotInversiones(fondeoKuboRespon.getNumeroTotInversiones());
			fondeoKuboResponse.setNumeroInvActivasResumen(fondeoKuboRespon.getNumeroInvActivasResumen());
			fondeoKuboResponse.setSaldoInvActivasResumen(fondeoKuboRespon.getSaldoInvActivasResumen());
			fondeoKuboResponse.setNumeroInvAtrasadas1a15Resumen(fondeoKuboRespon.getNumeroInvAtrasadas1a15Resumen());
			fondeoKuboResponse.setSaldoInvAtrasadas1a15Resumen(fondeoKuboRespon.getSaldoInvAtrasadas1a15Resumen());
			fondeoKuboResponse.setNumeroInvAtrasadas16a30Resumen(fondeoKuboRespon.getNumeroInvAtrasadas16a30Resumen());
			fondeoKuboResponse.setSaldoInvAtrasadas16a30Resumen(fondeoKuboRespon.getSaldoInvAtrasadas16a30Resumen());
			fondeoKuboResponse.setNumeroInvAtrasadas31a90Resumen(fondeoKuboRespon.getNumeroInvAtrasadas31a90Resumen());
			fondeoKuboResponse.setSaldoInvAtrasadas31a90Resumen(fondeoKuboRespon.getSaldoInvAtrasadas31a90Resumen());
			fondeoKuboResponse.setNumeroInvVencidas91a120Resumen(fondeoKuboRespon.getNumeroInvVencidas91a120Resumen());
			fondeoKuboResponse.setSaldoInvVencidas91a120Resumen(fondeoKuboRespon.getSaldoInvVencidas91a120Resumen());
			fondeoKuboResponse.setNumeroInvVencidas121a180Resumen(fondeoKuboRespon.getNumeroInvVencidas121a180Resumen());
			fondeoKuboResponse.setSaldoInvVencidas121a180Resumen(fondeoKuboRespon.getSaldoInvVencidas121a180Resumen());
			fondeoKuboResponse.setNumeroInvQuebrantadasResumen(fondeoKuboRespon.getNumeroInvQuebrantadasResumen());
			fondeoKuboResponse.setSaldoInvQuebrantadasResumen(fondeoKuboRespon.getSaldoInvQuebrantadasResumen());
			fondeoKuboResponse.setNumeroInvLiquidadasResumen(fondeoKuboRespon.getNumeroInvLiquidadasResumen());
			fondeoKuboResponse.setSaldoInvLiquidadasResumen(fondeoKuboRespon.getSaldoInvLiquidadasResumen());
			fondeoKuboResponse.setNumCapitalCobrado(fondeoKuboRespon.getNumCapitalCobrado());
			fondeoKuboResponse.setCapitalCobrado(fondeoKuboRespon.getCapitalCobrado());
			fondeoKuboResponse.setNumMoraCobrado(fondeoKuboRespon.getNumMoraCobrado());
			fondeoKuboResponse.setMoraCobrado(fondeoKuboRespon.getMoraCobrado());
			fondeoKuboResponse.setNumComFalPago(fondeoKuboRespon.getNumComFalPago());
			fondeoKuboResponse.setComFalPago(fondeoKuboRespon.getComFalPago());
			fondeoKuboResponse.setCodigoRespuesta(fondeoKuboRespon.getCodigoRespuesta());
			fondeoKuboResponse.setMensajeRespuesta(fondeoKuboRespon.getMensajeRespuesta());
			}else
				if (Integer.parseInt(fondeoKuboRespon.getCodigoRespuesta())!= 0){
					

					fondeoKuboResponse.setCodigoRespuesta(fondeoKuboRespon.getCodigoRespuesta());
					fondeoKuboResponse.setMensajeRespuesta(fondeoKuboRespon.getMensajeRespuesta());
			
		}
		return fondeoKuboResponse;	
	}
	
	
	

	public void setFondeoKuboServicio(FondeoKuboServicio fondeoKuboServicio) {
		this.fondeoKuboServicio = fondeoKuboServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
	
		ConsultaInversionesRequest inversionesRequest = (ConsultaInversionesRequest)arg0; 			
						
		return consultaInversionKubo(inversionesRequest);
		
	}
	

	
}

