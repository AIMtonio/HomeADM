package tarjetas.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import soporte.serviciosrest.ConexionWSRest;
import tarjetas.bean.ParamTarjetasBean;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.beanWS.request.IsoTrxBean;
import tarjetas.beanWS.request.IsotrxRequest;
import tarjetas.beanWS.request.OperacionTarjetaRequest;
import tarjetas.beanWS.request.ParamTarjetasRequest;
import tarjetas.beanWS.request.TarjetaPeticionRequest;
import tarjetas.beanWS.response.OperacionPeticionResponse;
import tarjetas.beanWS.response.TarjetaPeticionResponse;
import tarjetas.servicio.ISOTRXServicio.Enum_Con_ISOTRX;

public class ISOTRXDAO extends BaseDAO {;

	String tipoTarjeta = "";
	String mensajeError = "";

	public static interface Armar_JSON {
		int tarjetaPeticion	  = 1;
		int operacionPeticion = 2;
	}

	public ISOTRXDAO() {
		super();
	}

	// Proceso de Tarjeta Petición
	public MensajeTransaccionBean tarjetaPeticion( final TarjetaDebitoBean tarjetaDebitoBean, final int tipoProceso, final long numeroTransaccion){

		IsoTrxBean isoTrxBean = null;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		ConexionWSRest conexionWSRest = null;
		TarjetaPeticionResponse tarjetaPeticionResponse = new TarjetaPeticionResponse();
		IsotrxRequest isotrxRequest = null;

		try{

			mensajeTransaccionBean = new MensajeTransaccionBean();
			loggerISOTRX.info(Constantes.NIVEL_DAO);
			loggerISOTRX.info("Obteniendo Datos de la Tarjeta");
			isoTrxBean = consultaTarjetaPeticion(tarjetaDebitoBean, tipoProceso, numeroTransaccion);
			if(isoTrxBean == null ) {
				mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[0]);
				mensajeTransaccionBean.setDescripcion("Error en la Consulta de los Parámetros de Autorización Terceros.");
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			loggerISOTRX.info("Los Parámetros de Autorización Terceros: " +  Utileria.logJsonFormat(isoTrxBean.getParamTarjetasBean()));
			tipoTarjeta = (Utileria.convierteEntero(isoTrxBean.getTipoTarjeta()) != 1) ? "DESCONOCIDA" :"TARJETA DE DÉBITO" ;
			loggerISOTRX.info("Tipo de Tarjeta: " +  tipoTarjeta);

			if( Utileria.convierteEntero(isoTrxBean.getTipoTarjeta()) == Constantes.tipoTarjeta.debito &&
				isoTrxBean.getParamTarjetasBean().getAutorizaTerceroTranTD().equals(Constantes.STRING_SI) ){

				isotrxRequest = armarJsonRequest(isoTrxBean, Armar_JSON.tarjetaPeticion);
				conexionWSRest = new ConexionWSRest(isoTrxBean.getRutaConSAFIWS());
				conexionWSRest.addHeader("autentificacion", isoTrxBean.getUsuarioConSAFIWS());
				tarjetaPeticionResponse = (TarjetaPeticionResponse) conexionWSRest.peticionPOST(isotrxRequest, TarjetaPeticionResponse.class, isoTrxBean.getParamTarjetasBean().getTimeOutConWSAutoriza(), Constantes.logger.ISOTRX);

				if( Utileria.convierteEntero(tarjetaPeticionResponse.getResultadoOperacion()) != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0])){

					mensajeTransaccionBean.setNumero(Utileria.convierteEntero(tarjetaPeticionResponse.getResultadoOperacion()));
					mensajeError = (tarjetaPeticionResponse.getMensajeRechazo() != null) ? "Error con el Proveedor de Servicios" : tarjetaPeticionResponse.getMensajeRechazo();

					switch(Utileria.convierteEntero(tarjetaPeticionResponse.getException())){
						case ConexionWSRest.Enum_Exception.SocketTimeoutException:
							// Segmento de Time Out
							mensajeError = ConexionWSRest.Enum_MensajeError.mensajeTimeOut;
						break;
						case ConexionWSRest.Enum_Exception.ClientProtocolException:
							// Segmento de Protocolos
							mensajeError = ConexionWSRest.Enum_MensajeError.mensajeProtocolo;
						break;
						case ConexionWSRest.Enum_Exception.IOException:
							// Segmento de Lectura de Datos
							mensajeError = ConexionWSRest.Enum_MensajeError.mensajeLectura;
						break;
					}

					mensajeTransaccionBean.setDescripcion(mensajeError);
					throw new Exception(mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
				}
			}



			// El codigo de Exito de ISOTRX es 1 por lo cual se debe de Evaluar Si el mensaje es Diferente de 1 en los consumos de este método
			mensajeTransaccionBean.setNumero(Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]));
			mensajeTransaccionBean.setDescripcion(Constantes.STR_CODIGOEXITOISOTRX[1]);

		} catch (Exception exception){
			//Devolvemos codigo y mensaje de proceso fallido
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(Utileria.convierteEntero(Constantes.STR_ERROR_DAO[0]));
				mensajeTransaccionBean.setDescripcion(Constantes.STR_ERROR_DAO[1]);
			}
			exception.printStackTrace();
			loggerISOTRX.error("No se pudo realizar la Autentificación de Terceros con el Proveedor de Servicios: " + exception.getMessage());
			return mensajeTransaccionBean;
		}

		return mensajeTransaccionBean;
	}

	//consulta Tarjera Petición
	public IsoTrxBean consultaTarjetaPeticion(final TarjetaDebitoBean tarjetaDebitoBean, final int tipoProceso, final long numeroTransaccion){
		IsoTrxBean isoTrxBean = new IsoTrxBean();
		isoTrxBean = (IsoTrxBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" }) // Si existe Error Eliminar esta Parte
			public Object doInTransaction(TransactionStatus transaction) {
				IsoTrxBean bean = new IsoTrxBean();
				try {
					// Query con el Store Procedure
					bean = (IsoTrxBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							//Query con el Store Procedure
							String query = "CALL ISOTRXCON(?,?,?,?,?," +
														  "?," +
														  "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_TarjetaDebitoID", tarjetaDebitoBean.getTarjetaDebID());
							sentenciaStore.setDouble("Par_MontoOperacion", Constantes.DOUBLE_VACIO);
							sentenciaStore.setInt("Par_TipoInstrumento", Utileria.convierteEntero(tarjetaDebitoBean.getTipoInstrumento()));
							sentenciaStore.setLong("Par_NumeroInstrumento", Utileria.convierteLong(tarjetaDebitoBean.getNumeroInstrumento()));
							sentenciaStore.setInt("Par_TipoProceso", tipoProceso);

							sentenciaStore.setInt("Par_TipoConsulta", Enum_Con_ISOTRX.tarjetaPeticion);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "ISOTRXDAO.TarjetaPeticion");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
							loggerISOTRX.info(Constantes.NIVEL_DAO);
							loggerISOTRX.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							IsoTrxBean isoTrxBean = null;
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								isoTrxBean = new IsoTrxBean();
								ParamTarjetasBean paramTarjetasBean = new ParamTarjetasBean();
								TarjetaPeticionRequest tarjetaPeticionRequest = new TarjetaPeticionRequest();
								OperacionTarjetaRequest operacionTarjetaRequest = new OperacionTarjetaRequest();

								paramTarjetasBean.setAutorizaTerceroTranTD(resultadosStore.getString("AutorizaTerceroTranTD"));
								paramTarjetasBean.setRutaConWSAutoriza(resultadosStore.getString("RutaConWSAutoriza"));
								paramTarjetasBean.setTimeOutConWSAutoriza(resultadosStore.getString("TimeOutConWSAutoriza"));
								paramTarjetasBean.setUsuarioConWSAutoriza(resultadosStore.getString("UsuarioConWSAutoriza"));

								tarjetaPeticionRequest.setEmisorID(resultadosStore.getString("IDEmisor"));
								tarjetaPeticionRequest.setMensajeID(resultadosStore.getString("PrefijoEmisor"));
								tarjetaPeticionRequest.setComandoID(resultadosStore.getString("ComandoID"));
								tarjetaPeticionRequest.setFechaPeticion(resultadosStore.getString("FechaPeticion"));
								tarjetaPeticionRequest.setHoraPeticion(resultadosStore.getString("HoraPeticion"));

								tarjetaPeticionRequest.setNumeroTarjeta(resultadosStore.getString("NumeroTarjeta"));
								tarjetaPeticionRequest.setNumeroProxy(resultadosStore.getString("NumeroProxy"));
								tarjetaPeticionRequest.setNumeroCuenta(resultadosStore.getString("NumeroCuenta"));
								tarjetaPeticionRequest.setNombreTarjeta(resultadosStore.getString("NombreTarjeta"));
								tarjetaPeticionRequest.setEstatusTarjeta(resultadosStore.getString("EstatusTarjeta"));

								tarjetaPeticionRequest.setLimiteDisposicionDiario(resultadosStore.getString("LimiteDisposicionDiario"));
								tarjetaPeticionRequest.setLimiteComprasDiario(resultadosStore.getString("LimiteComprasDiario"));
								tarjetaPeticionRequest.setLimiteDisposicionMensual(resultadosStore.getString("LimiteDisposicionMensual"));
								tarjetaPeticionRequest.setLimiteComprasMensual(resultadosStore.getString("LimiteComprasMensual"));
								tarjetaPeticionRequest.setNumeroDisposicionesXDia(resultadosStore.getString("NumeroDisposicionesXDia"));

								isoTrxBean.setTipoTarjeta(resultadosStore.getString("TipoTarjeta"));
								isoTrxBean.setRutaConSAFIWS(resultadosStore.getString("RutaConSAFIWS"));
								isoTrxBean.setUsuarioConSAFIWS(resultadosStore.getString("UsuarioConSAFIWS"));

								isoTrxBean.setParamTarjetasBean(paramTarjetasBean);
								isoTrxBean.setTarjetaPeticionRequest(tarjetaPeticionRequest);
								isoTrxBean.setOperacionTarjetaRequest(operacionTarjetaRequest);
							}else{
								isoTrxBean = null;
							}
							return isoTrxBean;
						}
					});
					if(bean ==  null){
						loggerISOTRX.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Fallo. El Procedimiento no Regreso Ningun Resultado");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerISOTRX.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Información de Tarjeta Petición en ISOTRX ", exception);
				}
				return bean;
			}
		});
		return isoTrxBean;
	}

	// Proceso de Operación Petición
	public MensajeTransaccionBean operacionPeticion(final TarjetaDebitoBean tarjetaDebitoBean, final int tipoProceso, final long numeroTransaccion ){

		IsoTrxBean isoTrxBean = null;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		ConexionWSRest conexionWSRest = null;
		OperacionPeticionResponse operacionPeticionResponse = new OperacionPeticionResponse();
		IsotrxRequest isotrxRequest = null;

		try{

			mensajeTransaccionBean = new MensajeTransaccionBean();
			loggerISOTRX.info(Constantes.NIVEL_DAO);
			loggerISOTRX.info("Obteniendo Datos de la Tarjeta");
			isoTrxBean = consultaOperacionPeticion(tarjetaDebitoBean, tipoProceso, numeroTransaccion);
			if(isoTrxBean == null ) {
				mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[0]);
				mensajeTransaccionBean.setDescripcion("Error en la Consulta de los Parámetros de Autorización Terceros.");
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			loggerISOTRX.info("Los Parámetros de Autorización Terceros: " +  Utileria.logJsonFormat(isoTrxBean.getParamTarjetasBean()));
			tipoTarjeta = (Utileria.convierteEntero(isoTrxBean.getTipoTarjeta()) != 1) ? "DESCONOCIDA" :"TARJETA DE DÉBITO" ;
			loggerISOTRX.info("Tipo de Tarjeta: " +  tipoTarjeta);

			if( Utileria.convierteEntero(isoTrxBean.getTipoTarjeta()) == Constantes.tipoTarjeta.debito &&
				isoTrxBean.getParamTarjetasBean().getAutorizaTerceroTranTD().equals(Constantes.STRING_SI) ){

				isotrxRequest = armarJsonRequest(isoTrxBean, Armar_JSON.operacionPeticion);
				conexionWSRest = new ConexionWSRest(isoTrxBean.getRutaConSAFIWS());
				conexionWSRest.addHeader("autentificacion", isoTrxBean.getUsuarioConSAFIWS());
				operacionPeticionResponse = (OperacionPeticionResponse) conexionWSRest.peticionPOST(isotrxRequest, OperacionPeticionResponse.class, isoTrxBean.getParamTarjetasBean().getTimeOutConWSAutoriza(), Constantes.logger.ISOTRX);

				if( Utileria.convierteEntero(operacionPeticionResponse.getResultadoOperacion()) != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0])){

					mensajeTransaccionBean.setNumero(Utileria.convierteEntero(operacionPeticionResponse.getResultadoOperacion()));
					mensajeError = (operacionPeticionResponse.getMensajeRechazo() != null) ? "Error con el Proveedor de Servicios" : operacionPeticionResponse.getMensajeRechazo();

					switch(Utileria.convierteEntero(operacionPeticionResponse.getException())){
						case ConexionWSRest.Enum_Exception.SocketTimeoutException:
							// Segmento de Time Out
							mensajeError = ConexionWSRest.Enum_MensajeError.mensajeTimeOut;
						break;
						case ConexionWSRest.Enum_Exception.ClientProtocolException:
							// Segmento de Protocolos
							mensajeError = ConexionWSRest.Enum_MensajeError.mensajeProtocolo;
						break;
						case ConexionWSRest.Enum_Exception.IOException:
							// Segmento de Lectura de Datos
							mensajeError = ConexionWSRest.Enum_MensajeError.mensajeLectura;
						break;
					}

					mensajeTransaccionBean.setDescripcion(mensajeError);
					throw new Exception(mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
				}

			}
			// El codigo de Exito de ISOTRX es 1 por lo cual se debe de Evaluar Si el mensaje es Diferente de 1 en los consumos de este método
			mensajeTransaccionBean.setNumero(Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]));
			mensajeTransaccionBean.setDescripcion(Constantes.STR_CODIGOEXITOISOTRX[1]);

		} catch (Exception exception){
			//Devolvemos codigo y mensaje de proceso fallido
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(Utileria.convierteEntero(Constantes.STR_ERROR_DAO[0]));
				mensajeTransaccionBean.setDescripcion(Constantes.STR_ERROR_DAO[1]);
			}
			exception.printStackTrace();
			loggerISOTRX.error("No se pudo realizar la Autentificación de Terceros con el Proveedor de Servicios: " + exception.getMessage());
			return mensajeTransaccionBean;
		}

		return mensajeTransaccionBean;
	}

	//consulta Operación Petición
	public IsoTrxBean consultaOperacionPeticion(final TarjetaDebitoBean tarjetaDebitoBean, final int tipoProceso, final long numeroTransaccion){
		IsoTrxBean isoTrxBean = new IsoTrxBean();
		isoTrxBean = (IsoTrxBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" }) // Si existe Error Eliminar esta Parte
			public Object doInTransaction(TransactionStatus transaction) {
				IsoTrxBean bean = new IsoTrxBean();
				try {
					// Query con el Store Procedure
					bean = (IsoTrxBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							//Query con el Store Procedure
							String query = "CALL ISOTRXCON(?,?,?,?,?," +
														  "?," +
														  "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_TarjetaDebitoID", tarjetaDebitoBean.getTarjetaDebID());
							sentenciaStore.setDouble("Par_MontoOperacion", Utileria.convierteDoble(tarjetaDebitoBean.getMontoOperacion()));
							sentenciaStore.setInt("Par_TipoInstrumento", Utileria.convierteEntero(tarjetaDebitoBean.getTipoInstrumento()));
							sentenciaStore.setLong("Par_NumeroInstrumento", Utileria.convierteLong(tarjetaDebitoBean.getNumeroInstrumento()));
							sentenciaStore.setInt("Par_TipoProceso", tipoProceso);

							sentenciaStore.setInt("Par_TipoConsulta", Enum_Con_ISOTRX.operacionPeticion);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "ISOTRXDAO.OperacionPeticion");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
							loggerISOTRX.info(Constantes.NIVEL_DAO);
							loggerISOTRX.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							IsoTrxBean isoTrxBean = null;
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								isoTrxBean = new IsoTrxBean();
								ParamTarjetasBean paramTarjetasBean = new ParamTarjetasBean();
								TarjetaPeticionRequest tarjetaPeticionRequest = new TarjetaPeticionRequest();
								OperacionTarjetaRequest operacionTarjetaRequest = new OperacionTarjetaRequest();

								paramTarjetasBean.setAutorizaTerceroTranTD(resultadosStore.getString("AutorizaTerceroTranTD"));
								paramTarjetasBean.setRutaConWSAutoriza(resultadosStore.getString("RutaConWSAutoriza"));
								paramTarjetasBean.setTimeOutConWSAutoriza(resultadosStore.getString("TimeOutConWSAutoriza"));
								paramTarjetasBean.setUsuarioConWSAutoriza(resultadosStore.getString("UsuarioConWSAutoriza"));

								operacionTarjetaRequest.setEmisorID(resultadosStore.getString("IDEmisor"));
								operacionTarjetaRequest.setMensajeID(resultadosStore.getString("PrefijoEmisor"));
								operacionTarjetaRequest.setTipoOperacion(resultadosStore.getString("TipoOperacion"));
								operacionTarjetaRequest.setFechaPeticion(resultadosStore.getString("FechaPeticion"));
								operacionTarjetaRequest.setHoraPeticion(resultadosStore.getString("HoraPeticion"));

								operacionTarjetaRequest.setNumeroAfiliacion(resultadosStore.getString("NumeroAfiliacion"));
								operacionTarjetaRequest.setNombreComercio(resultadosStore.getString("NombreComercio"));
								operacionTarjetaRequest.setNumeroCuenta(resultadosStore.getString("NumeroCuenta"));
								operacionTarjetaRequest.setNumeroTarjeta(resultadosStore.getString("NumeroTarjeta"));
								operacionTarjetaRequest.setCodigoMoneda(resultadosStore.getString("CodigoMoneda"));

								operacionTarjetaRequest.setMontoTransaccion(resultadosStore.getString("MontoTransaccion"));
								operacionTarjetaRequest.setMontoAdicional(resultadosStore.getString("MontoAdicional"));
								operacionTarjetaRequest.setMontoComision(resultadosStore.getString("MontoComision"));
								operacionTarjetaRequest.setOriCodigoAutorizacion(resultadosStore.getString("OriCodigoAutorizacion"));

								isoTrxBean.setTipoTarjeta(resultadosStore.getString("TipoTarjeta"));
								isoTrxBean.setRutaConSAFIWS(resultadosStore.getString("RutaConSAFIWS"));
								isoTrxBean.setUsuarioConSAFIWS(resultadosStore.getString("UsuarioConSAFIWS"));

								isoTrxBean.setParamTarjetasBean(paramTarjetasBean);
								isoTrxBean.setTarjetaPeticionRequest(tarjetaPeticionRequest);
								isoTrxBean.setOperacionTarjetaRequest(operacionTarjetaRequest);
							}else{
								isoTrxBean = null;
							}
							return isoTrxBean;
						}
					});
					if(bean ==  null){
						loggerISOTRX.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Fallo. El Procedimiento no Regreso Ningun Resultado");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}
				} catch (Exception exception) {
					bean = null;
					exception.printStackTrace();
					loggerISOTRX.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Información de Operación Petición en Tarjetas ISOTRX ", exception);
				}
				return bean;
			}
		});
		return isoTrxBean;
	}

	public IsotrxRequest armarJsonRequest(IsoTrxBean isoTrxBean, int tipoOperacion){

		IsotrxRequest isotrxRequest = null;
		ParamTarjetasRequest paramTarjetasRequest = null;
		TarjetaPeticionRequest tarjetaPeticionRequest = null;
		OperacionTarjetaRequest operacionTarjetaRequest = null;

		try{

			switch( tipoOperacion ){
				case Armar_JSON.tarjetaPeticion:
					loggerISOTRX.info("Iniciando Armando JSON tarjetaPeticion");
				break;
				case Armar_JSON.operacionPeticion:
					loggerISOTRX.info("Iniciando Armando JSON OperacionPeticion");
				break;
			}

			isotrxRequest = new IsotrxRequest();
			paramTarjetasRequest = new ParamTarjetasRequest();
			tarjetaPeticionRequest = new TarjetaPeticionRequest();
			operacionTarjetaRequest = new OperacionTarjetaRequest();

			paramTarjetasRequest.setRutaConWSAutoriza(isoTrxBean.getParamTarjetasBean().getRutaConWSAutoriza());
			paramTarjetasRequest.setTimeOutConWSAutoriza(isoTrxBean.getParamTarjetasBean().getTimeOutConWSAutoriza());
			paramTarjetasRequest.setUsuarioConWSAutoriza(isoTrxBean.getParamTarjetasBean().getUsuarioConWSAutoriza());

			tarjetaPeticionRequest = isoTrxBean.getTarjetaPeticionRequest();
			operacionTarjetaRequest = isoTrxBean.getOperacionTarjetaRequest();

			isotrxRequest.setParamTarjetasRequest(paramTarjetasRequest);
			isotrxRequest.setTarjetaPeticionRequest(tarjetaPeticionRequest);
			isotrxRequest.setOperacionTarjetaRequest(operacionTarjetaRequest);

			switch( tipoOperacion ){
				case Armar_JSON.tarjetaPeticion:
					loggerISOTRX.info("Finalizando Armando JSON tarjetaPeticion");
				break;
				case Armar_JSON.operacionPeticion:
					loggerISOTRX.info("Finalizando Armando JSON OperacionPeticion");
				break;
			}

		} catch (Exception exception){
			///Devolvemos codigo y mensaje de proceso fallido
			isotrxRequest = null;
			exception.printStackTrace();
			loggerISOTRX.error("Error al Armar el JSON OperacionPeticion: " + exception.getMessage());
		}

		return isotrxRequest;

	}
}
