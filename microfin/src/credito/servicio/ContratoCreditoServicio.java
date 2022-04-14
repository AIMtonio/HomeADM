package credito.servicio;

import general.bean.BaseBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.GeneralesContratoBean;
import credito.bean.IntegraGruposDetalleBean;
import credito.dao.ContratoCreditoDAO;

public class ContratoCreditoServicio extends BaseServicio {

	private ContratoCreditoServicio(){
		super();
	}

	ContratoCreditoDAO contratoCreditoDAO = null;

	public static interface Enum_Rep_Contrato {
		int grupal = 1;
		int individual = 2;
	}

	public List consulta(int contrato, int cicloGrupo, int listaIntegrantes, GeneralesContratoBean generalesContratoBean){
		GeneralesContratoBean generalesContrato = null;
		List integrantesGrupo = null;
		List amortizaciones = null;
		List<Object> DatosContrato = new ArrayList<Object>();

		switch (contrato) {
			case Enum_Rep_Contrato.grupal:
				generalesContrato = contratoCreditoDAO.generalesGrupo(generalesContratoBean);
				integrantesGrupo = contratoCreditoDAO.detalleIntegrantes(cicloGrupo, listaIntegrantes, generalesContratoBean);
				amortizaciones = contratoCreditoDAO.cuotasContrato(Enum_Rep_Contrato.grupal, generalesContratoBean);


				DatosContrato.add(generalesContrato);
				DatosContrato.add(integrantesGrupo);
				DatosContrato.add(amortizaciones);

				return DatosContrato;
		}
		return null;
	}

	public ContratoCreditoDAO getContratoCreditoDAO() {
		return contratoCreditoDAO;
	}

	public void setContratoCreditoDAO(ContratoCreditoDAO contratoCreditoDAO) {
		this.contratoCreditoDAO = contratoCreditoDAO;
	}


}
