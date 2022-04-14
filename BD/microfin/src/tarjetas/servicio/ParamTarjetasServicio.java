package tarjetas.servicio;

import java.util.List;

import tarjetas.bean.ParamTarjetasBean;
import tarjetas.dao.ParamTarjetasDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ParamTarjetasServicio extends BaseServicio {
	
	ParamTarjetasDAO paramTarjetasDAO = null;
	
	public static interface Enum_Tran_Parametros {
		int grabar = 1;
	}

	public static interface Enum_Con_Parametros {
		int principal = 1;
	}

	public static interface Enum_Lis_Parametros {
		int principal = 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParamTarjetasBean paramTarjetasBean) {

		MensajeTransaccionBean mensajeTransaccionBean = null;

		try{
			switch (tipoTransaccion) {
				case Enum_Tran_Parametros.grabar:
					mensajeTransaccionBean = paramTarjetasDAO.actualizaParamTarjetas(paramTarjetasBean);
				break;
				default:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(999);
					mensajeTransaccionBean.setDescripcion("Tipo de Transacción desconocida.");
				break;
			}
		} catch(Exception exception){
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error al Grabar la Transacción");
			}
			loggerSAFI.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();
		}
		return mensajeTransaccionBean;
	}

	public ParamTarjetasBean consulta(int tipoConsulta, ParamTarjetasBean paramTarjetasBean) {

		ParamTarjetasBean paramTarjetas = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_Parametros.principal:
					paramTarjetas = paramTarjetasDAO.consultaPrincipal(paramTarjetasBean, tipoConsulta);
				break;
				default:
					paramTarjetas = null;
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Parámetros de Tarjetas ", exception);
			exception.printStackTrace();
		}
		return paramTarjetas;
	}


	public List<ParamTarjetasBean> lista(int tipoLista,  ParamTarjetasBean paramTarjetasBean) {

		List<ParamTarjetasBean> listaParametros = null;
		try{
			switch(tipoLista){
				case Enum_Lis_Parametros.principal:
					listaParametros = paramTarjetasDAO.listaPrincipal(paramTarjetasBean, tipoLista);
				break;
				default:
					listaParametros = null;
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta ", exception);
			exception.printStackTrace();
		}
		return listaParametros;
	}
	public ParamTarjetasDAO getParamTarjetasDAO() {
		return paramTarjetasDAO;
	}

	public void setParamTarjetasDAO(ParamTarjetasDAO paramTarjetasDAO) {
		this.paramTarjetasDAO = paramTarjetasDAO;
	}
}
