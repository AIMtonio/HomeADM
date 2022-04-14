package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;

import credito.bean.CarCreditoSuspendidoBean;
import credito.bean.CreditosBean;
import credito.dao.CarCreditoSuspendidoDAO;


public class CarCreditoSuspendidoServicio extends BaseServicio {
	CarCreditoSuspendidoDAO carCreditoSuspendidoDAO = null;
	
	private CarCreditoSuspendidoServicio(){
		super();
	}
		
	public static interface Enum_Con_CreditoSusp{
		int ConPrincipal = 1;
	}
	
	public static interface Enum_Tra_CreditoSup{
		int ProcesoSuspencionCred = 1;
		int ProcesoReversaSuspensionCred = 2;
	}
		
	public static interface Enum_Lis_CreditoSup{
		int listaPrincipal = 1;
	}
	
	public static interface Enum_Reporte_CredSusp{
		int creditoSuspExcel = 2;
	}
	/* =====================================================================  */
	/* =====================================================================  */
	public List<CarCreditoSuspendidoBean> consultaReporteCreditoSusp(int tipoLista, CarCreditoSuspendidoBean carCreditoSuspendidoBean, HttpServletResponse response){
		List<CarCreditoSuspendidoBean> listaCreditoSusp = null;
		switch(tipoLista){
			case Enum_Reporte_CredSusp.creditoSuspExcel:
				listaCreditoSusp = carCreditoSuspendidoDAO.consultaReporteCreditoSusp(carCreditoSuspendidoBean, tipoLista);
			break;
		}
		return listaCreditoSusp;
	}
	/* =====================================================================  */
	/* =====================================================================  */
	public CarCreditoSuspendidoBean consulta(int tipoConsulta, CarCreditoSuspendidoBean carCreditoSuspendidoBean){
		CarCreditoSuspendidoBean consultaRetornada = null;
		switch(tipoConsulta){
			case Enum_Con_CreditoSusp.ConPrincipal:
				consultaRetornada = carCreditoSuspendidoDAO.consultaCreditoSuspendido(carCreditoSuspendidoBean, tipoConsulta);
			break;
		}
		return consultaRetornada;
	}
	
	/* =====================================================================  */
	/* =====================================================================  */

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion,CarCreditoSuspendidoBean carCreditoSuspendidoBean) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case (Enum_Tra_CreditoSup.ProcesoSuspencionCred):	
				mensaje = carCreditoSuspendidoDAO.altaCreditoSuspendido(carCreditoSuspendidoBean);
				break;
			case (Enum_Tra_CreditoSup.ProcesoReversaSuspensionCred):
				mensaje = carCreditoSuspendidoDAO.reversaCreditoSuspendido(carCreditoSuspendidoBean);
				break;
		}
		return mensaje;
	}	
	
	/* =====================================================================  */
	/* =====================================================================  */
	public List lista(int tipoLista, CarCreditoSuspendidoBean carCreditoSuspendidoBean){
		List listaResult = null;
		switch (tipoLista) {
        case  Enum_Lis_CreditoSup.listaPrincipal:
        	listaResult = carCreditoSuspendidoDAO.listReverCredSuspension(carCreditoSuspendidoBean,tipoLista);
        	break;    
		}
		return listaResult;
	}
	
	public ByteArrayOutputStream reporteCarCreditoSuspPDF(CarCreditoSuspendidoBean carCreditoSuspendidoBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio",carCreditoSuspendidoBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",carCreditoSuspendidoBean.getFechaFinal());
		parametrosReporte.agregaParametro("Par_SucursalID",carCreditoSuspendidoBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_ProductoCreditoID",carCreditoSuspendidoBean.getProductoCreditoID());
		parametrosReporte.agregaParametro("Par_NombreUsuario", carCreditoSuspendidoBean.getUsuario());
		
		if(Utileria.convierteEntero(carCreditoSuspendidoBean.getSucursalID()) == 0){
			parametrosReporte.agregaParametro("Par_NombreSucursal","TODOS");
		}else
			parametrosReporte.agregaParametro("Par_NombreSucursal", carCreditoSuspendidoBean.getNombreSucursal());
		if(Utileria.convierteEntero(carCreditoSuspendidoBean.getProductoCreditoID()) == 0)
			parametrosReporte.agregaParametro("Par_NombreProducto", "TODOS");
		else
			parametrosReporte.agregaParametro("Par_NombreProducto", carCreditoSuspendidoBean.getNombreProducto());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public CarCreditoSuspendidoDAO getCarCreditoSuspendidoDAO() {
		return carCreditoSuspendidoDAO;
	}

	public void setCarCreditoSuspendidoDAO(
			CarCreditoSuspendidoDAO carCreditoSuspendidoDAO) {
		this.carCreditoSuspendidoDAO = carCreditoSuspendidoDAO;
	}
	
}
