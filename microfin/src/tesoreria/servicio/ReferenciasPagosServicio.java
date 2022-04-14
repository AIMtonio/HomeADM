package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.ReferenciasPagosBean;
import tesoreria.dao.ReferenciasPagosDAO;

public class ReferenciasPagosServicio extends BaseServicio{
	
	ReferenciasPagosDAO referenciasPagosDAO;

	private ReferenciasPagosServicio(){
		super();
	}
	
	public static interface Enum_Transaccion {
		int alta = 1;
	}
	
	public static interface Enum_Lis_PaisesGAFI{
		int listaPrincipal = 1;
	}
	
	public static interface Enum_Consulta {
		int principal = 1;
		int foranea = 2;
		int referenciaCreditos = 3;
	}
	
	/**
	 * Método que graba la transacción.
	 * @param tipoTransaccion : 1.- Alta/Registro.
	 * @param referenciasBean : Clase bean que contiene los valores para dar de baja las referencias.
	 * @param detalles : Uso futuro.
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ReferenciasPagosBean referenciasBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Transaccion.alta:
			mensaje = grabaDetalle(referenciasBean, detalles);
			break;
		}
		return mensaje;
	}
	
	/**
	 * Graba la lista de las referencias de pagos por tipo de instrumento.
	 * @param referenciasBean : Clase bean que contiene los valores para dar de baja las referencias.
	 * @param detalles : Cadena con la lista de las referencias a pasear en la clase bean.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	private MensajeTransaccionBean grabaDetalle(ReferenciasPagosBean referenciasBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			detalles = referenciasBean.getDetalleReferencias();
			List<ReferenciasPagosBean> listaDetalle = creaListaDetalle(detalles);
			mensaje=referenciasPagosDAO.grabaDetalle(referenciasBean, listaDetalle);
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}

	/**
	 * Método para crear la lista de detalles.
	 * @param detalles : Cadena de la lista de las referencias separados por corchetes.
	 * @return List : Lista con los beans que contiene los datos de las referencias de pagos.
	 * @author avelasco
	 */
	private List<ReferenciasPagosBean> creaListaDetalle(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<ReferenciasPagosBean> listaDetalle = new ArrayList<ReferenciasPagosBean>();
		ReferenciasPagosBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new ReferenciasPagosBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setTipoCanalID(tokensCampos[0]);
				detalle.setInstrumentoID(tokensCampos[1]);
				detalle.setOrigen(tokensCampos[2]);
				detalle.setInstitucionID(tokensCampos[3]);
				detalle.setNombInstitucion(tokensCampos[4]);
				detalle.setReferencia(tokensCampos[5]);

				listaDetalle.add(detalle);
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}
	/**
	 * Método que lista las referencias de pago por tipo de instrumento y tipo de canal.
	 * @param tipoLista : Tipo de lista. 1.- Principal.
	 * @param referenciasBean : Clase bean para los valores de los parámetros de entrada al SP-REFPAGOSXINSTLIS.
	 * @return Lista de clases bean ReferenciasPagosBean, para enlistar las referencias de pago.
	 * @author avelasco
	 */
	public List<ReferenciasPagosBean> lista(int tipoLista, ReferenciasPagosBean referenciasBean){
		List<ReferenciasPagosBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_PaisesGAFI.listaPrincipal:
			lista = referenciasPagosDAO.lista(referenciasBean, tipoLista);
			break;
		}
		return lista;
	}
	
	public ReferenciasPagosBean consulta(ReferenciasPagosBean referenciasBean, int tipoConsulta){
		ReferenciasPagosBean refBean = null;
		switch (tipoConsulta) {
		case Enum_Consulta.foranea:
			refBean=referenciasPagosDAO.consultaForanea(referenciasBean, tipoConsulta);
			break;
			
		case Enum_Consulta.referenciaCreditos:
			refBean=referenciasPagosDAO.consultaReferenciasCredito(referenciasBean, tipoConsulta);
			break;
		}
		return refBean;
	}
	
	public ReferenciasPagosBean calculaAlgoritmoRefe(ReferenciasPagosBean refeBean){
		ReferenciasPagosBean referenciasPagosBean = null;
		referenciasPagosBean = referenciasPagosDAO.calculaAlgoritmoRefe(refeBean);
				
		return referenciasPagosBean;
	}


	// Creacion del reporte en PDf 
	public ByteArrayOutputStream repRefPagoInstPDF(ReferenciasPagosBean referenciasPagosBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_TipoCanal",(!referenciasPagosBean.getTipoCanalID().isEmpty() ? referenciasPagosBean.getTipoCanalID() : Constantes.STRING_VACIO));
		parametrosReporte.agregaParametro("Par_InstrumentoID", (!referenciasPagosBean.getInstrumentoID().isEmpty() ? referenciasPagosBean.getInstrumentoID() : Constantes.STRING_VACIO));
		parametrosReporte.agregaParametro("Par_ClienteID", (!referenciasPagosBean.getClienteID().isEmpty() ? referenciasPagosBean.getClienteID() : Constantes.STRING_VACIO));
		parametrosReporte.agregaParametro("Par_NombreCliente", (!referenciasPagosBean.getNombreCliente().isEmpty() ? referenciasPagosBean.getNombreCliente() : Constantes.STRING_VACIO));

		parametrosReporte.agregaParametro("Par_NombreInstitucion", referenciasPagosBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema", referenciasPagosBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_ClaveUsuario",referenciasPagosBean.getClaveUsuario());

		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ReferenciasPagosDAO getReferenciasPagosDAO() {
		return referenciasPagosDAO;
	}

	public void setReferenciasPagosDAO(ReferenciasPagosDAO referenciasPagosDAO) {
		this.referenciasPagosDAO = referenciasPagosDAO;
	}

}