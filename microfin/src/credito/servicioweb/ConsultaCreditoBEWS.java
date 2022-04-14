package credito.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import credito.bean.CreditosBean;
import credito.beanWS.request.ConsultaCreditoBERequest;
import credito.beanWS.response.ConsultaCreditoBEResponse;
import credito.servicio.CreditosServicio;


public class ConsultaCreditoBEWS extends AbstractMarshallingPayloadEndpoint {
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaCreditoBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	CreditosServicio creditosServicio = null;
	
	
	private ConsultaCreditoBEResponse consultaCreditosWS(ConsultaCreditoBERequest consultaCreditoBERequest){	
		ConsultaCreditoBEResponse consultaCreditoBEResponse= new ConsultaCreditoBEResponse();
		CreditosBean creditosBean = new CreditosBean();				
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		creditosBean.setCreditoID(consultaCreditoBERequest.getCreditoID());
		
		try{
			if(Utileria.convierteLong(creditosBean.getCreditoID())!=0){
		
		creditosBean=creditosServicio.consulta(CreditosServicio.Enum_Con_Creditos.conCreditoBEWS, creditosBean);
		
		if(creditosBean != null){
			
		consultaCreditoBEResponse.setCodigoRespuesta("00");
		consultaCreditoBEResponse.setMensajeRespuesta("Consulta Exitosa");
		consultaCreditoBEResponse.setCreditoID(creditosBean.getCreditoID());
		consultaCreditoBEResponse.setCuentaID(creditosBean.getCuentaID());
		consultaCreditoBEResponse.setEstatus(creditosBean.getEstatus());
		consultaCreditoBEResponse.setProductoCreditoID(creditosBean.getProducCreditoID());
		consultaCreditoBEResponse.setDescripcionCredito(creditosBean.getDescripcionCredito());
		consultaCreditoBEResponse.setTipoMoneda(creditosBean.getMonedaID());
		
		consultaCreditoBEResponse.setValorCat(creditosBean.getValorCat());
		consultaCreditoBEResponse.setTasaFija(creditosBean.getTasaFija());
		consultaCreditoBEResponse.setDiasFaltaPago(creditosBean.getDiasAtraso());
		consultaCreditoBEResponse.setTotalDeauda(creditosBean.getTotalAdeudo());
		consultaCreditoBEResponse.setMontoExigible(creditosBean.getMontoExigible());
		
		consultaCreditoBEResponse.setProxFechaPag(creditosBean.getFechaProxPago());
		consultaCreditoBEResponse.setSaldoCapVigente(creditosBean.getSaldoCapVigent());
		consultaCreditoBEResponse.setSaldoCapAtrasa(creditosBean.getSaldoCapAtrasad());
		consultaCreditoBEResponse.setSaldoIVAIntVig(creditosBean.getSaldoIVAInteres());
		consultaCreditoBEResponse.setSaldoInteresVig(creditosBean.getSaldoInteresVig());
		
		consultaCreditoBEResponse.setSaldoInteresesAtr(creditosBean.getSaldoInterAtras());
		consultaCreditoBEResponse.setSaldoMoratorios(creditosBean.getSaldoMoratorios());
		consultaCreditoBEResponse.setSaldoIVAAtrasa(creditosBean.getSaldoIVAAtrasa());
		consultaCreditoBEResponse.setSaldoComFaltaPago(creditosBean.getSaldoComFaltPago());
		consultaCreditoBEResponse.setSaldoOtrasComis(creditosBean.getSaldoOtrasComis());
		
		consultaCreditoBEResponse.setSaldoIVAMorato(creditosBean.getSaldoIVAMorato());
		consultaCreditoBEResponse.setSaldoIVAComFaltaPago(creditosBean.getSaldoIVAComFaltaP());
		consultaCreditoBEResponse.setSaldoIVAComisi(creditosBean.getSaldoIVAComisi());		
		}else{
			consultaCreditoBEResponse.setCodigoRespuesta("02");
			consultaCreditoBEResponse.setMensajeRespuesta("El Número de Crédito no Existe");
			consultaCreditoBEResponse.setCreditoID(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setCuentaID(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setEstatus(Constantes.STRING_VACIO);
			consultaCreditoBEResponse.setProductoCreditoID(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setDescripcionCredito(Constantes.STRING_VACIO);
			consultaCreditoBEResponse.setTipoMoneda(Constantes.STRING_CERO);
			
			consultaCreditoBEResponse.setValorCat(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setTasaFija(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setDiasFaltaPago(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setTotalDeauda(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setMontoExigible(Constantes.STRING_CERO);
			
			consultaCreditoBEResponse.setProxFechaPag(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setSaldoCapVigente(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setSaldoCapAtrasa(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setSaldoIVAIntVig(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setSaldoInteresVig(Constantes.STRING_CERO);
			
			consultaCreditoBEResponse.setSaldoInteresesAtr(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setSaldoMoratorios(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setSaldoIVAAtrasa(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setSaldoComFaltaPago(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setSaldoOtrasComis(Constantes.STRING_VACIO);
			
			consultaCreditoBEResponse.setSaldoIVAMorato(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setSaldoIVAComFaltaPago(Constantes.STRING_CERO);
			consultaCreditoBEResponse.setSaldoIVAComisi(Constantes.STRING_CERO);
				}
			}
			}catch(NumberFormatException e)	{
				consultaCreditoBEResponse.setCodigoRespuesta("01");
				consultaCreditoBEResponse.setMensajeRespuesta("Ingresar Sólo Números");
				consultaCreditoBEResponse.setCreditoID(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setCuentaID(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setEstatus(Constantes.STRING_VACIO);
				consultaCreditoBEResponse.setProductoCreditoID(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setDescripcionCredito(Constantes.STRING_VACIO);
				consultaCreditoBEResponse.setTipoMoneda(Constantes.STRING_CERO);
				
				consultaCreditoBEResponse.setValorCat(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setTasaFija(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setDiasFaltaPago(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setTotalDeauda(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setMontoExigible(Constantes.STRING_CERO);
				
				consultaCreditoBEResponse.setProxFechaPag(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setSaldoCapVigente(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setSaldoCapAtrasa(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setSaldoIVAIntVig(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setSaldoInteresVig(Constantes.STRING_CERO);
				
				consultaCreditoBEResponse.setSaldoInteresesAtr(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setSaldoMoratorios(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setSaldoIVAAtrasa(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setSaldoComFaltaPago(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setSaldoOtrasComis(Constantes.STRING_VACIO);
				
				consultaCreditoBEResponse.setSaldoIVAMorato(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setSaldoIVAComFaltaPago(Constantes.STRING_CERO);
				consultaCreditoBEResponse.setSaldoIVAComisi(Constantes.STRING_CERO);
			}
		return consultaCreditoBEResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaCreditoBERequest consultaCreditoBERequest = (ConsultaCreditoBERequest)arg0;
		return consultaCreditosWS(consultaCreditoBERequest);
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
	
	
}
