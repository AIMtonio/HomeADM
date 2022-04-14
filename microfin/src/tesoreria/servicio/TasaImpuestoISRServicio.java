package tesoreria.servicio;

import java.util.List;

import aportaciones.dao.TasasISRExtDAO;
import tesoreria.bean.TasaImpuestoISRBean;
import tesoreria.dao.TasaImpuestoISRDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TasaImpuestoISRServicio extends BaseServicio{

	TasaImpuestoISRDAO tasaImpuestoISRDAO = null;
	TasasISRExtDAO tasasISRExtDAO = null;

	public static interface Enum_Tra_TasaImpuestoISR {
		int actualiza = 1;
		int actResidentesExt = 2;
	}

	public static interface Enum_Con_TasaImpuestoISR {
		int principal   = 1;
	}

	public static interface Enum_Lis_TasaImpuestoISR {
		int tasaImpuestoISR   = 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TasaImpuestoISRBean tasaImpuestoISR){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_TasaImpuestoISR.actualiza:
			mensaje = tasaImpuestoISRDAO.actualizaTasaImpuestoISR(tasaImpuestoISR);
			break;
		case Enum_Tra_TasaImpuestoISR.actResidentesExt:
			mensaje = tasasISRExtDAO.actualizaTasaImpuestoISR(tasaImpuestoISR);
			break;
		}

		return mensaje;
	}
	public TasaImpuestoISRBean consulta(int tipoConsulta, TasaImpuestoISRBean tasaImpuestoISR){
		TasaImpuestoISRBean tasaImpuestoISRBean = null;
		switch(tipoConsulta){
		case Enum_Con_TasaImpuestoISR.principal:
			tasaImpuestoISRBean = tasaImpuestoISRDAO.consultaPrincipal(tasaImpuestoISR, Enum_Con_TasaImpuestoISR.principal);
			break;

		}
		return tasaImpuestoISRBean;
	}

	public List<TasaImpuestoISRBean> lista(int tipoLista, TasaImpuestoISRBean tasaImpuestoISR){
		List<TasaImpuestoISRBean> tasaImpuestoISRLista = null;
		switch (tipoLista) {
		case  Enum_Lis_TasaImpuestoISR.tasaImpuestoISR:
			tasaImpuestoISRLista = tasaImpuestoISRDAO.listaTasaImpuestoISR(tasaImpuestoISR, tipoLista);
			break;
		}
		return tasaImpuestoISRLista;
	}

	public TasaImpuestoISRDAO getTasaImpuestoISRDAO() {
		return tasaImpuestoISRDAO;
	}

	public void setTasaImpuestoISRDAO(TasaImpuestoISRDAO tasaImpuestoISRDAO) {
		this.tasaImpuestoISRDAO = tasaImpuestoISRDAO;
	}

	public TasasISRExtDAO getTasasISRExtDAO() {
		return tasasISRExtDAO;
	}

	public void setTasasISRExtDAO(TasasISRExtDAO tasasISRExtDAO) {
		this.tasasISRExtDAO = tasasISRExtDAO;
	}
}