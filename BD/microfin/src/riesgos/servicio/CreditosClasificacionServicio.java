package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosClasificacionDAO;
import general.servicio.BaseServicio;

public class CreditosClasificacionServicio extends BaseServicio{
	CreditosClasificacionDAO creditosClasificacionDAO = null;
	
	public CreditosClasificacionServicio (){
		super();
	}
	/* ======= Tipo de Lista para Créditos por Clasificación ====== */
	public static interface Enum_Lis_CreditosClasifica	{
		int excel	 = 1;
	}

	/* == Tipo de Consulta para Créditos por Clasificación ==== */
	public static interface Enum_Con_CreditosClasifica{
		int creditosClasificacion	 = 1;
	}
	
	public List <UACIRiesgosBean>listaReporteCredConsumo(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_CreditosClasifica.excel:
				listaReportes = creditosClasificacionDAO.reporteCreditosClasificacion(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean clasificacion = null;
		switch (tipoConsulta) {
			case Enum_Con_CreditosClasifica.creditosClasificacion:	
				clasificacion = creditosClasificacionDAO.consultaCreditosClasificacion(riesgosBean,tipoConsulta);
				break;									
		}				
		return clasificacion;
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosClasificacionDAO getCreditosClasificacionDAO() {
		return creditosClasificacionDAO;
	}

	public void setCreditosClasificacionDAO(
			CreditosClasificacionDAO creditosClasificacionDAO) {
		this.creditosClasificacionDAO = creditosClasificacionDAO;
	}

}
