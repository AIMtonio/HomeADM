package tarjetas.servicio;

import java.util.List;

import aportaciones.bean.AportDispersionesBean;

import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import tarjetas.bean.TarBinParamsBean;
import tarjetas.dao.TarBinParamsDAO;

public class TarBinParamsServicio extends BaseServicio{
	
	TarBinParamsDAO tarBinParamsDAO = null;
	TransaccionDAO transaccionDAO = null;
	
	public TarBinParamsServicio(){
		super();
	}
	
	public static interface Enum_Tra_ParamsBIN{
		int alta						=1;
		int modificar					=2;
	}
	
	public static interface Enum_Lis_ParametrosBIN{
		int listaParamsBINPrin = 1;
		int listaParamsBINGrid = 2;
		int listaComboMarcaTar = 3;
	}
	
	public static interface Enum_Con_ParametrosBIN{
		int consultaParamsBinPrin = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TarBinParamsBean tarBinParamsBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_ParamsBIN.alta:
			//ALTA EN BASE DATOS PRINCIPAL
			mensaje = tarBinParamsDAO.altaParametrosBINBDPrincipal(tarBinParamsBean);
			//ALTA BASE MICROFIN
			if(mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR){
				tarBinParamsBean.setTarBinParamsID(mensaje.getConsecutivoString());
				mensaje = tarBinParamsDAO.altaParametrosBIN(tarBinParamsBean);
			}
			break;
		case Enum_Tra_ParamsBIN.modificar:
			//MODIFICACIÓN BASE DATOS PRINCIPAL
			mensaje = tarBinParamsDAO.modificarParametrosBINBDPrincipal(tarBinParamsBean);
			//MODIFICACIÓN BASE DATOS MICROFIN
			if(mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR){
				mensaje = tarBinParamsDAO.modificarParametrosBIN(tarBinParamsBean);
			}
			break;
		}
		return mensaje;
	}
	
	public TarBinParamsBean consulta(int tipoConsulta, TarBinParamsBean tarBinParamsBean){
		TarBinParamsBean tarBinParamsBeanResp = null;
		switch (tipoConsulta) {
		case Enum_Con_ParametrosBIN.consultaParamsBinPrin:
			tarBinParamsBeanResp = tarBinParamsDAO.consultaParametroBINBDPrincipal(tipoConsulta, tarBinParamsBean);
			break;
		default:
			break;
		}
		return tarBinParamsBeanResp;
	}
	
	public List lista(int tipoLista, TarBinParamsBean tarBinParamsBean){
		List parametrosBIN = null;
		switch(tipoLista){
		case Enum_Lis_ParametrosBIN.listaParamsBINPrin:
			parametrosBIN = tarBinParamsDAO.listaParamsBINsBDPrincipal(tipoLista, tarBinParamsBean);
			break;
		case Enum_Lis_ParametrosBIN.listaParamsBINGrid:
			parametrosBIN = tarBinParamsDAO.listaParamsBINsGridBDPrincipal(tipoLista, tarBinParamsBean);
			break;
		case Enum_Lis_ParametrosBIN.listaComboMarcaTar:
			parametrosBIN = tarBinParamsDAO.listaCatMarcaTar(tipoLista, tarBinParamsBean);
			break;
		}
		return parametrosBIN;
	}

	public TarBinParamsDAO getTarBinParamsDAO() {
		return tarBinParamsDAO;
	}

	public void setTarBinParamsDAO(TarBinParamsDAO tarBinParamsDAO) {
		this.tarBinParamsDAO = tarBinParamsDAO;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}
	
}
