package cliente.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import cliente.BeanWS.Request.ConsultaNegAfiliaRequest;
import cliente.BeanWS.Response.ConsultaNegAfiliaResponse;
import cliente.bean.NegocioAfiliadoBean;
import cliente.servicio.NegocioAfiliadoServicio;



public class ConsultaNegAfiliaWS extends AbstractMarshallingPayloadEndpoint {

	NegocioAfiliadoServicio negocioAfiliadoServicio= null;
	public ConsultaNegAfiliaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
private ConsultaNegAfiliaResponse consultaNegAfilia(ConsultaNegAfiliaRequest consultaNegAfiliaRequest ){
	ConsultaNegAfiliaResponse consultaNegAfiliaResponse = new ConsultaNegAfiliaResponse();
	
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	negocioAfiliadoServicio.getNegocioAfiliadoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		NegocioAfiliadoBean negocioAfiliadoBean =new NegocioAfiliadoBean();
		negocioAfiliadoBean.setNegocioAfiliadoID(consultaNegAfiliaRequest.getNegocioAfiliadoID());
	
		negocioAfiliadoBean=negocioAfiliadoServicio.consulta(NegocioAfiliadoServicio.Enum_Con_NegocioAfiliado.principal, negocioAfiliadoBean);
		
		if(negocioAfiliadoBean==null){
			consultaNegAfiliaResponse.setRazonSocial(Constantes.STRING_VACIO);
		}
		else
		{
		consultaNegAfiliaResponse.setRazonSocial(negocioAfiliadoBean.getRazonSocial());
		}
		return consultaNegAfiliaResponse;
	}

protected Object invokeInternal(Object arg0) throws Exception {
	ConsultaNegAfiliaRequest consultaNegAfiliaRequest = (ConsultaNegAfiliaRequest)arg0;
	return consultaNegAfilia(consultaNegAfiliaRequest);
}

public NegocioAfiliadoServicio getNegocioAfiliadoServicio() {
	return negocioAfiliadoServicio;
}

public void setNegocioAfiliadoServicio(
		NegocioAfiliadoServicio negocioAfiliadoServicio) {
	this.negocioAfiliadoServicio = negocioAfiliadoServicio;
}


}
