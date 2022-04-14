package tesoreria.servicio;

import general.servicio.BaseServicio;
import java.util.List;
import tesoreria.bean.DistCCInvBancariaBean;
import tesoreria.dao.DistCCInvBancariaDAO;

public class DistCCInvBancariaServicio extends BaseServicio {
	DistCCInvBancariaDAO distCCInvBancariaDAO = null;

	private DistCCInvBancariaServicio() {
		super();
	}

	public static interface Enum_Lis_DistCCInvBancaria {
		int principal = 1;
	}

	public List<DistCCInvBancariaBean> lista(int tipoLista, DistCCInvBancariaBean DistCCInvBancaria) {
		List<DistCCInvBancariaBean> DistCCInvBancariaLista = null;
		switch (tipoLista) {
		case Enum_Lis_DistCCInvBancaria.principal:
			DistCCInvBancariaLista = distCCInvBancariaDAO.lista(
					DistCCInvBancaria, tipoLista);
			break;
		}
		return DistCCInvBancariaLista;
	}

	public DistCCInvBancariaDAO getDistCCInvBancariaDAO() {
		return distCCInvBancariaDAO;
	}

	public void setDistCCInvBancariaDAO(DistCCInvBancariaDAO distCCInvBancariaDAO) {
		this.distCCInvBancariaDAO = distCCInvBancariaDAO;
	}
}
