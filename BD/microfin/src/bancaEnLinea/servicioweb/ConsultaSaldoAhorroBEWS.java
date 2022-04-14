package bancaEnLinea.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.oxm.Unmarshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;
import cuentas.servicio.CuentasAhoServicio.Enum_Con_CuentasAho;
import bancaEnLinea.beanWS.request.ConsultaSaldoAhorroBERequest;
import bancaEnLinea.beanWS.response.ConsultaSaldoAhorroBEResponse;


public class ConsultaSaldoAhorroBEWS extends AbstractMarshallingPayloadEndpoint{
	CuentasAhoServicio cuentasAhoServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public ConsultaSaldoAhorroBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaSaldoAhorroBEResponse consultaSaldosBE(ConsultaSaldoAhorroBERequest consultaSaldoAhorroBERequest){
		ConsultaSaldoAhorroBEResponse consultaSaldoAhorroBEResponse = new ConsultaSaldoAhorroBEResponse();
		CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		cuentasAhoBean.setClienteID(consultaSaldoAhorroBERequest.getClienteID());
		cuentasAhoBean.setCuentaAhoID(consultaSaldoAhorroBERequest.getCuentaAhoID());
		
		cuentasAhoBean = cuentasAhoServicio.consultaCuentasAho(Enum_Con_CuentasAho.saldosWS, cuentasAhoBean);
		if(cuentasAhoBean != null){
				consultaSaldoAhorroBEResponse.setCodigoRespuesta("00");
				consultaSaldoAhorroBEResponse.setMensajeRespuesta("Consulta Exitosa");
				consultaSaldoAhorroBEResponse.setClienteID(cuentasAhoBean.getClienteID());
				consultaSaldoAhorroBEResponse.setCuentaAhoID(cuentasAhoBean.getCuentaAhoID());
				consultaSaldoAhorroBEResponse.setTipoCuenta(cuentasAhoBean.getDescripcionTipoCta());
				consultaSaldoAhorroBEResponse.setSaldo(cuentasAhoBean.getSaldo());
				consultaSaldoAhorroBEResponse.setMonedaID(cuentasAhoBean.getMonedaID());
				consultaSaldoAhorroBEResponse.setDescriCorta(cuentasAhoBean.getDescripcionMoneda());
				consultaSaldoAhorroBEResponse.setEstatus(cuentasAhoBean.getEstatus());
				consultaSaldoAhorroBEResponse.setSaldoDispon(cuentasAhoBean.getSaldoDispon());
				consultaSaldoAhorroBEResponse.setSaldoSBC(cuentasAhoBean.getSaldoSBC());
				consultaSaldoAhorroBEResponse.setSaldoBloq(cuentasAhoBean.getSaldoBloq());
				consultaSaldoAhorroBEResponse.setVar_SumPenAct(cuentasAhoBean.getSumCanPenAct());
				consultaSaldoAhorroBEResponse.setSaldoIniMes(cuentasAhoBean.getSaldoIniMes());
				consultaSaldoAhorroBEResponse.setAbonosMes(cuentasAhoBean.getAbonosMes());
				consultaSaldoAhorroBEResponse.setCargoMes(cuentasAhoBean.getCargosMes());
				consultaSaldoAhorroBEResponse.setCargosDia(cuentasAhoBean.getCargosDia());
				consultaSaldoAhorroBEResponse.setSaldoIniDia(cuentasAhoBean.getSaldoIniDia());
				consultaSaldoAhorroBEResponse.setAbonosDia(cuentasAhoBean.getAbonosDia());
		}else{
			consultaSaldoAhorroBEResponse.setCodigoRespuesta("02");
			consultaSaldoAhorroBEResponse.setMensajeRespuesta("Se Requiere Cuenta y Cliente Validos");	
			consultaSaldoAhorroBEResponse.setClienteID(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setCuentaAhoID(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setTipoCuenta(Constantes.STRING_VACIO);
			consultaSaldoAhorroBEResponse.setSaldo(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setMonedaID(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setDescriCorta(Constantes.STRING_VACIO);
			consultaSaldoAhorroBEResponse.setEstatus(Constantes.STRING_VACIO);
			consultaSaldoAhorroBEResponse.setSaldoDispon(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setSaldoSBC(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setSaldoBloq(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setVar_SumPenAct(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setSaldoIniMes(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setAbonosMes(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setCargoMes(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setCargosDia(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setSaldoIniDia(Constantes.STRING_CERO);
			consultaSaldoAhorroBEResponse.setAbonosDia(Constantes.STRING_CERO);
			}	
		return consultaSaldoAhorroBEResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaSaldoAhorroBERequest consultaSaldoAhorroBERequest = (ConsultaSaldoAhorroBERequest)arg0; 							
		return consultaSaldosBE(consultaSaldoAhorroBERequest);
		
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}
	

}
