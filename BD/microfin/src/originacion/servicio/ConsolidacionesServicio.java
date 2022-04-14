package originacion.servicio;

import java.util.List;

import originacion.bean.ConsolidacionesBean;
import originacion.dao.ConsolidacionesDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ConsolidacionesServicio extends BaseServicio {

	ConsolidacionesDAO consolidacionesDAO = null;
	
	public static interface Enum_Tran_Consolidacion {
		int altaConsolidacion	= 1;
		int bajaConsolidacion	= 2;
		int bajaTablaTemporal	= 3;
		int bajaTablaFisica		= 4;
		int crearTabla			= 5;
		int altaSolicitud		= 6;
		int proyeccionInteres	= 7;
	}
	
	public static interface Enum_Baj_Consolidacion {
		int registro		= 1;
		int tablaTemporal	= 2;
		int tablaFisica 	= 3;
	}

	public static interface Enum_Con_Consolidacion {
		int principal 		= 1;
		int validaCliente 	= 2;
		int asignaGarantia 	= 3;
	}

	public static interface Enum_Con_CreConsolidacion {
		int principal 			= 1;
		int solicitudCreditoID	= 2;
		int creditoID			= 3;
		int montoConsolidado 	= 4;
 	}

	public static interface Enum_Lis_Consolidacion {
		int principal 		 = 1;
		int solicitudCredito = 2;
		int credito			 = 3;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConsolidacionesBean consolidacionesBean) {

		MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
		try{

			switch (tipoTransaccion) {
				case Enum_Tran_Consolidacion.altaConsolidacion:
					mensajeTransaccionBean = consolidacionesDAO.procesoAltaConsolidacionAgro(consolidacionesBean);
				break;
				case Enum_Tran_Consolidacion.bajaConsolidacion:
					mensajeTransaccionBean = bajaConcilacion(consolidacionesBean, Enum_Baj_Consolidacion.registro);
				break;
				case Enum_Tran_Consolidacion.bajaTablaTemporal:
					mensajeTransaccionBean = bajaConcilacion(consolidacionesBean, Enum_Baj_Consolidacion.tablaTemporal);
				break;
				case Enum_Tran_Consolidacion.bajaTablaFisica:
					mensajeTransaccionBean = bajaConcilacion(consolidacionesBean, Enum_Baj_Consolidacion.tablaFisica);
				break;
				case Enum_Tran_Consolidacion.crearTabla:
					mensajeTransaccionBean = consolidacionesDAO.creaListaTemporal(consolidacionesBean);
				break;
				case Enum_Tran_Consolidacion.altaSolicitud:
					mensajeTransaccionBean = consolidacionesDAO.procesoSolicitudConsolidacion(consolidacionesBean);
				break;
				case Enum_Tran_Consolidacion.proyeccionInteres:
					mensajeTransaccionBean = consolidacionesDAO.proyeccionInteres(consolidacionesBean);
				break;
				default:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(999);
					mensajeTransaccionBean.setDescripcion("Tipo de Transaccion desconocida.");
				break;
			}
		} catch(Exception exception){
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error al Grabar la Transaccion");
			}
			loggerSAFI.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();
		}
		return mensajeTransaccionBean;
	}

	public ConsolidacionesBean consulta(int tipoConsulta, ConsolidacionesBean consolidacionesBean) {

		ConsolidacionesBean consolidaciones = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_Consolidacion.principal:
					consolidaciones = consolidacionesDAO.consultaCreditoConsolidado(consolidacionesBean, tipoConsulta);
				break;
				case Enum_Con_Consolidacion.validaCliente:
					consolidaciones = consolidacionesDAO.validaClienteConsolidado(consolidacionesBean, Enum_Con_Consolidacion.principal);
				break;
				case Enum_Con_Consolidacion.asignaGarantia:
					consolidaciones = consolidacionesDAO.asignaGarantiaFira(consolidacionesBean, Enum_Con_Consolidacion.validaCliente);
				break;
				default:
					consolidaciones = null;
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Créditos Consolidados ", exception);
			exception.printStackTrace();
		}
		return consolidaciones;
	}

	public ConsolidacionesBean consultaConsolidacion(int tipoConsulta, ConsolidacionesBean consolidacionesBean) {

		ConsolidacionesBean consolidaciones = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_CreConsolidacion.principal:
					consolidaciones = consolidacionesDAO.consultaConsolidacion(consolidacionesBean, tipoConsulta);
				break;
				case Enum_Con_CreConsolidacion.solicitudCreditoID:
					consolidaciones = consolidacionesDAO.consultaConsolidacion(consolidacionesBean, tipoConsulta);
				break;
				case Enum_Con_CreConsolidacion.creditoID:
					consolidaciones = consolidacionesDAO.consultaConsolidacion(consolidacionesBean, tipoConsulta);
				break;
				case Enum_Con_CreConsolidacion.montoConsolidado:
					consolidaciones = consolidacionesDAO.montoConsolidado(consolidacionesBean, tipoConsulta);
				break;
				default:
					consolidaciones = null;
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Créditos Consolidados ", exception);
			exception.printStackTrace();
		}
		return consolidaciones;
	}

	public List<ConsolidacionesBean> lista(int tipoLista, ConsolidacionesBean consolidacionesBean) {

		List<ConsolidacionesBean> listaAlmacenes = null;
		try{
			switch(tipoLista){
				case Enum_Lis_Consolidacion.principal:
					listaAlmacenes = consolidacionesDAO.listaCreditoConsolidado(consolidacionesBean, tipoLista);
				break;
				case Enum_Lis_Consolidacion.solicitudCredito:
					listaAlmacenes = consolidacionesDAO.listaGridCreditoConsolidado(consolidacionesBean, tipoLista);
				break;
				case Enum_Lis_Consolidacion.credito:
					listaAlmacenes = consolidacionesDAO.listaGridCreditoConsolidado(consolidacionesBean, tipoLista);
				break;
				default:
					listaAlmacenes = null;
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Créditos Consolidados ", exception);
			exception.printStackTrace();
		}
		return listaAlmacenes;
	}

	public MensajeTransaccionBean bajaConcilacion(ConsolidacionesBean consolidacionesBean, int tipoOperacion){
		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean = consolidacionesDAO.bajaConsolidacion(consolidacionesBean, tipoOperacion);
		return mensajeTransaccionBean;
	}

	public ConsolidacionesDAO getConsolidacionesDAO() {
		return consolidacionesDAO;
	}

	public void setConsolidacionesDAO(ConsolidacionesDAO consolidacionesDAO) {
		this.consolidacionesDAO = consolidacionesDAO;
	}

}
