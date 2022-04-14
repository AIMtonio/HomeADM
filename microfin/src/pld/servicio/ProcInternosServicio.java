package pld.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import pld.bean.MotivosPreoBean;
import pld.bean.ProcInternosBean;
import pld.dao.MotivosPreoDAO;
import pld.dao.ProcInternosDAO;
import pld.servicio.MotivosPreoServicio.Enum_Con_MotivosPreo;
import pld.servicio.MotivosPreoServicio.Enum_Lis_MotivosPreo;

public class ProcInternosServicio extends BaseServicio {

	private ProcInternosServicio(){
		super();
	}

	ProcInternosDAO procInternosDAO = null;

	public static interface Enum_Lis_ProcInternos{
		int alfanumerica = 1;
		int foranea 	 = 2;
	}
	
	public static interface Enum_Con_ProcInternos{
		int principal = 1;
		int principalExterna=2;
	}
	
	
	
	public List lista(int tipoLista, ProcInternosBean procInternos){		
		List listaProcInternos = null;
		switch (tipoLista) {
			case Enum_Lis_ProcInternos.alfanumerica:		
				listaProcInternos=  procInternosDAO.listaAlfanumerica(procInternos, Enum_Lis_ProcInternos.alfanumerica);				
				break;
			case Enum_Lis_ProcInternos.foranea:		
				listaProcInternos=  procInternosDAO.listaAlfExterno(procInternos, Enum_Lis_ProcInternos.alfanumerica);				
				break;	
		}		
		return listaProcInternos;
	}
	
	
	public ProcInternosBean consulta(int tipoConsulta, ProcInternosBean procInternos){
		ProcInternosBean procInternosBean = null;
		switch(tipoConsulta){
			case Enum_Con_ProcInternos.principal:
				procInternosBean = procInternosDAO.consultaPrincipal(procInternos, Enum_Con_ProcInternos.principal);
			break;
			case Enum_Con_ProcInternos.principalExterna:
				procInternosBean = procInternosDAO.consultaPrincipalExterna(procInternos, Enum_Con_ProcInternos.principal);
			break;
		}
		return procInternosBean;
		
	}
	
		
	public void setProcInternosDAO(ProcInternosDAO procInternosDAO ){
		this.procInternosDAO = procInternosDAO;
	}

	public ProcInternosDAO getProcInternosDAO() {
		return procInternosDAO;
	}

}
