package arrendamiento.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import org.apache.log4j.Logger;

import arrendamiento.bean.ArrendaAmortiBean;
import arrendamiento.bean.ArrendamientosBean;
import arrendamiento.dao.ArrendaAmortiDAO;
import arrendamiento.servicio.ArrendamientosServicio.Enum_Con_Arrenda;

public class ArrendaAmortiServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ArrendaAmortiDAO arrendaAmortiDAO = null;

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_AmortiArrenda {
		int principal = 1;
		int amortiPagoArrenda = 2;
	}
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_AmortiArrenda {
		int amortizaciones = 1;
	}
	
	/**
	 * Metodo de Consulta
	 * @param tipoConsulta
	 * @param arrendaAmortiBean
	 * @return arrendaAmortiBean
	 */
	public ArrendaAmortiBean consulta(int tipoConsulta, ArrendaAmortiBean arrendaAmortiBean){
		ArrendaAmortiBean amoArrenda = null;
		switch (tipoConsulta) {
			case Enum_Con_AmortiArrenda.principal:					
				break;	
			case Enum_Con_AmortiArrenda.amortiPagoArrenda:		
				amoArrenda = arrendaAmortiDAO.consultaArrendaAmorti(arrendaAmortiBean, tipoConsulta);
				break;
		}
		return amoArrenda;
	}
	/**
	 * Lista de amortizaciones
	 * @param tipoLista
	 * @param arrendaAmortiBean
	 * @return
	 */
	public List lista(int tipoLista, ArrendaAmortiBean arrendaAmortiBean){
		List amortizaciones = null;
		switch (tipoLista) {
			case Enum_Lis_AmortiArrenda.amortizaciones:		
				amortizaciones = arrendaAmortiDAO.listaAmortisArrendamientoID(arrendaAmortiBean, tipoLista);
				break;	
		}		
		return amortizaciones;
	}
		
	//---------- Getter y Setters ------------------------------------------------------------------------
	public ArrendaAmortiDAO getArrendaAmortiDAO() {
		return arrendaAmortiDAO;
	}

	public void setArrendaAmortiDAO(ArrendaAmortiDAO arrendaAmortiDAO) {
		this.arrendaAmortiDAO = arrendaAmortiDAO;
	}			   

	
}
