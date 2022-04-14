package soporte.servicio;

import general.servicio.BaseServicio;
import soporte.bean.CalculoDiaFestivoBean;
import soporte.dao.DiaFestivoDAO;


public class DiaFestivoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	DiaFestivoDAO diaFestivoDAO = null;			   
	String siguiente = "S";
	String anterior = "A";
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_DiaFestivo {
		int principal 		= 1;
		int sumaFecha 		= 2;
		int sumaFechaHab	= 3;
		int sumaMesesDiaHabil = 4;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_DiaFestivo {
		int principal = 1;
	}

	public static interface Enum_DiaHabil {
		int diaHabilSiguiente = 1;
		int diaHabilAnterior = 2;
	}

	
	public DiaFestivoServicio() {
		super();
	}
	
	public CalculoDiaFestivoBean calculaDiaFestivo(int siguienteAnterior, CalculoDiaFestivoBean diaFestivoBean){
		CalculoDiaFestivoBean diaFestivo = null;
	
		switch(siguienteAnterior){
			case Enum_DiaHabil.diaHabilSiguiente:
				diaFestivoBean.setSigAnt(siguiente);
				diaFestivo = diaFestivoDAO.calculaDiaFestivoSiguiente(diaFestivoBean);		
				break;
			case Enum_DiaHabil.diaHabilAnterior:
				diaFestivoBean.setSigAnt(anterior);
				diaFestivo = diaFestivoDAO.calculaDiaFestivoSiguiente(diaFestivoBean);		
				break;
		}
		return diaFestivo;
	}
	/**
	 * Método de genérico de consulta.
	 * @param numConsulta : Número de consulta.
	 * @param diaFestivoBean : Clase bean con los valores de entrada para realizar la consulta.
	 * @return {@link CalculoDiaFestivoBean} con el resultado de la consulta.
	 * @author avelasco
	 */
	public CalculoDiaFestivoBean consulta(int numConsulta, CalculoDiaFestivoBean diaFestivoBean){
		CalculoDiaFestivoBean diaFestivo = null;
		switch(numConsulta){
		case Enum_Con_DiaFestivo.sumaFecha:
			diaFestivo = diaFestivoDAO.sumaDiasFecha(diaFestivoBean);
			break;
		case Enum_Con_DiaFestivo.sumaFechaHab:
			diaFestivo = diaFestivoDAO.sumaDiasFechaHabil(diaFestivoBean);
			break;
		case Enum_Con_DiaFestivo.sumaMesesDiaHabil:
			diaFestivo = diaFestivoDAO.sumaMesesFecha(diaFestivoBean);
			break;
		}
		return diaFestivo;
	}

	public DiaFestivoDAO getDiaFestivoDAO() {
		return diaFestivoDAO;
	}

	public void setDiaFestivoDAO(DiaFestivoDAO diaFestivoDAO) {
		this.diaFestivoDAO = diaFestivoDAO;
	}
	
}