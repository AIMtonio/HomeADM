package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.ParamDiasFrecuenciaBean;
import originacion.dao.ParamDiasFrecuenciaDAO;
import originacion.servicio.ReferenciaClienteServicio.Enum_Lis_ReferenciaCliente;

public class ParamDiasFrecuenciaServicio extends BaseServicio{
	
	ParamDiasFrecuenciaDAO paramDiasFrecuenciaDAO;


	private ParamDiasFrecuenciaServicio(){
		super();
	}
	
	public static interface Enum_Transaccion {
		int alta = 1;
	}
	
	/**
	 * Graba la transacción
	 * @param tipoTransaccion
	 * @param paramDiasFrecuenciaBean
	 * @param detalles
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParamDiasFrecuenciaBean paramDiasFrecuenciaBean, String detalles) {
		// TODO Auto-generated method stub
		MensajeTransaccionBean mensaje = null;

		switch (tipoTransaccion) {
		case Enum_Transaccion.alta:
			mensaje = grabaDetalle(tipoTransaccion, paramDiasFrecuenciaBean, detalles);
			break;
		}
		return mensaje;
	}
	
	/**
	 * Graba el detalle de la parametrización de los dias por frecuencia de creditos
	 * @param tipoTransaccion
	 * @param paramDiasFrecuenciaBean
	 * @param detalles
	 * @return
	 */
	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, ParamDiasFrecuenciaBean paramDiasFrecuenciaBean, String detalles) {
		List<ParamDiasFrecuenciaBean> listaDetalle = creaListaDetalle(paramDiasFrecuenciaBean,detalles);
		MensajeTransaccionBean mensaje=paramDiasFrecuenciaDAO.grabaDetalle(paramDiasFrecuenciaBean, listaDetalle);
		return mensaje;
	}

	/**
	 * Método para crear la lista de detalles
	 * @param paramDiasFrecuenciaBean
	 * @param detalles
	 * @return
	 */
	private List<ParamDiasFrecuenciaBean> creaListaDetalle(ParamDiasFrecuenciaBean paramDiasFrecuenciaBean, String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<ParamDiasFrecuenciaBean> listaDetalle = new ArrayList<ParamDiasFrecuenciaBean>();
		ParamDiasFrecuenciaBean detalle;
		while (tokensBean.hasMoreTokens()) {
			detalle = new ParamDiasFrecuenciaBean();
			stringCampos = tokensBean.nextToken();
			
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalle.setProducCreditoID(paramDiasFrecuenciaBean.getProducCreditoID());
			detalle.setFrecuencia(tokensCampos[0]);
			detalle.setDias(tokensCampos[1]);

			listaDetalle.add(detalle);
		}
		return listaDetalle;
	}

	public List<ParamDiasFrecuenciaBean> lista(int tipoLista, ParamDiasFrecuenciaBean paramDiasFrecuenciaBean){
		List<ParamDiasFrecuenciaBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_ReferenciaCliente.lista:
			lista = paramDiasFrecuenciaDAO.lista(paramDiasFrecuenciaBean,tipoLista);
			break;
		}
		return lista;
	}
	
	public ParamDiasFrecuenciaDAO getParamDiasFrecuenciaDAO() {
		return paramDiasFrecuenciaDAO;
	}

	public void setParamDiasFrecuenciaDAO(ParamDiasFrecuenciaDAO paramDiasFrecuenciaDAO) {
		this.paramDiasFrecuenciaDAO = paramDiasFrecuenciaDAO;
	}

}
