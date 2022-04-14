package pld.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import pld.bean.ParametrosegoperBean;
import pld.bean.SeguimientoOperacionesRepBean;
import soporte.bean.UsuarioBean;

public class ParametrosegoperDAO extends BaseDAO{


	public ParametrosegoperDAO() {
		super();
	}


	public MensajeTransaccionBean alta(final ParametrosegoperBean parametrosegoper,final int  tipoTransaccion ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PARAMETROSEGOPERALT(?,?,?,?,?,  ?,?,?,?,?  ,?,?,?,?,?, ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TipoPersona",parametrosegoper.getTipoPersona());
								sentenciaStore.setInt("Par_TipoIns",Utileria.convierteEntero(parametrosegoper.getTipoInstrumento() ));
								sentenciaStore.setString("Par_NacCliente",parametrosegoper.getNacCliente() );
								sentenciaStore.setDouble("Par_MontoInf",Utileria.convierteDoble(parametrosegoper.getMontoInferior() ));
								sentenciaStore.setInt("Par_MonedaComp",Utileria.convierteEntero(parametrosegoper.getMonedaComp() ));
								sentenciaStore.setDate("Par_FechaIniVig",OperacionesFechas.conversionStrDate( parametrosegoper.getFechaInicioVigencia()));
								sentenciaStore.setInt("Par_NivelSeg",Utileria.convierteEntero(parametrosegoper.getNivelSeguimien() ));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de parametros seguimiento", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificacion(final ParametrosegoperBean parametrosegoper,final int  tipoTransaccion ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PARAMETROSEGOPERMOD(?,?,?,?,?,  ?,?,?,?,?  ,?,?,?,?,?, ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TipoPersona",parametrosegoper.getTipoPersona());
								sentenciaStore.setInt("Par_TipoIns",Utileria.convierteEntero(parametrosegoper.getTipoInstrumento() ));
								sentenciaStore.setString("Par_NacCliente",parametrosegoper.getNacCliente());
								sentenciaStore.setDouble("Par_MontoInf",Utileria.convierteDoble(parametrosegoper.getMontoInferior() ));
								sentenciaStore.setInt("Par_MonedaComp",Utileria.convierteEntero(parametrosegoper.getMonedaComp() ));
								sentenciaStore.setString("Par_FechaIniVig",Constantes.FECHA_VACIA);
								sentenciaStore.setInt("Par_NivelSeg",Utileria.convierteEntero(parametrosegoper.getNivelSeguimien() ));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de operacion de seguimiento", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	//consulta parametros SEGUIMIENTO
			public ParametrosegoperBean consultaPrincipal(ParametrosegoperBean parametrosegoper, int tipoConsulta) {
				//Query con el Store Procedure
				String query = "call PARAMETROSEGOPERCON(?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = { parametrosegoper.getTipoPersona(),
										parametrosegoper.getTipoInstrumento(),
										//parametrosegoper.getNacMoneda(),
										parametrosegoper.getNacCliente(),
										parametrosegoper.getNivelSeguimien(),
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"ParametrosegoperDAO.consultaPrincipal",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO
										};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSEGOPERCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ParametrosegoperBean parametrosegoper = new ParametrosegoperBean();
						parametrosegoper.setNivelSeguimien(String.valueOf(resultSet.getInt("NivelSeguimien")));
						parametrosegoper.setTipoPersona(resultSet.getString("TipoPersona"));
						parametrosegoper.setTipoInstrumento(String.valueOf(resultSet.getInt("TipoInstrumento")));
						parametrosegoper.setNacCliente(resultSet.getString("NacCliente"));
						parametrosegoper.setMontoInferior(String.valueOf(resultSet.getDouble("MontoInferior")));
						parametrosegoper.setMonedaComp(String.valueOf(resultSet.getInt("MonedaComp")));

						return parametrosegoper;
					}
				});
				return matches.size() > 0 ? (ParametrosegoperBean) matches.get(0) : null;
			}




	public List consultaOperacionesSeguimiento(SeguimientoOperacionesRepBean parametrosegoper, int tipoLista) {
		List listaResultado = null;
		try{
			//Query con el Store Procedure
			String query = "call PLDSEGTOOPERREP(" +
					"?,?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					OperacionesFechas.conversionStrDate(parametrosegoper.getFechaInicio()),
					OperacionesFechas.conversionStrDate(parametrosegoper.getFechaFin()),
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"consultaOperaionesSeguimiento",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDSEGTOOPERREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguimientoOperacionesRepBean resultado = new SeguimientoOperacionesRepBean();
					resultado.setFechaDetec(resultSet.getString("FechaDetec"));
					resultado.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					resultado.setNumeroMov(resultSet.getString("NumeroMov"));
					resultado.setFecha(resultSet.getString("Fecha"));
					resultado.setNatMovimiento(resultSet.getString("NatMovimiento"));

					resultado.setCantidadMov(resultSet.getString("CantidadMov"));
					resultado.setDescripcionMov(resultSet.getString("DescripcionMov"));
					resultado.setReferenciaMov(resultSet.getString("ReferenciaMov"));
					resultado.setTipoMovAhoID(resultSet.getString("TipoMovAhoID"));
					resultado.setMonedaID(resultSet.getString("MonedaID"));

					resultado.setClienteID(resultSet.getString("ClienteID"));
					resultado.setTipoPersona(resultSet.getString("TipoPersona"));
					resultado.setNacionCliente(resultSet.getString("NacionCliente"));
					resultado.setTransaccion(resultSet.getString("Transaccion"));
					return resultado;
				}
			});

			listaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de operacion de seguimiento", e);
		}
		return listaResultado;
	}

}
