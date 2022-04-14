package operacionesCRCB.beanWS.response;

import java.util.ArrayList;

import operacionesCRCB.bean.ConsultaAmortizacionesBean;


public class ConsultaAmortizacionesResponse extends BaseResponseBean {
	
	private ArrayList<ConsultaAmortizacionesBean> amortiCredito = new ArrayList<ConsultaAmortizacionesBean>();

	public ArrayList<ConsultaAmortizacionesBean> getAmortiCredito() {
		return amortiCredito;
	}

	public void setAmortiCredito(ArrayList<ConsultaAmortizacionesBean> amortiCredito) {
		this.amortiCredito = amortiCredito;
	}

	
}
