package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.EsquemaCargoDispBean;
import originacion.dao.EsquemaCargoDispDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class EsquemaCargoDispServicio extends BaseServicio{
	
	EsquemaCargoDispDAO esquemaCargoDispDAO = null;

	private EsquemaCargoDispServicio(){
		super();
	}
	
	public static interface Enum_Transaccion {
		int alta		= 1;
		int modifica	= 2;
		int baja		= 3;
	}
	
	public static interface Enum_Lis_EsquemaCargoDisp{
		int lista = 1;
	}
	
	public static interface Enum_Consulta {
		int principal = 1;
	}
	
	public static interface Enum_Reporte{
		int principal = 1;
	}
	
	/**
	 * Método que graba la transacción dependiendo del Tipo de Transacción.
	 * @param tipoTransaccion : Número del tipo de Transacción.
	 * @param esquemaCargoDispBean : Clase bean con los valores de entrada a los SPs.
	 * @param detalles : Cadena con los detalles del alta. Uso futuro.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EsquemaCargoDispBean esquemaCargoDispBean, String detalles) {
		// TODO Auto-generated method stub
		MensajeTransaccionBean mensaje = null;

		switch (tipoTransaccion) {
		case Enum_Transaccion.alta:
			mensaje = esquemaCargoDispDAO.alta(esquemaCargoDispBean);
			break;
		case Enum_Transaccion.baja:
			mensaje = esquemaCargoDispDAO.baja(esquemaCargoDispBean);
			break;
		}
		return mensaje;
	}
	
	/**
	 * Lista el esquema de cargos por dispersión de créditos que tiene parametrizado un producto de crédito.
	 * @param tipoLista : Número de lista.
	 * @param esquemaCargoDispBean : Clase bean con los parámetros de entrada al SP de lista.
	 * @return Lista del esquema parametrizado.
	 * @author avelasco
	 */
	public List<EsquemaCargoDispBean> lista(int tipoLista, EsquemaCargoDispBean esquemaCargoDispBean){
		List<EsquemaCargoDispBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_EsquemaCargoDisp.lista:
			lista = esquemaCargoDispDAO.lista(esquemaCargoDispBean,tipoLista);
			break;
		}
		return lista;
	}

	/**
	 * Lista del reporte de los cargos que se han realizado por disposición de crédito.
	 * @param esquemaCargoDispBean : Clase bean con los parámetros de entrada al SP de lista.
	 * @param tipoReporte : Número de reporte.
	 * @return Lista con el resultado del reporte.
	 * @author avelasco
	 */
	public List listaReporte(EsquemaCargoDispBean esquemaCargoDispBean, int tipoReporte){
		List lista= null;
		switch (tipoReporte) {
		case Enum_Reporte.principal:
			lista = esquemaCargoDispDAO.reporte(esquemaCargoDispBean, tipoReporte);	
		}			
		return lista;
	}
	
	public EsquemaCargoDispBean consulta(EsquemaCargoDispBean esquemaCargoDispBean, int tipoConsulta){
		EsquemaCargoDispBean esquema = null;
		switch (tipoConsulta) {
		case Enum_Consulta.principal:
			esquema=esquemaCargoDispDAO.consulta(esquemaCargoDispBean, tipoConsulta);
			break;
		}
		return esquema;
	}

	/* =========  Reporte PDF  de Historico de Operaciones de Riesgo Cte =========== */
	public ByteArrayOutputStream reportePDF(EsquemaCargoDispBean esquemaCargoDispBean , String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();		
		parametrosReporte.agregaParametro("Par_InstitucionID",esquemaCargoDispBean.getInstitucionID());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",esquemaCargoDispBean.getNombreInstitucion());// Titulo reporte
		parametrosReporte.agregaParametro("Par_NombInstitucion",esquemaCargoDispBean.getNombInstitucion());// filtro pantalla
		parametrosReporte.agregaParametro("Par_Usuario", esquemaCargoDispBean.getUsuario());
		parametrosReporte.agregaParametro("Par_FechaInicio",esquemaCargoDispBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFinal",esquemaCargoDispBean.getFechaFinal());
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public EsquemaCargoDispDAO getEsquemaCargoDispDAO() {
		return esquemaCargoDispDAO;
	}

	public void setEsquemaCargoDispDAO(EsquemaCargoDispDAO esquemaCargoDispDAO) {
		this.esquemaCargoDispDAO = esquemaCargoDispDAO;
	}

}