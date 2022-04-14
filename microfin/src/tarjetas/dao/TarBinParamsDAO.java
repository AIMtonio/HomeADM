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

import tarjetas.bean.TarBinParamsBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class TarBinParamsDAO extends BaseDAO{

	public TarBinParamsDAO(){
		super();
	}

	/*Alta de configuración de parametros del BIN*/
	public MensajeTransaccionBean altaParametrosBIN(final TarBinParamsBean tarBinParamsBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARBINPARAMSALT(?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_TarBinParamsID",tarBinParamsBean.getTarBinParamsID());
								sentenciaStore.setString("Par_NumBIN",tarBinParamsBean.getNumBIN());
								sentenciaStore.setString("Par_EsSubBin",tarBinParamsBean.getEsSubBin());
								sentenciaStore.setString("Par_EsBinMulEmp",tarBinParamsBean.getEsBinMulEmp());
								sentenciaStore.setString("Par_CatMarcaTarjetaID",tarBinParamsBean.getCatMarcaTarjetaID());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la alta de ParametrosBIN", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*Alta de configuración de parametros del BIN*/
	public MensajeTransaccionBean altaParametrosBINBDPrincipal(final TarBinParamsBean tarBinParamsBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARBINPARAMSALT(?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_TarBinParamsID",tarBinParamsBean.getTarBinParamsID());
								sentenciaStore.setString("Par_NumBIN",tarBinParamsBean.getNumBIN());
								sentenciaStore.setString("Par_EsSubBin",tarBinParamsBean.getEsSubBin());
								sentenciaStore.setString("Par_EsBinMulEmp",tarBinParamsBean.getEsBinMulEmp());
								sentenciaStore.setString("Par_CatMarcaTarjetaID",tarBinParamsBean.getCatMarcaTarjetaID());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-BDPRINCIPAL-"+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
						throw new Exception("Fallo. El Procedimiento a BDPrincipal no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error("BDPrincipal"+"-"+"Error en la alta de ParametrosBIN", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*modificación de configuración de parametros del BIN*/
	public MensajeTransaccionBean modificarParametrosBIN(final TarBinParamsBean tarBinParamsBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARBINPARAMSMOD(?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_TarBinParamsID",tarBinParamsBean.getTarBinParamsID());
								sentenciaStore.setString("Par_NumBIN",tarBinParamsBean.getNumBIN());
								sentenciaStore.setString("Par_EsSubBin",tarBinParamsBean.getEsSubBin());
								sentenciaStore.setString("Par_EsBinMulEmp",tarBinParamsBean.getEsBinMulEmp());
								sentenciaStore.setString("Par_CatMarcaTarjetaID",tarBinParamsBean.getCatMarcaTarjetaID());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la modificación de ParametrosBIN", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*modificación de configuración de parametros del BIN-BD-Principal*/
	public MensajeTransaccionBean modificarParametrosBINBDPrincipal(final TarBinParamsBean tarBinParamsBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARBINPARAMSMOD(?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_TarBinParamsID",tarBinParamsBean.getTarBinParamsID());
								sentenciaStore.setString("Par_NumBIN",tarBinParamsBean.getNumBIN());
								sentenciaStore.setString("Par_EsSubBin",tarBinParamsBean.getEsSubBin());
								sentenciaStore.setString("Par_EsBinMulEmp",tarBinParamsBean.getEsBinMulEmp());
								sentenciaStore.setString("Par_CatMarcaTarjetaID",tarBinParamsBean.getCatMarcaTarjetaID());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info("BDPrincipal"+"-"+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
					e.printStackTrace();
					loggerSAFI.error("BDPrincipal"+"-"+"Error en la modificación de ParametrosBIN", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Consulta parametros BIN - BDPrincipal
	public TarBinParamsBean consultaParametroBINBDPrincipal(int tipoConsulta, TarBinParamsBean tarBinParamsBean){

			String query = "call TARBINPARAMSCON(?, ?,   ?,?,?,?,?,?,?);";

					Object[] parametros = {
							tarBinParamsBean.getTarBinParamsID(),
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"TarBinParamsDAO.consultaParametroBIN",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO

							};
					loggerSAFI.info("BDPrincipal"+"-"+"call TARBINPARAMSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

							TarBinParamsBean tarBinParamsBeanResp = new TarBinParamsBean();
							tarBinParamsBeanResp.setTarBinParamsID(resultSet.getString("TarBinParamsID"));
							tarBinParamsBeanResp.setNumBIN(resultSet.getString("NumBIN"));
							tarBinParamsBeanResp.setEsSubBin(resultSet.getString("EsSubBin"));
							tarBinParamsBeanResp.setEsBinMulEmp(resultSet.getString("EsBinMulEmp"));
							tarBinParamsBeanResp.setCatMarcaTarjetaID(resultSet.getString("CatMarcaTarjetaID"));
							return tarBinParamsBeanResp;

						}
					});

			return matches.size() > 0 ? (TarBinParamsBean) matches.get(0) : null;
		}

		// Lista ayuda parametros BIN - BDPrincipal
		public List listaParamsBINsBDPrincipal(int tipoLista, TarBinParamsBean tarBinParamsBean){
				List lista = null;
				try{

						String query = "call TARBINPARAMSLIS(?,?, ?,?,?,?,?,?,?);";
						Object[] parametros = {
									tarBinParamsBean.getTarBinParamsID(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"TarBinParamsDAO.listaParamsBINs",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};

						loggerSAFI.info("BDPrincipal"+"-"+"call TARBINPARAMSLIS(" + Arrays.toString(parametros) + ")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								TarBinParamsBean tarBinParamsBeanResp = new TarBinParamsBean();
								tarBinParamsBeanResp.setTarBinParamsID(resultSet.getString("TarBinParamsID"));
								tarBinParamsBeanResp.setNumBIN(resultSet.getString("NumBIN"));
								tarBinParamsBeanResp.setEsSubBin(resultSet.getString("EsSubBin"));
								tarBinParamsBeanResp.setEsBinMulEmp(resultSet.getString("EsBinMulEmp"));
								tarBinParamsBeanResp.setDescMarcaTar(resultSet.getString("DescMarcaTar"));

								return tarBinParamsBeanResp;
							}
						});
						lista= matches;
					}catch(Exception e){
						e.printStackTrace();
						loggerSAFI.error("BDPrincipal"+"-"+"Error en Lista de ParametrosBINs ", e);

					}
					return lista;
			}
		//metodo de llamado para el Grid - BDPrincipal
		public List listaParamsBINsGridBDPrincipal(int tipoLista, TarBinParamsBean tarBinParamsBean){
			List lista = null;
			try{

					String query = "call TARBINPARAMSLIS(?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
								tarBinParamsBean.getDescripcion(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TarBinParamsDAO.listaParamsBINs",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};

					loggerSAFI.info("BDPrincipal"+"-"+"call TARBINPARAMSLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							TarBinParamsBean tarBinParamsBeanResp = new TarBinParamsBean();
							tarBinParamsBeanResp.setTarBinParamsID(resultSet.getString("TarBinParamsID"));
							tarBinParamsBeanResp.setNumBIN(resultSet.getString("NumBIN"));
							tarBinParamsBeanResp.setEsSubBin(resultSet.getString("SUBBIN"));
							tarBinParamsBeanResp.setEsBinMulEmp(resultSet.getString("BINMULTIBASE"));
							tarBinParamsBeanResp.setDescMarcaTar(resultSet.getString("DescMarcaTar"));

							return tarBinParamsBeanResp;
						}
					});
					lista= matches;
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error("BDPrincipal"+"-"+"Error en Lista de ParametrosBINs ", e);

				}
				return lista;
		}

		// Lista catalogo de Marca
		public List listaCatMarcaTar(int tipoConsulta, TarBinParamsBean tarBinParamsBean){
			List lista = null;
			try{
				String query = "call CATMARCATARJETALIS(?, ?,   ?,?,?,?,?,?,?);";

					Object[] parametros = {
							Constantes.ENTERO_CERO,
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"TarBinParamsDAO.listaCatMarcaTar",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO

							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATMARCATARJETALIS(" + Arrays.toString(parametros) +")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						TarBinParamsBean tarBinParamsBeanResp = new TarBinParamsBean();
						tarBinParamsBeanResp.setCatMarcaTarjetaID(resultSet.getString("CatMarcaTarjetaID"));
						tarBinParamsBeanResp.setDescMarcaTar(resultSet.getString("Descripcion"));

						return tarBinParamsBeanResp;
					}
				});
				lista= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de ParametrosBINs ", e);

			}
			return lista;
		}
}
