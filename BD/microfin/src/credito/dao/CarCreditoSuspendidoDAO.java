package credito.dao;

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

import regulatorios.bean.DesagregadoCarteraC0451Bean;

import credito.bean.CarCreditoSuspendidoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CarCreditoSuspendidoDAO extends BaseDAO{
	public CarCreditoSuspendidoDAO(){

	}

	/* ================================================================================================ */
	/* =================== METODO DE CONSULTA DE INFORMACION DEL CREDITO SUSPENDIDO =================== */
	public CarCreditoSuspendidoBean consultaCreditoSuspendido(final CarCreditoSuspendidoBean carCreditoSuspendidoBean,int tipoConsulta) {
		CarCreditoSuspendidoBean carCreditoSuspendido = null;
		try{
			//Query con el Store Procedure
			String query = "CALL CARCREDITOSUSPENDIDOCON(?,?,?,?,?," +
														"?,?,?,?,?);";

			Object[] parametros = {
					Constantes.ENTERO_CERO,
					Utileria.convierteLong(carCreditoSuspendidoBean.getCreditoID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CarCreditoSuspendidoDAO.consultaCreditoSusp",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARCREDITOSUSPENDIDOCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CarCreditoSuspendidoBean carCreditoSuspendidoBean = new CarCreditoSuspendidoBean();

					carCreditoSuspendidoBean.setCarCreditoSuspendidoID(resultSet.getString("CarCreditoSuspendidoID"));
					carCreditoSuspendidoBean.setCreditoID(resultSet.getString("CreditoID"));
					carCreditoSuspendidoBean.setEstatusCredito(resultSet.getString("EstatusCredito"));
					carCreditoSuspendidoBean.setFechaDefuncion(resultSet.getString("FechaDefuncion"));
					carCreditoSuspendidoBean.setFechaSuspencion(resultSet.getString("FechaSuspencion"));
					carCreditoSuspendidoBean.setFolioActa(resultSet.getString("FolioActa"));
					carCreditoSuspendidoBean.setObservDefuncion(resultSet.getString("ObservDefuncion"));
					carCreditoSuspendidoBean.setEstatus(resultSet.getString("Estatus"));
					carCreditoSuspendidoBean.setTotalAdeudo(resultSet.getString("TotalAdeudo"));
					carCreditoSuspendidoBean.setTotalSalCapital(resultSet.getString("TotalSalCapital"));
					carCreditoSuspendidoBean.setTotalSalInteres(resultSet.getString("TotalSalInteres"));
					carCreditoSuspendidoBean.setTotalSalMoratorio(resultSet.getString("TotalSalMoratorio"));
					carCreditoSuspendidoBean.setTotalSalComisiones(resultSet.getString("TotalSalComisiones"));

					return carCreditoSuspendidoBean;
				}
			});
			carCreditoSuspendido = matches.size() > 0 ? (CarCreditoSuspendidoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de informacion de Credito Suspendido", e);
		}
		return carCreditoSuspendido;
	}

	/* ================================================================================================ */

	/* Lista de Creditos la cual se requiere Consultar.*/
	public List listReverCredSuspension(CarCreditoSuspendidoBean carCreditoSuspendidoBean, int tipoLista) {
		List listaReverCreditosBean = null ;
		try{
			// Query con el Store Procedure
			String query = "CALL CARCREDITOSUSPENDIDOLIS(?, ?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					carCreditoSuspendidoBean.getNombreCliente(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosDAO.listCredSuspension",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CARCREDITOSUSPENDIDOLIS(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CarCreditoSuspendidoBean carCreditoSuspendidoBean = new CarCreditoSuspendidoBean();
					carCreditoSuspendidoBean.setCreditoID(resultSet.getString("CreditoID"));
					carCreditoSuspendidoBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					return carCreditoSuspendidoBean;
				}
			});

			listaReverCreditosBean = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos para Guarda Valores", e);
		}
		return listaReverCreditosBean;
	}

	/* ============= METODO DE PRINCIPAL DEL PROCESO DE PASE DEL CREDITO A SUSPENDIDO ================= */
	public MensajeTransaccionBean altaCreditoSuspendido(final CarCreditoSuspendidoBean carCreditoSuspendidoBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call CARCREDITOSUSPENDIDOPRO(?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(carCreditoSuspendidoBean.getCreditoID()));
							sentenciaStore.setString("Par_FechaDefuncion",Utileria.convierteFecha(carCreditoSuspendidoBean.getFechaDefuncion()));
							sentenciaStore.setString("Par_FolioActa",carCreditoSuspendidoBean.getFolioActa());
							sentenciaStore.setString("Par_ObservDefuncion",carCreditoSuspendidoBean.getObservDefuncion());
							sentenciaStore.setDouble("Par_TotalAdeudo",Utileria.convierteDoble(carCreditoSuspendidoBean.getTotalAdeudo()));

							sentenciaStore.setDouble("Par_TotalSalCapital",Utileria.convierteDoble(carCreditoSuspendidoBean.getTotalSalCapital()));
							sentenciaStore.setDouble("Par_TotalSalInteres",Utileria.convierteDoble(carCreditoSuspendidoBean.getTotalSalInteres()));
							sentenciaStore.setDouble("Par_TotalSalMoratorio",Utileria.convierteDoble(carCreditoSuspendidoBean.getTotalSalMoratorio()));
							sentenciaStore.setDouble("Par_TotalSalComisiones",Utileria.convierteDoble(carCreditoSuspendidoBean.getTotalSalComisiones()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "CarCreditoSuspendidoDAO.altaCreditoSusp");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CarCreditoSuspendidoDAO.altaCreditoSusp");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CarCreditoSuspendidoDAO.altaCreditoSusp");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso de Traspaso de Credito a Suspendido" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* ============= METODO DE PRINCIPAL DEL PROCESO DE PASE DEL CREDITO A SUSPENDIDO ================= */
	public MensajeTransaccionBean reversaCreditoSuspendido(final CarCreditoSuspendidoBean carCreditoSuspendidoBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call CARCREDITOSUSPENDIDOREVERPRO(?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(carCreditoSuspendidoBean.getCreditoID()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "CarCreditoSuspendidoDAO.reversaCreditoSuspendido");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CarCreditoSuspendidoDAO.reversaCreditoSuspendido");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CarCreditoSuspendidoDAO.reversaCreditoSuspendido");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso Reversa de Traspaso de Credito a Suspendido" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* ============= METODO DE PRINCIPAL DEL PROCESO DE PASE DEL CREDITO A SUSPENDIDO ================= */
	public List<CarCreditoSuspendidoBean> consultaReporteCreditoSusp(final CarCreditoSuspendidoBean carCreditoSuspendidoBean, int tipoLista){
		String query = "call CARCREDITOSUSPENDIDOREP(?,?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(carCreditoSuspendidoBean.getFechaInicio()),
							Utileria.convierteFecha(carCreditoSuspendidoBean.getFechaFinal()),
							carCreditoSuspendidoBean.getSucursalID(),
							carCreditoSuspendidoBean.getProductoCreditoID(),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"consultaReporteCreditoSusp",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARCREDITOSUSPENDIDOREP(" + Arrays.toString(parametros) +")");
		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CarCreditoSuspendidoBean carCreditoSuspendidoBean = new CarCreditoSuspendidoBean();

					carCreditoSuspendidoBean.setCreditoID(resultSet.getString("CreditoID"));
					carCreditoSuspendidoBean.setClienteID(resultSet.getString("ClienteID"));
					carCreditoSuspendidoBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					carCreditoSuspendidoBean.setProductoCreditoDesc(resultSet.getString("ProductoCred"));
					carCreditoSuspendidoBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					carCreditoSuspendidoBean.setMontoOriginal(resultSet.getString("MontoOriginal"));
					carCreditoSuspendidoBean.setFechaDesembolso(resultSet.getString("FechaDesembolso"));
					carCreditoSuspendidoBean.setFechaSuspencion(resultSet.getString("FechaSuspension"));
					carCreditoSuspendidoBean.setFechaDefuncion(resultSet.getString("FechaDefuncion"));
					carCreditoSuspendidoBean.setFolioActa(resultSet.getString("FolioActa"));
					carCreditoSuspendidoBean.setTotalSalCapital(resultSet.getString("CapitalDet"));
					carCreditoSuspendidoBean.setTotalSalInteres(resultSet.getString("InteresDet"));
					carCreditoSuspendidoBean.setTotalSalMoratorio(resultSet.getString("MoratorioDet"));
					carCreditoSuspendidoBean.setTotalSalComisiones(resultSet.getString("ComisionDet"));
					carCreditoSuspendidoBean.setTotalAdeudo(resultSet.getString("TotalDet"));
					carCreditoSuspendidoBean.setPagos(resultSet.getString("PagosDet"));
					carCreditoSuspendidoBean.setCondonaciones(resultSet.getString("PagosDet"));
					carCreditoSuspendidoBean.setRecuperar(resultSet.getString("RecuperarDet"));
					carCreditoSuspendidoBean.setNotasCargo(resultSet.getString("MontoNotasCargo"));

					return carCreditoSuspendidoBean ;
				}

			});

			return matches;

			}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
		return null;
	}

}
