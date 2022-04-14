package tarjetas.servicio;


import java.util.List;


import tarjetas.bean.TarDebTipoAclaraBean;
import tarjetas.dao.TarDebTipoAclaraDAO;
import general.servicio.BaseServicio;

public class TarDebTipoAclaraServicio extends BaseServicio {
	
	TarDebTipoAclaraDAO tarDebTipoAclaraDAO = null;

	public TarDebTipoAclaraServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	

	public static interface Enum_lis_tipoAclara{
		int listaCombo 	= 2;
	}

	
	public List lista(int tipoLista, TarDebTipoAclaraBean tarDebTipoAclaraBean){		
		List listaTipoAclaracion = null;
		switch (tipoLista) {
			case Enum_lis_tipoAclara.listaCombo:		
				listaTipoAclaracion = tarDebTipoAclaraDAO.listaReportes(tarDebTipoAclaraBean, tipoLista);				
				break;	
		}			
		return listaTipoAclaracion;
	}


	public TarDebTipoAclaraDAO getTarDebTipoAclaraDAO() {
		return tarDebTipoAclaraDAO;
	}


	public void setTarDebTipoAclaraDAO(TarDebTipoAclaraDAO tarDebTipoAclaraDAO) {
		this.tarDebTipoAclaraDAO = tarDebTipoAclaraDAO;
	}
	
	//------------------setter y getter-----------
	
}
