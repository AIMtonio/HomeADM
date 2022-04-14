package spei.servicio;

import java.util.ArrayList;


import spei.bean.ParamPagoCreditoBean;
import spei.dao.ParamPagoCreditoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ParamPagoCreditoServicio extends BaseServicio{

	private ParamPagoCreditoServicio(){
		super();
	}
	
	ParamPagoCreditoDAO paramPagoCreditoDAO=null;

		
	public static interface Enum_Tra_Param {
		int modificacion = 1;
	}	
	
	public static interface Enum_Con_Param{
		int principal = 1;
	
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParamPagoCreditoBean paramPagoCredito) {
		
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){		
		case Enum_Tra_Param.modificacion:
			mensaje = paramPagoCreditoDAO.modificacion(paramPagoCredito,tipoTransaccion);
			break;	
		}
		return mensaje;
	
	}
	
	
	public ParamPagoCreditoBean consulta(int tipoConsulta, ParamPagoCreditoBean paramPagoCreditoBean){		
		ParamPagoCreditoBean consultaSpei = null;
		switch (tipoConsulta) {
		case Enum_Con_Param.principal:		
			consultaSpei =  paramPagoCreditoDAO.consultaPrincipal(tipoConsulta, paramPagoCreditoBean);				
			break;	
		}	

		return consultaSpei;
	}
	
	
	public ParamPagoCreditoDAO getParamPagoCreditoDAO() {
		return paramPagoCreditoDAO;
	}

	public void setParamPagoCreditoDAO(ParamPagoCreditoDAO paramPagoCreditoDAO) {
		this.paramPagoCreditoDAO = paramPagoCreditoDAO;
	}
	
	
	
}
