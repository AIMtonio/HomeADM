package cedes.servicio;

import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.PropiedadesSAFIBean;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.ISOTRXServicio;
import tarjetas.servicio.ISOTRXServicio.Cat_Instrumentos_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_OpePeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Tran_ISOTRX;
import cedes.bean.CedesBean;
import cedes.dao.CedesDAO;
import cuentas.bean.MonedasBean;
import cuentas.servicio.MonedasServicio;

public class CedesServicio extends BaseServicio{
 
	CedesDAO cedesDAO = null;
	MonedasServicio monedasServicio = null;
	ISOTRXServicio isotrxServicio = null;
	TransaccionDAO transaccionDAO = null;
	
	//---------- Constructor ------------------------------------------------------------------------
	public CedesServicio(){
		super();
	}
		

	public static interface Enum_Tra_Cedes {
		int alta				= 1;
		int modifica			= 2;
		int autoriza			= 3;
		int imprimePagare		= 4;
		int reinvertitr			= 5;
		int cancelarReinver		= 6;
		int autorizaAnclaje		= 7;
		int cancelaCede         = 10;
		int vencimientoCede     = 11;

	}
	
	public static interface Enum_Con_Cedes {
		int principal		= 1;			
		int pagare			= 2;
		int numCedes		= 3;
		int checkList		= 4;
		int reinversion 	= 5;
		int anclaje			= 6;
		int montosAnclados	= 7;
		int ajuste			= 8;
		int vencimiAnt		= 9;
	}	
	
	public static interface Enum_Lis_Cedes{
		int principal	     	= 1;
		int simulador	      	= 2;
		int resumenCte	      	= 3;
		int checklist         	= 4;
		int digitaDod         	= 5;
		int	reinversionManual 	= 6;
		int reimpresion	      	= 7;
		int cedesVencidas     	= 8;
		int cedesVigentes     	= 9;
		int cedesCancela      	= 10;
		int cedesVencimiento  	= 11;
		int cedesOrigVigentes 	= 12;
		int cedesGuardaValores	= 13;
		int cedesPorAutorizar	= 14;
	}
	
