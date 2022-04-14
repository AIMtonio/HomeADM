package inversiones.servicio;

import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.InversionBean;
import inversiones.dao.InversionDAO;

import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.util.SystemOutLogger;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.ISOTRXServicio;
import tarjetas.servicio.ISOTRXServicio.Cat_Instrumentos_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_OpePeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Tran_ISOTRX;
import cuentas.bean.MonedasBean;
import cuentas.servicio.MonedasServicio;

public class InversionServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	InversionDAO inversionDAO = null;
	MonedasServicio monedasServicio = null;
	ISOTRXServicio isotrxServicio = null;
	TransaccionDAO transaccionDAO = null;

	//---------- Constructor ------------------------------------------------------------------------
	public InversionServicio(){
		super();
	}
			
	public static interface Enum_Tra_Inversion {
		int alta				    = 1;
		int cancela					= 2;
		int reinversion 		    = 3;
		int cancelaReinversion	    = 4;
		int modifica 				= 5;
		int autoriza 				= 6;
		int imprimePagare 			= 7;
		int vecim_Anticipada		= 8;
	}
	
	public static interface Enum_Con_Inversion {
		int principal 				= 1;
		int pagare 					= 2;
		int vecim_Anticipada 		= 3;
		int inverVigente			= 4;
	}
	
	public static interface Enum_Lis_Inversion {
		int principal = 1;
		int resumCte = 2;
		int paraCancelacion = 3;
		int general= 4;
		int reinversion = 5;
		int vencimientoAnt = 6;
		int inversionVig	= 7;
		int extravioDocs = 8;
		int inversionGuardaValores = 9;
		int inversionVen	= 10;
	}
	
	//---------- Transacciones ------------------------------------------------------------------------
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, InversionBean inversionBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case(Enum_Tra_Inversion.alta):
				mensaje = inversionDAO.alta(inversionBean, tipoTransaccion);
				break;
			case(Enum_Tra_Inversion.cancela):
			case(Enum_Tra_Inversion.vecim_Anticipada):
			case(Enum_Tra_Inversion.cancelaReinversion):
			case(Enum_Tra_Inversion.reinversion):
				mensaje = procesoCancelacionVencimiento(inversionBean, tipoTransaccion);
			break;
			case(Enum_Tra_Inversion.modifica):
				mensaje = inversionDAO.modificaInversion(inversionBean);
				break;
			case(Enum_Tra_Inversion.autoriza):
				mensaje = inversionDAO.actualizaInversion(inversionBean, tipoTransaccion);
				break;
			case(Enum_Tra_Inversion.imprimePagare):
				mensaje = inversionDAO.imprimePagareInversion(inversionBean, tipoTransaccion);
			break;
		}
				
		return mensaje;
	}
	
	public InversionBean consulta(int tipoConsulta, InversionBean inversionBean){
		
		InversionBean inversion = null;
		
		switch(tipoConsulta){
			case(Enum_Con_Inversion.principal):
				inversion = inversionDAO.consultaPrincipal(inversionBean, tipoConsulta);
				break;
			case(Enum_Con_Inversion.vecim_Anticipada):
				inversion = inversionDAO.consultaVencim_Anticipada(inversionBean, tipoConsulta);
				break;
			case(Enum_Con_Inversion.inverVigente):
				inversion = inversionDAO.consultaInversionVigente(inversionBean, tipoConsulta);
				break;
		}		
		return inversion;		
	}

	public List lista(int tipoLista, InversionBean inversionBean){
		List inverLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_Inversion.principal:
	        	inverLista = inversionDAO.listaPrincipal(inversionBean, tipoLista);
	        	break;
	        case  Enum_Lis_Inversion.resumCte:
	        	inverLista = inversionDAO.listaResumenCte(inversionBean, tipoLista);
	        	break;
	        case  Enum_Lis_Inversion.paraCancelacion:
	        	inverLista = inversionDAO.listaParaCancelacion(inversionBean, tipoLista);
	        	break; 	
	        case  Enum_Lis_Inversion.reinversion:
	        	inverLista = inversionDAO.listaParaCancelacion(inversionBean, tipoLista);
	        	break; 	        	
	        case  Enum_Lis_Inversion.vencimientoAnt:
	        	inverLista = inversionDAO.listaParaCancelacion(inversionBean, tipoLista);
	        	break; 
	        case  Enum_Lis_Inversion.inversionVig:
	        	inverLista = inversionDAO.listaInversionVig(inversionBean, tipoLista);
	        	break;
	        case Enum_Lis_Inversion.extravioDocs:
	        	inverLista = inversionDAO.listaPrincipal(inversionBean, tipoLista);
	        	break;
	        case Enum_Lis_Inversion.inversionGuardaValores:
	        	inverLista = inversionDAO.listaGuardaValores(inversionBean, tipoLista);
	        	break;
	        case  Enum_Lis_Inversion.inversionVen:
	        	inverLista = inversionDAO.listaResumenCte(inversionBean, tipoLista);
	        	break;
		}
		return inverLista;
	}
		
	// Proceso de Cancelacion o Vencimiento de Inversión
	public MensajeTransaccionBean procesoCancelacionVencimiento( final InversionBean inversionBean, final int tipoTransaccion){
		
		MensajeTransaccionBean mensajeTransaccionBean = null;
		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
		InversionBean inversion = new InversionBean();
		int tipoOperacion = 0;
		String descripcion = "";
		String notificar = "N";
		String inversionID = "";
		
		try {

			Long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
			parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion);
			switch(tipoTransaccion){
				case(Enum_Tra_Inversion.cancela):
					tipoOperacion = Enum_Pro_OpePeticion_ISOTRX.cancelaInversion;
					mensajeTransaccionBean = inversionDAO.cancelaInversion(inversionBean, tipoTransaccion);
				break;
				case(Enum_Tra_Inversion.vecim_Anticipada):
					tipoOperacion = Enum_Pro_OpePeticion_ISOTRX.vencimientoAntInversion;
					mensajeTransaccionBean = inversionDAO.vencimientoAntiInversion(inversionBean, tipoTransaccion);
				break;
				case(Enum_Tra_Inversion.cancelaReinversion):
					tipoOperacion = Enum_Pro_OpePeticion_ISOTRX.cancelaInversion;
					mensajeTransaccionBean = inversionDAO.cancelaReInversion(inversionBean, tipoTransaccion);
				break;
				case(Enum_Tra_Inversion.reinversion):
					
					// para el caso de la reinversión Se notifica el Abono de la Inversion y posterior el cargo
					mensajeTransaccionBean = inversionDAO.altaReinversion(inversionBean, tipoTransaccion);
					if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ) {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					notificar = Constantes.STRING_SI;
					descripcion = mensajeTransaccionBean.getDescripcion();
					inversionID = mensajeTransaccionBean.getConsecutivoString();

					inversion.setInversionID(inversionID);
					inversion = consulta(Enum_Con_Inversion.principal, inversion);

					if( Utileria.convierteLong(inversion.getCuentaAhoID()) == Constantes.ENTERO_CERO ){
						mensajeTransaccionBean.setNumero(30);
						mensajeTransaccionBean.setDescripcion("Error en la Consulta de Información de Reinversión");
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					// Proceso de tarjetas - notificacion de movimiento
					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
					tarjetaDebitoBean.setNumeroInstrumento(inversion.getCuentaAhoID());
					tarjetaDebitoBean.setMontoOperacion(String.valueOf(inversion.getMonto()));
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.aperturaInversion, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 

					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						mensajeTransaccionBean.setDescripcion("<br><b>WS ISOTRX:</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
						mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
					mensajeTransaccionBean.setDescripcion(descripcion);
					mensajeTransaccionBean.setConsecutivoString(inversionID);
					// Se notifica el Cargo por Reinversion
					tipoOperacion = Enum_Pro_OpePeticion_ISOTRX.reinversion;
				break;
				default:
					tipoOperacion = 0;
					mensajeTransaccionBean = null;
				break;
			}

			if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ) {
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			notificar = Constantes.STRING_SI;
			descripcion = mensajeTransaccionBean.getDescripcion();
			inversionID = mensajeTransaccionBean.getConsecutivoString();
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.inversion);
			tarjetaDebitoBean.setNumeroInstrumento(inversionBean.getInversionID());
			tarjetaDebitoBean.setMontoOperacion(Constantes.STRING_CERO);
			loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, tipoOperacion, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 

			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				mensajeTransaccionBean.setDescripcion("<br><b>WS ISOTRX:</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
				mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
				descripcion = descripcion +" "+ mensajeTransaccionBean.getDescripcion();
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO );
			mensajeTransaccionBean.setDescripcion(descripcion);
			mensajeTransaccionBean.setNombreControl("inversionID");
			mensajeTransaccionBean.setConsecutivoString(inversionID);

		}
		catch (Exception exception) {
			if (mensajeTransaccionBean.getNumero() == 0) {
				mensajeTransaccionBean.setNumero(999);
			}
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el proceso de Cancelación o Vencimiento de Inversiones: ", exception);

			if(notificar.equals(Constantes.STRING_SI)){
				// Si el proceso falla si se notifica el saldo de la cuenta
				loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
				mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.notificaSaldoCuenta , parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 
				if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
					mensajeTransaccionBean.setDescripcion("<br><b>WS ISOTRX:</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
					mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
					loggerSAFI.error(mensajeTransaccionBean.getDescripcion());
				}

				// si la operacion se proceso en SFI y fue Existosa se regresa el objeto con mensaje exitoso y el fallo de ISOTRX al momento de notificar el 
				// el abono
				mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO );
				mensajeTransaccionBean.setDescripcion(descripcion);
				mensajeTransaccionBean.setNombreControl("inversionID");
				mensajeTransaccionBean.setConsecutivoString(inversionID);
			}
		}

		return mensajeTransaccionBean;
	}

	//---------- Reportes ------------------------------------------------------------------------		

	public ByteArrayOutputStream reporteInversion(InversionBean inversionBean, String nombreReporte)
			throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		MonedasBean monedaBean = null;
		monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
													inversionBean.getMonedaID());
		
		parametrosReporte.agregaParametro("Par_InversionID", inversionBean.getInversionID());
		parametrosReporte.agregaParametro("Par_TipoConsulta", Enum_Con_Inversion.pagare);
		parametrosReporte.agregaParametro("Par_NombreInstitucion", inversionBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_MontoEnLetras", Utileria.cantidadEnLetras(
																	inversionBean.getMonto(),
																	Integer.parseInt(monedaBean.getMonedaID()),
																	monedaBean.getSimbolo(),
																	monedaBean.getDescripcion()));
		
		parametrosReporte.agregaParametro("Par_DirecInstit",inversionBean.getDireccionInstit());
		parametrosReporte.agregaParametro("Par_RFCInt",inversionBean.getRFCInstit());
		parametrosReporte.agregaParametro("Par_TelInst",inversionBean.getTelefonoInst());
		parametrosReporte.agregaParametro("Par_FechaEmision",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_GerenteGeneral",inversionBean.getNombreGerente());
		parametrosReporte.agregaParametro("Par_Usuario",inversionBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_Presidente",inversionBean.getNombrePresidente());
		parametrosReporte.agregaParametro("Par_SucursalID",inversionBean.getSucursalID());
		
		// Actualiza el Estatus del Pagare de la Inversion a Impreso
		MensajeTransaccionBean mensaje = grabaTransaccion(Enum_Tra_Inversion.imprimePagare, inversionBean);	
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	
	public String reporteInversionDia(InversionBean inversionBean, String nombreReporte)
			throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_Fecha",inversionBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_TipoInversion",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
		parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(inversionBean.getPromotorID()));
		parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(inversionBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_TipoMoneda",Utileria.convierteEntero(inversionBean.getMonedaID()));	

		parametrosReporte.agregaParametro("Par_DescripcionInv",(!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.agregaParametro("Par_NomPromotor",(!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomSucursal",(!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NomMoneda",(!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ByteArrayOutputStream repInversionPDF(InversionBean inversionBean, String nombreReporte)
			throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_Fecha",inversionBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_TipoInversion",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
		parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(inversionBean.getPromotorID()));
		parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(inversionBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_TipoMoneda",Utileria.convierteEntero(inversionBean.getMonedaID()));	

		parametrosReporte.agregaParametro("Par_DescripcionInv",(!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.agregaParametro("Par_NomPromotor",(!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomSucursal",(!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NomMoneda",(!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	
    public String reporteCancelacionDia(InversionBean inversionBean, String nombreReporte)throws Exception {
		
    	ParametrosReporte parametrosReporte = new ParametrosReporte();
    	
    	parametrosReporte.agregaParametro("Par_Fecha",inversionBean.getFechaInicio());
    	parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
    	parametrosReporte.agregaParametro("Par_TipoInversion",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
    	parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(inversionBean.getPromotorID()));
    	parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(inversionBean.getSucursalID()));
    	parametrosReporte.agregaParametro("Par_TipoMoneda",Utileria.convierteEntero(inversionBean.getMonedaID()));	

    	parametrosReporte.agregaParametro("Par_DescripcionInv",(!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
    	parametrosReporte.agregaParametro("Par_NomPromotor",(!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
    	parametrosReporte.agregaParametro("Par_NomSucursal",(!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
    	parametrosReporte.agregaParametro("Par_NomMoneda",(!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
    	parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
    	parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
    	
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
    
    public ByteArrayOutputStream repCancelacionPDF(InversionBean inversionBean, String nombreReporte)
    		throws Exception{
    	ParametrosReporte parametrosReporte = new ParametrosReporte();

    	parametrosReporte.agregaParametro("Par_Fecha",inversionBean.getFechaInicio());
    	parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
    	parametrosReporte.agregaParametro("Par_TipoInversion",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
    	parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(inversionBean.getPromotorID()));
    	parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(inversionBean.getSucursalID()));
    	parametrosReporte.agregaParametro("Par_TipoMoneda",Utileria.convierteEntero(inversionBean.getMonedaID()));	

    	parametrosReporte.agregaParametro("Par_DescripcionInv",(!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
    	parametrosReporte.agregaParametro("Par_NomPromotor",(!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
    	parametrosReporte.agregaParametro("Par_NomSucursal",(!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
    	parametrosReporte.agregaParametro("Par_NomMoneda",(!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
    	parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
    	parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
    	
    	return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
    	
    }
    
	public String reporteVencimientosDia(InversionBean inversionBean, String nombreReporte)throws Exception {
			
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_Fecha",inversionBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_TipoInversion",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
		parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(inversionBean.getPromotorID()));
		parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(inversionBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_TipoMoneda",Utileria.convierteEntero(inversionBean.getMonedaID()));	
		parametrosReporte.agregaParametro("Par_Estatus",inversionBean.getEstatus());
		
		parametrosReporte.agregaParametro("Par_DescripcionInv",(!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.agregaParametro("Par_NomPromotor",(!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomSucursal",(!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NomMoneda",(!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
	
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ByteArrayOutputStream repVencimientoPDF(InversionBean inversionBean, String nombreReporte)
			throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
	
		parametrosReporte.agregaParametro("Par_Fecha",inversionBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_TipoInversion",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
		parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(inversionBean.getPromotorID()));
		parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(inversionBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_TipoMoneda",Utileria.convierteEntero(inversionBean.getMonedaID()));	
		parametrosReporte.agregaParametro("Par_Estatus",inversionBean.getEstatus());
	
		parametrosReporte.agregaParametro("Par_DescripcionInv",(!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.agregaParametro("Par_NomPromotor",(!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomSucursal",(!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NomMoneda",(!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}

	public String reporteRenovacion(InversionBean inversionBean, String nombreReporte)throws Exception {
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_Fecha",inversionBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_TipoInversion",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
		parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(inversionBean.getPromotorID()));
		parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(inversionBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_Anio",inversionBean.getAnio());
		parametrosReporte.agregaParametro("Par_Mes",inversionBean.getMes());
		parametrosReporte.agregaParametro("Par_Renovada",Utileria.convierteEntero(inversionBean.getInversionRenovada()));
		parametrosReporte.agregaParametro("Par_DescripcionInv",(!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.agregaParametro("Par_NomPromotor",(!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomRenovada",(!inversionBean.getReinvertir().isEmpty())? inversionBean.getReinvertir() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomSucursal",(!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
	
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ByteArrayOutputStream repRenovacionPDF(InversionBean inversionBean, String nombreReporte)
			throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
	
		parametrosReporte.agregaParametro("Par_Fecha",inversionBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_TipoInversion",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
		parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(inversionBean.getPromotorID()));
		parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(inversionBean.getSucursalID()));	
		parametrosReporte.agregaParametro("Par_Anio",inversionBean.getAnio());
		parametrosReporte.agregaParametro("Par_Mes",inversionBean.getMes());
		parametrosReporte.agregaParametro("Par_Renovada",Utileria.convierteEntero(inversionBean.getInversionRenovada()));
		parametrosReporte.agregaParametro("Par_DescripcionInv",(!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.agregaParametro("Par_NomPromotor",(!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomRenovada",(!inversionBean.getReinvertir().isEmpty())? inversionBean.getReinvertir() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomSucursal",(!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}

	public String reporteInversionVig(InversionBean inversionBean, String nombreReporte)throws Exception {
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Fecha",inversionBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_TipoInversion",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
		parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(inversionBean.getPromotorID()));
		parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(inversionBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_TipoMoneda",Utileria.convierteEntero(inversionBean.getMonedaID()));	
	
		parametrosReporte.agregaParametro("Par_DescripcionInv",(!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.agregaParametro("Par_NomPromotor",(!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomSucursal",(!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NomMoneda",(!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ByteArrayOutputStream repInversionVigPDF(InversionBean inversionBean, String nombreReporte)
			throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
	
		parametrosReporte.agregaParametro("Par_Fecha",inversionBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_TipoInversion",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
		parametrosReporte.agregaParametro("Par_Promotor",Utileria.convierteEntero(inversionBean.getPromotorID()));
		parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(inversionBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_TipoMoneda",Utileria.convierteEntero(inversionBean.getMonedaID()));	
	
		parametrosReporte.agregaParametro("Par_DescripcionInv",(!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.agregaParametro("Par_NomPromotor",(!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomSucursal",(!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NomMoneda",(!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}

	public String reporteInverCliente(InversionBean inversionBean,
		   String nombreReporte)throws Exception {
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(inversionBean.getClienteID()));
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(inversionBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_NombreSucursal",inversionBean.getNombreSucursal());
		
		parametrosReporte.agregaParametro("Par_NomCliente",(!inversionBean.getNombreCliente().isEmpty())? inversionBean.getNombreCliente() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ByteArrayOutputStream repInverClientePDF(InversionBean inversionBean, String nombreReporte)
			throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
	
		parametrosReporte.agregaParametro("Par_FechaActual",inversionBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(inversionBean.getClienteID()));
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(inversionBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_NombreSucursal",inversionBean.getNombreSucursal());
	
		parametrosReporte.agregaParametro("Par_NomCliente",(!inversionBean.getNombreCliente().isEmpty())? inversionBean.getNombreCliente() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());	
	}

	public String reporteInverSalCon(String fecha, String nombreReporte)throws Exception {
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Fecha",fecha);
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public List <InversionBean>listaInversionesAperturaExcel(InversionBean inversionBean, HttpServletResponse request) {

		InversionBean parametrosReporte = new InversionBean();

		parametrosReporte.setFechaInicio(inversionBean.getFechaInicio());
		parametrosReporte.setFechaActual(inversionBean.getFechaActual());
		parametrosReporte.setTipoInversionID(inversionBean.getTipoInversionID());
		parametrosReporte.setPromotorID(inversionBean.getPromotorID());
		parametrosReporte.setSucursalID(inversionBean.getSucursalID());
		parametrosReporte.setMonedaID(inversionBean.getMonedaID());	
	
		parametrosReporte.setDescripcionTipoInv((!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.setNombrePromotor((!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.setNombreSucursal((!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.setNombreMoneda((!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
		parametrosReporte.setNombreUsuario((!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.setNombreInstitucion((!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");

		List<InversionBean> listaInversion = null;
		listaInversion = inversionDAO.reporteInversionDiaExcel(parametrosReporte);
		return listaInversion;
	}
	
	public List <InversionBean>listaCancelacionInversionesExcel(InversionBean inversionBean, HttpServletResponse request) {

		InversionBean parametrosReporte = new InversionBean();

		parametrosReporte.setFechaInicio(inversionBean.getFechaInicio());
		parametrosReporte.setFechaActual(inversionBean.getFechaActual());
		parametrosReporte.setTipoInversionID(inversionBean.getTipoInversionID());
		parametrosReporte.setPromotorID(inversionBean.getPromotorID());
		parametrosReporte.setSucursalID(inversionBean.getSucursalID());
		parametrosReporte.setMonedaID(inversionBean.getMonedaID());	
	
		parametrosReporte.setDescripcionTipoInv((!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.setNombrePromotor((!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.setNombreSucursal((!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.setNombreMoneda((!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
		parametrosReporte.setNombreUsuario((!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.setNombreInstitucion((!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");

		List<InversionBean> listaInversion = null;
		listaInversion = inversionDAO.reporteCancelacionesInversionDiaExcel(parametrosReporte);
		return listaInversion;
	}
	
	public List <InversionBean>listaVencimientoInversionesExcel(InversionBean inversionBean, HttpServletResponse request) {

		InversionBean parametrosReporte = new InversionBean();	
		
		parametrosReporte.setFechaVencimiento(inversionBean.getFechaVencimiento());
		parametrosReporte.setFechaActual(inversionBean.getFechaActual());
		parametrosReporte.setTipoInversionID(inversionBean.getTipoInversionID());
		parametrosReporte.setPromotorID(inversionBean.getPromotorID());
		parametrosReporte.setSucursalID(inversionBean.getSucursalID());
		parametrosReporte.setMonedaID(inversionBean.getMonedaID());
		parametrosReporte.setEstatus(inversionBean.getEstatus());
	
		parametrosReporte.setDescripcionTipoInv((!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.setNombrePromotor((!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.setNombreSucursal((!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.setNombreMoneda((!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
		parametrosReporte.setEstatus((!inversionBean.getEstatus().isEmpty())? inversionBean.getEstatus() : "");
		parametrosReporte.setNombreUsuario((!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.setNombreInstitucion((!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");

		List<InversionBean> listaInversion = null;
		listaInversion = inversionDAO.reporteVencimientoInversionDiaExcel(parametrosReporte);
		return listaInversion;
	}
	
	public List <InversionBean>listaRenovacionesMesExcel(InversionBean inversionBean, HttpServletResponse request) {

		InversionBean parametrosReporte = new InversionBean();
		
		parametrosReporte.setAnio(inversionBean.getAnio());
		parametrosReporte.setMes(inversionBean.getMes());
		parametrosReporte.setFechaActual(inversionBean.getFechaActual());
		parametrosReporte.setTipoInversionID(inversionBean.getTipoInversionID());
		parametrosReporte.setPromotorID(inversionBean.getPromotorID());
		parametrosReporte.setSucursalID(inversionBean.getSucursalID());
		parametrosReporte.setInversionRenovada(inversionBean.getInversionRenovada());	
		
		parametrosReporte.setDescripcionTipoInv((!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"");
		parametrosReporte.setNombrePromotor((!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.setNombreSucursal((!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.setNombreUsuario((!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.setNombreInstitucion((!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");

		List<InversionBean> listaInversion = null;
		listaInversion = inversionDAO.reporteRenovacionesMesExcel(parametrosReporte);
		return listaInversion;
	}
	
	public List <InversionBean>listaInversionesVigentesExcel(InversionBean inversionBean, HttpServletResponse request) {

		InversionBean parametrosReporte = new InversionBean();

		parametrosReporte.setFechaInicio(inversionBean.getFechaInicio());
		parametrosReporte.setFechaActual(inversionBean.getFechaActual());
		parametrosReporte.setTipoInversionID(inversionBean.getTipoInversionID());
		parametrosReporte.setPromotorID(inversionBean.getPromotorID());
		parametrosReporte.setSucursalID(inversionBean.getSucursalID());
		parametrosReporte.setMonedaID(inversionBean.getMonedaID());	
	
		parametrosReporte.setDescripcionTipoInv((!inversionBean.getDescripcionTipoInv().isEmpty())? inversionBean.getDescripcionTipoInv():"TODOS");
		parametrosReporte.setNombrePromotor((!inversionBean.getNombrePromotor().isEmpty())? inversionBean.getNombrePromotor() : "TODOS");
		parametrosReporte.setNombreSucursal((!inversionBean.getNombreSucursal().isEmpty())? inversionBean.getNombreSucursal():"TODOS");
		parametrosReporte.setNombreMoneda((!inversionBean.getNombreMoneda().isEmpty())? inversionBean.getNombreMoneda() : "TODOS");
		parametrosReporte.setNombreUsuario((!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.setNombreInstitucion((!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");

		List<InversionBean> listaInversion = null;
		listaInversion = inversionDAO.reporteInversionesVigentesExcel(parametrosReporte);
		return listaInversion;
	}
	
	public List <InversionBean>listaInversionesClienteExcel(InversionBean inversionBean, HttpServletResponse request) {
		
		InversionBean parametrosReporte = new InversionBean();
		
		parametrosReporte.setFechaActual(inversionBean.getFechaActual());
		parametrosReporte.setClienteID(inversionBean.getClienteID());
		parametrosReporte.setSucursalID(inversionBean.getSucursalID());
		parametrosReporte.setNombreSucursal(inversionBean.getNombreSucursal());
	
		parametrosReporte.setNombreCliente((!inversionBean.getNombreCliente().isEmpty())? inversionBean.getNombreCliente() : "TODOS");
		parametrosReporte.setNombreUsuario((!inversionBean.getNombreUsuario().isEmpty())?inversionBean.getNombreUsuario(): "TODOS");
		parametrosReporte.setNombreInstitucion((!inversionBean.getNombreInstitucion().isEmpty())?inversionBean.getNombreInstitucion(): "TODOS");
		
		List<InversionBean> listaInversion = null;
		listaInversion = inversionDAO.reporteInversionesClienteExcel(parametrosReporte);
		return listaInversion;
	}

		
	//---------- Asignaciones ------------------------------------------------------------------------


	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}

	public InversionDAO getInversionDAO() {
		return inversionDAO;
	}

	public void setInversionDAO(InversionDAO inversionDAO) {
		this.inversionDAO = inversionDAO;
	}

	public MonedasServicio getMonedasServicio() {
		return monedasServicio;
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
