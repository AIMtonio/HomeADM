package cuentas.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.beanWS.request.ConsultaDisponibleCtaRequest;
import cuentas.beanWS.response.ConsultaDisponibleCtaResponse;
import cuentas.servicio.CuentasAhoServicio;
import cuentas.servicio.CuentasAhoServicio.Enum_Con_CuentasAho;

public class ConsultaDisponibleCtaWS extends AbstractMarshallingPayloadEndpoint {
	CuentasAhoServicio cuentasAhoServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	public ConsultaDisponibleCtaWS(Marshaller marshaller) {
		super(marshaller);
		
	}

	private ConsultaDisponibleCtaResponse consultaDisponibleCta(ConsultaDisponibleCtaRequest consultaDisponibleCtaRequest){
		ConsultaDisponibleCtaResponse consultaDisponibleCtaResponse= new ConsultaDisponibleCtaResponse();
		CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();		
		cuentasAhoBean.setCuentaAhoID(consultaDisponibleCtaRequest.getCuentaAhoID());
	
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		try{
			if(Long.parseLong(cuentasAhoBean.getCuentaAhoID())!=0){
				cuentasAhoBean = cuentasAhoServicio.consultaCuentasAho(Enum_Con_CuentasAho.saldoDispWS,cuentasAhoBean);
				
				consultaDisponibleCtaResponse.setCuentaAhoID(cuentasAhoBean.getCuentaAhoID());
				consultaDisponibleCtaResponse.setSaldoDispon(cuentasAhoBean.getSaldoDispon());
			    consultaDisponibleCtaResponse.setDescripcion(cuentasAhoBean.getDescripcionTipoCta());
				consultaDisponibleCtaResponse.setCodigoRespuesta(cuentasAhoBean.getCodigoRespuesta());
				consultaDisponibleCtaResponse.setMensajeRespuesta(cuentasAhoBean.getMensajeRespuesta());
			}
			
		}catch(NumberFormatException e){
			consultaDisponibleCtaResponse.setCuentaAhoID(String.valueOf(Constantes.ENTERO_CERO));
			consultaDisponibleCtaResponse.setSaldoDispon(String.valueOf(Constantes.ENTERO_CERO));
			consultaDisponibleCtaResponse.setDescripcion(Constantes.STRING_VACIO);
			consultaDisponibleCtaResponse.setCodigoRespuesta("02");
			consultaDisponibleCtaResponse.setMensajeRespuesta("Ingrese sólo números");		
		}
		
		return consultaDisponibleCtaResponse;
}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaDisponibleCtaRequest consultaDisponibleCta = (ConsultaDisponibleCtaRequest)arg0; 			
						
		return consultaDisponibleCta(consultaDisponibleCta);
		
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}
}