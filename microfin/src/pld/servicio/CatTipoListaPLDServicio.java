package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import java.util.List;
import pld.bean.CatTipoListaPLDBean;
import pld.dao.CatTipoListaPLDDAO;

public class CatTipoListaPLDServicio extends BaseServicio {
	
	CatTipoListaPLDDAO	catTipoListaPLDDAO;
	
	public static interface Enum_Tra_CatTipoLista {
		int	alta			= 1;
		int	modificacion	= 2;
	}
	
	public static interface Enum_Con_CatTipoLista {
		int	principal	= 1;
	}
	
	public static interface Enum_Lis_CatTipoLista {
		int	principal	= 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CatTipoListaPLDBean catTipoListaPLDBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_CatTipoLista.alta:
				mensaje = catTipoListaPLDDAO.grabar(catTipoListaPLDBean);
				break;
			case Enum_Tra_CatTipoLista.modificacion:
				mensaje = catTipoListaPLDDAO.modifica(catTipoListaPLDBean);
				break;
		}
		return mensaje;
	}
	
	public CatTipoListaPLDBean consulta(int tipoConsulta, CatTipoListaPLDBean catTipoListaPLDBean) {
		CatTipoListaPLDBean catTipoListaPLD = null;
		switch (tipoConsulta) {
			case Enum_Con_CatTipoLista.principal:
				catTipoListaPLD = catTipoListaPLDDAO.consultaPrincipal(catTipoListaPLDBean, tipoConsulta);
				break;
		}
		return catTipoListaPLD;
	}
	
	public List<CatTipoListaPLDBean> lista(int tipoLista, CatTipoListaPLDBean catTipoListaPLDBean) {
		List<CatTipoListaPLDBean> lista = null;
		switch (tipoLista) {
			case Enum_Lis_CatTipoLista.principal:
				lista = catTipoListaPLDDAO.lista(catTipoListaPLDBean, tipoLista);
				break;
		}
		return lista;
	}
	
	public CatTipoListaPLDDAO getCatTipoListaPLDDAO() {
		return catTipoListaPLDDAO;
	}
	
	public void setCatTipoListaPLDDAO(CatTipoListaPLDDAO catTipoListaPLDDAO) {
		this.catTipoListaPLDDAO = catTipoListaPLDDAO;
	}
	
}
