package credito.servicio;

import general.bean.BaseBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.GeneralesPagareBean;
import credito.dao.PagareCreditoDAO;

public class PagareCreditoIndivServicio extends BaseServicio {

	private PagareCreditoIndivServicio(){
		super();
	}

	PagareCreditoDAO pagareCreditoDAO = null;

	public static interface Enum_Rep_Contrato {
		int individual = 1;
		int contratoIndi=2;
	}

	public List consulta(int contrato,GeneralesPagareBean generalesPagareBean){
		List amortizaciones = null;
		List listaAvales = null;
		GeneralesPagareBean datosContratoMilagro=null;
		
		List<Object> DatosContrato = new ArrayList<Object>();

		switch (contrato) {
			case Enum_Rep_Contrato.individual:
				amortizaciones = pagareCreditoDAO.cuotasPagareIndividual(generalesPagareBean);
				listaAvales = pagareCreditoDAO.listaAvales(generalesPagareBean);

				DatosContrato.add(amortizaciones);
				DatosContrato.add(listaAvales);
				 break;
			case Enum_Rep_Contrato.contratoIndi:
				datosContratoMilagro=pagareCreditoDAO.generalesPagareMilagro(generalesPagareBean);
				DatosContrato.add(datosContratoMilagro);
			break;
		}
		return DatosContrato;
	}

	public PagareCreditoDAO getPagareCreditoDAO() {
		return pagareCreditoDAO;
	}

	public void setPagareCreditoDAO(PagareCreditoDAO pagareCreditoDAO) {
		this.pagareCreditoDAO = pagareCreditoDAO;
	}

	

	


}
