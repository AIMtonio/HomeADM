package cuentas.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.beanWS.request.ConsultaDisponiblePorClienteRequest;
import cuentas.beanWS.response.ConsultaDisponiblePorClienteResponse;
import cuentas.servicio.CuentasAhoServicio;

public class ConsultaDisponiblePorClienteWS extends AbstractMarshallingPayloadEndpoint {
	CuentasAhoServicio cuentasAhoServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaDisponiblePorClienteWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaDisponiblePorClienteResponse consultaDisponiblePorCliente(ConsultaDisponiblePorClienteRequest consultaDisponiblePorClienteRequest){
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		Object objDisCteRequest=(Object)consultaDisponiblePorClienteRequest;
		Object obj = null;
		
		obj = cuentasAhoServicio.consultaDisponibleCte(CuentasAhoServicio.Enum_Con_CuentasAho.saldoDisCte,objDisCteRequest);

		ConsultaDisponiblePorClienteResponse consultaDisponiblePorClienteResp =(ConsultaDisponiblePorClienteResponse)obj;
		ConsultaDisponiblePorClienteResponse consultaDisponiblePorClienteResponse = new ConsultaDisponiblePorClienteResponse();

		if (Integer.parseInt(consultaDisponiblePorClienteResp.getCodigoRespuesta())== 0) {
			consultaDisponiblePorClienteResponse.setSaldoDispon(consultaDisponiblePorClienteResp.getSaldoDispon());
			consultaDisponiblePorClienteResponse.setCodigoRespuesta(consultaDisponiblePorClienteResp.getCodigoRespuesta());
			consultaDisponiblePorClienteResponse.setMensajeRespuesta(consultaDisponiblePorClienteResp.getMensajeRespuesta());
			}else
				if (Integer.parseInt(consultaDisponiblePorClienteResp.getCodigoRespuesta())!= 0){
					consultaDisponiblePorClienteResponse.setSaldoDispon(String.valueOf(Constantes.ENTERO_CERO));
					consultaDisponiblePorClienteResponse.setCodigoRespuesta(consultaDisponiblePorClienteResp.getCodigoRespuesta());
					consultaDisponiblePorClienteResponse.setMensajeRespuesta(consultaDisponiblePorClienteResp.getMensajeRespuesta());
			
		}
		return consultaDisponiblePorClienteResponse;	
	}
	
	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaDisponiblePorClienteRequest consultaDisponiblePorCliente = (ConsultaDisponiblePorClienteRequest)arg0; 			
						
		return consultaDisponiblePorCliente(consultaDisponiblePorCliente);
		
	}
	
}
