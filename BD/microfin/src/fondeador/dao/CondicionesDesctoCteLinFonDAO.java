package fondeador.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import fondeador.bean.CondicionesDesctoCteLinFonBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

public class CondicionesDesctoCteLinFonDAO extends BaseDAO{

	public CondicionesDesctoCteLinFonDAO() {
		super();
	}


	// ------------------ Transacciones ------------------------------------------


	/* Alta de condiciones de descuenta del  Cliente */
	public MensajeTransaccionBean alta(final CondicionesDesctoCteLinFonBean condicionesDesctoCteLinFonBean) {
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
								String query = "call LINFONCONDCTEALT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(condicionesDesctoCteLinFonBean.getLineaFondeoIDCte()));
								sentenciaStore.setString("Par_Sexo",condicionesDesctoCteLinFonBean.getSexo());
								sentenciaStore.setString("Par_EstadoCivil",condicionesDesctoCteLinFonBean.getEstadoCivil());
								sentenciaStore.setDouble("Par_MontoMinimo",Utileria.convierteDoble(condicionesDesctoCteLinFonBean.getMontoMinimo()));
								sentenciaStore.setDouble("Par_MontoMaximo",Utileria.convierteDoble(condicionesDesctoCteLinFonBean.getMontoMaximo()));

								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(condicionesDesctoCteLinFonBean.getMonedaID()));
								sentenciaStore.setInt("Par_DiasGraIngCre",Utileria.convierteEntero(condicionesDesctoCteLinFonBean.getDiasGraIngCre()));
								sentenciaStore.setString("Par_ProductosCre",condicionesDesctoCteLinFonBean.getProductosCre());
								sentenciaStore.setInt("Par_MaxDiasMora",Utileria.convierteEntero(condicionesDesctoCteLinFonBean.getMaxDiasMora()));
								sentenciaStore.setString("Par_Clasificacion",condicionesDesctoCteLinFonBean.getClasificacion());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CondicionesDesctoEdoLinFonDAO.alta");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " CondicionesDesctoEdoLinFonDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Condiciones de linea de Fondeo" + e);
						e.printStackTrace();
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

