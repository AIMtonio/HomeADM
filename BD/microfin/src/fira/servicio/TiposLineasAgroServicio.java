package fira.servicio;

import java.util.List;

import fira.bean.TiposLineasAgroBean;
import fira.dao.TiposLineasAgroDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TiposLineasAgroServicio extends BaseServicio {

	TiposLineasAgroDAO tiposLineasAgroDAO = null;

	public static interface Enum_Tran_TiposLineasAgro {
		int alta 		= 1;
		int modificar	= 2;
		int baja		= 3;
	}
	public static interface Enum_Act_TiposLineasAgro {
		int baja = 1;
	}

	public static interface Enum_Con_TiposLineasAgro {
		int principal	= 1;
		int manejaLinea = 2;
	}

	public static interface Enum_Lis_TiposLineasAgro {
		int listaPrincipal		= 1;
		int listaComboActivos	= 2;
		int listaComboTodos		= 3;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, TiposLineasAgroBean tiposLineasAgroBean) {

		MensajeTransaccionBean mensajeTransaccionBean = null;
		switch (tipoTransaccion) {
			case Enum_Tran_TiposLineasAgro.alta:
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean = tiposLineasAgroDAO.altaTiposLineasAgro(tiposLineasAgroBean);
			break;
			case Enum_Tran_TiposLineasAgro.modificar:
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean = tiposLineasAgroDAO.modificaTiposLineasAgro(tiposLineasAgroBean);
			break;
			case Enum_Tran_TiposLineasAgro.baja:
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean = actualizacionTipoLinea(tipoActualizacion, tiposLineasAgroBean);
			break;
			default:
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Tipo de Transacción desconocida.");
			break;
		}
		return mensajeTransaccionBean;
	}
	
	public MensajeTransaccionBean actualizacionTipoLinea(int tipoActualizacion, TiposLineasAgroBean tiposLineasAgroBean){
		MensajeTransaccionBean mensajeTransaccionBean = tiposLineasAgroDAO.bajaTiposLineasAgro(tiposLineasAgroBean, tipoActualizacion);	
		return mensajeTransaccionBean;
	}

	public TiposLineasAgroBean consulta(int tipoConsulta, TiposLineasAgroBean tiposLineasAgroBean) {

		TiposLineasAgroBean tiposLineasAgro = null;
		switch(tipoConsulta){
			case Enum_Con_TiposLineasAgro.principal:
			case Enum_Con_TiposLineasAgro.manejaLinea:
				tiposLineasAgro = tiposLineasAgroDAO.consultaPrincipal(tiposLineasAgroBean, tipoConsulta);
			break;
		}
		return tiposLineasAgro;
	}

	public List<TiposLineasAgroBean> lista(int tipoLista, TiposLineasAgroBean tiposLineasAgroBean) {

		List<TiposLineasAgroBean> listaTiposLineasAgroBean = null;
		switch(tipoLista){
			case Enum_Lis_TiposLineasAgro.listaPrincipal:
				listaTiposLineasAgroBean = tiposLineasAgroDAO.listaPrincipal(tiposLineasAgroBean, tipoLista);
			break;
		}
		return listaTiposLineasAgroBean;
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista, TiposLineasAgroBean tiposLineasAgroBean) {
		List<TiposLineasAgroBean> listaInstrumentos = null;
		switch(tipoLista){
		case Enum_Lis_TiposLineasAgro.listaComboActivos:
			listaInstrumentos = tiposLineasAgroDAO.listaCombo(tiposLineasAgroBean, tipoLista);
		break;
		case Enum_Lis_TiposLineasAgro.listaComboTodos:
			listaInstrumentos = tiposLineasAgroDAO.listaCombo(tiposLineasAgroBean, tipoLista);
		break;
		}
		return listaInstrumentos.toArray();
	}

	public TiposLineasAgroDAO getTiposLineasAgroDAO() {
		return tiposLineasAgroDAO;
	}

	public void setTiposLineasAgroDAO(TiposLineasAgroDAO tiposLineasAgroDAO) {
		this.tiposLineasAgroDAO = tiposLineasAgroDAO;
	}

}
