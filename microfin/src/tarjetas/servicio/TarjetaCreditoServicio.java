package tarjetas.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;
import org.springframework.core.task.TaskExecutor;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.servicio.ParamGeneralesServicio;
import tarjetas.bean.TarjetaCreditoBean;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.dao.TarjetaCreditoDAO;


public class TarjetaCreditoServicio extends BaseServicio {
	ParamGeneralesServicio paramGeneralesServicio = null;
	TarjetaCreditoDAO tarjetaCreditoDAO = null;
	public TaskExecutor taskExecutor;

	
	public TarjetaCreditoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Tra_tarjetaCredito {
		int altaBloqueo		= 1;
		int altaDesBloqueo	= 2;
		int altaCancelacion	= 3;
		int	activaTarjeta	= 4;
		int altaLineaCred	= 5;
		int cuentaClabe		= 6;  // Modificar la cuenta clabe en caso que no se haya dado de alta al asociar la linea


	}
	public static interface Enum_Act_tarjetaCredito {
		int asociaCuentasTarjetaC 		= 1;
	
	}
	public static interface Enum_Con_tarjetaCredito{			
		int principal		              	= 1;
		int consultaTarDeb              	= 2;
		int tarDebEstAsigna					= 3;
		int consultaTarDebCancel            = 4;
		int consultaTarCredBitacoraDesBloq	= 5; // 5
		int consultaTarExistentes			= 6; // 15
		int consultaMovTarjetas				= 7; // 16
		int tarjetaCta						= 8;
		int asociaTarjeta					= 9;
		int TarjetaComision					= 10;
		int TarjetaAsignacion				= 11;

	}

