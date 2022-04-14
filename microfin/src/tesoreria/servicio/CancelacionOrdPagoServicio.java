package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import contabilidad.servicio.CatMetodosPagoServicio.Enum_Lis_CatMetodoPago;

import tesoreria.bean.CancelacionOrdPagoBean;
import tesoreria.dao.CancelacionOrdPagoDAO;

public class CancelacionOrdPagoServicio extends BaseServicio{
	
	CancelacionOrdPagoDAO cancelacionOrdPagoDAO;

	private CancelacionOrdPagoServicio(){
		super();
	}
	
	public static interface Enum_Transaccion {
		int procesaOrdenPag = 1;
	}
	
	public static interface Enum_Lis_Accesorios{
		int listaOrdPago = 1;
		int listaCombo		= 2;
	}
	
	public static interface Enum_Consulta {
		int principal = 1;
	}
	
	/**
	 * 
	 * @param tipoTransaccion: Cancelacion de Orden de Pago
	 * @param otrosAccesoriosBean
	 * @param detalles
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CancelacionOrdPagoBean cancelacionOrdPagoBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Transaccion.procesaOrdenPag:

			mensaje = grabaDetalle(tipoTransaccion, cancelacionOrdPagoBean, detalles);
			break;
		
		}
		return mensaje;
	}
	
	/**
	 * 
	 * @param tipoTransaccion: Procesa Cancelacion de Orden de Pago
	 * @param cancelacionOrdPagoBean
	 * @param detalles
	 * @return
	 */
	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, CancelacionOrdPagoBean cancelacionOrdPagoBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			switch (tipoTransaccion) {
			case Enum_Lis_Accesorios.listaOrdPago:
				detalles = cancelacionOrdPagoBean.getDetalleAccesorios();
				break;

			}

			List<CancelacionOrdPagoBean> listaDetalle = listadetalles(cancelacionOrdPagoBean);

			mensaje=cancelacionOrdPagoDAO.grabaDetalle(cancelacionOrdPagoBean, listaDetalle);
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
	private List<CancelacionOrdPagoBean> creaListaDetalle(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<CancelacionOrdPagoBean> listaDetalle = new ArrayList<CancelacionOrdPagoBean>();
		CancelacionOrdPagoBean detalle;
		try {
		while (tokensBean.hasMoreTokens()) {
			detalle = new CancelacionOrdPagoBean();
			stringCampos = tokensBean.nextToken();
			
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalle.setFolioDispersion(tokensCampos[0]);
			detalle.setClaveDisMov(tokensCampos[1]);

			listaDetalle.add(detalle);
		}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}
	
	
	public List<CancelacionOrdPagoBean> listadetalles(CancelacionOrdPagoBean cancelacionOrdPagoBean){
		List<CancelacionOrdPagoBean> listaDetalle = new ArrayList<CancelacionOrdPagoBean>();
		List<String> listaFolioDispersion = cancelacionOrdPagoBean.getLisFolioDispersion();
		List<String> listaClaveDisMov = cancelacionOrdPagoBean.getLisClaveDisMov();
		try{
		for(int i=0;i<listaFolioDispersion.size(); i++){
			CancelacionOrdPagoBean canOrdPagoBean = new CancelacionOrdPagoBean();
			
			canOrdPagoBean.setClaveDisMov(listaClaveDisMov.get(i));
			canOrdPagoBean.setFolioDispersion(listaFolioDispersion.get(i));
			listaDetalle.add(canOrdPagoBean);
		}
		}catch(Exception ex){
			ex.printStackTrace();
		}

		return listaDetalle;
		
	}

	/**
	 * 
	 * @param tipoLista: Lista los accesorios de un crédito
	 * @param otrosAccesoriosBean
	 * @return
	 */
	public List<CancelacionOrdPagoBean> lista(int tipoLista, CancelacionOrdPagoBean cancelacionOrdPagoBean){
		List<CancelacionOrdPagoBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_Accesorios.listaOrdPago:
			lista = cancelacionOrdPagoDAO.lista(cancelacionOrdPagoBean, tipoLista);
			break;
		
		}
		return lista;
	}

	public CancelacionOrdPagoDAO getCancelacionOrdPagoDAO() {
		return cancelacionOrdPagoDAO;
	}

	public void setCancelacionOrdPagoDAO(CancelacionOrdPagoDAO cancelacionOrdPagoDAO) {
		this.cancelacionOrdPagoDAO = cancelacionOrdPagoDAO;
	}
	

	
}
