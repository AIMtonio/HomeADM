package credito.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import credito.bean.AvaladosCreditoRepBean;
import credito.dao.AvaldosCreditoRepDAO;
import general.servicio.BaseServicio;

public class AvaladosCreditoRepServicio extends BaseServicio {

	AvaldosCreditoRepDAO avaldosCreditoRepDAO = null;
	String  todos ="-1"; // Todos los dias de Mora
	private String cadena_vacia =""; //cadena vacia
	private AvaladosCreditoRepServicio(){
		super();
	}


	public ByteArrayOutputStream reporteAvaladosCreditoPDF(
			AvaladosCreditoRepBean avaladosCreditoRepBean,
			String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		try{


			if(avaladosCreditoRepBean.getDiasMora().equalsIgnoreCase("TODOS")){
				avaladosCreditoRepBean.setDiasMora(todos);
			}
			
			if(avaladosCreditoRepBean.getNombreClienteInicial().equalsIgnoreCase("TODOS")){
				avaladosCreditoRepBean.setNombreClienteInicial(cadena_vacia);
			}
			if(avaladosCreditoRepBean.getNombreClienteFinal().equalsIgnoreCase("TODOS")){
				avaladosCreditoRepBean.setNombreClienteFinal(cadena_vacia);
			}
			if(avaladosCreditoRepBean.getNombrePromotor().equalsIgnoreCase("TODOS")){
				avaladosCreditoRepBean.setNombrePromotor(cadena_vacia);
			}
			
			if(!avaladosCreditoRepBean.getClienteInicial().equalsIgnoreCase("0")){
				if(avaladosCreditoRepBean.getClienteFinal().equalsIgnoreCase("0")){
						avaladosCreditoRepBean.setClienteFinal("-1");
				}
			}


			parametrosReporte.agregaParametro("Par_ClienteInicial",avaladosCreditoRepBean.getClienteInicial());
			parametrosReporte.agregaParametro("Par_ClienteFinal",avaladosCreditoRepBean.getClienteFinal());
			parametrosReporte.agregaParametro("Par_FechaInicial",avaladosCreditoRepBean.getFechaInicial());
			parametrosReporte.agregaParametro("Par_FechaFinal",avaladosCreditoRepBean.getFechaFinal());
			parametrosReporte.agregaParametro("Par_DiasMora",avaladosCreditoRepBean.getDiasMora());
			parametrosReporte.agregaParametro("Par_Promotor",avaladosCreditoRepBean.getPromotor());
			parametrosReporte.agregaParametro("Par_NombreInstitucion",avaladosCreditoRepBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_Usuario",avaladosCreditoRepBean.getNombreUsuario());
			parametrosReporte.agregaParametro("Par_FechaEmision",avaladosCreditoRepBean.getFechaSistema());
			parametrosReporte.agregaParametro("Par_NombreClienteIni",avaladosCreditoRepBean.getNombreClienteInicial());
			parametrosReporte.agregaParametro("Par_NombreClienteFinal",avaladosCreditoRepBean.getNombreClienteFinal());
			parametrosReporte.agregaParametro("Par_NombrePromotor",avaladosCreditoRepBean.getNombrePromotor());
			parametrosReporte.agregaParametro("Par_SucursalID",avaladosCreditoRepBean.getSucursalID());
			parametrosReporte.agregaParametro("Par_NombreSucursal",avaladosCreditoRepBean.getNombreSucursal());
			parametrosReporte.agregaParametro("Par_Estatus",avaladosCreditoRepBean.getEstatus());
			parametrosReporte.agregaParametro("Par_ProductoID",avaladosCreditoRepBean.getProducCreditoID());
			parametrosReporte.agregaParametro("Par_NombreProducto",avaladosCreditoRepBean.getNombreProducto());
			parametrosReporte.agregaParametro("Par_EtiquetaSocio",avaladosCreditoRepBean.getEtiquetaSocio());// safilocale.cliente
			

		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el reporte de Avalados", e);
		}
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public List ListaAvalesCredito(int tipoLista,
			AvaladosCreditoRepBean avaladosCreditoRepBean,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		List listaAvalesCredito =null;
		
		if(avaladosCreditoRepBean.getDiasMora().equalsIgnoreCase("TODOS")){
			avaladosCreditoRepBean.setDiasMora(todos);
		}
		
		listaAvalesCredito = avaldosCreditoRepDAO.consultaAvalesCreditoExcel(avaladosCreditoRepBean, tipoLista); 
		return listaAvalesCredito;
	}
	
	public AvaldosCreditoRepDAO getAvaldosCreditoRepDAO() {
		return avaldosCreditoRepDAO;
	}
	public void setAvaldosCreditoRepDAO(AvaldosCreditoRepDAO avaldosCreditoRepDAO) {
		this.avaldosCreditoRepDAO = avaldosCreditoRepDAO;
	}


	


}
