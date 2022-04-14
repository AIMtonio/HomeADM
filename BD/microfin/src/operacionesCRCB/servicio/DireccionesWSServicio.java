package operacionesCRCB.servicio;

import operacionesCRCB.beanWS.request.ActualizaDireccionRequest;
import operacionesCRCB.beanWS.request.AltaCuentaAutorizadaRequest;
import operacionesCRCB.beanWS.response.ActualizaDireccionResponse;
import operacionesCRCB.beanWS.response.AltaCuentaAutorizadaResponse;
import operacionesCRCB.dao.CuentaAutorizadaDAO;
import operacionesCRCB.dao.DireccionesWSDAO;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import general.servicio.BaseServicio;

public class DireccionesWSServicio extends BaseServicio {

	DireccionesWSDAO direccionesWSDAO = null;
	ParametrosSisServicio		parametrosSisServicio	= null;

	public DireccionesWSServicio(){
		super();
	}

	public static interface Enum_Tran_Direcc {
		int modifica = 2;
	}

	public ActualizaDireccionResponse grabaTransaccion(ActualizaDireccionRequest actualizaDireccionRequest, int tipoTransaccion){
		ActualizaDireccionResponse altaCuentaResponse = null;
		switch(tipoTransaccion){
		case Enum_Tran_Direcc.modifica:
			altaCuentaResponse =  modificaDireccionWS(actualizaDireccionRequest);
			break;
		}

		return altaCuentaResponse;

	}

	private	ActualizaDireccionResponse modificaDireccionWS(ActualizaDireccionRequest actualizaDireccionRequest) {

		ActualizaDireccionResponse altaCuentaResponse = null;
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean.setEmpresaID("1");
		parametrosSisBean = parametrosSisServicio.consulta(1, parametrosSisBean);

		altaCuentaResponse =  direccionesWSDAO.modificaDireccion(actualizaDireccionRequest);


		if(altaCuentaResponse.getCodigoRespuesta().contentEquals("0")) {
			if(parametrosSisBean.getReplicaAct().equalsIgnoreCase("S")) {
				altaCuentaResponse =  direccionesWSDAO.modificaDireccionReplica(actualizaDireccionRequest, parametrosSisBean.getOrigenReplica());
			}
		}

		return altaCuentaResponse;
	}

	public DireccionesWSDAO getDireccionesWSDAO() {
		return direccionesWSDAO;
	}

	public void setDireccionesWSDAO(DireccionesWSDAO direccionesWSDAO) {
		this.direccionesWSDAO = direccionesWSDAO;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}


}
