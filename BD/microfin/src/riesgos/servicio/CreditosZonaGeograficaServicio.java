package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosZonaGeograficaDAO;
import general.servicio.BaseServicio;

public class CreditosZonaGeograficaServicio extends BaseServicio{
	CreditosZonaGeograficaDAO creditosZonaGeograficaDAO = null;
	
	public CreditosZonaGeograficaServicio (){
		super();
	}
	
	/* ======== Tipo de Lista para Créditos por Zona Geográfica ======== */
	public static interface Enum_Lis_CredZonaGeo {
		int excel	 = 1;
	}

	/* ===== Tipo de Consulta para Créditos por Zona Geográfica ====== */
	public static interface Enum_Con_CredZonaGeo{
		int creditosZonaGeo	 = 1;
	}
	
	public List <UACIRiesgosBean>listaReporteCredZonaGeo(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_CredZonaGeo.excel:
				listaReportes = creditosZonaGeograficaDAO.reporteCredZonaGeografica(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}

	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean credZonaGeo = null;
		switch (tipoConsulta) {
			case Enum_Con_CredZonaGeo.creditosZonaGeo:	
				credZonaGeo = creditosZonaGeograficaDAO.consultaCredZonaGeografica(riesgosBean,tipoConsulta);
				break;									
		}				
		return credZonaGeo;
	}
	
	 /* ********************** GETTERS y SETTERS **************************** */
	public CreditosZonaGeograficaDAO getCreditosZonaGeograficaDAO() {
		return creditosZonaGeograficaDAO;
	}

	public void setCreditosZonaGeograficaDAO(
			CreditosZonaGeograficaDAO creditosZonaGeograficaDAO) {
		this.creditosZonaGeograficaDAO = creditosZonaGeograficaDAO;
	}

}
