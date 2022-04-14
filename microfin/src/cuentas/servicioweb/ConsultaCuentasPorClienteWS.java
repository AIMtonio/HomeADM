package cuentas.servicioweb;

import java.util.List;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.beanWS.request.ConsultaCuentasPorClienteRequest;
import cuentas.beanWS.response.ConsultaCuentasPorClienteResponse;
import cuentas.servicio.CuentasAhoServicio;

public class ConsultaCuentasPorClienteWS extends AbstractMarshallingPayloadEndpoint {
	CuentasAhoServicio cuentasAhoServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public ConsultaCuentasPorClienteWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaCuentasPorClienteResponse consultaCuentasPorCliente(ConsultaCuentasPorClienteRequest consultaCuentasPorClienteRequest){
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ConsultaCuentasPorClienteResponse  cuentasPorCliente = (ConsultaCuentasPorClienteResponse) cuentasAhoServicio.consultaCuentasPorClienteWS(CuentasAhoServicio.Enum_Con_CuentasAho.ctaCteWS, consultaCuentasPorClienteRequest);
		return cuentasPorCliente;
	}
		

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaCuentasPorClienteRequest consultaCuentasPorClienteRequest = (ConsultaCuentasPorClienteRequest)arg0; 			
						
		return consultaCuentasPorCliente(consultaCuentasPorClienteRequest);
		
	}

}