	/* Alta de condiciones de descuenta del  Cliente */
	public MensajeTransaccionBean baja(final CondicionesDesctoCteLinFonBean condicionesDesctoCteLinFonBean) {
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
								String query = "call LINFONCONDCTEBAJ(" +
									"?,?,?,?," +
									"?,?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(condicionesDesctoCteLinFonBean.getLineaFondeoIDCte()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CondicionesDesctoEdoLinFonDAO.baja");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " CondicionesDesctoEdoLinFonDAO.baja");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de Condiciones de linea de Fondeo" + e);
						e.printStackTrace();
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

	/* Alta de condiciones de descuenta del  Cliente */
	public MensajeTransaccionBean modificacion(final CondicionesDesctoCteLinFonBean condicionesDesctoCteLinFonBean) {
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
								String query = "call LINFONCONDCTEMOD(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(condicionesDesctoCteLinFonBean.getLineaFondeoIDCte()));
								sentenciaStore.setString("Par_Sexo",condicionesDesctoCteLinFonBean.getSexo());
								sentenciaStore.setString("Par_EstadoCivil",condicionesDesctoCteLinFonBean.getEstadoCivil());
								sentenciaStore.setDouble("Par_MontoMinimo",Utileria.convierteDoble(condicionesDesctoCteLinFonBean.getMontoMinimo()));
								sentenciaStore.setDouble("Par_MontoMaximo",Utileria.convierteDoble(condicionesDesctoCteLinFonBean.getMontoMaximo()));

								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(condicionesDesctoCteLinFonBean.getMonedaID()));
								sentenciaStore.setInt("Par_DiasGraIngCre",Utileria.convierteEntero(condicionesDesctoCteLinFonBean.getDiasGraIngCre()));
								sentenciaStore.setString("Par_ProductosCre",condicionesDesctoCteLinFonBean.getProductosCre());
								sentenciaStore.setInt("Par_MaxDiasMora",Utileria.convierteEntero(condicionesDesctoCteLinFonBean.getMaxDiasMora()));
								sentenciaStore.setString("Par_Clasificacion",condicionesDesctoCteLinFonBean.getClasificacion());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CondicionesDesctoEdoLinFonDAO.mod");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " CondicionesDesctoEdoLinFonDAO.mod");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Condiciones de linea de Fondeo" + e);
						e.printStackTrace();
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

	/* Alta de las condiciones de descuento para estados, municipios, localidades de credito grid*/
	public MensajeTransaccionBean altaCondCte(final CondicionesDesctoCteLinFonBean condicionesDesctoCteLinFonBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean=baja(condicionesDesctoCteLinFonBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}
					mensajeBean=alta(condicionesDesctoCteLinFonBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Condiciones de linea de Fondeo" + e);
					e.printStackTrace();
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
	/* Consuta LineaFondeador por Llave Foranea*/
	public CondicionesDesctoCteLinFonBean consultaPrincipal(CondicionesDesctoCteLinFonBean lineaFond, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call LINFONCONDCTECON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(lineaFond.getLineaFondeoIDCte()),
				lineaFond.getSexo(),
				lineaFond.getEstadoCivil(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CondicionesDesctoCteLinFonDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINFONCONDCTECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CondicionesDesctoCteLinFonBean lineaFond = new CondicionesDesctoCteLinFonBean();
				lineaFond.setLineaFondeoIDCte(String.valueOf(resultSet.getInt("LineaFondeoID")));
				lineaFond.setSexo(resultSet.getString("Sexo"));
				lineaFond.setEstadoCivil(resultSet.getString("EstadoCivil"));
				lineaFond.setMontoMinimo(resultSet.getString("MontoMinimo"));
				lineaFond.setMontoMaximo(resultSet.getString("MontoMaximo"));
				lineaFond.setMonedaID(resultSet.getString("MonedaID"));
				lineaFond.setDiasGraIngCre(resultSet.getString("DiasGraIngCre"));
				lineaFond.setProductosCre(resultSet.getString("ProductosCre"));
				lineaFond.setMaxDiasMora(resultSet.getString("MaxDiasMora"));
				lineaFond.setClasificacion(resultSet.getString("Clasificacion"));

				return lineaFond;
			}
		});
		return matches.size() > 0 ? (CondicionesDesctoCteLinFonBean) matches.get(0) : null;
	}

	/* Consuta LineaFondeador por Llave Foranea*/
	public CondicionesDesctoCteLinFonBean consultaForanea(CondicionesDesctoCteLinFonBean lineaFond, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call LINFONCONDCTECON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(lineaFond.getLineaFondeoIDCte()),
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CondicionesDesctoCteLinFonDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINFONCONDCTECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CondicionesDesctoCteLinFonBean lineaFond = new CondicionesDesctoCteLinFonBean();
				lineaFond.setLineaFondeoIDCte(String.valueOf(resultSet.getInt("LineaFondeoID")));
				lineaFond.setSexo(resultSet.getString("Sexo"));
				lineaFond.setEstadoCivil(resultSet.getString("EstadoCivil"));
				lineaFond.setMontoMinimo(resultSet.getString("MontoMinimo"));
				lineaFond.setMontoMaximo(resultSet.getString("MontoMaximo"));
				lineaFond.setMonedaID(resultSet.getString("MonedaID"));
				lineaFond.setDiasGraIngCre(resultSet.getString("DiasGraIngCre"));
				lineaFond.setProductosCre(resultSet.getString("ProductosCre"));
				lineaFond.setMaxDiasMora(resultSet.getString("MaxDiasMora"));
				lineaFond.setClasificacion(resultSet.getString("Clasificacion"));

				return lineaFond;
			}
		});
		return matches.size() > 0 ? (CondicionesDesctoCteLinFonBean) matches.get(0) : null;
	}

}

