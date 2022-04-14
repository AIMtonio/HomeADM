package cuentas.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.beanWS.request.ConsultaSaldoAhorroHisRequest;
import cuentas.beanWS.response.ConsultaSaldoAhorroHisResponse;
import cuentas.servicio.CuentasAhoServicio;
import cuentas.servicio.CuentasAhoServicio.Enum_Con_CuentasAho;

public class ConsultaSaldoAhorroHisWS extends AbstractMarshallingPayloadEndpoint{
	CuentasAhoServicio cuentasAhoServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public ConsultaSaldoAhorroHisWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaSaldoAhorroHisResponse consultaSaldoHis(ConsultaSaldoAhorroHisRequest consultaSaldoAhorroHisRequest){
		ConsultaSaldoAhorroHisResponse consultaSaldoAhorroHisResponse = new ConsultaSaldoAhorroHisResponse();
		CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		cuentasAhoBean.setClienteID(consultaSaldoAhorroHisRequest.getClienteID());
		cuentasAhoBean.setCuentaAhoID(consultaSaldoAhorroHisRequest.getCuentaAhoID());
		cuentasAhoBean.setMes(consultaSaldoAhorroHisRequest.getMes());
		cuentasAhoBean.setAnio(consultaSaldoAhorroHisRequest.getAnio());
		
		cuentasAhoBean = cuentasAhoServicio.consultaCuentasAho(Enum_Con_CuentasAho.saldosHisWS, cuentasAhoBean);
	if(cuentasAhoBean==null){
		consultaSaldoAhorroHisResponse.setClienteID(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setCuentaAhoID(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setTipoCuenta(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setSaldo(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setMonedaID(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setDescriCorta(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setEstatus(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setSaldoDispon(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setSaldoSBC(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setSaldoBloq(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setVar_SumPenAct(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setSaldoIniMes(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setAbonosMes(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setCargoMes(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setCargosDia(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setSaldoIniDia(Constantes.STRING_VACIO);
		consultaSaldoAhorroHisResponse.setAbonosDia(Constantes.STRING_VACIO);
	}else{
		consultaSaldoAhorroHisResponse.setClienteID(cuentasAhoBean.getClienteID());
		consultaSaldoAhorroHisResponse.setCuentaAhoID(cuentasAhoBean.getCuentaAhoID());
		consultaSaldoAhorroHisResponse.setTipoCuenta(cuentasAhoBean.getDescripcionTipoCta());
		consultaSaldoAhorroHisResponse.setSaldo(cuentasAhoBean.getSaldo());
		consultaSaldoAhorroHisResponse.setMonedaID(cuentasAhoBean.getMonedaID());
		consultaSaldoAhorroHisResponse.setDescriCorta(cuentasAhoBean.getDescripcionMoneda());
		consultaSaldoAhorroHisResponse.setEstatus(cuentasAhoBean.getEstatus());
		consultaSaldoAhorroHisResponse.setSaldoDispon(cuentasAhoBean.getSaldoDispon());
		consultaSaldoAhorroHisResponse.setSaldoSBC(cuentasAhoBean.getSaldoSBC());
		consultaSaldoAhorroHisResponse.setSaldoBloq(cuentasAhoBean.getSaldoBloq());
		consultaSaldoAhorroHisResponse.setVar_SumPenAct(cuentasAhoBean.getSumCanPenAct());
		consultaSaldoAhorroHisResponse.setSaldoIniMes(cuentasAhoBean.getSaldoIniMes());
		consultaSaldoAhorroHisResponse.setAbonosMes(cuentasAhoBean.getAbonosMes());
		consultaSaldoAhorroHisResponse.setCargoMes(cuentasAhoBean.getCargosMes());
		consultaSaldoAhorroHisResponse.setCargosDia(cuentasAhoBean.getCargosDia());
		consultaSaldoAhorroHisResponse.setSaldoIniDia(cuentasAhoBean.getSaldoIniDia());
		consultaSaldoAhorroHisResponse.setAbonosDia(cuentasAhoBean.getAbonosDia());
	}
		return consultaSaldoAhorroHisResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaSaldoAhorroHisRequest consultaSaldoAhorroHisRequest = (ConsultaSaldoAhorroHisRequest)arg0; 							
		return consultaSaldoHis(consultaSaldoAhorroHisRequest);
		
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}
	
}
