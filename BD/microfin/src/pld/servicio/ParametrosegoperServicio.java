package pld.servicio;


import java.io.ByteArrayOutputStream;
import java.util.List;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import pld.bean.ParametrosegoperBean;
import pld.bean.RepConocimientoCteBean;
import pld.bean.SeguimientoOperacionesRepBean;
import pld.dao.ParametrosegoperDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;
 
public class ParametrosegoperServicio extends BaseServicio{ 
	
	//---------- Variables ------------------------------------------------------------------------
	ParametrosegoperDAO parametrosegoperDAO = null;

	//---------- Tipos de transacciones---------------------------------------------------------------
	public static interface Enum_Tra_ParSegto {
		int alta   = 1;
		int modificacion =2;
	}
	public static interface Enum_Con_ParSegto {
		int principal   = 1;
		int foranea  = 2;
	}
	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_ParSegto {
		int principal   = 1;
	}

	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosegoperBean parametrosegoperBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_ParSegto.alta:
				mensaje = parametrosegoperDAO.alta(parametrosegoperBean, tipoTransaccion);
			break;
			case Enum_Tra_ParSegto.modificacion:
				mensaje = parametrosegoperDAO.modificacion(parametrosegoperBean,tipoTransaccion);
			break;
			
		}
		return mensaje;
	}
	
	public ParametrosegoperBean consulta(int tipoConsulta, ParametrosegoperBean parametrosegoperBean){
		ParametrosegoperBean parametrosegoper = null;
		switch(tipoConsulta){
			case Enum_Con_ParSegto.principal:
				parametrosegoper = parametrosegoperDAO.consultaPrincipal(parametrosegoperBean,tipoConsulta);
			break;
		}
		return parametrosegoper;
	}
	
	public List listaSegOp(int tipoLista, SeguimientoOperacionesRepBean parametrosegoperBean){		
		List listaRe = null;
		switch (tipoLista) {
			case Enum_Lis_ParSegto.principal:		
				listaRe=  parametrosegoperDAO.consultaOperacionesSeguimiento(parametrosegoperBean, tipoLista);				
				break;	
		}		
		return listaRe;
	}
	
	public ByteArrayOutputStream creaRepConocimientoClientePDF(RepConocimientoCteBean repConocimientoCteBean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_ClienteID",repConocimientoCteBean.getClienteID());
    	parametrosReporte.agregaParametro("Par_nombreClienteID",repConocimientoCteBean.getNombreCliente() );
        parametrosReporte.agregaParametro("Par_nombreInstitucion",(!repConocimientoCteBean.getNombreInstitucion().isEmpty())?repConocimientoCteBean.getNombreInstitucion(): "TODOS");
		parametrosReporte.agregaParametro("Par_nombreUsuario",(!repConocimientoCteBean.getNombreUsuario().isEmpty())?repConocimientoCteBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_FechaEmision",repConocimientoCteBean.getParFechaEmision());
		System.out.println(repConocimientoCteBean.getNombreCliente());
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//------------------ Geters y Seters --------------------------------------------


	public ParametrosegoperDAO getParametrosegoperDAO() {
		return parametrosegoperDAO;
	}


	public void setParametrosegoperDAO(ParametrosegoperDAO parametrosegoperDAO) {
		this.parametrosegoperDAO = parametrosegoperDAO;
	}



	}

