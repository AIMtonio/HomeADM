package bancaEnLinea.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.servicio.CuentasAhoMovServicio;
import cuentas.servicio.CuentasAhoMovServicio.Enum_Lis_CuentasAhoMov;
import cuentas.servicio.ReporteMovimientosServicio;
import bancaEnLinea.beanWS.request.ConsultaSaldoDetalleBERequest;
import bancaEnLinea.beanWS.response.ConsultaSaldoDetalleBEResponse;



public class ConsultaSaldoDetalleBEWS extends AbstractMarshallingPayloadEndpoint {
	ReporteMovimientosServicio reporteMovimientosServicio =null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaSaldoDetalleBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	private ConsultaSaldoDetalleBEResponse consultaSaldoDetalleBE(ConsultaSaldoDetalleBERequest cuentaSaldoDetalleBERequest){
		reporteMovimientosServicio.getReporteMovimientosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ConsultaSaldoDetalleBEResponse consultaSaldoDetalleBEResponse = (ConsultaSaldoDetalleBEResponse)
				reporteMovimientosServicio.ConsultaSaldoDetalleWS(cuentaSaldoDetalleBERequest);
		
		return consultaSaldoDetalleBEResponse;
		
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaSaldoDetalleBERequest cuentaSaldoDetalleBERequest = (ConsultaSaldoDetalleBERequest)arg0; 							
		return consultaSaldoDetalleBE(cuentaSaldoDetalleBERequest);
		
	}
	public ReporteMovimientosServicio getReporteMovimientosServicio() {
		return reporteMovimientosServicio;
	}
	public void setReporteMovimientosServicio(
			ReporteMovimientosServicio reporteMovimientosServicio) {
		this.reporteMovimientosServicio = reporteMovimientosServicio;
	}

	

}
