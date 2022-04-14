package contratos.fira.servicio;

import java.util.ArrayList;
import java.util.List;

import contratos.fira.bean.ContratosAgroBean;
import contratos.fira.dao.ContratosAgroDAO;
import general.servicio.BaseServicio;

public class ContratosAgroServicio extends BaseServicio {
	
	private ContratosAgroServicio(){
		super();
	}
	
	ContratosAgroDAO contratosAgroDAO = null;
	
	public static interface Enum_Rep_ContratoAgro {
		int individual = 1;
	}
	
	public List consulta(int contrato, ContratosAgroBean contratosAgroBean){
		ContratosAgroBean contratoAgro = null;
		ContratosAgroBean generalesContrato = null;
		ContratosAgroBean datosAvales = null;
		ContratosAgroBean datosGarantes = null;
		ContratosAgroBean escriturasPublicas = null;
		List amortizaciones = null;
		List garantias = null;
		List integrantesGeneral = null;
		List listaGarantes = null;
		List listaAvales = null;
		List listaUsuarios = null;
		List garantiasFira = null;
		List ministraciones = null;
		List garantiasGarantes = null;
		List consejoAdmon = null;
		
		List<Object> datosContrato = new ArrayList<Object>();

		switch (contrato) {
			case Enum_Rep_ContratoAgro.individual:
				generalesContrato = contratosAgroDAO.generalesIndividual(contratosAgroBean);
				amortizaciones = contratosAgroDAO.cuotasContratoIndividual(contratosAgroBean);
				garantias = contratosAgroDAO.garantiasCreditoIndividual(contratosAgroBean);
				datosAvales = contratosAgroDAO.generalesAval(contratosAgroBean);
				datosGarantes = contratosAgroDAO.generalesGarantes(contratosAgroBean);
				integrantesGeneral = contratosAgroDAO.integrantesCreditoIndividual(contratosAgroBean);
				listaGarantes = contratosAgroDAO.listaGarantes(contratosAgroBean);
				listaAvales = contratosAgroDAO.listaAvales(contratosAgroBean);
				listaUsuarios = contratosAgroDAO.listaUsuarios(contratosAgroBean);
				contratoAgro = contratosAgroDAO.generalesContrato(contratosAgroBean);
				garantiasFira = contratosAgroDAO.listaGarantiasFIRA(contratosAgroBean);
				ministraciones = contratosAgroDAO.listaMinistraciones(contratosAgroBean);
				garantiasGarantes = contratosAgroDAO.listaGarantesGarantia(contratosAgroBean);
				consejoAdmon = contratosAgroDAO.listaConsejoAdmonCliente(contratosAgroBean);
				escriturasPublicas = contratosAgroDAO.escrituraPublicaPM(contratosAgroBean);
				
				datosContrato.add(generalesContrato);
				datosContrato.add(amortizaciones);
				datosContrato.add(garantias);
				datosContrato.add(datosAvales);
				datosContrato.add(datosGarantes);
				datosContrato.add(integrantesGeneral);
				datosContrato.add(listaGarantes);
				datosContrato.add(listaAvales);
				datosContrato.add(listaUsuarios);
				datosContrato.add(contratoAgro);
				datosContrato.add(garantiasFira);
				datosContrato.add(ministraciones);
				datosContrato.add(garantiasGarantes);
				datosContrato.add(consejoAdmon);
				datosContrato.add(escriturasPublicas);

				return datosContrato;
		}
		return null;
	}

	public ContratosAgroDAO getContratosAgroDAO() {
		return contratosAgroDAO;
	}

	public void setContratosAgroDAO(ContratosAgroDAO contratosAgroDAO) {
		this.contratosAgroDAO = contratosAgroDAO;
	}
}