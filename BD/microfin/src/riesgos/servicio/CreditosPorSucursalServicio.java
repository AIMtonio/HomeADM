package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosPorSucursalDAO;
import general.servicio.BaseServicio;

public class CreditosPorSucursalServicio extends BaseServicio{
	CreditosPorSucursalDAO creditosPorSucursalDAO = null; 
	
	public CreditosPorSucursalServicio (){
		super();
	}
	
	/* == Tipo de Lista para Créditos por Sucursal == */
	public static interface Enum_Lis_RepCredSucursal{
		int credSucExcel   = 3;
	}
	
	/* == Consulta de Créditos por Sucursal (Grid) == */
	public static interface Enum_Lis_CredSucursal{
		int montoSucursal = 1;
		int saldoSucursal = 2;
	}
	
			
	// Lista para el reporte en Excel Créditos por Sucursal
	public List <UACIRiesgosBean>listaReporteCreditosSucursal(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_RepCredSucursal.credSucExcel:
				listaReportes = creditosPorSucursalDAO.reporteCreditoSucursal(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	// Consulta de Créditos por Sucursal (Grid)
	public List lista(int tipoLista, UACIRiesgosBean riesgosBean){	
		List listaSucursal= null;
		switch (tipoLista) {
		case Enum_Lis_CredSucursal.montoSucursal:		
			listaSucursal = creditosPorSucursalDAO.listaMontoSucursal(tipoLista, riesgosBean);	
			break;	
		case Enum_Lis_CredSucursal.saldoSucursal:		
			listaSucursal = creditosPorSucursalDAO.listaSaldoSucursal(tipoLista, riesgosBean);	
			break;		
		}
		return listaSucursal;
	}
	
	
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosPorSucursalDAO getCreditosPorSucursalDAO() {
		return creditosPorSucursalDAO;
	}

	public void setCreditosPorSucursalDAO(
			CreditosPorSucursalDAO creditosPorSucursalDAO) {
		this.creditosPorSucursalDAO = creditosPorSucursalDAO;
	}

}
