package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosPagosUnicosDAO;
import general.servicio.BaseServicio;

public class CreditosPagosUnicosServicio extends BaseServicio{
	CreditosPagosUnicosDAO creditosPagosUnicosDAO = null;
	
	public CreditosPagosUnicosServicio() {
		super();
		}
	
	 /* ======== Tipo de Lista para Pagos Únicos ============== */
	public static interface Enum_Lis_PagoUnico	{
		int excel	 = 2;
	}
	
	/* ======== Tipo de Consulta para Pagos Únicos ======= */
	public static interface Enum_Con_PagoUnico{
		int pagoUnico	 = 2;
	}

	public List <UACIRiesgosBean>listaReportePagoUnico(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_PagoUnico.excel:
				listaReportes = creditosPagosUnicosDAO.reportePagoUnico(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean pagoUnico = null;
		switch (tipoConsulta) {
			case Enum_Con_PagoUnico.pagoUnico:	
				pagoUnico = creditosPagosUnicosDAO.consultaPagoUnico(riesgosBean,tipoConsulta);
				break;									
		}				
		return pagoUnico;
	}
	 /* ********************** GETTERS y SETTERS **************************** */
	public CreditosPagosUnicosDAO getCreditosPagosUnicosDAO() {
		return creditosPagosUnicosDAO;
	}

	public void setCreditosPagosUnicosDAO(
			CreditosPagosUnicosDAO creditosPagosUnicosDAO) {
		this.creditosPagosUnicosDAO = creditosPagosUnicosDAO;
	}
	
}
