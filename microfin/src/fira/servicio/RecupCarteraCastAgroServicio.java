package fira.servicio;

import fira.bean.RecupCarteraCastAgroBean;
import fira.dao.RecupCarteraCastAgroDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.ParametrosAplicacionDAO;
import general.servicio.BaseServicio;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.PropiedadesSAFIBean;
import soporte.dao.SucursalesDAO;
import credito.dao.CreditosDAO;
import cuentas.dao.CuentasAhoDAO;
import cuentas.dao.CuentasAhoMovDAO;
import cuentas.servicio.MonedasServicio;

public class RecupCarteraCastAgroServicio extends BaseServicio{
	
	RecupCarteraCastAgroDAO recupCarteraCastAgroDAO =null;
	CuentasAhoMovDAO cuentasAhoMovDAO = null;
	CreditosDAO creditosDAO = null;
	SucursalesDAO sucursalesDAO = null;
	ParametrosSesionBean parametrosSesionBean =null;
	RecupCarteraCastAgroServicio recupCarteraCastAgroServicio = null;
	ParametrosAplicacionDAO parametrosAplicacionDAO = null;
	MonedasServicio monedasServicio = null;
	CuentasAhoDAO cuentasAhoDAO = null;
	
	final boolean origenVent = true;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	protected final Logger loggerVent = Logger.getLogger("Vent");
	
	public static interface Enum_Tra_CreditoAgro {
		int recCarteraCastigada	 	= 1;	// Recuperacion de Cartera Castigada
	}
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Creditos {
		int conCreCastigos			= 43; 	// Consulta para Creditos Castigados 
	}
	public static interface Enum_Rep_Ventanilla {
		int recupCartCastigada		= 19;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,RecupCarteraCastAgroBean recupCarteraCastAgroBean) {
		MensajeTransaccionBean mensaje = null;
		try {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						
				switch (tipoTransaccion) {
					case Enum_Tra_CreditoAgro.recCarteraCastigada:
						mensajeBean = recupCarteraCastAgroDAO.recuperaCarteraCastigada(recupCarteraCastAgroBean);
						break;
					
				}// switch	
				
				mensaje = mensajeBean;

		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Grabar la Transaccion." + ex.getMessage());
			}
		return mensaje;
	}
	
	
	//-------------------------------------------------------------------------------------------------
	// -------------------- CONSULTAS -----------------------------------------------------------------
	//-------------------------------------------------------------------------------------------------	

	public RecupCarteraCastAgroBean consulta(int tipoConsulta, RecupCarteraCastAgroBean recupCarteraCastAgroBean) {
		RecupCarteraCastAgroBean creditos = null;
		switch (tipoConsulta) {
			case Enum_Con_Creditos.conCreCastigos :
				creditos = recupCarteraCastAgroDAO.conCreCastigos(recupCarteraCastAgroBean, tipoConsulta);
				
		}
		return creditos;
	}
	
	/**
	 * Método que genera los reportes/tickets de Ventanilla.
	 * @param tipoTransaccion : Numero de transaccion
	 * @param request : {@link HttpServletRequest} de pantalla
	 * @param nombreReporte : Nombre del reporte
	 * @return String
	 * @throws Exception
	 */
	public String reporteTicket(int tipoTransaccion,HttpServletRequest request, String nombreReporte) throws Exception{

		String htmlString ="";
		switch(tipoTransaccion){ 				
			case Enum_Rep_Ventanilla.recupCartCastigada: 
				htmlString= reporteRecupCarteraCastigada(request,nombreReporte);
				break;
		}
		return htmlString;
	}
	
	/**
	 * Ticket para Recuperacion de Cartera Castigada
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteRecupCarteraCastigada(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias")); 
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Numero", request.getParameter("numero"));
		parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("creditoID"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}		
	
	public String consultaProperties(){
		String properties   = PropiedadesSAFIBean.propiedadesSAFI.getProperty("MostrarBotones");
		properties += ","+PropiedadesSAFIBean.propiedadesSAFI.getProperty("TipoBusqueda");
		
		return properties;
	}

	public RecupCarteraCastAgroDAO getRecupCarteraCastAgroDAO() {
		return recupCarteraCastAgroDAO;
	}

	public void setRecupCarteraCastAgroDAO(
			RecupCarteraCastAgroDAO recupCarteraCastAgroDAO) {
		this.recupCarteraCastAgroDAO = recupCarteraCastAgroDAO;
	}

	public CuentasAhoMovDAO getCuentasAhoMovDAO() {
		return cuentasAhoMovDAO;
	}

	public void setCuentasAhoMovDAO(CuentasAhoMovDAO cuentasAhoMovDAO) {
		this.cuentasAhoMovDAO = cuentasAhoMovDAO;
	}

	public CreditosDAO getCreditosDAO() {
		return creditosDAO;
	}

	public void setCreditosDAO(CreditosDAO creditosDAO) {
		this.creditosDAO = creditosDAO;
	}

	public SucursalesDAO getSucursalesDAO() {
		return sucursalesDAO;
	}

	public void setSucursalesDAO(SucursalesDAO sucursalesDAO) {
		this.sucursalesDAO = sucursalesDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public RecupCarteraCastAgroServicio getRecupCarteraCastAgroServicio() {
		return recupCarteraCastAgroServicio;
	}

	public void setRecupCarteraCastAgroServicio(
			RecupCarteraCastAgroServicio recupCarteraCastAgroServicio) {
		this.recupCarteraCastAgroServicio = recupCarteraCastAgroServicio;
	}

	public ParametrosAplicacionDAO getParametrosAplicacionDAO() {
		return parametrosAplicacionDAO;
	}

	public void setParametrosAplicacionDAO(
			ParametrosAplicacionDAO parametrosAplicacionDAO) {
		this.parametrosAplicacionDAO = parametrosAplicacionDAO;
	}

	public CuentasAhoDAO getCuentasAhoDAO() {
		return cuentasAhoDAO;
	}

	public void setCuentasAhoDAO(CuentasAhoDAO cuentasAhoDAO) {
		this.cuentasAhoDAO = cuentasAhoDAO;
	}
	


}
