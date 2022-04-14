package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosSectorEconomicoDAO;
import general.servicio.BaseServicio;

public class CreditosSectorEconomicoServicio extends BaseServicio{
	CreditosSectorEconomicoDAO creditosSectorEconomicoDAO = null;
	
	public CreditosSectorEconomicoServicio (){
		super ();
	}
	
	/* == Tipo de Lista para Créditos por Sector Economico == */
	public static interface Enum_Lis_RepSectorEconomico{
		int credSectorExcel	 = 3;
	}
	
	/* ==  Consulta de Créditos por Sector Económico (Grid) == */
	public static interface Enum_Lis_SectorEconomico{
		int montoSector = 1;
		int saldoSector = 2;

	}
	
	/* === Tipo de Consulta por Sector Económico ==== */
	public static interface Enum_Con_SectorEco{
		int montoCartera	 = 1;
		int saldoCartera	 = 4;
	}
	
	// Lista para el reporte en Excel Créditos por Sector Económico
	public List <UACIRiesgosBean>listaReporteSectorEconomico(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_RepSectorEconomico.credSectorExcel:
				listaReportes = creditosSectorEconomicoDAO.reporteSectorEconomico(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	// Consulta de Créditos por Sector Económico (Grid)
	public List lista(int tipoLista, UACIRiesgosBean riesgosBean){	
		List listaSectorEconomico = null;
		switch (tipoLista) {
		case Enum_Lis_SectorEconomico.montoSector:		
			listaSectorEconomico = creditosSectorEconomicoDAO.listaMontoSectorEconomico(tipoLista, riesgosBean);	
			break;	
		case Enum_Lis_SectorEconomico.saldoSector:		
			listaSectorEconomico = creditosSectorEconomicoDAO.listaSaldoSectorEconomico(tipoLista, riesgosBean);	
			break;	
		}
		return listaSectorEconomico;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean riesgos = null;
		switch (tipoConsulta) {
			case Enum_Con_SectorEco.saldoCartera:	
				riesgos = creditosSectorEconomicoDAO.consultaCarteraCredito(riesgosBean,tipoConsulta);
				break;	
			case Enum_Con_SectorEco.montoCartera:	
				riesgos = creditosSectorEconomicoDAO.consultaMontoCarteraCredito(riesgosBean,tipoConsulta);
				break;
		}				
		return riesgos;
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosSectorEconomicoDAO getCreditosSectorEconomicoDAO() {
		return creditosSectorEconomicoDAO;
	}

	public void setCreditosSectorEconomicoDAO(
			CreditosSectorEconomicoDAO creditosSectorEconomicoDAO) {
		this.creditosSectorEconomicoDAO = creditosSectorEconomicoDAO;
	}
	
}