	public static interface Enum_Act_Cedes {
		int actProcesoCedeSI 		= 3;  // Se usa para actualizar el valor parametro: SI
		int actProcesoCedeNO 		= 4;  // Se usa para actualizar el valor parametro: NO
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CedesBean cedesBean){
		
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case(Enum_Tra_Cedes.alta):
				mensaje = cedesDAO.alta(cedesBean, tipoTransaccion);
				break;
			case(Enum_Tra_Cedes.modifica):
				mensaje = cedesDAO.modificar(cedesBean, tipoTransaccion);
				break;
			case(Enum_Tra_Cedes.autoriza):
				mensaje = cedesDAO.autoriza(cedesBean, tipoTransaccion);
				break;
			case(Enum_Tra_Cedes.imprimePagare):
				mensaje = cedesDAO.actualizaCede(cedesBean, tipoTransaccion);
				break;
			case(Enum_Tra_Cedes.autorizaAnclaje):
				mensaje = cedesDAO.autoriza(cedesBean, 5);
				break;
			case(Enum_Tra_Cedes.cancelaCede):
			case(Enum_Tra_Cedes.vencimientoCede):
			case(Enum_Tra_Cedes.cancelarReinver):
			case(Enum_Tra_Cedes.reinvertitr):
				mensaje = procesoCancelacionVencimiento(cedesBean, tipoTransaccion);
			break;
		}
		return mensaje;
	}
	
	public CedesBean consulta(int tipoConsulta,CedesBean cedesBean){
		CedesBean cedes = null;
		switch (tipoConsulta) {
			case Enum_Con_Cedes.principal:		
				cedes = cedesDAO.consultaPrincipal(cedesBean, Enum_Con_Cedes.principal);				
				break;	
			case Enum_Con_Cedes.numCedes:		
				cedes = cedesDAO.consultaNumeroCedes(cedesBean, Enum_Con_Cedes.numCedes);				
				break;	
				
			case Enum_Con_Cedes.checkList:		
				cedes = cedesDAO.consultaCheckList(cedesBean, Enum_Con_Cedes.checkList);				
				break;
			case Enum_Con_Cedes.reinversion:
				cedes = cedesDAO.consultaReinversion(cedesBean, Enum_Con_Cedes.reinversion);
				break;
			case Enum_Con_Cedes.anclaje:
				cedes = cedesDAO.consultaAnclaje(cedesBean, Enum_Con_Cedes.anclaje);
				break;
			case Enum_Con_Cedes.montosAnclados:
				cedes = cedesDAO.consultaMontosAnclados(cedesBean, Enum_Con_Cedes.montosAnclados);
				break;
			case Enum_Con_Cedes.ajuste:
				cedes = cedesDAO.AjusteAnclaje(cedesBean,1);
				break;
			case Enum_Con_Cedes.vencimiAnt:		
				cedes = cedesDAO.consultaVencimientoAnt(cedesBean, Enum_Con_Cedes.vencimiAnt);				
				break;			
		}
		return cedes;
	}
	
	public List lista(int tipoLista, CedesBean cedesBean){		
		List listaCedes = null;
		switch (tipoLista) {
			case Enum_Lis_Cedes.principal:		
				listaCedes = cedesDAO.listaPrincipal(cedesBean, tipoLista);				
				break;	
			case Enum_Lis_Cedes.simulador:		
				listaCedes = cedesDAO.simulador(cedesBean);				
				break;	
			case Enum_Lis_Cedes.resumenCte:
				listaCedes = cedesDAO.resumenCte(cedesBean, tipoLista);
				break;
			case Enum_Lis_Cedes.checklist:		
				listaCedes = cedesDAO.listaPrincipal(cedesBean, tipoLista);				
				break;
				
			case Enum_Lis_Cedes.digitaDod:		
				listaCedes = cedesDAO.listaPrincipal(cedesBean, tipoLista);				
				break;
			case Enum_Lis_Cedes.reinversionManual:		
				listaCedes = cedesDAO.listaPrincipal(cedesBean, tipoLista);				
				break;	
			case Enum_Lis_Cedes.reimpresion:		
				listaCedes = cedesDAO.listaPrincipal(cedesBean, tipoLista);				
				break;
			case Enum_Lis_Cedes.cedesVencidas:
				listaCedes = cedesDAO.listaReporteCedesVencidas(cedesBean, tipoLista);
				break;
			case Enum_Lis_Cedes.cedesVigentes:
				listaCedes = cedesDAO.listaReporteCedesVigentes(cedesBean, tipoLista);
				break;
			case Enum_Lis_Cedes.cedesCancela:
				listaCedes = cedesDAO.listaCancelacion(cedesBean, tipoLista);
				break;
			case Enum_Lis_Cedes.cedesVencimiento:
				listaCedes = cedesDAO.listaCancelacion(cedesBean, tipoLista);
				break;
			case Enum_Lis_Cedes.cedesOrigVigentes:
				listaCedes = cedesDAO.listaPrincipal(cedesBean, tipoLista);
				break;
			case Enum_Lis_Cedes.cedesGuardaValores:
				listaCedes = cedesDAO.listaGuardaValores(cedesBean, tipoLista);
			break;
			case Enum_Lis_Cedes.cedesPorAutorizar:
				listaCedes = cedesDAO.reporteCedesPorAurtorizar(cedesBean);
				break;
		}
		return listaCedes;
	}
	
	// Proceso de Cancelacion o Vencimiento de Cede
	public MensajeTransaccionBean procesoCancelacionVencimiento( final CedesBean cedesBean, final int tipoTransaccion){
		
		MensajeTransaccionBean mensajeTransaccionBean = null;
		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
		CedesBean cedes = new CedesBean();
		int tipoOperacion = 0;
		String descripcion = "";
		String notificar = "N";
		String cedeID = "";
		try {

			Long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
			parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion);
			switch(tipoTransaccion){
				case(Enum_Tra_Cedes.cancelaCede):
					tipoOperacion = Enum_Pro_OpePeticion_ISOTRX.cancelaCede;
					mensajeTransaccionBean = cedesDAO.cancelaCede(cedesBean, tipoTransaccion);
				break;
				case(Enum_Tra_Cedes.vencimientoCede):
					tipoOperacion = Enum_Pro_OpePeticion_ISOTRX.vencimientoAntCede;
					mensajeTransaccionBean = cedesDAO.cancelaCede(cedesBean, tipoTransaccion);
				break;
				case(Enum_Tra_Cedes.cancelarReinver):
					tipoOperacion = Enum_Pro_OpePeticion_ISOTRX.cancelaCede;
					mensajeTransaccionBean = cedesDAO.abonar(cedesBean);				
				break;
				case(Enum_Tra_Cedes.reinvertitr):
					
					// para el caso de la reinversión Se notifica la Apertura a la cuenta y posterior el cargo
					mensajeTransaccionBean = cedesDAO.reinvertir(cedesBean);
					if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ) {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					notificar = Constantes.STRING_SI;
					descripcion = mensajeTransaccionBean.getDescripcion();
					cedeID = mensajeTransaccionBean.getConsecutivoString();

					cedes.setCedeID(cedeID);
					cedes = consulta(Enum_Con_Cedes.principal, cedes);

					if( Utileria.convierteLong(cedes.getCuentaAhoID()) == Constantes.ENTERO_CERO ){
						mensajeTransaccionBean.setNumero(30);
						mensajeTransaccionBean.setDescripcion("Error en la Consulta de Información de Reinversión");
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					// Proceso de notificacion de saldo
					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
					tarjetaDebitoBean.setNumeroInstrumento(cedes.getCuentaAhoID());
					tarjetaDebitoBean.setMontoOperacion(String.valueOf(cedes.getMonto()));
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.aperturaCede, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 

					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						mensajeTransaccionBean.setDescripcion("<br><b>WS ISOTRX:</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
						mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
					mensajeTransaccionBean.setDescripcion(descripcion);
					mensajeTransaccionBean.setConsecutivoString(cedeID);
					tipoOperacion = Enum_Pro_OpePeticion_ISOTRX.reinversionCede;
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
			cedeID = mensajeTransaccionBean.getConsecutivoString();
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cede);
			tarjetaDebitoBean.setNumeroInstrumento(cedesBean.getCedeID());
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
			mensajeTransaccionBean.setNombreControl("cedeID");
			mensajeTransaccionBean.setConsecutivoString(cedeID);

		}
		catch (Exception exception) {
			if (mensajeTransaccionBean.getNumero() == 0) {
				mensajeTransaccionBean.setNumero(999);
			}
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el proceso de Cancelación o Vencimiento de Cedes: ", exception);

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
				mensajeTransaccionBean.setNombreControl("cedeID");
				mensajeTransaccionBean.setConsecutivoString(cedeID);
			}
		}

		return mensajeTransaccionBean;
	}
	
	public ByteArrayOutputStream reporteCedes(CedesBean cedesBean, String nombreReporte)
			throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		MonedasBean monedaBean =null ;
		monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
													cedesBean.getMonedaID());
		
		String pathImgInverCamex = PropiedadesSAFIBean.propiedadesSAFI.getProperty("RutaImgInvercamex");
		
		parametrosReporte.agregaParametro("Par_CedeID",Utileria.completaCerosIzquierda(cedesBean.getCedeID(), 6));
		parametrosReporte.agregaParametro("Par_TipoConsulta", Enum_Con_Cedes.pagare);
		parametrosReporte.agregaParametro("Par_NombreInstitucion", cedesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_MontoEnLetras", Utileria.cantidadEnLetras(Utileria.convierteDoble(
																	cedesBean.getTotal()),
																	Integer.parseInt(monedaBean.getMonedaID()),
																	monedaBean.getSimbolo(),
																	monedaBean.getDescripcion()));
	
		parametrosReporte.agregaParametro("Par_NombreCliente",cedesBean.getNombreCompleto());
		parametrosReporte.agregaParametro("Par_SucursalID",cedesBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_NombreSucursal",cedesBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_DesTipoCede",cedesBean.getDescripcion());
		parametrosReporte.agregaParametro("Par_FechaApertura",cedesBean.getFechaApertura());
		parametrosReporte.agregaParametro("Par_FechaVencimiento",cedesBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_CuentaAhoID",Utileria.completaCerosIzquierda(cedesBean.getCuentaAhoID(), 12));
		parametrosReporte.agregaParametro("Par_Plazo",cedesBean.getPlazo());
		parametrosReporte.agregaParametro("Par_CalculoInteres",cedesBean.getCalculoInteres());
		parametrosReporte.agregaParametro("Par_TasaBase",cedesBean.getTasaBase());
		parametrosReporte.agregaParametro("Par_SobreTasa",cedesBean.getSobreTasa());
		parametrosReporte.agregaParametro("Par_PisoTasa",cedesBean.getPisoTasa());
		parametrosReporte.agregaParametro("Par_TechoTasa",cedesBean.getTechoTasa());
		parametrosReporte.agregaParametro("Par_Importe",cedesBean.getTotalRecibir());
		parametrosReporte.agregaParametro("Par_DireccionInst",cedesBean.getDireccionInstit());
		parametrosReporte.agregaParametro("Par_TasaFija",cedesBean.getTasaFija());
		parametrosReporte.agregaParametro("Par_TasaISR",cedesBean.getTasaISR());
		parametrosReporte.agregaParametro("Par_TasaNeta",cedesBean.getTasaNeta());
		parametrosReporte.agregaParametro("Par_InteresRecibir",cedesBean.getInteresRecibir());		
		parametrosReporte.agregaParametro("Par_ValorGat", cedesBean.getValorGat());
		parametrosReporte.agregaParametro("Par_RutaInvercamex",pathImgInverCamex);
		
		// Actualiza el Estatus del Pagare de la Inversion a Impreso
		MensajeTransaccionBean mensaje = grabaTransaccion(Enum_Tra_Cedes.imprimePagare, cedesBean);	
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}

	public ByteArrayOutputStream reporteCedesVigPDF(CedesBean cedesBean, String nombreReporte)throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_TipoCedeID", cedesBean.getTipoCedeID());
		parametrosReporte.agregaParametro("Par_PromotorID", cedesBean.getPromotorID());
		parametrosReporte.agregaParametro("Par_SucursalID",cedesBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_ClienteID", cedesBean.getClienteID());
		parametrosReporte.agregaParametro("Par_FechaApertura", cedesBean.getFechaApertura());
		parametrosReporte.agregaParametro("Par_NombreUsuario", cedesBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", cedesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision", cedesBean.getFechaEmision());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public  ByteArrayOutputStream repVencimientoPDF(CedesBean cedesBean, String nombreReporte)throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicial", cedesBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFinal", cedesBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_Sucursal", cedesBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_TipoMoneda", cedesBean.getMonedaID());
		parametrosReporte.agregaParametro("Par_Promotor", cedesBean.getPromotorID());
		parametrosReporte.agregaParametro("Par_Cede", cedesBean.getCedeID());
		parametrosReporte.agregaParametro("Par_DescripcionCede", cedesBean.getDescripcion());
		parametrosReporte.agregaParametro("Par_NomPromotor", cedesBean.getNombrePromotor());
		parametrosReporte.agregaParametro("Par_NomSucursal", cedesBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_NomMoneda", cedesBean.getNombreMoneda());
		parametrosReporte.agregaParametro("Par_NomUsuario", cedesBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NomInstitucion", cedesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_Estatus", cedesBean.getEstatus());
		parametrosReporte.agregaParametro("Par_FechaActual", cedesBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_NombreEstatus", cedesBean.getDesEstatus());

		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/**
	 * Método que crea el reporte en formato pdf de CEDES No Autorizadas.
	 * @param cedesBean : Clase bean con los valores de los parámetros que recibe el prpt.
	 * @param nombreReporte : Nombre del archivo prpt definido en el xml de cedes.
	 * @param request : HttpServletRequest que trae por parámetro el valor para safilocale.cliente.
	 * @return ByteArrayOutputStream : Reporte generado.
	 * @throws Exception : Error al crear el reporte.
	 * @author avelasco
	 */
	public ByteArrayOutputStream cedesNoAutorizadasPDF(CedesBean cedesBean, String nombreReporte, HttpServletRequest request) throws Exception {
		String safilocaleCliente = request.getParameter("safilocaleCliente");
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_TipoCedeID", cedesBean.getTipoCedeID());
		parametrosReporte.agregaParametro("Par_PromotorID", cedesBean.getPromotorID());
		parametrosReporte.agregaParametro("Par_SucursalID", cedesBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_ClienteID", cedesBean.getClienteID());
		parametrosReporte.agregaParametro("Par_NomPromotor", cedesBean.getNombrePromotor());
		parametrosReporte.agregaParametro("Par_NomSucursal", cedesBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_Usuario", cedesBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", cedesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NombreCliente", cedesBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_NomTipoCede", cedesBean.getDescripcion());
		parametrosReporte.agregaParametro("Par_FechaSistema", parametrosAuditoriaBean.getFecha().toString());
		parametrosReporte.agregaParametro("Par_SafiLocale", safilocaleCliente);
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public MensajeTransaccionBean vencimientoMasivoCedes(CedesBean cedesBean){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeActualiza = new MensajeTransaccionBean();
		CedesBean cedBean = null;
				
		mensajeActualiza = cedesDAO.actualizaProcesoCedes(cedBean,Enum_Act_Cedes.actProcesoCedeSI);

		if(mensajeActualiza.getNumero()==0){	
			mensaje = cedesDAO.vencimientoMasivoCedes(cedesBean);
			mensajeActualiza = cedesDAO.actualizaProcesoCedes(cedBean,Enum_Act_Cedes.actProcesoCedeNO);
		}
		else{
			mensaje=mensajeActualiza;
		}
			return mensaje;
	}


	public MonedasServicio getMonedasServicio() {
		return monedasServicio;
	}

	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}

	public CedesDAO getCedesDAO() {
		return cedesDAO;
	}

	public void setCedesDAO(CedesDAO cedesDAO) {
		this.cedesDAO = cedesDAO;
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
