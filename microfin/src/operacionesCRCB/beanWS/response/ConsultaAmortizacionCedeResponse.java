package operacionesCRCB.beanWS.response;

import java.util.ArrayList;

import operacionesCRCB.bean.ConsultaCedesBean;

public class ConsultaAmortizacionCedeResponse extends BaseResponseBean{

	private ArrayList<ConsultaCedesBean> amortiCedes = new ArrayList<ConsultaCedesBean>();
	

	public ArrayList<ConsultaCedesBean> getAmortiCedes() {
		return amortiCedes;
	}

	public void setAmortiCedes(ArrayList<ConsultaCedesBean> amortiCedes) {
		this.amortiCedes = amortiCedes;
	}


	
}
