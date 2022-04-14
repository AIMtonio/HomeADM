package contabilidad.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import contabilidad.bean.ConceptosEdosFinancierosBean;
import contabilidad.dao.ConceptosEdosFinancierosDAO;

public class ConceptosEdosFinancierosServicio  extends BaseServicio {

	ConceptosEdosFinancierosDAO conceptosEdosFinancierosDAO = null;
	
	private ConceptosEdosFinancierosServicio(){
		super();
	}
	
	public static interface Enum_Tra_ConceptosFin{
		int alta 		= 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Lis_ConceptosFin{
		int principal 		= 1;
		int esCalculado		= 2;
	}
	
	public static interface Enum_Con_DetallePoliza{
		int repMov 		= 1;
	}
	/**
	 * Graba la transacción (alta de conceptos para reportes de FIRA).
	 * @param tipoTransaccion : Indica si se trata de una alta o modificación.
	 * @param edosFinancieros : Clase bean con los valores de los parámetros de entrada al SP-CONCEEDOSFINFIRAALT.
	 * @param numTransaccion : Número de transacción.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConceptosEdosFinancierosBean edosFinancieros, long numTransaccion){
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
		case  Enum_Tra_ConceptosFin.alta:
			mensajeBean = conceptosEdosFinancierosDAO.alta(edosFinancieros, numTransaccion);
			break;
	        case  Enum_Tra_ConceptosFin.baja:
	        	mensajeBean = conceptosEdosFinancierosDAO.baja(edosFinancieros, numTransaccion);
	        break;
		}
		return mensajeBean;
	}
	/**
	 * Método que lista los Conceptos de los Reportes Financieros.
	 * @param tipoLista : Número de lista.
	 * @param edosFinancieros : Clase bean con los parámetros de entrada a los SPs de lista.
	 * @return Lista de clases {@linkplain ConceptosEdosFinancierosBean}.
	 * @author avelasco
	 */
	public ArrayList<ConceptosEdosFinancierosBean> lista(int tipoLista, ConceptosEdosFinancierosBean edosFinancieros){
		ArrayList<ConceptosEdosFinancierosBean> edosFinancierosLista = null;
		switch (tipoLista) {
		case  Enum_Lis_ConceptosFin.principal:
			edosFinancierosLista = conceptosEdosFinancierosDAO.lista(edosFinancieros, tipoLista);
			break;
		case  Enum_Lis_ConceptosFin.esCalculado:
			edosFinancierosLista = conceptosEdosFinancierosDAO.lista(edosFinancieros, tipoLista);
			break;	        
		}
		return edosFinancierosLista;
	}

	public ConceptosEdosFinancierosDAO getConceptosEdosFinancierosDAO() {
		return conceptosEdosFinancierosDAO;
	}

	public void setConceptosEdosFinancierosDAO(
			ConceptosEdosFinancierosDAO conceptosEdosFinancierosDAO) {
		this.conceptosEdosFinancierosDAO = conceptosEdosFinancierosDAO;
	}

}