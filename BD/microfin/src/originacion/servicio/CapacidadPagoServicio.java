package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;
 
import originacion.bean.CapacidadPagoBean;
import originacion.dao.CapacidadPagoDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class CapacidadPagoServicio extends BaseServicio{
	/* Declaracion de Variables */
	CapacidadPagoDAO capacidadPagoDAO = null;
	
	public CapacidadPagoServicio() {
		super();
	}
	
	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Tra_CapacidadPago {
		int alta	 = 1;
	}
	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Lis_CapacidadPago {
		int productoCre = 1;
	}
	
	/*Enumera los tipo de consulta */
	public static interface Enum_Con_CapacidadPago {	
		int principal = 1 ;
		int estimacion = 2;
	}
		
	
	
	/* ========================== TRANSACCIONES ==============================  */

	/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CapacidadPagoBean capacidadPagoBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {		
			case Enum_Tra_CapacidadPago.alta:
				mensaje = capacidadPagoDAO.alta(capacidadPagoBean);					
				break;
		}
		return mensaje;
	}
	
	
	/* consulta los parametros de caja */
	public CapacidadPagoBean consulta(int tipoConsulta,CapacidadPagoBean bean){						
		CapacidadPagoBean capacidadPagoBean = null;
		switch (tipoConsulta) {
			case Enum_Con_CapacidadPago.principal:		
				capacidadPagoBean = capacidadPagoDAO.ultimaEstimacion(bean, tipoConsulta);				
				break;
			case Enum_Con_CapacidadPago.estimacion:		
				capacidadPagoBean = capacidadPagoDAO.calculaEstimacion(bean);				
				break;
		}
			
		return capacidadPagoBean;
	}

	
	
	/* controla el tipo de consulta*/
	public List lista(int tipoLista){		
		List productosCre = null;
		switch (tipoLista) {
			case Enum_Lis_CapacidadPago.productoCre:		
				productosCre = capacidadPagoDAO.productosCredito();				
				break;			
		}
			
		return productosCre;
	}

	
	
	
	/* =========  Reporte PDF de Estimacion Previa de Capacidad de Pago  =========== */
	public ByteArrayOutputStream reporteCapacidadPago(int tipoReporte, CapacidadPagoBean bean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaInicio",Utileria.convierteFecha(bean.getFechaInicio()) );
		parametrosReporte.agregaParametro("Par_FechaFin",Utileria.convierteFecha(bean.getFechaFin()) );
		parametrosReporte.agregaParametro("Par_ClienteID",bean.getClienteID() );
		parametrosReporte.agregaParametro("Par_SucursalID",bean.getSucursalID() );
		parametrosReporte.agregaParametro("Par_NombreCliente",bean.getNombreCliente() );
		parametrosReporte.agregaParametro("Par_NombreSucursal",bean.getNombreSucursal());
		
		parametrosReporte.agregaParametro("Par_NumRep",tipoReporte);
		
		parametrosReporte.agregaParametro("Par_NombreInstitucion", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema",Utileria.convierteFecha(bean.getFechaSistema()));
		parametrosReporte.agregaParametro("Par_Usuario",bean.getNombreUsuario());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	
	/* ===================== GETTER's Y SETTER's ======================= */
	public CapacidadPagoDAO getCapacidadPagoDAO() {
		return capacidadPagoDAO;
	}

	public void setCapacidadPagoDAO(CapacidadPagoDAO capacidadPagoDAO) {
		this.capacidadPagoDAO = capacidadPagoDAO;
	}

}
