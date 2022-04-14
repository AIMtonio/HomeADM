package operacionesVBC.beanWS.response;

import java.util.ArrayList;

import operacionesVBC.bean.VbcSimuladorCreditoBean;
import general.bean.BaseBeanWS;

public class VbcSimuladorCreditoResponse extends BaseBeanWS{

	private ArrayList<VbcSimuladorCreditoBean> amortiSimulador = new ArrayList<VbcSimuladorCreditoBean>();  
	
	private String CodigoRespuesta;
	private String MensajeRespuesta;
	
	public ArrayList<VbcSimuladorCreditoBean> getAmortiSimulador() {
		return amortiSimulador;
	}
	public void setAmortiSimulador(ArrayList<VbcSimuladorCreditoBean> amortiSimulador) {
		this.amortiSimulador = amortiSimulador;
	} 
	public void addAmortiSimulador(VbcSimuladorCreditoBean amortiSimulador){  
        this.amortiSimulador.add(amortiSimulador);  
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