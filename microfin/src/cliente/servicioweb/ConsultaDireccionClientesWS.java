package cliente.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ConsultaDireccionClientesRequest;
import cliente.BeanWS.Response.ConsultaDireccionClientesResponse;
import cliente.bean.DireccionesClienteBean;
import cliente.servicio.DireccionesClienteServicio;
import cliente.servicio.DireccionesClienteServicio.Enum_Con_DireccionesCliente;


public class ConsultaDireccionClientesWS extends AbstractMarshallingPayloadEndpoint {
	DireccionesClienteServicio direccionesclienteServicio = null;

	public ConsultaDireccionClientesWS(Marshaller marshaller) {
		super(marshaller);// TODO Auto-generated constructor stub
	}
	private ConsultaDireccionClientesResponse consultaDireccionClientes(ConsultaDireccionClientesRequest consultaDireccionClientesRequest){
		DireccionesClienteBean direccionesclienteBean = new DireccionesClienteBean();
		ConsultaDireccionClientesResponse consultaDireccionClientesResponse = new ConsultaDireccionClientesResponse();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		direccionesclienteServicio.getDireccionesClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		direccionesclienteBean.setClienteID(consultaDireccionClientesRequest.getClienteID());
		direccionesclienteBean.setDireccionID(consultaDireccionClientesRequest.getDireccionID());
		
		direccionesclienteBean = direccionesclienteServicio.consulta(Enum_Con_DireccionesCliente.principal, direccionesclienteBean);
		
		if(direccionesclienteBean==null){
			consultaDireccionClientesResponse.setClienteID(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setDireccionID(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setTipoDireccionID(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setEstadoID(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setMunicipioID(Constantes.STRING_VACIO);
			
			
			consultaDireccionClientesResponse.setLocalidadID(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setColoniaID(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setCalle(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setNumeroCasa(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setNumInterior(Constantes.STRING_VACIO);

			consultaDireccionClientesResponse.setPiso(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setPrimEntreCalle(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setSegEntreCalle(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setCP(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setLatitud(Constantes.STRING_VACIO);
			

			consultaDireccionClientesResponse.setLongitud(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setLote(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setManzana(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setOficial(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setFiscal(Constantes.STRING_VACIO);
			consultaDireccionClientesResponse.setDescripcion(Constantes.STRING_VACIO);	
		}
		else{
		consultaDireccionClientesResponse.setClienteID(direccionesclienteBean.getClienteID());
		consultaDireccionClientesResponse.setDireccionID(direccionesclienteBean.getDireccionID());
		consultaDireccionClientesResponse.setTipoDireccionID(direccionesclienteBean.getTipoDireccionID());
		consultaDireccionClientesResponse.setEstadoID(direccionesclienteBean.getEstadoID());
		consultaDireccionClientesResponse.setMunicipioID(direccionesclienteBean.getMunicipioID());
		
		
		consultaDireccionClientesResponse.setLocalidadID(direccionesclienteBean.getLocalidadID());
		consultaDireccionClientesResponse.setColoniaID(direccionesclienteBean.getColoniaID());
		consultaDireccionClientesResponse.setCalle(direccionesclienteBean.getCalle());
		consultaDireccionClientesResponse.setNumeroCasa(direccionesclienteBean.getNumeroCasa());
		consultaDireccionClientesResponse.setNumInterior(direccionesclienteBean.getNumeroCasa());

		consultaDireccionClientesResponse.setPiso(direccionesclienteBean.getPiso());
		consultaDireccionClientesResponse.setPrimEntreCalle(direccionesclienteBean.getPrimEntreCalle());
		consultaDireccionClientesResponse.setSegEntreCalle(direccionesclienteBean.getSegEntreCalle());
		consultaDireccionClientesResponse.setCP(direccionesclienteBean.getCP());
		consultaDireccionClientesResponse.setLatitud(direccionesclienteBean.getLatitud());
		
		consultaDireccionClientesResponse.setLongitud(direccionesclienteBean.getLongitud());
		consultaDireccionClientesResponse.setLote(direccionesclienteBean.getLote());
		consultaDireccionClientesResponse.setManzana(direccionesclienteBean.getManzana());
		consultaDireccionClientesResponse.setOficial(direccionesclienteBean.getOficial());
		consultaDireccionClientesResponse.setFiscal(direccionesclienteBean.getFiscal());
		consultaDireccionClientesResponse.setDescripcion(direccionesclienteBean.getDescripcion());
		}		
		return consultaDireccionClientesResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaDireccionClientesRequest consultaDireccionClientesRequest = (ConsultaDireccionClientesRequest)arg0;
		return consultaDireccionClientes (consultaDireccionClientesRequest);
	}

	public DireccionesClienteServicio getDireccionesclienteServicio() {
		return direccionesclienteServicio;
	}

	public void setDireccionesclienteServicio(
			DireccionesClienteServicio direccionesclienteServicio) {
		this.direccionesclienteServicio = direccionesclienteServicio;
	}
	
}
