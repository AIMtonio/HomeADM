package operacionesVBC.beanWS.response;

import general.bean.BaseBeanWS;

import java.util.ArrayList;

import operacionesVBC.bean.VbcConsultaCatalogoBean;


public class VbcConsultaCatalogoResponse extends BaseBeanWS{

	private String codigoRespuesta;
	private String mensajeRespuesta;
	private ArrayList<VbcConsultaCatalogoBean> otrosCat = new ArrayList<VbcConsultaCatalogoBean>();

	public ArrayList<VbcConsultaCatalogoBean> getOtrosCat() {
		return otrosCat;
	}
	
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}

	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}

	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}

	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}

	public void setOtrosCat(ArrayList<VbcConsultaCatalogoBean> otrosCat) {
		this.otrosCat = otrosCat;
	}
	
	public void addOtrosCat(VbcConsultaCatalogoBean otrosCata){
		 this.otrosCat.add(otrosCata);  
	}
}
