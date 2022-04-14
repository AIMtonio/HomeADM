package tarjetas.servicio;


import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import javax.script.ScriptEngine;
import javax.script.ScriptException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.pentaho.di.core.KettleEnvironment;
import org.pentaho.di.core.exception.KettleException;
import org.pentaho.di.core.util.EnvUtil;
import org.pentaho.di.job.Job;
import org.pentaho.di.job.JobMeta;

import org.springframework.core.task.TaskExecutor;

import credito.bean.CreditosBean;


import pld.servicio.CargaListasPLDServicio.Enum_Con_ParamGenerales;
import soporte.servicio.ParamGeneralesServicio;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ParamGeneralesBean;
import soporte.bean.ParametrosSisBean;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.dao.TarjetaDebitoDAO;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_OpePeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_TarPeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Tran_ISOTRX;


public class TarjetaDebitoServicio extends BaseServicio {
	ParamGeneralesServicio paramGeneralesServicio = null;
	ISOTRXServicio isotrxServicio = null;
	TarjetaDebitoDAO tarjetaDebitoDAO = null;
	TransaccionDAO transaccionDAO = null;
	public TaskExecutor taskExecutor;

	
	public TarjetaDebitoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Tra_tarjetaDebito {
		int alta 			= 1;
		int modificacion 	= 2;
		int actualizacion 	= 3;
		int altaTarjeta		= 4;
		int altaBloqueo		= 5;
		int altaDesbloqueo  = 6;

		int altaCancelacion = 7;
		int activaTarjeta	= 8;	
		int altaLote        = 9;
		int altaLoteSAFI	= 10;

	}

	public static interface Enum_Act_tarjetaDebito {
		int asociaCuentasTarjetaC 		= 1;
		int pagoComisionAnual			= 2;
	
	}

	public static interface Enum_Con_tarjetaDebito{			
		int principal						= 1;
		int foranea							= 2;
		int cuenta_NumTarjeta_Tipo			= 3;
		int tipoTarjeta			 			= 4;
		int consultaTarDeb              	= 5;
		int consultaTarDebBitacoraBloq  	= 6;
	    int consultaTarDebBitacoraDesBloq 	= 7;
		int tarDebEstAsigna					= 9;
        int consultaTarDebCancel        	= 10;
        int asociaTarjeta					= 12;
        int tarjetaCta                 	    = 13;   // Antes 12	    
        int consultaComisionSolicitud		= 15;
        int consultaMovTarjetas				= 17;
        int consultaTarDebCta				= 18;
        int consultaCobroAnualTarDeb		= 19;
        int consultaTarExistentes			= 20;
        int conBitacoraPagoCom				= 21;
        int conLote							= 22;
        int conLoteSAFI						= 23;
        int conRutaNomArchSAFI				= 24;
        
	}

	public static interface Enum_lis_tarjetaDebito{
		int principal 		             = 1;
		int tarjetaDebitoBLoq			 = 2;
		int TarjetaDebEst 				 = 3;
		int tarjetaLis					 = 4;
		int tarjetaDeb 	 				 = 5;  // Antes 3
		int tarjetaDebitoDesbloq		 = 6;
		int tarAsignaLis				 = 7;
		int tarjetaDebitoCancel		     = 8;
		int tarjetaDebito		         = 9;
		int LimiteTarDeb                 =10;
		int GirosTarDebInd               =11;
		int listaMovimientos             =13;
		int listaTarjExist               =15;
		int listaPagoAnual	             =14;
		int listaTarjetasPorCta			 =16; //lista las tarjetas asociadas a la cta indicada
		int listaTarjetasDebPorCta	     =17; //lista las  debito asociada  a una cuenta

		
	}

	public static interface Enum_lis_tarjetaDebitoMovs{
		int principal 		             = 1;
	}
	
	public static interface Enum_Tra_loteTarjetas{
		int principal 		             = 1;
	}
	
