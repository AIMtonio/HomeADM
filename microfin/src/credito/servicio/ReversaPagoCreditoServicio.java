package credito.servicio;


import java.io.ByteArrayOutputStream;
import java.util.List;
 
import reporte.ParametrosReporte;
import reporte.Reporte;


import credito.bean.IntegraGruposBean;
import credito.bean.ReversaPagoCreditoBean;
import credito.dao.ReversaPagoCreditoDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;

public class ReversaPagoCreditoServicio extends BaseServicio{
	
	ReversaPagoCreditoDAO reversaPagoCreditoDAO = null;
	IntegraGruposServicio integraGruposServicio = null;
	protected TransaccionDAO transaccionDAO = null;
	protected ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	
	
	public MensajeTransaccionBean grabaTransaccion(	ReversaPagoCreditoBean reversaPagoBean) {
		// TODO Auto-generated method stub
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensaje = null;
		IntegraGruposBean integraGrupo 	= new IntegraGruposBean();
		List listaIntegrantes = null;
		integraGrupo.setGrupoID(reversaPagoBean.getGrupoID());
		integraGrupo.setCiclo(reversaPagoBean.getCicloID());
		listaIntegrantes = integraGruposServicio.lista(IntegraGruposServicio.Enum_Lis_Grupos.integrantesRevDesembolso, integraGrupo);
		mensaje = reversaPagoCreditoDAO.reversaPagoCreditoProceso(reversaPagoBean, listaIntegrantes);
		return mensaje;
	}
	

			public ByteArrayOutputStream ticketReversaPagoCre(ReversaPagoCreditoBean reversaPagoCreditoBean, String nombreReporte ) throws Exception{
				
					ParametrosReporte parametrosReporte = new ParametrosReporte();
					
					parametrosReporte.agregaParametro("Par_NombreInstitucion",reversaPagoCreditoBean.getNombreInstitucion());
					parametrosReporte.agregaParametro("Par_Sucursal",reversaPagoCreditoBean.getSucursal());
					parametrosReporte.agregaParametro("Par_Fecha",reversaPagoCreditoBean.getFechaEmision());
					parametrosReporte.agregaParametro("Par_Folio",reversaPagoCreditoBean.getFolio());
					parametrosReporte.agregaParametro("Par_Usuario", reversaPagoCreditoBean.getUsuario());
					parametrosReporte.agregaParametro("Par_ClienteID",reversaPagoCreditoBean.getClienteID());
					parametrosReporte.agregaParametro("Par_CreditoID",reversaPagoCreditoBean.getCreditoID());
					parametrosReporte.agregaParametro("Par_Transaccion",reversaPagoCreditoBean.getTranRespaldo());
					parametrosReporte.agregaParametro("Par_FormaPago", reversaPagoCreditoBean.getFormaPago());
					parametrosReporte.agregaParametro("Par_PagoCredito",reversaPagoCreditoBean.getPagCre());
					parametrosReporte.agregaParametro("Par_GarantiaAdicional",reversaPagoCreditoBean.getGarantiaAd());
					parametrosReporte.agregaParametro("Par_TotalReversa", reversaPagoCreditoBean.getTotalRev());
					
					return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}
			

	// ----------------- SETTER Y GETTERS ----------------------------------------------------
	
	public ReversaPagoCreditoDAO getReversaPagoCreditoDAO() {
		return reversaPagoCreditoDAO;
	}

	public void setReversaPagoCreditoDAO(ReversaPagoCreditoDAO reversaPagoCreditoDAO) {
		this.reversaPagoCreditoDAO = reversaPagoCreditoDAO;
	}

	public IntegraGruposServicio getIntegraGruposServicio() {
		return integraGruposServicio;
	}

	public void setIntegraGruposServicio(IntegraGruposServicio integraGruposServicio) {
		this.integraGruposServicio = integraGruposServicio;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	
}
