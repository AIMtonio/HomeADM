package cuentas.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.bean.CuentasAhoBean;

import cuentas.beanWS.request.ConsultaCuentaRequest;
import cuentas.beanWS.response.ConsultaCuentaResponse;
import cuentas.servicio.CuentasAhoServicio;
import cuentas.servicio.CuentasAhoServicio.Enum_Con_CuentasAho;

public class ConsultaCuentaWS extends AbstractMarshallingPayloadEndpoint {
	CuentasAhoServicio cuentasAhoServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaCuentaWS(Marshaller marshaller) {
		super(marshaller);
		
	} 
	
	private ConsultaCuentaResponse consultaCuenta(ConsultaCuentaRequest consultaCuentaRequest){
		ConsultaCuentaResponse consultaCuentaResponse= new ConsultaCuentaResponse();
		CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
		cuentasAhoBean.setCuentaAhoID(consultaCuentaRequest.getCuentaAhoID());
		
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
			try{
				if(Long.parseLong(cuentasAhoBean.getCuentaAhoID())!=0){
					cuentasAhoBean = cuentasAhoServicio.consultaCuentasAho(Enum_Con_CuentasAho.cuentaAhoWS, cuentasAhoBean);
					if(cuentasAhoBean!=null){
						consultaCuentaResponse.setClienteID(cuentasAhoBean.getClienteID());
						consultaCuentaResponse.setNombreCompleto(cuentasAhoBean.getNombreCompleto());
						consultaCuentaResponse.setTipoCta(cuentasAhoBean.getTipoCuentaID());
						consultaCuentaResponse.setDescripcion(cuentasAhoBean.getDescripcionTipoCta());
						
					}
					else{
					consultaCuentaResponse.setClienteID(Constantes.STRING_VACIO);
					consultaCuentaResponse.setNombreCompleto(Constantes.STRING_VACIO);
					consultaCuentaResponse.setTipoCta(Constantes.STRING_VACIO);
					consultaCuentaResponse.setDescripcion(Constantes.STRING_VACIO);
					}
				}
		}catch(NumberFormatException e){
			consultaCuentaResponse.setNombreCompleto(Constantes.STRING_VACIO);
			consultaCuentaResponse.setDescripcion(Constantes.STRING_VACIO);
			
		}
		
		
		
	return consultaCuentaResponse;
	}
	
	
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaCuentaRequest consulCuentas = (ConsultaCuentaRequest)arg0; 									
		return consultaCuenta(consulCuentas);
		
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}	

}
