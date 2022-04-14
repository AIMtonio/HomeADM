package aportaciones.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import aportaciones.bean.TasasISRExtBean;
import aportaciones.dao.TasasISRExtDAO;

public class TasasISRExtServicio extends BaseServicio{

	TasasISRExtDAO tasasISRExtDAO;

	private TasasISRExtServicio(){
		super();
	}

	public static interface Enum_Transaccion {
		int alta = 1;
	}

	public static interface Enum_Lis_PaisesGAFI{
		int listaGrid = 1;
	}

	public static interface Enum_Consulta {
		int principal = 1;
	}

	/**
	 * Método que graba la transacción.
	 * @param tipoTransaccion : Número del tipo de Grid. 1.- Paises no cooperantes 2.- Paises en mejora.
	 * @param tasasExtBean
	 * @param detalles
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TasasISRExtBean tasasExtBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Transaccion.alta:
			mensaje = grabaDetalle(tipoTransaccion, tasasExtBean, detalles);
			break;
		}
		return mensaje;
	}

	/**
	 * Graba la lista de los paises del catálogo GAFI.
	 * @param tipoTransaccion : Número de transacción, 1.- Paises en mejora, 2.- Paises no cooperantes.
	 * @param tasasExtBean : Clase bean que contiene los valores para dar de baja del catálogo y da de alta en el histórico.
	 * @param detalles : Cadena con la lista de los paises a pasear en la clase bean.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, TasasISRExtBean tasasExtBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			detalles = tasasExtBean.getDetalle();
			List<TasasISRExtBean> listaDetalle = creaListaDetalle(detalles);
			mensaje=tasasISRExtDAO.grabaDetalle(tasasExtBean, listaDetalle);
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}

	/**
	 * Método para crear la lista de detalles.
	 * @param detalles : Cadena de la lista de los paises separados por corchetes.
	 * @return List : Lista con los beans que contiene los datos de los paises.
	 * @author avelasco
	 */
	private List<TasasISRExtBean> creaListaDetalle(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<TasasISRExtBean> listaDetalle = new ArrayList<TasasISRExtBean>();
		TasasISRExtBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new TasasISRExtBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setPaisID(tokensCampos[0]);
				detalle.setTasaISR(tokensCampos[1]);

				listaDetalle.add(detalle);
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}

	public List<TasasISRExtBean> lista(int tipoLista, TasasISRExtBean tasasExtBean){
		List<TasasISRExtBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_PaisesGAFI.listaGrid:
			lista = tasasISRExtDAO.lista(tasasExtBean, tipoLista);
			break;
		}
		return lista;
	}

	public TasasISRExtDAO getTasasISRExtDAO() {
		return tasasISRExtDAO;
	}

	public void setTasasISRExtDAO(TasasISRExtDAO tasasISRExtDAO) {
		this.tasasISRExtDAO = tasasISRExtDAO;
	}

}