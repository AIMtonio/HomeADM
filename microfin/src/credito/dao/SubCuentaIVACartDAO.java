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

import credito.bean.SubCuentaIVACartBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SubCuentaIVACartDAO extends BaseDAO{

	public MensajeTransaccionBean alta(final SubCuentaIVACartBean subCuentaIVACart){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean)((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean)((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator(){
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException{
										String query = "CALL SUBCUENTAIVACARTALT("
															+ "?,?,?,?,?,"
															+ "?,?,?,?,?,"
															+ "?,?,?)";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_ConceptoCartID",Utileria.convierteEntero(subCuentaIVACart.getConceptoCartID()));
										sentenciaStore.setDouble("Par_Porcentaje",Utileria.convierteDoble(subCuentaIVACart.getPorcentaje()));
										sentenciaStore.setString("Par_SubCuenta", subCuentaIVACart.getSubCuenta());

										sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.TINYINT);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_UsuarioID", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID", "SubCuentaIVACartDAO.alta");
										sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
										return sentenciaStore;
									}
								},new CallableStatementCallback(){
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException{
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										if(callableStatement.execute()){
											ResultSet resultadoStore = callableStatement.getResultSet();

											resultadoStore.next();
											mensajeTransaccion.setNumero(Integer.valueOf(resultadoStore.getString(1)).intValue());
											mensajeTransaccion.setDescripcion(resultadoStore.getString(2));
										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado.");
										}

										return mensajeTransaccion;
									}
								});
					if(mensajeBean==null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado");
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de SubCuentaIVA");
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modifica(final SubCuentaIVACartBean subCuentaIVACart){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean)((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException{
									String query = "CALL SUBCUENTAIVACARTMOD("
														+ "?,?,?,?,?,"
														+ "?,?,?,?,?,"
														+ "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ConceptoCartID",Utileria.convierteEntero(subCuentaIVACart.getConceptoCartID()));
									sentenciaStore.setDouble("Par_Porcentaje",Utileria.convierteDoble(subCuentaIVACart.getPorcentaje()));
									sentenciaStore.setString("Par_SubCuenta", subCuentaIVACart.getSubCuenta());

									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.TINYINT);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_UsuarioID", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "SubCuentaIVACartDAO.alta");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback(){
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException{
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadoStore = callableStatement.getResultSet();

										resultadoStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadoStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadoStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadoStore.getString(3));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado");
									}

									return mensajeTransaccion;
								}
							});
					if(mensajeBean == null){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado");
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al modificar SubCuentaIVA");
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean baja(final SubCuentaIVACartBean subCuentaIVACart){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean)((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean)((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL SUBCUENTAIVACARTBAJ("
														+ "?,?,?,?,?,"
														+ "?,?,?,?,?,"
														+ "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ConceptoCartID",Utileria.convierteEntero(subCuentaIVACart.getConceptoCartID()));
									sentenciaStore.setDouble("Par_Porcentaje", Utileria.convierteDoble(subCuentaIVACart.getPorcentaje()));

									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.TINYINT);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_UsuarioID", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "SubCuentaIVACartDAO.alta");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException{
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadoStore = callableStatement.getResultSet();

										resultadoStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadoStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadoStore.getString(2));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if(mensajeBean == null){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado.");
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en baja de SubCuentaIVA");
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public SubCuentaIVACartBean consultaPrincipal(SubCuentaIVACartBean subCuentaIVACart,int tipoConsulta){
		String query = "CALL SUBCUENTAIVACARTCON(?,?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {
				Utileria.convierteEntero(subCuentaIVACart.getConceptoCartID()),
				Utileria.convierteDoble(subCuentaIVACart.getPorcentaje()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SubCuentaIVACartDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL SUBCUENTAIVACARTCON("+Arrays.toString(parametros)+")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper(){
			public Object mapRow(ResultSet resultSet, int numRow) throws SQLException{
				SubCuentaIVACartBean subCuentaIVACartBean = new SubCuentaIVACartBean();

				subCuentaIVACartBean.setConceptoCartID(resultSet.getString("ConceptoCartID"));
				subCuentaIVACartBean.setPorcentaje(resultSet.getString("Porcentaje"));
				subCuentaIVACartBean.setSubCuenta(resultSet.getString("SubCuenta"));

				return subCuentaIVACartBean;
			}
		});
		return matches.size()>0 ? (SubCuentaIVACartBean)matches.get(0) : null;
	}
}
