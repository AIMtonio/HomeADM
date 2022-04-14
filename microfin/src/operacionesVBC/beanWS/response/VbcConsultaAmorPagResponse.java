package operacionesVBC.beanWS.response;

import java.util.ArrayList;

import operacionesVBC.bean.VbcConsultaAmortiPagosBean;
import general.bean.BaseBeanWS;

public class VbcConsultaAmorPagResponse extends BaseBeanWS{

	private ArrayList<VbcConsultaAmortiPagosBean> amortiPagos = new ArrayList<VbcConsultaAmortiPagosBean>();  
	
	private String CodigoRespuesta;
	private String MensajeRespuesta;
	public void addAmortiPagos(VbcConsultaAmortiPagosBean amortiPagos){  
        this.amortiPagos.add(amortiPagos);  
	}
	public ArrayList<VbcConsultaAmortiPagosBean> getAmortiPagos() {
		return amortiPagos;
	}
	public void setAmortiPagos(ArrayList<VbcConsultaAmortiPagosBean> amortiPagos) {
		this.amortiPagos = amortiPagos;
	}
	public String getCodigoRespuesta() {
		return CodigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		CodigoRespuesta = codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return MensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		MensajeRespuesta = mensajeRespuesta;
	}

}