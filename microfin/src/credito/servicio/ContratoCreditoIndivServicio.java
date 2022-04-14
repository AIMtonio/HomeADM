package credito.servicio;

import general.bean.BaseBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.GeneralesContratoBean;
import credito.dao.ContratoCreditoDAO;

public class ContratoCreditoIndivServicio extends BaseServicio {

	private ContratoCreditoIndivServicio(){
		super();
	}

	ContratoCreditoDAO contratoCreditoDAO = null;

	public static interface Enum_Rep_Contrato {
		int individual = 1;
		int contratoIndi=2;
	}

	public List consulta(int contrato,GeneralesContratoBean generalesContratoBean){
		GeneralesContratoBean generalesContrato = null;
		List amortizaciones = null;
		List garantias = null;
		GeneralesContratoBean datosAvales = null;
		GeneralesContratoBean datosGarantes = null;
		GeneralesContratoBean datosContratoMilagro=null;
		
		
		List integrantesGeneral = null;
		List listaGarantes = null;
		List listaAvales = null;
		List listaUsuarios = null;
		
		List<Object> DatosContrato = new ArrayList<Object>();

		switch (contrato) {
			case Enum_Rep_Contrato.individual:
				generalesContrato = contratoCreditoDAO.generalesIndividual(generalesContratoBean);
				amortizaciones = contratoCreditoDAO.cuotasContratoIndividual(generalesContratoBean);
				garantias = contratoCreditoDAO.garantiasCreditoIndividual(generalesContratoBean);
				datosAvales = contratoCreditoDAO.generalesAval(generalesContratoBean);
				datosGarantes = contratoCreditoDAO.generalesGarantes(generalesContratoBean);
				integrantesGeneral = contratoCreditoDAO.integrantesCreditoIndividual(generalesContratoBean);
				listaGarantes = contratoCreditoDAO.listaGarantes(generalesContratoBean);
				listaAvales = contratoCreditoDAO.listaAvales(generalesContratoBean);
				listaUsuarios = contratoCreditoDAO.listaUsuarios(generalesContratoBean);


				DatosContrato.add(generalesContrato);
				DatosContrato.add(amortizaciones);
				DatosContrato.add(garantias);
				DatosContrato.add(datosAvales);
				DatosContrato.add(datosGarantes);
				DatosContrato.add(integrantesGeneral);
				DatosContrato.add(listaGarantes);
				DatosContrato.add(listaAvales);
				DatosContrato.add(listaUsuarios);				
			    break;
			case Enum_Rep_Contrato.contratoIndi:
				datosContratoMilagro=contratoCreditoDAO.generalesContratoMilagro(generalesContratoBean);
				DatosContrato.add(datosContratoMilagro);
			break;
		}
		return DatosContrato;
	}

	public ContratoCreditoDAO getContratoCreditoDAO() {
		return contratoCreditoDAO;
	}

	public void setContratoCreditoDAO(ContratoCreditoDAO contratoCreditoDAO) {
		this.contratoCreditoDAO = contratoCreditoDAO;
	}


}
