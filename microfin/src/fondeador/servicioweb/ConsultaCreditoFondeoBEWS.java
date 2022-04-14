package fondeador.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import fondeador.bean.CreditoFondeoBean;
import fondeador.beanWS.request.ConsultaCreditoFondeoBERequest;
import fondeador.beanWS.response.ConsultaCreditoFondeoBEResponse;
import fondeador.servicio.CreditoFondeoServicio;

public class ConsultaCreditoFondeoBEWS extends AbstractMarshallingPayloadEndpoint {
	CreditoFondeoServicio creditoFondeoServicio=null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaCreditoFondeoBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}

	private ConsultaCreditoFondeoBEResponse consultaCreditosFondeoBE(ConsultaCreditoFondeoBERequest consultaCreditoFondeoBERequest){
		ConsultaCreditoFondeoBEResponse consultaCreditoFondeoBEResponse = new ConsultaCreditoFondeoBEResponse();		
		CreditoFondeoBean creditoFondeoBean = new CreditoFondeoBean();		
		creditoFondeoBean.setCreditoFondeoID(consultaCreditoFondeoBERequest.getCreditoID());
		
		creditoFondeoServicio.getCreditoFondeoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		creditoFondeoBean = creditoFondeoServicio.consulta(CreditoFondeoServicio.Enum_Con_CreditoFondeo.bancaLinea, creditoFondeoBean);
		
		consultaCreditoFondeoBEResponse.setCreditoFondeoID(creditoFondeoBean.getCreditoFondeoID());
		consultaCreditoFondeoBEResponse.setTasa(creditoFondeoBean.getTasaFija());
		consultaCreditoFondeoBEResponse.setMoneda(creditoFondeoBean.getMonedaID());
		consultaCreditoFondeoBEResponse.setFecInicio(creditoFondeoBean.getFechaInicio());
		consultaCreditoFondeoBEResponse.setFecVencimiento(creditoFondeoBean.getFechaVencimien());
		consultaCreditoFondeoBEResponse.setSaldoCapVigente(creditoFondeoBean.getSaldoCapVigente());
		consultaCreditoFondeoBEResponse.setSaldoCapAtrasad(creditoFondeoBean.getSaldoCapAtrasad());
		consultaCreditoFondeoBEResponse.setSaldoInteresPro(creditoFondeoBean.getSaldoInteres());
		consultaCreditoFondeoBEResponse.setSaldoInteresAtra(creditoFondeoBean.getSaldoInteresAtra());
		consultaCreditoFondeoBEResponse.setSaldoIVAInteres(creditoFondeoBean.getSaldoIVAInteres());
		consultaCreditoFondeoBEResponse.setSaldoMoratorios(creditoFondeoBean.getSaldoMoratorio());
		consultaCreditoFondeoBEResponse.setSaldoIVAMora(creditoFondeoBean.getSaldoIVAMora());
		consultaCreditoFondeoBEResponse.setSaldoComFaltaPa(creditoFondeoBean.getSaldoComFaltPag());
		consultaCreditoFondeoBEResponse.setSaldoOtrasComis(creditoFondeoBean.getSaldoOtrasComis());
		consultaCreditoFondeoBEResponse.setSaldoIVAComisi(creditoFondeoBean.getSaldoIVAComisi());
		consultaCreditoFondeoBEResponse.setSaldoRetencion(creditoFondeoBean.getSaldoRetencion());
		consultaCreditoFondeoBEResponse.setSaldoIVAComFalP(creditoFondeoBean.getSaldoIVAComFal());
	
		
		return consultaCreditoFondeoBEResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaCreditoFondeoBERequest consultaCreditoFondeoBERequest = (ConsultaCreditoFondeoBERequest)arg0; 							
		return consultaCreditosFondeoBE(consultaCreditoFondeoBERequest);
		
	}

	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}

	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}
	
	
	
}