	public static interface Enum_Con_loteTarjetas{
		int principal 		             = 1;
	}
	public static interface Enum_Con_ParamGenerales {
		int JobLoteTarjetas = 8;
		int JobLoteTarjetasSAFI = 61;
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, TarjetaDebitoBean tarjetaDebitoBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_tarjetaDebito.altaTarjeta:
				mensaje = tarjetaDebitoDAO.alta(tipoTransaccion,tarjetaDebitoBean);
			break;					
			case Enum_Tra_tarjetaDebito.actualizacion:
				mensaje = actualizaTajetaCredito(tipoActualizacion,tarjetaDebitoBean);
			break;
			case Enum_Tra_tarjetaDebito.activaTarjeta:
			case Enum_Tra_tarjetaDebito.altaBloqueo:
			case Enum_Tra_tarjetaDebito.altaDesbloqueo:
			case Enum_Tra_tarjetaDebito.altaCancelacion:
				mensaje = procesoTarjetaDebito(tipoTransaccion,tarjetaDebitoBean);
			break;
			case Enum_Tra_tarjetaDebito.altaLote:
				mensaje = tarjetaDebitoDAO.insertaLoteTarjeta(tipoTransaccion,tarjetaDebitoBean);
				if(mensaje.getNumero()== 0){
					mensaje = escribeProcesoISS();
					if(mensaje.getNumero()== 999){
						mensaje = tarjetaDebitoDAO.validaLoteTarjeta(tipoTransaccion,tarjetaDebitoBean);
					}
				}
			break;
			case Enum_Tra_tarjetaDebito.altaLoteSAFI:
				mensaje = tarjetaDebitoDAO.insertaLoteTarjetaSAFI(tipoTransaccion,tarjetaDebitoBean);
				//Se asigna el valor consecutivo
				tarjetaDebitoBean.setLoteDebitoSAFIID(mensaje.getConsecutivoString());
				if(mensaje.getNumero()== 0){
					mensaje = tarjetaDebitoDAO.procesarArchivoTarjetas();
					if(mensaje.getNumero() > 0){
						mensaje = tarjetaDebitoDAO.validaLoteTarjetaSAFI(tipoTransaccion,tarjetaDebitoBean);
						mensaje.setNumero(1);// Fallo de la operación Error controlado
					}else{
						return mensaje;
					}
				}
			break;
		}

