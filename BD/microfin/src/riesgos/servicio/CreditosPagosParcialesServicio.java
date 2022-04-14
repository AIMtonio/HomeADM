package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosPagosParcialesDAO;
import general.servicio.BaseServicio;

public class CreditosPagosParcialesServicio extends BaseServicio{
	CreditosPagosParcialesDAO creditosPagosParcialesDAO = null;

	public CreditosPagosParcialesServicio() {
	super();
	}
	
	/* ======== Tipo de Lista para Pagos Parciales ============== */
	public static interface Enum_Lis_PagoParcial{
		int excel	 = 1;
	}

	/* ======== Tipo de Consulta para Pagos Parciales ======= */
	public static interface Enum_Con_PagoParcial{
		int pagoParcial	 = 1;
	}
	
	public List <UACIRiesgosBean>listaReportePagosParciales(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_PagoParcial.excel:
				listaReportes = creditosPagosParcialesDAO.reportePagosParciales(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean pagoParcial = null;
		switch (tipoConsulta) {
			case Enum_Con_PagoParcial.pagoParcial:	
				pagoParcial = creditosPagosParcialesDAO.consultaPagoParcial(riesgosBean,tipoConsulta);
				break;									
		}				
		return pagoParcial;
	}
	
	 /* ********************** GETTERS y SETTERS **************************** */
	public CreditosPagosParcialesDAO getCreditosPagosParcialesDAO() {
		return creditosPagosParcialesDAO;
	}

	public void setCreditosPagosParcialesDAO(
			CreditosPagosParcialesDAO creditosPagosParcialesDAO) {
		this.creditosPagosParcialesDAO = creditosPagosParcialesDAO;
	}
	
}
