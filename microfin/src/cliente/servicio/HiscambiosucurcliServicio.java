package cliente.servicio;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;

import originacion.bean.CapacidadPagoBean;
import reporte.ParametrosReporte;
import reporte.Reporte;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cliente.bean.ApoyoEscolarSolBean;
import cliente.bean.HiscambiosucurcliBean;
import cliente.dao.HiscambiosucurcliDAO;
import cliente.servicio.ApoyoEscolarSolServicio.Enum_Tra_ApoyoEscolarSol;


public class HiscambiosucurcliServicio extends BaseServicio{
	
	
	/* Declaracion de Variables */
	HiscambiosucurcliDAO hiscambiosucurcliDAO = null;


	public HiscambiosucurcliServicio() {
		super();
	}
	
	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Tra_CambioSucursal {
		int alta	 = 1;
	}


	/* ========================== TRANSACCIONES ==============================  */


	/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,  HiscambiosucurcliBean bean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {		
			case Enum_Tra_ApoyoEscolarSol.alta:
				mensaje = hiscambiosucurcliDAO.alta(bean);					
				break;
		}
		return mensaje;
	}
	
	
	/* =========  Reporte PDF de Historial de Cambios de Sucursal al cliente  =========== */
	public ByteArrayOutputStream reporteCambiosSucursal(int tipoReporte, HiscambiosucurcliBean bean , String nomReporte) throws Exception{	
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_ClienteInicio",bean.getClienteInicio() );
		parametrosReporte.agregaParametro("Par_ClienteFin",bean.getClienteFin());		
		parametrosReporte.agregaParametro("Par_NumReporte",tipoReporte);
		parametrosReporte.agregaParametro("Par_FechaInicial",bean.getFechaInicial());
		parametrosReporte.agregaParametro("Par_FechaFinal",bean.getFechaFinal());
		
		parametrosReporte.agregaParametro("Par_NombreInstitucion", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema",Utileria.convierteFecha(bean.getFechaSistema()));
		parametrosReporte.agregaParametro("Par_Usuario",bean.getNombreUsuario());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	
	/* ========= FORMATO REPORTE POR CAMBIO DE SUCURSAL  =========== */
	public ByteArrayOutputStream cambioSucFormato(HiscambiosucurcliBean bean ,HttpServletRequest request, String nomReporte) throws Exception{	
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_ClienteID",bean.getClienteID());
		parametrosReporte.agregaParametro("Par_NombreCliente",request.getParameter("clienteIDDes")); 
		parametrosReporte.agregaParametro("Par_NombreInstitucion", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_DomicilioInst", request.getParameter("domicilioInst")); 
		parametrosReporte.agregaParametro("Par_RFCInst", request.getParameter("rfcInst")); 
		parametrosReporte.agregaParametro("Par_NomSucOrigen",request.getParameter("sucursalOrigenDes")); 
		parametrosReporte.agregaParametro("Par_NomSucDestino",request.getParameter("sucursalDestinoDes")); 
		parametrosReporte.agregaParametro("Par_NombreSucLogeado",bean.getSucursal());	
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}


	public HiscambiosucurcliDAO getHiscambiosucurcliDAO() {
		return hiscambiosucurcliDAO;
	}

	public void setHiscambiosucurcliDAO(HiscambiosucurcliDAO hiscambiosucurcliDAO) {
		this.hiscambiosucurcliDAO = hiscambiosucurcliDAO;
	}	

}
