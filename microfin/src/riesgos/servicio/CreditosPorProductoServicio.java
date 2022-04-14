package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosPorProductoDAO;
import general.servicio.BaseServicio;

public class CreditosPorProductoServicio extends BaseServicio{
	CreditosPorProductoDAO creditosPorProductoDAO = null;
	
	public CreditosPorProductoServicio (){
		super();
	}
	
	/* ====== Tipo de Lista para Créditos por Producto ======= */
	public static interface Enum_Lis_RepCredProducto{
		int credProdexcel	 = 3;
	}
	
	/* ====== Consulta de Créditos por Producto (Grid) ======= */
	public static interface Enum_Lis_CredProducto {
		int montoProducto = 1;
		int saldoProducto = 2;
	}
	
	// Lista para el reporte en Excel Créditos por Producto 
	public List <UACIRiesgosBean>listaReporteCreditoProducto(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_RepCredProducto.credProdexcel:
				listaReportes = creditosPorProductoDAO.reporteCreditoProducto(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	// Consulta de Créditos por Producto (Grid)
	public List lista(int tipoLista, UACIRiesgosBean riesgosBean){	
		List listaCreditosProd = null;
		switch (tipoLista) {
		case Enum_Lis_CredProducto.montoProducto:		
			listaCreditosProd = creditosPorProductoDAO.listaMontoProducto(tipoLista, riesgosBean);	
			break;	
		case Enum_Lis_CredProducto.saldoProducto:		
			listaCreditosProd = creditosPorProductoDAO.listaSaldoProducto(tipoLista, riesgosBean);	
			break;	
		}
		return listaCreditosProd;
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosPorProductoDAO getCreditosPorProductoDAO() {
		return creditosPorProductoDAO;
	}

	public void setCreditosPorProductoDAO(
			CreditosPorProductoDAO creditosPorProductoDAO) {
		this.creditosPorProductoDAO = creditosPorProductoDAO;
	}

}
