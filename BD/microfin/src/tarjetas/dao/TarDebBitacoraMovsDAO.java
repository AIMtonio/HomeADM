package tarjetas.dao;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import tarjetas.bean.TarDebBitacoraMovsBean;

public class TarDebBitacoraMovsDAO extends BaseDAO{

	public TarDebBitacoraMovsDAO(){
		super();
	}

	public static interface Enum_Tra_Movs{
		int procesa	= 1;
	}

	PolizaDAO				polizaDAO				= null;
	public static String polizaAutomatica		= "A";
	public static String conta_tarjeta			= "42";

	public MensajeTransaccionBean procesaCheckin(final TarDebBitacoraMovsBean tarDebBitacoraMovsBean , final int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				tarDebBitacoraMovsBean.setMontoTransac(String.valueOf(tarDebBitacoraMovsBean.getMontoTransac()).replace(".", ""));
				tarDebBitacoraMovsBean.setFechaSistema(String.valueOf(tarDebBitacoraMovsBean.getFechaSistema().substring(2).replaceAll(":", "").replaceAll("-", "")));
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {

					String query = "call TARDEBTRANSPRO(?,?,?,?,?, ?,?,?,?,?, "
													+ "	?,?,?,?,?, ?,?,?,?,? );";
					Object[] parametros = {
							tarDebBitacoraMovsBean.getTipoMensaje(),
							tarDebBitacoraMovsBean.getOperacion(),
							tarDebBitacoraMovsBean.getNumtarjeta(),
							tarDebBitacoraMovsBean.getOrigenInst(),
							Utileria.completaCerosIzquierda(tarDebBitacoraMovsBean.getMontoTransac(),12),

							tarDebBitacoraMovsBean.getFechaSistema(),
							parametrosAuditoriaBean.getNumeroTransaccion(),
							tarDebBitacoraMovsBean.getGiroNegocio(),
							Constantes.STRING_VACIO,
							tarDebBitacoraMovsBean.getPuntoEntrada(),

							tarDebBitacoraMovsBean.getUbicaTerminal(),
							Constantes.STRING_VACIO,
							tarDebBitacoraMovsBean.getCodigoMonOpe(),
							Utileria.completaCerosIzquierda(Constantes.STRING_CERO, 12),
							Utileria.completaCerosIzquierda(Constantes.STRING_CERO, 12),

							Utileria.completaCerosIzquierda(Constantes.STRING_CERO, 12),
							tarDebBitacoraMovsBean.getReferencia(),
							Constantes.STRING_VACIO,
							tarDebBitacoraMovsBean.getCheckIn(),
							tarDebBitacoraMovsBean.getCodigoAprobacion()

					};


					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBTRANSPRO(" + Arrays.toString(parametros) +")");

					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

							mensaje.setConsecutivoInt(resultSet.getString("NumeroTransaccion"));
							mensaje.setDescripcion("Transaccion Realizada Exitosamente");
							mensaje.setNombreControl(resultSet.getString("SaldoDisponibleAct"));
							mensaje.setNumero(Integer.valueOf(resultSet.getString("CodigoRespuesta")).intValue());
							mensaje.setCampoGenerico(resultSet.getString("FechaAplicacion"));

							return mensaje;

						}

					});

					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {

					if(mensajeBean.getNumero()==0){

						mensajeBean.setNumero(999);

					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al procesar los Movimientos Grid", e);
					transaction.setRollbackOnly();
				}

				return mensajeBean;
			}
		});

		return mensaje;
	}


	public List consultaCheckin( int tipoConsulta){
		List segtoProductos = null ;
		try{
			String query = "call TARDEBBITACORAMOVSLIS(?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.FECHA_VACIA,
					Constantes.FECHA_VACIA,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TarDebBitacoraMovs.consultaSegtoProducto",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBBITACORAMOVSLIS(" +Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarDebBitacoraMovsBean tarDebBitacoraMovs = new TarDebBitacoraMovsBean();
					tarDebBitacoraMovs.setNumtarjeta(resultSet.getString("TarjetaDebID"));
					tarDebBitacoraMovs.setOperacion(resultSet.getString("TipoOperacionID"));
					tarDebBitacoraMovs.setCliente(resultSet.getString("NombreCompleto"));
					tarDebBitacoraMovs.setNumCta(resultSet.getString("CuentaAhoID"));
					tarDebBitacoraMovs.setMontoTransac(resultSet.getString("MontoOpe"));
					tarDebBitacoraMovs.setTipoMensaje(resultSet.getString("TipoMensaje"));
					tarDebBitacoraMovs.setOrigenInst(resultSet.getString("OrigenInst"));
					tarDebBitacoraMovs.setFechaSistema(resultSet.getString("FechaSistema"));
					tarDebBitacoraMovs.setNumTransaccion(resultSet.getString("NumTransaccion"));
					tarDebBitacoraMovs.setGiroNegocio(resultSet.getString("GiroNegocio"));
					tarDebBitacoraMovs.setPuntoEntrada(resultSet.getString("PuntoEntrada"));
					tarDebBitacoraMovs.setCodigoMonOpe(resultSet.getString("CodigoMonOpe"));
					tarDebBitacoraMovs.setCheckIn(resultSet.getString("CheckIn"));
					tarDebBitacoraMovs.setCodigoAprobacion(resultSet.getString("CodigoAprobacion"));
					tarDebBitacoraMovs.setUbicaTerminal(resultSet.getString("NombreUbicaTer"));
					tarDebBitacoraMovs.setEsIsotrx(resultSet.getString("EsIsotrx"));
					tarDebBitacoraMovs.setTarDebMovID(resultSet.getString("TarDebMovID"));
					return tarDebBitacoraMovs;
				}
			});
			segtoProductos =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Checkout por producto", e);
		}
		return segtoProductos;
	}

	/**Descripcion: Metodo para realizar el alta de bitacora de respuesta de isotrx
	 * */
	public MensajeTransaccionBean altaBitacoraRespuestaIsotrx(final TarDebBitacoraMovsBean tarDebBitacoraMovsBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ISOTRXTARDEBBITACORARESPALT(" +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,		" +
											"?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_NumeroTarjeta", tarDebBitacoraMovsBean.getNumtarjeta());
									sentenciaStore.setString("Par_TipoMensaje", tarDebBitacoraMovsBean.getTipoMensaje());
									sentenciaStore.setInt("Par_TipoOperacionID", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTipoOperacionID()));
									sentenciaStore.setDate("Par_FechaHrOpe", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setDouble("Par_MontoTransaccion", Utileria.convierteDoble(tarDebBitacoraMovsBean.getMontoTransac()));

									sentenciaStore.setString("Par_TerminalID", tarDebBitacoraMovsBean.getPuntoEntrada());
									sentenciaStore.setString("Par_Referencia", tarDebBitacoraMovsBean.getCodigoAprobacion());
									sentenciaStore.setLong("Par_NumTransResp", parametrosAuditoriaBean.getNumeroTransaccion());
									sentenciaStore.setString("Par_SaldoContableAct", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_SaldoDispoAct", Constantes.STRING_VACIO);

									sentenciaStore.setString("Par_CodigoRespuesta", tarDebBitacoraMovsBean.getCodigoRespuesta());
									sentenciaStore.setString("Par_MensajeRespuesta", tarDebBitacoraMovsBean.getMensajeRespuesta());
									sentenciaStore.setString("Par_FechaOperacion", tarDebBitacoraMovsBean.getFechaOperacion());
									sentenciaStore.setString("Par_HoraOperacion", tarDebBitacoraMovsBean.getHoraTransaccion());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("control"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de bitacora de respuesta de ISOTRX", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	/**Descripcion: Metodo para realizar el alta de bitacora de entrada de isotrx
	 * */
	public MensajeTransaccionBean altaBitacoraEntradaIsotrx(final TarDebBitacoraMovsBean tarDebBitacoraMovsBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ISOTRXTARDEBBITACORAMOVSALT(" +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_EmisorID", Utileria.convierteEntero(tarDebBitacoraMovsBean.getEmisorID()));
									sentenciaStore.setString("Par_MensajeID", tarDebBitacoraMovsBean.getMensajeID());
									sentenciaStore.setInt("Par_TipoOperacion", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTipoOperacionID()));
									sentenciaStore.setInt("Par_ResultadoOperacion", Utileria.convierteEntero(tarDebBitacoraMovsBean.getResultadoOperacion()));
									sentenciaStore.setInt("Par_EstatusOperacion", Utileria.convierteEntero(tarDebBitacoraMovsBean.getEstatusOperacion()));

									sentenciaStore.setString("Par_FechaOperacion", tarDebBitacoraMovsBean.getFechaOperacion());
									sentenciaStore.setString("Par_HoraOperacion", tarDebBitacoraMovsBean.getHoraOperacion());
									sentenciaStore.setString("Par_CodigoRespuesta", tarDebBitacoraMovsBean.getCodigoRespuesta());
									sentenciaStore.setString("Par_CodigoAutorizacion", tarDebBitacoraMovsBean.getCodigoAprobacion());
									sentenciaStore.setInt("Par_CodigoRechazo", Utileria.convierteEntero(tarDebBitacoraMovsBean.getCodigoRechazo()));

									sentenciaStore.setInt("Par_GiroComercial", Utileria.convierteEntero(tarDebBitacoraMovsBean.getGiroNegocio()));
									sentenciaStore.setInt("Par_NumeroAfiliacion", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTerminalID()));
									sentenciaStore.setString("Par_NombreComercio", tarDebBitacoraMovsBean.getNombreUbicaTer());
									sentenciaStore.setInt("Par_ModoEntrada", Utileria.convierteEntero(tarDebBitacoraMovsBean.getModoEntrada()));
									sentenciaStore.setInt("Par_PuntoAcceso", Utileria.convierteEntero(tarDebBitacoraMovsBean.getPuntoEntrada()));

									sentenciaStore.setLong("Par_NumeroCuenta", Utileria.convierteLong(tarDebBitacoraMovsBean.getNumeroCuenta()));
									sentenciaStore.setString("Par_NumeroTarjeta", tarDebBitacoraMovsBean.getTarjetaDebID());
									sentenciaStore.setInt("Par_CodigoMoneda", Utileria.convierteEntero(tarDebBitacoraMovsBean.getCodigoMonOpe()));
									sentenciaStore.setDouble("Par_MontoTransaccion", Utileria.convierteDoble(tarDebBitacoraMovsBean.getMontoOpe()));
									sentenciaStore.setDouble("Par_MontoAdicional", Utileria.convierteDoble(tarDebBitacoraMovsBean.getMontosAdiciona()));

									sentenciaStore.setDouble("Par_MontoRemplazo", Utileria.convierteDoble(tarDebBitacoraMovsBean.getMontoRemplazo()));
									sentenciaStore.setDouble("Par_MontoComision", Utileria.convierteDoble(tarDebBitacoraMovsBean.getMontoSurcharge()));
									sentenciaStore.setString("Par_FechaTransaccion", tarDebBitacoraMovsBean.getFechaTransaccion());
									sentenciaStore.setString("Par_HoraTransaccion", tarDebBitacoraMovsBean.getHoraTransaccion());
									sentenciaStore.setDouble("Par_SaldoDisponible", Utileria.convierteDoble(tarDebBitacoraMovsBean.getSaldoDisponible()));

									sentenciaStore.setInt("Par_ProDiferimiento", Utileria.convierteEntero(tarDebBitacoraMovsBean.getProDiferimiento()));
									sentenciaStore.setInt("Par_ProNumeroPagos", Utileria.convierteEntero(tarDebBitacoraMovsBean.getProNumeroPagos()));
									sentenciaStore.setInt("Par_ProTipoPlan", Utileria.convierteEntero(tarDebBitacoraMovsBean.getProTipoPlan()));
									sentenciaStore.setString("Par_OriCodigoAutorizacion", tarDebBitacoraMovsBean.getCodigoAprobacion());
									sentenciaStore.setString("Par_OriFechaTransaccion", tarDebBitacoraMovsBean.getOriFechaTransaccion());

									sentenciaStore.setString("Par_OriHoraTransaccion", tarDebBitacoraMovsBean.getHoraOperacion());
									sentenciaStore.setLong("Par_DesNumeroCuenta", Utileria.convierteLong(tarDebBitacoraMovsBean.getDesNumeroCuenta()));
									sentenciaStore.setString("Par_DesNumeroTarjeta", tarDebBitacoraMovsBean.getDesNumeroTarjeta());
									sentenciaStore.setString("Par_TrsClaveRastreo", tarDebBitacoraMovsBean.getTrsClaveRastreo());
									sentenciaStore.setInt("Par_TrsInstitucionRemitente", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTrsInstitucionRemitente()));

									sentenciaStore.setString("Par_TrsNombreEmisor", tarDebBitacoraMovsBean.getTrsNombreEmisor());
									sentenciaStore.setInt("Par_TrsTipoCuentaRemitente", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTrsTipoCuentaRemitente()));
									sentenciaStore.setString("Par_TrsCuentaRemitente", tarDebBitacoraMovsBean.getTrsCuentaRemitente());
									sentenciaStore.setString("Par_TrsConceptoPago", tarDebBitacoraMovsBean.getTrsConceptoPago());
									sentenciaStore.setInt("Par_TrsReferenciaNumerica", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTrsReferenciaNumerica()));

									sentenciaStore.registerOutParameter("Par_TarDebMovID", Types.INTEGER);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_ErrLog", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion((resultadosStore.getString("ErrMen")));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de bitacora de entrada de ISOTRX", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**Descripcion: Metodo que realiza la transaccion reporte de isotrx
	 * */
	public MensajeTransaccionBean transaccionReporteIsotrx(final TarDebBitacoraMovsBean tarDebBitacoraMovsBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ISOTRXTRANSACCREPORTEPRO(" +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_EmisorID", Utileria.convierteEntero(tarDebBitacoraMovsBean.getEmisorID()));
									sentenciaStore.setString("Par_MensajeID", tarDebBitacoraMovsBean.getMensajeID());
									sentenciaStore.setInt("Par_TipoOperacion", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTipoOperacionID()));
									sentenciaStore.setInt("Par_ResultadoOperacion", Utileria.convierteEntero(tarDebBitacoraMovsBean.getResultadoOperacion()));
									sentenciaStore.setInt("Par_EstatusOperacion", Utileria.convierteEntero(tarDebBitacoraMovsBean.getEstatusOperacion()));

									sentenciaStore.setString("Par_FechaOperacion", tarDebBitacoraMovsBean.getFechaOperacion());
									sentenciaStore.setString("Par_HoraOperacion", tarDebBitacoraMovsBean.getHoraOperacion());
									sentenciaStore.setString("Par_CodigoRespuesta", tarDebBitacoraMovsBean.getCodigoRespuesta());
									sentenciaStore.setString("Par_CodigoAutorizacion", tarDebBitacoraMovsBean.getCodigoAprobacion());
									sentenciaStore.setInt("Par_CodigoRechazo", Utileria.convierteEntero(tarDebBitacoraMovsBean.getCodigoRechazo()));

									sentenciaStore.setInt("Par_GiroComercial", Utileria.convierteEntero(tarDebBitacoraMovsBean.getGiroNegocio()));
									sentenciaStore.setInt("Par_NumeroAfiliacion", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTerminalID()));
									sentenciaStore.setString("Par_NombreComercio", tarDebBitacoraMovsBean.getNombreUbicaTer());
									sentenciaStore.setInt("Par_ModoEntrada", Utileria.convierteEntero(tarDebBitacoraMovsBean.getModoEntrada()));
									sentenciaStore.setInt("Par_PuntoAcceso", Utileria.convierteEntero(tarDebBitacoraMovsBean.getPuntoEntrada()));

									sentenciaStore.setLong("Par_NumeroCuenta", Utileria.convierteLong(tarDebBitacoraMovsBean.getNumeroCuenta()));
									sentenciaStore.setString("Par_NumeroTarjeta", tarDebBitacoraMovsBean.getTarjetaDebID());
									sentenciaStore.setInt("Par_CodigoMoneda", Utileria.convierteEntero(tarDebBitacoraMovsBean.getCodigoMonOpe()));
									sentenciaStore.setDouble("Par_MontoTransaccion", Utileria.convierteDoble(tarDebBitacoraMovsBean.getMontoOpe()));
									sentenciaStore.setDouble("Par_MontoAdicional", Utileria.convierteDoble(tarDebBitacoraMovsBean.getMontosAdiciona()));

									sentenciaStore.setDouble("Par_MontoRemplazo", Utileria.convierteDoble(tarDebBitacoraMovsBean.getMontoRemplazo()));
									sentenciaStore.setDouble("Par_MontoComision", Utileria.convierteDoble(tarDebBitacoraMovsBean.getMontoSurcharge()));
									sentenciaStore.setString("Par_FechaTransaccion", tarDebBitacoraMovsBean.getFechaTransaccion());
									sentenciaStore.setString("Par_HoraTransaccion", tarDebBitacoraMovsBean.getHoraTransaccion());
									sentenciaStore.setDouble("Par_SaldoDisponible", Utileria.convierteDoble(tarDebBitacoraMovsBean.getSaldoDisponible()));

									sentenciaStore.setInt("Par_ProDiferimiento", Utileria.convierteEntero(tarDebBitacoraMovsBean.getProDiferimiento()));
									sentenciaStore.setInt("Par_ProNumeroPagos", Utileria.convierteEntero(tarDebBitacoraMovsBean.getProNumeroPagos()));
									sentenciaStore.setInt("Par_ProTipoPlan", Utileria.convierteEntero(tarDebBitacoraMovsBean.getProTipoPlan()));
									sentenciaStore.setString("Par_OriCodigoAutorizacion", tarDebBitacoraMovsBean.getCodigoAprobacion());
									sentenciaStore.setString("Par_OriFechaTransaccion", tarDebBitacoraMovsBean.getOriFechaTransaccion());

									sentenciaStore.setString("Par_OriHoraTransaccion", tarDebBitacoraMovsBean.getHoraOperacion());
									sentenciaStore.setLong("Par_DesNumeroCuenta", Utileria.convierteLong(tarDebBitacoraMovsBean.getDesNumeroCuenta()));
									sentenciaStore.setString("Par_DesNumeroTarjeta", tarDebBitacoraMovsBean.getDesNumeroTarjeta());
									sentenciaStore.setString("Par_TrsClaveRastreo", tarDebBitacoraMovsBean.getTrsClaveRastreo());
									sentenciaStore.setInt("Par_TrsInstitucionRemitente", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTrsInstitucionRemitente()));

									sentenciaStore.setString("Par_TrsNombreEmisor", tarDebBitacoraMovsBean.getTrsNombreEmisor());
									sentenciaStore.setInt("Par_TrsTipoCuentaRemitente", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTrsTipoCuentaRemitente()));
									sentenciaStore.setString("Par_TrsCuentaRemitente", tarDebBitacoraMovsBean.getTrsCuentaRemitente());
									sentenciaStore.setString("Par_TrsConceptoPago", tarDebBitacoraMovsBean.getTrsConceptoPago());
									sentenciaStore.setInt("Par_TrsReferenciaNumerica", Utileria.convierteEntero(tarDebBitacoraMovsBean.getTrsReferenciaNumerica()));

									sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(tarDebBitacoraMovsBean.getPolizaID()));
									sentenciaStore.setInt("Par_TarDebMovID", Utileria.convierteEntero(tarDebBitacoraMovsBean.getMovIsotrxD()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de la transaccion pos autorizacion de ISOTRX", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Descripcion Metodo que realiza la consulta de la bitacora de movimientos de tarjetas.
	 * */
	public TarDebBitacoraMovsBean consultaMovsIsotrx(TarDebBitacoraMovsBean tarDebBitacoraMovsBean, int tipoConsulta) {
			String query = "CALL ISOTRXTARDEBBITACORAMOVSCON(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(tarDebBitacoraMovsBean.getTarDebMovID()),
					tarDebBitacoraMovsBean.getNumtarjeta(),
					Utileria.convierteEntero(tarDebBitacoraMovsBean.getTipoOperacionID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					tarDebBitacoraMovsBean.getUsuario(),
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			//loggeo de jQuery en llamadas al store procedure
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL ISOTRXTARDEBBITACORAMOVSCON(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarDebBitacoraMovsBean movsBean = new TarDebBitacoraMovsBean();
					try {
						movsBean.setTarDebMovID(resultSet.getString("TarDebMovID"));
						movsBean.setTipoMensaje(resultSet.getString("TipoMensaje"));
						movsBean.setTipoOperacionID(resultSet.getString("TipoOperacionID"));
						movsBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
						movsBean.setOrigenInst(resultSet.getString("OrigenInst"));
						movsBean.setMontoOpe(resultSet.getString("MontoOpe"));
						movsBean.setFechaTransaccion(resultSet.getString("FechaTransaccion"));
						movsBean.setHoraTransaccion(resultSet.getString("HoraTransaccion"));
						movsBean.setNumeroTran(resultSet.getString("NumeroTran"));
						movsBean.setGiroNegocio(resultSet.getString("GiroNegocio"));
						movsBean.setPuntoEntrada(resultSet.getString("PuntoEntrada"));
						movsBean.setTerminalID(resultSet.getString("TerminalID"));
						movsBean.setNombreUbicaTer(resultSet.getString("NombreUbicaTer"));
						movsBean.setNip(resultSet.getString("NIP"));
						movsBean.setCodigoMonOpe(resultSet.getString("CodigoMonOpe"));
						movsBean.setMontosAdiciona(resultSet.getString("MontosAdiciona"));
						movsBean.setMontoSurcharge(resultSet.getString("MontoSurcharge"));
						movsBean.setMontoLoyaltyfee(resultSet.getString("MontoLoyaltyfee"));
						movsBean.setReferencia(resultSet.getString("Referencia"));
						movsBean.setDatosTiempoAire(resultSet.getString("DatosTiempoAire"));
						movsBean.setEstatusConcilia(resultSet.getString("EstatusConcilia"));
						movsBean.setFolioConcilia(resultSet.getString("FolioConcilia"));
						movsBean.setDetalleConciliaID(resultSet.getString("DetalleConciliaID"));
						movsBean.setTransEnLinea(resultSet.getString("TransEnLinea"));
						movsBean.setCheckIn(resultSet.getString("CheckIn"));
						movsBean.setCodigoAprobacion(resultSet.getString("CodigoAprobacion"));
						movsBean.setEstatus(resultSet.getString("Estatus"));
						movsBean.setEmisorID(resultSet.getString("EmisorID"));
						movsBean.setMensajeID(resultSet.getString("MensajeID"));
						movsBean.setModoEntrada(resultSet.getString("ModoEntrada"));
						movsBean.setResultadoOperacion(resultSet.getString("ResultadoOperacion"));
						movsBean.setEstatusOperacion(resultSet.getString("EstatusOperacion"));
						movsBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
						movsBean.setHoraOperacion(resultSet.getString("HoraOperacion"));
						movsBean.setCodigoRespuesta(resultSet.getString("CodigoRespuesta"));
						movsBean.setCodigoRechazo(resultSet.getString("CodigoRechazo"));
						movsBean.setNumeroCuenta(resultSet.getString("NumeroCuenta"));
						movsBean.setMontoRemplazo(resultSet.getString("MontoRemplazo"));
						movsBean.setSaldoDisponible(resultSet.getString("SaldoDisponible"));
						movsBean.setProDiferimiento(resultSet.getString("ProDiferimiento"));
						movsBean.setProNumeroPagos(resultSet.getString("ProNumeroPagos"));
						movsBean.setProTipoPlan(resultSet.getString("ProTipoPlan"));
						movsBean.setOriCodigoAutorizacion(resultSet.getString("OriCodigoAutorizacion"));
						movsBean.setOriFechaTransaccion(resultSet.getString("OriFechaTransaccion"));
						movsBean.setOriHoraTransaccion(resultSet.getString("OriHoraTransaccion"));
						movsBean.setDesNumeroCuenta(resultSet.getString("DesNumeroCuenta"));
						movsBean.setDesNumeroTarjeta(resultSet.getString("DesNumeroTarjeta"));
						movsBean.setTrsClaveRastreo(resultSet.getString("TrsClaveRastreo"));
						movsBean.setTrsInstitucionRemitente(resultSet.getString("TrsInstitucionRemitente"));
						movsBean.setTrsNombreEmisor(resultSet.getString("TrsNombreEmisor"));
						movsBean.setTrsTipoCuentaRemitente(resultSet.getString("TrsTipoCuentaRemitente"));
						movsBean.setTrsCuentaRemitente(resultSet.getString("TrsCuentaRemitente"));
						movsBean.setTrsConceptoPago(resultSet.getString("TrsConceptoPago"));
					} catch (Exception ex) {
						loggerSAFI.info("Error al realizar consulta de movimientos de ISOTRX:" + ex.getMessage(), ex);
						ex.printStackTrace();
					}
					return movsBean;

				}
			});

			return matches.size() > 0 ? (TarDebBitacoraMovsBean) matches.get(0) : null;
		}


		/**
		 * Descripcion: Metodo que realiza el proceso de transaccion reporte
		 **/
		public MensajeTransaccionBean procesaTransaccionReporte(final TarDebBitacoraMovsBean tarDebBitacoraMovsBean) {
			MensajeTransaccionBean mensaje = null;
			MensajeTransaccionBean mensajeRespuesta = null;
			int tarDebMovID = 0;

			//Se genera un numero de transaccion unico
			transaccionDAO.generaNumeroTransaccion();

			loggerSAFI.info("PROCESO DE ALTA DE BITACORA DE ENTRADA DE ISOTRX [procesaTransaccionReporte]");

			/** ------------------- Bitacora de entrada -------------------*/
			mensaje = altaBitacoraEntradaIsotrx(tarDebBitacoraMovsBean);
			//Se evalua la respuesta de isotrx
			if(mensaje.getNumero() != Constantes.CODIGO_SIN_ERROR) {
				/** ------------------- Bitacora de Respuesta -------------------*/

				loggerSAFI.info("Ocurrio un error al registrar la bitacora de Entrada de Isotrx " + mensaje.getDescripcion());
				//Si truena la bitacora de entrada, siempre se debe de grabar la bitacora de respuesta
				mensajeRespuesta = null;
				tarDebBitacoraMovsBean.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
				tarDebBitacoraMovsBean.setMensajeRespuesta(mensaje.getConsecutivoString());
				mensajeRespuesta = altaBitacoraRespuestaIsotrx(tarDebBitacoraMovsBean);

				//Se evalua la respuesta de isotrx
				if(mensajeRespuesta.getNumero() != Constantes.CODIGO_SIN_ERROR) {
					loggerSAFI.info("Ocurrio un error al registrar la bitacora de Respuesta de Isotrx " + mensajeRespuesta.getDescripcion());
				}
				return mensaje;
			}

			loggerSAFI.info("TERMINA PROCESO DE ALTA DE BITACORA DE ENTRADA DE ISOTRX [procesaTransaccionReporte]");

			//Se guarda el id de la bitacora
			tarDebBitacoraMovsBean.setMovIsotrxD(mensaje.getConsecutivoString());

			final PolizaBean polizaBean=new PolizaBean();

			polizaBean.setEmpresaID(String.valueOf(parametrosAuditoriaBean.getEmpresaID()));
			polizaBean.setFecha(String.valueOf(parametrosAuditoriaBean.getFecha()));
			polizaBean.setTipo(polizaAutomatica);
			polizaBean.setConceptoID(conta_tarjeta);
			polizaBean.setConcepto("REVERSO DISPOSICIÓN" + tarDebBitacoraMovsBean.getNombreUbicaTer());

			loggerSAFI.info("INICIO DE TRANSACCION PARA GENERAR POLIZA DE ISOTRX");
			int	contador  = 0;
			while(contador <= PolizaBean.numIntentosGeneraPoliza){
				contador ++;
				polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
					break;
				}
			}

			tarDebBitacoraMovsBean.setPolizaID(polizaBean.getPolizaID());
			loggerSAFI.info("TERMINA TRANSACCION GENERACION POLIZA DE ISOTRX");


			loggerSAFI.info("INICIA TRANSACCION DE LA OPERACION POS AUTORIZACION DE ISOTRX");
			mensaje = null;

			/** ------------------- Transaccion Reporte -------------------*/
			//La operacion pos autorizacion corresponde el id del catalogo CATTIPOPERACIONISOTRX
			tarDebBitacoraMovsBean.setTipoOperacionID("16");
			mensaje = transaccionReporteIsotrx(tarDebBitacoraMovsBean);
			//Se evalua la respuesta de isotrx
			if(mensaje.getNumero() != Constantes.CODIGO_SIN_ERROR) {
				/** ------------------- Bitacora de Respuesta -------------------*/
				loggerSAFI.info("Ocurrio un error al registrar la operacion pos Autorizacion de Isotrx " + mensaje.getDescripcion());
				//Si truena la bitacora de entrada, siempre se debe de grabar la bitacora de respuesta
				mensajeRespuesta = null;
				tarDebBitacoraMovsBean.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
				tarDebBitacoraMovsBean.setMensajeRespuesta(mensaje.getConsecutivoString());
				mensajeRespuesta = altaBitacoraRespuestaIsotrx(tarDebBitacoraMovsBean);

				//Se borra la poliza
				bajaPolizaIsotrx(tarDebBitacoraMovsBean);

				//Se evalua la respuesta de isotrx
				if(mensajeRespuesta.getNumero() != Constantes.CODIGO_SIN_ERROR) {
					loggerSAFI.info("Ocurrio un error al registrar la bitacora de Respuesta de Isotrx " + mensajeRespuesta.getDescripcion());
				}
				return mensaje;
			}

			//Si no hubo ningun error, siempre se registra en la bitacora
			loggerSAFI.info("TERMINA TRANSACCION DE LA OPERACION POS AUTORIZACION DE ISOTRX");

			/** ------------------- Bitacora de Respuesta -------------------*/
			mensajeRespuesta = null;
			tarDebBitacoraMovsBean.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
			tarDebBitacoraMovsBean.setMensajeRespuesta(mensaje.getConsecutivoString());
			mensajeRespuesta = altaBitacoraRespuestaIsotrx(tarDebBitacoraMovsBean);

			//Se evalua la respuesta de isotrx
			if(mensajeRespuesta.getNumero() != Constantes.CODIGO_SIN_ERROR) {
				loggerSAFI.info("Ocurrio un error al registrar la bitacora de Respuesta de Isotrx " + mensajeRespuesta.getDescripcion());
				return mensajeRespuesta;
			}



			return mensaje;
		}

		public MensajeTransaccionBean bajaPolizaIsotrx(TarDebBitacoraMovsBean tarDebBitacoraMovsBean) {
			MensajeTransaccionBean mensaje = null;
			PolizaBean bajaPolizaBean = new PolizaBean();
			bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
			bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
			bajaPolizaBean.setNumErrPol(tarDebBitacoraMovsBean.getCodigoRespuesta() + "");
			bajaPolizaBean.setErrMenPol(tarDebBitacoraMovsBean.getMensajeRespuesta());
			bajaPolizaBean.setDescProceso("TarDebBitacoraMovsDAO.ISOTRX");
			bajaPolizaBean.setPolizaID(tarDebBitacoraMovsBean.getPolizaID());
			MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
			mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
			loggerSAFI.error("Se realiza la baja de poliza contable de isotrx " + mensajeBaja.getDescripcion());

			return mensaje;
		}


		public PolizaDAO getPolizaDAO() {
			return polizaDAO;
		}


		public void setPolizaDAO(PolizaDAO polizaDAO) {
			this.polizaDAO = polizaDAO;
		}

	}

