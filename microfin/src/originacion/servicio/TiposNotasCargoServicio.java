package originacion.servicio;

import java.util.List;
import general.bean.MensajeTransaccionBean;
import originacion.bean.TiposNotasCargoBean;
import originacion.dao.TiposNotasCargoDAO;
import general.servicio.BaseServicio;

public class TiposNotasCargoServicio extends BaseServicio {

	private TiposNotasCargoDAO tiposNotasCargoDAO = null;

	public static interface Enum_Tra_TipoNotas {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_TipoNota {
		int consultaPrincipal = 1;
	}
	
	public static interface Enum_Lis_TipoNota {
		int listaAyuda = 1;
		int listaCombo = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TiposNotasCargoBean tiposNotasCargoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
		case Enum_Tra_TipoNotas.alta:
			mensaje = tiposNotasCargoDAO.altaTipoNotasCargo(tiposNotasCargoBean);
			break;
		case Enum_Tra_TipoNotas.modificacion:
			mensaje = tiposNotasCargoDAO.modificaTipoNotasCargo(tiposNotasCargoBean);
			break;
		}
		return mensaje;
	}

	public TiposNotasCargoBean consulta(int tipoConsulta, TiposNotasCargoBean tiposNotasCargoBean) {
		TiposNotasCargoBean beanConsulta = null;
		switch(tipoConsulta) {
			case Enum_Con_TipoNota.consultaPrincipal:
				beanConsulta = tiposNotasCargoDAO.consultaPrincipal(tiposNotasCargoBean, tipoConsulta);
				break;
		}
		return beanConsulta;
	}

	public List<?> lista(int tipoLista, TiposNotasCargoBean tiposNotasCargoBean) {
		List<?> resultado = null;
		switch (tipoLista) {
			case Enum_Lis_TipoNota.listaAyuda:
				resultado = tiposNotasCargoDAO.listaAyuda(tipoLista, tiposNotasCargoBean);
				break;
			case Enum_Lis_TipoNota.listaCombo:
				resultado = tiposNotasCargoDAO.listaCombo(tipoLista, tiposNotasCargoBean);
				break;
		}
		return resultado;
	}

	public TiposNotasCargoDAO getTiposNotasCargoDAO() {
		return tiposNotasCargoDAO;
	}

	public void setTiposNotasCargoDAO(TiposNotasCargoDAO tiposNotasCargoDAO) {
		this.tiposNotasCargoDAO = tiposNotasCargoDAO;
	}
}
