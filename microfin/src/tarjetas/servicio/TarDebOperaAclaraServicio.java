package tarjetas.servicio;


import java.util.List;

import tarjetas.bean.TarDebOperaAclaranBean;
import tarjetas.dao.TarDebOperaAclaraDAO;

import general.servicio.BaseServicio;

public class TarDebOperaAclaraServicio extends BaseServicio {
	
	TarDebOperaAclaraDAO tarDebOperaAclaraDAO = null;

	public TarDebOperaAclaraServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	

	public static interface Enum_lis_0peraAclara{
		int listaCombo 	= 1;
		int listaCreCombo = 2;
	}

	
	public List listaCombo(int tipoLista, TarDebOperaAclaranBean tarDebOperaAclaranBean){		
		List listaOperacionAclaracion = null;
		switch (tipoLista) {
			case Enum_lis_0peraAclara.listaCombo:		
				listaOperacionAclaracion = tarDebOperaAclaraDAO.listaAclaracion(tarDebOperaAclaranBean, tipoLista);				
			break;
			case Enum_lis_0peraAclara.listaCreCombo:		
				listaOperacionAclaracion = tarDebOperaAclaraDAO.listaCreAclaracion(tarDebOperaAclaranBean, tipoLista);				
			break;	
		}			
		return listaOperacionAclaracion;
	}
	
	//------------------setter y getter-----------

	public TarDebOperaAclaraDAO getOperacionAclaracionDAO() {
		return tarDebOperaAclaraDAO;
	}

	public void setOperacionAclaracionDAO(TarDebOperaAclaraDAO tarDebOperaAclaraDAO) {
		this.tarDebOperaAclaraDAO = tarDebOperaAclaraDAO;
	}
}