package guardaValores.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import guardaValores.bean.CatalogoAlmacenesBean;
import herramientas.Constantes;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

public class CatalogoAlmacenesDAO extends BaseDAO {

	public CatalogoAlmacenesDAO(){
		super();
	}

	// Alta de Almacenes de Guarda Valores
	public MensajeTransaccionBean altaCatalogoAlmacenes(final CatalogoAlmacenesBean catalogoAlmacenesBean) {
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
								String query = "CALL ALMACENESALT(?,?,?,"
															    +"?,?,?,"
															    +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_NombreAlmacen", catalogoAlmacenesBean.getNombreAlmacen());
								sentenciaStore.setString("Par_Estatus", catalogoAlmacenesBean.getEstatus());
								sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(catalogoAlmacenesBean.getSucursalID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de Almacen en Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}//Fin Alta de Almacenes de Guarda Valores

	// Modificacion de Almacenes de Guarda Valores
	public MensajeTransaccionBean modificaCatalogoAlmacenes(final CatalogoAlmacenesBean catalogoAlmacenesBean) {
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
								String query = "CALL ALMACENESMOD(?,?,?,?,"
																+"?,?,?,"
																+"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_AlmacenID", Utileria.convierteLong(catalogoAlmacenesBean.getAlmacenID()));
								sentenciaStore.setString("Par_NombreAlmacen", catalogoAlmacenesBean.getNombreAlmacen());
								sentenciaStore.setString("Par_Estatus", catalogoAlmacenesBean.getEstatus());
								sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(catalogoAlmacenesBean.getSucursalID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});

					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Modificación del Almacen en Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// Fin  Modificacion de Almacenes de Guarda Valores

	// Consulta Principal
	public CatalogoAlmacenesBean consultaPrincipal(final CatalogoAlmacenesBean catalogoAlmacenesBean, final int tipoConsulta) {

		CatalogoAlmacenesBean catalogoAlmacenes = null;
		//Query con el Store Procedure
		try{
			String query = "CALL ALMACENESCON(?,?,?,"
										    +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catalogoAlmacenesBean.getAlmacenID()),
				Utileria.convierteEntero(catalogoAlmacenesBean.getSucursalID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatalogoAlmacenesDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL ALMACENESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoAlmacenesBean catalogo = new CatalogoAlmacenesBean();

					catalogo.setAlmacenID(resultSet.getString("AlmacenID"));
					catalogo.setNombreAlmacen(resultSet.getString("NombreAlmacen"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					catalogo.setSucursalID(resultSet.getString("SucursalID"));
					return catalogo;
				}
			});

			catalogoAlmacenes = matches.size() > 0 ? (CatalogoAlmacenesBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Almacenes en Guarda Valores ", exception);
			catalogoAlmacenes = null;
		}

		return catalogoAlmacenes;
	}

	// Consulta Almacenes Activos
	public CatalogoAlmacenesBean consultaAlmacenActSuc(final CatalogoAlmacenesBean catalogoAlmacenesBean, final int tipoConsulta) {

		CatalogoAlmacenesBean catalogoAlmacenes = null;
		//Query con el Store Procedure
		try{
			String query = "CALL ALMACENESCON(?,?,?,"
										    +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(catalogoAlmacenesBean.getAlmacenID()),
				Utileria.convierteEntero(catalogoAlmacenesBean.getSucursalID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatalogoAlmacenesDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL ALMACENESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoAlmacenesBean catalogo = new CatalogoAlmacenesBean();

					catalogo.setAlmacenID(resultSet.getString("AlmacenID"));
					catalogo.setNombreAlmacen(resultSet.getString("NombreAlmacen"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					catalogo.setSucursalID(resultSet.getString("SucursalID"));
					return catalogo;
				}
			});

			catalogoAlmacenes = matches.size() > 0 ? (CatalogoAlmacenesBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Almacenes Activos por Sucursal en Guarda Valores ", exception);
			catalogoAlmacenes = null;
		}

		return catalogoAlmacenes;
	}

	// Lista Almacenes
	public List<CatalogoAlmacenesBean> listaPrincipal(final CatalogoAlmacenesBean catalogoAlmacenesBean, final int tipoLista) {

		List<CatalogoAlmacenesBean> listaAlmacenes = null;
		//Query con el Store Procedure
		try{
			String query = "CALL ALMACENESLIS(?,?,?,?,"
										    +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catalogoAlmacenesBean.getAlmacenID()),
				Utileria.convierteEntero(catalogoAlmacenesBean.getSucursalID()),
				catalogoAlmacenesBean.getNombreAlmacen(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatalogoAlmacenesDAO.listaAlmacenes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL ALMACENESLIS(" + Arrays.toString(parametros) + ")");
			List<CatalogoAlmacenesBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoAlmacenesBean  catalogo = new CatalogoAlmacenesBean();

					catalogo.setAlmacenID(resultSet.getString("AlmacenID"));
					catalogo.setNombreAlmacen(resultSet.getString("NombreAlmacen"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					catalogo.setSucursalID(resultSet.getString("SucursalID"));
					return catalogo;
				}
			});

			listaAlmacenes = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Almacenes en  Guarda Valores", exception);
			listaAlmacenes = null;
		}

		return listaAlmacenes;
	}

	// Lista Almacenes Activos
	public List<CatalogoAlmacenesBean> listaAlmacenesActivo(final CatalogoAlmacenesBean catalogoAlmacenesBean, final int tipoLista) {

		List<CatalogoAlmacenesBean> listaAlmacenes = null;
		//Query con el Store Procedure
		try{
			String query = "CALL ALMACENESLIS(?,?,?,?,"
										    +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catalogoAlmacenesBean.getAlmacenID()),
				Utileria.convierteEntero(catalogoAlmacenesBean.getSucursalID()),
				catalogoAlmacenesBean.getNombreAlmacen(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatalogoAlmacenesDAO.listaAlmacenesActivo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL ALMACENESLIS(" + Arrays.toString(parametros) + ")");
			List<CatalogoAlmacenesBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoAlmacenesBean  catalogo = new CatalogoAlmacenesBean();

					catalogo.setAlmacenID(resultSet.getString("AlmacenID"));
					catalogo.setNombreAlmacen(resultSet.getString("NombreAlmacen"));
					catalogo.setSucursalID(resultSet.getString("SucursalID"));
					return catalogo;
				}
			});

			listaAlmacenes = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Almacenes Activos en Guarda Valores", exception);
			listaAlmacenes = null;
		}

		return listaAlmacenes;
	}

}
