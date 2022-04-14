package cuentas.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.beanWS.request.ListaCtaClienteRequest;
import cuentas.beanWS.response.ListaCtaClienteResponse;
import cuentas.servicio.CuentasAhoServicio;



public class ListaCtaClienteBEWS  extends AbstractMarshallingPayloadEndpoint {
	CuentasAhoServicio cuentasAhoServicio= null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ListaCtaClienteBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ListaCtaClienteResponse listaCtaCliente(ListaCtaClienteRequest listaCtaClienteRequest){
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ListaCtaClienteResponse  listaCtaClienteResponse = (ListaCtaClienteResponse)
				cuentasAhoServicio.listaCtaCliente( listaCtaClienteRequest);
		return listaCtaClienteResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		ListaCtaClienteRequest listaCtaClienteRequest = (ListaCtaClienteRequest)arg0; 			
		return listaCtaCliente(listaCtaClienteRequest);
	}
	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}
	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}
	

}
