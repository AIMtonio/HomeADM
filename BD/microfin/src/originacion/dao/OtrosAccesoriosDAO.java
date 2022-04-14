package originacion.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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

import originacion.bean.OtrosAccesoriosBean;

public class OtrosAccesoriosDAO extends BaseDAO {

	java.sql.Date fecha = null;

	public OtrosAccesoriosDAO(){
		super();
	}

	private final static String salidaPantalla = "S";


	/**
	 * Da de alta los accesorios de un crédito
	 * @param otrosAccesoriosBean
	 * @param NumeroTransaccion
	 * @return
	 */
	public MensajeTransaccionBean alta(final OtrosAccesoriosBean otrosAccesoriosBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ACCESORIOSALT(?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_AccesorioID", otrosAccesoriosBean.getAccesorioID());
									sentenciaStore.setString("Par_Descripcion", otrosAccesoriosBean.getDescripcion());
									sentenciaStore.setString("Par_Abreviatura", otrosAccesoriosBean.getAbreviatura());
									sentenciaStore.setString("Par_Prelacion", otrosAccesoriosBean.getPrelacion());
									sentenciaStore.setString("Par_CAT", otrosAccesoriosBean.getAplicaCalCAT());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",NumeroTransaccion);
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OtrosAccesoriosDAO.alta");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .OtrosAccesoriosDAO.alta");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Accesorios: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método que da de alta los Accesorios de un Crédito
	 * @param paisesBean
	 * @return
	 */
	public MensajeTransaccionBean bajaOtrosAccesorios(final OtrosAccesoriosBean otrosAccesoriosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ACCESORIOSBAJ(?,?,?,?,?,"
																	+ "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									//Parametros de Auditoria
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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OtrosAccesoriosDAO.bajaOtrosAccesorios");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .OtrosAccesoriosDAO.bajaOtrosAccesorios");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Accesorios: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**
	 * Método que lista los Accesorios de un crédito
	 * @param paisesBean
	 * @param tipoLista
	 * @return
	 */
	public List<OtrosAccesoriosBean> lista(OtrosAccesoriosBean paisesBean, int tipoLista) {
		List<OtrosAccesoriosBean> lista=new ArrayList<OtrosAccesoriosBean>();
		String query = "CALL ACCESORIOSLIS(?,?,?,?,?,   " +
											 "?,?,?);";
		Object[] parametros = {
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"OtrosAccesoriosDAO.lista",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call ACCESORIOSLIS(" + Arrays.toString(parametros) + ");");
		try{
			List<OtrosAccesoriosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OtrosAccesoriosBean parametro = new OtrosAccesoriosBean();
					parametro.setAccesorioID(resultSet.getString("AccesorioID"));
					parametro.setDescripcion((resultSet.getString("Descripcion")));
					parametro.setAbreviatura(resultSet.getString("NombreCorto"));
					parametro.setPrelacion(resultSet.getString("Prelacion"));
					parametro.setAplicaCalCAT(resultSet.getString("CAT"));
					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en OtrosAccesoriosDAO.lista: "+ex.getMessage());
		}
		return lista;
	}


	public List listaCombo(int tipoLista) {
		List<OtrosAccesoriosBean> listaPrincipal = null;
		try {
			String query = "CALL ACCESORIOSLIS(?,?,?,?,?,   " +
					 "?,?,?);";
			Object[] parametros = {
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,

					"OtrosAccesoriosDAO.lista",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call ACCESORIOSLIS(" + Arrays.toString(parametros) + ")");
			List<OtrosAccesoriosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					OtrosAccesoriosBean bean = new OtrosAccesoriosBean();
					bean.setAccesorioID(resultSet.getString("AccesorioID"));
					bean.setDescripcion(resultSet.getString("NombreCorto"));
					return bean;
				}
			});
			listaPrincipal = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista principal de accesorios.", e);
		}
		return listaPrincipal;
	}


	/**
	 * Método que da de baja y elimina los accesorios de un crédito
	 * @param otrosAccesorios
	 * @param listaDetalle: Lista los accesorios a grabar
	 * @return
	 */
	public MensajeTransaccionBean grabaDetalle(final OtrosAccesoriosBean otrosAccesorios,final List<OtrosAccesoriosBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean = bajaOtrosAccesorios(otrosAccesorios);
					for(OtrosAccesoriosBean detalle : listaDetalle){
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						mensajeBean = alta(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grabar accesorios: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

}