package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import contabilidad.servicio.CatMetodosPagoServicio.Enum_Lis_CatMetodoPago;

import originacion.bean.OtrosAccesoriosBean;
import originacion.dao.OtrosAccesoriosDAO;

public class OtrosAccesoriosServicio extends BaseServicio{
	
	OtrosAccesoriosDAO otrosAccesoriosDAO;

	private OtrosAccesoriosServicio(){
		super();
	}
	
	public static interface Enum_Transaccion {
		int altaAccesorios = 1;
	}
	
	public static interface Enum_Lis_Accesorios{
		int listaAccesorios = 1;
		int listaCombo		= 2;
	}
	
	public static interface Enum_Consulta {
		int principal = 1;
	}
	
	/**
	 * 
	 * @param tipoTransaccion: Da de alta los Accesorios de un Crédito
	 * @param otrosAccesoriosBean
	 * @param detalles
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, OtrosAccesoriosBean otrosAccesoriosBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Transaccion.altaAccesorios:
			mensaje = grabaDetalle(tipoTransaccion, otrosAccesoriosBean, detalles);
			break;
		
		}
		return mensaje;
	}
	
	/**
	 * 
	 * @param tipoTransaccion: Da de alta los Accesorios de un Crédito
	 * @param otrosAccesoriosBean
	 * @param detalles
	 * @return
	 */
	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, OtrosAccesoriosBean otrosAccesoriosBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			switch (tipoTransaccion) {
			case Enum_Lis_Accesorios.listaAccesorios:
				detalles = otrosAccesoriosBean.getDetalleAccesorios();
				break;

			}
			List<OtrosAccesoriosBean> listaDetalle = creaListaDetalle(detalles);
			mensaje=otrosAccesoriosDAO.grabaDetalle(otrosAccesoriosBean, listaDetalle);
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}

	/**
	 * 
	 * @param detalles
	 * @return
	 */
	private List<OtrosAccesoriosBean> creaListaDetalle(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<OtrosAccesoriosBean> listaDetalle = new ArrayList<OtrosAccesoriosBean>();
		OtrosAccesoriosBean detalle;
		try {
		while (tokensBean.hasMoreTokens()) {
			detalle = new OtrosAccesoriosBean();
			stringCampos = tokensBean.nextToken();
			
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalle.setAccesorioID(tokensCampos[0]);
			detalle.setDescripcion(tokensCampos[1]);
			detalle.setAbreviatura(tokensCampos[2]);
			detalle.setPrelacion(tokensCampos[3]);
			detalle.setAplicaCalCAT(tokensCampos[4]);

			listaDetalle.add(detalle);
		}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}

	/**
	 * 
	 * @param tipoLista: Lista los accesorios de un crédito
	 * @param otrosAccesoriosBean
	 * @return
	 */
	public List<OtrosAccesoriosBean> lista(int tipoLista, OtrosAccesoriosBean otrosAccesoriosBean){
		List<OtrosAccesoriosBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_Accesorios.listaAccesorios:
			lista = otrosAccesoriosDAO.lista(otrosAccesoriosBean, tipoLista);
			break;
		
		}
		return lista;
	}
	
	public  Object[] listaCombo(int tipoLista) {
		List listaConceptos = null;
		switch(tipoLista){			
		case Enum_Lis_CatMetodoPago.listaCombo: 			

			listaConceptos = otrosAccesoriosDAO.listaCombo(tipoLista);

			break;
			
			
		}
		return listaConceptos.toArray();		
	}	

	public OtrosAccesoriosDAO getOtrosAccesoriosDAO() {
		return otrosAccesoriosDAO;
	}

	public void setOtrosAccesoriosDAO(OtrosAccesoriosDAO otrosAccesoriosDAO) {
		this.otrosAccesoriosDAO = otrosAccesoriosDAO;
	}
	
}
