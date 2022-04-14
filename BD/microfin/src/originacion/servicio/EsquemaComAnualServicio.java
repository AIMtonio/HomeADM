package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import originacion.bean.EsquemaComAnualBean;
import originacion.dao.EsquemaComAnualDAO;
import originacion.servicio.EsquemaGarantiaLiqServicio.Enum_Con_EsquemaGarantia;
import originacion.servicio.EsquemaGarantiaLiqServicio.Enum_Tra_EsquemaGarantia;

public class EsquemaComAnualServicio extends BaseServicio {
	
	private EsquemaComAnualDAO	esquemaComAnualDAO;
	
	/**
	 * Enumera los tipos de Transacciones
	 */
	public static interface Enum_Tra_EsquemaComAnual {
		int	alta			= 1;
		int	actualizacion	= 2;
	}
	
	/**
	 * Enumera los tipo de consulta
	 */
	public static interface Enum_Con_EsquemaComAnual {
		int	principal	= 1;
	}
	
	private EsquemaComAnualServicio() {
		super();
	}
	/**
	 * Método para grabar los diferentes tipos de transacción
	 * @param tipoTransaccion : Corresponde a los valores de la Interface Enum_Tra_EsquemaComAnual[1: alta, 2:Actualiza]
	 * @param esquemaComAnualBean : Bean con los datos a grabar Objeto de tipo EsquemaComAnualBean
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EsquemaComAnualBean esquemaComAnualBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_EsquemaGarantia.alta:
				mensaje = esquemaComAnualDAO.alta(esquemaComAnualBean);
				break;
			case Enum_Tra_EsquemaGarantia.actualizacion:
				mensaje = esquemaComAnualDAO.actualiza(esquemaComAnualBean);
				break;
			default:
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Opción no Válida");
		}
		return mensaje;
	}
	
	/**
	 * Método para realizar la consulta de los valores guardados para el Esquema de Comisión Anual de Crédito
	 * @param tipoConsulta : Corresponde a los valores de la Interface Enum_Con_EsquemaComAnual[1: Principal]
	 * @param esquemaComAnualBean : Clase Bean con los datos para la consulta
	 * @return
	 */
	public EsquemaComAnualBean consulta(int tipoConsulta, EsquemaComAnualBean esquemaComAnualBean) {
		EsquemaComAnualBean esquemas = null;
		switch (tipoConsulta) {
			case Enum_Con_EsquemaGarantia.principal:
				esquemas = esquemaComAnualDAO.consultaPrincipal(tipoConsulta, esquemaComAnualBean);
				break;
		}
		
		return esquemas;
	}
	
	public EsquemaComAnualDAO getEsquemaComAnualDAO() {
		return esquemaComAnualDAO;
	}
	
	public void setEsquemaComAnualDAO(EsquemaComAnualDAO esquemaComAnualDAO) {
		this.esquemaComAnualDAO = esquemaComAnualDAO;
	}
}