		return mensaje;
	}
	
	public MensajeTransaccionBean actualizaTajetaCredito(int tipoActualizacion, TarjetaDebitoBean tarjetaDebitoBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
			case Enum_Act_tarjetaDebito.asociaCuentasTarjetaC:
				mensaje = tarjetaDebitoDAO.actualiza(tipoActualizacion, tarjetaDebitoBean);				
			break;
			case Enum_Act_tarjetaDebito.pagoComisionAnual:
				mensaje = tarjetaDebitoDAO.pagoComisionAnual(tipoActualizacion, tarjetaDebitoBean);				
			break;
		}
		return mensaje;
	}
	
	//Escritura de Lote de Tarjetas
	public MensajeTransaccionBean escribeProcesoISS( ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ParamGeneralesBean	paramGeneralesBean = new ParamGeneralesBean();
		
		paramGeneralesBean = paramGeneralesServicio.consulta(Enum_Con_ParamGenerales.JobLoteTarjetas, paramGeneralesBean);
		final String fileKtr = paramGeneralesBean.getValorParametro();
		
		try {
				KettleEnvironment.init();
				JobMeta jobMeta = new JobMeta(fileKtr, null);
				Job job = new Job(null, jobMeta);
				job.start();
			    job.waitUntilFinished();
			    
			    if(job.getErrors()>0){
				mensaje.setNumero(999);
				mensaje.setDescripcion("Ha ocurrido un Error. No se pudieron insertar los registros.");
				mensaje.setNombreControl("LoteDebitoID");				
			} 
			    else {
				mensaje.setNumero(0);
				mensaje.setDescripcion("Operación Realizada Exitosamente");
				mensaje.setNombreControl("LoteDebitoID");				
			}
			 
		} catch (KettleException e) {
					mensaje.setNumero(999);	
					mensaje.setDescripcion("Ha ocurrido un Error. No se pudieron insertar las tarjetas.");
					mensaje.setNombreControl("LoteDebitoID");
					loggerSAFI.error("Error al insertar tarjetas: ", e);
		}
		
		return mensaje;
	}
	
	public TarjetaDebitoBean consulta(int tipoConsulta, TarjetaDebitoBean tarjetaDebitoBean){
		TarjetaDebitoBean tarjetaDebito = null;
		switch(tipoConsulta){
			case Enum_Con_tarjetaDebito.principal:
			tarjetaDebito = tarjetaDebitoDAO.principal(Enum_Con_tarjetaDebito.principal, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.cuenta_NumTarjeta_Tipo:
				tarjetaDebito = tarjetaDebitoDAO.consulta(Enum_Con_tarjetaDebito.cuenta_NumTarjeta_Tipo, tarjetaDebitoBean);
			break;	
			case Enum_Con_tarjetaDebito.tipoTarjeta:
				tarjetaDebito = tarjetaDebitoDAO.consulta(Enum_Con_tarjetaDebito.tipoTarjeta, tarjetaDebitoBean);
			break;	
			case Enum_Con_tarjetaDebito.tarjetaCta:
				tarjetaDebito = tarjetaDebitoDAO.consultaTar(Enum_Con_tarjetaDebito.tarjetaCta, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.asociaTarjeta:
				tarjetaDebito = tarjetaDebitoDAO.consultaAsocia(Enum_Con_tarjetaDebito.asociaTarjeta, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.tarDebEstAsigna:
				tarjetaDebito = tarjetaDebitoDAO.consultaTarDebAsigna(Enum_Con_tarjetaDebito.tarDebEstAsigna, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.consultaTarDeb:
				tarjetaDebito = tarjetaDebitoDAO.consultaTarjetaDeb(Enum_Con_tarjetaDebito.consultaTarDeb, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.consultaTarDebBitacoraBloq:
				tarjetaDebito = tarjetaDebitoDAO.consultaBitacoTarjetaDebBloq(Enum_Con_tarjetaDebito.consultaTarDebBitacoraBloq, tarjetaDebitoBean);
			break;	
			case Enum_Con_tarjetaDebito.consultaTarDebBitacoraDesBloq:
					tarjetaDebito = tarjetaDebitoDAO.consultaBitacoTarjetaDebDesbloq(Enum_Con_tarjetaDebito.consultaTarDebBitacoraDesBloq, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.consultaTarDebCancel:
				tarjetaDebito = tarjetaDebitoDAO.consultaTarjetaCancel(Enum_Con_tarjetaDebito.consultaTarDebCancel, tarjetaDebitoBean);
			break;			
			case Enum_Con_tarjetaDebito.consultaComisionSolicitud:
				tarjetaDebito = tarjetaDebitoDAO.consultaComisionSol(Enum_Con_tarjetaDebito.consultaComisionSolicitud, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.consultaMovTarjetas:
				tarjetaDebito = tarjetaDebitoDAO.consultaMovTarjetas(Enum_Con_tarjetaDebito.consultaMovTarjetas, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.consultaTarDebCta:
				tarjetaDebito = tarjetaDebitoDAO.consultaTarDebCuenta(Enum_Con_tarjetaDebito.consultaTarDebCta, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.consultaTarExistentes:
				tarjetaDebito = tarjetaDebitoDAO.consultaTarExistentes(Enum_Con_tarjetaDebito.consultaTarExistentes, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.consultaCobroAnualTarDeb:
				tarjetaDebito = tarjetaDebitoDAO.consultaPagoAnual(Enum_Con_tarjetaDebito.consultaCobroAnualTarDeb, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.conBitacoraPagoCom:
				tarjetaDebito = tarjetaDebitoDAO.consultaBitacoraPago(Enum_Con_tarjetaDebito.conBitacoraPagoCom, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.conLote:	
				tarjetaDebito = tarjetaDebitoDAO.loteTarjetaCon(Enum_Con_tarjetaDebito.conLote, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.conLoteSAFI:	
				tarjetaDebito = tarjetaDebitoDAO.loteTarjetaCon(Enum_Con_tarjetaDebito.conLoteSAFI, tarjetaDebitoBean);
			break;
			case Enum_Con_tarjetaDebito.conRutaNomArchSAFI:	
				tarjetaDebito = tarjetaDebitoDAO.loteTarjetaRutaArchCon(Enum_Con_tarjetaDebito.conRutaNomArchSAFI, tarjetaDebitoBean);
			break;
		}
		return tarjetaDebito;
	}
	
	public List lista(int tipoLista, TarjetaDebitoBean tarjetaDebitoBean){	
			List listaTarjetaDebito = null;
		switch (tipoLista) {
			case Enum_lis_tarjetaDebito.principal:		
				listaTarjetaDebito = tarjetaDebitoDAO.listaTarjetas(tarjetaDebitoBean, tipoLista);		
				break;
			case Enum_lis_tarjetaDebito.tarjetaDeb:		
				listaTarjetaDebito = tarjetaDebitoDAO.listaTarjetasDeb(tarjetaDebitoBean, tipoLista);				
				break;	

			case Enum_lis_tarjetaDebito.TarjetaDebEst:		
				listaTarjetaDebito = tarjetaDebitoDAO.listTarEstatus(tarjetaDebitoBean, tipoLista);				
				break;	
			case Enum_lis_tarjetaDebito.tarjetaLis:		
				listaTarjetaDebito = tarjetaDebitoDAO.listTarEstatus(tarjetaDebitoBean, tipoLista);				
				break;
			case Enum_lis_tarjetaDebito.tarAsignaLis:
				listaTarjetaDebito = tarjetaDebitoDAO.listTarEstatus(tarjetaDebitoBean, tipoLista);
				break;
			case Enum_lis_tarjetaDebito.tarjetaDebitoBLoq:
				listaTarjetaDebito = tarjetaDebitoDAO.TarjetaDeb(tipoLista,tarjetaDebitoBean);
				break;
			case Enum_lis_tarjetaDebito.tarjetaDebitoDesbloq:		
				listaTarjetaDebito = tarjetaDebitoDAO.TarjetaDeb(tipoLista,tarjetaDebitoBean);
				break;
			case Enum_lis_tarjetaDebito.tarjetaDebitoCancel:
				listaTarjetaDebito = tarjetaDebitoDAO.TarjetaDeb(tipoLista,tarjetaDebitoBean);
				break;
	        case Enum_lis_tarjetaDebito.tarjetaDebito:
				listaTarjetaDebito = tarjetaDebitoDAO.TarjetaDeb(tipoLista,tarjetaDebitoBean);
				break;
	        case Enum_lis_tarjetaDebito.LimiteTarDeb:
				listaTarjetaDebito = tarjetaDebitoDAO.TarjetaDeb(tipoLista,tarjetaDebitoBean);
				break;
	        case Enum_lis_tarjetaDebito.GirosTarDebInd:
				listaTarjetaDebito = tarjetaDebitoDAO.TarjetaDeb(tipoLista,tarjetaDebitoBean);
				break;

	        case Enum_lis_tarjetaDebito.listaMovimientos:
				listaTarjetaDebito = tarjetaDebitoDAO.TarjetaDeb(tipoLista,tarjetaDebitoBean);
				break;
	        case Enum_lis_tarjetaDebito.listaTarjExist:
				listaTarjetaDebito = tarjetaDebitoDAO.listTarExistente(tipoLista,tarjetaDebitoBean);
				break;
	        case Enum_lis_tarjetaDebito.listaPagoAnual:
				listaTarjetaDebito = tarjetaDebitoDAO.TarjetaDeb(tipoLista,tarjetaDebitoBean);
				break;
	        case Enum_lis_tarjetaDebito.listaTarjetasPorCta:
				listaTarjetaDebito = tarjetaDebitoDAO.TarDebListaCta(tipoLista,tarjetaDebitoBean);
				break;
	        case Enum_lis_tarjetaDebito.listaTarjetasDebPorCta:
				listaTarjetaDebito = tarjetaDebitoDAO.TarDebListaCtaUnica(tipoLista,tarjetaDebitoBean);
				break;
		}
		return listaTarjetaDebito;		
	}
	
	public ByteArrayOutputStream creaReporteBloqueoDesbloqueoTarDebPDF( TarjetaDebitoBean tarjetaDebitoBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaInicio",tarjetaDebitoBean.getFechaRegistro());
		parametrosReporte.agregaParametro("Par_FechaFin",tarjetaDebitoBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_ClienteID",tarjetaDebitoBean.getClienteID());
		parametrosReporte.agregaParametro("Par_CuentaAho",(!tarjetaDebitoBean.getCuentaAhoID().isEmpty())?tarjetaDebitoBean.getCuentaAhoID():"Todos");

		parametrosReporte.agregaParametro("Par_TipoTarjeta",tarjetaDebitoBean.getTipoTarjetaDebID());
		parametrosReporte.agregaParametro("Par_Mostrar",tarjetaDebitoBean.getEstatus());
		parametrosReporte.agregaParametro("Par_Motivo",tarjetaDebitoBean.getMotivoBloqID());
		parametrosReporte.agregaParametro("Par_nombreCliente",(!tarjetaDebitoBean.getNombreCompleto().isEmpty())?tarjetaDebitoBean.getNombreCompleto():"Todos");
		parametrosReporte.agregaParametro("Par_nombreTipoTarjeta",(!tarjetaDebitoBean.getNombreTarjeta().isEmpty())?tarjetaDebitoBean.getNombreTarjeta():"Todos");
		parametrosReporte.agregaParametro("Par_nombreMotivo",(!tarjetaDebitoBean.getDescriBloqueo().isEmpty())?tarjetaDebitoBean.getDescriBloqueo():"Todos");

		parametrosReporte.agregaParametro("Par_FechaEmision",tarjetaDebitoBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!tarjetaDebitoBean.getNombreUsuario().isEmpty())?tarjetaDebitoBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!tarjetaDebitoBean.getNombreInstitucion().isEmpty())?tarjetaDebitoBean.getNombreInstitucion(): "Todos");
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// Reporte de Solicitud de Tarjeta por Estatus
	public ByteArrayOutputStream creaTarDebReporteEstatusPDF( TarjetaDebitoBean tarjetaDebitoBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();

	
		parametrosReporte.agregaParametro("Par_FechaInicio",tarjetaDebitoBean.getFechaRegistro());
		parametrosReporte.agregaParametro("Par_FechaFin",tarjetaDebitoBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_Estatus",tarjetaDebitoBean.getEstatus());
    	parametrosReporte.agregaParametro("Par_NombreEstatus",(!tarjetaDebitoBean.getEstatus().isEmpty())?tarjetaDebitoBean.getEstatus():"Todos");
		parametrosReporte.agregaParametro("Par_FechaEmision",tarjetaDebitoBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!tarjetaDebitoBean.getNombreUsuario().isEmpty())?tarjetaDebitoBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!tarjetaDebitoBean.getNombreInstitucion().isEmpty())?tarjetaDebitoBean.getNombreInstitucion(): "Todos");
		 	 	
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}	
	
	/* =========  Reporte PDF de Caratula del contrato de la tarjeta de debito  =========== */
	public ByteArrayOutputStream reporteCaratulaContrato(int tipoReporte, TarjetaDebitoBean bean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_TarjetaDebID",bean.getTarjetaDebID());
		parametrosReporte.agregaParametro("Par_NumRep",tipoReporte);
		
		parametrosReporte.agregaParametro("Par_NombreInstitucion", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema",Utileria.convierteFecha(bean.getFechaSistema()));

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/* =========  Reporte PDF de Pagos de comision Anual de tarjetas de debito  =========== */
	public ByteArrayOutputStream reportePagoComAnual(int tipoReporte, TarjetaDebitoBean bean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_TipoTarjetaDebID",bean.getTipoTarjetaDebID());
		parametrosReporte.agregaParametro("Par_TipoTarjeta",bean.getTipo());
		parametrosReporte.agregaParametro("Par_NumRep",tipoReporte);
		
		parametrosReporte.agregaParametro("Par_NombreInstitucion", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema",bean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_Usuario",bean.getNombreUsuario());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// Proceso de Tarjetas de Debito
	public MensajeTransaccionBean procesoTarjetaDebito(final int tipoTransaccion, final TarjetaDebitoBean tarjetaDebitoBean)  {

		MensajeTransaccionBean mensajeTransaccionBean = null;
		String mensajeRespuesta = "";
		String controlRespuesta = "";
		String consecutivoRespuesta = "";
		try {

			Long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
			parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion);
			switch(tipoTransaccion){
				case Enum_Tra_tarjetaDebito.activaTarjeta:

					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_TarPeticion_ISOTRX.activacionTarjeta, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.tarjetaPeticion);
					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						mensajeRespuesta = mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
						mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
						throw new Exception(mensajeRespuesta);
					}

					mensajeTransaccionBean = tarjetaDebitoDAO.activa(tipoTransaccion, tarjetaDebitoBean);
					if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ) {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					mensajeRespuesta = mensajeTransaccionBean.getDescripcion();
					controlRespuesta = mensajeTransaccionBean.getNombreControl();
					consecutivoRespuesta = mensajeTransaccionBean.getConsecutivoString();

					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.activacionTarjeta, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion);
					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						mensajeRespuesta = mensajeRespuesta + " <br><b>WS ISOTRX:</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
						mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
						throw new Exception(mensajeRespuesta);
					}

					mensajeTransaccionBean.setDescripcion(mensajeRespuesta);
					mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
					mensajeTransaccionBean.setNombreControl(controlRespuesta);
					mensajeTransaccionBean.setConsecutivoString(consecutivoRespuesta);

				break;
				case Enum_Tra_tarjetaDebito.altaDesbloqueo:

					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_TarPeticion_ISOTRX.desbloqueoTarjeta, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.tarjetaPeticion);
					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						mensajeRespuesta = mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
						mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
						throw new Exception(mensajeRespuesta);
					}

					mensajeTransaccionBean = tarjetaDebitoDAO.desbloqueoTarjeta(tipoTransaccion, tarjetaDebitoBean);
					if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ) {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					mensajeRespuesta = mensajeTransaccionBean.getDescripcion();
					controlRespuesta = mensajeTransaccionBean.getNombreControl();
					consecutivoRespuesta = mensajeTransaccionBean.getConsecutivoString();

					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.activacionTarjeta, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion);
					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						mensajeRespuesta = mensajeRespuesta + " <br><b>WS ISOTRX:</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
						mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
						throw new Exception(mensajeRespuesta);
					}
					
					mensajeTransaccionBean.setDescripcion(mensajeRespuesta);
					mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
					mensajeTransaccionBean.setNombreControl(controlRespuesta);
					mensajeTransaccionBean.setConsecutivoString(consecutivoRespuesta);

				break;
				case Enum_Tra_tarjetaDebito.altaBloqueo:

					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_TarPeticion_ISOTRX.bloqueoTarjeta, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.tarjetaPeticion);

					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						mensajeRespuesta = mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
						mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
						throw new Exception(mensajeRespuesta);
					}

					mensajeTransaccionBean = tarjetaDebitoDAO.bloqueoTarjeta(tipoTransaccion, tarjetaDebitoBean);
					if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ) {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

				break;
				case Enum_Tra_tarjetaDebito.altaCancelacion:

					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_TarPeticion_ISOTRX.cancelacionTarjeta, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.tarjetaPeticion);
					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						mensajeRespuesta = mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
						mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
						throw new Exception(mensajeRespuesta);
					}

					mensajeTransaccionBean = tarjetaDebitoDAO.cancelacionTarjetaDebito(tipoTransaccion, tarjetaDebitoBean);
					if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ) {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

				break;
			}					
		}
		catch (Exception exception) {
			mensajeTransaccionBean.setDescripcion(exception.getMessage());
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en Los Procesos de Tarjetas de Débito: ", exception);
		}

		return mensajeTransaccionBean;

	}
	
	//------------------setter y getter-----------
	public TarjetaDebitoDAO getTarjetaDebitoDAO() {
		return tarjetaDebitoDAO;
	}

	public void setTarjetaDebitoDAO(TarjetaDebitoDAO tarjetaDebitoDAO) {
		this.tarjetaDebitoDAO = tarjetaDebitoDAO;
	}
	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}
	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public ISOTRXServicio getIsotrxServicio() {
		return isotrxServicio;
	}

	public void setIsotrxServicio(ISOTRXServicio isotrxServicio) {
		this.isotrxServicio = isotrxServicio;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}
}
