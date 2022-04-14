package cuentas.servicioweb;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cuentas.beanWS.request.ListaCuentaAhoRequest;
import cuentas.beanWS.response.ListaCuentaAhoResponse;
import cuentas.servicio.CuentasAhoServicio;

public class ListaCuentaAhoWS extends AbstractMarshallingPayloadEndpoint{
	CuentasAhoServicio cuentasAhoServicio  = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ListaCuentaAhoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ListaCuentaAhoResponse listaCuentaAhorro(ListaCuentaAhoRequest listaCuentaAhoRequest){
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		ListaCuentaAhoResponse  listaCuentaAhoResponse = (ListaCuentaAhoResponse)
				cuentasAhoServicio.listaCuentasAhoWS(listaCuentaAhoRequest);
		return listaCuentaAhoResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		ListaCuentaAhoRequest listaCuentaAhoRequest = (ListaCuentaAhoRequest)arg0; 							
		return listaCuentaAhorro(listaCuentaAhoRequest);
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

}
