package tarjetas.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;
import reporte.ParametrosReporte;
import reporte.Reporte;
import tarjetas.bean.TipoTarjetaDebBean;
import tarjetas.dao.TipoTarjetaDebDAO;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import originacion.bean.SolicitudesArchivoBean;
import originacion.servicio.SolicitudArchivoServicio.Enum_Tra_ArchivoSolicitudBaja;

public class TipoTarjetaDebServicio extends BaseServicio {
	TipoTarjetaDebDAO tipoTarjetaDebDAO = null;
	
	public TipoTarjetaDebServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_Tra_tarjetaDebito {
		int alta=1;
		int modificacion=2;	
		int eliminar = 3;
	}
	
	public static interface Enum_lis_TipoTarjetaDebito{
		int principal 			= 1;
		int foranea				= 2;
		int porTipoCuenta  		= 3;
		int tipoTarjetaDebito 	= 4;
		int activos				= 5;
		int tipoTarCobro		= 6;
		int colorTarjeta		= 7;
		int activosTarCred		= 8;
		int serviceCode			= 9;
		int patrocsubbin  		= 10;
		int consultasubbin 		= 11;

	}    
		
	public static interface Enum_Con_TipoTarjetaDebito{
		int principal 			= 1;
		int foranea				= 2;
		int tipoTarjetaDebito   =3;
	}
	public static interface Enum_Con_TipoTarjetaBAJ{
		int bajaSubBin  = 1;
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, TipoTarjetaDebBean tipoTarjetaDebBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){		
	    	case Enum_Tra_tarjetaDebito.alta:
	    		//ALTA BASE PRINCIPAL
	    		mensaje = tipoTarjetaDebDAO.tipoTarjetaDebitoBDPrincipal(tipoTransaccion,tipoTarjetaDebBean);
	    		//ALTA BASE MICROFIN
	    		if(mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR){
	    			tipoTarjetaDebBean.setNumeroTipoTarjeta(mensaje.getConsecutivoString());
	    			mensaje = tipoTarjetaDebDAO.tipoTarjetaDebito(tipoTransaccion,tipoTarjetaDebBean);
	    		}
	    		break;
		    case Enum_Tra_tarjetaDebito.modificacion:
		    	//ALTA BASE PRINCIPAL
				mensaje = tipoTarjetaDebDAO.modtipoTarjetaDebitoBDPrincipal(tipoTarjetaDebBean);
				//ALTA BASE MICROFIN
				if(mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR){
					mensaje = tipoTarjetaDebDAO.modtipoTarjetaDebito(tipoTarjetaDebBean);
				}
				break;
				
		    case Enum_Tra_tarjetaDebito.eliminar:
				mensaje =tipoTarjetaDebDAO.BajtipoTarjetaSudBinBDPrincipal(tipoTarjetaDebBean);
	    		//ALTA BASE MICROFIN
	    		if(mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR){
	    			mensaje = BajatipoTarjetaSudBin(tipoTarjetaDebBean);
	    		}	
			break;
		
		}
		return mensaje;
	}
	
	/* transaccion para Baja de Archivos o Documentos de los creditos*/
	public MensajeTransaccionBean bajaTipoTarjeta(int tipoBaja,TipoTarjetaDebBean tipoTarjetaDebBean){
		
		MensajeTransaccionBean mensaje = null;
		
		
			switch (tipoBaja) {
				case Enum_Con_TipoTarjetaBAJ.bajaSubBin:
					mensaje =tipoTarjetaDebDAO.BajtipoTarjetaSudBinBDPrincipal(tipoTarjetaDebBean);
		    		//ALTA BASE MICROFIN
		    		if(mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR){
		    			mensaje = BajatipoTarjetaSudBin(tipoTarjetaDebBean);
		    		}
				
						break;	

			}
			return mensaje;
	}

	public TipoTarjetaDebBean consulta(int tipoConsulta, TipoTarjetaDebBean tipoTarjetaDebBean){
		TipoTarjetaDebBean tarjetaDebito = null;
		switch(tipoConsulta){
		case Enum_Con_TipoTarjetaDebito.principal:
			tarjetaDebito = tipoTarjetaDebDAO.consultaPrincipal(Enum_Con_TipoTarjetaDebito.principal, tipoTarjetaDebBean);
		break;
			case Enum_Con_TipoTarjetaDebito.tipoTarjetaDebito:
				tarjetaDebito = tipoTarjetaDebDAO.consultaTipoTarjetaDebitoBDPrincipal(Enum_Con_TipoTarjetaDebito.tipoTarjetaDebito, tipoTarjetaDebBean);
			break;
			}
		return tarjetaDebito;
	}
	
	public TipoTarjetaDebBean consultaTipoTarjeta(int tipoConsulta, String tarjetaDebID,String cuentaAhoID ){
		TipoTarjetaDebBean tipoTarjeta = null;
		switch (tipoConsulta) {
			case Enum_Con_TipoTarjetaDebito.foranea://solo necesito nombre del corportativo
				tipoTarjeta = tipoTarjetaDebDAO.consultaForanea(Integer.parseInt(tarjetaDebID),Long.parseLong(cuentaAhoID),tipoConsulta);
				break;
		}
		return tipoTarjeta;
	}
	
	public List lista(int tipoLista, TipoTarjetaDebBean tipoTarjetaDebBean){		
		List listaTipoTarjetaDe = null;
		switch (tipoLista) {
			case Enum_lis_TipoTarjetaDebito.principal:		
				listaTipoTarjetaDe = tipoTarjetaDebDAO.listaPrincipalBDPrincipal(tipoTarjetaDebBean, tipoLista);				
				break;
			case Enum_lis_TipoTarjetaDebito.foranea:		
				listaTipoTarjetaDe = tipoTarjetaDebDAO.listaforanea(tipoTarjetaDebBean, tipoLista);				
				break;
			case Enum_lis_TipoTarjetaDebito.porTipoCuenta:		
				listaTipoTarjetaDe = tipoTarjetaDebDAO.listaPorTipoCuenta(tipoTarjetaDebBean, tipoLista);				
				break;
			case Enum_lis_TipoTarjetaDebito.tipoTarjetaDebito:		
				listaTipoTarjetaDe = tipoTarjetaDebDAO.listaPrincipal(tipoTarjetaDebBean, tipoLista);				
				break;
			case Enum_lis_TipoTarjetaDebito.consultasubbin:		
				listaTipoTarjetaDe = tipoTarjetaDebDAO.listaPatrocSubBin(tipoTarjetaDebBean, tipoLista);				
				break;	
				
		}
		return listaTipoTarjetaDe;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista, TipoTarjetaDebBean tipoTarjetaDebBean) {
		List listaTipoTarjetaDe = null;

		switch(tipoLista){
			case (Enum_lis_TipoTarjetaDebito.activos): 
				listaTipoTarjetaDe = tipoTarjetaDebDAO.listaPrincipal(tipoTarjetaDebBean, Enum_lis_TipoTarjetaDebito.activos);
			break;
			case (Enum_lis_TipoTarjetaDebito.tipoTarCobro): 
				listaTipoTarjetaDe = tipoTarjetaDebDAO.comboTipoTarjetaCobroBDPrincipal(tipoTarjetaDebBean, Enum_lis_TipoTarjetaDebito.tipoTarCobro);
			break;
			case (Enum_lis_TipoTarjetaDebito.colorTarjeta): 
				listaTipoTarjetaDe = tipoTarjetaDebDAO.comboColorTarjetas(tipoTarjetaDebBean, Enum_lis_TipoTarjetaDebito.colorTarjeta);
			break;
			case (Enum_lis_TipoTarjetaDebito.serviceCode):
				listaTipoTarjetaDe = tipoTarjetaDebDAO.comboServiceCode(tipoTarjetaDebBean, Enum_lis_TipoTarjetaDebito.serviceCode);
			break;
			
			case (Enum_lis_TipoTarjetaDebito.patrocsubbin):
				listaTipoTarjetaDe = tipoTarjetaDebDAO.comboPatrocinados(tipoTarjetaDebBean,tipoLista);
			break;
		}
		return listaTipoTarjetaDe.toArray();
	}

	public ByteArrayOutputStream creaReporteTarDebTiposPDF( TipoTarjetaDebBean tipoTarjetaDebBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaInicio",tipoTarjetaDebBean.getFechaRegistro());
		parametrosReporte.agregaParametro("Par_FechaFin",tipoTarjetaDebBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_TipoTarjeta",tipoTarjetaDebBean.getTipoTarjetaDebID());
    	parametrosReporte.agregaParametro("Par_nombreTipoTarjeta",(!tipoTarjetaDebBean.getNombreTarjeta().isEmpty())?tipoTarjetaDebBean.getNombreTarjeta():"Todos");
		parametrosReporte.agregaParametro("Par_FechaEmision",tipoTarjetaDebBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!tipoTarjetaDebBean.getNombreUsuario().isEmpty())?tipoTarjetaDebBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!tipoTarjetaDebBean.getNombreInstitucion().isEmpty())?tipoTarjetaDebBean.getNombreInstitucion(): "Todos");
		 	 
		
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	
//	REPORTE POR TIPO DE TARJETA DE CREDITO
	public ByteArrayOutputStream creaReporteTarCredTiposPDF( TipoTarjetaDebBean tipoTarjetaDebBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaInicio",tipoTarjetaDebBean.getFechaRegistro());
		parametrosReporte.agregaParametro("Par_FechaFin",tipoTarjetaDebBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_TipoTarjeta",tipoTarjetaDebBean.getTipoTarjetaCredID());
    	parametrosReporte.agregaParametro("Par_nombreTipoTarjeta",(!tipoTarjetaDebBean.getNombreTarjeta().isEmpty())?tipoTarjetaDebBean.getNombreTarjeta():"Todos");
		parametrosReporte.agregaParametro("Par_FechaEmision",tipoTarjetaDebBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!tipoTarjetaDebBean.getNombreUsuario().isEmpty())?tipoTarjetaDebBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!tipoTarjetaDebBean.getNombreInstitucion().isEmpty())?tipoTarjetaDebBean.getNombreInstitucion(): "Todos");
		 	 
		
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	public MensajeTransaccionBean BajatipoTarjetaSudBin(TipoTarjetaDebBean tipoTarjetaDebBean){
		MensajeTransaccionBean mensaje = null;
			mensaje = tipoTarjetaDebDAO.BajtipoTarjetaSudBin(tipoTarjetaDebBean);	
			System.out.println(tipoTarjetaDebBean);
		return mensaje;
	}
	
	
	//--------------------Getter y setter---------------------------------
	public TipoTarjetaDebDAO getTipoTarjetaDebDAO() {
		return tipoTarjetaDebDAO;
	}
	public void setTipoTarjetaDebDAO(TipoTarjetaDebDAO tipoTarjetaDebDAO) {
		this.tipoTarjetaDebDAO = tipoTarjetaDebDAO;
	}
}

