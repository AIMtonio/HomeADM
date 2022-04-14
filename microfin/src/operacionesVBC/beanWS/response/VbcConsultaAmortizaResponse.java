package operacionesVBC.beanWS.response;

import java.util.ArrayList;

import operacionesVBC.bean.VbcConsultaAmortizacionesBean;
import general.bean.BaseBeanWS;

public class VbcConsultaAmortizaResponse extends BaseBeanWS{

	private ArrayList<VbcConsultaAmortizacionesBean> amortizaciones = new ArrayList<VbcConsultaAmortizacionesBean>();  
	
	private String CodigoRespuesta;
	private String MensajeRespuesta;
	
	public ArrayList<VbcConsultaAmortizacionesBean> getAmortizaciones() {
		return amortizaciones;
	}
	public void setAmortizaciones(
			ArrayList<VbcConsultaAmortizacionesBean> amortizaciones) {
		this.amortizaciones = amortizaciones;
	}
	public void addAmortizaciones(VbcConsultaAmortizacionesBean amortizaciones){  
        this.amortizaciones.add(amortizaciones);  
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