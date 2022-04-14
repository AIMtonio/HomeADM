package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.EsquemaSeguroBean;
import originacion.dao.EsquemaSeguroDAO;
import originacion.servicio.ReferenciaClienteServicio.Enum_Lis_ReferenciaCliente;

public class EsquemaSeguroServicio extends BaseServicio{
	
	EsquemaSeguroDAO esquemaSeguroDAO;


	private EsquemaSeguroServicio(){
		super();
	}
	
	public static interface Enum_Transaccion {
		int alta = 1;
	}
	
	public static interface Enum_Lis_EsquemaSeguro{
		int lista = 1;
	}
	
	public static interface Enum_Consulta {
		int principal = 1;
	}
	
	/**
	 * Graba la transacción
	 * @param tipoTransaccion
	 * @param esquemaSeguroBean
	 * @param detalles
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EsquemaSeguroBean esquemaSeguroBean, String detalles) {
		// TODO Auto-generated method stub
		MensajeTransaccionBean mensaje = null;

		switch (tipoTransaccion) {
		case Enum_Transaccion.alta:
			mensaje = grabaDetalle(tipoTransaccion, esquemaSeguroBean, detalles);
			break;
		}
		return mensaje;
	}
	
	/**
	 * Graba el detalle del esquema de seguros
	 * @param tipoTransaccion
	 * @param esquemaSeguroBean
	 * @param detalles
	 * @return
	 */
	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, EsquemaSeguroBean esquemaSeguroBean, String detalles) {
		List<EsquemaSeguroBean> listaDetalle = creaListaDetalle(esquemaSeguroBean,detalles);
		MensajeTransaccionBean mensaje=esquemaSeguroDAO.grabaDetalle(esquemaSeguroBean, listaDetalle);
		return mensaje;
	}

	/**
	 * Método para crear la lista de detalles
	 * @param esquemaSeguroBean
	 * @param detalles
	 * @return
	 */
	private List<EsquemaSeguroBean> creaListaDetalle(EsquemaSeguroBean esquemaSeguroBean, String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<EsquemaSeguroBean> listaDetalle = new ArrayList<EsquemaSeguroBean>();
		EsquemaSeguroBean detalle;
		while (tokensBean.hasMoreTokens()) {
			detalle = new EsquemaSeguroBean();
			stringCampos = tokensBean.nextToken();
			
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalle.setProducCreditoID(esquemaSeguroBean.getProducCreditoID());
			detalle.setFrecuencia(tokensCampos[0]);
			detalle.setMonto(tokensCampos[1]);

			listaDetalle.add(detalle);
		}
		return listaDetalle;
	}

	public List<EsquemaSeguroBean> lista(int tipoLista, EsquemaSeguroBean esquemaSeguroBean){
		List<EsquemaSeguroBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_EsquemaSeguro.lista:
			lista = esquemaSeguroDAO.lista(esquemaSeguroBean,tipoLista);
			break;
		}
		return lista;
	}
	
	public EsquemaSeguroBean consulta(EsquemaSeguroBean esquemaSeguroBean, int tipoConsulta){
		EsquemaSeguroBean esquema = null;
		switch (tipoConsulta) {
		case Enum_Consulta.principal:
			esquema=esquemaSeguroDAO.consulta(esquemaSeguroBean, tipoConsulta);
			break;
		}
		return esquema;
	}
	
	public EsquemaSeguroDAO getEsquemaSeguroDAO() {
		return esquemaSeguroDAO;
	}

	public void setEsquemaSeguroDAO(EsquemaSeguroDAO esquemaSeguroDAO) {
		this.esquemaSeguroDAO = esquemaSeguroDAO;
	}

}
