package fira.servicio;

import fira.bean.MinistracionCredAgroBean;
import fira.dao.MinistraCredAgroDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

public class MinistraCredAgroServicio extends BaseServicio {
	
	MinistraCredAgroDAO ministraCredAgroDAO = null;

	public static interface Enum_TransMinistraCredAgro {
		int alta = 1;
		int baja = 2;
	}
	
	public static interface Enum_LisMinistraCredAgro {
		int principal = 1;
		int desembolso = 2;
		int noInactivas = 3;
		int grupales	= 4;
		int grupalesnoformales = 5;
	}
	
	public static interface Enum_Act_MinistraCredAgro {
		int desembolso = 1;
		int cancelacion = 2;
		int actualizaCredito = 3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, MinistracionCredAgroBean ministraciones, String detalles) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_TransMinistraCredAgro.alta:
			long numTransaccion = ministraCredAgroDAO.numTransaccion();
			mensaje = grabaDetalle(tipoTransaccion, ministraciones, detalles, numTransaccion);
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean actualizacion(int numActualizaccion, long numTransaccion, MinistracionCredAgroBean ministraciones) {
		MensajeTransaccionBean mensaje = null;
		switch (numActualizaccion) {
		case Enum_Act_MinistraCredAgro.desembolso:
		case Enum_Act_MinistraCredAgro.cancelacion:
		case Enum_Act_MinistraCredAgro.actualizaCredito:
			mensaje = ministraCredAgroDAO.actualizacion(ministraciones, numTransaccion, numActualizaccion);
			break;
		}
		return mensaje;
	}

	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, MinistracionCredAgroBean ministracionCredAgroBean, String detalles, long numeroTransaccion) {
		MensajeTransaccionBean mensaje = ministraCredAgroDAO.grabaDetalle(ministracionCredAgroBean, detalles, numeroTransaccion);
		return mensaje;
	}
	
	public List<MinistracionCredAgroBean> lista(int tipoLista, MinistracionCredAgroBean ministracionCredAgroBean) {
		List<MinistracionCredAgroBean> lista = null;
		switch (tipoLista) {
		case Enum_LisMinistraCredAgro.principal:
		case Enum_LisMinistraCredAgro.noInactivas:
		case Enum_LisMinistraCredAgro.grupales:
		case Enum_LisMinistraCredAgro.grupalesnoformales:
			lista = ministraCredAgroDAO.lista(tipoLista, ministracionCredAgroBean);
			break;
		case Enum_LisMinistraCredAgro.desembolso:
			lista = ministraCredAgroDAO.listaDesembolso(tipoLista, ministracionCredAgroBean);
			break;
		}
		return lista;
	}

	public MinistraCredAgroDAO getMinistraCredAgroDAO() {
		return ministraCredAgroDAO;
	}

	public void setMinistraCredAgroDAO(MinistraCredAgroDAO ministraCredAgroDAO) {
		this.ministraCredAgroDAO = ministraCredAgroDAO;
	}


}
