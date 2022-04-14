package originacion.servicio;
import general.servicio.BaseServicio;
import java.util.List;
import originacion.bean.CreditosPlazosBean;
import originacion.bean.FrecuenciaBean;
import originacion.dao.CreditosPlazosDAO;

public class CreditosPlazosServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CreditosPlazosDAO creditosPlazosDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Calendario{
		int principal = 1;
		int foranea = 2;
		int fecha = 3;
		int fechVenCuotas = 4; // fecha de vencimiento de credito en base a cuotas
	
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Calendario {
		int combo = 3;
		int plazoMes = 4;
		int plazo_producto = 5;
		int listaCredAuto	= 6;
		int listaCredAho	= 7;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Calendario {
		int alta = 1;
		int modificacion = 2;
		int elimina = 3;
	}

	public CreditosPlazosServicio() {
		super();
	}	
	/**
	 * Consulta de plazos
	 * @param tipoConsulta
	 * @param creditosPlazosBean
	 * @return
	 */
	public CreditosPlazosBean consulta(int tipoConsulta, CreditosPlazosBean creditosPlazosBean){
		CreditosPlazosBean creditosPlazos = null;
		switch (tipoConsulta) {
			case Enum_Con_Calendario.principal:	
				creditosPlazos = creditosPlazosDAO.consultaPrincipal(creditosPlazosBean, tipoConsulta);				
			break;	
			case Enum_Con_Calendario.foranea:		
				
			break;
			case Enum_Con_Calendario.fecha:		
				creditosPlazos = creditosPlazosDAO.consultaFechaPlazo(creditosPlazosBean, tipoConsulta);			
			break;
			case Enum_Con_Calendario.fechVenCuotas:		
				creditosPlazos = creditosPlazosDAO.consultaFechaVencimientoCuotas(creditosPlazosBean, tipoConsulta);			
			break;
		}				
		return creditosPlazos;
	}
	/**
	 * Método para listar los plazos en los combos 
	 * @param tipoLista
	 * @param creditosPlazosBean
	 * @return
	 */
	public Object[] listaCombo(int tipoLista, CreditosPlazosBean creditosPlazosBean){
		List<CreditosPlazosBean> listaPlazos = null;
		switch (tipoLista) {
			case Enum_Lis_Calendario.combo:		
				listaPlazos=  creditosPlazosDAO.listaCombo(creditosPlazosBean,tipoLista);				
				break;	
			case Enum_Lis_Calendario.plazoMes:		
				listaPlazos=  creditosPlazosDAO.listaPlazoMes(creditosPlazosBean,tipoLista);				
				break;				
			case Enum_Lis_Calendario.listaCredAuto:
				listaPlazos=  creditosPlazosDAO.listaCombo(creditosPlazosBean,tipoLista);	
				break;
			case Enum_Lis_Calendario.listaCredAho:
				listaPlazos=  creditosPlazosDAO.listaCombo(creditosPlazosBean,tipoLista);	
				break;
				
				
				
		}		
		return listaPlazos.toArray();
	}
	/**
	 * Lista los plazos de los créditos
	 * @param tipoLista
	 * @param creditosPlazosBean
	 * @return
	 */
	public Object[] listaComboProducto(int tipoLista, CreditosPlazosBean creditosPlazosBean){
		List<CreditosPlazosBean> listaPlazos = null;
		switch (tipoLista) {
			case Enum_Lis_Calendario.plazo_producto:
				listaPlazos=  creditosPlazosDAO.listaPlazosProducto(creditosPlazosBean,tipoLista);
				break;
		}		
		return listaPlazos.toArray();
	}

	//------------------ Geters y Seters ------------------------------------------------------	
	public CreditosPlazosDAO getCreditosPlazosDAO() {
		return creditosPlazosDAO;
	}
	public void setCreditosPlazosDAO(CreditosPlazosDAO creditosPlazosDAO) {
		this.creditosPlazosDAO = creditosPlazosDAO;
	}
}


