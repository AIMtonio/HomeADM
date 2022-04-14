package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.SumaTiposAhorroDAO;
import general.dao.BaseDAO;

public class SumaTiposAhorroServicio extends BaseDAO{
	SumaTiposAhorroDAO sumaTiposAhorroDAO = null;

	public SumaTiposAhorroServicio (){
		super();
	}
	
	/* ====== Tipo de Lista para Suma Tipos Ahorro ======= */
	public static interface Enum_Lis_RepSumaTiposAhorro {
		int excel	 = 1;
	}
	
	
	/* == Tipo de Consulta para Suma Tipos Ahorro (Pantalla) ==== */
	public static interface Enum_Con_SumaTiposAhorro {
		int sumaAhorroInversion	 = 1;
	}
	
	// Lista para el reporte en Excel Suma Tipos Ahorro
	public List <UACIRiesgosBean>listaReporteSumaTiposAhorro(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_RepSumaTiposAhorro.excel:
				listaReportes = sumaTiposAhorroDAO.reporteSumaTiposAhorro(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}

		
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean sumTipoAhorro = null;
		switch (tipoConsulta) {
			case Enum_Con_SumaTiposAhorro.sumaAhorroInversion:	
				sumTipoAhorro = sumaTiposAhorroDAO.consultaSumasTiposAhorro(riesgosBean,tipoConsulta);
				break;									
		}				
		return sumTipoAhorro;
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public SumaTiposAhorroDAO getSumaTiposAhorroDAO() {
		return sumaTiposAhorroDAO;
	}

	public void setSumaTiposAhorroDAO(SumaTiposAhorroDAO sumaTiposAhorroDAO) {
		this.sumaTiposAhorroDAO = sumaTiposAhorroDAO;
	}
	
}
