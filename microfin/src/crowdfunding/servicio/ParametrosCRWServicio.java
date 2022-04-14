package crowdfunding.servicio;

import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;
import crowdfunding.bean.ParametrosCRWBean;
import crowdfunding.dao.ParametrosCRWDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

public class ParametrosCRWServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ParametrosCRWDAO parametrosCRWDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Param {
		int principal = 1;
	}


	//---------- tipos Transacciones ------------------------------------------------------------------------

	public static interface Enum_Tra_Param  {
		int alta = 1;
		int modificar = 2;
	}

	//---------- tipos Consulta ------------------------------------------------------------------------

	public static interface Enum_Con_Param  {
		int principal = 1;
	}


	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosCRWBean parametrosCRWBean, ParamGeneralesBean generalesBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = paramGeneralesServicio.actualizacion(1, generalesBean);
		if(generalesBean.getValorParametro().equalsIgnoreCase(Constantes.STRING_SI) && mensaje.getNumero()==0){
			switch (tipoTransaccion) {
			case Enum_Tra_Param.alta:
				mensaje = alta(parametrosCRWBean);
				break;
			case Enum_Tra_Param.modificar:
				mensaje = modifica(parametrosCRWBean);
				break;
			}
		}
		return mensaje;
	}


	public MensajeTransaccionBean alta(ParametrosCRWBean parametrosCRWBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosCRWDAO.altaParametros(parametrosCRWBean);
		return mensaje;
	}

	public MensajeTransaccionBean modifica(ParametrosCRWBean parametrosCRWBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosCRWDAO.modificaParametros(parametrosCRWBean);
		return mensaje;
	}

	public ParametrosCRWBean consulta(int tipoConsulta, ParametrosCRWBean parametrosCRWBean){
		ParametrosCRWBean parametrosCRW = null;
		switch (tipoConsulta) {
		case Enum_Con_Param.principal:
			parametrosCRW = parametrosCRWDAO.consultaPrincipal(parametrosCRWBean, tipoConsulta);
			break;
		}
		return parametrosCRW;
	}

	public ParametrosCRWDAO getParametrosCRWDAO() {
		return parametrosCRWDAO;
	}


	public void setParametrosCRWDAO(ParametrosCRWDAO parametrosCRWDAO) {
		this.parametrosCRWDAO = parametrosCRWDAO;
	}


	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}


	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

}