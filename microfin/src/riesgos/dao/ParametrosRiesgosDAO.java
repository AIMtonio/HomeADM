package riesgos.dao;

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
import riesgos.bean.UACIRiesgosBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ParametrosRiesgosDAO extends BaseDAO  {

	/* Método para el registro de Parametros de Riesgos */
	public MensajeTransaccionBean grabaParametrosRiesgos(final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					UACIRiesgosBean riesgosBaja;
					UACIRiesgosBean riesgosAlta;
			        // Lista para dar de baja los parámetros de riesgos registrados
					if(listaBean!=null){
						for(int i=0; i<listaBean.size(); i++){
							/* obtenemos un bean de la lista */
							riesgosBaja = (UACIRiesgosBean)listaBean.get(i);
								mensajeBean = bajaParametrosRiesgos(riesgosBaja);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
					 // Lista para dar de alta los parámetros de riesgos
					if(listaBean!=null){
						for(int i=0; i<listaBean.size(); i++){
							/* obtenemos un bean de la lista */
							riesgosAlta = (UACIRiesgosBean)listaBean.get(i);
								mensajeBean = altaParametrosRiesgos(riesgosAlta);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al grabar parámetros de riesgos", e);
					if(mensajeBean.getNumero()==0){
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

		// Baja de Parámetros de Riesgos
		public MensajeTransaccionBean bajaParametrosRiesgos(final UACIRiesgosBean riesgosBean) {
			transaccionDAO.generaNumeroTransaccion();
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PARAMUACIRIESGOSBAJ(?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ParamRiesgosID",Utileria.convierteEntero(riesgosBean.getParamRiesgosID()));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de parametros de riesgos", e);
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

		// Alta de Parámetros de Riesgos
		public MensajeTransaccionBean altaParametrosRiesgos(final UACIRiesgosBean riesgosBean) {
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
									String query = "call PARAMUACIRIESGOSALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ParamRiesgosID",Utileria.convierteEntero(riesgosBean.getParamRiesgosID()));
									sentenciaStore.setInt("Par_ReferenciaID",Utileria.convierteEntero(riesgosBean.getReferenciaID()));
									sentenciaStore.setString("Par_Descripcion",riesgosBean.getDescripcion());
									sentenciaStore.setDouble("Par_Porcentaje",Utileria.convierteDoble(riesgosBean.getPorcentaje()));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de parámetros de riesgos", e);
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

	// Lista Combo para la pantalla de Parámetros de Riesgos
	public List listaComboParametros(int tipoLista){
		String query = "call PARAMUACIRIESGOSLIS(?,?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"ParametrosRiesgosDAO.listaCombo",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMUACIRIESGOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setParamRiesgosID(resultSet.getString(1));
				bean.setDescripcion(resultSet.getString(2));
				return bean;
			}
		});

		return matches;
	}

	// Lista Grid de la pantalla Parametros de Riesgos
	public List listaGridParametrosRiesgos(UACIRiesgosBean riesgosBean,int tipoLista){
		String query = "call PARAMUACIRIESGOSLIS(?,?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {
					Utileria.convierteEntero(riesgosBean.getParamRiesgosID()),
					Constantes.STRING_VACIO,
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"ParametrosRiesgosDAO.listaGrid",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMUACIRIESGOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setParamRiesgosID(resultSet.getString(1));
				bean.setDescripcion(resultSet.getString(2));
				bean.setDinamico(resultSet.getString(3));
				bean.setPorcentaje(resultSet.getString(4));
				bean.setReferenciaID(resultSet.getString(5));

				return bean;
			}
		});

		return matches;
	}
}
