package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import pld.bean.PaisesGAFIPLDBean;
import pld.dao.PaisesGAFIPLDDAO;
import soporte.servicio.CorreoServicio;

public class PaisesGAFIPLDServicio extends BaseServicio{
	
	PaisesGAFIPLDDAO paisesGAFIPLDDAO;
	CorreoServicio correoServicio;

	private PaisesGAFIPLDServicio(){
		super();
	}
	
	public static interface Enum_Transaccion {
		int altaPaisesMejora = 1;
		int altaPaisesNoCoop = 2;
	}
	
	public static interface Enum_Lis_PaisesGAFI{
		int listaPaisesMejora = 1;
		int listaPaisesNoCoop = 2;
	}
	
	public static interface Enum_Consulta {
		int principal = 1;
	}
	
	/**
	 * Método que graba la transacción.
	 * @param tipoTransaccion : Número del tipo de Grid. 1.- Paises no cooperantes 2.- Paises en mejora.
	 * @param paisesGAFIBean
	 * @param detalles
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PaisesGAFIPLDBean paisesGAFIBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Transaccion.altaPaisesMejora:
		case Enum_Transaccion.altaPaisesNoCoop:
			mensaje = grabaDetalle(tipoTransaccion, paisesGAFIBean, detalles);
			break;
		}
		return mensaje;
	}
	
	/**
	 * Graba la lista de los paises del catálogo GAFI.
	 * @param tipoTransaccion : Número de transacción, 1.- Paises en mejora, 2.- Paises no cooperantes.
	 * @param paisesGAFIBean : Clase bean que contiene los valores para dar de baja del catálogo y da de alta en el histórico.
	 * @param detalles : Cadena con la lista de los paises a pasear en la clase bean.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, PaisesGAFIPLDBean paisesGAFIBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			switch (tipoTransaccion) {
			case Enum_Lis_PaisesGAFI.listaPaisesMejora:
				detalles = paisesGAFIBean.getDetalleMejora();
				break;
			case Enum_Lis_PaisesGAFI.listaPaisesNoCoop:
				detalles = paisesGAFIBean.getDetalleNoCoop();
				break;
			}
			List<PaisesGAFIPLDBean> listaDetalle = creaListaDetalle(detalles);
			mensaje=paisesGAFIPLDDAO.grabaDetalle(paisesGAFIBean, listaDetalle);
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
	private List<PaisesGAFIPLDBean> creaListaDetalle(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<PaisesGAFIPLDBean> listaDetalle = new ArrayList<PaisesGAFIPLDBean>();
		PaisesGAFIPLDBean detalle;
		try {
		while (tokensBean.hasMoreTokens()) {
			detalle = new PaisesGAFIPLDBean();
			stringCampos = tokensBean.nextToken();
			
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalle.setPaisID(tokensCampos[0]);
			detalle.setNombre(tokensCampos[1]);
			detalle.setTipoPais(tokensCampos[2]);

			listaDetalle.add(detalle);
		}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}

	public List<PaisesGAFIPLDBean> lista(int tipoLista, PaisesGAFIPLDBean paisesGAFIBean){
		List<PaisesGAFIPLDBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_PaisesGAFI.listaPaisesMejora:
			lista = paisesGAFIPLDDAO.lista(paisesGAFIBean, tipoLista);
			break;
		case Enum_Lis_PaisesGAFI.listaPaisesNoCoop:
			lista = paisesGAFIPLDDAO.lista(paisesGAFIBean, tipoLista);
			break;
		}
		return lista;
	}
	
	public PaisesGAFIPLDBean consulta(PaisesGAFIPLDBean paisesGAFIBean, int tipoConsulta){
		PaisesGAFIPLDBean esquema = null;
		switch (tipoConsulta) {
		case Enum_Consulta.principal:
			esquema=null;
			break;
		}
		return esquema;
	}
	
	/**
	 * Método que realiza la consulta de los paises de la GAFI
	 * @param paisesGAFIBean: Bean que trae los datos del pais y del cliente,aval, prospecto, y relacionado
	 * @return: PaisesGAFIPLDBean
	 */
	public PaisesGAFIPLDBean consultaPaisesGAFI(PaisesGAFIPLDBean paisesGAFIBean) {
		try {
			PaisesGAFIPLDBean paisesGAFIPLDBean = paisesGAFIPLDDAO.consultaDeteccion(paisesGAFIBean);
			/* Si el Pais es detectado en los catalogos se envia el correo con la detección. */
			if(paisesGAFIPLDBean!=null && paisesGAFIPLDBean.getEstaEnCatalogo().equals(Constantes.STRING_SI)){
				correoServicio.EjecutaEnvioCorreo();
			}
			return paisesGAFIPLDBean;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	public PaisesGAFIPLDDAO getPaisesGAFIPLDDAO() {
		return paisesGAFIPLDDAO;
	}

	public void setPaisesGAFIPLDDAO(PaisesGAFIPLDDAO paisesGAFIPLDDAO) {
		this.paisesGAFIPLDDAO = paisesGAFIPLDDAO;
	}

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

}