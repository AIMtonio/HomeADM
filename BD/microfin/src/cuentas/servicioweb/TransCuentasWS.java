package cuentas.servicioweb;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.beanWS.request.TransCuentasRequest;
import cuentas.beanWS.response.TransCuentasResponse;
import cuentas.servicio.CuentasAhoServicio;
import cuentas.servicio.CuentasAhoServicio.Enum_Tra_CuentasAho;

public class TransCuentasWS extends AbstractMarshallingPayloadEndpoint {
	CuentasAhoServicio cuentasAhoServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public TransCuentasWS(Marshaller marshaller) {
		super(marshaller);
	}
	
	private TransCuentasResponse transferCuentas(TransCuentasRequest transCuentasRequest){
		TransCuentasResponse transCuentasResponse= new TransCuentasResponse();
	    CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
		MensajeTransaccionBean mensaje= new MensajeTransaccionBean();
		
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		cuentasAhoBean.setCuentaOrigen(transCuentasRequest.getCuentaOrigen());
		cuentasAhoBean.setCuentaDestino(transCuentasRequest.getCuentaDestino());
		cuentasAhoBean.setMonto(transCuentasRequest.getMonto());
		cuentasAhoBean.setReferencia(transCuentasRequest.getReferencia());
		try{
			if((Utileria.convierteEntero(cuentasAhoBean.getCuentaOrigen())!=0)&& (Utileria.convierteEntero(cuentasAhoBean.getCuentaDestino())!=0)&&
			  (Utileria.convierteDoble(cuentasAhoBean.getMonto())!=0)){
				
				mensaje=cuentasAhoServicio.grabaTransaccion(Enum_Tra_CuentasAho.transferencia, 0 ,cuentasAhoBean);
		
				transCuentasResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
				transCuentasResponse.setMensajeRespuesta(mensaje.getDescripcion());
				
				}else{
					transCuentasResponse.setCodigoRespuesta("5");
					transCuentasResponse.setMensajeRespuesta("La cuenta de origen,cuenta destino y monto son necesarios");
					
				}
			}catch(NumberFormatException e){
			transCuentasResponse.setCodigoRespuesta("4");
			transCuentasResponse.setMensajeRespuesta("Ingrese sólo números");	
		}
		return transCuentasResponse;
	
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		TransCuentasRequest transCuentas = (TransCuentasRequest)arg0; 									
		return transferCuentas(transCuentas);
		
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}	
	
}
