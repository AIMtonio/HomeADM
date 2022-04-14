package ventanilla.servicio;


import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import contabilidad.servicio.TipoInstrumentosServicio.Enum_Con_tipoInstrumentos;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.CatalogoGastosAntBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.bean.ReversasOperBean;
import ventanilla.bean.ReversasOperCajaBean;
import ventanilla.dao.CatalogoGastosAntDAO;
import ventanilla.dao.ReversasOperCajaDAO;
import ventanilla.servicio.CajasVentanillaServicio.Enum_Rep_Ventanilla;
import ventanilla.servicio.IngresosOperacionesServicio.Enum_Con_ReversaCajaMosv;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ReversasOperCajaServicio extends BaseServicio {
	ReversasOperCajaDAO reversasOperCajaDAO = null;
	
	public static interface Enum_Tra_Reversas {
		int alta = 1;
		int modificacion = 2;
	}
	public static interface Enum_Con_Reversas  {
		int principal = 1;

	}
	public static interface Enum_Lis_Reversas  {
		int principal	= 1;
;
	}
	
	public ReversasOperCajaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
			
	//Se cre el Reporte de Movimientos de Gastos y Anticipos 
	public ByteArrayOutputStream reporteReversasPDF(ReversasOperCajaBean reversasOperCajaBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio",reversasOperCajaBean.getFechaIni());
		parametrosReporte.agregaParametro("Par_FechaFin",reversasOperCajaBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_Sucursal",reversasOperCajaBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_CajaID",reversasOperCajaBean.getCajaID());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",reversasOperCajaBean.getNombreInstitucion());
		
		parametrosReporte.agregaParametro("Par_NombreSucursal",reversasOperCajaBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_NombreCaja",reversasOperCajaBean.getDescripcionCaja());
		parametrosReporte.agregaParametro("Par_ClaUsuario",reversasOperCajaBean.getUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",reversasOperCajaBean.getFecha());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	public List	listaReversas(ReversasOperCajaBean reversasOperCajaBean, HttpServletResponse response ){
		 List listaVentanilla=null;
				listaVentanilla = reversasOperCajaDAO.consultaReversas(reversasOperCajaBean); 
		return listaVentanilla;
	}
	
	
	public ReversasOperBean consulta(int tipoConsulta, ReversasOperBean reversasOperBean){
		ReversasOperBean reverOperBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Reversas.principal:	
				reverOperBean = reversasOperCajaDAO.consultaPrincipal(reversasOperBean, tipoConsulta);
			break;	
		}
		return reverOperBean;
	}



	public ReversasOperCajaDAO getReversasOperCajaDAO() {
		return reversasOperCajaDAO;
	}





	public void setReversasOperCajaDAO(ReversasOperCajaDAO reversasOperCajaDAO) {
		this.reversasOperCajaDAO = reversasOperCajaDAO;
	}
	
	
	
	
	//--------- getter y setter 	-------------

	
	

}
