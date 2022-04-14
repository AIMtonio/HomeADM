package ventanilla.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import soporte.bean.SucursalesBean;
import soporte.dao.SucursalesDAO;
import soporte.servicio.SucursalesServicio;
import credito.bean.CreditosBean;
import credito.dao.CreditosDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;
import cuentas.servicio.MonedasServicio;
import ventanilla.bean.RepPagServBean;
import ventanilla.dao.RepPagoSeviciosDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class RepPagoServiciosServicio extends BaseServicio{
	ParametrosSesionBean parametrosSesionBean;
	MonedasServicio monedasServicio = new MonedasServicio();
	RepPagoSeviciosDAO repPagoSeviciosDAO = new RepPagoSeviciosDAO();
	

	//
	public static interface Enum_Lis_Rep {
		int listaRepPagoServicios 	= 2;
	}
	
	
	
	//:::::::::::::::::::::::::::::::::::::::::::::::REVERSAS :::::::::::::::::::::::::::::::::::::::::......
	public List <RepPagServBean> listaReporte(int tipoLista, RepPagServBean repPagServBean){	
		List <RepPagServBean> listaOperaciones = null;
		switch (tipoLista) {
		
			case Enum_Lis_Rep.listaRepPagoServicios:	
				listaOperaciones = repPagoSeviciosDAO.listaRepPagosServicios(repPagServBean);				
				break;				
		}		
		return listaOperaciones;
	}
	
	
	
	//------------------------setter y getters--------------------------------
		
	

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

		public MonedasServicio getMonedasServicio() {
		return monedasServicio;
	}

	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}



	public RepPagoSeviciosDAO getRepPagoSeviciosDAO() {
		return repPagoSeviciosDAO;
	}



	public void setRepPagoSeviciosDAO(RepPagoSeviciosDAO repPagoSeviciosDAO) {
		this.repPagoSeviciosDAO = repPagoSeviciosDAO;
	}



	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	
	
}