	public static interface Enum_lis_tarjetaCredito{
		int tarjetaCreditoBLoq			 = 1;
		int tarjetaCreditoDesbloq		 = 2;
		int tarAsignaLis				 = 3; 
		int tarjetaCreditoCancel		 = 4;
		int tarjetaCred					 = 5;
		int GirosTarCredInd              =11;
		int listaTarjExist				 =12;
		int listaMovimientos             =13;
		int tarjetaLis		             =14;
		int TarCredListaCta		         =15;
	}

	

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, TarjetaDebitoBean  tarjetaDebitoBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_tarjetaCredito.altaBloqueo:
			mensaje = tarjetaCreditoDAO.bloqueoTarjeta(tipoTransaccion, tarjetaDebitoBean);
			break;
		case Enum_Tra_tarjetaCredito.altaDesBloqueo:
			mensaje = tarjetaCreditoDAO.desbloqueoTarjeta(tipoTransaccion, tarjetaDebitoBean);
			break;	
		case Enum_Tra_tarjetaCredito.altaCancelacion:
			mensaje = tarjetaCreditoDAO.cancelacionTarjetaDebito(tipoTransaccion, tarjetaDebitoBean);
			break;
		case Enum_Tra_tarjetaCredito.activaTarjeta:
			mensaje = tarjetaCreditoDAO.activa(tipoTransaccion,tarjetaDebitoBean);
			break;
		case Enum_Tra_tarjetaCredito.altaLineaCred:
			mensaje = tarjetaCreditoDAO.altaLineaCred(tipoTransaccion,tarjetaDebitoBean);
			break;
		case Enum_Tra_tarjetaCredito.cuentaClabe:
			mensaje = tarjetaCreditoDAO.altaCuentaClabe(tipoTransaccion,tarjetaDebitoBean);
			break;
			
		}
		return mensaje;
	}
	

	
	///LISTAS
	public List lista(int tipoLista, TarjetaCreditoBean tarjetaCreditoBean){	
		List listaTarjetaCredito = null;
	switch (tipoLista) {
		case Enum_lis_tarjetaCredito.tarjetaCreditoBLoq:
			listaTarjetaCredito = tarjetaCreditoDAO.TarjetaCredito(tipoLista,tarjetaCreditoBean);
			break;
		case Enum_lis_tarjetaCredito.tarjetaCreditoDesbloq:		
			listaTarjetaCredito = tarjetaCreditoDAO.TarjetaCredito(tipoLista,tarjetaCreditoBean);
			break;
		case Enum_lis_tarjetaCredito.tarAsignaLis:
			listaTarjetaCredito = tarjetaCreditoDAO.listTarEstatus(tarjetaCreditoBean, tipoLista);
			break;
		case Enum_lis_tarjetaCredito.tarjetaCreditoCancel:
			listaTarjetaCredito = tarjetaCreditoDAO.TarjetaCredito(tipoLista, tarjetaCreditoBean);
			break;
		case Enum_lis_tarjetaCredito.GirosTarCredInd:
			listaTarjetaCredito = tarjetaCreditoDAO.TarjetaCredito(tipoLista, tarjetaCreditoBean);
			break;
		case Enum_lis_tarjetaCredito.listaTarjExist:
			listaTarjetaCredito = tarjetaCreditoDAO.TarjetaCredito(tipoLista,tarjetaCreditoBean);
			break;
		case Enum_lis_tarjetaCredito.listaMovimientos:
			listaTarjetaCredito = tarjetaCreditoDAO.TarjetaCredito(tipoLista,tarjetaCreditoBean);
			break;
		case Enum_lis_tarjetaCredito.tarjetaCred:		
			listaTarjetaCredito = tarjetaCreditoDAO.listaTarjetasDeb(tarjetaCreditoBean, tipoLista);				
			break;
		case Enum_lis_tarjetaCredito.tarjetaLis:		
			listaTarjetaCredito = tarjetaCreditoDAO.TarjetaCredito(tipoLista, tarjetaCreditoBean );				
			break;
		case Enum_lis_tarjetaCredito.TarCredListaCta:		
			listaTarjetaCredito = tarjetaCreditoDAO.TarCredListaCta(tipoLista, tarjetaCreditoBean );				
			break;
			
			
			
			
	}
	return listaTarjetaCredito;		
}

	
	// CONSUTAS
	public TarjetaCreditoBean consulta(int tipoConsulta, TarjetaCreditoBean tarjetaCreditoBean){
		TarjetaCreditoBean tarjetaCredito = null;
		
		switch(tipoConsulta){
			case Enum_Con_tarjetaCredito.principal:
				tarjetaCredito = tarjetaCreditoDAO.principal(tipoConsulta, tarjetaCreditoBean);
			break;
			case Enum_Con_tarjetaCredito.consultaTarDeb:
				tarjetaCredito = tarjetaCreditoDAO.consultaTarjetaDeb(tipoConsulta, tarjetaCreditoBean);
			break;
			case Enum_Con_tarjetaCredito.tarDebEstAsigna:
				tarjetaCredito = tarjetaCreditoDAO.consultaTarDebAsigna(Enum_Con_tarjetaCredito.tarDebEstAsigna, tarjetaCreditoBean);
			break;
			case Enum_Con_tarjetaCredito.consultaTarDebCancel:
				tarjetaCredito = tarjetaCreditoDAO.consultaTarjetaCancel(tipoConsulta, tarjetaCreditoBean);
			break;
			case Enum_Con_tarjetaCredito.consultaTarCredBitacoraDesBloq:
				tarjetaCredito = tarjetaCreditoDAO.consultaTarCredBitacoraDesBloq(tipoConsulta, tarjetaCreditoBean);
			break;
			case Enum_Con_tarjetaCredito.consultaTarExistentes:
				tarjetaCredito = tarjetaCreditoDAO.consultaTarExistentes(tipoConsulta, tarjetaCreditoBean);
			break;
			case Enum_Con_tarjetaCredito.consultaMovTarjetas:
				tarjetaCredito = tarjetaCreditoDAO.consultaMovTarjetas(tipoConsulta, tarjetaCreditoBean);
			break;
			case Enum_Con_tarjetaCredito.tarjetaCta:
				tarjetaCredito = tarjetaCreditoDAO.consultaTar(tipoConsulta, tarjetaCreditoBean);
			break;
			case Enum_Con_tarjetaCredito.asociaTarjeta:
				tarjetaCredito = tarjetaCreditoDAO.consultaAsocia(tipoConsulta, tarjetaCreditoBean);
			break;
			
			case Enum_Con_tarjetaCredito.TarjetaComision:
				tarjetaCredito = tarjetaCreditoDAO.consultaComisionSol(tipoConsulta, tarjetaCreditoBean);
			break;
			case Enum_Con_tarjetaCredito.TarjetaAsignacion:
				tarjetaCredito = tarjetaCreditoDAO.consultaAsignacion(tipoConsulta, tarjetaCreditoBean);
			break;
		}
		return tarjetaCredito;
	}
	
	/* =========  Reporte PDF de Caratula del contrato de la tarjeta de credito  =========== */
	public ByteArrayOutputStream reporteCaratulaContrato(int tipoReporte, TarjetaDebitoBean bean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_TarjetaDebID",bean.getTarjetaDebID());
		parametrosReporte.agregaParametro("Par_NumRep",tipoReporte);
		
		parametrosReporte.agregaParametro("Par_NombreInstitucion", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema",Utileria.convierteFecha(bean.getFechaSistema()));

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
 	public ByteArrayOutputStream creaReporteBloqueoDesbloqueoTarCredPDF( TarjetaCreditoBean tarjetaCreditoBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaInicio",tarjetaCreditoBean.getFechaRegistro());
		parametrosReporte.agregaParametro("Par_FechaFin",tarjetaCreditoBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_ClienteID",tarjetaCreditoBean.getClienteID());
		parametrosReporte.agregaParametro("Par_LineaTarCred",(!tarjetaCreditoBean.getLineaTarCredID().isEmpty())?tarjetaCreditoBean.getLineaTarCredID():"Todos");

		parametrosReporte.agregaParametro("Par_TipoTarjetaCredID",tarjetaCreditoBean.getTipoTarjetaID());
		parametrosReporte.agregaParametro("Par_Mostrar",tarjetaCreditoBean.getEstatus());
		parametrosReporte.agregaParametro("Par_Motivo",tarjetaCreditoBean.getMotivoBloqID());
		parametrosReporte.agregaParametro("Par_nombreCliente",(!tarjetaCreditoBean.getNombreCompleto().isEmpty())?tarjetaCreditoBean.getNombreCompleto():"Todos");
		parametrosReporte.agregaParametro("Par_nombreTipoTarjeta",(!tarjetaCreditoBean.getNombreTarjeta().isEmpty())?tarjetaCreditoBean.getNombreTarjeta():"Todos");
		parametrosReporte.agregaParametro("Par_nombreMotivo",(!tarjetaCreditoBean.getDescriBloqueo().isEmpty())?tarjetaCreditoBean.getDescriBloqueo():"Todos");

		parametrosReporte.agregaParametro("Par_FechaEmision",tarjetaCreditoBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!tarjetaCreditoBean.getNombreUsuario().isEmpty())?tarjetaCreditoBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!tarjetaCreditoBean.getNombreInstitucion().isEmpty())?tarjetaCreditoBean.getNombreInstitucion(): "Todos");
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	
	

	
	//------------------setter y getter-----------
	
	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public TarjetaCreditoDAO getTarjetaCreditoDAO() {
		return tarjetaCreditoDAO;
	}

	public void setTarjetaCreditoDAO(TarjetaCreditoDAO tarjetaCreditoDAO) {
		this.tarjetaCreditoDAO = tarjetaCreditoDAO;
	}

	
}
