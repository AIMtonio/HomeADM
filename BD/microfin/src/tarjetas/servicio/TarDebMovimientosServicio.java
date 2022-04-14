package tarjetas.servicio;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import cliente.bean.ReportesFOCOOPBean;
import cliente.servicio.ReportesFOCOOPServicio.Enum_Reporte_FOCOOP;
import reporte.ParametrosReporte;
import reporte.Reporte;
import tarjetas.bean.TarDebMovimientosBean;
import tarjetas.dao.TarDebMovimientosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Archivos;
import herramientas.Constantes;
 
public class TarDebMovimientosServicio  extends BaseServicio{
	
	TarDebMovimientosDAO tarDebMovimientosDAO = null;
	
	public TarDebMovimientosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// Consulta de movimientos por tarjeta (Grid)
	public static interface Enum_Lis_MovimientosTarjetas{
		int tipoOperacion = 1;
		int operacionMovimiento = 2;	
	}
	
	public List lista(int tipoLista, TarDebMovimientosBean tarDebMovimientosBean){	
		List listaMovimientos = null;
		switch (tipoLista) {
		case Enum_Lis_MovimientosTarjetas.tipoOperacion:		
			listaMovimientos = tarDebMovimientosDAO.listaGridMovimientos(tipoLista, tarDebMovimientosBean);	
			break;		
		case Enum_Lis_MovimientosTarjetas.operacionMovimiento:		
			listaMovimientos = tarDebMovimientosDAO.listaGridMovimientos(tipoLista, tarDebMovimientosBean);	
		break;	
		}
		return listaMovimientos;
	}
    public MensajeTransaccionBean generaReporte( TarDebMovimientosBean tarDebMovimientosBean,
					HttpServletResponse response){
			MensajeTransaccionBean mensaje = null;
			mensaje = generaReporteMovsCta(tarDebMovimientosBean,response);
			return mensaje;
	}	

	
	// Reporte Movimientos Tarjetas
	public ByteArrayOutputStream creaReporteMovimientosTarDebPDF(TarDebMovimientosBean tarDebMovimientosBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_TarjetaDebID",tarDebMovimientosBean.getTarjetaDebID());
		parametrosReporte.agregaParametro("Par_TipoOperacion",tarDebMovimientosBean.getTipoOperacion());
		parametrosReporte.agregaParametro("Par_FechaInicio",tarDebMovimientosBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",tarDebMovimientosBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_TipoReporte",tarDebMovimientosBean.getNumeroReporte());
		parametrosReporte.agregaParametro("Par_FechaEmision",tarDebMovimientosBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!tarDebMovimientosBean.getNombreUsuario().isEmpty())?tarDebMovimientosBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!tarDebMovimientosBean.getNombreInstitucion().isEmpty())?tarDebMovimientosBean.getNombreInstitucion(): "Todos");
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	public ByteArrayOutputStream reporteMovsTarDeb(TarDebMovimientosBean tarDebMovimientosBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_TipoOperacion",tarDebMovimientosBean.getTipoOperacion());
		parametrosReporte.agregaParametro("Par_FechaInicio",tarDebMovimientosBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",tarDebMovimientosBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_TipoReporte",tarDebMovimientosBean.getNumeroReporte());
		parametrosReporte.agregaParametro("Par_FechaEmision",tarDebMovimientosBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!tarDebMovimientosBean.getNombreUsuario().isEmpty())?tarDebMovimientosBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!tarDebMovimientosBean.getNombreInstitucion().isEmpty())?tarDebMovimientosBean.getNombreInstitucion(): "Todos");
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	private MensajeTransaccionBean generaReporteMovsCta(TarDebMovimientosBean tarDebMovimientosBean,HttpServletResponse response){
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		Calendar calendario = new GregorianCalendar();
		String rutaArchivo = "",nombreArchivo="";
		mensaje.setNumero(Constantes.ENTERO_CERO);
		List listaFocopBeans = tarDebMovimientosDAO.movimientosPorCuenta(tarDebMovimientosBean);
		String[] nombresCamposBean = { "cuentaAho", "tarjetaDebID", "fecha", "descripcionMov","naturaleza","referenciaCta",
										"monto","codAutorizacion","fechaTrasaccion","horaTransaccion"
										};
		String[] titulosCamposCSV={
				"NumeroCuenta","NumeroTarjeta","Fecha","Descripcion","Tipo","Referencia",
				"Monto","CodAutorizacion","FechaTransaccion","HoraTransaccion"
				};
	    String nombreBean=TarDebMovimientosBean.class.getName();
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		nombreArchivo="ReporteMovimientosCta"+"-"+tarDebMovimientosBean.getFechaEmision()+"-"+hora+minutos+segundos+milisegundos;
		
		
		//Aleatorio para el nombre, y borrar el archivo despues de usarse
		try {
		  rutaArchivo = Archivos.EscribeArchivoTexto(listaFocopBeans, nombresCamposBean,titulosCamposCSV,nombreBean, "",nombreArchivo, "csv", "|",true);
		  Archivos.obtenerArchivo(rutaArchivo,response, Archivos.VerDocumentoTexo, Archivos.Str_NO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mensaje.setDescripcion(rutaArchivo);
		return mensaje;
	}
	
	//------------------setter y getter-----------

	public TarDebMovimientosDAO getTarDebMovimientosDAO() {
		return tarDebMovimientosDAO;
	}

	public void setTarDebMovimientosDAO(TarDebMovimientosDAO tarDebMovimientosDAO) {
		this.tarDebMovimientosDAO = tarDebMovimientosDAO;
	}
	
}
