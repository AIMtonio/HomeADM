package aportaciones.dao;

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

import aportaciones.bean.SubCtaTiProAportacionBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;

public class SubCtaTiProAportacionDAO extends BaseDAO{

	public SubCtaTiProAportacionDAO() {
		super();
	}

	/*Metodo Para registrar subctas de tipos de APORTACIONES*/

	public MensajeTransaccionBean alta(final SubCtaTiProAportacionBean subCtaTiProAportacion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SUBCTATIPROAPORTACIONALT(?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConceptoAportacionID",Utileria.convierteEntero( subCtaTiProAportacion.getConceptoAportacionID()));
							sentenciaStore.setInt("Par_TipoAportacionID", Utileria.convierteEntero(subCtaTiProAportacion.getTipoAportacionID()));
							sentenciaStore.setString("Par_SubCuenta", subCtaTiProAportacion.getSubCuenta());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTATIPROAPORTACIONALT(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ning??n Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ning??n Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Alta Subcuentas de tipos de aportaciones.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}


	/*Metodo Para modificar subctas de tipos de APORTACIONES*/

	public MensajeTransaccionBean modifica(final SubCtaTiProAportacionBean subCtaTiProAportacion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SUBCTATIPROAPORTACIONMOD(?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConceptoAportacionID",Utileria.convierteEntero( subCtaTiProAportacion.getConceptoAportacionID()));
							sentenciaStore.setInt("Par_TipoAportacionID", Utileria.convierteEntero(subCtaTiProAportacion.getTipoAportacionID()));
							sentenciaStore.setString("Par_SubCuenta", subCtaTiProAportacion.getSubCuenta());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTATIPROAPORTACIONMOD(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ning??n Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ning??n Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificacion de Subcuentas de tipos de aportaciones.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}


	/*Metodo Para eliminar subctas de tipos de APORTACIONES*/

	public MensajeTransaccionBean baja(final SubCtaTiProAportacionBean subCtaTiProAportacion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SUBCTATIPROAPORTACIONBAJ(?,?,  ?,?,?,  ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConceptoAportacionID",Utileria.convierteEntero( subCtaTiProAportacion.getConceptoAportacionID()));
							sentenciaStore.setInt("Par_TipoAportacionID", Utileria.convierteEntero(subCtaTiProAportacion.getTipoAportacionID()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTATIPROAPORTACIONBAJ(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ning??n Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ning??n Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al Eliminar las Subcuentas de tipos de aportaciones.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}


	/*Metodo Para consultar subctas de tipos de APORTACIONES*/
	public SubCtaTiProAportacionBean consultaPrincipal(SubCtaTiProAportacionBean subCtaTiProAportacion, int tipoConsulta){
		String query = "call SUBCTATIPROAPORTACIONCON(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
				subCtaTiProAportacion.getConceptoAportacionID(),
				subCtaTiProAportacion.getTipoAportacionID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SubCtaTiProAportacionDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTATIPROAPORTACIONCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SubCtaTiProAportacionBean subCtaTiProApor = new SubCtaTiProAportacionBean();
				subCtaTiProApor.setConceptoAportacionID(resultSet.getString(1));
				subCtaTiProApor.setTipoAportacionID(resultSet.getString(2));
				subCtaTiProApor.setSubCuenta(resultSet.getString(3));
				return subCtaTiProApor;
			}
		});
		return matches.size() > 0 ? (SubCtaTiProAportacionBean) matches.get(0) : null;
	}

}
