package tarjetas.servicio;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tarjetas.bean.TarDebAclaraBean;
import tarjetas.bean.TipoTarjetaDebBean;
import tarjetas.dao.TarDebAclaraDAO;

 

public class TarDebAclaraServicio extends BaseServicio {
	
	TarDebAclaraDAO tarDebAclaraDAO = null;

	public TarDebAclaraServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Tra_aclaracion {
		int altaAclaracion 	= 1;
		int actualizacion 	= 2;
		int actualizaResulta    =3;
	}
	
	public static interface Enum_Con_aclaracion{
		int principal	= 1;
		int foranea		= 2;
		int parametros	= 3;
        int resultado   = 4;
        int conCredito	= 5;
        int resultCre	= 6;
	}
	public static interface Enum_lis_aclaracion{
		int principal	= 1;
		int transCred	= 2;
		int transaccion	= 3;
		int resultado	= 4;
		int puesto      = 5;
		int resultCre	= 6;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,TarDebAclaraBean tarDebAclaraBean,
					String lisFolioID, String lisTipoArchivo,String lisRuta, String lisNombreArchivo ){		
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_aclaracion.altaAclaracion:
			mensaje = tarDebAclaraDAO.altaAclaracion(tipoTransaccion,tarDebAclaraBean);			
			break;
		case Enum_Tra_aclaracion.actualizacion:
			mensaje = tarDebAclaraDAO.actualizacion(tarDebAclaraBean, lisFolioID, lisTipoArchivo, lisRuta, lisNombreArchivo);
			break;
		case Enum_Tra_aclaracion.actualizaResulta:
			mensaje = tarDebAclaraDAO.actualizaResultaAclaracion(tarDebAclaraBean);
			break;
		}
		return mensaje;
	}
		
	public TarDebAclaraBean consulta(int tipoConsulta, TarDebAclaraBean tarDebAclaraBean){
		TarDebAclaraBean consultaAclara = null;
		switch(tipoConsulta){
			case Enum_Con_aclaracion.principal:
				consultaAclara = tarDebAclaraDAO.consulta(Enum_Con_aclaracion.principal, tarDebAclaraBean);
			break;
			case Enum_Con_aclaracion.parametros:
				consultaAclara = tarDebAclaraDAO.consultaParametros(tipoConsulta, tarDebAclaraBean);
			break;
			case Enum_Con_aclaracion.resultado:
				consultaAclara = tarDebAclaraDAO.resultado(tipoConsulta, tarDebAclaraBean);
			break;
			case Enum_Con_aclaracion.conCredito:
				consultaAclara = tarDebAclaraDAO.consultaCredito(tipoConsulta, tarDebAclaraBean);
			break;
			case Enum_Con_aclaracion.resultCre:
				consultaAclara = tarDebAclaraDAO.resultadoCre(tipoConsulta, tarDebAclaraBean);
			break;
		}
		return consultaAclara;
	}
	
	public List lista(int tipoLista, TarDebAclaraBean tarDebAclaraBean){
		List listaAclara = null;
		switch (tipoLista) {
			case Enum_lis_aclaracion.principal:		
				listaAclara = tarDebAclaraDAO.listaAclara(tarDebAclaraBean, tipoLista);	
			break;
			case Enum_lis_aclaracion.transCred:		
				listaAclara = tarDebAclaraDAO.listaAclaraCred(tarDebAclaraBean, tipoLista);	
			break;
			case Enum_lis_aclaracion.transaccion:		
				listaAclara = tarDebAclaraDAO.listaTransaccion(tarDebAclaraBean, tipoLista);	
			break;
			case Enum_lis_aclaracion.resultado:		
				listaAclara = tarDebAclaraDAO.listaResultadoAclara(tarDebAclaraBean, tipoLista);	
			break;
			case Enum_lis_aclaracion.resultCre:
				listaAclara = tarDebAclaraDAO.listaResultCreAclara(tarDebAclaraBean, tipoLista);
			break;
		}			
		return listaAclara;
	}
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista,TarDebAclaraBean tarDebAclaraBean) {				
		List listaPuesto = null;
		switch(tipoLista){
			case (Enum_lis_aclaracion.puesto): 
				listaPuesto = tarDebAclaraDAO.listaPuesto(tarDebAclaraBean, tipoLista);	
			break;
		}		
		return listaPuesto.toArray();
	}
	public ByteArrayOutputStream creaReporteResultAclaraPDF( TarDebAclaraBean tarDebAclaraBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		

	    parametrosReporte.agregaParametro("Par_TarjetaDebID",tarDebAclaraBean.getTarjetaDebID());
	  	parametrosReporte.agregaParametro("Par_ReporteID",tarDebAclaraBean.getReporteID());
		parametrosReporte.agregaParametro("Par_FechaEmision",tarDebAclaraBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_UsuarioID",(!tarDebAclaraBean.getUsuarioID().isEmpty())?tarDebAclaraBean.getUsuarioID(): "Todos");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!tarDebAclaraBean.getNombreUsuario().isEmpty())?tarDebAclaraBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!tarDebAclaraBean.getNombreInstitucion().isEmpty())?tarDebAclaraBean.getNombreInstitucion(): "Todos");
		
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ByteArrayOutputStream creaReporteSolicitudAclaracionPDF(TarDebAclaraBean tarDebAclaraBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		 parametrosReporte.agregaParametro("Par_TarjetaDebID",tarDebAclaraBean.getTarjetaDebID());
	    parametrosReporte.agregaParametro("Par_ReporteID",tarDebAclaraBean.getReporteID());
		parametrosReporte.agregaParametro("Par_FechaSistema",tarDebAclaraBean.getFechaEmision());
			
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ByteArrayOutputStream creaReporteResolucionAclaracionPDF(TarDebAclaraBean tarDebAclaraBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_TarjetaDebID",tarDebAclaraBean.getTarjetaDebID());
	    parametrosReporte.agregaParametro("Par_ReporteID",tarDebAclaraBean.getReporteID());
		parametrosReporte.agregaParametro("Par_FechaSistema",tarDebAclaraBean.getFechaEmision());
			
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	//------------------setter y getter-----------
	public TarDebAclaraDAO getTarDebAclaraDAO() {
		return tarDebAclaraDAO;
	}
	public void setTarDebAclaraDAO(TarDebAclaraDAO tarDebAclaraDAO) {
		this.tarDebAclaraDAO = tarDebAclaraDAO;
	}	
									
	
}
