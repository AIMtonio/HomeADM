package tesoreria.servicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cuentas.bean.AnaliticoAhorroBean;
import cuentas.servicio.CuentasAhoServicio.Enum_Lis_CuenRep;
import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.ReqGastosSucBean;
import tesoreria.bean.TesoreriaMovsBean;
import tesoreria.bean.DepositosRefeBean;
import tesoreria.dao.CuentasPropiasDAO;
import tesoreria.dao.DepositosRefeDAO;
import tesoreria.dao.TesoMovimientosDAO;

 


public class TesoMovimientosServicio extends BaseServicio{

	
	TesoMovimientosDAO tesoMovimientosDAO;
	
	public static interface Enum_Tra_tesoMovs {
		int alta = 1;
		int modificacion = 2;
		int elimina =3;
 
	}
	public static interface Enum_Lis_CuenRep{
		int fondeoSucursal =1;       //reporte de  analitico ahorro
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,TesoreriaMovsBean tesoMovsBean,String institucionID, HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) { 
			case Enum_Tra_tesoMovs.alta:		
				mensaje = altaTesoMovtos(tesoMovsBean,institucionID, request);			
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaTesoMovtos( TesoreriaMovsBean tesoMovsBean,String institucionID, HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		
		ArrayList listaDetalleGrid = (ArrayList) DetalleGrid(tesoMovsBean); 
		ArrayList listaDetGridDepos = (ArrayList)DetalleGridDeposi(tesoMovsBean,institucionID);
		mensaje = tesoMovimientosDAO.altaMovimientos(listaDetalleGrid,listaDetGridDepos, request);
		       
		return mensaje;		
	}
	
	
   public List DetalleGrid(TesoreriaMovsBean tesoMovsBean){
	                             
	List<String> folioCarga = tesoMovsBean.getLfolioCargaID();
	
	    List<String> cuentaAho = tesoMovsBean.getLcuentaAhoID();
		List<String> fechaMov = tesoMovsBean.getLfechaMov();
		List<String> referencia = tesoMovsBean.getLreferenciaMov();
		List<String> descripcion = tesoMovsBean.getLdescripcionMov();
		List<String> monto = tesoMovsBean.getLmontoMov();
		List<String> montoPend = tesoMovsBean.getLmontoPendApli();
		List<String> tipoDep = tesoMovsBean.getLtipoDeposito();
		List<String> tipoCanal = tesoMovsBean.getLtipoCanal();
		List<String> refeConfirmar = tesoMovsBean.getLrerefenConfirmar();
		List<String> estatus = tesoMovsBean.getLestatus();
		
		ArrayList listaDetalle = new ArrayList();
		TesoreriaMovsBean tesoreriaMovsBean= null;
		
		int tamanio = cuentaAho.size();
		
		for(int i=0; i<tamanio; i++){
			tesoreriaMovsBean = new TesoreriaMovsBean();
			
			tesoreriaMovsBean.setCuentaAhoID(cuentaAho.get(i));
			tesoreriaMovsBean.setFechaMov(fechaMov.get(i));
			tesoreriaMovsBean.setReferenciaMov(referencia.get(i));
			tesoreriaMovsBean.setDescripcionMov(descripcion.get(i));
			tesoreriaMovsBean.setMontoMov(monto.get(i));
			tesoreriaMovsBean.setMontoPendiMov(montoPend.get(i));
			tesoreriaMovsBean.setTipoDep(tipoDep.get(i));
			tesoreriaMovsBean.setTipoCanal(tipoCanal.get(i));
			tesoreriaMovsBean.setReferenConfirm(refeConfirmar.get(i));
			tesoreriaMovsBean.setStatus(estatus.get(i));
			
			
			listaDetalle.add(tesoreriaMovsBean);
		}
		
		return listaDetalle;
	}
   public List DetalleGridDeposi(TesoreriaMovsBean tesoMovsBean, String institucionID){
            
	         
		      List<String> folioCarga = tesoMovsBean.getLfolioCargaID();
		      List<String> cuentaAho = tesoMovsBean.getLcuentaAhoID();
			  List<String> tipoCanal = tesoMovsBean.getLtipoCanal();
 			  List<String> estatus = tesoMovsBean.getLestatus();
 			  List<String> refereNoId = tesoMovsBean.getLrerefenConfirmar();
 			  List<String> descriNoId = tesoMovsBean.getLdescripcionMov();
 			  List<String> fechaMov = tesoMovsBean.getLfechaMov();
 			  List<String> referencia = tesoMovsBean.getLreferenciaMov();
 			  List<String> monto = tesoMovsBean.getLmontoMov();
 			  List<String> montoPend = tesoMovsBean.getLmontoPendApli();
 			  List<String> tipoDep = tesoMovsBean.getLtipoDeposito();
 			  List<String> refeConfirmar = tesoMovsBean.getLrerefenConfirmar();
              List<String> tipoMoneda = tesoMovsBean.getLtipoMoneda();
              List<String> natMov = tesoMovsBean.getLnatMovimiento();
 			 
			
			ArrayList listaDetalle = new ArrayList();
			DepositosRefeBean depRefeBean= null;
			
			int tamanio = folioCarga.size();
			
			for(int i=0; i<tamanio; i++){
				depRefeBean = new DepositosRefeBean();
				
				depRefeBean.setFolioCargaID(folioCarga.get(i));
				depRefeBean.setCuentaAhoID(cuentaAho.get(i));
				depRefeBean.setInstitucionID(institucionID);
				depRefeBean.setFechaOperacion(fechaMov.get(i));
				depRefeBean.setTipoCanal(tipoCanal.get(i));
				depRefeBean.setStatus(estatus.get(i));
				depRefeBean.setReferenNoIden(referencia.get(i));
				depRefeBean.setDescripNoIden(descriNoId.get(i));
				depRefeBean.setReferenciaMov(refereNoId.get(i));
				depRefeBean.setDescripcionMov(descriNoId.get(i));
				depRefeBean.setMontoMov(monto.get(i));
				depRefeBean.setMontoPendApli(montoPend.get(i));
				depRefeBean.setTipoCanal(tipoCanal.get(i));
				depRefeBean.setTipoDeposito(tipoDep.get(i));
				depRefeBean.setTipoMoneda(tipoMoneda.get(i));
				depRefeBean.setNatMovimiento(natMov.get(i));
				
		        listaDetalle.add(depRefeBean);
			}
			
			return listaDetalle;
		}
	   
   /*case para listas de reportes de credito*/
	public List listaReportesFondeo(int tipoLista, ReqGastosSucBean reqGastosSucBean){
		
		// List listaCreditos = null;
		 List listaFondeo = null;
		 System.out.println("Tipo Lista->"+ tipoLista);
	
		switch(tipoLista){
		
					
			case Enum_Lis_CuenRep.fondeoSucursal:
				listaFondeo = tesoMovimientosDAO.consultaRepProxFondeo(reqGastosSucBean, tipoLista);
				break;
		}
		return listaFondeo;
		
	}

	
	
	 // Reporte Fondeo Sucursales a PDF
	public ByteArrayOutputStream creaFondeoSucursalPDF(ReqGastosSucBean reqGastosSucBean, String nombreReporte) throws Exception{
	
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Fecha",reqGastosSucBean.getParFechaEmision());
		parametrosReporte.agregaParametro("Par_FechaEmision",reqGastosSucBean.getParFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!reqGastosSucBean.getNombreUsuario().isEmpty())?reqGastosSucBean.getNombreUsuario(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!reqGastosSucBean.getNombreInstitucion().isEmpty())?reqGastosSucBean.getNombreInstitucion(): "");

	return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

	}

	
	public void setTesoMovimientosDAO(TesoMovimientosDAO tesoMovimientosDAO) {
		this.tesoMovimientosDAO = tesoMovimientosDAO;
	}

	public TesoMovimientosDAO getTesoMovimientosDAO() {
		return tesoMovimientosDAO;
	}
}
