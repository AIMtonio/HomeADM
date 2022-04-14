package fira.servicio;

import java.util.List;

import fira.bean.UniConceptosInvAgroBean;
import fira.dao.CreditosAgroDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class UniConceptosInvAgroServicio extends BaseServicio {
	CreditosAgroDAO creditosAgroDAO = null;

	public UniConceptosInvAgroServicio() {
		super();
	}

	public static interface Enum_Tra_UnidadInv {
		int	alta			= 1;
		int	modificacion	= 2;
	}

	public static interface Enum_Con_UnidadInv {
		int principal = 1;
	}
	public static interface Enum_Lis_UnidadInv {
		int principal = 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, UniConceptosInvAgroBean unidades) {

		MensajeTransaccionBean mensaje = null;
try{
		switch (tipoTransaccion) {
		case Enum_Tra_UnidadInv.alta:
			mensaje = creditosAgroDAO.altaUnidadConcepto(tipoTransaccion, unidades);
			break;
		case Enum_Tra_UnidadInv.modificacion:
			mensaje = creditosAgroDAO.modificaUnidadConcepto(tipoTransaccion, unidades);
			break;
		}
} catch (Exception ex) {
	ex.printStackTrace();
	mensaje=new MensajeTransaccionBean();
	mensaje.setNumero(404);
	mensaje.setDescripcion("Error en el servicio .");
}
		return mensaje;
	}

	public UniConceptosInvAgroBean consulta(int tipoConsulta, UniConceptosInvAgroBean conceptosInversionBean) {
		UniConceptosInvAgroBean conceptosInvernBean = null;
		switch (tipoConsulta) {
		case Enum_Con_UnidadInv.principal:
			conceptosInvernBean = creditosAgroDAO.consultaUnidadConceptoInv(tipoConsulta, conceptosInversionBean);
			break;
		}
		return conceptosInvernBean;
	}
	
	public List<UniConceptosInvAgroBean> lista(int tipoLista, UniConceptosInvAgroBean conceptosInversionBean) {
		List<UniConceptosInvAgroBean> lista = null;
		switch (tipoLista) {
			case Enum_Lis_UnidadInv.principal:
				lista = creditosAgroDAO.listaUnidadConceptoInv(conceptosInversionBean, tipoLista);
				break;
		}
		return lista;
	}

	public CreditosAgroDAO getCreditosAgroDAO() {
		return creditosAgroDAO;
	}

	public void setCreditosAgroDAO(CreditosAgroDAO creditosAgroDAO) {
		this.creditosAgroDAO = creditosAgroDAO;
	}
}
